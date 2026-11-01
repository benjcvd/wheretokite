"""Official wind stations near the Spanish and French spots, and their hourly readings (WHE-72).

Sources (all open, no key):
- Meteocat XEMA (Catalonia): masts at 10, 6 or 2 m, via model_backtest.xema.
- Météo-France hourly climatological files per department (FF = 10 min mean at 10 m), from the
  live OVH bucket (the data.gouv object mirror froze on 24 Jun 2026).
- AEMET SYNOP reports (synoptic stations, 10 m), relayed by Ogimet; positions from NOAA's
  station history file.
- Airport METARs (AEMET and Météo-France run the airport masts), from Iowa State's IEM archive.

    python3 tools/backtest/stations.py > /tmp/candidates.md   # every spot, every station ≤ 10 km

All downloads go through model_backtest.fetch (cached in tools/backtest/.cache/).
"""
import csv
import gzip
import io
import json
import math
import os
import sys
import time
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import fetch, months, xema, KN_PER_MS  # noqa: E402

MF_URL = "https://meteofrance.s3.sbg.io.cloud.ovh.net/data/synchro_ftp/BASE/HOR/H_{}_latest-2025-2026.csv.gz"
MF_DEPTS = "59 62 80 76 14 50 35 22 29 56 44 85 17 33 40 64 66 11 34 30 13 83 06 20".split()


def km(a, b, c, d):
    a, b, c, d = map(math.radians, (a, b, c, d))
    x = math.sin(a) * math.sin(c) + math.cos(a) * math.cos(c) * math.cos(b - d)
    return 6371 * math.acos(max(-1, min(1, x)))


# MARK: Station lists

def xema_stations():
    rows = json.loads(fetch("https://analisi.transparenciacatalunya.cat/resource/yqwd-vj5e.json?$limit=2000"))
    return [{"source": "xema", "id": r["codi_estacio"], "name": "Meteocat " + r["nom_estacio"],
             "lat": float(r["latitud"]), "lon": float(r["longitud"]), "alt": float(r["altitud"]), "kind": "mast"}
            for r in rows if r["nom_estat_ema"] == "Operativa"]


_mf_rows = {}


def mf_rows(dept, since="2026070100"):
    """Rows from `since` on, wind columns only, as dicts (the files have 200 columns and
    two years: keeping everything takes gigabytes)."""
    if dept not in _mf_rows:
        lines = gzip.decompress(fetch(MF_URL.format(dept))).decode("latin-1").splitlines()
        head = lines[0].split(";")
        keep = ["NUM_POSTE", "NOM_USUEL", "LAT", "LON", "ALTI", "AAAAMMJJHH", "FF", "DD", "FXI"]
        idx = [head.index(k) for k in keep]
        di = head.index("AAAAMMJJHH")
        rows = []
        for line in lines[1:]:
            f = line.split(";")
            if f[di] >= since:
                rows.append({k: f[i] for k, i in zip(keep, idx)})
        _mf_rows[dept] = rows
    return _mf_rows[dept]


def mf_stations(since="2026080100"):
    out = {}
    for dept in MF_DEPTS:
        for r in mf_rows(dept):
            if r["AAAAMMJJHH"] < since or not r["FF"].strip():
                continue
            n = r["NUM_POSTE"].strip()
            if n not in out:
                name = r["NOM_USUEL"].strip()
                kind = "semaphore" if any(w in name for w in ("SEMAPHORE", "SEM ", "PHARE", "CAP ", "PTE ", "POINTE")) else "mast"
                out[n] = {"source": "meteofrance", "id": n, "dept": dept, "name": "Météo-France " + name.title(),
                          "lat": float(r["LAT"]), "lon": float(r["LON"]), "alt": float(r["ALTI"] or 0), "kind": kind}
    return list(out.values())


def synop_stations():
    text = fetch("https://www.ncei.noaa.gov/pub/data/noaa/isd-history.csv").decode("latin-1")
    out = []
    for r in csv.DictReader(io.StringIO(text)):
        u = r["USAF"]
        if r["CTRY"] == "SP" and r["END"] >= "20250101" and u[:2] in ("08", "60") and u.endswith("0") and r["LAT"]:
            out.append({"source": "synop", "id": u[:5], "name": "AEMET " + r["STATION NAME"].title(),
                        "lat": float(r["LAT"]), "lon": float(r["LON"]), "alt": float(r["ELEV(M)"] or 0), "kind": "synop"})
    return out


