"""Can we tell riders "x % chance you'll kite" and have it mean x %? (WHE-81)

Event, per spot and day (07-17 UTC): two consecutive hours each between 12 and 28 kn
(intermediate safety limit) with a usable direction (review.usable: not offshore).
Truth: the WHE-72 shore masts (pairs_esfr.json, classes a/a2, wind brought to 10 m) plus the
POEM buoy on the water for the two spots next to it.

Labels: Go ≥ 70 %, Probably 40-70 %, Long shot 15-40 %, No < 15 %. Pass bar (Ben): each label's
measured hit rate lands in its own band, on days not used to tune it, for every day ahead the app
shows (today, +1 … +5), and per kind of place and kind of day, with ≥ 30 spot-days over ≥ 15 dates
behind it (else "too few"). One method everywhere: groups are for checking only, nothing is tuned
per group.

Methods (the chance for a spot-day), the same at every lead and spot:
  Today       best match on the sea cell, yes/no (100 % or 0 %)
  A1 votes    share of 4 models that say go: best match (sea cell), Météo-France seamless
              (AROME 1.3 → AROME 2.5 → ARPEGE as lead grows, beach cell), ICON (beach cell),
              ECMWF (sea cell). Open-Meteo Previous Runs: day 0 = latest run, day N = run N days before
  A2 margin   the same 4 models: p = Phi((mean best 2 h - 12 + b) / sqrt(sd^2 + s^2)); one b and
              one s for all leads and places, fitted on the other weeks (odd ISO weeks scored
              with numbers fitted on even weeks and back)
  B1 ENS raw  the go rule run on each of ECMWF's 51 ensemble members (ens_fetch.py), read at
              ECMWF's sea cell: share of members that say go. Today: 00 UTC run; day N: 12 UTC
              run of D-N
  B3 ENS+MF   the ensemble's spread around Météo-France seamless: each member's best 2 h shifted
              by (MF best 2 h - ensemble mean best 2 h), then share above the threshold

Groups (checking only):
  place  strait/funnel (Tarifa, Calais strait, Empordà tramontana), island (Canaries, Corsica),
         lagoon (waterType lagoon: Mar Menor, Étang de Berre), open coast (the rest)
  sea    Mediterranean vs Atlantic/Channel
  day    from the same-day best-match forecast at the spot (never the station): calm (best 2 h
         < 8 kn), sea breeze (07-09 UTC < 8 kn, afternoon onshore within 75° and ≥ 4 kn up on
         the morning), weather system (the rest)

    python3 tools/backtest/chance.py > tools/backtest/results/whe81.md
"""
import argparse
import datetime as dt
import json
import math
import os
import random
import statistics
import sys
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from esfr_backtest import forecasts, om, REGIONS, ICON, EC, BM  # noqa: E402
from model_backtest import months, angle  # noqa: E402
from review import to_10m, usable  # noqa: E402
from stations import observations, load_spots  # noqa: E402

HERE = os.path.dirname(__file__)
CACHE = os.path.join(HERE, ".cache")
HOURS = list(range(7, 18))
LO, HI = 12, 28
KN = 1.943844
MF = "meteofrance_seamless"
DET = [(BM, "sea"), (MF, "land"), (ICON, "land"), (EC, "sea")]
LEADS = [0, 1, 2, 3, 4, 5]
LEAD_NAME = {0: "today", 1: "+1 day", 2: "+2 days", 3: "+3 days", 4: "+4 days", 5: "+5 days (Pro)"}
LABELS = [("Go", 0.7, 1.01), ("Probably", 0.4, 0.7), ("Long shot", 0.15, 0.4), ("No", 0, 0.15)]
METHODS = ["Today", "A1 votes", "A2 margin", "B1 ENS raw", "B3 ENS+MF"]
MIN_DAYS, MIN_DATES = 30, 15
STRAIT = {"es-tarifa-balneario", "fr-les-hemmes-de-marck", "es-sant-pere-pescador", "es-empuriabrava-la-rubina"}
ATLANTIC_REGIONS = {"Canarias", "Pays basque", "Landes", "Gironde", "Charente-Maritime", "Bretagne", "Normandie",
                    "Baie de Somme", "Côte d'Opale"}
