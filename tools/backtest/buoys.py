"""Forecasts against wind measured on the water: moored buoys (WHE-62).

Every station in pairs.json is on land. This script uses buoys from the Copernicus Marine
In Situ TAC, whose public HTTPS mirror needs no account:
https://data-marineinsitu.ifremer.fr/glo_multiparameter_nrt/ (monthly files, and daily
files under latest/ for the last ~30 days).

Two questions:
A. At each buoy: does each model read too high or too low over open water? (forecast read at
   the buoy, sea cell; for the near-shore buoy, the land cell too).
B. Near-shore buoy POEM (2.3 km off Canet-en-Roussillon): the app's setups read at the
   nearest kite spots on the same straight sandy coast, against the wind on the water.

Measured wind brought to 10 m with a neutral log profile over sea (z0 = 0.2 mm): ×1.12 from
3 m, ×1.17 from 2 m. Forecasts from Open-Meteo's Previous Runs API (review.previous_runs),
days 0, 1, 2 ahead. Scores and bootstrap reused from review.py.

Needs the netCDF4 package (pip3 install --user netCDF4): the buoy files are NetCDF-4.

    python3 tools/backtest/buoys.py --start 2026-01-01 --end 2026-10-31 > /tmp/buoys.md
"""
import argparse
import datetime as dt
import json
import math
import os
import statistics
import sys
import urllib.request

sys.path.insert(0, os.path.dirname(__file__))
from review import (LEADS, SETUPS, previous_runs, combine, hour_stats, days_of, day_stats,  # noqa: E402
                    bootstrap, fmt, pct, DAY_UTC, MODELS, SHORT, usable)

MIRROR = "https://data-marineinsitu.ifremer.fr/glo_multiparameter_nrt"
CACHE = os.path.join(os.path.dirname(__file__), ".cache", "buoys")
Z0_SEA = 0.0002
MS_TO_KN = 1.943844

# id -> file prefix, name, anemometer height (m), spots on the same coast for question B
BUOYS = {
    "POEM": {"prefix": "GL_TS_MO_POEM", "name": "POEM buoy, 2.3 km off Canet-en-Roussillon (CNRS)",
             "height": 2, "spots": ["fr-torreilles-le-blockhaus", "fr-saint-cyprien-canet-pont-des-basses"]},
    "6100196": {"prefix": "IR_TS_MO_6100196", "name": "Cabo Begur buoy, 25 km off Begur (Puertos del Estado)",
                "height": 3, "spots": []},
    "6100280": {"prefix": "IR_TS_MO_6100280", "name": "Tarragona buoy, 40 km off Tarragona (Puertos del Estado)",
                "height": 3, "spots": []},
}


def download(path):
    os.makedirs(CACHE, exist_ok=True)
    local = os.path.join(CACHE, path.replace("/", "_"))
    if not os.path.exists(local):
        try:
            with urllib.request.urlopen(f"{MIRROR}/{path}", timeout=120) as r:
                data = r.read()
        except Exception as e:  # missing month or day: skip it
            print(f"  no {path}: {e}", file=sys.stderr)
            return None
        with open(local, "wb") as f:
            f.write(data)
    return local


def buoy_files(prefix, start, end):
    """Monthly files for full past months, daily files (latest/) for the current month."""
    d0, d1 = dt.date.fromisoformat(start), dt.date.fromisoformat(end)
    today = dt.date.today()
    out = []
    m = d0.replace(day=1)
    while m <= d1:
        if (m.year, m.month) < (today.year, today.month):
            out.append(f"monthly/MO/{m:%Y%m}/{prefix}_{m:%Y%m}.nc")
        else:
            day = max(m, d0)
            while day <= min(d1, today) and day.month == m.month:
                out.append(f"latest/{day:%Y%m%d}/{prefix}_{day:%Y%m%d}.nc")
                day += dt.timedelta(days=1)
        m = (m + dt.timedelta(days=32)).replace(day=1)
    return out


