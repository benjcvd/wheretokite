"""Second look at the WHE-58 recommendation, scored the way riders use the app (WHE-61).

What it adds to model_backtest.py:
- lead time: Open-Meteo's Previous Runs API, so day 1 and day 2 forecasts, not only each
  run's first hours;
- the level as the app shows it: no bias removed, station readings at 2 m or 6 m brought to
  10 m with a log wind profile;
- rider scores: kiteable hours (12 / 15 kn+, not offshore), the best 2 h window of each day
  and "go days" (best 2 h window at 12 / 15 kn+);
- per-model grid cell (ECMWF on the sea cell, the others on land) and two-model blends;
- 95 % intervals from a bootstrap over days (all spots of a day stay together, since
  neighbouring hours and neighbouring spots share the same weather).

    python3 tools/backtest/review.py --start 2026-07-01 --end 2026-10-25 > /tmp/review.md

Downloads are cached in tools/backtest/.cache/ like model_backtest.py.
"""
import argparse
import json
import math
import os
import random
import statistics
import sys
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import fetch, months, xema, meteofrance, angle  # noqa: E402

MODELS = ["meteofrance_arome_france_hd", "meteofrance_arome_france", "icon_seamless", "ecmwf_ifs025", "best_match"]
SHORT = {"meteofrance_arome_france_hd": "AROME 1.3", "meteofrance_arome_france": "AROME 2.5",
         "icon_seamless": "ICON", "ecmwf_ifs025": "ECMWF", "best_match": "best match"}
LEADS = {0: "", 1: "_previous_day1", 2: "_previous_day2"}
DAY_UTC = range(7, 18)
Z0 = 0.03   # roughness of open flat land (m), for the 2 m / 6 m → 10 m correction

# Setups: name -> (kind, [(model, cell)]). "mean" averages the models available that hour,
# as the app does (Blend.hour), so AROME 1.3 dropping out past its range changes the mix.
SETUPS = {
    "Old: best match, sea cell": ("mean", [("best_match", "sea")]),
    "New: mean AROME 1.3+ICON+ECMWF, land": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "land")]),
    "Best match, land": ("mean", [("best_match", "land")]),
    "AROME 1.3, land": ("mean", [("meteofrance_arome_france_hd", "land")]),
    "AROME 2.5, land": ("mean", [("meteofrance_arome_france", "land")]),
    "ICON, land": ("mean", [("icon_seamless", "land")]),
    "ECMWF, land": ("mean", [("ecmwf_ifs025", "land")]),
    "ECMWF, sea": ("mean", [("ecmwf_ifs025", "sea")]),
    "Mean AROME 1.3+ICON, land": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land")]),
    "Mean AROME 1.3+ICON land, ECMWF sea": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "sea")]),
    "Median AROME 1.3+ICON+ECMWF, land": ("median", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "land")]),
}


def to_10m(kn, height):
    if height in (None, 10):
        return kn
    return kn * math.log(10 / Z0) / math.log(height / Z0)


def previous_runs(lat, lon, start, end, cell):
    """model -> lead -> hour -> (speed kn, direction). Month by month (long ranges time out)."""
    vars_ = [f"{v}{suffix}" for v in ("wind_speed_10m", "wind_direction_10m") for suffix in LEADS.values()]
    out = {m: {l: {} for l in LEADS} for m in MODELS}
    for lo, hi in months(start, end):
        body = urllib.parse.urlencode({
            "latitude": f"{lat:.4f}", "longitude": f"{lon:.4f}", "hourly": ",".join(vars_),
            "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
            "models": ",".join(MODELS), "cell_selection": cell,
        })
        j = json.loads(fetch("https://previous-runs-api.open-meteo.com/v1/forecast", body))
        if "hourly" not in j:
            sys.exit(f"Open-Meteo: {j}")
        h = j["hourly"]
        hrs = [t[:13] for t in h["time"]]
        for m in MODELS:
            for lead, suffix in LEADS.items():
                s = h.get(f"wind_speed_10m{suffix}_{m}") or []
                d = h.get(f"wind_direction_10m{suffix}_{m}") or []
                for i, t in enumerate(hrs):
                    if i < len(s) and s[i] is not None and d[i] is not None:
                        out[m][lead][t] = (s[i], d[i])
    return out


def combine(kind, members, fc, lead, hour):
    vals = [fc[cell][m][lead][hour] for m, cell in members if hour in fc[cell][m][lead]]
    if not vals:
        return None
    speeds = [s for s, _ in vals]
    sp = statistics.median(speeds) if kind == "median" else statistics.mean(speeds)
    u = sum(s * math.sin(math.radians(d)) for s, d in vals)
    v = sum(s * math.cos(math.radians(d)) for s, d in vals)
    return sp, math.degrees(math.atan2(u, v)) % 360, len(vals)


def usable(direction, spot):
    """Not offshore: the app flags 'offshore component' from 100° off the sea-facing side.
    Lagoons and spots with two sides: any direction."""
    if spot.get("waterType") == "lagoon" or spot.get("sides") or direction is None:
        return True
    return angle(direction, spot["seaFacingDeg"]) < 100


