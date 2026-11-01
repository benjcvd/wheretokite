"""Five forecast setups on the Spanish and French spots, against official stations (WHE-72).

Past forecasts from Open-Meteo's Previous Runs API: the forecast made the day before (lead 1,
what riders plan on) and the day itself (lead 0). AROME's day-ahead archive starts on
8 Aug 2026, so that's the earliest start.

Setups (per hour; "mean" = mean speed of the members available that hour, vector-mean
direction, as the app's Blend.hour does):
  1 Baseline   best_match on the sea cell (what main ships today)
  2 AROME      AROME 1.3 beach cell, else AROME 2.5 beach cell, else ICON beach cell
  3 Option 1   mean AROME 1.3 + ICON beach cell, ECMWF sea cell (WHE-61, built, not shipped)
  4 Sea capped mean of the same three on their sea cell, unless that cell's centre is more
               than 1.5 km from the pin: then their nearest cell
  5 Weighted   Option 1's members, weights per model and region fitted on alternate weeks
               (two folds: weeks with an even ISO number train the odd ones and back), so no
               day is scored by weights fitted on it
Forecast point study (AROME 1.3 only): beach cell, nearest cell at the pin, at 500 m and
1 km out along the beach normal, and the sea cell.

    python3 tools/backtest/esfr_backtest.py --pairs tools/backtest/pairs_es.json > /tmp/es.md

Truth classes: "a" station ≤ 1.5 km from the pin (main), "c" further (weak, reported apart).
"""
import argparse
import datetime
import itertools
import json
import math
import os
import random
import statistics
import sys
import time
import urllib.error
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import fetch, months, angle  # noqa: E402
from review import to_10m, usable, best2h  # noqa: E402
from stations import observations, km, load_spots  # noqa: E402

HD, A25, ICON, EC, BM = "meteofrance_arome_france_hd", "meteofrance_arome_france", "icon_seamless", "ecmwf_ifs025", "best_match"
REQUESTS = {   # cell key -> (cell_selection, offshore metres, models)
    "land": ("land", 0, [HD, A25, ICON]),
    "sea": ("sea", 0, [BM, HD, ICON, EC]),
    "nearest": ("nearest", 0, [HD, ICON, EC]),
    "off500": ("nearest", 500, [HD]),
    "off1000": ("nearest", 1000, [HD]),
}
LEADS = {0: "", 1: "_previous_day1"}
DAY_UTC = range(7, 18)
CAP_KM = 1.5
GO_KN = 12
SETUPS = ["1 Baseline: best match, sea cell", "2 AROME only, beach cell", "3 Option 1: AROME+ICON beach, ECMWF sea",
          "4 All three on the sea cell, capped at 1.5 km", "5 Skill-weighted (held-out weeks)"]
POINTS = ["AROME 1.3 beach cell", "AROME 1.3 nearest cell at the pin", "AROME 1.3 at 500 m out",
          "AROME 1.3 at 1 km out", "AROME 1.3 sea cell"]
POINT_KEYS = dict(zip(POINTS, ["land", "nearest", "off500", "off1000", "sea"]))
REGIONS = {
    "Catalunya": "Catalonia", "Comunitat Valenciana": "Valencia/Murcia", "Murcia": "Valencia/Murcia",
    "Andalucía": "Andalusia/Tarifa", "Canarias": "Canaries", "Illes Balears": "Balearics",
    "Galicia": "Galicia/Cantabrian", "Asturias": "Galicia/Cantabrian", "Cantabria": "Galicia/Cantabrian",
    "País Vasco": "Galicia/Cantabrian", "Euskadi": "Galicia/Cantabrian",
    "Languedoc": "Languedoc/Roussillon", "Roussillon": "Languedoc/Roussillon",
    "Camargue": "Provence/Corsica", "Provence": "Provence/Corsica", "Var": "Provence/Corsica",
    "Côte d'Azur": "Provence/Corsica", "Corse": "Provence/Corsica",
    "Pays basque": "French Atlantic", "Landes": "French Atlantic", "Gironde": "French Atlantic",
    "Charente-Maritime": "French Atlantic", "Pays de la Loire": "French Atlantic",
    "Bretagne": "Brittany", "Normandie": "Channel", "Côte d'Opale": "Channel", "Baie de Somme": "Channel",
}