def read_buoy(prefix, start, end):
    """hour 'YYYY-MM-DDTHH' (UTC) -> (speed kn at the sensor, direction from); position.
    Samples within ±30 min of the hour are averaged (speed scalar, direction vector).
    Only QC flags 1 (good) and 2 (probably good) are kept."""
    import netCDF4
    samples = {}
    pos = None
    for path in buoy_files(prefix, start, end):
        local = download(path)
        if not local:
            continue
        d = netCDF4.Dataset(local)
        t = d.variables["TIME"][:]
        sp, di = d.variables["WSPD"][:], d.variables["WDIR"][:]
        qs, qd = d.variables["WSPD_QC"][:], d.variables["WDIR_QC"][:]
        lat, lon = d.variables["LATITUDE"][:], d.variables["LONGITUDE"][:]
        pos = (float(lat.ravel()[-1]), float(lon.ravel()[-1]))
        base = dt.datetime(1950, 1, 1)
        k = 0  # the wind sits on the first level in these files
        for i in range(len(t)):
            s, w = sp[i, k], di[i, k]
            if s is None or w is None or getattr(s, "mask", False) or getattr(w, "mask", False):
                continue
            if int(qs[i, k]) not in (1, 2) or int(qd[i, k]) not in (1, 2):
                continue
            when = base + dt.timedelta(days=float(t[i]))
            hour = (when + dt.timedelta(minutes=30)).replace(minute=0, second=0, microsecond=0)
            key = hour.strftime("%Y-%m-%dT%H")
            if start <= key[:10] <= end:
                samples.setdefault(key, []).append((float(s) * MS_TO_KN, float(w)))
        d.close()
    out = {}
    for h, vals in samples.items():
        u = sum(s * math.sin(math.radians(w)) for s, w in vals)
        v = sum(s * math.cos(math.radians(w)) for s, w in vals)
        out[h] = (statistics.mean(s for s, _ in vals), math.degrees(math.atan2(u, v)) % 360)
    return out, pos


def to_10m_sea(kn, height):
    return kn * math.log(10 / Z0_SEA) / math.log(height / Z0_SEA)


def km(a, b):
    la1, lo1, la2, lo2 = map(math.radians, (*a, *b))
    x = (lo2 - lo1) * math.cos((la1 + la2) / 2)
    return 6371 * math.hypot(x, la2 - la1)


# Question A: one model at a time, read at the buoy
AT_BUOY = {f"{SHORT[m]}, sea": ("mean", [(m, "sea")]) for m in MODELS}
AT_BUOY.update({f"{SHORT[m]}, land": ("mean", [(m, "land")]) for m in MODELS})


def rows(obs, height, fc, setups, pair, spot):
    hs = []
    for h, (kn, d) in obs.items():
        if int(h[11:13]) not in DAY_UTC:
            continue
        f = {}
        for name, (kind, members) in setups.items():
            for lead in LEADS:
                c = combine(kind, members, fc, lead, h)
                if c:
                    f[(name, lead)] = c
        hs.append({"pair": pair, "spot": spot, "day": h[:10], "hour": h, "obs": to_10m_sea(kn, height),
                   "obs_raw": kn, "dir": d, "height": height, "fc": f})
    return hs


def raw_bias(hs, key):
    """Bias against the anemometer as read, no height correction (sensitivity check)."""
    e = [x["fc"][key][0] - x["obs_raw"] for x in hs if key in x["fc"]]
    return statistics.mean(e) if e else None


def windy_bias(hs, key, thr=12):
    e = [x["fc"][key][0] - x["obs"] for x in hs if key in x["fc"] and x["obs"] >= thr]
    return (statistics.mean(e), len(e)) if len(e) >= 20 else (None, len(e))


