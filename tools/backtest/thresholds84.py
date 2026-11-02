"""Set the Go / Most likely cut-offs with one method everywhere, check them on unseen weeks (WHE-84).

Chance per spot-day = WHE-81's A2 margin: the 4 models' mean best 2 h vs 12 kn, widened by their
spread: p = Phi((mean - 12 + b) / sqrt(sd^2 + s^2)). Per day ahead (0-4), on the tuning weeks:
  1. fit b and s (Brier score, pooled truth),
  2. Go cut = lowest p at which spot-days with p >= cut came true >= 80 %,
  3. Most likely cut = lowest p at which spot-days between it and the Go cut came true >= 70 %.
Tuning weeks = even ISO weeks, scored on odd weeks, and back (every day is scored with numbers that
never saw it). Nothing is tuned per country or per place: the groups are for checking only.

Truth sets (--truth):
  trusted  France masts + southern Spanish masts + POEM near-shore buoy + Begur/Tarragona open-sea
           buoys (Catalan Meteocat masts left out: they read about half the forecast and half the
           buoys in every wind direction, see diag84.py)
  all      the same plus the Catalan masts (as WHE-81 did)

    BACKTEST_OFFLINE=1 python3 tools/backtest/thresholds84.py --truth trusted
"""
import argparse
import datetime as dt
import os
import random
import sys

sys.path.insert(0, os.path.dirname(__file__))
from chance import collect, sites, fit, a2_prob, week_parity, LO  # noqa: E402
from diag84 import open_sea_buoys, wh62_forecasts, START, END  # noqa: E402
from esfr_backtest import BM  # noqa: E402

LEADS = [0, 1, 2, 3, 4]
GO, ML = float(os.environ.get("GO_TARGET", "0.80")), 0.70
CUTS = [x / 100 for x in range(30, 100)]
GROUPS = ["France", "Mainland Spain (south masts)", "Catalonia masts (not trusted)", "Canaries",
          "Near-shore buoy (POEM)", "Open-sea buoys (Begur, Tarragona)"]


def group_of(pair):
    spot, st = pair.split("|")
    if st == "POEM":
        return "Near-shore buoy (POEM)"
    if spot.startswith("buoy-"):
        return "Open-sea buoys (Begur, Tarragona)"
    if spot.startswith("fr-"):
        return "France"
    if any(k in spot for k in ("canaria", "lanzarote")):
        return "Canaries"
    if any(k in spot for k in ("tarifa", "cadiz", "rota", "almeria", "mar-menor")):
        return "Mainland Spain (south masts)"
    return "Catalonia masts (not trusted)"


def all_sites():
    out = []
    for pid, spot, obs, fc, ekey, kind in sites(START, END, True):
        if kind == "buoy" and not fc[(BM, "sea")][1]:
            fc = wh62_forecasts(spot["latitude"], spot["longitude"])
        out.append((pid, spot, obs, fc, ekey, kind))
    for pid, spot, obs, fc, ekey, kind in open_sea_buoys():
        spot = dict(spot, region="open sea", name=pid)
        out.append((pid, spot, obs, fc, ekey, kind))
    # pad leads the WHE-62 cache doesn't have (buoys: day 0-2 only)
    for _, _, _, fc, _, _ in out:
        for k in fc:
            for lead in range(6):
                fc[k].setdefault(lead, {})
    return out


def cuts(rows):
    """(go cut, most-likely cut) from tuning rows with r['pp'] set."""
    go = next((c for c in CUTS if (lambda s: len(s) >= 30 and sum(s) / len(s) >= GO)(
        [r["obs"] for r in rows if r["pp"] >= c])), None)
    if go is None:
        return None, None
    ml = next((c for c in CUTS if c < go and (lambda s: len(s) >= 30 and sum(s) / len(s) >= ML)(
        [r["obs"] for r in rows if c <= r["pp"] < go])), None)
    return go, ml


def label(r, go, ml):
    if go is not None and r["pp"] >= go:
        return "Go"
    if ml is not None and r["pp"] >= ml:
        return "Most likely"
    return "below"


