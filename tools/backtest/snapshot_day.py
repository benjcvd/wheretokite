"""Save today's forecast for a coming day, old setup vs new, so it can be checked against the
stations once the day is over (the archive only keeps each run's first hours).

    python3 tools/backtest/snapshot_day.py 2026-10-28 es-pals es-sant-pere-pescador ...
"""
import json
import os
import sys
import urllib.parse
import urllib.request

SETUPS = {
    "old (best match, offshore cell)": ("best_match", "sea"),
    "new (AROME+ICON+ECMWF, beach cell)": ("meteofrance_arome_france_hd,icon_seamless,ecmwf_ifs025", "land"),
    "AROME+ICON, beach cell": ("meteofrance_arome_france_hd,icon_seamless", "land"),
}

day, ids = sys.argv[1], sys.argv[2:]
spots = json.load(open("Data/spots.json"))
spots = {s["id"]: s for s in (spots["spots"] if isinstance(spots, dict) else spots)}
out = {"day": day, "spots": {}}
for sid in ids:
    s = spots[sid]
    per = {}
    for label, (models, cell) in SETUPS.items():
        q = urllib.parse.urlencode({
            "latitude": f"{s['latitude']:.4f}", "longitude": f"{s['longitude']:.4f}",
            "hourly": "wind_speed_10m,wind_direction_10m", "wind_speed_unit": "kn", "timezone": "GMT",
            "start_date": day, "end_date": day, "models": models, "cell_selection": cell,
        })
        h = json.load(urllib.request.urlopen("https://api.open-meteo.com/v1/forecast?" + q, timeout=60))["hourly"]
        names = models.split(",")
        speeds = []
        for i in range(len(h["time"])):
            vals = [h.get(f"wind_speed_10m_{m}" if len(names) > 1 else "wind_speed_10m")[i] for m in names]
            vals = [v for v in vals if v is not None]
            speeds.append(round(sum(vals) / len(vals), 1) if vals else None)
        per[label] = dict(zip([t[:13] for t in h["time"]], speeds))
    out["spots"][sid] = {"name": s["name"], "forecast_utc": per}
path = os.path.join(os.path.dirname(__file__), f"snapshot_{day}.json")
json.dump(out, open(path, "w"), indent=1, ensure_ascii=False)
print(path)