def table(hs, setups, lead, title):
    print(f"#### {title}\n")
    print("| Setup | Hours | Bias | Bias, no height correction | Bias when 12 kn+ measured | Error | 12 kn+ hours caught | false alarms | "
          "15 kn+ caught | false | Best 2 h bias | Best 2 h error | Go days 12+ caught | false | Direction error |")
    print("|---" * 15 + "|")
    for name in setups:
        key = (name, lead)
        h12, h15 = hour_stats(hs, key, 12), hour_stats(hs, key, 15)
        if not h12:
            continue
        wb, wn = windy_bias(hs, key)
        d = days_of(hs, key)
        d12 = day_stats(d, 12)
        print(f"| {name} | {h12['n']} | {fmt(h12['bias'], '{:+.1f}')} | {fmt(raw_bias(hs, key), '{:+.1f}')} | {fmt(wb, '{:+.1f}')} ({wn} h) | {fmt(h12['mae'])} | "
              f"{pct(h12['pod'])} | {pct(h12['far'])} | {pct(h15['pod'])} | {pct(h15['far'])} | "
              f"{fmt(d12 and d12['bias'], '{:+.1f}')} | {fmt(d12 and d12['mae'])} | {pct(d12 and d12['pod'])} | "
              f"{pct(d12 and d12['far'])} | {fmt(h12['dir'], '{:.0f}°')} |")
    print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-01-01")
    ap.add_argument("--end", default="2026-10-31")
    ap.add_argument("--buoy", action="append", help="only these buoy ids")
    ap.add_argument("--leads", default="0,1,2")
    ap.add_argument("--split", default="2026-07-01", help="also report the periods before / after this day")
    a = ap.parse_args()
    leads = [int(x) for x in a.leads.split(",")]
    spots = json.load(open("Data/spots.json"))
    spots = {s["id"]: s for s in (spots["spots"] if isinstance(spots, dict) else spots)}
    open_water = {"waterType": "lagoon"}  # any direction counts as usable at a buoy

    print(f"# Forecasts against buoys, {a.start} … {a.end}\n")
    print("Measured wind brought to 10 m (log profile over sea, z0 = 0.2 mm). Daylight 07–17 UTC. "
          "No bias removed. Forecast read at the buoy unless said otherwise.\n")
    for bid, b in BUOYS.items():
        if a.buoy and bid not in a.buoy:
            continue
        obs, pos = read_buoy(b["prefix"], a.start, a.end)
        if not obs:
            print(f"## {b['name']}: no data\n")
            continue
        fc = {cell: previous_runs(pos[0], pos[1], a.start, a.end, cell) for cell in ("sea", "land")}
        raw = statistics.mean(v[0] for v in obs.values())
        print(f"## {b['name']}\n")
        print(f"Position {pos[0]:.4f}, {pos[1]:.4f}; anemometer {b['height']} m above the sea; {len(obs)} hours "
              f"with good data; mean {raw:.1f} kn at {b['height']} m, {to_10m_sea(raw, b['height']):.1f} kn at 10 m.\n")
        hs = rows(obs, b["height"], fc, AT_BUOY, bid, open_water)
        periods = [("all", hs), (f"before {a.split}", [x for x in hs if x["day"] < a.split]),
                   (f"from {a.split}", [x for x in hs if x["day"] >= a.split])]
        print("### A. Each model, read at the buoy\n")
        for lead in leads:
            for pname, sub in periods:
                if len({x['day'] for x in sub}) >= 20:
                    table(sub, AT_BUOY, lead, f"Day {lead} ahead, {pname} ({len({x['day'] for x in sub})} days)")

        for sid in b["spots"]:
            spot = spots[sid]
            sfc = {cell: previous_runs(spot["latitude"], spot["longitude"], a.start, a.end, cell) for cell in ("land", "sea")}
            shs = rows(obs, b["height"], sfc, SETUPS, sid, spot)
            dist = km(pos, (spot["latitude"], spot["longitude"]))
            print(f"### B. App setups read at {spot['name']} ({dist:.1f} km from the buoy), against the buoy\n")
            for lead in leads:
                onshore = [x for x in shs if usable(x["dir"], spot)]
                for pname, sub in [("all", shs), (f"before {a.split}", [x for x in shs if x["day"] < a.split]),
                                   (f"from {a.split}", [x for x in shs if x["day"] >= a.split]),
                                   ("measured wind not offshore at the spot", onshore),
                                   (f"not offshore, from {a.split}", [x for x in onshore if x["day"] >= a.split])]:
                    if len({x['day'] for x in sub}) >= 20:
                        table(sub, SETUPS, lead, f"Day {lead} ahead, {pname} ({len({x['day'] for x in sub})} days)")
            print("Change against the old setup, best 2 h window, 95 % interval over days:\n")
            print("| Setup | Lead | Days | Change in best 2 h error (kn) | Change in go-day score 12 kn (CSI) |")
            print("|---|---|---|---|---|")
            base = "Old: best match, sea cell"
            for name in ("New: mean AROME 1.3+ICON+ECMWF, land", "Mean AROME 1.3+ICON land, ECMWF sea",
                         "Mean AROME 1.3+ICON, land", "AROME 1.3, land", "Best match, land"):
                for lead in leads:
                    try:
                        n, (m_lo, m_hi), (c_lo, c_hi) = bootstrap(shs, (base, lead), (name, lead), 12)
                    except (ValueError, IndexError, statistics.StatisticsError):
                        continue
                    print(f"| {name} | {lead} | {n} | {m_lo:+.2f} … {m_hi:+.2f} | {c_lo:+.2f} … {c_hi:+.2f} |")
            print()
            # Concrete days: windiest measured days with rideable direction, Jul-Oct, day 1 ahead
            names = [base, "New: mean AROME 1.3+ICON+ECMWF, land", "Mean AROME 1.3+ICON land, ECMWF sea", "AROME 1.3, land"]
            ride = [x for x in shs if usable(x["dir"], spot) and x["day"] >= a.split]
            ds = [days_of(ride, (n, 1)) for n in names]
            common = [k for k in ds[0] if all(k in d for d in ds)]
            top = sorted(common, key=lambda k: -ds[0][k][1])[:8]
            print(f"Windiest measured days from {a.split}, wind not offshore (best 2 h, kn, forecast a day ahead):\n")
            print("| Day | Buoy (10 m) | Old | New 3-model beach | AROME+ICON beach, ECMWF sea | AROME 1.3 beach |")
            print("|---|---|---|---|---|---|")
            for k in sorted(top, key=lambda k: k[1]):
                print(f"| {k[1]} | {ds[0][k][1]:.0f} | " + " | ".join(f"{d[k][0]:.0f}" for d in ds) + " |")
            print()


if __name__ == "__main__":
    main()
