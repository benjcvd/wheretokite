#!/usr/bin/env python3
"""Build docs/validation_map.html: where the France + Spain spot validation stands.

Reads Data/spots.json, tools/spots/validation/zones.json and status.csv (and, if present,
.atlas/board.json to show card codes). Usage: python3 tools/validation_map.py
"""
import csv
import json
import sys
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VAL = ROOT / "tools/spots/validation"
OUT = ROOT / "docs/validation_map.html"

COLORS = {"validated": "#1a9e55", "review": "#2f7fd8", "doing": "#e8a317",
          "waiting": "#d6453d", "todo": "#9aa0a6"}
LABELS = {"validated": "Validated", "review": "Ready to merge", "doing": "In progress",
          "waiting": "Waiting on you", "todo": "Not started"}


def zone_of(spot, zones):
    for z in zones:
        if spot.get("region") not in z["regions"]:
            continue
        box = z.get("box")
        if box and not (box[0] <= spot["latitude"] < box[1] and box[2] <= spot["longitude"] < box[3]):
            continue
        return z["id"]
    return None


def hull(points):
    pts = sorted(set(points))
    if len(pts) <= 2:
        return pts
    def cross(o, a, b):
        return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
    lower, upper = [], []
    for p in pts:
        while len(lower) >= 2 and cross(lower[-2], lower[-1], p) <= 0:
            lower.pop()
        lower.append(p)
    for p in reversed(pts):
        while len(upper) >= 2 and cross(upper[-2], upper[-1], p) <= 0:
            upper.pop()
        upper.append(p)
    return lower[:-1] + upper[:-1]


def main():
    data = json.loads((ROOT / "Data/spots.json").read_text())
    spots = data if isinstance(data, list) else data["spots"]
    zones = json.loads((VAL / "zones.json").read_text())["zones"]
    status = {r["zone"]: r for r in csv.DictReader((VAL / "status.csv").open())}
    codes = {}
    board = ROOT / ".atlas/board.json"
    if board.exists():
        for c in json.loads(board.read_text()).get("cards", []):
            codes[c["id"]] = c.get("code", c["id"])

    fr_es = [s for s in spots if s.get("country") in ("FR", "ES")]
    unassigned = []
    by_zone = {z["id"]: [] for z in zones}
    for s in fr_es:
        zid = zone_of(s, zones)
        if zid:
            by_zone[zid].append(s)
        else:
            unassigned.append(s)

    out_zones = []
    for z in zones:
        st = status.get(z["id"], {})
        ss = by_zone[z["id"]]
        card = " ".join(codes.get(c, c) for c in (st.get("card") or "").split())
        out_zones.append({
            "id": z["id"], "country": z["country"], "name": z["name"],
            "status": st.get("status") or "todo", "card": card,
            "report": st.get("report") or "", "updated": st.get("updated") or "",
            "windy": f'{st["windy_matched"]}/{st["windy_markers"]}' if st.get("windy_markers") else "",
            "added": st.get("added") or "", "archived": st.get("archived") or "",
            "hull": [[round(a, 4), round(b, 4)] for a, b in hull([(s["latitude"], s["longitude"]) for s in ss])],
            "spots": [{"n": s["name"], "la": s["latitude"], "lo": s["longitude"]} for s in sorted(ss, key=lambda s: s["name"])],
        })

    n_val = sum(z["status"] == "validated" for z in out_zones)
    n_spots_val = sum(len(z["spots"]) for z in out_zones if z["status"] == "validated")
    payload = {"zones": out_zones, "colors": COLORS, "labels": LABELS,
               "unassigned": [s["name"] for s in unassigned],
               "summary": {"zones": len(out_zones), "zonesValidated": n_val,
                           "spots": len(fr_es) - len(unassigned), "spotsValidated": n_spots_val},
               "built": date.today().isoformat()}
    OUT.write_text(TEMPLATE.replace("__DATA__", json.dumps(payload, ensure_ascii=False)))
    print(f"{OUT.relative_to(ROOT)}: {n_val}/{len(out_zones)} zones validated, "
          f"{n_spots_val}/{len(fr_es) - len(unassigned)} spots")
    if unassigned:
        print("Spots in no zone (add them to zones.json):", ", ".join(s["name"] for s in unassigned))
        sys.exit(1)


