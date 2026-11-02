"""One statistical correction of the forecast wind, learned from measurements, the same at every spot (WHE-80).

Correction (MOS as a lookup table): corrected speed = max(0, forecast + c[key]) with
  key = (model, day ahead 0-5, forecast speed band, direction vs the beach)
  c   = mean(measured - forecast) over the fitting hours in that key, pulled toward the coarser
        key (model, day ahead, speed band) with K_SHRINK hours of weight, itself pulled toward 0.
Direction bands: onshore (< 45° off the sea-facing side), cross (45-100°), offshore (>= 100°),
open water (buoys, lagoons: no beach side). Direction is never changed.

Fitting truth: the trusted masts (France, southern Spain, Canaries; WHE-72 classes a/a2, brought to
10 m) + POEM near-shore buoy + Begur / Tarragona open-sea buoys. Catalan Meteocat masts are never
used (they read ~half the forecast, WHE-84). Hours 07-17 UTC.

Scored two ways, every hour with numbers that never saw it:
  weeks      fitted on the other ISO-week parity (all fitting stations)
  weeks+site fitted on the other weeks AND without the scored station: what a spot with no
             station of its own gets (the app's real case)
Untouched Catalan test: Barcelona airport (AEMET METAR) against the Castelldefels forecast and Port
Bocana Sud (Meteocat Y7) against Barceloneta, as the app reads them (WHE-86 part 3). Never fitted.

The wind shown = best match on the sea cell (today's app). Go = WHE-82's chance to kite from the
4 models (best match sea, Météo-France land, ICON land, ECMWF sea), tuning per day ahead as in
Scoring.chanceTuning, all 4 models corrected the same way; real go = two hours in a row 12-28 kn,
not offshore, 07-17 UTC.

    BACKTEST_OFFLINE=1 python3 tools/backtest/mos80.py > tools/backtest/results/whe80.md
"""
import math
import os
import random
import statistics
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(__file__))
from chance import DET, HOURS, LO, HI, BM, det_forecasts, ride, best2, phi, week_parity  # noqa: E402
from model_backtest import angle  # noqa: E402
from review import usable  # noqa: E402
from thresholds84 import all_sites, group_of  # noqa: E402

LEADS = [0, 1, 2, 3, 4, 5]
BANDS = [0, 4, 8, 12, 16, 20, 25, 999]
K_SHRINK = float(os.environ.get("K_SHRINK", "300"))
# Scoring.chanceTuning on atlas/t/whe-82: lead -> (bias kn, error kn, Go from)
TUNING = {0: (-0.25, 2.0, 0.68), 1: (-0.25, 2.25, 0.73), 2: (0, 2.5, 0.70), 3: (0, 2.75, 0.79),
          4: (-1, 4.5, 0.71), 5: (-1, 5, 0.80)}
FIT_GROUPS = {"France", "Mainland Spain (south masts)", "Canaries", "Near-shore buoy (POEM)",
              "Open-sea buoys (Begur, Tarragona)"}
AREAS = ["France", "Mainland Spain (south masts)", "Canaries", "Near-shore buoy (POEM)",
         "Open-sea buoys (Begur, Tarragona)", "Catalonia test (airport, Bocana Sud)"]


def band(f):
    return next(i for i in range(len(BANDS) - 1) if f < BANDS[i + 1])


def dir_class(d, spot):
    if spot.get("waterType") == "lagoon" or spot.get("seaFacingDeg") is None or spot.get("sides"):
        return "open"
    a = angle(d, spot["seaFacingDeg"])
    return "on" if a < 45 else "cross" if a < 100 else "off"


def station_of(pid):
    return pid.split("|")[1]


# MARK: Data

def catalan_tests():
    import whe86
    from stations import load_spots
    spots = {s["id"]: s for s in load_spots()}
    out = []
    for spid, sid in whe86.APP_PAIRS:
        st = whe86.station(sid, "metar" if sid == "LEBL" else "xema")
        obs, _ = whe86.obs10(st)
        out.append((f"{spid}|{sid}", spots[spid], obs, det_forecasts(spots[spid], whe86.START, whe86.END), None, "test"))
    return out


