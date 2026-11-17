"""Does reading ECMWF (and best match) on the beach cell skew the chance to kite? (WHE-71)

The app's chance (KiteChance, WHE-81/84) compares 4 models' best 2 h: best match, Météo-France
seamless, ICON, ECMWF. Its numbers (bias, error, Go cut-off per day ahead, Scoring.chanceTuning)
were tuned with best match and ECMWF on their SEA cell, MF and ICON on the beach (land) cell.
The app (ConfidenceEstimator) asks all four on the beach cell. ECMWF's beach cell can sit 10-20 km
inland, so its wind is lighter and the 4 models look like they disagree.

Setups (same 4 models, only the cell changes):
  tuned   best match sea, MF land, ICON land, ECMWF sea   (what the numbers were tuned on)
  app     all four land                                   (what the app ships)
  ec-sea  best match land, MF land, ICON land, ECMWF sea  (smallest fix: ECMWF only)

Each setup goes through the shipped formula and tuning, unchanged:
  chance = Phi((mean best 2 h - 12 + bias) / sqrt(spread^2 + error^2)),
  likely (Go possible) >= goFrom, uncertain >= 0.40, else unlikely.
Truth: trusted masts (France, southern Spain; Catalan Meteocat masts and Canaries out, WHE-84) and
the POEM near-shore buoy; event = two consecutive hours 12-28 kn at a usable direction, 07-17 UTC.
Forecasts: Open-Meteo Previous Runs (day N = run N days before). Two periods: the tuning period
(8 Aug - 30 Oct) and the weeks after it (31 Oct - 15 Nov) that the tuning never saw.

    python3 tools/backtest/whe71.py > tools/backtest/results/whe71.md
"""
import datetime as dt
import json
import math
import os
import random
import statistics
import sys
import urllib.parse

sys.path.insert(0, os.path.dirname(__file__))
from esfr_backtest import om, ICON, EC, BM  # noqa: E402
from model_backtest import months  # noqa: E402
from review import to_10m  # noqa: E402
from stations import observations, load_spots, km  # noqa: E402
from chance import ride, best2, HOURS, MF  # noqa: E402

HERE = os.path.dirname(__file__)
START, SPLIT, END = "2026-08-08", "2026-10-31", "2026-11-15"
LEADS = [0, 1, 2, 3, 4, 5]
CELLS = [(BM, "sea"), (BM, "land"), (MF, "land"), (ICON, "land"), (EC, "sea"), (EC, "land")]
SETUPS = {
    "tuned": [(BM, "sea"), (MF, "land"), (ICON, "land"), (EC, "sea")],
    "app": [(BM, "land"), (MF, "land"), (ICON, "land"), (EC, "land")],
    "ec-sea": [(BM, "land"), (MF, "land"), (ICON, "land"), (EC, "sea")],
}
# Scoring.chanceTuning (bias kn, error kn, Go cut-off) and uncertainWindFrom, as shipped.
TUNING = {0: (-0.25, 2.0, 0.68), 1: (-0.25, 2.25, 0.73), 2: (0, 2.5, 0.70), 3: (0, 2.75, 0.79),
          4: (-1, 4.5, 0.71), 5: (-1, 5, 0.80)}
UNCERTAIN = 0.40
THR = 12
SOUTH = ("tarifa", "cadiz", "rota", "almeria", "mar-menor")


def trusted(pair):
    s = pair["spot"]
    return s.startswith("fr-") or any(k in s for k in SOUTH)


def fetch(spot, start, end):
    """(model, cell) -> (lead -> 'YYYY-MM-DDTHH' -> (kn, dir), (cell lat, lon))."""
    sufs = {0: ""} | {n: f"_previous_day{n}" for n in LEADS if n}
    vars_ = ",".join(f"{v}{s}" for s in sufs.values() for v in ("wind_speed_10m", "wind_direction_10m"))
    out = {}
    for m, cell in CELLS:
        series, where = {n: {} for n in LEADS}, None
        for lo, hi in months(start, end):
            j = om("https://previous-runs-api.open-meteo.com/v1/forecast", urllib.parse.urlencode({
                "latitude": f"{spot['latitude']:.5f}", "longitude": f"{spot['longitude']:.5f}", "hourly": vars_,
                "wind_speed_unit": "kn", "timezone": "GMT", "start_date": lo, "end_date": hi,
                "models": m, "cell_selection": cell}))
            if "latitude" in j:
                where = (j["latitude"], j["longitude"])
            h = j.get("hourly") or {}
            for n, suf in sufs.items():
                for t, a, b in zip(h.get("time", []), h.get(f"wind_speed_10m{suf}") or [],
                                   h.get(f"wind_direction_10m{suf}") or []):
                    if a is not None and b is not None:
                        series[n][t[:13]] = (a, b)
        out[(m, cell)] = (series, where)
    return out


