"""Day-by-day check of the forecast setups against Meteocat stations, rebuilt from Open-Meteo's
Previous Runs archive (the forecast as it stood 1 day and 2 days before), for days after the
backtest window. Use it when no live snapshot exists or the stations missed the snapshot day
(WHE-60: Meteocat's open feed has no data for 27-29 Oct 2026). One day is an example, not
evidence: read it next to review.py.

    python3 tools/backtest/check_recent.py 2026-10-26 2026-10-30
"""
import json
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import xema  # noqa: E402
from review import to_10m, best2h, previous_runs, combine  # noqa: E402
from check_day import STATIONS, HOURS  # noqa: E402

SETUPS = {
    "Old: best match, offshore cell": ("mean", [("best_match", "sea")]),
    "New (WHE-58): AROME+ICON+ECMWF, beach cell": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "land")]),
    "WHE-61 pick: AROME+ICON beach, ECMWF offshore": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"), ("ecmwf_ifs025", "sea")]),
    "AROME+ICON, beach cell": ("mean", [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land")]),
}
NAMES = {
    "es-pals": "Pals", "es-l-estartit-gola-del-ter": "L'Estartit", "es-sant-pere-pescador": "Sant Pere Pescador",
    "es-sant-marti-d-empuries": "Sant Martí d'Empúries", "es-l-escala-platja-dels-riells": "L'Escala",
    "es-palamos-la-fosca": "Palamós",
}


def cell(v):
    return "–" if v is None else f"{v:.0f}"


def main():
    days = sys.argv[1:]
    spots = json.load(open("Data/spots.json"))
    spots = {s["id"]: s for s in (spots["spots"] if isinstance(spots, dict) else spots)}
    lo, hi = min(days), max(days)
    obs_cache = {}
    for sid, st in STATIONS.items():
        s = spots[sid]
        if st not in obs_cache:
            obs_cache[st] = xema(st, lo, hi)
        obs, height = obs_cache[st]
        fc = {c: previous_runs(s["latitude"], s["longitude"], lo, hi, c) for c in ("land", "sea")}
        for day in days:
            o = [to_10m(obs[f"{day}T{h:02d}"][0], height) if f"{day}T{h:02d}" in obs else None for h in HOURS]
            if all(v is None for v in o):
                print(f"\n### {NAMES[sid]}, {day}: no station data\n")
                continue
            print(f"\n### {NAMES[sid]}, {day} (station {st}, {height} m → 10 m)\n")
            print("| Setup | Lead | " + " | ".join(f"{h}" for h in HOURS) + " | Best 2 h | Mean error |")
            print("|---" * (len(HOURS) + 4) + "|")
            print("| **Measured** | | " + " | ".join(cell(v) for v in o) + f" | **{cell(best2h(o))}** | |")
            for label, (kind, members) in SETUPS.items():
                for lead in (1, 2):
                    f = [combine(kind, members, fc, lead, f"{day}T{h:02d}") for h in HOURS]
                    f = [c[0] if c else None for c in f]
                    err = [a - b for a, b in zip(f, o) if a is not None and b is not None]
                    me = f"{statistics.mean(err):+.1f}" if err else "–"
                    print(f"| {label} | D-{lead} | " + " | ".join(cell(v) for v in f) + f" | {cell(best2h(f))} | {me} |")


if __name__ == "__main__":
    main()