ATLANTIC_SPOTS = {"es-tarifa-balneario", "es-cadiz-cortadura", "es-rota-el-rompidillo"}


def place_of(spot):
    if spot["id"] in STRAIT:
        return "strait/funnel"
    if spot["region"] in ("Canarias", "Corse"):
        return "island"
    if spot.get("waterType") == "lagoon":
        return "lagoon"
    return "open coast"


def sea_of(spot):
    return "Atlantic/Channel" if spot["region"] in ATLANTIC_REGIONS or spot["id"] in ATLANTIC_SPOTS else "Mediterranean"


def day_kind(series, spot):
    """series: same-day best-match forecast, hour -> (kn, dir)."""
    if len(series) < len(HOURS):
        return None
    b2 = best2(series, spot)
    if b2 is None or b2 < 8:
        return "calm"
    morning = statistics.mean(series[h][0] for h in (7, 8, 9))
    aft = [series[h] for h in (12, 13, 14, 15, 16)]
    aft_kn = statistics.mean(k for k, _ in aft)
    onshore = all(angle(d, spot["seaFacingDeg"]) < 75 for _, d in aft) if spot.get("seaFacingDeg") is not None else False
    if morning < 8 and onshore and aft_kn >= morning + 4:
        return "sea breeze"
    return "weather system"


# MARK: Wind helpers

def ride(series, spot, lo=LO):
    """series: hour -> (kn, dir). True when two consecutive hours are in range at a usable direction."""
    ok = [h in series and lo <= series[h][0] <= HI and usable(series[h][1], spot) for h in HOURS]
    return any(a and b for a, b in zip(ok, ok[1:]))


def best2(series, spot):
    """Best 2 h mean of the kiteable speed (0 when the direction is offshore). None if hours missing."""
    k = [series[h][0] if usable(series[h][1], spot) else 0 for h in HOURS if h in series]
    if len(k) < len(HOURS):
        return None
    return max((a + b) / 2 for a, b in zip(k, k[1:]))


def uv_to(u, v):
    return math.hypot(u, v) * KN, (math.degrees(math.atan2(-u, -v)) % 360)