def sites():
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json")))
             if p["cls"] in ("a", "a2") and trusted(p)]
    out = []
    for p in pairs:
        spot = spots[p["spot"]]
        obs, height = observations(p["station"], START, END)
        if not obs:
            print(f"no obs {p['station']['id']}", file=sys.stderr)
            continue
        obs = {h: (to_10m(kn, height), d) for h, (kn, d) in obs.items()}
        out.append((f"{p['spot']}|{p['station']['id']}", spot, obs, fetch(spot, START, END), "mast"))
    from buoys import BUOYS, read_buoy, to_10m_sea
    b = BUOYS["POEM"]
    obs, _ = read_buoy(b["prefix"], START, END)
    obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
    for sid in b["spots"]:
        spot = spots.get(sid)
        if not spot:   # spot renamed or archived since WHE-62
            print(f"POEM spot {sid} not in the catalogue", file=sys.stderr)
            continue
        out.append((f"{sid}|POEM", spot, obs, fetch(spot, START, END), "buoy"))
    return out


def chance(xs, lead):
    b, s, _ = TUNING[min(lead, 5)]
    mean, sd = statistics.mean(xs), statistics.pstdev(xs)
    return math.erfc(-((mean - THR + b) / math.sqrt(sd ** 2 + s ** 2)) / math.sqrt(2)) / 2, mean, sd


def outlook(p, lead):
    return "likely" if p >= TUNING[min(lead, 5)][2] else "uncertain" if p >= UNCERTAIN else "unlikely"


def collect(site_list):
    rows = []
    d0, d1 = dt.date.fromisoformat(START), dt.date.fromisoformat(END)
    for pid, spot, obs, fc, kind in site_list:
        day = d0
        while day <= d1:
            ds = day.isoformat()
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            day += dt.timedelta(days=1)
            if len(o) < 9:
                continue
            for lead in LEADS:
                b2 = {}
                for key in CELLS:
                    s = {h: fc[key][0][lead].get(f"{ds}T{h:02d}") for h in HOURS}
                    if all(s.values()):
                        b2[key] = best2(s, spot)
                r = {"pair": pid, "kind": kind, "day": ds, "lead": lead, "obs": ride(o, spot),
                     "late": ds >= SPLIT, "b2": {}, "p": {}, "out": {}, "sd": {}, "mean": {}}
                for name, keys in SETUPS.items():
                    if all(b2.get(k) is not None for k in keys):
                        p, mean, sd = chance([b2[k] for k in keys], lead)
                        r["p"][name], r["out"][name], r["sd"][name], r["mean"][name] = p, outlook(p, lead), sd, mean
                if len(r["p"]) == len(SETUPS):
                    r["b2"] = {f"{m}|{c}": v for (m, c), v in b2.items()}
                    rows.append(r)
    return rows


def stats(rows, name):
    go = [r for r in rows if r["out"][name] == "likely"]
    unc = [r for r in rows if r["out"][name] == "uncertain"]
    ev = sum(r["obs"] for r in rows)
    ps = [(r["p"][name], r["obs"]) for r in rows]
    return {"n": len(rows), "go": len(go), "hit": sum(r["obs"] for r in go) / len(go) if go else None,
            "caught": sum(r["obs"] for r in go) / ev if ev else None,
            "unc": len(unc), "unc_hit": sum(r["obs"] for r in unc) / len(unc) if unc else None,
            "missed_unlikely": sum(r["obs"] for r in rows if r["out"][name] == "unlikely") / ev if ev else None,
            "brier": statistics.mean((p - o) ** 2 for p, o in ps),
            "sd": statistics.mean(r["sd"][name] for r in rows),
            "bias": statistics.mean(r["mean"][name] for r in rows)}


def boot(rows, a, b, key, reps=1000, seed=71):
    """95 % interval over dates (whole days resampled) of stats(a)[key] - stats(b)[key]."""
    by = {}
    for r in rows:
        by.setdefault(r["day"], []).append(r)
    dates = sorted(by)
    rng = random.Random(seed)
    out = []
    for _ in range(reps):
        s = [r for d in (rng.choice(dates) for _ in dates) for r in by[d]]
        x, y = stats(s, a)[key], stats(s, b)[key]
        if x is not None and y is not None:
            out.append(x - y)
    out.sort()
    return out[int(0.025 * len(out))], out[int(0.975 * len(out)) - 1]


def pc(x):
    return "–" if x is None else f"{x * 100:.0f} %"


def table(rows, title):
    print(f"\n### {title}\n")
    print("| Day ahead | Setup | Spot-days | Go shown | Go came true | Kite days caught by Go | "
          "Uncertain came true | Kite days left in 'unlikely' | Brier | Models' spread (kn) | Models' mean best 2 h (kn) |")
    print("|---|---|---|---|---|---|---|---|---|---|---|")
    for lead in LEADS:
        rl = [r for r in rows if r["lead"] == lead]
        if not rl:
            continue
        for name in SETUPS:
            s = stats(rl, name)
            print(f"| {lead} | {name} | {s['n']} | {s['go']} | {pc(s['hit'])} | {pc(s['caught'])} | {pc(s['unc_hit'])} | "
                  f"{pc(s['missed_unlikely'])} | {s['brier']:.3f} | {s['sd']:.1f} | {s['bias']:.1f} |")


