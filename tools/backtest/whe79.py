"""Why do easterly days on the Tarragona coast read too light? (WHE-79)

Spots: Altafulla, Torredembarra, Creixell (Costa Daurada, beaches facing SSE).
Truth (07-17 UTC):
  - Meteocat DK Torredembarra (0.6 km from the Torredembarra pin, 2 m above sea level, by the beach),
  - Meteocat XE Tarragona and WZ Cunit (coastal, 18-20 km away) to see whether DK is the odd one,
  - Puertos del Estado Tarragona buoy (open sea, 40 km out), brought from 3 m to 10 m over sea.
Forecasts: Open-Meteo Previous Runs (day 0, 1, 2), each model on the beach cell (land) and sea cell,
plus today's app mix (WHE-87: MF seamless beach + ECMWF 9 km sea + GFS sea).
Day type = measured direction at the mast; "easterly" = the 07-17 UTC vector-mean direction at DK
between 45 and 135 deg with a measured mean of at least 6 kn (so calm days with noise are left out).

    python3 tools/backtest/whe79.py --fetch            # fill the cache (~1k weighted calls)
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe79.py > tools/backtest/results/whe79.md
"""
import argparse
import concurrent.futures as cf
import datetime as dt
import json
import math
import os
import random
import statistics
import sys
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from chance import HOURS, LO, HI, ride, best2  # noqa: E402
from esfr_backtest import om, vmean  # noqa: E402
from model_backtest import months  # noqa: E402
from review import to_10m  # noqa: E402
from stations import observations, xema_stations, load_spots, km  # noqa: E402

START, END = "2026-01-01", "2026-11-04"
LEADS = [0, 1, 2]
MODELS = ["best_match", "meteofrance_seamless", "meteofrance_arome_france_hd", "icon_seamless", "ecmwf_ifs",
          "gfs_seamless"]
SHORT = {"best_match": "best match", "meteofrance_seamless": "MF seamless", "meteofrance_arome_france_hd": "AROME HD",
         "icon_seamless": "ICON", "ecmwf_ifs": "ECMWF 9 km", "gfs_seamless": "GFS"}
CELLS = ["land", "sea"]
APP = [("meteofrance_seamless", "land"), ("ecmwf_ifs", "sea"), ("gfs_seamless", "sea")]
SPOTS = ["es-altafulla", "es-torredembarra", "es-creixell"]
MAST = "DK"
OTHERS = ["XE", "WZ"]
BUOY = ("IR_TS_MO_6100280", 3)
CELLINFO = {}


def name(src):
    if isinstance(src, str):
        return src
    return f"{SHORT[src[0]]}, {'beach' if src[1] == 'land' else 'sea'} cell"


# MARK: Data

def fetch(lat, lon, model, cell):
    """lead -> 'YYYY-MM-DDTHH' -> (kn, dir), 07-17 UTC; also notes where the cell falls."""
    sufs = {0: ""} | {n: f"_previous_day{n}" for n in LEADS if n}
    vars_ = ",".join(f"{v}{s}" for s in sufs.values() for v in ("wind_speed_10m", "wind_direction_10m"))
    out = {n: {} for n in LEADS}
    for lo, hi in months(START, END):
        body = urllib.parse.urlencode({
            "latitude": f"{lat:.5f}", "longitude": f"{lon:.5f}", "hourly": vars_,
            "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
            "models": model, "cell_selection": cell})
        j = om("https://previous-runs-api.open-meteo.com/v1/forecast", body)
        if j.get("latitude") is not None:
            CELLINFO[(f"{lat:.4f}", model, cell)] = (j["latitude"], j["longitude"], j.get("elevation"))
        h = j.get("hourly") or {}
        for n, suf in sufs.items():
            sp, d = h.get(f"wind_speed_10m{suf}") or [], h.get(f"wind_direction_10m{suf}") or []
            for t, a, b in zip(h.get("time", []), sp, d):
                if a is not None and b is not None and 7 <= int(t[11:13]) <= 17:
                    out[n][t[:13]] = (a, b)
    return out


def obs_mast(sid):
    st = next(s for s in xema_stations() if s["id"] == sid)
    o, h = observations(st, START, END)
    return st, h, {k: (to_10m(kn, h), d) for k, (kn, d) in o.items() if 7 <= int(k[11:13]) <= 17}


