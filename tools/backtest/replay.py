"""Replay recent weeks from Barcelona: did the app's top picks really have wind? (WHE-63)

For every day, the app's own ranking (KiteCore, through `kite --replay`) is fed with the forecast
as it stood one day before (Open-Meteo Previous Runs, "_previous_day1"), for each setup below.
The same ranking is then fed with what the nearest official station measured (brought to 10 m,
gusts = mean wind so only strength and direction count). "Go" = the app shows a riding window
(score 40+), exactly what a rider sees.

    swift build
    python3 tools/backtest/replay.py --start 2026-09-20 --end 2026-10-31 > /tmp/replay.md

Not replayed: the model-agreement penalty (it needs live model runs), tides (none to speak of
on this coast), daylight (the afternoon slot ends before sunset in this period), real drive
times (straight-line estimate, same reach as `kite --straight-line`).
Downloads are cached in tools/backtest/.cache/ like the other scripts.
"""
import argparse
import datetime
import gzip
import json
import math
import os
import random
import statistics
import subprocess
import sys
import tempfile
import urllib.parse
from zoneinfo import ZoneInfo

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import fetch, months, xema, KN_PER_MS  # noqa: E402
from review import to_10m, usable  # noqa: E402

ORIGIN = (41.3874, 2.1686)       # Barcelona centre, the CLI default
DRIVE, SLOT, HOURS = 150, "afternoon", range(13, 18)   # SessionSlot.afternoon: 13–18 local
TZ = ZoneInfo("Europe/Madrid")
MODELS = ["meteofrance_arome_france_hd", "icon_seamless", "ecmwf_ifs025", "best_match"]
VARS = ["wind_speed_10m", "wind_gusts_10m", "wind_direction_10m", "weather_code", "cape", "precipitation"]
SETUPS = {
    "Today in the app: best match, offshore cell": [("best_match", "sea")],
    "WHE-58: AROME+ICON+ECMWF, beach cell": [("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"),
                                             ("ecmwf_ifs025", "land")],
    "WHE-61 pick: AROME+ICON beach, ECMWF offshore": [("meteofrance_arome_france_hd", "land"),
                                                      ("icon_seamless", "land"), ("ecmwf_ifs025", "sea")],
}
MF_URL = "https://meteofrance.s3.sbg.io.cloud.ovh.net/data/synchro_ftp/BASE/HOR/H_{}_latest-2025-2026.csv.gz"
MF_DEPTS = ["66", "11", "34"]
URBAN = {"X4", "WU"}     # Meteocat rooftops in Barcelona and Badalona
NO_WIND = {"UE"}         # Torroella de Montgrí: no anemometer
MAX_KM = 6.2      # station ≤ 6 km from the spot and ≤ 40 m up: hill and far-inland masts read a different wind
MAX_ALT = 40
# Land masts read lower than the wind on the water (rougher ground, shelter). WHE-62's first buoy
# look (Canet) says the gap is several knots; this factor is a sensitivity check, not a measurement.
WATER_FACTORS = (1.0, 1.15, 1.3)


def km(a, b, c, d):
    a, b, c, d = map(math.radians, (a, b, c, d))
    x = math.sin(a) * math.sin(c) + math.cos(a) * math.cos(c) * math.cos(b - d)
    return 6371 * math.acos(max(-1, min(1, x)))


# MARK: Forecasts

def om_fetch(body):
    """Open-Meteo counts each location × (variables / 10) × (days / 14) as calls, 600 a minute:
    wait out a 429 instead of failing."""
    import time
    import urllib.error
    for attempt in range(6):
        try:
            return fetch("https://previous-runs-api.open-meteo.com/v1/forecast", body)
        except urllib.error.HTTPError as e:
            if e.code != 429 or attempt == 5:
                raise
            print("Open-Meteo: per-minute limit, waiting 70 s", file=sys.stderr)
            time.sleep(70)


