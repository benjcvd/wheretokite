"""Which forecast source is best for each day ahead, today to +5? (WHE-87)

Candidates, each read on the beach cell (cell_selection=land) and the sea cell (sea):
  best_match (today's app = best match, sea cell), meteofrance_seamless, meteofrance_arome_france_hd,
  meteofrance_arome_france, icon_seamless, icon_eu, ecmwf_ifs025, ecmwf_ifs (9 km), gfs_seamless,
  plus two blends: WHE-61 Option 1 (AROME HD + ICON beach cell, ECMWF sea cell, mean of what exists)
  and "mean of the best two" (the two single sources with the lowest best-2 h error on the OTHER
  ISO-week parity, so the pick never sees the days it is scored on).
A source that has no value at a spot or lead (AROME out of its domain or past its range) falls back
to today's best match on the sea cell: every candidate is a rule the app could run everywhere. The
coverage column says how often the named source really answered.

Forecast at day N = Open-Meteo Previous Runs `_previous_dayN` (day 0 = the latest run).
Truth (07-17 UTC, brought to 10 m): WHE-72 trusted masts (France, southern Spain, Canaries), POEM
near-shore buoy, Begur/Tarragona open-sea buoys, Barcelona airport (METAR) and Port Bocana Sud (Y7).
Catalan Meteocat masts are left out (they read ~half the forecast, WHE-84).

Per spot-day: best 2 h = highest mean of two consecutive hours of kiteable speed (0 when offshore);
go = two hours in a row 12-28 kn, not offshore (WHE-81 rule). Scores: bias and mean abs error of
the best 2 h, go days caught (of measured go days), false gos (of forecast go days), CSI = hits /
(hits + misses + false gos), one number that punishes both misses and dead-beach trips.
95 % intervals and gains vs today: bootstrap over whole dates (paired, same resample for both).

    python3 tools/backtest/whe87.py --fetch          # fill the cache (~4k weighted calls)
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe87.py > tools/backtest/results/whe87.md
"""
import argparse
import concurrent.futures as cf
import datetime as dt
import hashlib
import json
import os
import random
import statistics
import sys
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from chance import HOURS, LO, HI, ride, week_parity  # noqa: E402
from diag84 import START, END  # noqa: E402
from esfr_backtest import om, vmean  # noqa: E402
from model_backtest import months  # noqa: E402
from review import usable  # noqa: E402
from thresholds84 import all_sites, group_of  # noqa: E402

HERE = os.path.dirname(__file__)
LEADS = [0, 1, 2, 3, 4, 5]
MODELS = ["best_match", "meteofrance_seamless", "meteofrance_arome_france_hd", "meteofrance_arome_france",
          "icon_seamless", "icon_eu", "ecmwf_ifs025", "ecmwf_ifs", "gfs_seamless"]
SHORT = {"best_match": "best match", "meteofrance_seamless": "MF seamless", "meteofrance_arome_france_hd": "AROME HD",
         "meteofrance_arome_france": "AROME 2.5", "icon_seamless": "ICON seamless", "icon_eu": "ICON-EU",
         "ecmwf_ifs025": "ECMWF 25 km", "ecmwf_ifs": "ECMWF 9 km", "gfs_seamless": "GFS"}
CELLS = ["land", "sea"]
TODAY = ("best_match", "sea")
SINGLES = [(m, c) for m in MODELS for c in CELLS]
OPT1 = [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "sea")]
REPS = 1000
CACHE = os.path.join(HERE, ".cache")
REFUSED = set()


def name(src):
    if isinstance(src, str):
        return src
    return f"{SHORT[src[0]]}, {'beach' if src[1] == 'land' else 'sea'} cell"


# MARK: Data

