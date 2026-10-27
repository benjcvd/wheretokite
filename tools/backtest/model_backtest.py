"""Which forecast model best predicts the measured wind at our spots? (WHE-58)

For each (spot, station) pair: past model forecasts at the spot from Open-Meteo's
historical-forecast API (the first hours of each model run, i.e. short range), compared with
the wind measured at a nearby official station (Meteocat XEMA open data, Météo-France open
data). Daylight hours only. Writes a Markdown table to stdout.

    python3 tools/backtest/model_backtest.py --start 2026-07-01 --end 2026-10-25 > /tmp/bt.md

Network results are cached in tools/backtest/.cache/ (gitignored).
"""
import argparse
import csv
import datetime
import gzip
import hashlib
import io
import json
import math
import os
import statistics
import sys
import urllib.parse
import urllib.request

CACHE = os.path.join(os.path.dirname(__file__), ".cache")
KN_PER_MS = 1.943844

MODELS = {
    "AROME 1.3 km": "meteofrance_arome_france_hd",
    "AROME 2.5 km": "meteofrance_arome_france",
    "ICON (DWD)": "icon_seamless",
    "ECMWF IFS": "ecmwf_ifs025",
    "GFS": "gfs_seamless",
    "Best match (app today)": "best_match",
}
# Blends, from the single models above.
MIXES = {
    "Mean AROME+ICON+ECMWF": ["AROME 1.3 km", "ICON (DWD)", "ECMWF IFS"],
    "Mean all 5": ["AROME 1.3 km", "AROME 2.5 km", "ICON (DWD)", "ECMWF IFS", "GFS"],
    "Mean AROME 1.3+2.5": ["AROME 1.3 km", "AROME 2.5 km"],
}
CELLS = ["sea", "land"]
KITEABLE_KN = 12          # a session for most riders on their big kite
DIRECTION_MIN_KN = 8      # direction is noise below this
DAY_UTC = range(7, 18)    # roughly 08:00–19:00 local in autumn, 09:00–20:00 in summer


def fetch(url, data=None):
    os.makedirs(CACHE, exist_ok=True)
    key = hashlib.sha1((url + (data or "")).encode()).hexdigest()
    path = os.path.join(CACHE, key)
    if os.path.exists(path):
        return open(path, "rb").read()
    req = urllib.request.Request(url, data=data.encode() if data else None,
                                 headers={"User-Agent": "WhereToKite backtest (research)"})
    for attempt in range(3):
        try:
            body = urllib.request.urlopen(req, timeout=300).read()
            break
        except OSError as e:
            if attempt == 2 or getattr(e, "code", 500) < 500:
                raise
            print(f"retrying after {e}", file=sys.stderr)
    open(path, "wb").write(body)
    return body


def months(start, end):
    """[(first day, last day)] covering start…end, by calendar month."""
    out = []
    y, m = int(start[:4]), int(start[5:7])
    while f"{y:04d}-{m:02d}" <= end[:7]:
        ny, nm = (y + 1, 1) if m == 12 else (y, m + 1)
        lo = max(start, f"{y:04d}-{m:02d}-01")
        last = (datetime.date(ny, nm, 1) - datetime.timedelta(days=1)).day
        hi = min(end, f"{y:04d}-{m:02d}-{last:02d}")
        out.append((lo, hi))
        y, m = ny, nm
    return out


# MARK: Observations (UTC hour "YYYY-MM-DDTHH" -> (speed kn, direction deg or None))

def xema(station, start, end):
    """Meteocat XEMA, Socrata open data: 10 m wind (variables 30 speed m/s, 31 direction);
    stations without a 10 m mast report at 6 m (48/49) or 2 m (46/47). Times are UTC."""
    out_by_var = {}
    for speed_var, dir_var, height in (("30", "31", 10), ("48", "49", 6), ("46", "47", 2)):
        rows = []
        # Month by month: the dataset is huge and long queries time out.
        for lo, hi in months(start, end):
            q = {
                "$select": "data_lectura,codi_variable,valor_lectura",
                "$where": f"codi_estacio='{station}' AND codi_variable in('{speed_var}','{dir_var}') AND "
                          f"data_lectura between '{lo}T00:00:00' and '{hi}T23:59:59'",
                "$limit": "50000",
            }
            rows += json.loads(fetch("https://analisi.transparenciacatalunya.cat/resource/nzvn-apee.json?"
                                     + urllib.parse.urlencode(q)))
            if not rows:
                break   # no such mast at this station
        if not rows:
            continue
        speed, direction = {}, {}
        for r in rows:
            t = r["data_lectura"][:16]
            if not t.endswith(":00"):
                continue
            h = t[:13]
            v = float(r["valor_lectura"])
            (speed if r["codi_variable"] == speed_var else direction)[h] = v
        out_by_var = {h: (s * KN_PER_MS, direction.get(h)) for h, s in speed.items()}
        return out_by_var, height
    return out_by_var, None


