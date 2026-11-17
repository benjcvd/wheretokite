"""When the app's models blow opposite ways, what should the blended hour say? (WHE-218)

The app blends Météo-France seamless (beach cell, to day 3), ECMWF 9 km (sea cell) and GFS (sea cell):
mean speed, direction of the mean wind vector. When the models disagree by more than 90°, that
direction is one no model forecasts (Berck, 22 Nov: ECMWF 15 kn ESE offshore + GFS 21 kn WNW =
"18 kn W onshore").

Per hour (07-17 UTC), leads 0-5 (Previous Runs), trusted masts + POEM buoy (WHE-87 truth, Catalan
Meteocat masts out), 8 Aug - 15 Nov 2026:
  spread = largest angle between two models that each forecast >= MIN_KN (direction of lighter
  wind is noise). Flag = spread > 90°.
Rules for a flagged hour, judged against the measured wind:
  today     : as the app does now
  worst     : if any model with >= MIN_KN is offshore for the spot, the hour is offshore (scores 0)
  vector    : speed = length of the mean wind vector (opposite winds cancel)
  drop      : the hour is never kiteable
Kiteable hour = 12-28 kn and not offshore (app: offshore from 120° off the sea-facing side).
Day 'go' = two kiteable hours in a row (WHE-81 rule).

    python3 tools/backtest/whe218.py --fetch
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe218.py > tools/backtest/results/whe218.md
"""
import argparse
import concurrent.futures as cf
import datetime as dt
import json
import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import angle  # noqa: E402
from review import to_10m  # noqa: E402
from stations import observations, load_spots  # noqa: E402
from thresholds84 import group_of  # noqa: E402
import whe87  # noqa: E402

HERE = os.path.dirname(__file__)
START, END = "2026-08-08", "2026-11-15"
HOURS = list(range(7, 18))
LEADS = [0, 1, 2, 3, 4, 5]
SOURCES = [("meteofrance_seamless", "land"), ("ecmwf_ifs", "sea"), ("gfs_seamless", "sea")]
MF_LAST_DAY = 3
OFFSHORE_FROM = 120.0
MIN_KN = 8.0
FLAG_DEG = 90.0
LO, HI = 12, 28
RULES = ["today", "worst", "vector", "drop"]
REPS = 1000


def offshore(d, spot):
    if d is None or spot.get("waterType") == "lagoon" or spot.get("sides"):
        return False
    return angle(d, spot["seaFacingDeg"]) >= OFFSHORE_FROM


def kiteable(kn, d, spot):
    return LO <= kn <= HI and not offshore(d, spot)


def site_list():
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json"))) if p["cls"] in ("a", "a2")]
    out = []
    for p in pairs:
        pid = f"{p['spot']}|{p['station']['id']}"
        if group_of(pid) == "Catalonia masts (not trusted)" or p["spot"] not in spots:
            continue
        obs, height = observations(p["station"], START, END)
        if obs:
            out.append((pid, spots[p["spot"]], {h: (to_10m(kn, height), d) for h, (kn, d) in obs.items()}, p))
    from buoys import BUOYS, read_buoy, to_10m_sea
    b = BUOYS["POEM"]
    obs, _ = read_buoy(b["prefix"], START, END)
    obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
    for sid in b["spots"]:
        if sid in spots:
            out.append((f"{sid}|POEM", spots[sid], obs, {"km": None}))
    return out