# MARK: Open-Meteo, cached, paced for the free quota

def om(url, body):
    import hashlib
    from model_backtest import CACHE
    for attempt in range(30):
        try:
            return json.loads(fetch(url, body))
        except json.JSONDecodeError:   # truncated or empty answer was cached: drop it, retry
            os.remove(os.path.join(CACHE, hashlib.sha1((url + (body or "")).encode()).hexdigest()))
            time.sleep(5)
        except urllib.error.HTTPError as e:
            if e.code == 400:
                return {"error": e.read()[:200].decode(errors="replace")}   # e.g. point outside a model's domain
            if e.code != 429:
                raise
            print("Open-Meteo rate limit, waiting 70 s", file=sys.stderr)
            time.sleep(70)
    sys.exit("Open-Meteo quota exhausted")


def offset(lat, lon, bearing, metres):
    if not metres:
        return lat, lon
    b = math.radians(bearing)
    dlat = metres * math.cos(b) / 111320
    dlon = metres * math.sin(b) / (111320 * math.cos(math.radians(lat)))
    return lat + dlat, lon + dlon


def forecasts(spot, start, end):
    """(model, cell key) -> lead -> hour -> (kn, dir); and (model, cell key) -> cell centre."""
    fc, where = {}, {}
    for key, (sel, metres, models) in REQUESTS.items():
        lat, lon = offset(spot["latitude"], spot["longitude"], spot["seaFacingDeg"], metres)
        vars_ = [f"{v}{s}" for v in ("wind_speed_10m", "wind_direction_10m") for s in LEADS.values()]
        for m in models:
            fc[(m, key)] = {l: {} for l in LEADS}
        for lo, hi in months(start, end):
            groups = [models]
            while groups:
                ms = groups.pop()
                j = om("https://previous-runs-api.open-meteo.com/v1/forecast", urllib.parse.urlencode({
                    "latitude": f"{lat:.5f}", "longitude": f"{lon:.5f}", "hourly": ",".join(vars_),
                    "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
                    "models": ",".join(ms), "cell_selection": sel}))
                if "hourly" not in j:
                    if len(ms) > 1:      # one model outside its domain fails the whole request: split
                        groups += [[m] for m in ms]
                    continue
                h = j["hourly"]
                if len(ms) > 1 and not all(f"wind_speed_10m_{m}" in h for m in ms):
                    groups += [[m] for m in ms]   # models out of range were dropped, labels too
                    continue
                hrs = [t[:13] for t in h["time"]]
                for m in ms:
                    tag = f"_{m}" if len(ms) > 1 else ""
                    for lead, suf in LEADS.items():
                        sp = h.get(f"wind_speed_10m{suf}{tag}") or []
                        d = h.get(f"wind_direction_10m{suf}{tag}") or []
                        for i, t in enumerate(hrs):
                            if i < len(sp) and sp[i] is not None and d[i] is not None and int(t[11:13]) in DAY_UTC:
                                fc[(m, key)][lead][t] = (sp[i], d[i])
        # Where each model's cell actually is: one tiny request per model (one call each).
        for m in models:
            if m == BM:
                continue
            j = om("https://api.open-meteo.com/v1/forecast", urllib.parse.urlencode({
                "latitude": f"{lat:.5f}", "longitude": f"{lon:.5f}", "hourly": "wind_speed_10m", "forecast_days": 1,
                "models": m, "cell_selection": sel}))
            if "error" not in j:
                where[(m, key)] = (j.get("latitude"), j.get("longitude"))
    return fc, where


