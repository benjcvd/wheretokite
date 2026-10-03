#!/usr/bin/env python3
"""Build the WhereToKite spot catalogue (Data/spots.json).

Usage:
    python3 tools/build_spots.py                      # -> Data/spots.json
    python3 tools/build_spots.py

Python 3.9, standard library only. All network responses are cached under
tools/.osm_cache/ (git-ignored), so re-runs are offline and reproducible.

Pipeline
  1. Spots come from the hand-curated list tools/curated_spots.csv (well-known
     spots only). Coordinates are never typed in: each row is located either
     via Nominatim (free-text search restricted to the row's country) or via
     an explicit OpenStreetMap element (e.g. a sport=kitesurfing beach/node).
  2. Orientation (seaFacingDeg, compass bearing from the beach to open water):
     - sea:  OSM natural=coastline. Coastline ways have land on the LEFT and
       water on the RIGHT, so the seaward normal of a segment with bearing b
       is (b + 90) mod 360. We walk the joined coastline +-400 m from the
       nearest point and take a length-weighted circular mean of the normals
       (+-800 m when groynes make the line zig-zag, i.e. resultant < 0.7).
     - lake / lagoon: nearest large OSM natural=water polygon (ways and
       multipolygon relations); each boundary segment's normal is oriented
       into the water with a point-in-polygon test. Falls back to coastline
       (lagoons such as bays are often inside the coastline).
     Multi-sided spots (isthmus, sandbar, sea + lagoon) list one hint per side,
     `W:west side|E:lagoon side:lagoon` (direction, label, optional water type);
     each side is oriented separately and published in `sides`.
     The CSV `hint` (rough expected direction) is used only to (a) pick the
     correct shore when the located point is on an isthmus / sandbar / in the
     water, by snapping to the nearest shore facing within 60 deg of the hint,
     and (b) flag disagreements in the report.
  3. Checks: distance to shore, duplicate spots (< 2 km), OSM kite objects
     nearby (corroboration), and reference orientations; the script exits 1 if
     a reference is off by more than 30 deg or a spot is unusable.
"""

import argparse
import csv
import datetime
import hashlib
import json
import math
import os
import re
import sys
import time
import unicodedata
import urllib.error
import urllib.parse
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
USER_AGENT = "wheretokite-dev/0.2 (spot catalogue builder)"
OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://maps.mail.ru/osm/tools/overpass/api/interpreter",
]
# (overpass.kumi.systems / overpass.private.coffee were hanging in 2026-10; add
# them back here if the two above are down.)
NOMINATIM = "https://nominatim.openstreetmap.org"
DEFAULT_CACHE = os.path.join(HERE, ".osm_cache")

EARTH_R = 6371008.8
ORIENT_WINDOW = 400.0       # metres along the shore each side
COAST_SEARCH = 3000.0       # max distance spot -> shore
MAX_SHORE_DIST = 1500.0     # beyond this the spot is rejected
HINT_SNAP_RADIUS = 1500.0   # how far we may move a spot to the hinted shore
DUP_RADIUS = 2000.0
SNAP_IF_FARTHER = 300.0    # move located points this far from the shore onto it
MIN_WATER_EXTENT = 800.0    # ignore ponds smaller than this (bbox diagonal)

COMPASS16 = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
             "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

# Reference orientations (expected centre, deg). The build fails if the
# computed value is off by more than REF_TOL. "spot:<id>" refers to a catalogue
# spot; "q:<query>@CC" is located like a catalogue row but is not published.
REF_TOL = 30.0
REFERENCES = [
    ("Barceloneta (Barcelona)", "q:Platja de la Barceloneta@ES", "sea", "SE", 130),
    ("Castelldefels", "spot:es-castelldefels", None, None, 175),
    ("Sant Pere Pescador", "spot:es-sant-pere-pescador", None, None, 90),
    ("Leucate – Coussoules/Franqui", "spot:fr-leucate-les-coussoules-la-franqui", None, None, 105),
    ("Wissant", "spot:fr-wissant", None, None, 320),
    ("Hyères – L'Almanarre", "spot:fr-hyeres-l-almanarre", None, None, 255),
    ("Tarifa – Los Lances", "spot:es-tarifa-los-lances", None, None, 220),
]

CACHE_DIR = DEFAULT_CACHE


def log(*a):
    print(*a, file=sys.stderr)


# ---------------------------------------------------------------- fetching

def _cache_path(kind, key):
    h = hashlib.sha1(key.encode("utf-8")).hexdigest()[:16]
    return os.path.join(CACHE_DIR, "%s_%s.json" % (kind, h))