def hourly(site_list):
    """One record per (site, day, hour, lead): obs (kn, dir) and each model's (kn, dir)."""
    recs = []
    for pid, spot, obs, fc, _, kind in site_list:
        g = "Catalonia test (airport, Bocana Sud)" if kind == "test" else group_of(pid)
        for t, o in obs.items():
            if int(t[11:13]) not in HOURS or o[1] is None:
                continue
            for lead in LEADS:
                m = {mod: fc[(mod, cell)][lead].get(t) for mod, cell in DET}
                if not m.get(BM):
                    continue
                recs.append({"pid": pid, "st": station_of(pid), "spot": spot, "group": g, "t": t, "day": t[:10],
                             "par": week_parity(t[:10]), "lead": lead, "obs": o,
                             "fc": {k: v for k, v in m.items() if v}})
    return recs


# MARK: Fit

METHODS = ["raw", "bands, weeks only", "bands", "scale", "qmap", "own station"]
METHOD_NAME = {"raw": "today (no correction)", "bands, weeks only": "speed bands, station seen",
               "bands": "speed bands", "scale": "one factor", "qmap": "quantile map",
               "own station": "own station's mean miss (needs a station)"}
QS = [i / 100 for i in range(1, 100, 2)] + [0.995]


def keys(mod, lead, f, d, spot):
    b = band(f)
    return (mod, lead, b, dir_class(d, spot)), (mod, lead, b)


def sums(recs):
    """(station, parity) -> key -> [n, sum err, sum f, sum o] and -> qkey -> ([f], [o])."""
    s = defaultdict(lambda: defaultdict(lambda: [0, 0.0, 0.0, 0.0]))
    q = defaultdict(lambda: defaultdict(lambda: ([], [])))
    for r in recs:
        if r["group"] not in FIT_GROUPS:
            continue
        o = r["obs"][0]
        for mod, (f, d) in r["fc"].items():
            dc = dir_class(d, r["spot"])
            for k in keys(mod, r["lead"], f, d, r["spot"]) + ((mod, r["lead"], dc),):
                a = s[(r["st"], r["par"])][k]
                a[0] += 1
                a[1] += o - f
                a[2] += f
                a[3] += o
            fl, ol = q[(r["st"], r["par"])][(mod, r["lead"], dc)]
            fl.append(f)
            ol.append(o)
    return s, q


def quant(xs, p):
    i = p * (len(xs) - 1)
    lo = int(i)
    hi = min(lo + 1, len(xs) - 1)
    return xs[lo] + (xs[hi] - xs[lo]) * (i - lo)


def table(s, q, parity, drop=None):
    """Corrections fitted on weeks of `parity`, without station `drop`."""
    tot = defaultdict(lambda: [0, 0.0, 0.0, 0.0])
    for (st, par), ks in s.items():
        if par != parity or st == drop:
            continue
        for k, v in ks.items():
            t = tot[k]
            for i in range(4):
                t[i] += v[i]
    coarse = {k: (v[1] / (v[0] + K_SHRINK)) for k, v in tot.items() if len(k) == 3 and isinstance(k[2], int)}
    fine = {k: (v[1] + K_SHRINK * coarse.get(k[:3], 0)) / (v[0] + K_SHRINK) for k, v in tot.items() if len(k) == 4}
    scale = {k: v[3] / v[2] for k, v in tot.items() if len(k) == 3 and isinstance(k[2], str) and v[2] > 0}
    pooled = defaultdict(lambda: ([], []))
    for (st, par), ks in q.items():
        if par != parity or st == drop:
            continue
        for k, (fl, ol) in ks.items():
            pooled[k][0].extend(fl)
            pooled[k][1].extend(ol)
    qmap = {}
    for k, (fl, ol) in pooled.items():
        if len(fl) >= 200:
            fs, os_ = sorted(fl), sorted(ol)
            qmap[k] = ([quant(fs, p) for p in QS], [quant(os_, p) for p in QS])
    return {"fine": fine, "coarse": coarse, "scale": scale, "qmap": qmap}