def vmean(vals, weights=None):
    weights = weights or [1] * len(vals)
    w = sum(weights)
    sp = sum(s * k for (s, _), k in zip(vals, weights)) / w
    u = sum(s * k * math.sin(math.radians(d)) for (s, d), k in zip(vals, weights))
    v = sum(s * k * math.cos(math.radians(d)) for (s, d), k in zip(vals, weights))
    return sp, math.degrees(math.atan2(u, v)) % 360


def member(fc, m, key, lead, h):
    return fc.get((m, key), {}).get(lead, {}).get(h)


def setup_hour(name, fc, dist, lead, h, weights=None):
    if name.startswith("1"):
        return member(fc, BM, "sea", lead, h)
    if name.startswith("2"):
        for m in (HD, A25, ICON):
            v = member(fc, m, "land", lead, h)
            if v:
                return v
        return None
    trio = [(HD, "land"), (ICON, "land"), (EC, "sea")]
    if name.startswith("4"):
        trio = [(m, "sea" if (dist.get((m, "sea")) or 99) <= CAP_KM else "nearest") for m in (HD, ICON, EC)]
    vals, ws = [], []
    for m, key in trio:
        v = member(fc, m, key, lead, h)
        if v:
            vals.append(v)
            ws.append(weights[m] if weights else 1)
    if not vals or sum(ws) == 0:
        return None
    return vmean(vals, ws)


# MARK: Data set: one row per (pair, hour)

def iso_week_parity(day):
    return datetime.date.fromisoformat(day).isocalendar()[1] % 2


def collect(pairs, spots, start, end):
    rows, cells = [], []
    for p in pairs:
        spot = spots[p["spot"]]
        obs, height = observations(p["station"], start, end)
        if not obs:
            print(f"{spot['name']}: no readings at {p['station']['name']}", file=sys.stderr)
            continue
        fc, where = forecasts(spot, start, end)
        dist = {k: km(spot["latitude"], spot["longitude"], la, lo) for k, (la, lo) in where.items() if la is not None}
        cells.append({"pair": p, "dist": dist})
        n = 0
        for h, (kn, d) in obs.items():
            if int(h[11:13]) not in DAY_UTC or not (start <= h[:10] <= end):
                continue
            n += 1
            rows.append({"pair": p["spot"], "station": p["station"]["id"], "cls": p["cls"], "spot": spot,
                         "region": REGIONS.get(spot["region"], spot["region"]), "day": h[:10], "hour": h,
                         "obs": to_10m(kn, height), "dir": d, "fc": fc, "dist": dist})
        print(f"{spot['name']}: {n} daylight hours at {p['station']['name']} ({height} m, {p['km']} km)", file=sys.stderr)
    return rows, cells


def fit_weights(rows, lead):
    """Grid over the simplex (steps of 0.1): weights of AROME 1.3, ICON, ECMWF minimising the hourly
    speed error on these rows. Hours with AROME missing renormalise over the others."""
    best = None
    grid = [i / 10 for i in range(11)]
    for a, b in itertools.product(grid, grid):
        c = round(1 - a - b, 1)
        if c < 0:
            continue
        w = {HD: a, ICON: b, EC: c}
        errs = []
        for r in rows:
            f = setup_hour("3", r["fc"], r["dist"], lead, r["hour"], w)
            if f:
                errs.append(abs(f[0] - r["obs"]))
        if errs:
            e = statistics.mean(errs)
            if best is None or e < best[0]:
                best = (e, w)
    return best[1] if best else {HD: 1 / 3, ICON: 1 / 3, EC: 1 / 3}


def forecast_series(rows, lead, weights_by):
    """Attach f[(name, lead)] = (kn, dir) to each row."""
    for r in rows:
        f = r.setdefault("f", {})
        for name in SETUPS:
            w = None
            if name.startswith("5"):
                w = weights_by.get((r["region"], iso_week_parity(r["day"]), lead))
                if w is None:
                    continue
            v = setup_hour(name, r["fc"], r["dist"], lead, r["hour"], w)
            if v:
                f[(name, lead)] = v
        for name, key in POINT_KEYS.items():
            v = member(r["fc"], HD, key, lead, r["hour"])
            if v:
                f[(name, lead)] = v


