"""AROME 1.3 first, then best match, on the sea cell (WHE-78).

The idea from WHE-62: buoys say today's setup (best match, sea cell) has the most honest level,
and AROME 1.3 alone is closest on the water for the first two days. So: read AROME 1.3 on the
sea cell while it has data (its runs reach about 48 h, so days 0 and 1), best match after.

First thing this script measures: where that actually changes anything. Open-Meteo's best
match already *is* AROME 1.3 on some coasts for days 0–1; there the setup is today's setup.

Setups (per hour; "mean" = mean speed, vector-mean direction, as Blend.hour):
  1 Baseline        best match, sea cell (what main ships today)
  2 AROME first sea AROME 1.3 sea cell when it has the hour, else best match sea cell
  3 AROME first beach AROME 1.3 beach cell when it has the hour, else best match sea cell
  4 Option 1        mean AROME 1.3 + ICON beach cell, ECMWF sea cell (WHE-61, reference)

Truth: the WHE-72 main shore stations (pairs_esfr.json, classes a / a2, inside AROME's domain)
and the WHE-62 buoys (POEM read at the two nearest spots; Begur and Tarragona read at the buoy).
Leads 0–3 from the Previous Runs API. Scores and day bootstrap from esfr_backtest.py.

    python3 tools/backtest/arome_first.py --prefetch 3 > tools/backtest/results/whe78.md
"""
import argparse
import json
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
import esfr_backtest as E  # noqa: E402
from buoys import BUOYS, read_buoy, to_10m_sea  # noqa: E402
from stations import observations, km, load_spots  # noqa: E402
from review import to_10m  # noqa: E402

HD, ICON, EC, BM = E.HD, E.ICON, E.EC, E.BM
E.REQUESTS = {"sea": ("sea", 0, [BM, HD, EC]), "land": ("land", 0, [HD, ICON])}
E.LEADS = {0: "", 1: "_previous_day1", 2: "_previous_day2", 3: "_previous_day3"}
OUT_OF_AROME = {"Canaries", "Andalusia/Tarifa"}
SETUPS = ["1 Baseline: best match, sea cell", "2 AROME first, sea cell", "3 AROME first, beach cell",
          "4 Option 1: AROME+ICON beach, ECMWF sea"]


def setup_hour(name, fc, lead, h):
    m = E.member
    if name.startswith("1"):
        return m(fc, BM, "sea", lead, h)
    if name.startswith("2"):
        return m(fc, HD, "sea", lead, h) or m(fc, BM, "sea", lead, h)
    if name.startswith("3"):
        return m(fc, HD, "land", lead, h) or m(fc, BM, "sea", lead, h)
    vals = [v for v in (m(fc, HD, "land", lead, h), m(fc, ICON, "land", lead, h), m(fc, EC, "sea", lead, h)) if v]
    return E.vmean(vals) if vals else None


def attach(rows):
    for r in rows:
        r["f"] = {}
        for lead in E.LEADS:
            for name in SETUPS:
                v = setup_hour(name, r["fc"], lead, r["hour"])
                if v:
                    r["f"][(name, lead)] = v


def same_as_baseline(fc, lead):
    """Share of daylight hours where AROME 1.3 sea and best match sea differ by < 0.05 kn."""
    a, b = fc.get((HD, "sea"), {}).get(lead, {}), fc.get((BM, "sea"), {}).get(lead, {})
    both = [h for h in a if h in b]
    if not both:
        return None
    return sum(abs(a[h][0] - b[h][0]) < 0.05 for h in both) / len(both)


def station_rows(pairs, spots, start, end):
    rows, info = [], []
    for p in pairs:
        spot = spots[p["spot"]]
        region = E.REGIONS.get(spot["region"], spot["region"])
        if region in OUT_OF_AROME:
            continue
        obs, height = observations(p["station"], start, end)
        if not obs:
            continue
        fc, _ = E.forecasts(spot, start, end)
        info.append((spot, p, region, same_as_baseline(fc, 1)))
        for h, (kn, d) in obs.items():
            if int(h[11:13]) in E.DAY_UTC and start <= h[:10] <= end:
                rows.append({"pair": p["spot"], "station": p["station"]["id"], "cls": p["cls"], "spot": spot,
                             "region": region, "day": h[:10], "hour": h, "obs": to_10m(kn, height), "dir": d, "fc": fc})
    return rows, info


