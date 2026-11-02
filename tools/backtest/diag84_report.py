"""Tables from diag84.py's cache: one row per station pair (WHE-84).

    LEAD=1 python3 tools/backtest/diag84_report.py
"""
import json
import os
import statistics as st
import sys

sys.path.insert(0, os.path.dirname(__file__))
from model_backtest import angle  # noqa: E402

HERE = os.path.dirname(__file__)
BM = "best_match"
MEAN4 = "mean4"


def group(pid):
    s = pid.split("|")[0]
    if s.startswith("buoy-"):
        return "Open-sea buoys"
    if s.startswith("fr-"):
        return "France" if not pid.endswith("POEM") else "Buoy POEM"
    if pid.endswith("POEM"):
        return "Buoy POEM"
    if any(k in s for k in ("canaria", "lanzarote", "fuerteventura", "tenerife")):
        return "Canaries"
    if any(k in s for k in ("tarifa", "cadiz", "rota", "almeria", "mar-menor")):
        return "Spain south"
    return "Catalonia"


def f(x, d=1):
    return "–" if x is None else f"{x:+.{d}f}" if isinstance(x, float) and d < 0 else f"{x:.{d}f}"


def main():
    lead = int(os.environ.get("LEAD", "1"))
    data = json.load(open(os.path.join(HERE, ".cache", f"whe84_diag_l{lead}.json")))
    print(f"| Group | Pair | Station | Mast m | km | Days | Measured go | Best match go | of which came true | "
          f"Bias best 2 h (BM) | Bias, any direction | Go lost to direction rule | Go at 10 kn | Peak hour obs / fc | "
          f"Dir off > 45° on fc-go days |")
    print("|---" * 15 + "|")
    rows = []
    for r in data:
        ds = r["days"]
        if not ds:
            continue
        n = len(ds)
        ogo = sum(d["obs_go"] for d in ds)
        fgo = [d for d in ds if d["fc"][BM]["go"]]
        true = sum(d["obs_go"] for d in fgo)
        b = [d["fc"][BM]["b2"] - d["obs_b2"] for d in ds if d["obs_b2"] is not None and d["fc"][BM]["b2"] is not None]
        braw = [d["fc"][BM]["raw"] - d["obs_raw"] for d in ds if d["obs_raw"] is not None and d["fc"][BM]["raw"] is not None]
        lost = sum(1 for d in ds if d["obs_go_anydir"] and not d["obs_go"])
        go10 = sum(d["obs_go10"] for d in ds)
        pk_o = st.median(d["obs_peak"] for d in ds if d["fc"][BM]["b2"] and d["fc"][BM]["b2"] >= 10) if any(d["fc"][BM]["b2"] and d["fc"][BM]["b2"] >= 10 for d in ds) else None
        pk_f = st.median(d["fc"][BM]["peak"] for d in ds if d["fc"][BM]["b2"] and d["fc"][BM]["b2"] >= 10) if pk_o is not None else None
        off = [angle(a, b_) > 45 for d in fgo for a, b_, k, _ in d["fc_dir_obs_dir"] if a is not None and b_ is not None and k >= 4]
        g = group(r["pair"])
        rows.append((g, r, n, ogo, len(fgo), true, b, braw))
        print(f"| {g} | {r['pair'].split('|')[0][3:30]} | {r['station'][:30]} | {r['height']} | {r['km'] or '–'} | {n} | "
              f"{ogo} ({100 * ogo / n:.0f} %) | {len(fgo)} | {true} ({100 * true / len(fgo):.0f} %) |" if fgo else
              f"| {g} | {r['pair'].split('|')[0][3:30]} | {r['station'][:30]} | {r['height']} | {r['km'] or '–'} | {n} | "
              f"{ogo} ({100 * ogo / n:.0f} %) | 0 | – |", end="")
        print(f" {st.mean(b):+.1f} | {st.mean(braw):+.1f} | {lost} | {go10} | "
              f"{'–' if pk_o is None else f'{pk_o:.0f} / {pk_f:.0f}'} | {100 * st.mean(off):.0f} % |" if b and braw and off else
              f" {st.mean(b):+.1f} | – | {lost} | {go10} | – | – |" if b else " – | – | – | – | – | – |")
    print()
    print("| Group | Pairs | Spot-days | Measured go | Best-match go | came true | Bias best 2 h |")
    print("|---|---|---|---|---|---|---|")
    for g in ("France", "Buoy POEM", "Open-sea buoys", "Catalonia", "Spain south", "Canaries"):
        sel = [x for x in rows if x[0] == g]
        if not sel:
            continue
        n = sum(x[2] for x in sel); og = sum(x[3] for x in sel); fg = sum(x[4] for x in sel); t = sum(x[5] for x in sel)
        b = [v for x in sel for v in x[6]]
        print(f"| {g} | {len(sel)} | {n} | {og} ({100 * og / n:.0f} %) | {fg} | {t} ({100 * t / max(fg, 1):.0f} %) | {st.mean(b):+.1f} |")
    print()
    print("Measured ÷ forecast speed (best match), hours 07-17 UTC when the forecast says ≥ 10 kn, median; "
          "onshore = forecast direction within 60° of the beach's sea-facing side (buoys: all)\n")
    print("| Group | Pair | Onshore: ratio (hours) | Other directions: ratio (hours) |")
    print("|---|---|---|---|")
    pooled = {}
    for r in data:
        on, off = [], []
        for t in (x for d in r["days"] for x in d["fc_dir_obs_dir"]):
            fd, od, ok, fk = t
            if fk < 10 or fd is None:
                continue
            (on if r["facing"] is None or angle(fd, r["facing"]) < 60 else off).append(ok / fk)
        g = group(r["pair"])
        pooled.setdefault(g, ([], []))
        pooled[g][0].extend(on)
        pooled[g][1].extend(off)
        m = lambda v: f"{st.median(v):.2f} ({len(v)})" if v else "–"
        print(f"| {g} | {r['pair'].split('|')[0][:30]} | {m(on)} | {m(off)} |")
    for g, (on, off) in pooled.items():
        m = lambda v: f"{st.median(v):.2f} ({len(v)})" if v else "–"
        print(f"| **{g}, all** | | **{m(on)}** | **{m(off)}** |")
    print()
    print("Diurnal mean, measured / best match (kn), all days, 06-20 UTC\n")
    print("| Pair | " + " | ".join(f"{h:02d}" for h in range(6, 21)) + " |")
    print("|---|" + "---|" * 15)
    for r in data:
        if group(r["pair"]) in ("Catalonia", "Spain south", "Buoy POEM") or r["pair"].startswith("fr-le-grau"):
            po, pf = r["prof_o"], r["prof_f"]
            print(f"| {r['pair'].split('|')[0][3:24]} | " + " | ".join(
                f"{po[str(h)]:.0f}/{pf[str(h)]:.0f}" if po.get(str(h)) is not None and pf.get(str(h)) is not None else "–"
                for h in range(6, 21)) + " |")


if __name__ == "__main__":
    main()
