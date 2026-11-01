"""Why does a forecast Go come true so rarely in mainland Spain? Station by station (WHE-84).

For each WHE-81 truth pair (shore masts a/a2 + POEM buoy), day-ahead (lead 1) forecasts:
  - level: mean best 2 h (07-17 UTC, usable direction) forecast vs measured, and the same with
    direction ignored
  - timing: hour of the afternoon peak, forecast vs measured, and the diurnal mean profiles
  - go days: measured, forecast (best match and the 4-model mean), and how many measured
    near-misses are blocked by the direction rule or the 12 kn bar
  - height: the 10 m correction factor applied to the mast reading

    python3 tools/backtest/diag84.py > tools/backtest/results/whe84_diag.md
"""
import json
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
from chance import sites, HOURS, DET, ride, best2, LO  # noqa: E402
from esfr_backtest import BM  # noqa: E402
from review import usable  # noqa: E402
from stations import observations  # noqa: E402

START, END = "2026-08-08", "2026-10-30"
HERE = os.path.dirname(__file__)


def raw_b2(series):
    k = [series[h][0] for h in HOURS if h in series]
    return max((a + b) / 2 for a, b in zip(k, k[1:])) if len(k) == len(HOURS) else None


def open_sea_buoys():
    """Begur and Tarragona open-sea buoys (WHE-62), read with review.previous_runs on the same monthly
    windows WHE-62 used (cache hits). Any direction counts at sea. AROME 1.3 stands in for Météo-France
    seamless (same model at these leads)."""
    from buoys import BUOYS, read_buoy, to_10m_sea
    from review import previous_runs
    out = []
    for bid in ("6100196", "6100280"):
        b = BUOYS[bid]
        obs, pos = read_buoy(b["prefix"], START, END)
        if not obs:
            continue
        obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
        pr = {cell: previous_runs(pos[0], pos[1], "2026-08-01", "2026-10-31", cell) for cell in ("sea", "land")}
        fc = {}
        for m, cell in DET:
            src = "meteofrance_arome_france_hd" if m == "meteofrance_seamless" else m
            fc[(m, cell)] = {l: pr[cell][src].get(l, {}) for l in (0, 1, 2)}
        spot = {"id": bid, "latitude": pos[0], "longitude": pos[1], "waterType": "lagoon", "seaFacingDeg": None}
        out.append((f"buoy-{bid}|{bid}", spot, obs, fc, None, "openbuoy"))
    return out


def wh62_forecasts(lat, lon):
    """Same layout as chance.det_forecasts, from WHE-62's cached review.previous_runs requests."""
    from review import previous_runs
    pr = {cell: previous_runs(lat, lon, "2026-08-01", "2026-10-31", cell) for cell in ("sea", "land")}
    return {(m, cell): {l: pr[cell]["meteofrance_arome_france_hd" if m == "meteofrance_seamless" else m].get(l, {})
                        for l in (0, 1, 2)} for m, cell in DET}


def main():
    lead = int(os.environ.get("LEAD", "1"))
    pairs = {f"{p['spot']}|{p['station']['id']}": p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json")))}
    out = []
    for pid, spot, obs, fc, ekey, kind in sites(START, END, True) + open_sea_buoys():
        p = pairs.get(pid)
        if kind == "buoy" and not fc[(BM, "sea")][1]:
            fc = wh62_forecasts(spot["latitude"], spot["longitude"])
        height = observations(p["station"], START, END)[1] if p else 3
        days = sorted({h[:10] for h in obs})
        rec = {"pair": pid, "kind": kind, "height": height, "facing": spot.get("seaFacingDeg"),
               "station": p["station"]["name"] if p else "POEM buoy", "km": p["km"] if p else None,
               "src": p["station"]["source"] if p else "buoy", "days": []}
        prof_o = {h: [] for h in range(24)}
        prof_f = {h: [] for h in range(24)}
        for ds in days:
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            for h in range(24):
                t = f"{ds}T{h:02d}"
                if t in obs and t in fc[(BM, "sea")][lead]:
                    prof_o[h].append(obs[t][0])
                    prof_f[h].append(fc[(BM, "sea")][lead][t][0])
            if len(o) < 9:
                continue
            det = {}
            for m, cell in DET:
                s = {h: fc[(m, cell)][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                s = {h: v for h, v in s.items() if v}
                if len(s) == len(HOURS):
                    det[m] = s
            if BM not in det:
                continue
            ofull = len(o) == len(HOURS)
            d = {"day": ds, "obs_go": ride(o, spot), "obs_go10": ride(o, spot, 10),
                 "obs_go_anydir": ride({h: (k, None) for h, (k, _) in o.items()}, spot),
                 "obs_b2": best2(o, spot) if ofull else None, "obs_raw": raw_b2(o) if ofull else None,
                 "obs_peak": max(o, key=lambda h: o[h][0]),
                 "obs_dir_usable": statistics.mean(1 if usable(dd, spot) else 0 for _, dd in o.values()),
                 "fc": {m: {"go": ride(s, spot), "b2": best2(s, spot), "raw": raw_b2(s),
                            "peak": max(s, key=lambda h: s[h][0])} for m, s in det.items()},
                 "fc_dir_obs_dir": [(det[BM][h][1], o[h][1], o[h][0], det[BM][h][0]) for h in o if h in det[BM]]}
            rec["days"].append(d)
        rec["prof_o"] = {h: statistics.mean(v) if v else None for h, v in prof_o.items()}
        rec["prof_f"] = {h: statistics.mean(v) if v else None for h, v in prof_f.items()}
        out.append(rec)
    json.dump(out, open(os.path.join(HERE, ".cache", f"whe84_diag_l{lead}.json"), "w"))
    print(f"saved {len(out)} pairs", file=sys.stderr)


if __name__ == "__main__":
    main()