def qmapped(fq, oq, f):
    if f <= fq[0]:
        return max(0.0, f + oq[0] - fq[0])
    if f >= fq[-1]:
        return max(0.0, f + oq[-1] - fq[-1])
    i = next(j for j in range(1, len(fq)) if f <= fq[j])
    w = (f - fq[i - 1]) / (fq[i] - fq[i - 1]) if fq[i] > fq[i - 1] else 0
    return oq[i - 1] + w * (oq[i] - oq[i - 1])


def correct(tab, method, mod, lead, f, d, spot):
    if method.startswith("bands"):
        kf, kc = keys(mod, lead, f, d, spot)
        return max(0.0, f + tab["fine"].get(kf, tab["coarse"].get(kc, 0.0)))
    k = (mod, lead, dir_class(d, spot))
    if method == "scale":
        return f * tab["scale"].get(k, 1.0)
    if k in tab["qmap"]:
        return qmapped(*tab["qmap"][k], f)
    return f


def apply(recs, s, q):
    """r['cor'][method][mod] = (kn, dir), each hour corrected with numbers fitted on the other weeks and
    (except 'bands, weeks only') without its own station."""
    cache = {}
    own = defaultdict(lambda: [0, 0.0])   # (station, parity, model, lead) -> n, sum miss
    for r in recs:
        for mod, (f, _) in r["fc"].items():
            a = own[(r["st"], r["par"], mod, r["lead"])]
            a[0] += 1
            a[1] += r["obs"][0] - f
    for r in recs:
        tune_par = 1 - r["par"]
        cor = {"raw": r["fc"]}
        cor["own station"] = {}
        for mod, (f, d) in r["fc"].items():
            n, e = own.get((r["st"], tune_par, mod, r["lead"]), (0, 0.0))
            cor["own station"][mod] = (max(0.0, f + e / (n + K_SHRINK)), d)
        for method in METHODS[1:-1]:
            drop = None if method == "bands, weeks only" else r["st"]
            if (tune_par, drop) not in cache:
                cache[(tune_par, drop)] = table(s, q, tune_par, drop)
            tab = cache[(tune_par, drop)]
            cor[method] = {mod: (correct(tab, method, mod, r["lead"], f, d, r["spot"]), d)
                           for mod, (f, d) in r["fc"].items()}
        r["cor"] = cor


# MARK: Scores

def boot_diff(by_day, reps=400, seed=7):
    """by_day: day -> list of (before abs err, after abs err). 95 % interval of mean(after - before)."""
    days = sorted(by_day)
    if len(days) < 10:
        return None
    rng = random.Random(seed)
    out = []
    for _ in range(reps):
        xs = [x for d in (rng.choice(days) for _ in days) for x in by_day[d]]
        out.append(statistics.mean(b - a for a, b in xs))
    out.sort()
    return out[int(0.025 * reps)], out[int(0.975 * reps) - 1]


def hour_stats(rs, method):
    """Best match as shown: bias, MAE, kiteable hours, strong-wind hours."""
    errs, aerr = [], []
    hit = miss = fa = storm = storm_low = 0
    storm_err = []
    windy = []
    for r in rs:
        f, d = r["cor"][method][BM]
        o, od = r["obs"]
        errs.append(f - o)
        aerr.append(abs(f - o))
        if o >= 10 or r["fc"][BM][0] >= 10:
            windy.append(abs(f - o))
        fk = LO <= f <= HI and usable(d, r["spot"])
        ok = LO <= o <= HI and usable(od, r["spot"])
        hit += fk and ok
        miss += ok and not fk
        fa += fk and not ok
        if o >= 25:
            storm += 1
            storm_low += f < 20
            storm_err.append(f - o)
    n = len(errs)
    return {"n": n, "bias": statistics.mean(errs) if n else None, "mae": statistics.mean(aerr) if n else None,
            "pod": hit / (hit + miss) if hit + miss else None, "far": fa / (hit + fa) if hit + fa else None,
            "windy": statistics.mean(windy) if windy else None, "storm": storm, "storm_low": storm_low / storm if storm else None,
            "storm_bias": statistics.mean(storm_err) if storm_err else None}


