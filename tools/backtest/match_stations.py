"""Nearest Meteocat (XEMA) station for each Catalan spot. Usage: match_stations.py <stations.json>"""
import json
import math
import sys

spots = json.load(open("Data/spots.json"))
spots = spots["spots"] if isinstance(spots, dict) else spots
stations = [s for s in json.load(open(sys.argv[1])) if s["nom_estat_ema"] == "Operativa"]


def km(a, b, c, d):
    a, b, c, d = map(math.radians, (a, b, c, d))
    return 6371 * math.acos(min(1, math.sin(a) * math.sin(c) + math.cos(a) * math.cos(c) * math.cos(b - d)))


for sp in spots:
    if not (40.5 < sp["latitude"] < 42.5 and 0.5 < sp["longitude"] < 3.4) or sp.get("tier") == "archived":
        continue
    best = min(stations, key=lambda s: km(sp["latitude"], sp["longitude"], float(s["latitud"]), float(s["longitud"])))
    d = km(sp["latitude"], sp["longitude"], float(best["latitud"]), float(best["longitud"]))
    print(f"{sp['id'][:34]:34} {sp.get('tier', '')[:8]:8} -> {best['codi_estacio']} {best['nom_estacio'][:30]:30} "
          f"{best['altitud']:>4} m {d:4.1f} km")
