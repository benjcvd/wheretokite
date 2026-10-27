"""Compare a saved forecast snapshot (snapshot_day.py) with what the Meteocat stations measured
that day (WHE-60). One day is an example, not evidence: read it next to review.py.

    python3 tools/backtest/check_day.py tools/backtest/snapshot_2026-10-28.json
"""
import json
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import xema  # noqa: E402
from review import to_10m, best2h  # noqa: E402

# Spot -> nearest Meteocat station (all a few km inland: read the level with care).
STATIONS = {
    # Torroella de Montgrí (UE) has no anemometer: Palafrugell is the nearest wind mast.
    "es-pals": "YP",                       # Palafrugell, 10 km, 35 m up
    "es-l-estartit-gola-del-ter": "YP",    # 15 km: weak
    "es-sant-pere-pescador": "U2",         # 1.3 km
    "es-sant-marti-d-empuries": "U2",      # 6 km
    "es-l-escala-platja-dels-riells": "U2",
    "es-palamos-la-fosca": "YP",           # Palafrugell, 6 km, 35 m up
}
HOURS = range(11, 18)   # UTC, the afternoon slot


def main():
    snap = json.load(open(sys.argv[1]))
    day = snap["day"]
    cache = {}
    for sid, s in snap["spots"].items():
        st = STATIONS.get(sid)
        if not st:
            continue
        if st not in cache:
            cache[st] = xema(st, day, day)
        obs, height = cache[st]
        o = [to_10m(obs[f"{day}T{h:02d}"][0], height) if f"{day}T{h:02d}" in obs else None for h in HOURS]
        print(f"\n### {s['name']} (station {st}, {height} m → 10 m)\n")
        print("| Setup | " + " | ".join(f"{h} UTC" for h in HOURS) + " | Best 2 h | Mean error |")
        print("|---" * (len(HOURS) + 3) + "|")
        print("| Measured | " + " | ".join("–" if v is None else f"{v:.0f}" for v in o) + f" | {best2h(o) or 0:.0f} | |")
        for label, series in s["forecast_utc"].items():
            f = [series.get(f"{day}T{h:02d}") for h in HOURS]
            err = [a - b for a, b in zip(f, o) if a is not None and b is not None]
            me = f"{statistics.mean(err):+.1f}" if err else "–"
            print(f"| {label} | " + " | ".join("–" if v is None else f"{v:.0f}" for v in f) + f" | {best2h(f) or 0:.0f} | {me} |")


if __name__ == "__main__":
    main()
