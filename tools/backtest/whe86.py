"""Catalan forecasts against shore-level official sensors: harbour, airport, delta masts (WHE-86).

WHE-84 left Catalan Meteocat masts out of the truth because they read about half the forecast.
This checks that with sensors that sit where the wind is open:
  - Barcelona airport (AEMET mast, METAR via IEM, and the SYNOP 08181 as a cross-check), on the
    Llobregat delta 1-2 km from the beach
  - Meteocat's two Port de Barcelona masts (Bocana Sud on the harbour mouth, ZAL Prat in the
    logistics zone), plus the other Meteocat masts on the delta and the coast

Part 1 (no model involved): each mast against the airport, same hours, airport >= 10 kn.
Part 2: each mast against the 4-model forecast read at the mast itself (any direction counts, as
for buoys), days ahead 0-4, Go = WHE-84's A2 chance with the cut-offs tuned at 85 % on the
trusted truth (results/whe84_thresholds_trusted85.md), no refit.
Part 3: the same Go test at the two nearest spots (Castelldefels vs the airport, Barceloneta vs
Bocana Sud), forecast at the spot with its direction rule, as the app reads it.

    python3 tools/backtest/whe86.py > tools/backtest/results/whe86.md
"""
import os
import re
import statistics
import sys

sys.path.insert(0, os.path.dirname(__file__))
from chance import det_forecasts, collect, a2_prob, week_parity, best2, HOURS, LO, BM  # noqa: E402
from review import to_10m  # noqa: E402
from stations import observations, xema_stations, load_spots, km  # noqa: E402
from thresholds84 import boot, pc  # noqa: E402

START, END = "2026-08-08", "2026-10-25"   # Meteocat open feed gap 26-30 Oct
HERE = os.path.dirname(__file__)
LEADS = [0, 1, 2, 3, 4]

# (id, source, siting note)
MASTS = [
    ("LEBL", "metar", "Barcelona airport, AEMET mast, flat delta 1-2 km from the beach"),
    ("Y7", "xema", "Port de Barcelona, Bocana Sud: harbour mouth breakwater"),
    ("YQ", "xema", "Port de Barcelona, ZAL Prat: logistics zone behind the docks"),
    ("XL", "xema", "El Prat de Llobregat: town edge, 4 km inland"),
    ("YY", "xema", "Viladecans, les Filipines: 2 m mast behind the beach"),
    ("DL", "xema", "Illa de Buda, Ebro delta: rice fields at the delta tip"),
    ("UW", "xema", "Els Alfacs, Ebro delta: 2 m mast on the bay shore"),
    ("DK", "xema", "Torredembarra: 10 m mast in town"),
    ("WT", "xema", "Malgrat de Mar: 10 m mast"),
    ("U2", "xema", "Sant Pere Pescador: fields 1.6 km behind the beach"),
    ("D4", "xema", "Roses: town, 23 m up"),
    ("W1", "xema", "Castelló d'Empúries: fields 5 km from the beach"),
]
APP_PAIRS = [("es-castelldefels", "LEBL"), ("es-barcelona-barceloneta", "Y7")]


def cutoffs():
    """(lead, scored-week parity) -> (b, s, go cut) from WHE-84's trusted 85 % table."""
    out = {}
    for line in open(os.path.join(HERE, "results", "whe84_thresholds_trusted85.md")):
        m = re.match(r"\| (\d) \| (even|odd) \| ([+-][\d.]+) \| ([\d.]+) \| (\d+) % \|", line)
        if m:
            out[(int(m[1]), 1 if m[2] == "odd" else 0)] = (float(m[3]), float(m[4]), int(m[5]) / 100)
    return out


def station(sid, source):
    if source == "metar":
        return {"source": "metar", "id": sid, "name": "AEMET Barcelona airport", "lat": 41.2971, "lon": 2.0785}
    return next(s for s in xema_stations() if s["id"] == sid)