def mae_ci(rs, method):
    by = defaultdict(list)
    for r in rs:
        o = r["obs"][0]
        by[r["day"]].append((abs(r["fc"][BM][0] - o), abs(r["cor"][method][BM][0] - o)))
    return boot_diff(by)


def day_rows(recs, method):
    """(site, day, lead) -> best-2-h forecast / measured and the WHE-82 Go from the 4 models."""
    by = defaultdict(list)
    for r in recs:
        by[(r["pid"], r["day"], r["lead"])].append(r)
    out = {}
    for (pid, day, lead), hrs in by.items():
        spot = hrs[0]["spot"]
        o = {int(r["t"][11:13]): r["obs"] for r in hrs}
        if len(o) < 9:
            continue
        series = {}
        for mod, _ in DET:
            s = {int(r["t"][11:13]): r["cor"][method].get(mod) for r in hrs}
            s = {h: v for h, v in s.items() if v}
            if len(s) == len(o):
                series[mod] = s
        if BM not in series:
            continue
        hs = sorted(o)
        full = len(o) == len(HOURS)
        bests = []
        for mod, s in series.items():
            k = [s[h][0] if usable(s[h][1], spot) else 0 for h in hs]
            two = [(a + b) / 2 for h1, h2, a, b in zip(hs, hs[1:], k, k[1:]) if h2 == h1 + 1]
            if two:
                bests.append(max(two))
        go = p = None
        if len(bests) >= 2:
            bk, ek, cut = TUNING[lead]
            z = (statistics.mean(bests) - LO + bk) / math.sqrt(statistics.pstdev(bests) ** 2 + ek ** 2)
            p = phi(z)
            go = p >= cut
        out[(pid, day, lead)] = {"group": hrs[0]["group"], "lead": lead, "day": day, "obs": ride(o, spot), "p": p,
                                 "b2": (best2(series[BM], spot) - best2(o, spot)) if full else None, "go": go}
    return out


def go_stats(rows):
    g = [r for r in rows if r["go"]]
    ev = [r for r in rows if r["obs"]]
    true = sum(1 for r in g if r["obs"])
    return {"go": len(g), "true": true / len(g) if g else None, "wrong": len(g) - true,
            "caught": sum(1 for r in ev if r["go"]), "events": len(ev)}


def pc(x):
    return "–" if x is None else f"{100 * x:.0f} %"


def f1(x, sign=False):
    return "–" if x is None else (f"{x:+.1f}" if sign else f"{x:.1f}")


SHOW = ["raw", "bands", "scale", "qmap"]
CUTS = [x / 100 for x in range(30, 100)]


def equal_reliability(rows, target=0.85):
    """Go cut-off re-tuned per method so a Go came true >= target on the other weeks; scored on these."""
    out = []
    for par in (0, 1):
        tune = [r for r in rows if week_parity(r["day"]) != par and r["p"] is not None]
        cut = next((c for c in CUTS if (lambda s: len(s) >= 30 and sum(s) / len(s) >= target)(
            [r["obs"] for r in tune if r["p"] >= c])), 1.01)
        out += [dict(r, go=r["p"] >= cut) for r in rows if week_parity(r["day"]) == par and r["p"] is not None]
    return go_stats(out)