def meteofrance(dept, station, start, end):
    """Météo-France open data, hourly climatological files per department (meteo.data.gouv.fr):
    FF = 10 m mean wind m/s, DD = direction."""
    url = f"https://object.files.data.gouv.fr/meteofrance/data/synchro_ftp/BASE/HOR/H_{dept}_latest-2025-2026.csv.gz"
    text = gzip.decompress(fetch(url)).decode("latin-1")
    out = {}
    lo, hi = start.replace("-", "") + "00", end.replace("-", "") + "23"
    for r in csv.DictReader(io.StringIO(text), delimiter=";"):
        if r["NUM_POSTE"].strip() != station:
            continue
        d = r["AAAAMMJJHH"].strip()
        if not (lo <= d <= hi) or not r.get("FF", "").strip():
            continue
        h = f"{d[0:4]}-{d[4:6]}-{d[6:8]}T{d[8:10]}"
        dd = r.get("DD", "").strip()
        out[h] = (float(r["FF"]) * KN_PER_MS, float(dd) if dd else None)
    return out, 10


# MARK: Forecasts (label -> UTC hour -> (speed kn, direction))

def forecasts(lat, lon, start, end, cell):
    body = urllib.parse.urlencode({
        "latitude": f"{lat:.4f}", "longitude": f"{lon:.4f}",
        "hourly": "wind_speed_10m,wind_direction_10m", "wind_speed_unit": "kn", "timezone": "GMT",
        "start_date": start, "end_date": end, "models": ",".join(MODELS.values()), "cell_selection": cell,
    })
    j = json.loads(fetch("https://historical-forecast-api.open-meteo.com/v1/forecast", body))
    if "hourly" not in j:
        sys.exit(f"Open-Meteo: {j}")
    hrs = [t[:13] for t in j["hourly"]["time"]]
    out = {}
    for label, model in MODELS.items():
        s = j["hourly"].get(f"wind_speed_10m_{model}") or []
        d = j["hourly"].get(f"wind_direction_10m_{model}") or []
        out[label] = {h: (s[i], d[i]) for i, h in enumerate(hrs) if i < len(s) and s[i] is not None and d[i] is not None}
    for label, parts in MIXES.items():
        mix = {}
        for h in hrs:
            vals = [out[p][h] for p in parts if h in out[p]]
            if len(vals) != len(parts):
                continue
            u = sum(sp * math.sin(math.radians(dd)) for sp, dd in vals) / len(vals)
            v = sum(sp * math.cos(math.radians(dd)) for sp, dd in vals) / len(vals)
            mix[h] = (sum(sp for sp, _ in vals) / len(vals), math.degrees(math.atan2(u, v)) % 360)
        out[label] = mix
    return out


# MARK: Scores

def angle(a, b):
    d = abs(a - b) % 360
    return min(d, 360 - d)


def correlation(x, y):
    """Pearson r (statistics.correlation needs Python 3.10)."""
    mx, my = statistics.mean(x), statistics.mean(y)
    sxy = sum((a - mx) * (b - my) for a, b in zip(x, y))
    sx = math.sqrt(sum((a - mx) ** 2 for a in x))
    sy = math.sqrt(sum((b - my) ** 2 for b in y))
    return sxy / (sx * sy) if sx and sy else 0