def metar_stations():
    out = []
    for net in ("ES__ASOS", "FR__ASOS"):
        j = json.loads(fetch(f"https://mesonet.agron.iastate.edu/geojson/network/{net}.geojson"))
        for f in j["features"]:
            lon, lat = f["geometry"]["coordinates"]
            out.append({"source": "metar", "id": f["properties"]["sid"], "name": f"Airport {f['properties']['sname']}",
                        "lat": lat, "lon": lon, "alt": float(f["properties"].get("elevation") or 0), "kind": "airport"})
    return out


def all_stations():
    return xema_stations() + mf_stations() + synop_stations() + metar_stations()


# MARK: Readings: UTC hour "YYYY-MM-DDTHH" -> (speed kn, direction or None), plus mast height (m)

def mf_obs(dept, station, start, end):
    lo, hi = start.replace("-", "") + "00", end.replace("-", "") + "23"
    out = {}
    for r in mf_rows(dept):
        if r["NUM_POSTE"].strip() != station:
            continue
        d = r["AAAAMMJJHH"].strip()
        if not (lo <= d <= hi) or not r["FF"].strip():
            continue
        dd = r["DD"].strip()
        out[f"{d[0:4]}-{d[4:6]}-{d[6:8]}T{d[8:10]}"] = (float(r["FF"]) * KN_PER_MS, float(dd) if dd and dd != "0" else None)
    return out, 10


def synop_obs(wmo, start, end):
    """Hourly SYNOP (10 min mean wind before the hour). Units from the iw indicator."""
    out = {}
    for lo, hi in months(start, end):
        url = ("https://www.ogimet.com/cgi-bin/getsynop?" +
               urllib.parse.urlencode({"block": wmo, "begin": lo.replace("-", "") + "0000", "end": hi.replace("-", "") + "2300"}))
        cache_hit = os.path.exists(os.path.join(os.path.dirname(__file__), ".cache"))
        text = fetch(url).decode("latin-1")
        if "Status: 500" in text or "quota" in text.lower():
            sys.exit(f"Ogimet refused: {text[:200]}")
        for line in text.splitlines():
            parts = line.split(",")
            if len(parts) < 7 or parts[0] != wmo:
                continue
            g = parts[6].replace("=", "").split()
            if len(g) < 5 or g[0] != "AAXX" or "NIL" in g:
                continue
            iw = g[1][4]
            wind = g[4]
            if "/" in wind[1:5] or iw not in "0134":
                continue
            dd, ff = int(wind[1:3]), int(wind[3:5])
            if ff == 99 and len(g) > 5 and g[5].startswith("00"):
                ff = int(g[5][2:5])
            kn = ff * (KN_PER_MS if iw in "01" else 1)
            direction = None if dd in (0, 99) else dd * 10
            out[f"{parts[1]}-{parts[2]}-{parts[3]}T{parts[4]}"] = (kn, direction)
        time.sleep(0 if cache_hit else 1)
    return out, 10


def metar_obs(icao, start, end):
    """Routine METARs; the report closest to the full hour (±10 min)."""
    q = urllib.parse.urlencode([("station", icao), ("data", "sknt"), ("data", "drct"),
                                ("year1", start[:4]), ("month1", start[5:7]), ("day1", start[8:10]),
                                ("year2", end[:4]), ("month2", end[5:7]), ("day2", end[8:10]),
                                ("tz", "Etc/UTC"), ("format", "onlycomma"), ("report_type", "3")])
    text = fetch("https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py?" + q).decode()
    best = {}
    for r in csv.DictReader(io.StringIO(text)):
        if r["sknt"] in ("M", ""):
            continue
        t, minute = r["valid"][:13].replace(" ", "T"), int(r["valid"][14:16])
        hour, off = (t, minute) if minute <= 10 else (None, None)
        if minute >= 50:
            import datetime
            dt = datetime.datetime.strptime(t, "%Y-%m-%dT%H") + datetime.timedelta(hours=1)
            hour, off = dt.strftime("%Y-%m-%dT%H"), 60 - minute
        if hour and (hour not in best or off < best[hour][0]):
            d = r["drct"]
            best[hour] = (off, float(r["sknt"]), None if d in ("M", "", "0.00") else float(d))
    return {h: (v[1], v[2]) for h, v in best.items()}, 10


