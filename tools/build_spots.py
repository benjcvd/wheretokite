#!/usr/bin/env python3
"""Build the WhereToKite spot dataset from OpenStreetMap.

Usage:
    python3 tools/build_spots.py --bbox 40.4,0.4,42.5,3.4 --out Data/spots_barcelona.json

Python 3.9, standard library only.

Pipeline
  1. Candidate spots from Overpass (sport=kitesurfing/kiteboarding, plus
     kite schools/clubs/shops), kept only if within 1.5 km of the coastline
     (shops/schools: 400 m, so a city-centre kite shop is not a "spot").
  2. Deduplicate candidates within 800 m, name unnamed ones from the nearest
     named beach / place.
  3. Supplement with a curated list of well-known spots. Their coordinates are
     never typed in: each is snapped to a named OSM natural=beach (nearest to
     an OSM place used as anchor), falling back to Nominatim.
  4. seaFacingDeg from OSM natural=coastline geometry. Coastline ways have land
     on the LEFT and water on the RIGHT, so the seaward normal of a segment
     with bearing b is (b + 90) mod 360. We walk the joined coastline chain
     +-400 m from the nearest coastline point and take a length-weighted
     circular mean of the seaward normals (widened to +-800 m when groynes
     make the line zig-zag, i.e. mean resultant < 0.7).
"""

import argparse
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

USER_AGENT = "wheretokite-dev/0.1"
OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://maps.mail.ru/osm/tools/overpass/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
    "https://overpass.private.coffee/api/interpreter",
]
NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
DEFAULT_CACHE = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".osm_cache")

EARTH_R = 6371008.8
MAX_SHORE_DIST_SPOT = 1500.0     # sport=kitesurfing objects
MAX_SHORE_DIST_BUSINESS = 400.0  # shops / schools / clubs
DEDUP_RADIUS = 800.0
ORIENT_WINDOW = 400.0            # metres along the coastline each side
COAST_SEARCH = 3000.0

CACHE_DIR = DEFAULT_CACHE


def log(*a):
    print(*a, file=sys.stderr)


# ---------------------------------------------------------------- fetching

def _cache_path(kind, key):
    h = hashlib.sha1(key.encode("utf-8")).hexdigest()[:16]
    return os.path.join(CACHE_DIR, "%s_%s.json" % (kind, h))


def overpass(query, label=""):
    """Run an Overpass QL query (JSON output), with caching, retries, mirrors."""
    path = _cache_path("overpass", query)
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    data = urllib.parse.urlencode({"data": query}).encode("utf-8")
    last_err = None
    for attempt in range(3):
        for url in OVERPASS_ENDPOINTS:
            log("overpass %s attempt %d -> %s" % (label, attempt + 1, url))
            req = urllib.request.Request(url, data=data, headers={
                "User-Agent": USER_AGENT,
                "Content-Type": "application/x-www-form-urlencoded",
            })
            try:
                with urllib.request.urlopen(req, timeout=120) as resp:
                    body = resp.read()
                text = body.decode("utf-8", errors="replace")
                if not text.lstrip().startswith("{"):
                    raise ValueError("non-JSON response: " + re.sub(r"\s+", " ", text[:300]))
                obj = json.loads(text)
                remark = obj.get("remark", "")
                if remark and ("error" in remark.lower() or "timed out" in remark.lower()):
                    raise ValueError("overpass remark: " + remark)
                os.makedirs(CACHE_DIR, exist_ok=True)
                with open(path, "w", encoding="utf-8") as f:
                    json.dump(obj, f)
                return obj
            except (urllib.error.URLError, OSError, ValueError) as e:
                last_err = e
                log("  failed: %s" % (str(e)[:200],))
        backoff = 10 * (2 ** attempt)
        log("  all endpoints failed, backing off %ds" % backoff)
        time.sleep(backoff)
    raise RuntimeError("Overpass query failed (%s): %s" % (label, last_err))


_last_nominatim = [0.0]


