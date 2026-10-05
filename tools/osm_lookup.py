#!/usr/bin/env python3
"""Look things up in OpenStreetMap while curating spots (rate-limited and cached like
build_spots.py, so it is safe to run alongside other builds).

    python3 tools/osm_lookup.py search "Plage de Wissant" FR
        Nominatim results: lat, lon, category=type, osm id (use as osm:<id>), name.
    python3 tools/osm_lookup.py near 50.885 1.66 [radius_m]
        Beaches, kite features and bays within radius_m (default 2000) of a point, with ids.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import build_spots as b  # noqa: E402

b.CACHE_DIR = b.DEFAULT_CACHE


def search(q, country):
    for r in b.nominatim_search(q, country):
        print("%9.5f %10.5f  %-28s osm:%s%s  %s" % (
            float(r["lat"]), float(r["lon"]), "%s=%s" % (r.get("category"), r.get("type")),
            r.get("osm_type", "?")[0], r.get("osm_id"), r.get("display_name", "")[:80]))


def near(lat, lon, radius):
    q = ('[out:json][timeout:90];('
         'nwr["natural"~"^(beach|bay|cape|peninsula)$"](around:{r},{la},{lo});'
         'nwr["sport"~"kite",i](around:{r},{la},{lo});'
         'nwr["leisure"="beach_resort"](around:{r},{la},{lo}););out center tags;').format(r=radius, la=lat, lo=lon)
    rows = []
    for el in b.overpass(q, "near@%.4f,%.4f" % (lat, lon)).get("elements", []):
        c = el.get("center", el)
        t = el.get("tags", {})
        what = ",".join("%s=%s" % (k, t[k]) for k in ("natural", "sport", "leisure") if k in t)
        d = b.haversine(lat, lon, c["lat"], c["lon"])
        rows.append((d, "%6.0f m  %9.5f %10.5f  osm:%s%d  %-40s %s" % (
            d, c["lat"], c["lon"], el["type"][0], el["id"], what[:40], t.get("name", ""))))
    for _, line in sorted(rows):
        print(line)


if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) == 3 and a[0] == "search":
        search(a[1], a[2])
    elif len(a) in (3, 4) and a[0] == "near":
        near(float(a[1]), float(a[2]), int(a[3]) if len(a) == 4 else 2000)
    else:
        print(__doc__)
        sys.exit(2)