def blend_hour(members, rule, spot):
    """members: [(kn, dir)] of the models present. -> (kn, dir, offshore_forced)."""
    n = len(members)
    sp = sum(s for s, _ in members) / n
    u = sum(s * math.sin(math.radians(d)) for s, d in members) / n
    v = sum(s * math.cos(math.radians(d)) for s, d in members) / n
    dr = math.degrees(math.atan2(u, v)) % 360
    strong = [(s, d) for s, d in members if s >= MIN_KN]
    spread = max((angle(a[1], b[1]) for i, a in enumerate(strong) for b in strong[i + 1:]), default=0)
    flagged = spread > FLAG_DEG
    if not flagged or rule == "today":
        return sp, dr, False, flagged
    if rule == "worst":
        return sp, dr, any(offshore(d, spot) for _, d in strong), flagged
    if rule == "vector":
        return math.hypot(u, v), dr, False, flagged
    return 0.0, dr, True, flagged    # drop


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fetch", action="store_true")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--drop", default="", help="comma-separated pair ids to leave out")
    a = ap.parse_args()
    sites = [s for s in site_list() if s[0] not in set(a.drop.split(","))]
    print(f"{len(sites)} sites", file=sys.stderr)
    jobs = {(pid, src): (spot["latitude"], spot["longitude"], src[0], src[1], START, END)
            for pid, spot, _, _ in sites for src in SOURCES}
    fc = {}
    with cf.ThreadPoolExecutor(a.workers) as ex:
        futs = {ex.submit(whe87.fetch, *v): k for k, v in jobs.items()}
        for i, f in enumerate(cf.as_completed(futs)):
            fc[futs[f]] = f.result()
            if i % 20 == 0:
                print(f"  {i}/{len(jobs)}", file=sys.stderr)
    if a.fetch:
        print("refused:", sorted(whe87.REFUSED), file=sys.stderr)
        return

    # hour records and day records
    hrs, days = [], []
    for pid, spot, obs, meta in sites:
        d = dt.date.fromisoformat(START)
        while d <= dt.date.fromisoformat(END):
            ds = d.isoformat()
            d += dt.timedelta(days=1)
            for lead in LEADS:
                day = {r: [] for r in RULES}
                obs_k, ok = [], True
                for h in HOURS:
                    key = f"{ds}T{h:02d}"
                    o = obs.get(key)
                    mem = []
                    for src in SOURCES:
                        if src[0] == "meteofrance_seamless" and lead > MF_LAST_DAY:
                            continue
                        x = fc[(pid, src)][lead].get(key)
                        if x:
                            mem.append(x)
                    if len(mem) < 2 or o is None:
                        ok = False
                        continue
                    ok_h = kiteable(o[0], o[1], spot)
                    obs_k.append(ok_h)
                    rec = {"pair": pid, "day": ds, "lead": lead, "obs": o, "obs_k": ok_h,
                           "obs_off": o[0] >= MIN_KN and offshore(o[1], spot), "mem": mem}
                    for r in RULES:
                        sp, dr, forced, flagged = blend_hour(mem, r, spot)
                        k = (not forced) and kiteable(sp, dr, spot)
                        rec[r] = k
                        rec["flag"] = flagged
                        rec["blend_off"] = offshore(dr, spot)
                        rec["any_off"] = any(offshore(dd, spot) for s, dd in mem if s >= MIN_KN)
                        day[r].append(k)
                    hrs.append(rec)
                if ok and len(obs_k) == len(HOURS):
                    two = lambda xs: any(p and q for p, q in zip(xs, xs[1:]))
                    days.append({"pair": pid, "day": ds, "lead": lead, "obs": two(obs_k),
                                 **{r: two(day[r]) for r in RULES},
                                 "flagged": any(x["flag"] for x in hrs[-len(HOURS):])})

    report(sites, hrs, days)


def pct(a, b):
    return f"{100 * a / b:.1f} %" if b else "–"


def daystats(ds, r):
    hit = sum(1 for x in ds if x[r] and x["obs"])
    fa = sum(1 for x in ds if x[r] and not x["obs"])
    miss = sum(1 for x in ds if not x[r] and x["obs"])
    return hit, fa, miss


def csi(ds, r):
    h, f, m = daystats(ds, r)
    return h / (h + f + m) if h + f + m else 0


def boot_delta(ds, r, base="today", seed=7):
    by = {}
    for x in ds:
        by.setdefault(x["day"], []).append(x)
    keys = list(by)
    rnd = random.Random(seed)
    out = []
    for _ in range(REPS):
        s = [x for k in (rnd.choice(keys) for _ in keys) for x in by[k]]
        out.append(csi(s, r) - csi(s, base))
    out.sort()
    return out[int(0.025 * REPS)], out[int(0.975 * REPS)]