def best2h(series):
    """Highest mean of two consecutive daylight hours, or None."""
    best = None
    for i in range(len(series) - 1):
        a, b = series[i], series[i + 1]
        if a is not None and b is not None:
            best = max(best or -1, (a + b) / 2)
    return best


def collect(pairs, spots, start, end):
    """rows: one per (pair, day, hour, setup, lead) with forecast and measured wind."""
    hours = []   # (pair, day, hour, obs_kn, obs_dir, {(setup, lead): (kn, dir, n)})
    for p in pairs:
        spot = spots[p["spot"]]
        if p["source"] == "xema":
            obs, height = xema(p["station"], start, end)
        else:
            obs, height = meteofrance(p["dept"], p["station"], start, end)
        fc = {cell: previous_runs(spot["latitude"], spot["longitude"], start, end, cell) for cell in ("land", "sea")}
        print(f"{spot['name']}: {len(obs)} h measured at {p['station']} ({height} m)", file=sys.stderr)
        for h, (kn, d) in obs.items():
            if int(h[11:13]) not in DAY_UTC:
                continue
            f = {}
            for name, (kind, members) in SETUPS.items():
                for lead in LEADS:
                    c = combine(kind, members, fc, lead, h)
                    if c:
                        f[(name, lead)] = c
            hours.append({"pair": p["spot"], "spot": spot, "day": h[:10], "hour": h, "obs": to_10m(kn, height),
                          "obs_raw": kn, "dir": d, "height": height, "fc": f})
    return hours


def hour_stats(hs, key, thr):
    pts = [(x["fc"][key], x) for x in hs if key in x["fc"]]
    if len(pts) < 50:
        return None
    err = [f[0] - x["obs"] for f, x in pts]
    hit = miss = false = 0
    for f, x in pts:
        o_k = x["obs"] >= thr and usable(x["dir"], x["spot"])
        f_k = f[0] >= thr and usable(f[1], x["spot"])
        hit += o_k and f_k
        miss += o_k and not f_k
        false += f_k and not o_k
    dirs = [angle(f[1], x["dir"]) for f, x in pts if x["obs"] >= 8 and x["dir"] is not None]
    return {"n": len(pts), "bias": statistics.mean(err), "mae": statistics.mean(abs(e) for e in err),
            "pod": hit / (hit + miss) if hit + miss else None,
            "far": false / (hit + false) if hit + false else None,
            "csi": hit / (hit + miss + false) if hit + miss + false else None,
            "dir": statistics.mean(dirs) if dirs else None, "obs_k": hit + miss}


def days_of(hs, key):
    """(pair, day) -> (forecast best 2 h, measured best 2 h), on hours with both."""
    by = {}
    for x in hs:
        by.setdefault((x["pair"], x["day"]), {})[int(x["hour"][11:13])] = x
    out = {}
    for k, hrs in by.items():
        f = [hrs[h]["fc"][key][0] if h in hrs and key in hrs[h]["fc"] else None for h in DAY_UTC]
        o = [hrs[h]["obs"] if h in hrs and key in hrs[h]["fc"] else None for h in DAY_UTC]
        fb, ob = best2h(f), best2h(o)
        if fb is not None and ob is not None and sum(v is not None for v in o) >= 8:
            out[k] = (fb, ob)
    return out


def day_stats(d, thr):
    if len(d) < 20:
        return None
    hit = sum(1 for f, o in d.values() if f >= thr and o >= thr)
    miss = sum(1 for f, o in d.values() if f < thr <= o)
    false = sum(1 for f, o in d.values() if f >= thr > o)
    return {"n": len(d), "bias": statistics.mean(f - o for f, o in d.values()),
            "mae": statistics.mean(abs(f - o) for f, o in d.values()),
            "pod": hit / (hit + miss) if hit + miss else None,
            "far": false / (hit + false) if hit + false else None,
            "csi": hit / (hit + miss + false) if hit + miss + false else None, "obs_go": hit + miss}


def bootstrap(hs, key_a, key_b, thr, reps=1000, seed=1):
    """95 % interval of (B − A) for best-2 h MAE and go-day CSI, resampling whole dates."""
    da, db = days_of(hs, key_a), days_of(hs, key_b)
    common = sorted(set(da) & set(db))
    dates = sorted({d for _, d in common})
    by_date = {}
    for k in common:
        by_date.setdefault(k[1], []).append(k)
    rng = random.Random(seed)
    diffs_mae, diffs_csi = [], []

    def csi(sample):
        hit = sum(1 for f, o in sample if f >= thr and o >= thr)
        bad = sum(1 for f, o in sample if (f >= thr) != (o >= thr))
        return hit / (hit + bad) if hit + bad else 0

    for _ in range(reps):
        ks = [k for d in (rng.choice(dates) for _ in dates) for k in by_date[d]]
        a = [da[k] for k in ks]
        b = [db[k] for k in ks]
        diffs_mae.append(statistics.mean(abs(f - o) for f, o in b) - statistics.mean(abs(f - o) for f, o in a))
        diffs_csi.append(csi(b) - csi(a))
    q = lambda xs: (sorted(xs)[int(0.025 * len(xs))], sorted(xs)[int(0.975 * len(xs))])
    return len(dates), q(diffs_mae), q(diffs_csi)