def previous_day1(spots, start, end, cell, batch=10):
    """spot id -> model -> UTC hour "YYYY-MM-DDTHH" -> {var: value}."""
    if len(spots) > batch:
        out = {}
        for i in range(0, len(spots), batch):
            out.update(previous_day1(spots[i:i + batch], start, end, cell, batch))
        return out
    out = {s["id"]: {m: {} for m in MODELS} for s in spots}
    for lo, hi in months(start, end):
        body = urllib.parse.urlencode({
            "latitude": ",".join(f"{s['latitude']:.4f}" for s in spots),
            "longitude": ",".join(f"{s['longitude']:.4f}" for s in spots),
            "hourly": ",".join(v + "_previous_day1" for v in VARS), "wind_speed_unit": "kn", "timezone": "GMT",
            "start_date": lo, "end_date": hi, "models": ",".join(MODELS), "cell_selection": cell,
        })
        j = json.loads(om_fetch(body))
        j = j if isinstance(j, list) else [j]
        if len(j) != len(spots) or "hourly" not in j[0]:
            sys.exit(f"Open-Meteo: {str(j)[:300]}")
        for s, r in zip(spots, j):
            h = r["hourly"]
            for m in MODELS:
                for i, t in enumerate(h["time"]):
                    vals = {v: (h.get(f"{v}_previous_day1_{m}") or [None] * (i + 1))[i] for v in VARS}
                    if vals["wind_speed_10m"] is not None and vals["wind_direction_10m"] is not None:
                        out[s["id"]][m][t[:13]] = vals
    return out


def blend(vals):
    """Same as KiteCore's Blend.hour: mean speed and gust, vector-mean direction, worst weather
    code, highest CAPE, mean rain."""
    winds = [(v["wind_speed_10m"], max(v["wind_speed_10m"], v["wind_gusts_10m"] or v["wind_speed_10m"]),
              v["wind_direction_10m"]) for v in vals]
    n = len(winds)
    sp, gu = sum(w[0] for w in winds) / n, sum(w[1] for w in winds) / n
    u = sum(w[0] * math.sin(math.radians(w[2])) for w in winds)
    vv = sum(w[0] * math.cos(math.radians(w[2])) for w in winds)
    d = winds[0][2] if u == 0 and vv == 0 else math.degrees(math.atan2(u, vv)) % 360
    out = {"speedKn": sp, "gustKn": max(gu, sp), "directionDeg": d}
    wc = [v["weather_code"] for v in vals if v["weather_code"] is not None and 0 <= v["weather_code"] <= 99]
    cape = [v["cape"] for v in vals if v["cape"] is not None]
    rain = [v["precipitation"] for v in vals if v["precipitation"] is not None]
    if wc:
        out["weatherCode"] = int(max(wc))
    if cape:
        out["capeJkg"] = max(cape)
    if rain:
        out["precipitationMm"] = sum(rain) / len(rain)
    return out


def local(utc_hour):
    t = datetime.datetime.strptime(utc_hour, "%Y-%m-%dT%H").replace(tzinfo=datetime.timezone.utc).astimezone(TZ)
    return t.strftime("%Y-%m-%dT%H:00"), int(t.utcoffset().total_seconds())


def day_files(per_spot_hours):
    """spot id -> {utc hour: HourlyWind dict} -> {day: {spot id: DayForecast}} (local days)."""
    out = {}
    for sid, hours in per_spot_hours.items():
        for uh, w in sorted(hours.items()):
            lt, off = local(uh)
            day = out.setdefault(lt[:10], {}).setdefault(sid, {"day": lt[:10], "hours": [], "utcOffsetSeconds": off})
            day["hours"].append(dict(w, localTime=lt))
    return out


def rank(files, days):
    """Run the app's ranking on a replay file -> day -> [rec dicts], best first."""
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump({d: v for d, v in files.items() if d in days}, f)
    exe = os.path.join(".build", "debug", "kite")
    res = subprocess.run([exe, "--replay", f.name, "--slot", SLOT, "--drive", str(DRIVE), "--straight-line",
                          "--from", f"{ORIGIN[0]},{ORIGIN[1]}"], capture_output=True, text=True)
    os.unlink(f.name)
    if res.returncode:
        sys.exit(res.stderr)
    return {j["day"]: j["ranked"] for j in map(json.loads, res.stdout.splitlines())}


# MARK: Stations

def xema_stations():
    rows = json.loads(fetch("https://analisi.transparenciacatalunya.cat/resource/yqwd-vj5e.json?$limit=2000"))
    return [{"source": "xema", "id": r["codi_estacio"], "name": "Meteocat " + r["nom_estacio"],
             "lat": float(r["latitud"]), "lon": float(r["longitud"]), "alt": float(r["altitud"])}
            for r in rows if r["nom_estat_ema"] == "Operativa" and r["codi_estacio"] not in URBAN | NO_WIND]


_mf = {}


def mf_rows(dept, since):
    if dept not in _mf:
        lines = gzip.decompress(fetch(MF_URL.format(dept))).decode("latin-1").splitlines()
        head = lines[0].split(";")
        keep = ["NUM_POSTE", "NOM_USUEL", "LAT", "LON", "ALTI", "AAAAMMJJHH", "FF", "DD"]
        idx = [head.index(k) for k in keep]
        di = head.index("AAAAMMJJHH")
        _mf[dept] = [dict(zip(keep, (f[i] for i in idx))) for f in (l.split(";") for l in lines[1:]) if f[di] >= since]
    return _mf[dept]