def observations(st, start, end):
    if st["source"] == "xema":
        return xema(st["id"], start, end)
    if st["source"] == "meteofrance":
        return mf_obs(st["dept"], st["id"], start, end)
    if st["source"] == "synop":
        return synop_obs(st["id"], start, end)
    return metar_obs(st["id"], start, end)


# MARK: Candidates

def load_spots():
    d = json.load(open("Data/spots.json"))
    return d["spots"] if isinstance(d, dict) else d


# Stations outside AROME's domain (south of 37.5° N), placed by hand from AEMET / AENA station
# descriptions: km from the open water. Cliff or hill sites are flagged by height instead.
SHORE_BY_HAND = {"GCLP": 0.6, "60030": 0.6, "GCTS": 2.0, "60025": 2.0, "GCRR": 0.3, "60040": 0.3,
                 "08458": 0.3, "LEAG": 0.1, "08453": 1.0, "08452": 0.2, "LERT": 1.0, "EQYR": 1.0, "08449": 1.0,
                 "LEMG": 1.6, "08482": 1.6, "08488": 0.3, "08487": 0.5, "LEAM": 0.5}


def coast_km(st):
    """How far a station is from the sea, approximately (km): distance to the centre of the nearest
    AROME 1.3 km sea cell (grid 1.3 km, so ≤ 1.3 means "within about 1 km of the water"). South of
    AROME's domain, SHORE_BY_HAND, else None (unknown → weak)."""
    if st["lat"] < 37.6:
        return SHORE_BY_HAND.get(st["id"])
    from esfr_backtest import om
    j = om("https://api.open-meteo.com/v1/forecast", urllib.parse.urlencode({
        "latitude": f"{st['lat']:.5f}", "longitude": f"{st['lon']:.5f}", "hourly": "wind_speed_10m",
        "forecast_days": 1, "models": "meteofrance_arome_france_hd", "cell_selection": "sea"}))
    if j.get("latitude") is None:
        return None
    return km(st["lat"], st["lon"], j["latitude"], j["longitude"])


URBAN = {"X4", "WU"}      # Meteocat rooftops in Barcelona (faculty) and Badalona (museum): weak at best
NO_WIND = {"UE"}          # Meteocat Torroella de Montgrí: no anemometer


def classify(st, d_km, shore):
    """A = mast ≤ 1.5 km from the spot; A2 = shore mast (about ≤ 1 km from the water, ≤ 40 m up)
    1.5–5 km away; C = anything else within 10 km (inland, far or high: weak)."""
    if st["id"] in URBAN:
        return "c"
    if d_km <= 1.5 and st["alt"] <= 40:
        return "a"
    if d_km <= 5 and shore is not None and shore <= 1.3 and st["alt"] <= 40:
        return "a2"
    return "c"


def main():
    """Candidates (every station ≤ 10 km) to stdout; with --pairs FILE also the chosen pair per
    spot (best class, then nearest)."""
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--pairs")
    ap.add_argument("--country", default="ES,FR")
    a = ap.parse_args()
    stations = all_stations()
    print(f"{len(stations)} stations", file=sys.stderr)
    out, pairs, shore_cache = [], [], {}
    for sp in load_spots():
        if sp["country"] not in a.country.split(",") or sp.get("tier") == "archived" or sp.get("waterType") == "lake":
            continue
        near = sorted(((km(sp["latitude"], sp["longitude"], s["lat"], s["lon"]), s) for s in stations), key=lambda x: x[0])
        near = [(d, s) for d, s in near if d <= 10 and s["id"] not in NO_WIND][:4]
        cands = []
        for d, s in near:
            k = (s["source"], s["id"])
            if k not in shore_cache:
                shore_cache[k] = coast_km(s)
            shore = shore_cache[k]
            cands.append({"station": s, "km": round(d, 2), "shore_km": None if shore is None else round(shore, 2),
                          "cls": classify(s, d, shore)})
        out.append({"spot": sp["id"], "name": sp["name"], "region": sp["region"], "tier": sp.get("tier"), "near": cands})
        rank = {"a": 0, "a2": 1, "c": 2}
        if cands:
            best = min(cands, key=lambda c: (rank[c["cls"]], c["km"]))
            pairs.append({"spot": sp["id"], **best})
    json.dump(out, sys.stdout, indent=1, ensure_ascii=False)
    if a.pairs:
        json.dump(pairs, open(a.pairs, "w"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