def obs10(st):
    o, h = observations(st, START, END)
    return {k: (to_10m(kn, h), d) for k, (kn, d) in o.items()}, h


def day_hours(o, k):
    return 7 <= int(k[11:13]) <= 17


def main():
    cuts = cutoffs()
    spots = {s["id"]: s for s in load_spots()}
    print(f"# WHE-86: Catalan forecasts against harbour, airport and delta masts, {START} … {END}\n")

    # Part 1
    print("## 1. Masts against the airport (no forecast involved)\n")
    print("Median of mast ÷ airport, hours 07-17 UTC when the airport reads ≥ 10 kn. 2 m masts brought to "
          "10 m with the log profile (as WHE-81). Sea breeze = airport direction 150-250°.\n")
    print("| Mast | Height m | km to airport | Ratio, all | Ratio, sea breeze | Hours |")
    print("|---|---|---|---|---|---|")
    sts = {sid: station(sid, src) for sid, src, _ in MASTS}
    obs = {}
    heights = {}
    for sid, _, _ in MASTS:
        obs[sid], heights[sid] = obs10(sts[sid])
    syn, _ = observations({"source": "synop", "id": "08181"}, START, END)
    ref = obs["LEBL"]
    for sid, o, h, name in [("08181", syn, 10, "AEMET Barcelona airport SYNOP")] + \
            [(sid, obs[sid], heights[sid], sts[sid]["name"]) for sid, _, _ in MASTS[1:5]]:
        ks = [k for k in o if k in ref and ref[k][0] >= 10 and day_hours(o, k)]
        sb = [k for k in ks if ref[k][1] and 150 <= ref[k][1] <= 250]
        r = statistics.median(o[k][0] / ref[k][0] for k in ks)
        rs = statistics.median(o[k][0] / ref[k][0] for k in sb)
        d = 0 if sid == "08181" else km(sts[sid]["lat"], sts[sid]["lon"], sts["LEBL"]["lat"], sts["LEBL"]["lon"])
        print(f"| {name} | {h} | {d:.1f} | **{r:.2f}** | {rs:.2f} | {len(ks)} |")
    print()

    # Part 2
    def rows_for(pid, spot, o):
        fc = det_forecasts(spot, START, END)
        rs = [r for r in collect([(pid, spot, o, fc, None, "mast")], START, END) if r["lead"] in LEADS]
        for r in rs:
            b, s, go = cuts[(r["lead"], week_parity(r["day"]))]
            p = a2_prob(r, b, s, LO)
            r["go"] = p is not None and p >= go
        return rs, fc

    def level(o, fc):
        """median measured ÷ forecast (best match, sea cell, day ahead 1), 07-17 UTC, forecast ≥ 10 kn; and the
        mean best 2 h bias (forecast - measured), any direction."""
        f1 = fc[(BM, "sea")][1]
        ks = [k for k in o if k in f1 and f1[k][0] >= 10 and day_hours(o, k)]
        ratio = statistics.median(o[k][0] / f1[k][0] for k in ks) if ks else None
        days = sorted({k[:10] for k in o})
        bias = []
        for dday in days:
            so = {h: o.get(f"{dday}T{h:02d}") for h in HOURS}
            sf = {h: f1.get(f"{dday}T{h:02d}") for h in HOURS}
            if all(so.values()) and all(sf.values()):
                any_dir = {"waterType": "lagoon"}
                bias.append(best2(sf, any_dir) - best2(so, any_dir))
        return ratio, len(ks), (statistics.mean(bias) if bias else None)

    print("## 2. Forecast read at each mast (any wind direction counts)\n")
    print("Level: measured ÷ best match (sea cell, day ahead 1), hours 07-17 UTC with forecast ≥ 10 kn, median; "
          "bias = forecast − measured best 2 h, mean over days. Go = WHE-84 chance with its 85 % cut-offs "
          "(not refitted here). Go came true: share, 95 % interval over dates, Go days / dates.\n")
    print("| Mast | Siting | Level ratio (h) | Bias best 2 h kn | Measured go days | "
          + " | ".join(f"Go came true, day {l}" for l in LEADS) + " |")
    print("|---|---|---|---|---|" + "---|" * len(LEADS))
    all_rows = {}
    for sid, _, note in MASTS:
        st = sts[sid]
        near = min(spots.values(), key=lambda x: km(st["lat"], st["lon"], x["latitude"], x["longitude"]))
        spot = {"id": f"mast-{sid}", "latitude": st["lat"], "longitude": st["lon"], "waterType": "lagoon",
                "seaFacingDeg": near.get("seaFacingDeg"), "region": "Catalunya", "name": st["name"]}
        rs, fc = rows_for(f"mast-{sid}", spot, obs[sid])
        all_rows[sid] = rs
        ratio, nh, bias = level(obs[sid], fc)
        meas = len({r["day"] for r in rs if r["obs"]})
        ndays = len({r["day"] for r in rs})
        cells = []
        for lead in LEADS:
            n, nd, rate, iv = boot([r for r in rs if r["lead"] == lead], lambda r: r["go"])
            cells.append("–" if not n else f"**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}) · {n}/{nd}")
        print(f"| {st['name']} | {note} | {'–' if ratio is None else f'{ratio:.2f}'} ({nh}) | "
              f"{'–' if bias is None else f'{bias:+.1f}'} | {meas} of {ndays} | " + " | ".join(cells) + " |")
    print()

    # pooled: open-exposure masts only
    print("Pooled over the two open masts (airport + Bocana Sud), every day ahead 0-4 together:\n")
    pooled = all_rows["LEBL"] + all_rows["Y7"]
    n, nd, rate, iv = boot(pooled, lambda r: r["go"])
    ev = [r for r in pooled if r["obs"]]
    caught = sum(r["go"] for r in ev)
    print(f"- Go came true **{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}), {n} Go spot-days over {nd} dates; "
          f"measured go spot-days flagged Go: {caught} of {len(ev)} ({pc(caught / len(ev) if ev else None)})\n")
    for kind in ("sea breeze", "weather system"):
        sub = [r for r in pooled if r["dayk"] == kind]
        n, nd, rate, iv = boot(sub, lambda r: r["go"])
        print(f"- {kind} days: Go came true {'–' if not n else f'**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}), {n}/{nd}'}")
    print()

    # Part 3
    print("## 3. As the app reads it: forecast at the spot, the spot's direction rule, truth at the nearest open mast\n")
    print("| Spot | Mast | km | " + " | ".join(f"Go came true, day {l}" for l in LEADS) + " | All days ahead | Measured go days caught |")
    print("|---|---|---|" + "---|" * len(LEADS) + "---|---|")
    for spid, sid in APP_PAIRS:
        spot = spots[spid]
        rs, _ = rows_for(f"{spid}|{sid}", spot, obs[sid])
        d = km(spot["latitude"], spot["longitude"], sts[sid]["lat"], sts[sid]["lon"])
        cells = []
        for lead in LEADS:
            n, nd, rate, iv = boot([r for r in rs if r["lead"] == lead], lambda r: r["go"])
            cells.append("–" if not n else f"**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}) · {n}/{nd}")
        n, nd, rate, iv = boot(rs, lambda r: r["go"])
        ev = [r for r in rs if r["obs"]]
        caught = sum(r["go"] for r in ev)
        print(f"| {spot['name']} | {sts[sid]['name']} | {d:.1f} | " + " | ".join(cells) +
              f" | {'–' if not n else f'**{pc(rate)}** ({pc(iv[0])}–{pc(iv[1])}) · {n}/{nd}'} | {caught} of {len(ev)} |")
    print()


if __name__ == "__main__":
    main()
