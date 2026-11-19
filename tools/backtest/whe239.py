"""One model set for the forecast and the 'will there be wind' check (WHE-239).

The wind the app shows is the mean of Météo-France seamless (beach cell, days 0-3), ECMWF 9 km and
GFS (sea cells), picked in WHE-87. The chance check (KiteChance, Confidence.swift) still compares
best match, MF seamless, ICON (beach cells) and ECMWF 25 km (sea cell), tuned in WHE-81/84.
Question: re-tuned on the forecast's own models, is the check as good?

Setups (each model's best 2 h, 07-17 UTC, usable direction; chance = Phi((mean - 12 + b) /
sqrt(spread^2 + s^2)), the shipped formula):
  old-shipped  the 4 old models with the shipped tuning (what riders see today)
  old          the 4 old models, re-tuned here (fair comparison: same days, same method)
  new          MF land (days 0-3 only, as the app) + ECMWF 9 km sea + GFS sea, re-tuned
  new-nosd     the same, spread ignored (only s): is two models' spread worth anything at day 4+?
  new-sd2      the same, spread as the sample sd (n-1): two models' population sd halves the gap
Re-tuning per day ahead, WHE-84 method: fit b and s (Brier), Go cut = lowest chance at which
spot-days at or above it came true >= 85 % (>= 30 spot-days). Odd ISO weeks are scored with numbers
fitted on even weeks and back, so every score is on unseen weeks. Uncertain from 0.40 (unchanged).

Truth: WHE-84 'trusted' set: France + southern Spain masts (pairs_esfr a/a2, brought to 10 m) and
the POEM near-shore buoy. Abroad check (not used for tuning): KNMI coastal stations (Netherlands),
airport METARs in Greece and Morocco, each paired with the nearest catalogue spot.

    python3 tools/backtest/whe239.py --fetch            # fill the cache
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe239.py > tools/backtest/results/whe239.md
"""
import argparse
import datetime as dt
import json
import math
import os
import random
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
from chance import ride, best2, HOURS, MF  # noqa: E402
from esfr_backtest import ICON, EC, BM, vmean  # noqa: E402
from model_backtest import fetch as http  # noqa: E402
from review import to_10m  # noqa: E402
from stations import observations, load_spots, km, metar_obs  # noqa: E402
from whe71 import trusted  # noqa: E402
from whe87 import fetch as prev_runs  # noqa: E402

HERE = os.path.dirname(__file__)
START, END = "2026-08-08", "2026-11-16"
LEADS = [0, 1, 2, 3, 4, 5]
THR = 12
EC9, GFS = "ecmwf_ifs", "gfs_seamless"
OLD = [(BM, "land"), (MF, "land"), (ICON, "land"), (EC, "sea")]
NEW = [(MF, "land"), (EC9, "sea"), (GFS, "sea")]
MF_LAST = 3   # OpenMeteoProvider.lastDayByModel
CELLS = sorted(set(OLD + NEW + [(BM, "sea")]))
SHIPPED = {0: (-0.25, 2.0, 0.68), 1: (-0.25, 2.25, 0.73), 2: (0, 2.5, 0.70), 3: (0, 2.75, 0.79),
           4: (-1, 4.5, 0.71), 5: (-1, 5, 0.80)}
UNCERTAIN = 0.40
GO_TARGET = float(os.environ.get("GO_TARGET", "0.85"))
CUTS = [x / 100 for x in range(30, 100)]
B_GRID = [x * 0.25 for x in range(-16, 17)]
S_GRID = [x * 0.25 for x in range(2, 29)]
SETUPS = ["old-shipped", "old", "new", "new-nosd", "new-sd2"]

# Abroad: (spot id, station source, station id, name). KNMI masts are 10 m; METARs 10 m.
ABROAD = [
    ("nl-hoek-van-holland", "knmi", "330", "KNMI Hoek van Holland"),
    ("nl-ijmuiden", "knmi", "225", "KNMI IJmuiden"),
    ("nl-breskens-oost", "knmi", "310", "KNMI Vlissingen"),
    ("nl-den-helder-huisduinen", "knmi", "235", "KNMI De Kooy"),
    ("nl-lauwersoog", "knmi", "277", "KNMI Lauwersoog"),
    ("nl-terschelling-noordzee", "knmi", "251", "KNMI Hoorn Terschelling"),
    ("nl-stavoren", "knmi", "267", "KNMI Stavoren (lake)"),
    ("nl-lelystad-trintelhaven", "knmi", "258", "KNMI Houtribdijk (lake)"),
    ("gr-pounta", "metar", "LGPA", "Paros airport"),
    ("gr-afiartis-makry-gialos", "metar", "LGKP", "Karpathos airport"),
    ("gr-theologos", "metar", "LGRP", "Rhodes airport"),
    ("gr-mikri-vigla", "metar", "LGNX", "Naxos airport"),
    ("ma-dakhla-oum-labouir-westpoint", "metar", "GMMH", "Dakhla airport"),
    ("ma-essaouira", "metar", "GMMI", "Essaouira airport"),
]
KNMI_POS = {}