def diffs(rows, title, leads):
    print(f"\n### {title}: app minus tuned, 95 % interval over days\n")
    print("| Day ahead | Go came true | Kite days caught | Brier |")
    print("|---|---|---|---|")
    for lead in leads:
        rl = [r for r in rows if r["lead"] == lead]
        cells = []
        for key, scale, fmt in (("hit", 100, "{:+.0f} pts ({:+.0f}…{:+.0f})"), ("caught", 100, "{:+.0f} pts ({:+.0f}…{:+.0f})"),
                                ("brier", 1, "{:+.3f} ({:+.3f}…{:+.3f})")):
            x, y = stats(rl, "app")[key], stats(rl, "tuned")[key]
            lo, hi = boot(rl, "app", "tuned", key)
            cells.append(fmt.format((x - y) * scale, lo * scale, hi * scale))
        print(f"| {lead} | " + " | ".join(cells) + " |")


def flips(rows):
    print("\n### How often the shown outlook changes (app vs tuned), days 0–3\n")
    print("| Day ahead | Spot-days | Same | Go in tuned, not in app | Go in app, not in tuned | Other change |")
    print("|---|---|---|---|---|---|")
    for lead in range(4):
        rl = [r for r in rows if r["lead"] == lead]
        same = sum(r["out"]["app"] == r["out"]["tuned"] for r in rl)
        lost = [r for r in rl if r["out"]["tuned"] == "likely" and r["out"]["app"] != "likely"]
        won = [r for r in rl if r["out"]["app"] == "likely" and r["out"]["tuned"] != "likely"]
        lt = sum(r["obs"] for r in lost)
        wt = sum(r["obs"] for r in won)
        print(f"| {lead} | {len(rl)} | {pc(same / len(rl))} | {len(lost)} ({lt} had wind) | {len(won)} ({wt} had wind) | "
              f"{len(rl) - same - len(lost) - len(won)} |")


def cell_report(site_list):
    print("\n### Where each model's cell falls (km from the spot pin)\n")
    print("| Spot | ECMWF beach | ECMWF sea | best match beach | best match sea | MF beach | ICON beach |")
    print("|---|---|---|---|---|---|---|")
    seen, ec_land = set(), []
    for pid, spot, _, fc, _ in site_list:
        if spot["id"] in seen:
            continue
        seen.add(spot["id"])
        d = {}
        for key in CELLS:
            w = fc[key][1]
            d[key] = km(spot["latitude"], spot["longitude"], *w) if w else None
        ec_land.append(d[(EC, "land")])
        f = lambda k: "–" if d[k] is None else f"{d[k]:.0f}"
        print(f"| {spot['id']} | {f((EC, 'land'))} | {f((EC, 'sea'))} | {f((BM, 'land'))} | {f((BM, 'sea'))} | "
              f"{f((MF, 'land'))} | {f((ICON, 'land'))} |")
    xs = sorted(x for x in ec_land if x is not None)
    print(f"\nECMWF beach cell: median {statistics.median(xs):.0f} km from the pin, max {xs[-1]:.0f} km.")


def level(rows):
    """Each model-cell's mean best 2 h minus the measured best 2 h is not available per row; give the
    mean best 2 h per model-cell on days the event happened vs not, days 0-1."""
    print("\n### Each model's best 2 h (kn), days 0–1, on days with and without kiteable wind\n")
    print("| Model, cell | Mean, all | Mean, kite days | Mean, other days |")
    print("|---|---|---|---|")
    rl = [r for r in rows if r["lead"] <= 1]
    for m, c in CELLS:
        k = f"{m}|{c}"
        xs = [r["b2"][k] for r in rl if r["b2"].get(k) is not None]
        a = [r["b2"][k] for r in rl if r["b2"].get(k) is not None and r["obs"]]
        b = [r["b2"][k] for r in rl if r["b2"].get(k) is not None and not r["obs"]]
        print(f"| {m}, {c} | {statistics.mean(xs):.1f} | {statistics.mean(a):.1f} | {statistics.mean(b):.1f} |")


def main():
    site_list = sites()
    rows = collect(site_list)
    json.dump([{k: v for k, v in r.items()} for r in rows], open(os.path.join(HERE, ".cache", "whe71_rows.json"), "w"))
    early = [r for r in rows if not r["late"]]
    late = [r for r in rows if r["late"]]
    print("# WHE-71: beach cell vs sea cell for the chance to kite\n")
    print(f"{len({r['pair'] for r in rows})} station-spot pairs, {len({r['day'] for r in rows})} days, "
          f"{len(rows)} spot-day-leads. Truth: trusted masts + POEM buoy.")
    cell_report(site_list)
    level(rows)
    table(early, f"Tuning period {START} – 2026-10-30")
    table(late, f"After the tuning, {SPLIT} – {END} (never seen by the tuning)")
    table(rows, "Both periods together")
    diffs(rows, "Both periods", [0, 1, 2, 3])
    flips(rows)
    # Robustness: drop POEM (near-shore buoy, the one spot class where AROME-like beach cells did better)
    table([r for r in rows if r["kind"] == "mast"], "Masts only (POEM dropped), both periods")


if __name__ == "__main__":
    main()