def mf_stations(since):
    out = {}
    for dept in MF_DEPTS:
        for r in mf_rows(dept, since):
            n = r["NUM_POSTE"].strip()
            if r["FF"].strip() and n not in out:
                out[n] = {"source": "meteofrance", "id": n, "dept": dept, "name": "Météo-France " + r["NOM_USUEL"].strip().title(),
                          "lat": float(r["LAT"]), "lon": float(r["LON"]), "alt": float(r["ALTI"] or 0)}
    return list(out.values())


def observations(st, start, end):
    """UTC hour -> (kn, dir), mast height."""
    if st["source"] == "xema":
        return xema(st["id"], start, end)
    lo, hi = start.replace("-", "") + "00", end.replace("-", "") + "23"
    out = {}
    for r in mf_rows(st["dept"], lo):
        d = r["AAAAMMJJHH"].strip()
        if r["NUM_POSTE"].strip() == st["id"] and lo <= d <= hi and r["FF"].strip():
            dd = r["DD"].strip()
            out[f"{d[0:4]}-{d[4:6]}-{d[6:8]}T{d[8:10]}"] = (float(r["FF"]) * KN_PER_MS, float(dd) if dd and dd != "0" else None)
    return out, 10


def match(spots, start, end):
    """spot id -> (station, km, readings, height): nearest station within MAX_KM that has wind data."""
    stations = xema_stations() + mf_stations(start.replace("-", "") + "00")
    obs_cache, out = {}, {}
    for s in spots:
        near = sorted((km(s["latitude"], s["longitude"], st["lat"], st["lon"]), st["id"], st) for st in stations)
        for d, _, st in near:
            if d > MAX_KM:
                break
            if st["alt"] > MAX_ALT:
                continue
            if st["id"] not in obs_cache:
                obs_cache[st["id"]] = observations(st, start, end)
            obs, height = obs_cache[st["id"]]
            if obs:
                out[s["id"]] = (st, d, obs, height)
                break
    return out


def truth_hours(spot, obs, height, factor=1.0):
    """Measured wind as the app's hourly input: 10 m, gust = mean (strength and direction only),
    times `factor` (sensitivity to the land-vs-water gap)."""
    out = {}
    for uh, (kn, d) in obs.items():
        v = to_10m(kn, height) * factor
        if d is None:
            if v >= 6:
                continue      # direction matters from here: unknown, leave the hour out
            d = spot["seaFacingDeg"]
        out[uh] = {"speedKn": v, "gustKn": v, "directionDeg": d}
    return out


# MARK: Scoring

def best2h(hours, spot):
    """Best two-hour mean in the slot, counting offshore hours as 0 kn."""
    by = {int(h["localTime"][11:13]): h for h in hours}
    s = [by[h]["speedKn"] if h in by and usable(by[h]["directionDeg"], spot) else (0 if h in by else None) for h in HOURS]
    pairs = [(a + b) / 2 for a, b in zip(s, s[1:]) if a is not None and b is not None]
    return max(pairs) if pairs else None


def evaluate(ranked, truth, checkable):
    """Per day: top-5 outcomes. checkable: day -> set of spot ids with enough measured hours."""
    days = {}
    for day, recs in ranked.items():
        if day not in truth:
            continue
        tgo = {r["id"] for r in truth[day] if "window" in r and r["id"] in checkable[day]}
        top = recs[:5]
        out = {"top": [], "app_go": "window" in recs[0] if recs else False, "measured_go": bool(tgo)}
        for i, r in enumerate(top):
            f_go = "window" in r
            if r["id"] not in checkable[day]:
                out["top"].append((r["id"], i, f_go, None))
            else:
                out["top"].append((r["id"], i, f_go, r["id"] in tgo))
        out["missed_spots"] = sorted(tgo - {r["id"] for r in recs if "window" in r})
        days[day] = out
    return days