# MARK: Data

def knmi_obs(stn, start, end):
    """KNMI hourly: FF = 10 min mean before the hour (0.1 m/s), DD direction. 'YYYY-MM-DDTHH' UTC."""
    body = f"start={start.replace('-', '')}01&end={end.replace('-', '')}24&vars=DD:FF&stns={stn}"
    text = http("https://www.daggegevens.knmi.nl/klimatologie/uurgegevens", body).decode("latin-1")
    out = {}
    for line in text.splitlines():
        if line.startswith("#"):
            p = line[1:].split()
            if len(p) >= 4 and p[0] == stn:
                KNMI_POS[stn] = (float(p[2]), float(p[1]))
            continue
        p = [x.strip() for x in line.split(",")]
        if len(p) != 5 or p[0] != stn or not p[4]:
            continue
        t = dt.datetime.strptime(p[1], "%Y%m%d") + dt.timedelta(hours=int(p[2]))
        d = int(p[3]) if p[3] else None
        out[t.strftime("%Y-%m-%dT%H")] = (int(p[4]) / 10 * 1.943844, None if d in (None, 0, 990) else d)
    return out


def forecasts(spot):
    return {key: prev_runs(spot["latitude"], spot["longitude"], key[0], key[1], START, END) for key in CELLS}


def es_fr_sites():
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json")))
             if p["cls"] in ("a", "a2") and trusted(p)]
    out = []
    for p in pairs:
        spot = spots.get(p["spot"])
        if not spot:
            continue
        obs, height = observations(p["station"], START, END)
        if not obs:
            print(f"no obs {p['station']['id']}", file=sys.stderr)
            continue
        obs = {h: (to_10m(kn, height), d) for h, (kn, d) in obs.items()}
        out.append({"pair": f"{p['spot']}|{p['station']['id']}", "spot": spot, "obs": obs, "fc": forecasts(spot),
                    "kind": "mast", "station": p["station"]["name"], "km": p.get("km")})
    from buoys import BUOYS, read_buoy, to_10m_sea
    b = BUOYS["POEM"]
    obs, _ = read_buoy(b["prefix"], START, END)
    obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
    for sid in b["spots"]:
        if sid in spots:
            out.append({"pair": f"{sid}|POEM", "spot": spots[sid], "obs": obs, "fc": forecasts(spots[sid]),
                        "kind": "buoy", "station": "POEM buoy", "km": None})
    return out


def abroad_sites():
    spots = {s["id"]: s for s in load_spots()}
    out = []
    for sid, src, stn, name in ABROAD:
        spot = spots.get(sid)
        if not spot:
            print(f"abroad spot {sid} missing", file=sys.stderr)
            continue
        obs = knmi_obs(stn, START, END) if src == "knmi" else metar_obs(stn, START, END)[0]
        if not obs:
            print(f"no obs {stn}", file=sys.stderr)
            continue
        pos = KNMI_POS.get(stn)
        out.append({"pair": f"{sid}|{stn}", "spot": spot, "obs": obs, "fc": forecasts(spot), "kind": src,
                    "station": name, "km": km(spot["latitude"], spot["longitude"], *pos) if pos else None,
                    "country": sid[:2].upper()})
    return out


def models_at(setup, lead):
    if setup.startswith("new"):
        return [k for k in NEW if not (k[0] == MF and lead > MF_LAST)]
    return OLD