def fetch(lat, lon, model, cell, start, end):
    """lead -> 'YYYY-MM-DDTHH' -> (kn, dir). Same request as chance.det_forecasts (cache hits)."""
    sufs = {0: ""} | {n: f"_previous_day{n}" for n in LEADS if n}
    vars_ = ",".join(f"{v}{s}" for s in sufs.values() for v in ("wind_speed_10m", "wind_direction_10m"))
    out = {n: {} for n in LEADS}
    for lo, hi in months(start, end):
        url = "https://previous-runs-api.open-meteo.com/v1/forecast"
        body = urllib.parse.urlencode({
            "latitude": f"{lat:.5f}", "longitude": f"{lon:.5f}", "hourly": vars_,
            "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
            "models": model, "cell_selection": cell})
        j = om(url, body)
        if "error" in j:
            # When overloaded (2 Nov) Open-Meteo answers "No data is available for this location"
            # for in-domain points too: never keep a refusal, it is retried on the next online run.
            path = os.path.join(CACHE, hashlib.sha1((url + body).encode()).hexdigest())
            if os.path.exists(path) and not os.environ.get("BACKTEST_OFFLINE"):
                os.remove(path)
            REFUSED.add((model, cell, f"{lat:.3f},{lon:.3f}"))
        h = j.get("hourly") or {}
        for n, suf in sufs.items():
            sp, d = h.get(f"wind_speed_10m{suf}") or [], h.get(f"wind_direction_10m{suf}") or []
            for t, a, b in zip(h.get("time", []), sp, d):
                if a is not None and b is not None and 7 <= int(t[11:13]) <= 17:
                    out[n][t[:13]] = (a, b)
    return out


def site_list():
    """(pair id, group, spot, obs, start, end)."""
    out = []
    for pid, spot, obs, _, _, kind in all_sites():
        g = group_of(pid)
        if g == "Catalonia masts (not trusted)":
            continue
        out.append((pid, g, spot, obs, START, END))
    import whe86
    from stations import load_spots
    spots = {s["id"]: s for s in load_spots()}
    for spid, sid in whe86.APP_PAIRS:
        st = whe86.station(sid, "metar" if sid == "LEBL" else "xema")
        obs, _ = whe86.obs10(st)
        out.append((f"{spid}|{sid}", "Barcelona (airport, Bocana Sud)", spots[spid], obs, whe86.START, whe86.END))
    return out


def all_forecasts(sites, workers):
    jobs = {(pid, src): (spot["latitude"], spot["longitude"], src[0], src[1], s, e)
            for pid, _, spot, _, s, e in sites for src in SINGLES}
    out = {}
    with cf.ThreadPoolExecutor(workers) as ex:
        futs = {ex.submit(fetch, *a): k for k, a in jobs.items()}
        for i, f in enumerate(cf.as_completed(futs)):
            out[futs[f]] = f.result()
            if i % 50 == 0:
                print(f"  {i}/{len(jobs)} series", file=sys.stderr)
    return out


# MARK: Spot-day rows

def best2(series, spot):
    """Best 2 h mean of the kiteable speed over consecutive hours present (0 when offshore)."""
    k = {h: (series[h][0] if usable(series[h][1], spot) else 0) for h in HOURS if h in series}
    pairs = [(k[h] + k[h + 1]) / 2 for h in HOURS[:-1] if h in k and h + 1 in k]
    return max(pairs) if pairs else None