# MARK: Scores

def kite(kn, d, spot):
    return kn if usable(d, spot) else 0


def day_table(rows, key):
    """(pair, day) -> (forecast best 2 h, measured best 2 h, forecast go, measured go). Best 2 h on the raw
    speed; "go" = best 2 h ≥ GO_KN counting only hours whose direction is not offshore. ≥ 8 measured hours."""
    by = {}
    for r in rows:
        by.setdefault((r["pair"], r["day"]), {})[int(r["hour"][11:13])] = r
    out = {}
    for k, hrs in by.items():
        f, o, fk, ok = [], [], [], []
        for h in DAY_UTC:
            r = hrs.get(h)
            if r and key in r["f"]:
                v = r["f"][key]
                f.append(v[0])
                o.append(r["obs"])
                fk.append(kite(v[0], v[1], r["spot"]))
                ok.append(kite(r["obs"], r["dir"], r["spot"]))
            else:
                f.append(None), o.append(None), fk.append(None), ok.append(None)
        if sum(v is not None for v in o) >= 8:
            fb, ob = best2h(f), best2h(o)
            if fb is not None and ob is not None:
                out[k] = (fb, ob, best2h(fk) >= GO_KN, best2h(ok) >= GO_KN)
    return out


def go_counts(vals):
    hit = sum(1 for v in vals if v[2] and v[3])
    miss = sum(1 for v in vals if v[3] and not v[2])
    false = sum(1 for v in vals if v[2] and not v[3])
    return hit, miss, false


def scores(rows, key):
    pts = [(r["f"][key], r) for r in rows if key in r["f"]]
    if len(pts) < 30:
        return None
    err = [f[0] - r["obs"] for f, r in pts]
    dirs = [angle(f[1], r["dir"]) for f, r in pts if r["obs"] >= 8 and r["dir"] is not None]
    d = day_table(rows, key)
    hit, miss, false = go_counts(d.values())
    return {"hours": len(pts), "bias": statistics.mean(err), "mae": statistics.mean(abs(e) for e in err),
            "days": len(d), "d_bias": statistics.mean(v[0] - v[1] for v in d.values()) if d else None,
            "d_mae": statistics.mean(abs(v[0] - v[1]) for v in d.values()) if d else None,
            "go": hit + miss, "hit": hit, "miss": miss, "false": false,
            "pod": hit / (hit + miss) if hit + miss else None,
            "far": false / (hit + false) if hit + false else None,
            "dir": statistics.mean(dirs) if dirs else None}


def boot(rows, key, ref=None, reps=400, seed=7):
    """95 % intervals over dates (all pairs of a date resampled together) for best-2 h bias and
    error, go days caught and false alarms; with ref, intervals of the difference key − ref."""
    da = day_table(rows, key)
    db = day_table(rows, ref) if ref else None
    ks = sorted(set(da) & set(db)) if ref else sorted(da)
    by_date = {}
    for k in ks:
        by_date.setdefault(k[1], []).append(k)
    dates = sorted(by_date)
    if len(dates) < 10:
        return None
    rng = random.Random(seed)

    def m(tab, sample):
        v = [tab[k] for k in sample]
        hit, miss, false = go_counts(v)
        return (statistics.mean(x[0] - x[1] for x in v), statistics.mean(abs(x[0] - x[1]) for x in v),
                hit / (hit + miss) if hit + miss else float("nan"), false / (hit + false) if hit + false else float("nan"))

    out = []
    for _ in range(reps):
        s = [k for d in (rng.choice(dates) for _ in dates) for k in by_date[d]]
        a = m(da, s)
        out.append(tuple(x - y for x, y in zip(a, m(db, s))) if ref else a)
    res = []
    for i in range(4):
        xs = sorted(x[i] for x in out if x[i] == x[i])
        res.append((xs[int(0.025 * len(xs))], xs[int(0.975 * len(xs)) - 1]) if len(xs) > 20 else None)
    return {"dates": len(dates), "bias": res[0], "mae": res[1], "pod": res[2], "far": res[3]}