def score(fc, obs):
    pairs = [(fc[h], obs[h]) for h in obs if h in fc and int(h[11:13]) in DAY_UTC]
    if len(pairs) < 50:
        return None
    err = [f[0] - o[0] for f, o in pairs]
    bias = statistics.mean(err)
    fs, os_ = [f[0] for f, _ in pairs], [o[0] for _, o in pairs]
    dirs = [angle(f[1], o[1]) for f, o in pairs if o[0] >= DIRECTION_MIN_KN and o[1] is not None]
    # Kiteable or not, once the constant offset is removed: a station on land or at 2 m reads
    # lower than the water, which says nothing about the model.
    adj = [(f[0] - bias, o[0]) for f, o in pairs]
    hit = sum(1 for f, o in adj if f >= KITEABLE_KN and o >= KITEABLE_KN)
    miss = sum(1 for f, o in adj if f < KITEABLE_KN <= o)
    false = sum(1 for f, o in adj if f >= KITEABLE_KN > o)
    return {
        "n": len(pairs),
        "mae": statistics.mean(abs(e) for e in err),
        "bias": bias,
        # Error once the constant offset (station height, exposure) is removed.
        "mae_debiased": statistics.mean(abs(e - bias) for e in err),
        "r": correlation(fs, os_),
        "dir": statistics.mean(dirs) if dirs else None,
        "kiteable_obs": hit + miss,
        # Of the windy hours measured, how many were forecast; of those forecast, how many came.
        "pod": hit / (hit + miss) if hit + miss else None,
        "precision": hit / (hit + false) if hit + false else None,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-07-01")
    ap.add_argument("--end", default="2026-10-25")
    ap.add_argument("--pairs", default=os.path.join(os.path.dirname(__file__), "pairs.json"))
    ap.add_argument("--json", help="also write all scores here")
    a = ap.parse_args()

    spots = json.load(open("Data/spots.json"))
    spots = {s["id"]: s for s in (spots["spots"] if isinstance(spots, dict) else spots)}
    results = []
    for p in json.load(open(a.pairs)):
        spot = spots[p["spot"]]
        if p["source"] == "xema":
            obs, height = xema(p["station"], a.start, a.end)
        else:
            obs, height = meteofrance(p["dept"], p["station"], a.start, a.end)
        print(f"{spot['name']}: {len(obs)} observed hours from {p['station']} ({height} m)", file=sys.stderr)
        for cell in CELLS:
            fc = forecasts(spot["latitude"], spot["longitude"], a.start, a.end, cell)
            for label, series in fc.items():
                s = score(series, obs)
                if s:
                    results.append({"spot": spot["name"], "station": p["name"], "height": height,
                                    "cell": cell, "model": label, **s})
    if a.json:
        json.dump(results, open(a.json, "w"), indent=1)
    report(results)


def fmt(x, f="{:.1f}"):
    return "–" if x is None else f.format(x)


def report(results):
    labels = list(MODELS) + list(MIXES)
    print("## Overall (mean over spots)\n")
    print("| Model | Cell | Speed error (kn) | Bias (kn) | Error without bias (kn) | Correlation | "
          "Direction error (°) | Windy hours caught | Windy forecasts that came |")
    print("|---|---|---|---|---|---|---|---|---|")
    rows = []
    for cell in CELLS:
        for m in labels:
            rs = [r for r in results if r["model"] == m and r["cell"] == cell]
            if not rs:
                continue
            avg = lambda k: statistics.mean(r[k] for r in rs if r[k] is not None) if any(r[k] is not None for r in rs) else None
            rows.append((avg("mae_debiased"), m, cell, avg("mae"), avg("bias"), avg("r"), avg("dir"), avg("pod"), avg("precision")))
    for d, m, cell, mae, bias, r, dr, pod, prec in sorted(rows, key=lambda x: x[0]):
        print(f"| {m} | {cell} | {fmt(mae)} | {fmt(bias, '{:+.1f}')} | {fmt(d)} | {fmt(r, '{:.2f}')} | {fmt(dr, '{:.0f}')} | "
              f"{fmt(pod and pod * 100, '{:.0f} %')} | {fmt(prec and prec * 100, '{:.0f} %')} |")
    print("\n## Per spot (sea cell, error without bias, kn; best in bold)\n")
    spots = sorted({(r["spot"], r["station"], r["height"]) for r in results})
    print("| Spot (station) | " + " | ".join(labels) + " |")
    print("|---" * (len(labels) + 1) + "|")
    for spot, station, height in spots:
        vals = {r["model"]: r["mae_debiased"] for r in results if r["spot"] == spot and r["cell"] == "sea"}
        best = min(vals.values()) if vals else None
        cells = [("**" + fmt(vals[m]) + "**" if vals.get(m) == best else fmt(vals.get(m))) for m in labels]
        n = next(r["n"] for r in results if r["spot"] == spot)
        print(f"| {spot} ({station}, {height} m, {n} h) | " + " | ".join(cells) + " |")


if __name__ == "__main__":
    main()