def nominatim(q, viewbox=None):
    key = q + "|" + (viewbox or "")
    path = _cache_path("nominatim", key)
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    params = {"q": q, "format": "jsonv2", "limit": "5"}
    if viewbox:
        params["viewbox"] = viewbox
        params["bounded"] = "1"
    url = NOMINATIM_URL + "?" + urllib.parse.urlencode(params)
    wait = 1.1 - (time.time() - _last_nominatim[0])
    if wait > 0:
        time.sleep(wait)
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        obj = json.loads(resp.read().decode("utf-8"))
    _last_nominatim[0] = time.time()
    os.makedirs(CACHE_DIR, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f)
    return obj


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


# ---------------------------------------------------------------- coastline

class Coastline:
    """Joined natural=coastline polylines (land left, water right)."""

    def __init__(self, ways):
        # ways: list of (node_ids, [(lat,lon),...]) ; join end-to-start
        by_start = {}
        for nodes, geom in ways:
            if len(geom) >= 2:
                by_start.setdefault(nodes[0], []).append((nodes, geom))
        used = set()
        self.chains = []  # list of [(lat,lon), ...]
        all_ways = [(n, g) for n, g in ways if len(g) >= 2]
        ends = set(n[-1] for n, g in all_ways)
        # start chains at ways whose start is nobody's end (open chains), then closed rings
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
        # bounding boxes for quick rejection
        self.bboxes = []
        for ch in self.chains:
            lats = [p[0] for p in ch]
            lons = [p[1] for p in ch]
            self.bboxes.append((min(lats), min(lons), max(lats), max(lons)))

    def nearest(self, lat, lon, max_dist=COAST_SEARCH):
        """Return (dist_m, chain_index, seg_index, t) or None."""
        dlat = max_dist / 111000.0
        dlon = dlat / max(0.1, math.cos(math.radians(lat)))
        proj = LocalProj(lat, lon)
        best = None
        for ci, (s, w, n, e) in enumerate(self.bboxes):
            if lat < s - dlat or lat > n + dlat or lon < w - dlon or lon > e + dlon:
                continue
            ch = self.chains[ci]
            prev = proj.xy(*ch[0])
            for si in range(1, len(ch)):
                cur = proj.xy(*ch[si])
                # cheap reject
                if (min(prev[0], cur[0]) > max_dist or max(prev[0], cur[0]) < -max_dist or
                        min(prev[1], cur[1]) > max_dist or max(prev[1], cur[1]) < -max_dist):
                    prev = cur
                    continue
                d, t = point_seg(0.0, 0.0, prev[0], prev[1], cur[0], cur[1])
                if best is None or d < best[0]:
                    best = (d, ci, si - 1, t)
                prev = cur
        if best is None or best[0] > max_dist:
            return None
        return best

    def seaward(self, lat, lon, window=ORIENT_WINDOW):
        """Return (seaFacingDeg, distance_m, resultant) or None."""
        hit = self.nearest(lat, lon)
        if hit is None:
            return None
        dist, ci, si, t = hit
        ch = self.chains[ci]
        proj = LocalProj(lat, lon)
        pts = [proj.xy(*p) for p in ch]
        closed = ch[0] == ch[-1]
        n = len(pts) - 1  # number of segments
        pairs = []

        def seg(i):
            a, b = pts[i], pts[i + 1]
            return math.hypot(b[0] - a[0], b[1] - a[1]), (bearing_xy(a[0], a[1], b[0], b[1]) + 90.0) % 360.0

        # partial current segment, split at the projection point
        L0, normal = seg(si)
        pairs.append((normal, L0))
        # walk forward
        rem = window - L0 * (1 - t)
        i = si + 1
        steps = 0
        while rem > 0 and steps < n:
            if i >= n:
                if not closed:
                    break
                i = 0
            L, normal = seg(i)
            w = min(L, rem)
            pairs.append((normal, w))
            rem -= L
            i += 1
            steps += 1
        # walk backward
        rem = window - L0 * t
        i = si - 1
        steps = 0
        while rem > 0 and steps < n:
            if i < 0:
                if not closed:
                    break
                i = n - 1
            L, normal = seg(i)
            w = min(L, rem)
            pairs.append((normal, w))
            rem -= L
            i -= 1
            steps += 1
        mean, R = circ_mean(pairs)
        if mean is None:
            return None
        return mean, dist, R


