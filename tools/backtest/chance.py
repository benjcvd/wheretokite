"""Can we tell riders "x % chance you'll kite" and have it mean x %? (WHE-81)

Event, per spot and day (07-17 UTC): two consecutive hours each between 12 and 28 kn
(intermediate safety limit) with a usable direction (review.usable: not offshore). Same idea
as the app's "go" and as the WHE-72 go day, so "today's wrong gos" are comparable.
Truth: the WHE-72 shore masts (pairs_esfr.json, classes a/a2, wind brought to 10 m) plus the
POEM buoy on the water for the two spots next to it. Forecasts made the day before.

Methods (the chance for a spot-day):
  Today       best match on the sea cell, yes/no (100 % or 0 %)
  A1 votes    share of 4 models that say go: best match sea, AROME 1.3 beach, ICON beach,
              ECMWF sea (Open-Meteo Previous Runs, day before)
  A2 margin   from the same 4 models: how far their best 2 h sits above 12 kn and how much they
              disagree: p = Phi((mean - 12 + b) / sqrt(sd^2 + s^2)), b and s fitted on the other
              weeks (odd ISO weeks scored with weights fitted on even ones and back)
  B1 ENS raw  ECMWF ensemble, 50 members, 12 UTC run of the day before (ens_fetch.py), read
              at ECMWF's sea cell (the cell Open-Meteo picks): share of members that say go
  B2 ENS x c  the same with every member's speed multiplied by one factor c, fitted on the other
              weeks (same everywhere: no per-spot tuning)
  B3 ENS+AROME  the ensemble's spread around AROME 1.3's level: each member's best 2 h shifted
              by (AROME beach best 2 h - ensemble mean best 2 h), then share above 12 kn

    python3 tools/backtest/chance.py > tools/backtest/results/whe81.md
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
from esfr_backtest import forecasts, REGIONS, HD, ICON, EC, BM  # noqa: E402
from review import to_10m, usable  # noqa: E402
from stations import observations, load_spots  # noqa: E402

HERE = os.path.dirname(__file__)
ENS = os.path.join(HERE, ".cache", "ens")
HOURS = list(range(7, 18))
LO, HI = 12, 28
KN = 1.943844
DET = [(BM, "sea"), (HD, "land"), (ICON, "land"), (EC, "sea")]
METHODS = ["Today", "A1 votes", "A2 margin", "B1 ENS raw", "B2 ENS x c", "B3 ENS+AROME"]


def ride(series, spot, lo=LO):
    """series: hour -> (kn, dir). True when two consecutive hours are in range at a usable direction."""
    ok = [h in series and lo <= series[h][0] <= HI and usable(series[h][1], spot) for h in HOURS]
    return any(a and b for a, b in zip(ok, ok[1:]))


def best2(series, spot):
    """Best 2 h mean of the kiteable speed (0 when the direction is offshore). None if hours missing."""
    k = [series[h][0] if usable(series[h][1], spot) else 0 for h in HOURS if h in series]
    if len(k) < len(HOURS):
        return None
    return max((a + b) / 2 for a, b in zip(k, k[1:]))


def uv_to(u, v):
    return math.hypot(u, v) * KN, (math.degrees(math.atan2(-u, -v)) % 360)


def members(day_file, key):
    """member -> hour -> (kn, dir), linear in u, v between the 3-hourly steps."""
    pt = day_file["points"].get(key)
    if not pt:
        return {}
    out = {}
    for m, hrs in pt.items():
        s = {}
        for h in HOURS:
            a = (h // 3) * 3
            b = a + 3
            if str(a) not in hrs or str(b) not in hrs:
                break
            w = (h - a) / 3
            u = hrs[str(a)][0] * (1 - w) + hrs[str(b)][0] * w
            v = hrs[str(a)][1] * (1 - w) + hrs[str(b)][1] * w
            s[h] = uv_to(u, v)
        if len(s) == len(HOURS):
            out[m] = s
    return out


def ens_key(lat, lon):
    return f"{round(lat * 4) / 4:.2f},{round(lon * 4) / 4:.2f}"


def collect(start, end, buoy):
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(os.path.join(HERE, "pairs_esfr.json"))) if p["cls"] in ("a", "a2")]
    sites = []   # (pair id, spot, obs hour->(kn,dir), fc, ens key, kind)
    for p in pairs:
        spot = spots[p["spot"]]
        obs, height = observations(p["station"], start, end)
        if not obs:
            continue
        obs = {h: (to_10m(kn, height), d) for h, (kn, d) in obs.items()}
        fc, where = forecasts(spot, start, end)
        ec = where.get((EC, "sea")) or (spot["latitude"], spot["longitude"])
        sites.append((f"{p['spot']}|{p['station']['id']}", spot, obs, fc, ens_key(*ec), "mast"))
    if buoy:
        from buoys import BUOYS, read_buoy, to_10m_sea
        b = BUOYS["POEM"]
        obs, _ = read_buoy(b["prefix"], start, end)
        obs = {h: (to_10m_sea(kn, b["height"]), d) for h, (kn, d) in obs.items()}
        for sid in b["spots"]:
            spot = spots[sid]
            fc, where = forecasts(spot, start, end)
            ec = where.get((EC, "sea")) or (spot["latitude"], spot["longitude"])
            sites.append((f"{sid}|POEM", spot, obs, fc, ens_key(*ec), "buoy"))

    rows = []
    d0, d1 = dt.date.fromisoformat(start), dt.date.fromisoformat(end)
    day = d0
    while day <= d1:
        path = os.path.join(ENS, f"{day:%Y%m%d}.json")
        ens = json.load(open(path)) if os.path.exists(path) else None
        ds = day.isoformat()
        for pid, spot, obs, fc, ekey, kind in sites:
            o = {h: obs[f"{ds}T{h:02d}"] for h in HOURS if f"{ds}T{h:02d}" in obs}
            if len(o) < 9:   # ≥ 9 of 11 daylight hours measured
                continue
            det = {}
            for m, cell in DET:
                s = {h: fc.get((m, cell), {}).get(1, {}).get(f"{ds}T{h:02d}") for h in HOURS}
                s = {h: v for h, v in s.items() if v}
                if len(s) == len(HOURS):
                    det[m] = s
            if BM not in det:
                continue
            mem = members(ens, ekey) if ens else {}
            rows.append({"pair": pid, "spot": spot, "kind": kind, "day": ds,
                         "region": REGIONS.get(spot["region"], spot["region"]),
                         "obs": ride(o, spot), "obs15": ride(o, spot, 15), "obs_best": best2(o, spot) if len(o) == len(HOURS) else None,
                         "det": {m: (ride(s, spot), ride(s, spot, 15), best2(s, spot)) for m, s in det.items()},
                         "ens": [(ride(s, spot), ride(s, spot, 15), best2(s, spot)) for s in mem.values()],
                         "ens_series": list(mem.values())})
        day += dt.timedelta(days=1)
    return rows


# MARK: Methods

def phi(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))


def week_parity(day):
    return dt.date.fromisoformat(day).isocalendar()[1] % 2


def a2_prob(r, b, s, thr):
    xs = [v[2] for v in r["det"].values() if v[2] is not None]
    if len(xs) < 2:
        return None
    mean, sd = statistics.mean(xs), statistics.pstdev(xs)
    return phi((mean - thr + b) / math.sqrt(sd ** 2 + s ** 2))


def ens_scaled(r, c, thr):
    if not r["ens_series"]:
        return None
    n = 0
    for s in r["ens_series"]:
        n += ride({h: (kn * c, d) for h, (kn, d) in s.items()}, r["spot"], thr)
    return n / len(r["ens_series"])


def brier(ps):
    return statistics.mean((p - o) ** 2 for p, o in ps)


def fit(rows, f, grid, idx):
    best = None
    for params in grid:
        ps = [(f(r, *params), r[idx]) for r in rows]
        ps = [(p, o) for p, o in ps if p is not None]
        if ps:
            bs = brier(ps)
            if best is None or bs < best[0]:
                best = (bs, params)
    return best[1] if best else grid[len(grid) // 2]


def chances(rows, thr=LO):
    """Attach r['p'][method] for event threshold thr (12 or 15). Fitted methods: two folds by week."""
    idx = "obs" if thr == LO else "obs15"
    k = 0 if thr == LO else 1
    a2_grid = [(b, s) for b in [x * 0.5 for x in range(-8, 9)] for s in [0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6]]
    c_grid = [(c,) for c in [0.8 + 0.05 * i for i in range(17)]]
    fitted = {}
    for par in (0, 1):
        train = [r for r in rows if week_parity(r["day"]) != par]
        fitted[par] = (fit(train, lambda r, b, s: a2_prob(r, b, s, thr), a2_grid, idx),
                       fit([r for r in train if r["ens"]], lambda r, c: ens_scaled(r, c, thr), c_grid, idx))
    for r in rows:
        (b, s), (c,) = fitted[week_parity(r["day"])]
        p = r.setdefault("p", {}).setdefault(thr, {})
        p["Today"] = 1.0 if r["det"][BM][k] else 0.0
        p["A1 votes"] = sum(v[k] for v in r["det"].values()) / len(r["det"])
        p["A2 margin"] = a2_prob(r, b, s, thr)
        if r["ens"]:
            p["B1 ENS raw"] = sum(v[k] for v in r["ens"]) / len(r["ens"])
            p["B2 ENS x c"] = ens_scaled(r, c, thr)
            arome = r["det"].get(HD, (None, None, None))[2]
            xs = [v[2] for v in r["ens"] if v[2] is not None]
            if arome is not None and xs:
                shift = arome - statistics.mean(xs)
                p["B3 ENS+AROME"] = sum(1 for x in xs if x + shift >= thr) / len(xs)
    return fitted


# MARK: Scores

def score(rows, m, thr, cut=0.5):
    idx = "obs" if thr == LO else "obs15"
    ps = [(r["p"][thr][m], r[idx]) for r in rows if r["p"][thr].get(m) is not None]
    if len(ps) < 30:
        return None
    clim = statistics.mean(o for _, o in ps)
    bs = brier(ps)
    ref = statistics.mean((clim - o) ** 2 for _, o in ps)
    go = [(p, o) for p, o in ps if p >= cut]
    hits = sum(o for _, o in go)
    events = sum(o for _, o in ps)
    return {"n": len(ps), "base": clim, "brier": bs, "bss": 1 - bs / ref if ref else None,
            "go": len(go), "wrong": (len(go) - hits) / len(go) if go else None,
            "caught": hits / events if events else None,
            "sharp": sum(1 for p, _ in ps if p >= 0.7 or p <= 0.3) / len(ps)}


def boot_diff(rows, m, ref, thr, reps=500, seed=11):
    """95 % interval over dates of Brier skill(m) - Brier skill(ref) on the days both exist."""
    idx = "obs" if thr == LO else "obs15"
    both = [r for r in rows if r["p"][thr].get(m) is not None and r["p"][thr].get(ref) is not None]
    by = {}
    for r in both:
        by.setdefault(r["day"], []).append(r)
    dates = sorted(by)
    rng = random.Random(seed)
    out = []
    for _ in range(reps):
        s = [r for d in (rng.choice(dates) for _ in dates) for r in by[d]]
        clim = statistics.mean(r[idx] for r in s)
        ref_bs = statistics.mean((clim - r[idx]) ** 2 for r in s) or 1e-9
        a = 1 - statistics.mean((r["p"][thr][m] - r[idx]) ** 2 for r in s) / ref_bs
        b = 1 - statistics.mean((r["p"][thr][ref] - r[idx]) ** 2 for r in s) / ref_bs
        out.append(a - b)
    out.sort()
    return out[int(0.025 * reps)], out[int(0.975 * reps) - 1]


def reliability(rows, m, thr):
    idx = "obs" if thr == LO else "obs15"
    bins = [(0, 0.1), (0.1, 0.3), (0.3, 0.5), (0.5, 0.7), (0.7, 0.9), (0.9, 1.01)]
    out = []
    for lo, hi in bins:
        ps = [(r["p"][thr][m], r[idx]) for r in rows if r["p"][thr].get(m) is not None and lo <= r["p"][thr][m] < hi]
        out.append((lo, hi, len(ps), statistics.mean(p for p, _ in ps) if ps else None,
                    statistics.mean(o for _, o in ps) if ps else None))
    return out


def pc(x):
    return "–" if x is None else f"{100 * x:.0f} %"


def report(rows, title, thr, ref="A1 votes", diffs=True):
    print(f"### {title}\n")
    sub = [r for r in rows if r["ens"]]
    days = len({r["day"] for r in sub})
    print(f"{len(sub)} spot-days ({days} dates, {len({r['pair'] for r in sub})} spot/station pairs), "
          f"measured go on {pc(statistics.mean(r['obs' if thr == LO else 'obs15'] for r in sub) if sub else None)} of them. "
          "Only spot-days where every method has a forecast.\n")
    print("| Method | Skill vs climate (Brier) | Says go (≥ 50 %) | wrong gos | go days caught | Says go (≥ 70 %) | wrong gos | caught | Clear calls (≤ 30 % or ≥ 70 %) |")
    print("|---|---|---|---|---|---|---|---|---|")
    for m in METHODS:
        s, s7 = score(sub, m, thr), score(sub, m, thr, 0.7)
        if s:
            bss = "–" if s["bss"] is None else f"{s['bss']:+.2f}"
            print(f"| {m} | {bss} | {s['go']} | {pc(s['wrong'])} | {pc(s['caught'])} | "
                  f"{s7['go']} | {pc(s7['wrong'])} | {pc(s7['caught'])} | {pc(s['sharp'])} |")
    print()
    if diffs and len({r['day'] for r in sub}) >= 20:
        print(f"Difference in skill with **{ref}**, 95 % interval over dates: ", end="")
        print("; ".join(f"{m} {a:+.2f} … {b:+.2f}" for m in METHODS if m != ref
                        for a, b in [boot_diff(sub, m, ref, thr)]) + "\n")
    print("Does x % happen x % of the time? (chance band: spot-days, mean chance given → share that were go)\n")
    print("| Method | 0–10 % | 10–30 % | 30–50 % | 50–70 % | 70–90 % | 90–100 % |")
    print("|---|---|---|---|---|---|---|")
    for m in METHODS[1:]:
        cells = []
        for lo, hi, n, mp, mo in reliability(sub, m, thr):
            cells.append("–" if not n else f"{n}: {pc(mp)} → **{pc(mo)}**")
        print(f"| {m} | " + " | ".join(cells) + " |")
    print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2026-08-08")
    ap.add_argument("--end", default="2026-10-30")
    ap.add_argument("--no-buoy", action="store_true")
    a = ap.parse_args()
    rows = collect(a.start, a.end, not a.no_buoy)
    print(f"# WHE-81: chance you'll kite, {a.start} … {a.end}\n")
    print(f"{len(rows)} spot-days with a measurement and today's forecast; {sum(1 for r in rows if r['ens'])} with the ensemble too. "
          f"Go = two hours in a row between {LO} and {HI} kn, direction not offshore, 07–17 UTC. Forecast made the day before.\n")
    for thr in (LO, 15):
        fitted = chances(rows, thr)
        print(f"## Go at {thr} kn+\n")
        print("Fitted on the other weeks: " + "; ".join(
            f"weeks {'odd' if par else 'even'}: A2 b = {f[0][0]:+.1f} kn, s = {f[0][1]:.1f} kn, B2 c = {f[1][0]:.2f}"
            for par, f in sorted(fitted.items())) + "\n")
        masts = [r for r in rows if r["kind"] == "mast"]
        report(masts, "All shore masts", thr)
        for reg in sorted({r["region"] for r in masts}):
            sub = [r for r in masts if r["region"] == reg]
            if len({r["day"] for r in sub if r["ens"]}) >= 20:
                report(sub, f"{reg} only", thr, diffs=False)
        report([r for r in rows if r["kind"] == "buoy"], "On the water: POEM buoy, Torreilles and Saint-Cyprien", thr, diffs=False)
        # Robustness: drop one region at a time
        print("Drop one region at a time (skill A1 / A2 / B1 / B2 / B3, wrong gos Today → B2):\n")
        for reg in sorted({r["region"] for r in masts}):
            sub = [r for r in masts if r["region"] != reg and r["ens"]]
            ss = {m: score(sub, m, thr) for m in METHODS}
            if all(ss.values()) and all(v["bss"] is not None for v in ss.values()):
                print(f"- without {reg}: " + " / ".join(f"{ss[m]['bss']:+.2f}" for m in METHODS[1:]) +
                      f"; wrong gos {pc(ss['Today']['wrong'])} → {pc(ss['B2 ENS x c']['wrong'])}")
        print()
    json.dump([{"pair": r["pair"], "day": r["day"], "obs": r["obs"], "obs15": r["obs15"], "p": r["p"]} for r in rows],
              open(os.path.join(HERE, ".cache", "whe81_rows.json"), "w"))


if __name__ == "__main__":
    main()