TEMPLATE = """<!doctype html><html><head><meta charset="utf-8">
<title>WhereToKite – France and Spain validation</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<style>
body{margin:0;font:14px -apple-system,system-ui,sans-serif;display:flex;height:100vh;color:#222}
#side{width:380px;overflow:auto;border-right:1px solid #ddd}#map{flex:1}
h1{font-size:17px;margin:14px 14px 4px}.sum{margin:0 14px 10px;color:#555}
.bar{height:10px;background:#eee;border-radius:5px;margin:6px 14px 12px;overflow:hidden;display:flex}
.bar span{display:block;height:100%}
.leg{margin:0 14px 10px;font-size:12px;color:#555}.leg i{display:inline-block;width:10px;height:10px;border-radius:2px;margin:0 4px 0 10px}
h2{font-size:13px;text-transform:uppercase;letter-spacing:.05em;color:#777;margin:14px 14px 4px}
.z{padding:8px 14px;border-bottom:1px solid #f0f0f0;cursor:pointer}.z:hover{background:#f4f7fb}
.z .n{font-weight:600}.z .m{font-size:12px;color:#666;margin-top:2px}
.pill{display:inline-block;font-size:11px;padding:1px 7px;border-radius:9px;color:#fff;margin-right:6px}
.warn{margin:10px 14px;color:#b3261e;font-size:12px}
</style></head><body>
<div id="side"><h1>France and Spain spot validation</h1><div class="sum" id="sum"></div>
<div class="bar" id="bar"></div><div class="leg" id="leg"></div><div id="list"></div></div>
<div id="map"></div>
<script>
const D=__DATA__;
const S=D.summary;
document.getElementById('sum').innerHTML=`<b>${S.zonesValidated} of ${S.zones} zones validated</b> · ${S.spotsValidated} of ${S.spots} spots · built ${D.built}`;
const order=['validated','review','doing','waiting','todo'];
const count=s=>D.zones.filter(z=>z.status===s).length;
document.getElementById('bar').innerHTML=order.map(s=>`<span style="width:${100*count(s)/S.zones}%;background:${D.colors[s]}"></span>`).join('');
document.getElementById('leg').innerHTML=order.map(s=>`<i style="background:${D.colors[s]}"></i>${D.labels[s]} ${count(s)}`).join('');
const map=L.map('map').setView([42.5,-1.5],5);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:18,attribution:'© OpenStreetMap'}).addTo(map);
const layers={};
function info(z){
  const bits=[`<span class="pill" style="background:${D.colors[z.status]}">${D.labels[z.status]}</span>${z.spots.length} spots`];
  if(z.card) bits.push(z.card);
  if(z.windy) bits.push('Windy '+z.windy);
  if(z.added) bits.push('+'+z.added+' added');
  if(z.archived) bits.push(z.archived+' archived');
  if(z.updated) bits.push(z.updated);
  return bits.join(' · ');
}
for(const z of D.zones){
  const c=D.colors[z.status];const g=L.featureGroup();
  if(z.hull.length>=3) L.polygon(z.hull,{color:c,weight:2,fillOpacity:.15}).addTo(g);
  for(const s of z.spots) L.circleMarker([s.la,s.lo],{radius:5,color:c,fillColor:c,fillOpacity:.9,weight:1}).bindTooltip(s.n).addTo(g);
  const rep=z.report?`<br><a href="../${z.report}">Report</a>`:'';
  g.bindPopup(`<b>${z.name}</b><br>${info(z)}${rep}<br><small>${z.spots.map(s=>s.n).join(', ')}</small>`);
  g.addTo(map);layers[z.id]=g;
}
let html='';
for(const [cc,label] of [['ES','Spain'],['FR','France']]){
  const zs=D.zones.filter(z=>z.country===cc);
  html+=`<h2>${label} · ${zs.filter(z=>z.status==='validated').length}/${zs.length}</h2>`;
  for(const z of zs) html+=`<div class="z" data-id="${z.id}"><div class="n">${z.name}</div><div class="m">${info(z)}</div></div>`;
}
if(D.unassigned.length) html+=`<div class="warn">Spots in no zone: ${D.unassigned.join(', ')}</div>`;
const list=document.getElementById('list');list.innerHTML=html;
list.onclick=e=>{const el=e.target.closest('.z');if(!el)return;const g=layers[el.dataset.id];map.fitBounds(g.getBounds().pad(.3));g.openPopup();};
</script></body></html>
"""

if __name__ == "__main__":
    main()