def load_coastline(bbox):
    s, w, n, e = bbox
    pad = 0.05
    q = ('[out:json][timeout:180];way["natural"="coastline"](%f,%f,%f,%f);out geom;'
         % (s - pad, w - pad, n + pad, e + pad))
    obj = overpass(q, "coastline")
    ways = []
    for el in obj.get("elements", []):
        if el.get("type") == "way" and el.get("geometry"):
            geom = [(p["lat"], p["lon"]) for p in el["geometry"]]
            ways.append((el["nodes"], geom))
    log("coastline: %d ways" % len(ways))
    return Coastline(ways)


def water_orientation(lat, lon):
    """Fallback for inland water: nearest natural=water polygon outline.

    Water polygon (outer ring) direction is not standardised, so the seaward
    normal is chosen as the one pointing towards the polygon centroid side,
    i.e. into the water."""
    q = ('[out:json][timeout:60];(way["natural"="water"](around:%d,%f,%f););out geom;'
         % (int(COAST_SEARCH), lat, lon))
    obj = overpass(q, "water@%.4f,%.4f" % (lat, lon))
    proj = LocalProj(lat, lon)
    best = None
    for el in obj.get("elements", []):
        g = el.get("geometry") or []
        if len(g) < 3:
            continue
        pts = [proj.xy(p["lat"], p["lon"]) for p in g]
        for i in range(len(pts) - 1):
            d, t = point_seg(0, 0, pts[i][0], pts[i][1], pts[i + 1][0], pts[i + 1][1])
            if best is None or d < best[0]:
                best = (d, pts, i)
    if best is None:
        return None
    d, pts, i = best
    cx = sum(p[0] for p in pts[:-1]) / (len(pts) - 1)
    cy = sum(p[1] for p in pts[:-1]) / (len(pts) - 1)
    pairs = []
    for j in range(len(pts) - 1):
        a, b = pts[j], pts[j + 1]
        mx, my = (a[0] + b[0]) / 2, (a[1] + b[1]) / 2
        if math.hypot(mx - pts[i][0], my - pts[i][1]) > ORIENT_WINDOW:
            continue
        brg = bearing_xy(a[0], a[1], b[0], b[1])
        nrm = (brg + 90) % 360
        # pick normal pointing into the polygon (towards centroid)
        vx, vy = cx - mx, cy - my
        if vx * math.sin(math.radians(nrm)) + vy * math.cos(math.radians(nrm)) < 0:
            nrm = (nrm + 180) % 360
        pairs.append((nrm, math.hypot(b[0] - a[0], b[1] - a[1])))
    mean, R = circ_mean(pairs)
    if mean is None:
        return None
    return mean, d, R


# ---------------------------------------------------------------- naming

def slugify(s):
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def norm(s):
    return unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii").lower()


def el_latlon(el):
    if "lat" in el:
        return el["lat"], el["lon"]
    c = el.get("center")
    if c:
        return c["lat"], c["lon"]
    return None


def load_beaches(bbox):
    s, w, n, e = bbox
    q = ('[out:json][timeout:120];nwr["natural"="beach"]["name"](%f,%f,%f,%f);out center tags;'
         % (s, w, n, e))
    out = []
    for el in overpass(q, "beaches").get("elements", []):
        ll = el_latlon(el)
        if ll:
            out.append({"name": el["tags"]["name"], "lat": ll[0], "lon": ll[1],
                        "type": el["type"], "id": el["id"]})
    log("named beaches: %d" % len(out))
    return out


def load_places(bbox):
    s, w, n, e = bbox
    q = ('[out:json][timeout:120];node["place"~"^(city|town|village|hamlet|suburb|'
         'neighbourhood|quarter|locality|isolated_dwelling)$"]["name"](%f,%f,%f,%f);out;'
         % (s, w, n, e))
    out = []
    for el in overpass(q, "places").get("elements", []):
        out.append({"name": el["tags"]["name"], "lat": el["lat"], "lon": el["lon"],
                    "place": el["tags"].get("place")})
    log("named places: %d" % len(out))
    return out


def nearest_named(items, lat, lon, max_m):
    best = None
    for it in items:
        d = haversine(lat, lon, it["lat"], it["lon"])
        if d <= max_m and (best is None or d < best[0]):
            best = (d, it)
    return best


# ---------------------------------------------------------------- candidates

KITE_RE = r"kite|kitesurf|kiteboard"