def members(day_file, key):
    """member -> hour -> (kn, dir), linear in u, v between the 3-hourly steps."""
    pt = day_file["points"].get(key)
    if not pt:
        return {}
    out = {}
    for m, hrs in pt.items():
        s = {}
        for h in HOURS:
            a = (h // 3) * 3
            b = a + 3
            if str(a) not in hrs or str(b) not in hrs:
                break
            w = (h - a) / 3
            u = hrs[str(a)][0] * (1 - w) + hrs[str(b)][0] * w
            v = hrs[str(a)][1] * (1 - w) + hrs[str(b)][1] * w
            s[h] = uv_to(u, v)
        if len(s) == len(HOURS):
            out[m] = s
    return out


def ens_key(lat, lon):
    return f"{round(lat * 4) / 4:.2f},{round(lon * 4) / 4:.2f}"


def ens_dir(lead):
    return os.path.join(CACHE, "ens" if lead == 1 else f"ens_d{lead}")


# MARK: Data

def det_forecasts(spot, start, end):
    """(model, cell) -> lead -> hour -> (kn, dir), leads 0-5 from Previous Runs, one model per request
    (multi-model requests silently drop out-of-range models)."""
    sufs = {0: ""} | {n: f"_previous_day{n}" for n in LEADS if n}
    vars_ = ",".join(f"{v}{s}" for s in sufs.values() for v in ("wind_speed_10m", "wind_direction_10m"))
    fc = {}
    for m, cell in DET:
        fc[(m, cell)] = {n: {} for n in LEADS}
        for lo, hi in months(start, end):
            j = om("https://previous-runs-api.open-meteo.com/v1/forecast", urllib.parse.urlencode({
                "latitude": f"{spot['latitude']:.5f}", "longitude": f"{spot['longitude']:.5f}", "hourly": vars_,
                "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
                "models": m, "cell_selection": cell}))
            h = j.get("hourly") or {}
            for n, suf in sufs.items():
                sp, d = h.get(f"wind_speed_10m{suf}") or [], h.get(f"wind_direction_10m{suf}") or []
                for t, a, b in zip(h.get("time", []), sp, d):
                    if a is not None and b is not None:
                        fc[(m, cell)][n][t[:13]] = (a, b)
    return fc


def sites(start, end, buoy):
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json"))) if p["cls"] in ("a", "a2")]
    out = []   # (pair id, spot, obs, fc, ens key, kind)
    for p in pairs:
        spot = spots[p["spot"]]
        obs, height = observations(p["station"], start, end)
        if not obs:
            continue
        obs = {h: (to_10m(kn, height), d) for h, (kn, d) in obs.items()}
        _, where = forecasts(spot, start, end)          # cached: where ECMWF's sea cell is
        ec = where.get((EC, "sea")) or (spot["latitude"], spot["longitude"])
        out.append((f"{p['spot']}|{p['station']['id']}", spot, obs, det_forecasts(spot, start, end), ens_key(*ec), "mast"))
    if buoy:
        from buoys import BUOYS, read_buoy, to_10m_sea
        b = BUOYS["POEM"]
        obs, _ = read_buoy(b["prefix"], start, end)
        obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
        for sid in b["spots"]:
            spot = spots[sid]
            _, where = forecasts(spot, start, end)
            ec = where.get((EC, "sea")) or (spot["latitude"], spot["longitude"])
            out.append((f"{sid}|POEM", spot, obs, det_forecasts(spot, start, end), ens_key(*ec), "buoy"))
    return out


def collect(site_list, start, end):
    rows = []
    d0, d1 = dt.date.fromisoformat(start), dt.date.fromisoformat(end)
    for lead in LEADS:
        day = d0
        while day <= d1:
            path = os.path.join(ens_dir(lead), f"{day:%Y%m%d}.json")
            ens = json.load(open(path)) if os.path.exists(path) else None
            ds = day.isoformat()
            for pid, spot, obs, fc, ekey, kind in site_list:
                o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
                if len(o) < 9:   # ≥ 9 of 11 daylight hours measured
                    continue
                det = {}
                for m, cell in DET:
                    s = {h: fc[(m, cell)][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                    s = {h: v for h, v in s.items() if v}
                    if len(s) == len(HOURS):
                        det[m] = s
                if BM not in det:
                    continue
                today_bm = {h: fc[(BM, "sea")][0].get(f"{ds}T{h:02d}") for h in HOURS}
                today_bm = {h: v for h, v in today_bm.items() if v}
                mem = members(ens, ekey) if ens else {}
                rows.append({"pair": pid, "spot": spot, "kind": kind, "day": ds, "lead": lead,
                             "place": place_of(spot), "sea": sea_of(spot), "dayk": day_kind(today_bm, spot),
                             "country": "Spain" if spot["id"].startswith("es-") else "France",
                             "region": REGIONS.get(spot["region"], spot["region"]),
                             "obs": ride(o, spot), "obs15": ride(o, spot, 15),
                             "det": {m: (ride(s, spot), ride(s, spot, 15), best2(s, spot)) for m, s in det.items()},
                             "ens": [(ride(s, spot), ride(s, spot, 15), best2(s, spot)) for s in mem.values()]})
            day += dt.timedelta(days=1)
    return rows


# MARK: Methods

def phi(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))


def week_parity(day):
    return dt.date.fromisoformat(day).isocalendar()[1] % 2


def a2_prob(r, b, s, thr):
    xs = [v[2] for v in r["det"].values() if v[2] is not None]
    if len(xs) < 2:
        return None
    mean, sd = statistics.mean(xs), statistics.pstdev(xs)
    return phi((mean - thr + b) / math.sqrt(sd ** 2 + s ** 2))


def brier(ps):
    return statistics.mean((p - o) ** 2 for p, o in ps)


def fit(rows, thr, idx):
    grid = [(b, s) for b in [x * 0.5 for x in range(-8, 9)] for s in [0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6]]
    best = None
    for b, s in grid:
        ps = [(a2_prob(r, b, s, thr), r[idx]) for r in rows]
        ps = [(p, o) for p, o in ps if p is not None]
        if ps:
            bs = brier(ps)
            if best is None or bs < best[0]:
                best = (bs, (b, s))
    return best[1]


def chances(rows, thr=LO):
    """Attach r['p'][thr][method]. A2: one (b, s) for every lead and place, fitted on the other weeks
    (masts only, every 3rd row to keep the fit fast)."""
    idx = "obs" if thr == LO else "obs15"
    k = 0 if thr == LO else 1
    fitted = {par: fit([r for r in rows if r["kind"] == "mast" and week_parity(r["day"]) != par][::3], thr, idx)
              for par in (0, 1)}
    for r in rows:
        b, s = fitted[week_parity(r["day"])]
        p = r.setdefault("p", {}).setdefault(thr, {})
        p["Today"] = 1.0 if r["det"][BM][k] else 0.0
        p["A1 votes"] = sum(v[k] for v in r["det"].values()) / len(r["det"])
        p["A2 margin"] = a2_prob(r, b, s, thr)
        if r["ens"]:
            p["B1 ENS raw"] = sum(v[k] for v in r["ens"]) / len(r["ens"])
            anchor = r["det"].get(MF, (None, None, None))[2]
            xs = [v[2] for v in r["ens"] if v[2] is not None]
            if anchor is not None and xs:
                shift = anchor - statistics.mean(xs)
                p["B3 ENS+MF"] = sum(1 for x in xs if x + shift >= thr) / len(xs)
    return fitted


# MARK: Scores

def score(rows, m, thr, cut=0.5):
    idx = "obs" if thr == LO else "obs15"
    ps = [(r["p"][thr][m], r[idx]) for r in rows if r["p"][thr].get(m) is not None]
    if len(ps) < 30:
        return None
    clim = statistics.mean(o for _, o in ps)
    bs = brier(ps)
    ref = statistics.mean((clim - o) ** 2 for _, o in ps)
    go = [(p, o) for p, o in ps if p >= cut]
    hits = sum(o for _, o in go)
    events = sum(o for _, o in ps)
    return {"n": len(ps), "base": clim, "bss": 1 - bs / ref if ref else None,
            "go": len(go), "wrong": (len(go) - hits) / len(go) if go else None,
            "caught": hits / events if events else None}


def boot_diff(rows, m, ref, thr, reps=400, seed=11):
    """95 % interval over dates of Brier skill(m) - Brier skill(ref) on the spot-days both have."""
    idx = "obs" if thr == LO else "obs15"
    both = [r for r in rows if r["p"][thr].get(m) is not None and r["p"][thr].get(ref) is not None]
    by = {}
    for r in both:
        by.setdefault(r["day"], []).append(r)
    dates = sorted(by)
    if len(dates) < 15:
        return None
    rng = random.Random(seed)
    out = []
    for _ in range(reps):
        s = [r for d in (rng.choice(dates) for _ in dates) for r in by[d]]
        clim = statistics.mean(r[idx] for r in s)
        ref_bs = statistics.mean((clim - r[idx]) ** 2 for r in s) or 1e-9
        out.append(statistics.mean((r["p"][thr][ref] - r[idx]) ** 2 for r in s) / ref_bs
                   - statistics.mean((r["p"][thr][m] - r[idx]) ** 2 for r in s) / ref_bs)
    out.sort()
    return out[int(0.025 * reps)], out[int(0.975 * reps) - 1]


def label_stats(rows, m, thr, reps=300, seed=5):
    """label -> (spot-days, dates, hit rate, 95 % interval over dates)."""
    idx = "obs" if thr == LO else "obs15"
    rows = [r for r in rows if r["p"][thr].get(m) is not None]
    out = {}
    for name, lo, hi in LABELS:
        by = {}
        for r in rows:
            if lo <= r["p"][thr][m] < hi:
                by.setdefault(r["day"], []).append(r[idx])
        n = sum(len(v) for v in by.values())
        if not n:
            out[name] = (0, 0, None, None)
            continue
        rate = sum(sum(v) for v in by.values()) / n
        dates = sorted(by)
        rng = random.Random(seed)
        bs = []
        for _ in range(reps):
            xs = [o for d in (rng.choice(dates) for _ in dates) for o in by[d]]
            bs.append(sum(xs) / len(xs))
        bs.sort()
        out[name] = (n, len(dates), rate, (bs[int(0.025 * reps)], bs[int(0.975 * reps) - 1]))
    return out


def verdict(name, n, nd, rate):
    lo, hi = next((a, b) for nm, a, b in LABELS if nm == name)
    if n < MIN_DAYS or nd < MIN_DATES:
        return "too few"
    if rate < lo:
        return "too sure"
    return "pass" if rate < max(hi, 1.0001) else "too shy"


def pc(x):
    return "–" if x is None else f"{100 * x:.0f} %"


def bar(st):
    """'pass', 'fail: …' or 'too few: …' (labels with too few days don't fail, they can't be judged)."""
    fails, few = [], []
    for name, _, _ in LABELS:
        n, nd, rate, _ = st[name]
        v = verdict(name, n, nd, rate) if n else "too few"
        if v == "too few":
            few.append(name)
        elif v != "pass":
            fails.append(f"{name} {v}")
    if fails:
        return "**fail**: " + ", ".join(fails) + (f" (too few: {', '.join(few)})" if few else "")
    return "pass" + (f" (too few: {', '.join(few)})" if few else "")


def label_rows(groups, methods, thr):
    print("| Method | Day ahead | Group | " + " | ".join(f"{n} ({int(lo * 100)}–{min(100, int(hi * 100))} %)" for n, lo, hi in LABELS)
          + " | Wrong gos on Go | Bar |")
    print("|---|---|---|" + "---|" * (len(LABELS) + 2))
    for m in methods:
        for lead in LEADS:
            for title, rows in groups:
                sub = [r for r in rows if r["lead"] == lead]
                if not any(r["p"][thr].get(m) is not None for r in sub):
                    continue
                st = label_stats(sub, m, thr)
                cells = ["–" if not n else f"**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}) · {n}/{nd}"
                         for n, nd, rate, iv in (st[name] for name, _, _ in LABELS)]
                g = st["Go"]
                print(f"| {m} | {LEAD_NAME[lead]} | {title} | " + " | ".join(cells)
                      + f" | {'–' if not g[0] else pc(1 - g[2])} | {bar(st)} |")
    print()


def grid(groups, methods, thr):
    """Compact pass/fail grid: group x lead, one per method."""
    for m in methods:
        print(f"**{m}** (P = pass, F = fail, n = too few days to judge any label, P* / F* = some labels too few)\n")
        print("| Group | " + " | ".join(LEAD_NAME[l] for l in LEADS) + " |")
        print("|---|" + "---|" * len(LEADS))
        for title, rows in groups:
            cells = []
            for lead in LEADS:
                sub = [r for r in rows if r["lead"] == lead and r["p"][thr].get(m) is not None]
                if not sub:
                    cells.append("–")
                    continue
                st = label_stats(sub, m, thr, reps=50)
                b = bar(st)
                go = st["Go"]
                tag = "F" if b.startswith("**fail") else "P"
                if "too few" in b:
                    tag = "n" if all(st[x][0] < MIN_DAYS or st[x][1] < MIN_DATES for x in ("Go", "Probably", "Long shot")) else tag + "*"
                cells.append(f"{tag} · Go {pc(go[2])}" if go[0] else tag)
            print(f"| {title} | " + " | ".join(cells) + " |")
        print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-08-08")
    ap.add_argument("--end", default="2026-10-30")
    ap.add_argument("--no-buoy", action="store_true")
    a = ap.parse_args()
    rows = collect(sites(a.start, a.end, not a.no_buoy), a.start, a.end)
    print(f"# WHE-81: chance you'll kite, {a.start} … {a.end}\n")
    print(f"Go = two hours in a row between {LO} and {HI} kn, direction not offshore, 07–17 UTC. Labels: Go ≥ 70 %, "
          f"Probably 40–70 %, Long shot 15–40 %, No < 15 %. A label passes when its measured hit rate falls in its own "
          f"band, with ≥ {MIN_DAYS} spot-days over ≥ {MIN_DATES} dates (cells: hit rate (95 % interval over dates) · "
          "spot-days/dates). One method everywhere; groups are for checking only.\n")
    for lead in LEADS:
        sub = [r for r in rows if r["lead"] == lead]
        print(f"- {LEAD_NAME[lead]}: {len(sub)} spot-days, {sum(1 for r in sub if r['ens'])} with the ensemble")
    print()
    masts = [r for r in rows if r["kind"] == "mast"]
    groups = [("All masts", masts)]
    groups += [(f"Place: {g}", [r for r in masts if r["place"] == g]) for g in ("open coast", "strait/funnel", "island", "lagoon")]
    groups += [(f"Sea: {g}", [r for r in masts if r["sea"] == g]) for g in ("Mediterranean", "Atlantic/Channel")]
    groups += [(f"Day: {g}", [r for r in masts if r["dayk"] == g]) for g in ("sea breeze", "weather system", "calm")]
    groups += [("Catalonia (masts)", [r for r in masts if r["region"] == "Catalonia"]),
               ("All masts without Catalonia", [r for r in masts if r["region"] != "Catalonia"]),
               ("POEM buoy (water)", [r for r in rows if r["kind"] == "buoy"])]
    print("Groups: " + "; ".join(f"{t} {len({r['pair'] for r in g})} pairs" for t, g in groups) + "\n")
    for thr in (LO, 15):
        fitted = chances(rows, thr)
        print(f"## Go at {thr} kn+\n")
        print("A2 fitted on the other weeks (all leads and places together): " + "; ".join(
            f"weeks {'odd' if par else 'even'} b = {b:+.1f} kn, s = {s:.1f} kn" for par, (b, s) in sorted(fitted.items())) + "\n")
        print("### Skill and wrong gos per day ahead (all masts, chance ≥ 50 % = go)\n")
        print("| Day ahead | Method | Skill (Brier vs climate) | Says go | wrong gos | go days caught | A2 − method, 95 % |")
        print("|---|---|---|---|---|---|---|")
        for lead in LEADS:
            sub = [r for r in masts if r["lead"] == lead]
            for m in METHODS:
                s = score(sub, m, thr)
                if not s:
                    continue
                d = boot_diff(sub, "A2 margin", m, thr) if m != "A2 margin" else None
                print(f"| {LEAD_NAME[lead]} | {m} | {s['bss']:+.2f} | {s['go']} | {pc(s['wrong'])} | {pc(s['caught'])} | "
                      f"{'' if not d else f'{d[0]:+.2f} … {d[1]:+.2f}'} |")
        print()
        print("### Pass / fail by group and day ahead\n")
        grid(groups, ["A2 margin", "B1 ENS raw", "A1 votes"], thr)
        print("### Labels in full\n")
        label_rows(groups, ["A2 margin", "B1 ENS raw"] + (["A1 votes", "B3 ENS+MF"] if thr == LO else []), thr)
    json.dump([{"pair": r["pair"], "day": r["day"], "lead": r["lead"], "place": r["place"], "sea": r["sea"],
                "dayk": r["dayk"], "obs": r["obs"], "obs15": r["obs15"], "p": r["p"]} for r in rows],
              open(os.path.join(CACHE, "whe81_rows.json"), "w"))


if __name__ == "__main__":
    main()
