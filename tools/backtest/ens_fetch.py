"""Past ECMWF ensemble forecasts (51 members) at our spots, from ECMWF's open-data archive (WHE-81).

Open-Meteo's ensemble API keeps only the last ~3 days and no day-ahead series, so it can't be
backtested. ECMWF publishes every ENS run on AWS (s3://ecmwf-forecasts, no account), one
GRIB2 file per step with an index: we fetch only the 10 m wind fields (10u, 10v) of each member
by byte range, decode them with eccodes (pip3 install --user eccodes) and keep a 7 x 7 window
of 0.25° cells around each spot. GRIB files are not kept.

Run used for day D: the 12 UTC run of D-1 (published ~20:00 local the evening before: what a
rider planning the next day sees), steps 18-30 h = 06-18 UTC on D, every 3 h.

    python3 tools/backtest/ens_fetch.py --start 2026-08-08 --end 2026-10-30 --workers 8

Output: .cache/ens/<YYYYMMDD>.json = {"points": {"lat,lon": {"<member>": {"<UTC hour>": [u, v] m/s}}}}
"""
import argparse
import datetime as dt
import json
import os
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
from stations import load_spots  # noqa: E402

BASE = "https://ecmwf-forecasts.s3.eu-central-1.amazonaws.com"
OUT = os.path.join(os.path.dirname(__file__), ".cache", "ens")
STEPS = [18, 21, 24, 27, 30]          # from 12 UTC of D-1: 06, 09, 12, 15, 18 UTC on D
HALF = 3                              # window = (2 * HALF + 1)^2 cells around the spot
PAIRS = ["pairs_esfr.json"]
EXTRA = [(42.1, 3.65), (40.7, 1.47), (42.7, 3.07)]   # Begur, Tarragona, POEM buoys


def get(url, rng=None, tries=6):
    for i in range(tries):
        try:
            req = urllib.request.Request(url, headers={"Range": f"bytes={rng[0]}-{rng[1]}"} if rng else {})
            with urllib.request.urlopen(req, timeout=60) as r:
                return r.read()
        except Exception as e:  # noqa: BLE001 (network hiccups: retry)
            if i == tries - 1:
                raise
            print(f"retry {url} {e}", file=sys.stderr)
            time.sleep(3 * (i + 1))


def cells():
    """Grid indices (row, col) of every cell we keep. Grid: 90 → -90 by 0.25, lon -180 → 179.75."""
    here = os.path.dirname(__file__)
    spots = {s["id"]: s for s in load_spots()}
    pts = list(EXTRA)
    for f in PAIRS:
        for p in json.load(open(os.path.join(here, f))):
            s = spots[p["spot"]]
            pts.append((s["latitude"], s["longitude"]))
    keep = set()
    for lat, lon in pts:
        j0, i0 = round((90 - lat) / 0.25), round(((lon + 180) % 360) / 0.25)
        for dj in range(-HALF, HALF + 1):
            for di in range(-HALF, HALF + 1):
                keep.add((j0 + dj, (i0 + di) % 1440))
    return sorted(keep)


def fetch_step(run, step, keep):
    """{member: (u values, v values)} at the kept cells for one step."""
    import eccodes
    stem = f"{run:%Y%m%d}/12z/ifs/0p25/enfo/{run:%Y%m%d}120000-{step}h-enfo-ef"
    index = [json.loads(line) for line in get(f"{BASE}/{stem}.index").decode().splitlines() if line.strip()]
    out = {}
    for e in index:
        if e.get("param") not in ("10u", "10v") or e.get("type") not in ("cf", "pf"):
            continue
        member = 0 if e["type"] == "cf" else int(e["number"])
        raw = get(f"{BASE}/{stem}.grib2", (e["_offset"], e["_offset"] + e["_length"] - 1))
        g = eccodes.codes_new_from_message(raw)
        vals = eccodes.codes_get_values(g)
        eccodes.codes_release(g)
        out.setdefault(member, {})[e["param"]] = [round(float(vals[j * 1440 + i]), 2) for j, i in keep]
    return out


def fetch_part(day, step, keep):
    """One (day, step) unit, saved on its own so an interrupted run resumes where it stopped."""
    path = os.path.join(OUT, "parts", f"{day:%Y%m%d}_{step}.json")
    if not os.path.exists(path):
        data = fetch_step(day - dt.timedelta(days=1), step, keep)
        json.dump(data, open(path + ".tmp", "w"), separators=(",", ":"))
        os.replace(path + ".tmp", path)
    return path


def assemble(day, keep):
    path = os.path.join(OUT, f"{day:%Y%m%d}.json")
    if os.path.exists(path):
        return
    points = {f"{90 - j * 0.25:.2f},{i * 0.25 - 180:.2f}": {} for j, i in keep}
    keys = list(points)
    for step in STEPS:
        part = os.path.join(OUT, "parts", f"{day:%Y%m%d}_{step}.json")
        if not os.path.exists(part):
            return
        hour = (12 + step) % 24
        for member, uv in json.load(open(part)).items():
            if "10u" not in uv or "10v" not in uv:
                continue
            for k, u, v in zip(keys, uv["10u"], uv["10v"]):
                points[k].setdefault(str(member), {})[str(hour)] = [u, v]
    run = day - dt.timedelta(days=1)
    json.dump({"run": f"{run:%Y-%m-%d}T12", "points": points}, open(path + ".tmp", "w"), separators=(",", ":"))
    os.replace(path + ".tmp", path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-08-08")
    ap.add_argument("--end", default="2026-10-30")
    ap.add_argument("--workers", type=int, default=6)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    keep = cells()
    print(f"{len(keep)} cells kept per field", file=sys.stderr)
    d0, d1 = dt.date.fromisoformat(a.start), dt.date.fromisoformat(a.end)
    days = [d0 + dt.timedelta(days=k) for k in range((d1 - d0).days + 1)]
    os.makedirs(os.path.join(OUT, "parts"), exist_ok=True)
    todo = [(d, st) for d in days if not os.path.exists(os.path.join(OUT, f"{d:%Y%m%d}.json")) for st in STEPS]
    t = time.time()
    with ThreadPoolExecutor(a.workers) as ex:
        for i, _ in enumerate(ex.map(lambda u: fetch_part(u[0], u[1], keep), todo)):
            print(f"{i + 1}/{len(todo)} parts {time.time() - t:.0f} s", file=sys.stderr)
    for d in days:
        assemble(d, keep)

if __name__ == "__main__":
    main()