def load_candidates(bbox):
    s, w, n, e = bbox
    bb = "(%f,%f,%f,%f)" % (s, w, n, e)
    q = ('[out:json][timeout:120];('
         'nwr["sport"~"^(kitesurfing|kiteboarding|kite)",i]%s;'
         'nwr["sport"~"(^|;)\\\\s*(kitesurfing|kiteboarding)",i]%s;'
         'nwr["shop"]["name"~"%s",i]%s;'
         'nwr["club"]["name"~"%s",i]%s;'
         'nwr["leisure"]["name"~"%s",i]%s;'
         ');out center tags;' % (bb, bb, KITE_RE, bb, KITE_RE, bb, KITE_RE, bb))
    out = []
    for el in overpass(q, "candidates").get("elements", []):
        ll = el_latlon(el)
        if not ll:
            continue
        tags = el.get("tags", {})
        sport = tags.get("sport", "").lower()
        is_sport = "kitesurf" in sport or "kiteboard" in sport
        # shops, schools (usually leisure=sports_centre) and clubs are
        # businesses: they only indicate a spot if they sit on the beach.
        is_business = bool(tags.get("shop") or tags.get("office") or tags.get("craft")
                           or tags.get("club") or tags.get("amenity") or tags.get("tourism")
                           or tags.get("leisure") == "sports_centre")
        if tags.get("amenity") and not is_sport:
            continue  # e.g. a restaurant whose name happens to contain "kite"
        out.append({
            "osm_type": el["type"], "osm_id": el["id"],
            "lat": ll[0], "lon": ll[1], "tags": tags,
            "name": tags.get("name"),
            "kind": "business" if is_business else ("spot" if is_sport else "business"),
        })
    log("raw candidates: %d" % len(out))
    return out


# ---------------------------------------------------------------- curated

# Well-known Catalan kite spots. Coordinates are NOT given here: each entry is
# resolved to an OSM beach whose name matches `beach` (regex on normalised
# name), choosing the one nearest the OSM place called `anchor`; if that
# fails, Nominatim is queried with `nominatim`.
CURATED = [
    {"slug": "riumar", "name": "Riumar (Ebro delta)",
     "beach": r"riumar", "anchor": "Riumar",
     "nominatim": "Platja de Riumar, Deltebre",
     "notes": "Ebro delta, next to the river mouth."},
    {"slug": "trabucador", "name": "Platja del Trabucador (Ebro delta)",
     "beach": r"trabucador", "anchor": "Sant Carles de la Ràpita",
     "nominatim": "Platja del Trabucador",
     "notes": "Ebro delta sandbar with water on both sides (open sea to the E/SE, "
              "flat-water Badia dels Alfacs to the W/NW). seaFacingDeg is from the "
              "nearest coastline only."},
    {"slug": "eucaliptus", "name": "Platja dels Eucaliptus (Ebro delta)",
     "beach": r"eucaliptus", "anchor": "Els Eucaliptus",
     "nominatim": "Platja dels Eucaliptus, Amposta",
     "notes": "Ebro delta beach."},
    {"slug": "la-marquesa", "name": "Platja de la Marquesa (Ebro delta)",
     "beach": r"marquesa", "anchor": "Deltebre",
     "nominatim": "Platja de la Marquesa, Deltebre",
     "notes": "Ebro delta beach."},
    {"slug": "la-pineda", "name": "Platja de la Pineda (Vila-seca)",
     "beach": r"^platja de la pineda$", "anchor": "La Pineda",
     "nominatim": "Platja de la Pineda, Vila-seca"},
    {"slug": "torredembarra", "name": "Platja de Torredembarra",
     "beach": r"muntanyans|torredembarra", "anchor": "Torredembarra",
     "nominatim": "Platja dels Muntanyans, Torredembarra"},
    {"slug": "altafulla", "name": "Platja d'Altafulla",
     "beach": r"altafulla", "anchor": "Altafulla",
     "nominatim": "Platja d'Altafulla"},
    {"slug": "cunit", "name": "Platja de Cunit",
     "beach": r"cunit", "anchor": "Cunit",
     "nominatim": "Platja de Cunit"},
    {"slug": "cubelles", "name": "Platja de Cubelles",
     "beach": r"cubelles|platja llarga", "anchor": "Cubelles",
     "nominatim": "Platja Llarga, Cubelles"},
    {"slug": "castelldefels", "name": "Platja de Castelldefels",
     "beach": r"castelldefels", "anchor": "Castelldefels",
     "nominatim": "Platja de Castelldefels"},
    {"slug": "gava", "name": "Platja de Gavà",
     "beach": r"gava", "anchor": "Gavà Mar",
     "nominatim": "Platja de Gavà"},
    {"slug": "el-prat", "name": "Platja del Prat",
     "beach": r"prat", "anchor": "El Prat de Llobregat",
     "nominatim": "Platja del Prat, El Prat de Llobregat"},
    {"slug": "barceloneta", "name": "Platja de la Barceloneta",
     "beach": r"barceloneta", "anchor": "la Barceloneta",
     "nominatim": "Platja de la Barceloneta, Barcelona",
     "notes": "City beach; kiting is generally restricted here during the bathing season. Included mainly as an orientation reference."},
    {"slug": "sant-adria", "name": "Platja de Sant Adrià",
     "beach": r"sant adria", "anchor": "Sant Adrià de Besòs",
     "nominatim": "Platja de Sant Adrià de Besòs"},
    {"slug": "badalona", "name": "Platja de Badalona",
     "beach": r"badalona|el pont del petroli|coco", "anchor": "Badalona",
     "nominatim": "Platja del Pont del Petroli, Badalona"},
    {"slug": "sant-pere-pescador", "name": "Platja de Sant Pere Pescador",
     "beach": r"sant pere pescador|can marques|el cortal|la gaviota|platja de sant pere",
     "anchor": "Sant Pere Pescador",
     "nominatim": "Platja de Sant Pere Pescador"},
    {"slug": "sant-marti-empuries", "name": "Platja de Sant Martí d'Empúries",
     "beach": r"riuet|sant marti|empuries", "anchor": "Sant Martí d'Empúries",
     "nominatim": "Platja del Riuet, L'Escala"},
    {"slug": "roses-salatar", "name": "Platja del Salatar (Roses)",
     "beach": r"salatar", "anchor": "Roses",
     "nominatim": "Platja del Salatar, Roses"},
]