def buoy_rows(spots, start, end):
    """bid -> rows. POEM read at its two spots; the open-sea buoys read at the buoy."""
    out = {}
    for bid, b in BUOYS.items():
        obs, pos = read_buoy(b["prefix"], start, end)
        if not obs:
            continue
        targets = [spots[s] for s in b["spots"]] or [{"id": bid, "name": b["name"], "latitude": pos[0], "longitude": pos[1],
                                                       "seaFacingDeg": 0, "waterType": "lagoon", "region": "sea"}]
        rows = []
        for spot in targets:
            fc, _ = E.forecasts(spot, start, end)
            for h, (kn, d) in obs.items():
                if int(h[11:13]) in E.DAY_UTC:
                    rows.append({"pair": spot["id"], "station": bid, "cls": "buoy", "spot": spot, "region": bid,
                                 "day": h[:10], "hour": h, "obs": to_10m_sea(kn, b["height"]), "dir": d, "fc": fc})
        out[bid] = (b, rows, km(pos[0], pos[1], targets[0]["latitude"], targets[0]["longitude"]))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pairs", default="tools/backtest/pairs_esfr.json")
    ap.add_argument("--start", default="2026-08-08")
    ap.add_argument("--end", default="2026-10-30")
    ap.add_argument("--prefetch", type=int, default=0)
    a = ap.parse_args()
    spots = {s["id"]: s for s in load_spots()}
    pairs = [p for p in json.load(open(a.pairs)) if p["cls"] in ("a", "a2")]
    if a.prefetch:
        from concurrent.futures import ThreadPoolExecutor
        ids = sorted({p["spot"] for p in pairs if E.REGIONS.get(spots[p["spot"]]["region"]) not in OUT_OF_AROME})
        with ThreadPoolExecutor(a.prefetch) as ex:
            for i, _ in enumerate(ex.map(lambda sid: E.forecasts(spots[sid], a.start, a.end), ids)):
                print(f"prefetched {i + 1}/{len(ids)}", file=sys.stderr)

    rows, info = station_rows(pairs, spots, a.start, a.end)
    attach(rows)
    buoys = buoy_rows(spots, a.start, a.end)
    for _, brows, _ in buoys.values():
        attach(brows)

    print(f"# WHE-78: AROME 1.3 first, then best match, {a.start} … {a.end}\n")
    print("## Where the change does anything: share of day-1 daylight hours where best match (sea cell) "
          "already equals AROME 1.3 (sea cell)\n")
    by_reg = {}
    for spot, p, reg, same in info:
        if same is not None:
            by_reg.setdefault(reg, []).append((spot["name"], same))
    print("| Region | Spots | Already AROME 1.3 (median share) | Spots by share |")
    print("|---|---|---|---|")
    for reg, xs in sorted(by_reg.items()):
        print(f"| {reg} | {len(xs)} | {statistics.median(s for _, s in xs) * 100:.0f} % | "
              + ", ".join(f"{n} {s * 100:.0f} %" for n, s in sorted(xs, key=lambda x: x[1])) + " |")
    print()

    changed = {spot["id"] for spot, p, reg, same in info if same is not None and same < 0.5}
    for lead in E.LEADS:
        print(f"## Shore stations, day {lead} ahead\n")
        print("### All main stations in AROME's domain\n")
        E.table(rows, SETUPS, lead, ref=SETUPS[0])
        sub = [r for r in rows if r["pair"] in changed]
        print(f"### Only spots where best match is not AROME 1.3 ({len({r['pair'] for r in sub})} spots)\n")
        E.table(sub, SETUPS, lead, ref=SETUPS[0])

    print("## Per region, day 1 ahead (best 2 h bias / error · go days caught / false)\n")
    print("| Region | Spots | Days | " + " | ".join(s.split(":")[0] for s in SETUPS) + " |")
    print("|---" * (len(SETUPS) + 3) + "|")
    for reg in sorted({r["region"] for r in rows}):
        sub = [r for r in rows if r["region"] == reg]
        cells, nd = [], 0
        for name in SETUPS:
            s = E.scores(sub, (name, 1))
            nd = max(nd, s["days"] if s else 0)
            cells.append("–" if not s else f"{E.f1(s['d_bias'], True)} / {E.f1(s['d_mae'])} · {E.pc(s['pod'])} / {E.pc(s['far'])} ({s['go']})")
        print(f"| {reg} | {len({r['pair'] for r in sub})} | {nd} | " + " | ".join(cells) + " |")
    print()

    print("## Robustness: drop one station at a time (day 1, only spots where the change does something)\n")
    sub_all = [r for r in rows if r["pair"] in changed]
    for st in sorted({r["station"] for r in sub_all}):
        sub = [r for r in sub_all if r["station"] != st]
        s1, s2 = E.scores(sub, (SETUPS[0], 1)), E.scores(sub, (SETUPS[1], 1))
        if s1 and s2:
            print(f"- without {st}: best 2 h error {s1['d_mae']:.2f} → {s2['d_mae']:.2f}, bias {s1['d_bias']:+.2f} → {s2['d_bias']:+.2f}; "
                  f"caught {E.pc(s1['pod'])} → {E.pc(s2['pod'])}; false {E.pc(s1['far'])} → {E.pc(s2['far'])}")
    print()

    for bid, (b, brows, dist) in buoys.items():
        print(f"## Buoy: {b['name']} (read at {', '.join(sorted({r['spot']['name'] for r in brows}))}, {dist:.1f} km)\n")
        for lead in E.LEADS:
            print(f"### Day {lead} ahead\n")
            E.table(brows, SETUPS, lead, ref=SETUPS[0])
        fc = brows[0]["fc"] if brows else {}
        same = same_as_baseline(fc, 1)
        print(f"Best match already equals AROME 1.3 here on {same * 100:.0f} % of day-1 hours.\n" if same is not None else "")


if __name__ == "__main__":
    main()