def obs_buoy():
    from buoys import read_buoy, to_10m_sea
    o, pos = read_buoy(BUOY[0], START, END)
    return pos, {k: (to_10m_sea(kn, BUOY[1]), d) for k, (kn, d) in o.items() if 7 <= int(k[11:13]) <= 17}


def all_forecasts(points, workers=4):
    jobs = {(pid, m, c): (lat, lon, m, c) for pid, (lat, lon, cells) in points.items() for m in MODELS for c in cells}
    out = {}
    with cf.ThreadPoolExecutor(workers) as ex:
        futs = {ex.submit(fetch, *a): k for k, a in jobs.items()}
        for i, f in enumerate(cf.as_completed(futs)):
            out[futs[f]] = f.result()
            if i % 10 == 0:
                print(f"  {i}/{len(jobs)} series", file=sys.stderr)
    return out


# MARK: Helpers

def vdir(vals):
    """Speed-weighted vector mean direction (deg from) of [(kn, dir)]."""
    u = sum(s * math.sin(math.radians(d)) for s, d in vals if d is not None)
    v = sum(s * math.cos(math.radians(d)) for s, d in vals if d is not None)
    return math.degrees(math.atan2(u, v)) % 360 if (u or v) else None


def sector(d):
    if d is None:
        return "?"
    if 45 <= d < 135:
        return "E (llevant)"
    if 135 <= d < 200:
        return "SE-S (marinada)"
    if 200 <= d < 270:
        return "SW-W (garbí)"
    return "NW-NE (mestral, tramuntana)"


SECTORS = ["E (llevant)", "SE-S (marinada)", "SW-W (garbí)", "NW-NE (mestral, tramuntana)"]


def day_series(src_series, ds):
    x = {h: src_series.get(f"{ds}T{h:02d}") for h in HOURS}
    return x if all(x.values()) else None


def mix(sers):
    got = [s for s in sers if s]
    if len(got) < len(sers):
        return None
    return {h: vmean([s[h] for s in got]) for h in HOURS}


def days():
    d, last = dt.date.fromisoformat(START), dt.date.fromisoformat(END)
    while d <= last:
        yield d.isoformat()
        d += dt.timedelta(days=1)


def boot(vals_by_day, reps=1000, seed=79):
    """95 % interval of the mean over days (each day resampled whole)."""
    keys = list(vals_by_day)
    if len(keys) < 5:
        return None
    rnd = random.Random(seed)
    means = []
    for _ in range(reps):
        s = [vals_by_day[rnd.choice(keys)] for _ in keys]
        means.append(statistics.mean(s))
    means.sort()
    return means[int(0.025 * reps)], means[int(0.975 * reps)]


def f1(x, sign=False):
    if x is None:
        return "–"
    return f"{x:+.1f}" if sign else f"{x:.1f}"