def resolve_curated(entry, beaches, places, bbox):
    anchor = None
    an = norm(entry["anchor"])
    cands = [p for p in places if norm(p["name"]) == an]
    if cands:
        # prefer the most important place type
        rank = {"city": 0, "town": 1, "village": 2, "suburb": 3, "quarter": 4,
                "neighbourhood": 5, "hamlet": 6, "locality": 7, "isolated_dwelling": 8}
        cands.sort(key=lambda p: rank.get(p["place"], 9))
        anchor = cands[0]
    rx = re.compile(entry["beach"])
    matches = [b for b in beaches if rx.search(norm(b["name"]))]
    if anchor and matches:
        best = nearest_named(matches, anchor["lat"], anchor["lon"], 12000)
        if best:
            b = best[1]
            return b["lat"], b["lon"], "OSM beach '%s' (%s/%d), %.1f km from place '%s'" % (
                b["name"], b["type"], b["id"], best[0] / 1000, anchor["name"]), b["name"]
    # fallback: Nominatim restricted to bbox
    s, w, n, e = bbox
    try:
        res = nominatim(entry["nominatim"], viewbox="%f,%f,%f,%f" % (w, n, e, s))
    except Exception as ex:  # noqa
        log("nominatim failed for %s: %s" % (entry["slug"], ex))
        res = []
    if res:
        r = res[0]
        return float(r["lat"]), float(r["lon"]), "Nominatim '%s' -> %s/%s" % (
            entry["nominatim"], r.get("osm_type"), r.get("osm_id")), None
    return None


# ---------------------------------------------------------------- main