def rows_for(sites, fc):
    rows = []
    for pid, g, spot, obs, s, e in sites:
        d0, d1 = dt.date.fromisoformat(s), dt.date.fromisoformat(e)
        day = d0
        while day <= d1:
            ds = day.isoformat()
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            day += dt.timedelta(days=1)
            if len(o) < 9:
                continue
            ob2 = best2(o, spot)
            for lead in LEADS:
                ser = {}
                for src in SINGLES:
                    x = {h: fc[(pid, src)][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                    if all(x.values()):
                        ser[src] = x
                if TODAY not in ser:
                    continue
                rows.append({"pair": pid, "group": g, "spot": spot, "day": ds, "lead": lead,
                             "obs": ride(o, spot), "ob2": ob2, "ser": ser})
    return rows


def blend(ser, members):
    got = [ser[m] for m in members if m in ser]
    if not got:
        return None
    return {h: vmean([s[h] for s in got]) for h in HOURS}


def predict(r, cand):
    """(go, best 2 h, answered by the named source) for candidate cand on row r."""
    ser = r["ser"]
    if isinstance(cand, tuple):
        s, own = (ser[cand], True) if cand in ser else (ser[TODAY], False)
    else:
        members = OPT1 if cand == "Option 1 mix" else r["best_two"]
        s = blend(ser, members)
        own = s is not None and all(m in ser for m in members)
        s = s or ser[TODAY]
    return ride(s, r["spot"]), best2(s, r["spot"]), own


# MARK: Scores

def metrics(recs):
    """recs: (obs go, fc go, fc b2, obs b2). -> dict."""
    hits = sum(1 for o, f, _, _ in recs if o and f)
    miss = sum(1 for o, f, _, _ in recs if o and not f)
    fa = sum(1 for o, f, _, _ in recs if f and not o)
    err = [f2 - o2 for _, _, f2, o2 in recs if f2 is not None and o2 is not None]
    return {"n": len(recs), "bias": statistics.mean(err) if err else None,
            "mae": statistics.mean(abs(x) for x in err) if err else None,
            "pod": hits / (hits + miss) if hits + miss else None,
            "far": fa / (hits + fa) if hits + fa else None,
            "csi": hits / (hits + miss + fa) if hits + miss + fa else None,
            "obs_go": hits + miss, "fc_go": hits + fa}


def by_date(rows, cand):
    out = {}
    for r in rows:
        go, b2, own = r["pred"][cand]
        out.setdefault(r["day"], []).append((r["obs"], go, b2, r["ob2"]))
    return out


def boot(bd_a, bd_b, keys=("bias", "mae", "pod", "far", "csi"), seed=11):
    """95 % intervals of metric(a) and of metric(a) - metric(b), resampling whole dates."""
    dates = sorted(bd_a)
    rng = random.Random(seed)
    sa, sd = {k: [] for k in keys}, {k: [] for k in keys}
    for _ in range(REPS):
        pick = [rng.choice(dates) for _ in dates]
        ma = metrics([x for d in pick for x in bd_a[d]])
        mb = metrics([x for d in pick for x in bd_b[d]])
        for k in keys:
            if ma[k] is not None and mb[k] is not None:
                sa[k].append(ma[k])
                sd[k].append(ma[k] - mb[k])
    q = lambda xs: (sorted(xs)[int(0.025 * len(xs))], sorted(xs)[int(0.975 * len(xs)) - 1]) if xs else (None, None)
    return {k: q(v) for k, v in sa.items()}, {k: q(v) for k, v in sd.items()}


def pick_best_two(rows):
    """lead -> parity -> the two single sources with the lowest best-2 h MAE on the other parity."""
    out = {}
    for lead in LEADS:
        for par in (0, 1):
            fit = [r for r in rows if r["lead"] == lead and week_parity(r["day"]) != par]
            score = []
            for src in SINGLES:
                errs = []
                for r in fit:
                    s = r["ser"].get(src)
                    if s is None:
                        break   # must answer everywhere to be a blend member
                    b = best2(s, r["spot"])
                    if b is not None and r["ob2"] is not None:
                        errs.append(abs(b - r["ob2"]))
                else:
                    if errs:
                        score.append((statistics.mean(errs), src))
            score.sort()
            out[(lead, par)] = [s for _, s in score[:2]]
    return out


# MARK: Report

def f1(x, sign=False):
    return "–" if x is None else (f"{x:+.1f}" if sign else f"{x:.1f}")


def pc(x, sign=False):
    return "–" if x is None else (f"{100 * x:+.0f}" if sign else f"{100 * x:.0f} %")


def iv(t, pct=False):
    if t[0] is None:
        return ""
    return f" ({pc(t[0], True)}…{pc(t[1], True)})" if pct else f" ({t[0]:+.1f}…{t[1]:+.1f})"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fetch", action="store_true", help="only fill the cache")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--drop", default="", help="comma-separated groups to leave out (robustness check)")
    a = ap.parse_args()
    sites = site_list()
    drop = {x for x in a.drop.split(",") if x}
    sites = [s for s in sites if s[1] not in drop]
    fc = all_forecasts(sites, a.workers)
    if a.fetch:
        by = {}
        for m, c, _ in REFUSED:
            by[(m, c)] = by.get((m, c), 0) + 1
        print("refused (model, cell): sites", sorted(by.items()), file=sys.stderr)
        return
    rows = rows_for(sites, fc)
    picks = pick_best_two(rows)
    for r in rows:
        r["best_two"] = picks[(r["lead"], week_parity(r["day"]))]
    cands = SINGLES + ["Option 1 mix", "Mean of best two"]
    for r in rows:
        r["pred"] = {c: predict(r, c) for c in cands}

    print(f"# WHE-87: best forecast source for each day ahead, {START} … {END}\n")
    print(f"{len(sites)} truth sites, {len({r['day'] for r in rows})} dates. Groups: "
          + ", ".join(f"{g} {sum(1 for s in sites if s[1] == g)}" for g in sorted({s[1] for s in sites})) + ".")
    if drop:
        print(f"\n**Left out: {', '.join(sorted(drop))}.**")
    print("\nCoverage = share of spot-days where the named source answered (else best match, sea cell).")
    print("Gains vs today = candidate minus today (best match, sea cell); 95 % interval over dates. "
          "MAE gain < 0 is better; caught/CSI gain > 0 better; false-go gain < 0 better.\n")

    summary = []
    for lead in LEADS:
        lr = [r for r in rows if r["lead"] == lead]
        if not lr:
            continue
        bt = by_date(lr, TODAY)
        mt = metrics([x for v in bt.values() for x in v])
        print(f"\n## Day ahead {lead} — {len(lr)} spot-days, {len(bt)} dates, {mt['obs_go']} measured go days\n")
        bp = sorted({tuple(picks[(lead, p)]) for p in (0, 1)})
        print("Mean of best two picked: " + " / ".join(" + ".join(name(s) for s in p) for p in bp) + "\n")
        print("| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |")
        print("|---|---|---|---|---|---|---|---|---|---|---|")
        res = []
        for c in cands:
            bd = by_date(lr, c)
            m = metrics([x for v in bd.values() for x in v])
            cov = sum(1 for r in lr if r["pred"][c][2]) / len(lr)
            ci, dci = boot(bd, bt)
            res.append((c, m, cov, ci, dci))
        res.sort(key=lambda x: -(x[1]["csi"] or 0))
        for c, m, cov, ci, dci in res:
            today = c == TODAY
            print(f"| {'**' if today else ''}{name(c)}{'** (today)' if today else ''} | {pc(cov)} | {f1(m['bias'], True)}"
                  f" | {f1(m['mae'])} | {'' if today else f1(m['mae'] - mt['mae'], True) + iv(dci['mae'])}"
                  f" | {pc(m['pod'])} | {'' if today else pc(m['pod'] - mt['pod'], True) + iv(dci['pod'], True)}"
                  f" | {pc(m['far'])} | {'' if today else pc(m['far'] - mt['far'], True) + iv(dci['far'], True)}"
                  f" | {f1(100 * m['csi'])} | {'' if today else pc(m['csi'] - mt['csi'], True) + iv(dci['csi'], True)} |")
        summary.append((lead, res, mt))

    print("\n## Summary: winner per day ahead\n")
    print("Winner = highest CSI among sources (and mixes) that answered themselves on ≥ 90 % of spot-days; "
          "'real' when its CSI gain interval excludes 0.\n")
    print("| Day ahead | Today: CSI / MAE / bias | Best on CSI | CSI gain | MAE gain | Real? | Best on MAE | MAE gain |")
    print("|---|---|---|---|---|---|---|---|")
    for lead, res, mt in summary:
        live = [x for x in res if x[2] >= 0.9 or x[0] == TODAY]
        best = live[0]
        bm = min(live, key=lambda x: x[1]["mae"])
        real = best[4]["csi"][0] is not None and best[4]["csi"][0] > 0
        print(f"| {lead} | {100 * mt['csi']:.0f} / {mt['mae']:.1f} / {mt['bias']:+.1f} | {name(best[0])}"
              f" | {pc(best[1]['csi'] - mt['csi'], True)}{iv(best[4]['csi'], True)}"
              f" | {f1(best[1]['mae'] - mt['mae'], True)} | {'yes' if real else 'no (tie)'}"
              f" | {name(bm[0])} | {f1(bm[1]['mae'] - mt['mae'], True)}{iv(bm[4]['mae'])} |")

    print("\n## Per group, top 3 on CSI and today\n")
    for lead in LEADS:
        print(f"\n### Day ahead {lead}\n")
        print("| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |")
        print("|---|---|---|---|---|---|---|")
        for g in sorted({r["group"] for r in rows}):
            gr = [r for r in rows if r["lead"] == lead and r["group"] == g]
            if not gr:
                continue
            ms = []
            for c in cands:
                m = metrics([x for v in by_date(gr, c).values() for x in v])
                ms.append((c, m))
            mt = dict(ms)[TODAY]
            ms.sort(key=lambda x: -(x[1]["csi"] or 0))
            cell = lambda c, m: f"{name(c)} {100 * (m['csi'] or 0):.0f} / {f1(m['mae'])} / {f1(m['bias'], True)}"
            print(f"| {g} | {len(gr)} | {mt['obs_go']} | {100 * (mt['csi'] or 0):.0f} / {f1(mt['mae'])} / {f1(mt['bias'], True)} | "
                  + " | ".join(cell(c, m) for c, m in ms[:3]) + " |")


if __name__ == "__main__":
    main()