def summary(days):
    c = {"days": len(days), "hit": 0, "false": 0, "nogo_ok": 0, "nogo_miss": 0, "unchecked_go": 0,
         "top1_hit": 0, "top1_false": 0, "go_days": 0, "missed_days": 0, "measured_go_days": 0, "false_days": 0}
    for d in days.values():
        for sid, i, f, t in d["top"]:
            if t is None:
                c["unchecked_go"] += f
                continue
            key = ("hit" if t else "false") if f else ("nogo_miss" if t else "nogo_ok")
            c[key] += 1
            if i == 0 and f:
                c["top1_hit" if t else "top1_false"] += 1
        c["go_days"] += d["app_go"]
        c["measured_go_days"] += d["measured_go"]
        c["missed_days"] += d["measured_go"] and not d["app_go"]
        checked_go = [t for _, _, f, t in d["top"] if f and t is not None]
        c["false_days"] += bool(checked_go) and not any(checked_go)
    return c


def boot(days_a, days_b, reps=2000, seed=1):
    """95 % interval of B − A for the share of checked 'go' picks that had wind, resampling days."""
    keys = sorted(set(days_a) & set(days_b))
    rng = random.Random(seed)

    def prec(ds, ks):
        h = f = 0
        for k in ks:
            for _, _, go, t in ds[k]["top"]:
                if go and t is not None:
                    h += t
                    f += not t
        return h / (h + f) if h + f else 0

    diffs = []
    for _ in range(reps):
        ks = [rng.choice(keys) for _ in keys]
        diffs.append(prec(days_b, ks) - prec(days_a, ks))
    diffs.sort()
    return diffs[int(0.025 * reps)], diffs[int(0.975 * reps)]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-09-20")
    ap.add_argument("--end", default="2026-10-31")
    ap.add_argument("--drop", action="append", default=[], help="treat this spot's station as missing")
    a = ap.parse_args()
    cat = json.load(open("Data/spots.json"))
    cat = cat["spots"] if isinstance(cat, dict) else cat
    # Generous box around the 150 min reach; the app's own reach filter does the rest.
    spots = [s for s in cat if 40.4 < s["latitude"] < 43.4 and 0.3 < s["longitude"] < 3.6 and s.get("tier") != "archived"]
    byid = {s["id"]: s for s in spots}
    days = [d for d in (datetime.date.fromisoformat(a.start) + datetime.timedelta(n)
                        for n in range((datetime.date.fromisoformat(a.end) - datetime.date.fromisoformat(a.start)).days + 1))]
    days = [d.isoformat() for d in days]

    # Truth, at the level measured and with the land-vs-water sensitivity factor.
    pairs = {k: v for k, v in match(spots, a.start, a.end).items() if k not in a.drop}
    truth, truth_files = {}, {}
    for fac in WATER_FACTORS:
        tf = day_files({sid: truth_hours(byid[sid], obs, h, fac) for sid, (st, d, obs, h) in pairs.items()})
        checkable = {day: {sid for sid, f in tf.get(day, {}).items()
                           if sum(int(h["localTime"][11:13]) in HOURS for h in f["hours"]) >= 4} for day in days}
        for day in days:
            for sid in list(tf.get(day, {})):
                if sid not in checkable[day]:
                    del tf[day][sid]
        truth_files[fac], truth[fac] = tf, rank(tf, days)

    # Forecasts.
    fc = {cell: previous_day1(spots, a.start, a.end, cell) for cell in ("land", "sea")}
    results, files = {}, {}
    for name, members in SETUPS.items():
        per = {}
        for s in spots:
            hrs = {}
            for uh in fc["land"][s["id"]][MODELS[0]].keys() | fc["sea"][s["id"]]["best_match"].keys():
                vals = [fc[c][s["id"]][m][uh] for m, c in members if uh in fc[c][s["id"]][m]]
                if vals:
                    hrs[uh] = blend(vals)
            per[s["id"]] = hrs
        files[name] = day_files(per)
        results_ranked[name] = rank(files[name], days)
        for fac in WATER_FACTORS:
            results[(name, fac)] = evaluate(results_ranked[name], truth[fac], checkable)

    in_reach = sorted({r["id"] for r in results_ranked[next(iter(SETUPS))][days[0]]})
    n_checkable = sorted({sid for sid in in_reach if sid in pairs})

    print(f"# Replay {a.start} … {a.end}: afternoon, {DRIVE} min from Barcelona, forecast 1 day ahead\n")
    print(f"{len(in_reach)} spots in reach, {len(n_checkable)} with an official station ≤ {MAX_KM} km and ≤ {MAX_ALT} m up. "
          f"Days with station data: {sum(1 for d in days if checkable[d])} of {len(days)}."
          + (f" Left out: {', '.join(a.drop)}." if a.drop else "") + "\n")
    print("## Stations used\n")
    print("| Spot | Station | Distance | Mast | Up (m) | Days measured |")
    print("|---|---|---|---|---|---|")
    for sid in n_checkable:
        st, d, obs, h = pairs[sid]
        print(f"| {byid[sid]['name']} | {st['name']} | {d:.1f} km | {h} m | {st['alt']:.0f} | "
              f"{sum(sid in checkable[x] for x in days)} |")
    print("\nNo usable station: " + ", ".join(byid[s]["name"] for s in in_reach if s not in pairs) + "\n")

    print("## Top 5 picks, checked against stations\n")
    print("| Setup | Station level | 'Go' picks checked | had wind | no wind (false go) | share good | Top pick: good / bad | "
          "'Go' picks with no station | Go days (app) | Go days (measured) | Missed go days | Days every checked 'go' was wrong |")
    print("|---" * 12 + "|")
    for (name, fac), days_ in results.items():
        c = summary(days_)
        chk = c["hit"] + c["false"]
        print(f"| {name} | {'as measured' if fac == 1 else f'×{fac:g} (water guess)'} | {chk} | {c['hit']} | {c['false']} | "
              f"{c['hit'] / chk * 100 if chk else 0:.0f} % | {c['top1_hit']} / {c['top1_false']} | {c['unchecked_go']} | "
              f"{c['go_days']} | {c['measured_go_days']} | {c['missed_days']} | {c['false_days']} |")
    base = next(iter(SETUPS))
    print()
    for fac in WATER_FACTORS:
        for name in list(SETUPS)[1:]:
            lo, hi = boot(results[(base, fac)], results[(name, fac)])
            print(f"- Share of good 'go' picks, {name.split(':')[0]} minus today, station level ×{fac:g}: "
                  f"{lo * 100:+.0f} … {hi * 100:+.0f} points (95 %, days resampled).")

    print("\n## Per spot, every checkable day (not only top 5)\n")
    print("'Go' = the app shows a window. Wind bias = forecast minus measured best 2 h in the slot (offshore hours as 0), "
          "station level as measured.\n")
    print(f"| Spot | Days | Measured go (×1 / ×{WATER_FACTORS[-1]:g}) | " + " | ".join(f"{n.split(':')[0]}: go / false / missed / bias" for n in SETUPS) + " |")
    print("|---" * (3 + len(SETUPS)) + "|")
    for sid in n_checkable:
        ds = [d for d in days if sid in checkable[d] and d in truth[1.0]]
        if not ds:
            continue
        tgo = {d for d in ds if any(r["id"] == sid and "window" in r for r in truth[1.0][d])}
        tgo2 = {d for d in ds if any(r["id"] == sid and "window" in r for r in truth[WATER_FACTORS[-1]][d])}
        cells = []
        for name in SETUPS:
            fgo = {d for d in ds if any(r["id"] == sid and "window" in r for r in results_ranked[name].get(d, []))}
            bias = []
            for d in ds:
                f = files[name].get(d, {}).get(sid)
                fb, ob = f and best2h(f["hours"], byid[sid]), best2h(truth_files[1.0][d][sid]["hours"], byid[sid])
                if fb is not None and ob is not None:
                    bias.append(fb - ob)
            cells.append(f"{len(fgo)} / {len(fgo - tgo)} / {len(tgo - fgo)} / "
                         + (f"{statistics.mean(bias):+.1f}" if bias else "–"))
        print(f"| {byid[sid]['name']} | {len(ds)} | {len(tgo)} / {len(tgo2)} | " + " | ".join(cells) + " |")

    for name in SETUPS:
        print(f"\n## Day by day: {name}\n")
        print(f"Each 'go' pick in the top 5: ✓ had wind, ✗ no wind, · no station (station level as measured / ×{WATER_FACTORS[-1]:g}).\n")
        print("| Day | 'Go' picks in the top 5 | Measured go, app said no |")
        print("|---|---|---|")
        for day in days:
            d, d2 = results[(name, 1.0)].get(day), results[(name, WATER_FACTORS[-1])].get(day)
            if not d or not checkable[day]:
                continue
            mark = lambda t: "·" if t is None else "✓" if t else "✗"
            top = ", ".join(f"{byid[s]['name']} {mark(t)}{mark(t2)}" for (s, _, f, t), (_, _, _, t2) in zip(d["top"], d2["top"]) if f)
            missed = ", ".join(byid[s]["name"] for s in d["missed_spots"])
            missed2 = [byid[s]["name"] for s in d2["missed_spots"] if s not in d["missed_spots"]]
            print(f"| {day} | {top or 'no go'} | {missed or '–'}" + (f" (×{WATER_FACTORS[-1]:g} adds: {', '.join(missed2)})" if missed2 else "") + " |")

results_ranked = {}

if __name__ == "__main__":
    main()