def main():
    global CACHE_DIR
    ap = argparse.ArgumentParser()
    ap.add_argument("--bbox", required=True, help="south,west,north,east")
    ap.add_argument("--out", required=True)
    ap.add_argument("--region", default=None)
    ap.add_argument("--cache", default=DEFAULT_CACHE)
    ap.add_argument("--no-curated", action="store_true")
    args = ap.parse_args()
    CACHE_DIR = args.cache
    bbox = tuple(float(x) for x in args.bbox.split(","))
    if len(bbox) != 4:
        ap.error("bbox must be south,west,north,east")
    region = args.region or re.sub(r"^spots_", "", os.path.splitext(os.path.basename(args.out))[0])

    coast = load_coastline(bbox)
    beaches = load_beaches(bbox)
    places = load_places(bbox)
    raw = load_candidates(bbox)

    # --- filter: must be near the water
    kept = []
    for c in raw:
        hit = coast.nearest(c["lat"], c["lon"], max_dist=MAX_SHORE_DIST_SPOT)
        d = hit[0] if hit else None
        limit = MAX_SHORE_DIST_SPOT if c["kind"] == "spot" else MAX_SHORE_DIST_BUSINESS
        status = "keep" if d is not None and d <= limit else "drop"
        log("  cand %-5s %-8s %-40s %.5f,%.5f shore=%s -> %s" % (
            c["osm_type"], c["kind"], (c["name"] or "-")[:40], c["lat"], c["lon"],
            "%.0fm" % d if d is not None else ">1.5km", status))
        if status == "keep":
            c["shore"] = d
            kept.append(c)

    # --- dedup within 800 m; prefer sport objects, then named, then nodes
    def score(c):
        return (0 if c["kind"] == "spot" else 1, 0 if c["name"] else 1,
                0 if c["osm_type"] == "node" else 1, c["osm_id"])
    kept.sort(key=score)
    spots = []
    for c in kept:
        dup = None
        for s_ in spots:
            if haversine(c["lat"], c["lon"], s_["lat"], s_["lon"]) < DEDUP_RADIUS:
                dup = s_
                break
        if dup:
            dup.setdefault("merged", []).append(c)
            continue
        spots.append(c)

    out_spots = []
    for c in spots:
        name = c["name"]
        if not name or c["kind"] == "business" or re.search(KITE_RE, norm(name)):
            # business / unnamed: name the *spot* after the beach
            nb = nearest_named(beaches, c["lat"], c["lon"], 1500)
            if nb:
                spot_name = nb[1]["name"]
            else:
                np_ = nearest_named(places, c["lat"], c["lon"], 5000)
                spot_name = ("Kite spot near %s" % np_[1]["name"]) if np_ else (
                    "Kite spot near %.4f,%.4f" % (c["lat"], c["lon"]))
            note_bits = []
            if name:
                note_bits.append("OSM object: %s" % name)
            for m in c.get("merged", []):
                if m.get("name"):
                    note_bits.append("also: %s" % m["name"])
            name = spot_name
            notes = "; ".join(note_bits) or None
        else:
            notes = None
            extra = [m["name"] for m in c.get("merged", []) if m.get("name")]
            if extra:
                notes = "also: " + ", ".join(extra)
        same = [s_ for s_ in out_spots if s_["name"] == name
                and haversine(c["lat"], c["lon"], s_["lat"], s_["lon"]) < 3000]
        if same:
            # second object on the same named beach (e.g. a school next to the spot)
            extra = "also: %s" % (c["name"] or "OSM %s/%d" % (c["osm_type"], c["osm_id"]))
            same[0]["notes"] = (same[0]["notes"] + "; " + extra) if same[0]["notes"] else extra
            continue
        out_spots.append({
            "id": "osm-%s-%d" % (c["osm_type"], c["osm_id"]),
            "name": name, "lat": c["lat"], "lon": c["lon"],
            "source": "osm", "notes": notes,
        })

    # --- curated supplement (skipped where an OSM spot is already close)
    if not args.no_curated:
        for entry in CURATED:
            r = resolve_curated(entry, beaches, places, bbox)
            if r is None:
                log("curated %s: could not resolve, skipped" % entry["slug"])
                continue
            lat, lon, how, beach_name = r
            if not (bbox[0] <= lat <= bbox[2] and bbox[1] <= lon <= bbox[3]):
                log("curated %s: outside bbox, skipped" % entry["slug"])
                continue
            near = [s_ for s_ in out_spots
                    if haversine(lat, lon, s_["lat"], s_["lon"]) < 1500]
            if near:
                log("curated %s: already covered by %s" % (entry["slug"], near[0]["name"]))
                continue
            log("curated %s: %s" % (entry["slug"], how))
            out_spots.append({
                "id": "curated-%s" % entry["slug"], "name": entry["name"],
                "lat": lat, "lon": lon, "source": "curated",
                "notes": entry.get("notes"),
            })

    # --- orientation
    final = []
    for s_ in out_spots:
        res = coast.seaward(s_["lat"], s_["lon"])
        if res is not None and res[2] < 0.7:
            # Groynes / jetties make the line zig-zag; the length-weighted mean
            # equals the direction of the chord between the window ends, so a
            # wider window reduces the influence of where those ends land.
            res = coast.seaward(s_["lat"], s_["lon"], window=2 * ORIENT_WINDOW) or res
        osrc = "osm-coastline"
        if res is None:
            res = water_orientation(s_["lat"], s_["lon"])
            osrc = "osm-water"
        if res is None:
            facing, dist, osrc, R = None, None, "unknown", None
        else:
            facing, dist, R = res
        notes = s_["notes"]
        warn = None
        if R is not None and R < 0.5:
            warn = "Zig-zag shoreline near spot (groynes/jetties); orientation less certain (resultant %.2f)." % R
        if osrc == "osm-coastline":
            wide = coast.seaward(s_["lat"], s_["lon"], window=1500.0)
            if wide is not None:
                diff = abs((facing - wide[0] + 180) % 360 - 180)
                if diff > 25:
                    w2 = ("Shoreline bends here: %.0f deg locally vs %.0f deg averaged over "
                          "+-1.5 km; orientation uncertain." % (facing, wide[0]))
                    warn = (warn + " " + w2) if warn else w2
        if warn:
            notes = (notes + " " + warn) if notes else warn
        final.append({
            "id": s_["id"],
            "name": s_["name"],
            "latitude": round(s_["lat"], 5),
            "longitude": round(s_["lon"], 5),
            "seaFacingDeg": round(facing, 1) if facing is not None else None,
            "orientationSource": osrc,
            "distanceToShoreM": round(dist, 1) if dist is not None else None,
            "source": s_["source"],
            "notes": notes,
        })
    final.sort(key=lambda s_: (s_["latitude"], s_["longitude"]))

    doc = {
        "generatedAt": datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z",
        "region": region,
        "attribution": "© OpenStreetMap contributors (ODbL)",
        "spots": final,
    }
    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
        f.write("\n")

    # --- report + sanity checks
    print("%-45s %9s %9s %7s %8s %s" % ("name", "lat", "lon", "facing", "shore_m", "source"))
    for s_ in final:
        print("%-45s %9.5f %9.5f %7s %8s %s" % (
            s_["name"][:45], s_["latitude"], s_["longitude"],
            "%.1f" % s_["seaFacingDeg"] if s_["seaFacingDeg"] is not None else "null",
            "%.0f" % s_["distanceToShoreM"] if s_["distanceToShoreM"] is not None else "-",
            s_["source"]))
    print("\nSanity checks (reference points, computed directly on the coastline):")
    refs = [("Barceloneta", "la Barceloneta", r"barceloneta", 120, 140),
            ("Castelldefels", "Castelldefels", r"castelldefels", 155, 185),
            ("Sant Pere Pescador", "Sant Pere Pescador", r"sant pere pescador|can marques|el cortal|la gaviota", 75, 105)]
    ok_all = True
    for label, anchor, rx, lo, hi in refs:
        r = resolve_curated({"slug": label, "beach": rx, "anchor": anchor,
                             "nominatim": label}, beaches, places, bbox)
        if not r:
            print("  %-20s could not resolve" % label)
            continue
        res = coast.seaward(r[0], r[1])
        if res is not None and res[2] < 0.7:
            res = coast.seaward(r[0], r[1], window=2 * ORIENT_WINDOW) or res
        f_ = res[0] if res else None
        ok = f_ is not None and lo - 10 <= f_ <= hi + 10
        ok_all &= ok
        print("  %-20s %.5f,%.5f facing=%s expected %d-%d -> %s" % (
            label, r[0], r[1], "%.1f" % f_ if f_ is not None else "null", lo, hi,
            "OK" if ok else "CHECK"))
    print("\n%d spots (%d osm, %d curated) -> %s" % (
        len(final), sum(1 for s_ in final if s_["source"] == "osm"),
        sum(1 for s_ in final if s_["source"] == "curated"), args.out))
    return 0 if ok_all else 1


if __name__ == "__main__":
    sys.exit(main())