def report(sites, hrs, days):
    print(f"# WHE-218: models blowing opposite ways, {START} … {END}\n")
    print(f"{len(sites)} truth sites (trusted masts + POEM buoy), {len({h['day'] for h in hrs})} dates, "
          f"{len(hrs)} site-hours over leads 0-5. Flag = two models each ≥ {MIN_KN:.0f} kn more than "
          f"{FLAG_DEG:.0f}° apart. Offshore = ≥ {OFFSHORE_FROM:.0f}° off the sea-facing side.\n")

    print("## How often it happens\n")
    print("| Day ahead | Site-hours | Flagged | Flagged, blend says usable but a model says offshore |"
          " … and today's blend calls it kiteable |")
    print("|---|---|---|---|---|")
    for lead in LEADS:
        lr = [h for h in hrs if h["lead"] == lead]
        f = [h for h in lr if h["flag"]]
        danger = [h for h in f if not h["blend_off"] and h["any_off"]]
        kt = [h for h in danger if h["today"]]
        print(f"| {lead} | {len(lr)} | {len(f)} ({pct(len(f), len(lr))}) | {len(danger)} ({pct(len(danger), len(lr))})"
              f" | {len(kt)} ({pct(len(kt), len(lr))}) |")

    print("\n## What the water did in the hours today's blend calls kiteable but a model says offshore\n")
    print("| Day ahead | Hours | Measured kiteable | Measured offshore (≥ 8 kn) | Measured too light/strong, onshore |")
    print("|---|---|---|---|---|")
    allk = []
    for lead in LEADS:
        kt = [h for h in hrs if h["lead"] == lead and h["flag"] and not h["blend_off"] and h["any_off"] and h["today"]]
        allk += kt
        mk = sum(h["obs_k"] for h in kt)
        mo = sum(h["obs_off"] for h in kt)
        print(f"| {lead} | {len(kt)} | {mk} ({pct(mk, len(kt))}) | {mo} ({pct(mo, len(kt))}) | {len(kt) - mk - mo} |")
    mk, mo = sum(h["obs_k"] for h in allk), sum(h["obs_off"] for h in allk)
    print(f"| all | {len(allk)} | {mk} ({pct(mk, len(allk))}) | {mo} ({pct(mo, len(allk))}) | {len(allk) - mk - mo} |")

    print("\n## Kiteable hours, all hours (hits / false 'kiteable' / missed)\n")
    print("| Day ahead | Rule | Hits | False kiteable | of which measured offshore | Missed |")
    print("|---|---|---|---|---|---|")
    for lead in LEADS:
        lr = [h for h in hrs if h["lead"] == lead]
        for r in RULES:
            hit = sum(1 for h in lr if h[r] and h["obs_k"])
            fa = sum(1 for h in lr if h[r] and not h["obs_k"])
            fo = sum(1 for h in lr if h[r] and h["obs_off"])
            mi = sum(1 for h in lr if not h[r] and h["obs_k"])
            print(f"| {lead} | {r} | {hit} | {fa} | {fo} | {mi} |")

    print("\n## Go days (two kiteable hours in a row), CSI and change vs today with a 95 % date-bootstrap interval\n")
    print("| Day ahead | Spot-days | Days with a flagged hour | Rule | Hits | False go | Missed | CSI | Δ CSI |")
    print("|---|---|---|---|---|---|---|---|---|")
    for lead in LEADS:
        ld = [x for x in days if x["lead"] == lead]
        nf = sum(x["flagged"] for x in ld)
        for r in RULES:
            h, f, m = daystats(ld, r)
            dl = "" if r == "today" else "{:+.1f} [{:+.1f}, {:+.1f}]".format(
                100 * (csi(ld, r) - csi(ld, "today")), *(100 * v for v in boot_delta(ld, r)))
            print(f"| {lead} | {len(ld)} | {nf} | {r} | {h} | {f} | {m} | {100 * csi(ld, r):.1f} | {dl} |")

    print("\n## Flagged hours by site\n")
    print("| Site | Flagged hours | Today kiteable & model offshore | Measured offshore of those |")
    print("|---|---|---|---|")
    for pid in sorted({h["pair"] for h in hrs}):
        ph = [h for h in hrs if h["pair"] == pid]
        f = [h for h in ph if h["flag"]]
        kt = [h for h in f if not h["blend_off"] and h["any_off"] and h["today"]]
        if f:
            print(f"| {pid} | {len(f)} | {len(kt)} | {sum(h['obs_off'] for h in kt)} |")

    ex = sorted([h for h in allk], key=lambda h: (h["day"], h["pair"], h["lead"]))
    print("\n## Examples (today kiteable, a model offshore): first 25\n")
    print("| Day | Site | Lead | Models (kn/°) | Measured (kn/°) |")
    print("|---|---|---|---|---|")
    for h in ex[:25]:
        mem = ", ".join(f"{s:.0f}/{d:.0f}" for s, d in h["mem"])
        print(f"| {h['day']} | {h['pair']} | {h['lead']} | {mem} | {h['obs'][0]:.0f}/{h['obs'][1]:.0f} |")
    print("\n## Examples where the water was offshore (today kiteable, a model offshore, measured offshore)\n")
    print("| Day | Site | Lead | Sea faces ° | Models (kn/°) | Measured (kn/°) |")
    print("|---|---|---|---|---|---|")
    spots = {pid: spot for pid, spot, _, _ in sites}
    for h in [h for h in ex if h["obs_off"]]:
        mem = ", ".join(f"{s:.0f}/{d:.0f}" for s, d in h["mem"])
        print(f"| {h['day']} | {h['pair']} | {h['lead']} | {spots[h['pair']]['seaFacingDeg']:.0f} | {mem}"
              f" | {h['obs'][0]:.0f}/{h['obs'][1]:.0f} |")


if __name__ == "__main__":
    main()
