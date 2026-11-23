import sys, json, math, collections
sys.path.insert(0, "tools")
import build_spots as B

def seg_hit(dx, dy, R, a, b):
    # ray from origin along (dx,dy) up to R; segment a-b; return t in [0,R] or None
    ex, ey = b[0]-a[0], b[1]-a[1]
    den = dx*ey - dy*ex
    if abs(den) < 1e-12: return None
    t = (a[0]*ey - a[1]*ex) / den
    u = (a[0]*dy - a[1]*dx) / den
    if 0 <= t <= R and 0 <= u <= 1: return t
    return None

def arc(spot, R):
    lat, lon = spot["latitude"], spot["longitude"]
    coast = B.load_coastline(lat, lon)
    p = B.LocalProj(lat, lon)
    segs = []
    for ch in coast.chains:
        pts = [p.xy(a, b) for a, b in ch]
        for a, b in zip(pts, pts[1:]):
            if max(a[0], b[0]) < -R or min(a[0], b[0]) > R or max(a[1], b[1]) < -R or min(a[1], b[1]) > R:
                continue
            segs.append((a, b))
    water = 0
    for k in range(72):
        ang = math.radians(k * 5)
        dx, dy = math.sin(ang), math.cos(ang)
        n = sum(1 for a, b in segs if seg_hit(dx, dy, R, a, b) is not None)
        if n % 2 == 1: water += 1
    return water * 5

d = json.load(open("Data/spots.json")); spots = d["spots"] if isinstance(d, dict) else d
rows = []
for s in spots:
    if s.get("orientationSource") != "osm-coastline": continue
    try:
        a = arc(s, 1000.0)
    except Exception as e:
        continue
    rows.append((s["id"], s["country"], a))
    if len(rows) % 50 == 0: print(len(rows), flush=True)
json.dump(rows, open("/tmp/arc/arcs.json", "w"))
bins = collections.Counter()
for _, _, a in rows:
    bins["<120" if a < 120 else "120-150" if a < 150 else "150-210" if a <= 210 else "210-240" if a <= 240 else ">240"] += 1
print(len(rows), dict(bins))