def collect(sites):
    rows = []
    d0, d1 = dt.date.fromisoformat(START), dt.date.fromisoformat(END)
    for s in sites:
        spot, obs, fc = s["spot"], s["obs"], s["fc"]
        day = d0
        while day <= d1:
            ds = day.isoformat()
            day += dt.timedelta(days=1)
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            if len(o) < 9:
                continue
            for lead in LEADS:
                series = {}
                for key in CELLS:
                    ser = {h: fc[key][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                    if all(ser.values()):
                        series[key] = ser
                b2 = {k: best2(v, spot) for k, v in series.items()}
                r = {"pair": s["pair"], "kind": s["kind"], "day": ds, "lead": lead, "obs": ride(o, spot),
                     "obs_b2": best2(o, spot) if len(o) == len(HOURS) else None, "b2": b2, "series": series,
                     "spot": spot}
                if all(k in b2 for k in OLD) and all(k in b2 for k in models_at("new", lead)):
                    rows.append(r)
    return rows


# MARK: Chance

def phi(z):
    return 0.5 * math.erfc(-z / math.sqrt(2))


def xs_of(r, setup):
    return [r["b2"][k] for k in models_at(setup, r["lead"])]


def prob(r, setup, b, s):
    xs = xs_of(r, setup)
    mean = statistics.mean(xs)
    if setup == "new-nosd":
        sd = 0
    elif setup == "new-sd2":
        sd = statistics.stdev(xs)
    else:
        sd = statistics.pstdev(xs)
    return phi((mean - THR + b) / math.sqrt(sd ** 2 + s ** 2))


def fit(rows, setup):
    best = None
    for b in B_GRID:
        for s in S_GRID:
            bs = statistics.mean((prob(r, setup, b, s) - r["obs"]) ** 2 for r in rows)
            if best is None or bs < best[0]:
                best = (bs, b, s)
    return best[1], best[2]


def go_cut(ps):
    """ps: [(p, obs)]. Lowest cut at which p >= cut came true >= GO_TARGET, with >= 30 spot-days."""
    for c in CUTS:
        sel = [o for p, o in ps if p >= c]
        if len(sel) >= 30 and sum(sel) / len(sel) >= GO_TARGET:
            return c
    return None


def week_parity(day):
    return dt.date.fromisoformat(day).isocalendar()[1] % 2


def tune(rows, setup):
    b, s = fit(rows[::2] if len(rows) > 3000 else rows, setup)
    return b, s, go_cut([(prob(r, setup, b, s), r["obs"]) for r in rows])


def outlook(p, go):
    return "likely" if go is not None and p >= go else "uncertain" if p >= UNCERTAIN else "unlikely"


def score_cv(rows):
    """Attach r['p'][setup], r['out'][setup] scored on unseen weeks. Returns fitted per (setup, lead, parity)."""
    fitted = {}
    for lead in LEADS:
        rl = [r for r in rows if r["lead"] == lead]
        for r in rl:
            b, s, go = SHIPPED[lead]
            p = prob(r, "old", b, s)
            r.setdefault("p", {})["old-shipped"] = p
            r.setdefault("out", {})["old-shipped"] = outlook(p, go)
        for setup in SETUPS[1:]:
            for par in (0, 1):
                tr = [r for r in rl if week_parity(r["day"]) != par]
                b, s, go = tune(tr, setup)
                fitted[(setup, lead, par)] = (b, s, go)
                for r in rl:
                    if week_parity(r["day"]) == par:
                        p = prob(r, setup, b, s)
                        r["p"][setup], r["out"][setup] = p, outlook(p, go)
    return fitted


def stats(rows, setup):
    go = [r for r in rows if r["out"][setup] == "likely"]
    unc = [r for r in rows if r["out"][setup] == "uncertain"]
    ev = sum(r["obs"] for r in rows)
    hits = sum(r["obs"] for r in go)
    clim = ev / len(rows) if rows else 0
    br = statistics.mean((r["p"][setup] - r["obs"]) ** 2 for r in rows) if rows else None
    ref = statistics.mean((clim - r["obs"]) ** 2 for r in rows) if rows else None
    return {"n": len(rows), "ev": ev, "go": len(go), "hit": hits / len(go) if go else None,
            "caught": hits / ev if ev else None,
            "csi": hits / (ev + len(go) - hits) if ev + len(go) - hits else None,
            "unc": len(unc), "unc_hit": sum(r["obs"] for r in unc) / len(unc) if unc else None,
            "lost": sum(r["obs"] for r in rows if r["out"][setup] == "unlikely") / ev if ev else None,
            "brier": br, "bss": 1 - br / ref if ref else None}


def by_date(rows):
    by = {}
    for r in rows:
        by.setdefault(r["day"], []).append(r)
    return by


def boot(rows, fn, reps=400, seed=239):
    """95 % interval over whole dates of fn(rows)."""
    by = by_date(rows)
    dates = sorted(by)
    rng = random.Random(seed)
    out = []
    for _ in range(reps):
        x = fn([r for d in (rng.choice(dates) for _ in dates) for r in by[d]])
        if x is not None:
            out.append(x)
    out.sort()
    if not out:
        return None
    return out[int(0.025 * len(out))], out[int(0.975 * len(out)) - 1]


def pc(x):
    return "–" if x is None else f"{x * 100:.0f} %"


def f1(x):
    return "–" if x is None else f"{x:.1f}"


def f2(x):
    return "–" if x is None else f"{x:.2f}"


def sg(x):
    return "–" if x is None else f"{x:+.2f}"


def ivp(iv):
    return "" if not iv else f" ({iv[0] * 100:.0f}–{iv[1] * 100:.0f})"


# MARK: Report

def table(rows, setups, title, leads=LEADS):
    print(f"\n### {title}\n")
    print("| Day ahead | Setup | Spot-days (kite days) | Go shown | Go came true (95 %) | Kite days caught by Go | CSI | "
          "Uncertain came true | Kite days left in 'unlikely' | Brier skill |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    for lead in leads:
        rl = [r for r in rows if r["lead"] == lead]
        if not rl:
            continue
        for st in setups:
            s = stats(rl, st)
            iv = boot(rl, lambda x: stats(x, st)["hit"], reps=200) if s["go"] else None
            print(f"| {lead} | {st} | {s['n']} ({s['ev']}) | {s['go']} | {pc(s['hit'])}{ivp(iv)} | {pc(s['caught'])} | "
                  f"{f2(s['csi'])} | {pc(s['unc_hit'])} | {pc(s['lost'])} | {sg(s['bss'])} |")


def diffs(rows, a, b, leads, title):
    print(f"\n### {title}: {a} minus {b}, 95 % interval over days\n")
    print("| Day ahead | Go came true | Kite days caught by Go | Kite days left in 'unlikely' | Brier skill |")
    print("|---|---|---|---|---|")
    for lead in leads:
        rl = [r for r in rows if r["lead"] == lead]
        cells = []
        for key in ("hit", "caught", "lost", "bss"):
            x, y = stats(rl, a)[key], stats(rl, b)[key]
            if x is None or y is None:
                cells.append("–")
                continue
            iv = boot(rl, lambda s: (lambda p, q: None if p is None or q is None else p - q)(
                stats(s, a)[key], stats(s, b)[key]))
            sc = 100
            cells.append(f"{(x - y) * sc:+.0f} pts ({iv[0] * sc:+.0f}…{iv[1] * sc:+.0f})" if key != "bss"
                         else f"{x - y:+.3f} ({iv[0]:+.3f}…{iv[1]:+.3f})")
        print(f"| {lead} | " + " | ".join(cells) + " |")


def fitted_table(fitted):
    print("\n### Fitted numbers per day ahead (each half of the weeks)\n")
    print("| Setup | Day ahead | bias b (kn) even / odd | error s (kn) even / odd | Go cut even / odd |")
    print("|---|---|---|---|---|")
    for st in SETUPS[1:]:
        for lead in LEADS:
            a, c = fitted[(st, lead, 1)], fitted[(st, lead, 0)]   # tuned on even weeks scores odd (par 1)
            print(f"| {st} | {lead} | {a[0]:+.2f} / {c[0]:+.2f} | {a[1]:.2f} / {c[1]:.2f} | {pc(a[2])} / {pc(c[2])} |")


def spread_skill(rows):
    print("\n### Does the models' spread say anything? (error of the models' mean vs measured best 2 h)\n")
    print("Spot-days split in thirds by spread. If the spread means something, the error grows with it.\n")
    print("| Day ahead | Setup | Models | Spread thirds (kn) | Mean abs error, low / mid / high spread (kn) | "
          "Corr(spread, abs error) |")
    print("|---|---|---|---|---|---|")
    for lead in LEADS:
        rl = [r for r in rows if r["lead"] == lead and r["obs_b2"] is not None]
        for st in ("old", "new"):
            pts = []
            for r in rl:
                xs = xs_of(r, st)
                pts.append((statistics.pstdev(xs), abs(statistics.mean(xs) - r["obs_b2"])))
            pts.sort()
            n = len(pts)
            thirds = [pts[: n // 3], pts[n // 3: 2 * n // 3], pts[2 * n // 3:]]
            err = " / ".join(f"{statistics.mean(e for _, e in t):.1f}" for t in thirds)
            edges = f"< {pts[n // 3][0]:.1f}, < {pts[2 * n // 3][0]:.1f}"
            c = statistics.correlation([p for p, _ in pts], [e for _, e in pts])
            print(f"| {lead} | {st} | {len(models_at(st, lead))} | {edges} | {err} | {c:+.2f} |")


def final_tuning(rows):
    print("\n### Numbers for the app (fitted on all weeks, setup 'new')\n")
    print("| Day ahead | Models | bias b (kn) | error s (kn) | Go cut | Go came true on these weeks | Kite days caught |")
    print("|---|---|---|---|---|---|---|")
    out = {}
    for lead in LEADS:
        rl = [r for r in rows if r["lead"] == lead]
        b, s, go = tune(rl, "new")
        out[lead] = (b, s, go)
        ps = [(prob(r, "new", b, s), r["obs"]) for r in rl]
        sel = [o for p, o in ps if go is not None and p >= go]
        ev = sum(o for _, o in ps)
        print(f"| {lead} | {len(models_at('new', lead))} | {b:+.2f} | {s:.2f} | {pc(go)} | "
              f"{pc(sum(sel) / len(sel) if sel else None)} | {pc(sum(sel) / ev if ev else None)} |")
    return out


def level(rows):
    print("\n### Level: each model's best 2 h minus measured, days 0–3 (kn)\n")
    print("| Model, cell | Bias | Mean abs error |")
    print("|---|---|---|")
    rl = [r for r in rows if r["lead"] <= 3 and r["obs_b2"] is not None]
    for k in CELLS:
        d = [r["b2"][k] - r["obs_b2"] for r in rl if k in r["b2"]]
        if d:
            print(f"| {k[0]}, {k[1]} | {statistics.mean(d):+.1f} | {statistics.mean(abs(x) for x in d):.1f} |")
    for st in ("old", "new"):
        d = [statistics.mean(xs_of(r, st)) - r["obs_b2"] for r in rl]
        print(f"| mean of {st} | {statistics.mean(d):+.1f} | {statistics.mean(abs(x) for x in d):.1f} |")


# MARK: Abroad (the forecast mix itself)

def blend_series(r, keys):
    have = [k for k in keys if k in r["series"]]
    if not have:
        return None
    return {h: vmean([r["series"][k][h] for k in have]) for h in HOURS}


def abroad_sources(lead):
    mix = [k for k in NEW if not (k[0] == MF and lead > MF_LAST)]
    return {"forecast mix (MF + ECMWF + GFS)": mix, "best match, sea cell (before WHE-87)": [(BM, "sea")],
            "best match, beach cell": [(BM, "land")], "MF seamless, beach": [(MF, "land")],
            "ECMWF 9 km, sea": [(EC9, "sea")], "GFS, sea": [(GFS, "sea")], "ICON, beach": [(ICON, "land")]}


def abroad_rows(sites):
    rows = []
    d0, d1 = dt.date.fromisoformat(START), dt.date.fromisoformat(END)
    for s in sites:
        spot, obs, fc = s["spot"], s["obs"], s["fc"]
        day = d0
        while day <= d1:
            ds = day.isoformat()
            day += dt.timedelta(days=1)
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            if len(o) < len(HOURS):
                continue
            for lead in LEADS:
                series = {}
                for key in CELLS:
                    ser = {h: fc[key][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                    if all(ser.values()):
                        series[key] = ser
                r = {"pair": s["pair"], "country": s["country"], "day": ds, "lead": lead, "obs": ride(o, spot),
                     "obs_b2": best2(o, spot), "series": series, "spot": spot, "b2": {k: best2(v, spot) for k, v in series.items()}}
                r["src"] = {}
                for name, keys in abroad_sources(lead).items():
                    bs = blend_series(r, keys)
                    if bs and all(k in series for k in keys if k[0] != MF):
                        r["src"][name] = (best2(bs, spot), ride(bs, spot))
                rows.append(r)
    return rows


def abroad_report(sites, rows, app_tuning):
    print("\n## Abroad: the forecast mix against stations outside Spain and France\n")
    print("| Station | Spot | km | Country | Days with full 07–17 UTC readings |")
    print("|---|---|---|---|---|")
    for s in sites:
        n = len({r["day"] for r in rows if r["pair"] == s["pair"]})
        print(f"| {s['station']} | {s['spot']['id']} | {f1(s['km'])} | "
              f"{s['country']} | {n} |")
    for country in ("NL", "GR", "MA"):
        cr = [r for r in rows if r["country"] == country]
        if not cr:
            continue
        print(f"\n### {country}: best 2 h per day, days 1–3 pooled (and day 1 alone)\n")
        print("| Source | Bias (kn) | Mean abs error (kn) | Go days caught | False gos | CSI | CSI day 1 | Spot-days |")
        print("|---|---|---|---|---|---|---|---|")
        for name in abroad_sources(1):
            def sc(rr):
                rr = [r for r in rr if name in r["src"]]
                if not rr:
                    return None
                d = [r["src"][name][0] - r["obs_b2"] for r in rr]
                hits = sum(r["obs"] and r["src"][name][1] for r in rr)
                fgo = sum(r["src"][name][1] for r in rr)
                ev = sum(r["obs"] for r in rr)
                return {"bias": statistics.mean(d), "mae": statistics.mean(abs(x) for x in d), "n": len(rr),
                        "pod": hits / ev if ev else None, "far": (fgo - hits) / fgo if fgo else None,
                        "csi": hits / (ev + fgo - hits) if ev + fgo - hits else None}
            a = sc([r for r in cr if 1 <= r["lead"] <= 3])
            d1 = sc([r for r in cr if r["lead"] == 1])
            if not a:
                continue
            print(f"| {name} | {a['bias']:+.1f} | {a['mae']:.1f} | {pc(a['pod'])} | {pc(a['far'])} | {f2(a['csi'])} | "
                  f"{f2(d1['csi'] if d1 else None)} | {a['n']} |")
    # The chance check abroad, tuned in Spain/France only
    print("\n### The wind check abroad, with the numbers tuned in Spain and France\n")
    print("| Country | Day ahead | Setup | Spot-days (kite days) | Go shown | Go came true | Kite days caught | "
          "Kite days left in 'unlikely' |")
    print("|---|---|---|---|---|---|---|---|")
    for country in ("NL", "GR", "MA"):
        for lead in (0, 1, 2, 3):
            rl = [r for r in rows if r["country"] == country and r["lead"] == lead
                  and all(k in r["b2"] for k in OLD) and all(k in r["b2"] for k in models_at("new", lead))]
            if not rl:
                continue
            for st, (b, s, go) in (("old-shipped", SHIPPED[lead]), ("new", app_tuning[lead])):
                for r in rl:
                    p = prob(r, "old" if st == "old-shipped" else "new", b, s)
                    r.setdefault("p", {})[st], r.setdefault("out", {})[st] = p, outlook(p, go)
                x = stats(rl, st)
                print(f"| {country} | {lead} | {st} | {x['n']} ({x['ev']}) | {x['go']} | {pc(x['hit'])} | "
                      f"{pc(x['caught'])} | {pc(x['lost'])} |")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fetch", action="store_true", help="fill the cache only")
    ap.add_argument("--no-abroad", action="store_true")
    a = ap.parse_args()
    es = es_fr_sites()
    ab = [] if a.no_abroad else abroad_sites()
    if a.fetch:
        print(f"cached: {len(es)} ES/FR pairs, {len(ab)} abroad pairs", file=sys.stderr)
        return
    rows = collect(es)
    print("# WHE-239: the wind check on the forecast's own models\n")
    print(f"{len({r['pair'] for r in rows})} station-spot pairs (France + southern Spain masts, POEM buoy), "
          f"{len({r['day'] for r in rows})} days, {START} … {END}, Go target {GO_TARGET:.0%} on unseen weeks.")
    fitted = score_cv(rows)
    level(rows)
    table(rows, SETUPS[:3], "Old vs new, unseen weeks (odd scored with even-week numbers and back)")
    diffs(rows, "new", "old", LEADS, "Same days, both re-tuned")
    diffs(rows, "new", "old-shipped", LEADS, "Same days, new re-tuned vs what ships today")
    table(rows, ["new", "new-nosd", "new-sd2"], "Day 4 and 5: two models left, how to use their spread", leads=[3, 4, 5])
    spread_skill(rows)
    masts = [r for r in rows if r["kind"] == "mast"]
    table(masts, ["old", "new"], "Robustness: masts only (POEM buoy dropped)", leads=[0, 1, 2, 3])
    south = [r for r in rows if not r["pair"].startswith("fr-")]
    table(south, ["old-shipped", "old", "new"], "Robustness: southern Spain + POEM only", leads=[0, 1, 2, 3])
    fitted_table(fitted)
    app = final_tuning(rows)
    json.dump({str(k): v for k, v in app.items()}, open(os.path.join(HERE, ".cache", "whe239_tuning.json"), "w"))
    if ab:
        abroad_report(ab, abroad_rows(ab), app)


if __name__ == "__main__":
    main()
