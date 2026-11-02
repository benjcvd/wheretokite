"""WHE-87 checks on the recommended mix: per group, strong-wind days, a few real days.

    BACKTEST_OFFLINE=1 python3 tools/backtest/whe87_checks.py > tools/backtest/results/whe87_checks.md
"""
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
import whe87 as w  # noqa: E402

MIX = "Mix MF beach + ECMWF 9 km + GFS sea"
CANDS = [w.TODAY, MIX]


def main():
    sites = w.site_list()
    fc = w.all_forecasts(sites, 4)
    rows = w.rows_for(sites, fc)
    for r in rows:
        r["pred"] = {c: w.predict(r, c) for c in CANDS}
    print("# WHE-87 checks: today (best match, sea cell) vs the mix (MF seamless beach + ECMWF 9 km sea + GFS sea)\n")
    print("## Per group: CSI / bias of the best 2 h (kn), today → mix\n")
    groups = sorted({r["group"] for r in rows})
    print("| Day ahead | " + " | ".join(groups) + " |")
    print("|---" * (len(groups) + 1) + "|")
    for lead in w.LEADS:
        cells = []
        for g in groups:
            gr = [r for r in rows if r["lead"] == lead and r["group"] == g]
            ms = [w.metrics([(r["obs"], *r["pred"][c][:2], r["ob2"]) for r in gr]) for c in CANDS]
            cells.append(" → ".join(f"{100 * (m['csi'] or 0):.0f} / {m['bias']:+.1f}" for m in ms))
        print(f"| {lead} | " + " | ".join(cells) + " |")
    print("\n## Strong wind: spot-days measured ≥ 22 kn (best 2 h)\n")
    print("Mean forecast best 2 h and share of those days the forecast reads ≥ 18 kn (would a rider be warned it's strong?).\n")
    print("| Day ahead | Spot-days | Measured | Today | Mix | Today ≥ 18 | Mix ≥ 18 |")
    print("|---|---|---|---|---|---|---|")
    for lead in w.LEADS:
        sr = [r for r in rows if r["lead"] == lead and r["ob2"] is not None and r["ob2"] >= 22]
        f = {c: [r["pred"][c][1] for r in sr] for c in CANDS}
        print(f"| {lead} | {len(sr)} | {statistics.mean(r['ob2'] for r in sr):.1f} | "
              f"{statistics.mean(f[w.TODAY]):.1f} | {statistics.mean(f[MIX]):.1f} | "
              f"{100 * sum(x >= 18 for x in f[w.TODAY]) / len(sr):.0f} % | {100 * sum(x >= 18 for x in f[MIX]) / len(sr):.0f} % |")
    print("\n## Real days, forecast 1 day ahead (best 2 h kn, go = ✓)\n")
    print("| Day | Site | Measured | Today | Mix |")
    print("|---|---|---|---|---|")
    picks = [r for r in rows if r["lead"] == 1 and r["group"] in ("Barcelona (airport, Bocana Sud)", "Open-sea buoys (Begur, Tarragona)")
             and r["ob2"] is not None]
    picks.sort(key=lambda r: -abs((r["pred"][MIX][1] or 0) - (r["pred"][w.TODAY][1] or 0)))
    tick = lambda b: " ✓" if b else ""
    for r in sorted(picks[:8], key=lambda r: r["day"]):
        print(f"| {r['day']} | {r['pair']} | {r['ob2']:.0f}{tick(r['obs'])} | {r['pred'][w.TODAY][1]:.0f}{tick(r['pred'][w.TODAY][0])}"
              f" | {r['pred'][MIX][1]:.0f}{tick(r['pred'][MIX][0])} |")


if __name__ == "__main__":
    main()