def boot(rows, pred, reps=300, seed=3):
    """hit rate of rows matching pred, 95 % interval resampling whole dates."""
    by = {}
    for r in rows:
        if pred(r):
            by.setdefault(r["day"], []).append(r["obs"])
    n = sum(len(v) for v in by.values())
    if not n:
        return 0, 0, None, None
    rate = sum(sum(v) for v in by.values()) / n
    dates = sorted(by)
    rng = random.Random(seed)
    bs = []
    for _ in range(reps):
        xs = [o for d in (rng.choice(dates) for _ in dates) for o in by[d]]
        bs.append(sum(xs) / len(xs))
    bs.sort()
    return n, len(dates), rate, (bs[int(0.025 * reps)], bs[int(0.975 * reps) - 1])


def pc(x):
    return "–" if x is None else f"{100 * x:.0f} %"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--truth", default="trusted", choices=["trusted", "all"])
    a = ap.parse_args()
    rows = [r for r in collect(all_sites(), START, END) if r["lead"] in LEADS]
    for r in rows:
        r["group"] = group_of(r["pair"])
    tune_ok = (lambda r: r["group"] not in ("Catalonia masts (not trusted)", "Canaries")) if a.truth == "trusted" \
        else (lambda r: r["group"] != "Canaries")
    print(f"# WHE-84: Go and Most likely cut-offs, truth = {a.truth}, {START} … {END}\n")
    print("Go = two hours in a row 12–28 kn, direction not offshore, 07–17 UTC (as WHE-81). "
          "Cut-offs and the chance formula fitted per day ahead on the other weeks, pooled over the tuning truth "
          f"({'France + southern Spain masts + buoys' if a.truth == 'trusted' else 'all masts except Canaries + buoys'}). "
          "Cells: came true (95 % interval over dates) · spot-days / dates.\n")
    fitted = {}
    for lead in LEADS:
        for par in (0, 1):
            tune = [r for r in rows if r["lead"] == lead and week_parity(r["day"]) != par and tune_ok(r)]
            b, s = fit(tune, LO, "obs")
            for r in rows:
                if r["lead"] == lead and week_parity(r["day"]) == par:
                    r["pp"] = a2_prob(r, b, s, LO)
            for r in tune:
                r["_tune"] = a2_prob(r, b, s, LO)
            tune = [dict(r, pp=r["_tune"]) for r in tune if r["_tune"] is not None]
            fitted[(lead, par)] = (b, s) + cuts(tune)
    rows = [r for r in rows if r.get("pp") is not None]
    print("| Day ahead | Scored weeks | b (kn) | s (kn) | Go cut | Most likely cut |")
    print("|---|---|---|---|---|---|")
    for (lead, par), (b, s, go, ml) in sorted(fitted.items()):
        print(f"| {lead} | {'odd' if par else 'even'} | {b:+.1f} | {s:.1f} | {pc(go)} | {pc(ml)} |")
    print()
    for r in rows:
        _, _, go, ml = fitted[(r["lead"], week_parity(r["day"]))]
        r["lab"] = label(r, go, ml)
    print("| Day ahead | Group | Go came true | wrong gos | Most likely came true | real go days with Go | "
          "with Go or Most likely | measured go days |")
    print("|---|---|---|---|---|---|---|---|")
    for lead in LEADS:
        for g in GROUPS:
            sub = [r for r in rows if r["lead"] == lead and r["group"] == g]
            if not sub:
                continue
            n, nd, rate, iv = boot(sub, lambda r: r["lab"] == "Go")
            m, md, mr, miv = boot(sub, lambda r: r["lab"] == "Most likely")
            ev = [r for r in sub if r["obs"]]
            cg = sum(r["lab"] == "Go" for r in ev)
            cm = sum(r["lab"] in ("Go", "Most likely") for r in ev)
            cell = lambda n, nd, rate, iv: "–" if not n else f"**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}) · {n}/{nd}"
            print(f"| {lead} | {g} | {cell(n, nd, rate, iv)} | {'–' if not n else pc(1 - rate)} | {cell(m, md, mr, miv)} | "
                  f"{cg} ({pc(cg / len(ev) if ev else None)}) | {cm} ({pc(cm / len(ev) if ev else None)}) | {len(ev)} of {len(sub)} |")
    print()


if __name__ == "__main__":
    main()