def _cache_get(path):
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    return None


def _cache_put(path, obj):
    os.makedirs(CACHE_DIR, exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(obj, f)
    os.replace(tmp, path)


def overpass(query, label="", endpoints=None):
    """Run an Overpass QL query (JSON output), with caching, retries, mirrors."""
    path = _cache_path("overpass", query)
    hit = _cache_get(path)
    if hit is not None:
        return hit
    data = urllib.parse.urlencode({"data": query}).encode("utf-8")
    last_err = None
    for attempt in range(12):
        for url in endpoints or OVERPASS_ENDPOINTS:
            log("overpass %s attempt %d -> %s" % (label, attempt + 1, url))
            req = urllib.request.Request(url, data=data, headers={
                "User-Agent": USER_AGENT,
                "Content-Type": "application/x-www-form-urlencoded",
            })
            try:
                with urllib.request.urlopen(req, timeout=60) as resp:
                    body = resp.read()
                text = body.decode("utf-8", errors="replace")
                if not text.lstrip().startswith("{"):
                    raise ValueError("non-JSON response: " + re.sub(r"\s+", " ", text[:200]))
                obj = json.loads(text)
                remark = obj.get("remark", "")
                if remark and ("error" in remark.lower() or "timed out" in remark.lower()):
                    raise ValueError("overpass remark: " + remark)
                _cache_put(path, obj)
                return obj
            except (urllib.error.URLError, OSError, ValueError) as e:
                last_err = e
                log("  failed: %s" % (str(e)[:200],))
        backoff = min(60, 5 * (2 ** attempt))
        log("  all endpoints failed, backing off %ds" % backoff)
        time.sleep(backoff)
    raise RuntimeError("Overpass query failed (%s): %s" % (label, last_err))


_last_nominatim = [0.0]


def _nominatim_get(endpoint, params):
    key = endpoint + "?" + urllib.parse.urlencode(sorted(params.items()))
    path = _cache_path("nominatim", key)
    hit = _cache_get(path)
    if hit is not None:
        return hit
    wait = 1.1 - (time.time() - _last_nominatim[0])
    if wait > 0:
        time.sleep(wait)
    url = NOMINATIM + endpoint + "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            obj = json.loads(resp.read().decode("utf-8"))
    finally:
        _last_nominatim[0] = time.time()
    _cache_put(path, obj)
    return obj


def nominatim_search(q, country):
    return _nominatim_get("/search", {"q": q, "format": "jsonv2", "limit": "3",
                                      "countrycodes": country.lower()})


_OSM_REFS = []


def osm_element(ref):
    """Centre + tags of an OSM element such as 'n123' / 'w45' / 'r6', fetched
    from Overpass together with all other refs of the CSV (one query).
    (Nominatim's lookup ignores unnamed / sport-only objects.)"""
    refs = sorted(set(_OSM_REFS + [ref]))
    kinds = {"n": "node", "w": "way", "r": "relation"}
    parts = []
    for k, t in kinds.items():
        ids = [r[1:] for r in refs if r[0] == k]
        if ids:
            parts.append("%s(id:%s);" % (t, ",".join(ids)))
    q = "[out:json][timeout:60];(%s);out center tags;" % "".join(parts)
    for el in overpass(q, "osm-elements").get("elements", []):
        if el["type"][0] + str(el["id"]) == ref:
            c = el if "lat" in el else el.get("center")
            return c["lat"], c["lon"], el.get("tags", {})
    return None


# ---------------------------------------------------------------- geometry

def haversine(lat1, lon1, lat2, lon2):
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = p2 - p1
    dl = math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * EARTH_R * math.asin(min(1.0, math.sqrt(a)))


class LocalProj:
    """Equirectangular projection around a reference point (metres)."""

    def __init__(self, lat0, lon0):
        self.lat0, self.lon0 = lat0, lon0
        self.kx = math.radians(1) * EARTH_R * math.cos(math.radians(lat0))
        self.ky = math.radians(1) * EARTH_R

    def xy(self, lat, lon):
        return ((lon - self.lon0) * self.kx, (lat - self.lat0) * self.ky)

    def latlon(self, x, y):
        return (self.lat0 + y / self.ky, self.lon0 + x / self.kx)


def bearing_xy(x1, y1, x2, y2):
    return math.degrees(math.atan2(x2 - x1, y2 - y1)) % 360.0


def point_seg(px, py, ax, ay, bx, by):
    """Return (distance, t) of the projection of P on segment AB."""
    dx, dy = bx - ax, by - ay
    l2 = dx * dx + dy * dy
    t = 0.0 if l2 == 0 else max(0.0, min(1.0, ((px - ax) * dx + (py - ay) * dy) / l2))
    qx, qy = ax + t * dx, ay + t * dy
    return math.hypot(px - qx, py - qy), t


def circ_mean(pairs):
    """pairs: iterable of (angle_deg, weight) -> (mean_deg, resultant 0..1)."""
    s = c = w = 0.0
    for ang, wt in pairs:
        r = math.radians(ang)
        s += wt * math.sin(r)
        c += wt * math.cos(r)
        w += wt
    if w == 0 or (s == 0 and c == 0):
        return None, 0.0
    return math.degrees(math.atan2(s, c)) % 360.0, math.hypot(s, c) / w


def angdiff(a, b):
    return abs((a - b + 180.0) % 360.0 - 180.0)


def hint_deg(h):
    return COMPASS16.index(h) * 22.5 if h else None


def compass(deg):
    return COMPASS16[int((deg + 11.25) // 22.5) % 16]


# ---------------------------------------------------------------- coastline

class Coastline:
    """Joined natural=coastline polylines (land left, water right)."""

    def __init__(self, ways):
        by_start = {}
        all_ways = [(n, g) for n, g in ways if len(g) >= 2]
        for nodes, geom in all_ways:
            by_start.setdefault(nodes[0], []).append((nodes, geom))
        used = set()
        self.chains = []
        ends = set(n[-1] for n, g in all_ways)
        order = [w for w in all_ways if w[0][0] not in ends] + all_ways
        for nodes, geom in order:
            if id(geom) in used:
                continue
            chain = list(geom)
            used.add(id(geom))
            last = nodes[-1]
            while True:
                nxt = [w for w in by_start.get(last, []) if id(w[1]) not in used]
                if not nxt:
                    break
                n2, g2 = nxt[0]
                used.add(id(g2))
                chain.extend(g2[1:])
                last = n2[-1]
            self.chains.append(chain)

    def nearest(self, lat, lon, max_dist=COAST_SEARCH, want=None, tol=60.0):
        """Nearest coastline point -> (dist_m, chain, seg, t, normal) or None.
        With `want` (deg), only segments whose seaward normal is within `tol`."""
        proj = LocalProj(lat, lon)
        best = None
        for ci, ch in enumerate(self.chains):
            prev = proj.xy(*ch[0])
            for si in range(1, len(ch)):
                cur = proj.xy(*ch[si])
                if (min(prev[0], cur[0]) > max_dist or max(prev[0], cur[0]) < -max_dist or
                        min(prev[1], cur[1]) > max_dist or max(prev[1], cur[1]) < -max_dist):
                    prev = cur
                    continue
                normal = (bearing_xy(prev[0], prev[1], cur[0], cur[1]) + 90.0) % 360.0
                if want is not None and angdiff(normal, want) > tol:
                    prev = cur
                    continue
                d, t = point_seg(0.0, 0.0, prev[0], prev[1], cur[0], cur[1])
                if best is None or d < best[0]:
                    best = (d, ci, si - 1, t, normal)
                prev = cur
        if best is None or best[0] > max_dist:
            return None
        return best

    def candidates(self, lat, lon, max_dist, want, tol=60.0):
        """All segments within max_dist whose seaward normal is within tol of
        want, as nearest()-style hits, nearest first (one per 50 m bucket)."""
        proj = LocalProj(lat, lon)
        out = []
        for ci, ch in enumerate(self.chains):
            prev = proj.xy(*ch[0])
            for si in range(1, len(ch)):
                cur = proj.xy(*ch[si])
                if (min(prev[0], cur[0]) > max_dist or max(prev[0], cur[0]) < -max_dist or
                        min(prev[1], cur[1]) > max_dist or max(prev[1], cur[1]) < -max_dist):
                    prev = cur
                    continue
                normal = (bearing_xy(prev[0], prev[1], cur[0], cur[1]) + 90.0) % 360.0
                if angdiff(normal, want) <= tol:
                    d, t = point_seg(0.0, 0.0, prev[0], prev[1], cur[0], cur[1])
                    if d <= max_dist:
                        out.append((d, ci, si - 1, t, normal))
                prev = cur
        out.sort()
        seen, uniq = set(), []
        for h in out:
            k = int(h[0] // 50)
            if k not in seen:
                seen.add(k)
                uniq.append(h)
        return uniq

    def point_of(self, hit):
        _, ci, si, t, _ = hit
        a, b = self.chains[ci][si], self.chains[ci][si + 1]
        return a[0] + t * (b[0] - a[0]), a[1] + t * (b[1] - a[1])

    def seaward(self, lat, lon, window=ORIENT_WINDOW, hit=None):
        """Return (seaFacingDeg, distance_m, resultant) or None."""
        if hit is None:
            hit = self.nearest(lat, lon)
        if hit is None:
            return None
        dist, ci, si, t, _ = hit
        ch = self.chains[ci]
        proj = LocalProj(lat, lon)
        pts = [proj.xy(*p) for p in ch]
        closed = ch[0] == ch[-1]
        n = len(pts) - 1
        pairs = []

        def seg(i):
            a, b = pts[i], pts[i + 1]
            return math.hypot(b[0] - a[0], b[1] - a[1]), (bearing_xy(a[0], a[1], b[0], b[1]) + 90.0) % 360.0

        L0, normal = seg(si)
        pairs.append((normal, L0))
        for direction in (1, -1):
            rem = window - (L0 * (1 - t) if direction == 1 else L0 * t)
            i = si + direction
            steps = 0
            while rem > 0 and steps < n:
                if i >= n or i < 0:
                    if not closed:
                        break
                    i = 0 if i >= n else n - 1
                L, normal = seg(i)
                pairs.append((normal, min(L, rem)))
                rem -= L
                i += direction
                steps += 1
        mean, R = circ_mean(pairs)
        if mean is None:
            return None
        return mean, dist, R


def coastline_query(lat, lon):
    dlat = 0.05
    dlon = dlat / max(0.2, math.cos(math.radians(lat)))
    # snap the box to a 0.01 deg grid so nearby spots can share cache entries
    s, w = math.floor((lat - dlat) * 100) / 100, math.floor((lon - dlon) * 100) / 100
    n, e = math.ceil((lat + dlat) * 100) / 100, math.ceil((lon + dlon) * 100) / 100
    return ('[out:json][timeout:90];way["natural"="coastline"](%.2f,%.2f,%.2f,%.2f);out geom;'
            % (s, w, n, e))


def load_coastline(lat, lon):
    obj = overpass(coastline_query(lat, lon), "coastline@%.2f,%.2f" % (lat, lon))
    ways = []
    for el in obj.get("elements", []):
        if el.get("type") == "way" and el.get("geometry"):
            ways.append((el["nodes"], [(p["lat"], p["lon"]) for p in el["geometry"]]))
    return Coastline(ways)


def sea_orientation(lat, lon, hint):
    """-> dict(facing, dist, R, lat, lon, snapped, wide) or None.

    The located point is moved onto the shore (30 m landward of the nearest
    coastline point) when it is more than SNAP_IF_FARTHER from the shore, or
    when the nearest shore faces away from the hint (isthmus / sandbar)."""
    coast = load_coastline(lat, lon)
    hit = coast.nearest(lat, lon)
    if hit is None:
        return None
    res = coast.seaward(lat, lon, hit=hit)
    snapped = False
    far = hit[0] > SNAP_IF_FARTHER
    wrong_side = hint is not None and res is not None and angdiff(res[0], hint) > 90
    if far or wrong_side:
        # Candidate shore segments facing the hint, nearest first; take the
        # first whose averaged (+-400 m) orientation agrees with the hint, so
        # the short side of a jetty facing the hint is not mistaken for a beach.
        if hint is None:
            cands = [hit]
        else:
            cands = coast.candidates(lat, lon, COAST_SEARCH if far else HINT_SNAP_RADIUS, hint)
        chosen = None
        for alt in cands[:300]:
            plat, plon = coast.point_of(alt)
            p = LocalProj(plat, plon)
            back = math.radians(alt[4] + 180)
            nlat, nlon = p.latlon(30 * math.sin(back), 30 * math.cos(back))
            nhit = coast.nearest(nlat, nlon, max_dist=60.0) or alt
            nres = coast.seaward(nlat, nlon, hit=nhit)
            if nres is None:
                continue
            if chosen is None:
                chosen = (nlat, nlon, nhit, nres)
            if hint is None or angdiff(nres[0], hint) <= 45:
                chosen = (nlat, nlon, nhit, nres)
                break
        if chosen is not None:
            lat, lon, hit, res = chosen
            snapped = True
    if res is None:
        return None
    if res[2] < 0.7:
        res2 = coast.seaward(lat, lon, window=2 * ORIENT_WINDOW, hit=hit)
        res = res2 or res
    wide = coast.seaward(lat, lon, window=1500.0, hit=hit)
    return {"facing": res[0], "dist": res[1], "R": res[2], "lat": lat, "lon": lon,
            "snapped": snapped, "wide": wide[0] if wide else None, "src": "osm-coastline"}


# ---------------------------------------------------------------- inland water

class WaterPoly:
    def __init__(self, name, lines):
        self.name = name
        self.lines = lines  # list of [(lat,lon), ...]; together they form closed rings
        lats = [p[0] for l in lines for p in l]
        lons = [p[1] for l in lines for p in l]
        self.bbox = (min(lats), min(lons), max(lats), max(lons))
        self.extent = haversine(self.bbox[0], self.bbox[1], self.bbox[2], self.bbox[3])

    def segments(self, proj):
        for l in self.lines:
            pts = [proj.xy(*p) for p in l]
            for i in range(len(pts) - 1):
                yield pts[i], pts[i + 1]

    def contains_xy(self, proj, x, y, segs=None):
        inside = False
        for (ax, ay), (bx, by) in (segs if segs is not None else self.segments(proj)):
            if (ay > y) != (by > y):
                xi = ax + (y - ay) * (bx - ax) / (by - ay)
                if xi > x:
                    inside = not inside
        return inside


def water_query(lat, lon):
    return ('[out:json][timeout:180];(way["natural"="water"](around:%d,%f,%f);'
            'relation["natural"="water"](around:%d,%f,%f););out geom;'
            % (int(COAST_SEARCH), lat, lon, int(COAST_SEARCH), lat, lon))


def load_water(lat, lon):
    obj = overpass(water_query(lat, lon), "water@%.4f,%.4f" % (lat, lon))
    polys = []
    for el in obj.get("elements", []):
        name = el.get("tags", {}).get("name")
        if el["type"] == "way" and el.get("geometry"):
            g = [(p["lat"], p["lon"]) for p in el["geometry"]]
            if len(g) >= 4 and g[0] == g[-1]:
                polys.append(WaterPoly(name, [g]))
        elif el["type"] == "relation":
            lines = []
            for m in el.get("members", []):
                if m.get("type") == "way" and m.get("geometry") and m.get("role") in ("outer", "inner", ""):
                    lines.append([(p["lat"], p["lon"]) for p in m["geometry"]])
            if lines:
                polys.append(WaterPoly(name, lines))
    return [p for p in polys if p.extent >= MIN_WATER_EXTENT]


def water_orientation(lat, lon, hint):
    polys = load_water(lat, lon)
    proj = LocalProj(lat, lon)
    # The water body: the largest polygon whose shore is within 1.5 km (a lake
    # spot is about the big lake, not the pond or canal next to it), else the
    # nearest one.
    cands = []  # (dist, extent, poly, segs)
    inside_any = None
    for poly in polys:
        segs = list(poly.segments(proj))
        if poly.contains_xy(proj, 0.0, 0.0, segs):
            inside_any = poly
        d = min(point_seg(0, 0, a[0], a[1], b[0], b[1])[0] for a, b in segs)
        cands.append((d, poly.extent, poly, segs))
    if not cands:
        return None
    close = [c for c in cands if c[0] <= MAX_SHORE_DIST]
    best = max(close, key=lambda c: c[1]) if close else min(cands, key=lambda c: c[0])
    if best[0] > COAST_SEARCH:
        return None
    poly, segs = best[2], best[3]
    if inside_any is not None and inside_any is not poly:
        inside_any = None
    if inside_any is not None:
        poly = inside_any
        segs = list(poly.segments(proj))

    def inward(a, b):
        nrm = (bearing_xy(a[0], a[1], b[0], b[1]) + 90.0) % 360.0
        mx, my = (a[0] + b[0]) / 2, (a[1] + b[1]) / 2
        r = math.radians(nrm)
        if not poly.contains_xy(proj, mx + 8 * math.sin(r), my + 8 * math.cos(r), segs):
            nrm = (nrm + 180.0) % 360.0
        return nrm

    # nearest boundary point (optionally restricted to the hinted shore)
    def nearest(want):
        bst = None
        for a, b in segs:
            d, t = point_seg(0, 0, a[0], a[1], b[0], b[1])
            if (bst is not None and d >= bst[0]) or d > 8000:
                continue
            if want is not None:
                if math.hypot(b[0] - a[0], b[1] - a[1]) < 1e-6 or angdiff(inward(a, b), want) > 60:
                    continue
            bst = (d, a, b, t)
        return bst

    hit = nearest(None)
    snapped = False
    nrm0 = inward(hit[1], hit[2])
    far = inside_any is not None or hit[0] > SNAP_IF_FARTHER
    if hint is not None and (far or angdiff(nrm0, hint) > 90):
        alt = nearest(hint)
        if alt is not None and (alt[0] <= HINT_SNAP_RADIUS or far):
            hit, snapped = alt, True
        elif far:
            snapped = True
    elif far:
        snapped = True  # point in the water or inland: move to the nearest shore
    d, a, b, t = hit
    px, py = a[0] + t * (b[0] - a[0]), a[1] + t * (b[1] - a[1])
    if snapped:
        nrm = inward(a, b)
        r = math.radians(nrm + 180)
        sx, sy = px + 30 * math.sin(r), py + 30 * math.cos(r)
        lat, lon = proj.latlon(sx, sy)
        d = 30.0
    else:
        sx, sy = 0.0, 0.0

    def mean_around(window):
        pairs = []
        for a2, b2 in segs:
            mx, my = (a2[0] + b2[0]) / 2, (a2[1] + b2[1]) / 2
            L = math.hypot(b2[0] - a2[0], b2[1] - a2[1])
            if L < 1e-6 or math.hypot(mx - px, my - py) > window:
                continue
            pairs.append((inward(a2, b2), L))
        return circ_mean(pairs)

    facing, R = mean_around(ORIENT_WINDOW)
    if facing is None:
        return None
    if R < 0.7:
        f2, R2 = mean_around(2 * ORIENT_WINDOW)
        if f2 is not None:
            facing, R = f2, R2
    wide, _ = mean_around(1500.0)
    return {"facing": facing, "dist": d, "R": R, "lat": lat, "lon": lon, "snapped": snapped,
            "wide": wide, "src": "osm-water", "water": poly.name}


# ---------------------------------------------------------------- spots

def slugify(s):
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def read_curated(path):
    rows = []
    with open(path, "r", encoding="utf-8") as f:
        lines = [l for l in f if l.strip() and not l.lstrip().startswith("#")]
    for r in csv.DictReader(lines):
        r = {k: (v or "").strip() for k, v in r.items()}
        if r["water"] not in ("sea", "lagoon", "lake"):
            raise SystemExit("bad water type in row %r" % r)
        r["sides"] = parse_sides(r["hint"], r["water"])
        if r["sides"] is None:
            raise SystemExit("bad hint in row %r" % r)
        if len(r["sides"]) > 1:
            r["hint"] = r["sides"][0][0]
        rows.append(r)
    return rows


def parse_sides(hint, water):
    """'W' -> [('W', None, water)]; 'W:sea side|E:lagoon:lagoon' -> one tuple per side.
    None if malformed."""
    if not hint:
        return [("", None, water)]
    sides = []
    for part in hint.split("|"):
        bits = [b.strip() for b in part.split(":")]
        if bits[0] not in COMPASS16 or len(bits) > 3:
            return None
        w = bits[2] if len(bits) == 3 else water
        if w not in ("sea", "lagoon", "lake"):
            return None
        sides.append((bits[0], (bits[1] or None) if len(bits) > 1 else None, w))
    if len(sides) > 1 and any(name is None for _, name, _ in sides):
        return None
    if sides[0][2] != water:   # the row's water type is the first side's
        return None
    return sides


def locate(locator, country):
    """-> (lat, lon, description) or None."""
    kind, _, arg = locator.partition(":")
    if kind == "q":
        res = nominatim_search(arg, country)
        if not res:
            return None
        r = res[0]
        return float(r["lat"]), float(r["lon"]), "nominatim '%s' -> %s/%s %s=%s (%s)" % (
            arg, r.get("osm_type"), r.get("osm_id"), r.get("category"), r.get("type"),
            r.get("display_name", "")[:70])
    if kind == "osm":
        res = osm_element(arg)
        if not res:
            return None
        tags = res[2]
        what = ",".join("%s=%s" % (k, tags[k]) for k in ("natural", "leisure", "sport", "club",
                                                          "amenity", "shop") if k in tags)
        return res[0], res[1], "osm %s '%s' %s" % (arg, tags.get("name", ""), what)
    raise SystemExit("bad locator %r" % locator)


def orient(lat, lon, water, hint):
    if water == "sea":
        return sea_orientation(lat, lon, hint)
    res = water_orientation(lat, lon, hint)
    if res is None or res["dist"] > MAX_SHORE_DIST:
        alt = sea_orientation(lat, lon, hint)
        if alt is not None and (res is None or alt["dist"] < res["dist"]):
            return alt
    return res


def load_kite_objects():
    q = '[out:json][timeout:180];nwr["sport"~"kitesurf|kiteboard",i](20,-20,62,36);out center tags;'
    out = []
    for el in overpass(q, "kite-objects").get("elements", []):
        ll = (el.get("lat"), el.get("lon")) if "lat" in el else (
            el.get("center", {}).get("lat"), el.get("center", {}).get("lon"))
        if ll[0] is not None:
            out.append(ll)
    return out


def prefetch(rows):
    """Geocode every row, then fetch the Overpass queries in parallel, one
    worker per mirror for the first two mirrors (overpass-api.de allows 2 slots)."""
    import queue
    import threading
    todo = []
    for r in rows:
        loc = locate(r["locate"], r["country"])
        if loc is None:
            continue
        if r["water"] in ("sea", "lagoon"):
            todo.append(coastline_query(loc[0], loc[1]))
        if r["water"] in ("lake", "lagoon"):
            todo.append(water_query(loc[0], loc[1]))
    todo = [q for q in dict.fromkeys(todo) if _cache_get(_cache_path("overpass", q)) is None]
    log("prefetch: %d Overpass queries to fetch" % len(todo))
    jobs = queue.Queue()
    for q in todo:
        jobs.put(q)

    def worker(i):
        eps = OVERPASS_ENDPOINTS[i:] + OVERPASS_ENDPOINTS[:i]
        while True:
            try:
                q = jobs.get_nowait()
            except queue.Empty:
                return
            try:
                overpass(q, "prefetch[%d] %d left" % (i, jobs.qsize()), endpoints=eps)
            except RuntimeError as e:
                log("prefetch failed: %s" % e)

    threads = [threading.Thread(target=worker, args=(i,)) for i in range(2)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()


def main():
    global CACHE_DIR
    ap = argparse.ArgumentParser()
    ap.add_argument("--curated", default=os.path.join(HERE, "curated_spots.csv"))
    ap.add_argument("--out", default=os.path.join(REPO, "Data", "spots.json"))
    ap.add_argument("--also", action="append", default=[],
                    help="also write an identical copy here (legacy file name)")
    ap.add_argument("--cache", default=DEFAULT_CACHE)
    args = ap.parse_args()
    CACHE_DIR = args.cache

    rows = read_curated(args.curated)
    _OSM_REFS.extend(r["locate"][4:] for r in rows if r["locate"].startswith("osm:"))
    prefetch(rows)
    kite_objs = load_kite_objects()
    problems, warnings = [], []
    spots = []
    for r in rows:
        sid = "%s-%s" % (r["country"].lower(), slugify(r["name"]))
        loc = locate(r["locate"], r["country"])
        if loc is None:
            problems.append("%s: could not locate (%s)" % (sid, r["locate"]))
            continue
        lat, lon, how = loc
        hint = hint_deg(r["hint"])
        o = orient(lat, lon, r["water"], hint)
        if o is None or o["dist"] > MAX_SHORE_DIST:
            problems.append("%s: no shore within %.0f m of %.5f,%.5f (%s)" % (
                sid, MAX_SHORE_DIST, lat, lon, how))
            continue
        notes = [r["notes"]] if r["notes"] else []
        if o["R"] < 0.5:
            notes.append("Irregular shoreline near the spot; orientation less certain.")
        if o["wide"] is not None and angdiff(o["facing"], o["wide"]) > 25:
            notes.append("Shoreline bends here (%.0f° locally vs %.0f° over ±1.5 km)." % (
                o["facing"], o["wide"]))
        nearby = sum(1 for k in kite_objs if haversine(o["lat"], o["lon"], k[0], k[1]) < 3000)
        spot = {
            "id": sid,
            "name": r["name"],
            "latitude": round(o["lat"], 5),
            "longitude": round(o["lon"], 5),
            "seaFacingDeg": round(o["facing"], 1),
            "orientationSource": o["src"],
            "distanceToShoreM": round(o["dist"], 1),
            "source": "curated",
            "notes": " ".join(notes) or None,
            "country": r["country"],
            "region": r["region"],
            "waterType": r["water"],
        }
        spot["_how"] = how
        spot["_hint"] = r["hint"]
        spot["_snapped"] = o["snapped"]
        spot["_osm_kite"] = nearby
        spot["_R"] = o["R"]
        spots.append(spot)
        if hint is not None and angdiff(o["facing"], hint) > 45:
            warnings.append("%s: facing %.0f° (%s) but hint %s" % (
                sid, o["facing"], compass(o["facing"]), r["hint"]))
        if o["snapped"] and hint is not None and angdiff(o["facing"], hint) > 60:
            problems.append("%s: moved to the %s shore but the beach there faces %.0f°" % (
                sid, r["hint"], o["facing"]))
        if o["snapped"]:
            warnings.append("%s: moved to the %s-facing shore (located point %.5f,%.5f)" % (
                sid, r["hint"] or "nearest", lat, lon))
        if len(r["sides"]) > 1:
            sides = []
            for h, name, w in r["sides"]:
                so = o if (h, w) == (r["sides"][0][0], r["sides"][0][2]) else orient(lat, lon, w, hint_deg(h))
                if so is None or so["dist"] > MAX_SHORE_DIST + HINT_SNAP_RADIUS:
                    problems.append("%s: no %s shore for side '%s'" % (sid, h, name))
                    continue
                if angdiff(so["facing"], hint_deg(h)) > 45:
                    problems.append("%s: side '%s' faces %.0f° (%s) but hint %s" % (
                        sid, name, so["facing"], compass(so["facing"]), h))
                sides.append({"name": name, "seaFacingDeg": round(so["facing"], 1)})
                warnings.append("%s: side '%s' faces %.0f° (%s, %s, %.0f m from the located point)" % (
                    sid, name, so["facing"], compass(so["facing"]), so["src"],
                    haversine(lat, lon, so["lat"], so["lon"])))
            spot["sides"] = sides

    # duplicates
    ids = set()
    for i, a in enumerate(spots):
        if a["id"] in ids:
            problems.append("duplicate id %s" % a["id"])
        ids.add(a["id"])
        for b in spots[i + 1:]:
            d = haversine(a["latitude"], a["longitude"], b["latitude"], b["longitude"])
            if d < DUP_RADIUS:
                problems.append("%s and %s are only %.0f m apart" % (a["id"], b["id"], d))

    # report
    spots.sort(key=lambda s: (s["country"], s["latitude"], s["longitude"]))
    print("%-44s %9s %10s %6s %-4s %-4s %6s %4s %s" % (
        "id", "lat", "lon", "facing", "dir", "hint", "shore", "kite", "located by"))
    for s in spots:
        print("%-44s %9.5f %10.5f %6.1f %-4s %-4s %6.0f %4d %s%s" % (
            s["id"][:44], s["latitude"], s["longitude"], s["seaFacingDeg"],
            compass(s["seaFacingDeg"]), s["_hint"] or "-", s["distanceToShoreM"],
            s["_osm_kite"], "SNAPPED " if s["_snapped"] else "", s["_how"][:90]))

    print("\nReference orientations (fail if off by > %.0f°):" % REF_TOL)
    by_id = {s["id"]: s for s in spots}
    for label, ref, water, h, expected in REFERENCES:
        f_ = None
        if ref.startswith("spot:"):
            s = by_id.get(ref[5:])
            f_ = s["seaFacingDeg"] if s else None
        else:
            q, _, cc = ref[2:].rpartition("@")
            loc = locate("q:" + q, cc)
            if loc:
                o = orient(loc[0], loc[1], water, hint_deg(h))
                f_ = o["facing"] if o else None
        ok = f_ is not None and angdiff(f_, expected) <= REF_TOL
        print("  %-28s computed %6s expected %3d -> %s" % (
            label, "%.1f" % f_ if f_ is not None else "null", expected, "OK" if ok else "FAIL"))
        if not ok:
            problems.append("reference %s off: %s vs %d" % (label, f_, expected))

    if warnings:
        print("\nWarnings (review):")
        for w in warnings:
            print("  " + w)
    counts = {}
    for s in spots:
        counts[s["country"]] = counts.get(s["country"], 0) + 1
    print("\n%d spots: %s" % (len(spots), ", ".join("%s %d" % kv for kv in sorted(counts.items()))))
    if problems:
        print("\nPROBLEMS:")
        for p in problems:
            print("  " + p)

    out_spots = [{k: v for k, v in s.items() if not k.startswith("_")} for s in spots]
    doc = {
        "generatedAt": datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z",
        "region": "europe",
        "attribution": "Spot locations and shoreline geometry © OpenStreetMap contributors (ODbL); "
                       "spot selection curated by WhereToKite",
        "spots": out_spots,
    }
    for path in [args.out] + args.also:
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(doc, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print("wrote %s" % path)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