# MARK: Report

def f1(x, sign=False):
    return "–" if x is None else (f"{x:+.1f}" if sign else f"{x:.1f}")


def pc(x):
    return "–" if x is None else f"{x * 100:.0f} %"


def ci(iv, pct=False, sign=True):
    if not iv:
        return ""
    if not pct and not sign:
        return f" ({iv[0]:.1f}–{iv[1]:.1f})"
    if pct:
        return f" ({iv[0] * 100:+.0f} … {iv[1] * 100:+.0f})" if sign else f" ({iv[0] * 100:.0f}–{iv[1] * 100:.0f})"
    return f" ({iv[0]:+.1f} … {iv[1]:+.1f})"


def table(rows, names, lead, with_ci=True, ref=None):
    print("| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    for name in names:
        s = scores(rows, (name, lead))
        if not s:
            continue
        b = boot(rows, (name, lead)) if with_ci else None
        print(f"| {name} | {s['days']} | {f1(s['d_bias'], True)}{ci(b and b['bias'])} | {f1(s['d_mae'])}{ci(b and b['mae'], sign=False)} | "
              f"{s['go']} | {pc(s['pod'])}{ci(b and b['pod'], True, False)} | {pc(s['far'])}{ci(b and b['far'], True, False)} | "
              f"{f1(s['bias'], True)} | {f1(s['mae'])} | {f1(s['dir'])}° |")
    if ref:
        print(f"\nDifference with **{ref}**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):\n")
        for name in names:
            if name == ref:
                continue
            b = boot(rows, (name, lead), (ref, lead))
            if b:
                print(f"- {name}: error {ci(b['mae'])[1:]}, caught {ci(b['pod'], True)[1:]} pts, false alarms {ci(b['far'], True)[1:]} pts")
    print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pairs", required=True)
    ap.add_argument("--start", default="2026-08-08")
    ap.add_argument("--end", default="2026-10-30")
    ap.add_argument("--prefetch", type=int, default=0, help="download forecasts with N parallel workers first")
    ap.add_argument("--dump", help="write per-pair cell distances and per-region scores (JSON)")
    a = ap.parse_args()
    spots = {s["id"]: s for s in load_spots()}
    pairs = json.load(open(a.pairs))
    if a.prefetch:
        from concurrent.futures import ThreadPoolExecutor
        ids = sorted({p["spot"] for p in pairs})
        with ThreadPoolExecutor(a.prefetch) as ex:
            for i, _ in enumerate(ex.map(lambda sid: forecasts(spots[sid], a.start, a.end), ids)):
                print(f"prefetched {i + 1}/{len(ids)}", file=sys.stderr)
    rows, cells = collect(pairs, spots, a.start, a.end)

    weights_by = {}
    for lead in LEADS:
        for region in sorted({r["region"] for r in rows}):
            for parity in (0, 1):
                train = [r for r in rows if r["region"] == region and r["cls"] == "a" and iso_week_parity(r["day"]) != parity]
                if len({r["day"] for r in train}) < 15:   # too few: fit on all regions' training weeks
                    train = [r for r in rows if r["cls"] == "a" and iso_week_parity(r["day"]) != parity]
                weights_by[(region, parity, lead)] = fit_weights(train[::2], lead)
        forecast_series(rows, lead, weights_by)

    main_rows = [r for r in rows if r["cls"] == "a"]
    weak_rows = [r for r in rows if r["cls"] != "a"]
    print(f"# WHE-72 backtest {a.start} … {a.end}\n")
    print(f"{len({r['pair'] for r in main_rows})} spots with a station ≤ 1.5 km (main), "
          f"{len({r['pair'] for r in weak_rows})} with a station further away (weak). Daylight 07–17 UTC, "
          f"measured wind brought to 10 m, nothing removed. Go day = best 2 h ≥ {GO_KN} kn, direction not offshore.\n")
    for lead, label in ((1, "Forecast made the day before"), (0, "Forecast of the day itself")):
        print(f"## {label}, main stations\n")
        table(main_rows, SETUPS, lead, ref=SETUPS[0])
        print(f"### {label}, weak stations (further away)\n")
        table(weak_rows, SETUPS, lead, with_ci=False)

    print("## Per region, day before, main stations (best 2 h bias / error, go days caught / false)\n")
    regions = sorted({r["region"] for r in rows})
    print("| Region | Spots | Days | " + " | ".join(s.split(":")[0] for s in SETUPS) + " |")
    print("|---" * (len(SETUPS) + 3) + "|")
    for cls_rows, tag in ((main_rows, ""), (weak_rows, " (weak)")):
        for reg in regions:
            sub = [r for r in cls_rows if r["region"] == reg]
            if not sub:
                continue
            cells_ = []
            nd = 0
            for name in SETUPS:
                s = scores(sub, (name, 1))
                nd = max(nd, s["days"] if s else 0)
                cells_.append("–" if not s else f"{f1(s['d_bias'], True)} / {f1(s['d_mae'])} · {pc(s['pod'])} / {pc(s['far'])} ({s['go']})")
            print(f"| {reg}{tag} | {len({r['pair'] for r in sub})} | {nd} | " + " | ".join(cells_) + " |")
    print()

    print("## Where to read AROME: beach, 500 m, 1 km, sea cell (day before, main stations)\n")
    table(main_rows, POINTS, 1, ref=POINTS[0])

    print("## Weights fitted for setup 5 (AROME 1.3 / ICON / ECMWF, day before)\n")
    for (reg, par, lead), w in sorted(weights_by.items()):
        if lead == 1:
            print(f"- {reg}, weeks {'even' if par else 'odd'} trained on the others: {w[HD]:.1f} / {w[ICON]:.1f} / {w[EC]:.1f}")
    print()

    print("## Robustness: drop one main station at a time (day before, change Option 1 vs Baseline)\n")
    for st in sorted({r["station"] for r in main_rows}):
        sub = [r for r in main_rows if r["station"] != st]
        s1, s3, s4 = (scores(sub, (n, 1)) for n in (SETUPS[0], SETUPS[2], SETUPS[3]))
        if s1 and s3 and s4:
            print(f"- without {st}: best 2 h error {s1['d_mae']:.2f} → {s3['d_mae']:.2f} (opt 1) / {s4['d_mae']:.2f} (sea capped); "
                  f"caught {pc(s1['pod'])} → {pc(s3['pod'])} / {pc(s4['pod'])}; false {pc(s1['far'])} → {pc(s3['far'])} / {pc(s4['far'])}")
    print()

    print("## Pairs and where each model's cell falls (km from the pin)\n")
    print("| Spot | Region | Station | Kind | km | Height | AROME 1.3 beach / nearest / sea / 500 m / 1 km | ICON beach / nearest / sea | ECMWF nearest / sea |")
    print("|---|---|---|---|---|---|---|---|---|")
    for c in cells:
        p, d = c["pair"], c["dist"]
        g = lambda m, k: f1(d.get((m, k)))
        print(f"| {spots[p['spot']]['name']} | {REGIONS.get(spots[p['spot']]['region'])} | {p['station']['name']} | "
              f"{p['station']['kind']} ({p['cls']}) | {p['km']} | {p.get('height', '')} | "
              f"{g(HD, 'land')} / {g(HD, 'nearest')} / {g(HD, 'sea')} / {g(HD, 'off500')} / {g(HD, 'off1000')} | "
              f"{g(ICON, 'land')} / {g(ICON, 'nearest')} / {g(ICON, 'sea')} | {g(EC, 'nearest')} / {g(EC, 'sea')} |")
    if a.dump:
        json.dump({"cells": [{"spot": c["pair"]["spot"], "dist": {f"{m}|{k}": v for (m, k), v in c["dist"].items()}} for c in cells]},
                  open(a.dump, "w"), indent=1)


if __name__ == "__main__":
    main()