def main():
    sites = all_sites() + catalan_tests()
    recs = hourly(sites)
    s, q = sums(recs)
    apply(recs, s, q)
    days = {m: day_rows(recs, m) for m in SHOW}
    stations = sorted({(r["group"], r["st"]) for r in recs})
    fit_st = [st for g, st in stations if g in FIT_GROUPS]
    print("# WHE-80: one correction learned from measurements, the same at every spot\n")
    print(f"Hours 07–17 UTC, 2026-08-08 … 2026-10-30 (Catalan test to 10-25), days ahead 0–5 (buoys 0–2). "
          f"{len(recs)} station-hours × day ahead. Fitting stations: {len(fit_st)} ("
          + ", ".join(f"{g}: {sum(1 for gg, _ in stations if gg == g)}" for g in AREAS if g in FIT_GROUPS)
          + "). Every hour is corrected with numbers fitted on the other weeks and without its own station "
          f"(except 'station seen'). Speed-band shrink weight {K_SHRINK:.0f} h.\n")
    print("Methods: **speed bands** = add the mean miss for this model, day ahead, forecast speed band and direction "
          "vs the beach (classic MOS); **one factor** = multiply by measured ÷ forecast for this model, day ahead and "
          "direction; **quantile map** = map the forecast's place in its own spread to the same place in the measured "
          "spread (model, day ahead, direction).\n")

    def pooled(rs_filter, title):
        print(f"## {title}\n")
        print("Wind shown = best match, sea cell. MAE = mean absolute error, bias = forecast − measured (kn), Δ MAE 95 % = "
              "interval over dates. Kiteable hour = 12–28 kn not offshore: caught / false. Storm = hours measured 25 kn+ "
              "shown under 20 kn. Go = WHE-82 chance with its cut-offs unchanged: came true · wrong Go · real go days "
              "caught.\n")
        print("| Day ahead | Method | MAE | Δ MAE 95 % | MAE 10 kn+ | Bias | Kiteable caught | False | Storm read < 20 kn | "
              "Go came true | Wrong Go | Go days caught |")
        print("|---|---|---|---|---|---|---|---|---|---|---|---|")
        for lead in LEADS:
            rs = [r for r in recs if rs_filter(r["group"]) and r["lead"] == lead]
            if len(rs) < 200:
                continue
            for m in ["raw", "bands, weeks only"] + SHOW[1:] + ["own station"]:
                h = hour_stats(rs, m)
                ci = mae_ci(rs, m) if m != "raw" else None
                if m in days:
                    g = go_stats([v for v in days[m].values() if rs_filter(v["group"]) and v["lead"] == lead])
                    gc = f"{pc(g['true'])} | {g['wrong']} of {g['go']} | {g['caught']} of {g['events']}"
                else:
                    gc = " | | "
                print(f"| {lead} | {METHOD_NAME[m]} | **{f1(h['mae'])}** | {'' if not ci else f'{ci[0]:+.2f} … {ci[1]:+.2f}'} | "
                      f"{f1(h['windy'])} | {f1(h['bias'], 1)} | {pc(h['pod'])} | {pc(h['far'])} | {pc(h['storm_low'])} ({h['storm']} h) | {gc} |")
        print()

    pooled(lambda g: g in FIT_GROUPS, "All fitting stations (trusted masts + buoys)")

    print("## Go at equal reliability\n")
    print("Fair Go comparison: each method's Go cut-off re-tuned so a Go came true ≥ 85 % on the other weeks "
          "(pooled fitting stations), scored on the held-out weeks. Cells: came true · wrong Go · real go days caught.\n")
    print("| Day ahead | Real go days | " + " | ".join(METHOD_NAME[m] for m in SHOW) + " |")
    print("|---|---|" + "---|" * len(SHOW))
    for lead in LEADS:
        cells = []
        for m in SHOW:
            g = equal_reliability([v for v in days[m].values() if v["group"] in FIT_GROUPS and v["lead"] == lead])
            cells.append(f"{pc(g['true'])} · {g['wrong']} · **{g['caught']}**")
        print(f"| {lead} | {g['events']} | " + " | ".join(cells) + " |")
    print()

    print("## By area and day ahead\n")
    print("MAE and bias of the wind shown, best 2 h bias (best match), Go wrong / caught. Cells: today → speed bands / "
          "one factor / quantile map.\n")
    print("| Area | Day ahead | Hours | MAE | Bias | Best 2 h bias | Wrong Go | Go days caught (of) | Storm read < 20 kn |")
    print("|---|---|---|---|---|---|---|---|---|")
    for area in AREAS:
        for lead in LEADS:
            rs = [r for r in recs if r["group"] == area and r["lead"] == lead]
            if len(rs) < 200:
                continue
            hs = {m: hour_stats(rs, m) for m in SHOW}
            gs = {m: go_stats([v for v in days[m].values() if v["group"] == area and v["lead"] == lead]) for m in SHOW}
            b2 = {}
            for m in SHOW:
                xs = [v["b2"] for v in days[m].values() if v["group"] == area and v["lead"] == lead and v["b2"] is not None]
                b2[m] = statistics.mean(xs) if xs else None
            cell = lambda d, fmt: f"{fmt(d['raw'])} → " + " / ".join(fmt(d[m]) for m in SHOW[1:])
            print(f"| {area} | {lead} | {hs['raw']['n']} | {cell({m: hs[m]['mae'] for m in SHOW}, f1)} | "
                  f"{cell({m: hs[m]['bias'] for m in SHOW}, lambda x: f1(x, 1))} | {cell(b2, lambda x: f1(x, 1))} | "
                  f"{cell({m: gs[m]['wrong'] for m in SHOW}, str)} | {cell({m: gs[m]['caught'] for m in SHOW}, str)} "
                  f"({gs['raw']['events']}) | {cell({m: hs[m]['storm_low'] for m in SHOW}, pc)} |")
    print()

    print("## By station, day ahead 1 (MAE today → speed bands / one factor / quantile map)\n")
    print("| Area | Station | Hours | Bias today | MAE |")
    print("|---|---|---|---|---|")
    for area, st in stations:
        rs = [r for r in recs if r["st"] == st and r["group"] == area and r["lead"] == 1]
        if not rs:
            continue
        hs = {m: hour_stats(rs, m) for m in SHOW}
        print(f"| {area} | {rs[0]['pid']} | {hs['raw']['n']} | {f1(hs['raw']['bias'], 1)} | "
              f"{f1(hs['raw']['mae'])} → " + " / ".join(f1(hs[m]['mae']) for m in SHOW[1:]) + " |")
    print()

    # the tables themselves, fitted on everything
    tab = table(s, q, 0)
    tab1 = table(s, q, 1)
    print("## What each correction does to best match (fitted on all weeks pooled)\n")
    full = defaultdict(lambda: [0, 0.0, 0.0, 0.0])
    for ks in s.values():
        for k, v in ks.items():
            for i in range(4):
                full[k][i] += v[i]
    print("Speed bands, kn added (hours behind it):\n")
    print("| Day ahead | Direction | " + " | ".join(f"{BANDS[i]}–{BANDS[i + 1] if BANDS[i + 1] < 999 else '+'} kn"
                                             for i in range(len(BANDS) - 1)) + " | One factor |")
    print("|---|---|" + "---|" * len(BANDS))
    for lead in (0, 1, 3, 5):
        for dc in ("on", "cross", "off", "open"):
            cells = []
            for b in range(len(BANDS) - 1):
                n, e = full.get((BM, lead, b, dc), (0, 0.0))[:2]
                nc, ec = full.get((BM, lead, b), (0, 0.0))[:2]
                c = ec / (nc + K_SHRINK)
                cells.append(f"{(e + K_SHRINK * c) / (n + K_SHRINK):+.1f} ({n})" if n else "–")
            v = full.get((BM, lead, dc))
            print(f"| {lead} | {dc} | " + " | ".join(cells) + f" | ×{v[3] / v[2]:.2f} |" if v else " | – |")
    print()
    print("Quantile map, day ahead 1, onshore, even-week fit: forecast → corrected at 8 / 12 / 15 / 20 / 25 / 30 kn: "
          + ", ".join(f"{x} → {qmapped(*tab['qmap'][(BM, 1, 'on')], x):.1f}" for x in (8, 12, 15, 20, 25, 30)) + "\n")


if __name__ == "__main__":
    main()