# MARK: Report

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fetch", action="store_true")
    a = ap.parse_args()
    spots = {s["id"]: s for s in load_spots()}
    dk, dk_h, dk_obs = obs_mast(MAST)
    others = {sid: obs_mast(sid) for sid in OTHERS}
    bpos, buoy = obs_buoy()
    points = {sid: (spots[sid]["latitude"], spots[sid]["longitude"], CELLS) for sid in SPOTS}
    points["buoy"] = (bpos[0], bpos[1], ["sea"])
    for sid, (st, _, _) in others.items():
        points[sid] = (st["lat"], st["lon"], CELLS)
    fc = all_forecasts(points)
    if a.fetch:
        print("cache filled", file=sys.stderr)

    print(f"# WHE-79: easterly days on the Tarragona coast, {START} … {END}\n")
    print(f"Mast: {dk['name']} ({dk['lat']:.4f}, {dk['lon']:.4f}, {dk['alt']:.0f} m above sea level, "
          f"anemometer {dk_h} m), {km(dk['lat'], dk['lon'], spots['es-torredembarra']['latitude'], spots['es-torredembarra']['longitude']):.1f} km "
          f"from the Torredembarra pin. Buoy at {bpos[0]:.3f}, {bpos[1]:.3f}. Hours 07–17 UTC, measured wind at 10 m.\n")

    # 1. Where each cell falls
    print("## 1. Where each model reads the wind\n")
    print("| Spot | Source | Cell lat, lon | km from pin |")
    print("|---|---|---|---|")
    for sid in SPOTS:
        s = spots[sid]
        for m in MODELS:
            for c in CELLS:
                info = CELLINFO.get((f"{s['latitude']:.4f}", m, c))
                if not info:
                    continue
                print(f"| {s['name']} | {name((m, c))} | {info[0]:.3f}, {info[1]:.3f} | "
                      f"{km(s['latitude'], s['longitude'], info[0], info[1]):.1f} |")
    print()

    # Day table at Torredembarra (mast): sector, measured best 2 h, go
    spot = spots["es-torredembarra"]
    srcs = [(m, c) for m in MODELS for c in CELLS]
    rows = []
    for ds in days():
        o = {h: dk_obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in dk_obs}
        if len(o) < len(HOURS):
            continue
        mean_kn = statistics.mean(v[0] for v in o.values())
        sec = sector(vdir(o.values())) if mean_kn >= 6 else "light (< 6 kn)"
        bo = {h: buoy.get(f"{ds}T{h:02d}") for h in HOURS}
        bo = bo if all(bo.values()) else None
        r = {"day": ds, "sector": sec, "obs": o, "ob2": best2(o, spot), "go": ride(o, spot), "mean": mean_kn,
             "buoy": bo, "fc": {}}
        for lead in LEADS:
            for src in srcs:
                ser = day_series(fc[("es-torredembarra", *src)][lead], ds)
                if ser:
                    r["fc"][(lead, src)] = ser
            app = mix([r["fc"].get((lead, s)) for s in APP])
            if app:
                r["fc"][(lead, "app")] = app
            bser = day_series(fc[("buoy", "ecmwf_ifs", "sea")][lead], ds)
            if bser:
                r["fc"][(lead, "buoy ECMWF")] = bser
            for m in MODELS:
                bser = day_series(fc[("buoy", m, "sea")][lead], ds)
                if bser:
                    r["fc"][(lead, ("buoy", m))] = bser
        rows.append(r)

    print("## 2. Days measured at Torredembarra, by wind direction\n")
    print("| Day type (mast direction) | Days | Go days measured (2 h 12–28 kn) | Mean of measured best 2 h |")
    print("|---|---|---|---|")
    for sec in SECTORS + ["light (< 6 kn)"]:
        rs = [r for r in rows if r["sector"] == sec]
        if rs:
            print(f"| {sec} | {len(rs)} | {sum(r['go'] for r in rs)} | {statistics.mean(r['ob2'] for r in rs):.1f} |")
    print(f"\n{len(rows)} complete days. Months with no data at the mast: "
          f"{', '.join(sorted({d[:7] for d in (x for x in days())} - {r['day'][:7] for r in rows})) or 'none'}.\n")

    names = srcs + ["app"]

    def label(s):
        return "Today's app (MF beach + ECMWF 9 km sea + GFS sea)" if s == "app" else name(s)

    for lead in (1, 0, 2):
        print(f"## 3.{lead} Forecast vs Torredembarra mast, by day type, {'day ahead' if lead == 1 else 'same day' if lead == 0 else '2 days ahead'}\n")
        print("Best 2 h error (forecast − measured), mean over days, 95 % interval over days; "
              "go days caught = forecast go on a measured go day; false go = forecast go, mast no go.\n")
        for sec in SECTORS:
            rs = [r for r in rows if r["sector"] == sec]
            if len(rs) < 5:
                continue
            ngo = sum(r["go"] for r in rs)
            print(f"### {sec}: {len(rs)} days, {ngo} measured go\n")
            print("| Source | Days | Best 2 h error kn [95 %] | Speed ratio measured ÷ forecast (hours ≥ 8 kn fc) | Go caught | False go |")
            print("|---|---|---|---|---|---|")
            for s in names:
                have = [r for r in rs if (lead, s) in r["fc"]]
                if len(have) < 5:
                    continue
                errs = {r["day"]: best2(r["fc"][(lead, s)], spot) - r["ob2"] for r in have}
                iv = boot(errs)
                num = sum(r["obs"][h][0] for r in have for h in HOURS if r["fc"][(lead, s)][h][0] >= 8)
                den = sum(r["fc"][(lead, s)][h][0] for r in have for h in HOURS if r["fc"][(lead, s)][h][0] >= 8)
                caught = sum(1 for r in have if r["go"] and ride(r["fc"][(lead, s)], spot))
                false = sum(1 for r in have if not r["go"] and ride(r["fc"][(lead, s)], spot))
                gos = sum(r["go"] for r in have)
                print(f"| {label(s)} | {len(have)} | {f1(statistics.mean(errs.values()), True)} "
                      f"[{f1(iv[0], True)}, {f1(iv[1], True)}] | {num / den:.2f} | {caught}/{gos} | {false} |"
                      if iv and den else f"| {label(s)} | {len(have)} | – | – | {caught}/{gos} | {false} |")
            print()

    # 4. Open sea: is the easterly itself under-forecast, or only near the beach?
    print("## 4. Open sea (Tarragona buoy) on the same days, day ahead\n")
    print("Mean wind 07–17 UTC, measured at the buoy vs each model's sea cell at the buoy, and the "
          "Torredembarra mast vs the same model's beach cell.\n")
    for sec in SECTORS:
        rs = [r for r in rows if r["sector"] == sec and r["buoy"]]
        if len(rs) < 5:
            continue
        print(f"### {sec}: {len(rs)} days with the buoy\n")
        print("| Model | Buoy measured | Buoy forecast (sea cell) | Ratio | Mast measured | Beach cell forecast | Ratio |")
        print("|---|---|---|---|---|---|---|")
        for m in MODELS:
            have = [r for r in rs if (1, ("buoy", m)) in r["fc"] and (1, (m, "land")) in r["fc"]]
            if len(have) < 5:
                continue
            bm = statistics.mean(r["buoy"][h][0] for r in have for h in HOURS)
            bf = statistics.mean(r["fc"][(1, ("buoy", m))][h][0] for r in have for h in HOURS)
            mm = statistics.mean(r["obs"][h][0] for r in have for h in HOURS)
            mf = statistics.mean(r["fc"][(1, (m, "land"))][h][0] for r in have for h in HOURS)
            print(f"| {SHORT[m]} | {bm:.1f} | {bf:.1f} | {bm / bf:.2f} | {mm:.1f} | {mf:.1f} | {mm / mf:.2f} |")
        print()

    # 5. Is DK the odd one? Same easterly days at Tarragona and Cunit
    print("## 5. Other coastal masts on the Torredembarra easterly days, day ahead, MF seamless beach cell\n")
    print("| Mast | km from Torredembarra | Anemometer m | Days | Measured mean | Forecast mean | Ratio |")
    print("|---|---|---|---|---|---|---|")
    east = [r for r in rows if r["sector"] == SECTORS[0]]
    tor = spots["es-torredembarra"]
    for sid, (st, h, o) in [(MAST, (dk, dk_h, dk_obs))] + list(others.items()):
        key = "es-torredembarra" if sid == MAST else sid
        ms, fs, n = [], [], 0
        for r in east:
            ser = day_series(fc[(key, "meteofrance_seamless", "land")][1], r["day"])
            ob = [o.get(f"{r['day']}T{hh:02d}") for hh in HOURS]
            if not ser or not all(ob):
                continue
            n += 1
            ms += [x[0] for x in ob]
            fs += [ser[hh][0] for hh in HOURS]
        if n:
            print(f"| {st['name']} | {km(st['lat'], st['lon'], tor['latitude'], tor['longitude']):.1f} | {h} | {n} | "
                  f"{statistics.mean(ms):.1f} | {statistics.mean(fs):.1f} | {statistics.mean(ms) / statistics.mean(fs):.2f} |")
    print()

    # 6. Easterly go days, one by one
    print("## 6. Measured easterly go days at Torredembarra, best 2 h (kn), day ahead\n")
    cols = [("meteofrance_seamless", "land"), ("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"),
            ("ecmwf_ifs", "land"), ("ecmwf_ifs", "sea"), ("gfs_seamless", "sea"), ("best_match", "sea"), "app"]
    print("| Day | Mast dir | Mast | Buoy | " + " | ".join(label(c) for c in cols) + " |")
    print("|---|---|---|---|" + "---|" * len(cols))
    for r in rows:
        if r["sector"] != SECTORS[0] or not r["go"]:
            continue
        b = f1(best2(r["buoy"], {"seaFacingDeg": spot["seaFacingDeg"]})) if r["buoy"] else "–"
        cells = []
        for c in cols:
            ser = r["fc"].get((1, c))
            cells.append(f1(best2(ser, spot)) + (" go" if ser and ride(ser, spot) else "") if ser else "–")
        print(f"| {r['day']} | {vdir(r['obs'].values()):.0f}° | {r['ob2']:.1f} | {b} | " + " | ".join(cells) + " |")
    print()

    # 7. Same question for Altafulla and Creixell beach cells (no mast there: compare with DK)
    print("## 7. Altafulla and Creixell on the same easterly days (DK mast as truth, day ahead)\n")
    print("| Spot | Source | Days | Best 2 h error kn [95 %] | Go caught |")
    print("|---|---|---|---|---|")
    for sid in SPOTS:
        sp = spots[sid]
        for s in [("meteofrance_seamless", "land"), ("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"),
                  ("ecmwf_ifs", "sea"), ("gfs_seamless", "sea"), "app"]:
            errs, caught, gos = {}, 0, 0
            for r in east:
                if s == "app":
                    ser = mix([day_series(fc[(sid, *x)][1], r["day"]) for x in APP])
                else:
                    ser = day_series(fc[(sid, *s)][1], r["day"])
                if not ser:
                    continue
                errs[r["day"]] = best2(ser, sp) - r["ob2"]
                gos += r["go"]
                caught += r["go"] and ride(ser, sp)
            iv = boot(errs)
            if iv:
                print(f"| {sp['name']} | {label(s)} | {len(errs)} | {f1(statistics.mean(errs.values()), True)} "
                      f"[{f1(iv[0], True)}, {f1(iv[1], True)}] | {caught}/{gos} |")
    print()

    # 8. All directions together: does the sea cell's easterly gain survive the garbí over-read?
    print("## 8. All day types together at Torredembarra (go = 2 h 12–28 kn, CSI = hits ÷ (hits + misses + false go))\n")
    print("| Lead | Source | Days | Measured go | Caught | False go | CSI [95 %] | Best 2 h error kn |")
    print("|---|---|---|---|---|---|---|---|")
    for lead in (0, 1):
        for s in [("meteofrance_seamless", "land"), ("meteofrance_arome_france_hd", "land"), ("icon_seamless", "land"),
                  ("ecmwf_ifs", "sea"), ("gfs_seamless", "sea"), ("best_match", "sea"), "app"]:
            have = [r for r in rows if (lead, s) in r["fc"]]
            if len(have) < 20:
                continue
            per = {r["day"]: (r["go"], ride(r["fc"][(lead, s)], spot)) for r in have}
            def csi(keys):
                h = sum(1 for k in keys if per[k] == (True, True))
                bad = sum(1 for k in keys if per[k][0] != per[k][1])
                return h / (h + bad) if h + bad else 0
            rnd = random.Random(79)
            ks = list(per)
            bs = sorted(csi([rnd.choice(ks) for _ in ks]) for _ in range(1000))
            hit = sum(1 for v in per.values() if v == (True, True))
            fal = sum(1 for v in per.values() if v == (False, True))
            err = statistics.mean(best2(r["fc"][(lead, s)], spot) - r["ob2"] for r in have)
            print(f"| {lead} | {label(s)} | {len(have)} | {sum(v[0] for v in per.values())} | {hit} | {fal} | "
                  f"{csi(ks):.2f} [{bs[25]:.2f}, {bs[975]:.2f}] | {err:+.1f} |")
    print()

    # 9. Today's app on the measured easterly go days, same day (the only lead with a full year of MF)
    print("## 9. Today's app on measured easterly go days, same-day run (kn, best 2 h)\n")
    print("| Day | Mast | App | AROME HD beach | ECMWF 9 km sea | GFS sea |")
    print("|---|---|---|---|---|---|")
    for r in rows:
        if r["sector"] != SECTORS[0] or not r["go"]:
            continue
        def g(src):
            ser = r["fc"].get((0, src))
            return (f1(best2(ser, spot)) + (" go" if ride(ser, spot) else "")) if ser else "–"
        print(f"| {r['day']} | {r['ob2']:.1f} | {g('app')} | {g(('meteofrance_arome_france_hd', 'land'))} | "
              f"{g(('ecmwf_ifs', 'sea'))} | {g(('gfs_seamless', 'sea'))} |")
    print()
    json.dump({r["day"]: {"sector": r["sector"], "go": r["go"], "ob2": r["ob2"]} for r in rows},
              open(os.path.join(os.path.dirname(__file__), ".cache", "whe79_days.json"), "w"))


if __name__ == "__main__":
    main()