def fmt(x, f="{:.1f}"):
    return "–" if x is None else f.format(x)


def pct(x):
    return "–" if x is None else f"{x * 100:.0f} %"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-07-01")
    ap.add_argument("--end", default="2026-10-25")
    ap.add_argument("--pairs", default=os.path.join(os.path.dirname(__file__), "pairs.json"))
    ap.add_argument("--drop", action="append", default=[], help="leave out this spot id (robustness)")
    a = ap.parse_args()
    spots = json.load(open("Data/spots.json"))
    spots = {s["id"]: s for s in (spots["spots"] if isinstance(spots, dict) else spots)}
    pairs = [p for p in json.load(open(a.pairs)) if p["spot"] not in a.drop]
    hs = collect(pairs, spots, a.start, a.end)

    print(f"# Review {a.start} … {a.end}, {len(pairs)} spots, {len({x['day'] for x in hs})} days\n")
    print("Measured wind brought to 10 m (log profile, z0 = 3 cm). Daylight 07–17 UTC. No bias removed.\n")
    for lead in LEADS:
        print(f"## Day {lead} ahead\n")
        print("| Setup | Hours | Bias | Error | Kiteable 12 kn+ caught | false alarms | 15 kn+ caught | false alarms | "
              "Best 2 h bias | Best 2 h error | Go days 12+ caught | false | Go days 15+ caught | false | Direction error |")
        print("|---" * 16 + "|")
        for name in SETUPS:
            key = (name, lead)
            h12, h15 = hour_stats(hs, key, 12), hour_stats(hs, key, 15)
            if not h12:
                continue
            d = days_of(hs, key)
            d12, d15 = day_stats(d, 12), day_stats(d, 15)
            print(f"| {name} | {h12['n']} | {fmt(h12['bias'], '{:+.1f}')} | {fmt(h12['mae'])} | {pct(h12['pod'])} | {pct(h12['far'])} | "
                  f"{pct(h15['pod'])} | {pct(h15['far'])} | {fmt(d12 and d12['bias'], '{:+.1f}')} | {fmt(d12 and d12['mae'])} | "
                  f"{pct(d12 and d12['pod'])} | {pct(d12 and d12['far'])} | {pct(d15 and d15['pod'])} | {pct(d15 and d15['far'])} | "
                  f"{fmt(h12['dir'], '{:.0f}°')} |")
        obs12 = hour_stats(hs, ("Old: best match, sea cell", lead), 12)
        if obs12:
            print(f"\nMeasured kiteable hours (12 kn+, not offshore): {obs12['obs_k']}.\n")

    print("## Is the difference real? (best 2 h window, 95 % interval over days)\n")
    print("| Compared with old setup | Lead | Days | Change in best 2 h error (kn) | Change in go-day score 12 kn (CSI) |")
    print("|---|---|---|---|---|")
    base = "Old: best match, sea cell"
    for name in ("New: mean AROME 1.3+ICON+ECMWF, land", "Best match, land", "Mean AROME 1.3+ICON, land",
                 "Mean AROME 1.3+ICON land, ECMWF sea", "AROME 1.3, land"):
        for lead in LEADS:
            try:
                n, (m_lo, m_hi), (c_lo, c_hi) = bootstrap(hs, (base, lead), (name, lead), 12)
            except (ValueError, IndexError, statistics.StatisticsError):
                continue
            print(f"| {name} | {lead} | {n} | {m_lo:+.2f} … {m_hi:+.2f} | {c_lo:+.2f} … {c_hi:+.2f} |")

    print("\n## Per spot, day 1 ahead, best 2 h window bias (kn)\n")
    names = ["Old: best match, sea cell", "New: mean AROME 1.3+ICON+ECMWF, land", "Best match, land",
             "Mean AROME 1.3+ICON, land", "Mean AROME 1.3+ICON land, ECMWF sea", "ECMWF, land"]
    print("| Spot (station, height) | Days | " + " | ".join(names) + " |")
    print("|---" * (len(names) + 2) + "|")
    for p in pairs:
        sub = [x for x in hs if x["pair"] == p["spot"]]
        if not sub:
            continue
        cells = []
        n = 0
        for name in names:
            d = day_stats(days_of(sub, (name, 1)), 12)
            n = max(n, d["n"] if d else 0)
            cells.append(fmt(d and d["bias"], "{:+.1f}"))
        print(f"| {spots[p['spot']]['name']} ({p['station']}, {sub[0]['height']} m) | {n} | " + " | ".join(cells) + " |")


if __name__ == "__main__":
    main()
