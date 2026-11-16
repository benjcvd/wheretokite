# Validation: Cotentin (Normandy west) (fr-cotentin, WHE-116)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only, at zoom 9 and 11);
pins come from OSM, never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-atlantic.csv`
shows only the 2025 audit, tier and ban-column commits). `TO_CONFIRM.md` only listed Collignon and Jullouville as
"weak pins" and Jonville / Réville as "left out as uncertain".

Sources are mostly school pages (Fifty Kite, Pôle Kitesurf Normandie, Pôle Nautique de la Hague), tourist offices and
spot guides (kite-and-windsurfing-guide.com, vvanat.fr). I found **no municipal order or préfecture text** for any
spot, so no `banned` rule is encoded.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Utah Beach | basic | fixed (pin, notes, tide) | Kite guide: 12 km of gently sloping sand, butter-flat in offshore wind, small waves onshore, stay at high tide because mussel and oyster beds show on the beach. Fifty Kite (Jullouville school): sends riders to the east coast (Quinéville-Ravenoville) in easterly wind, all tides. No school on the beach, no order found. **Pin** moved from a Nominatim query to the OSM beach `osm:w258074739`, faces ENE (57°), Apple Maps agrees. Old note "best at low to mid tide" contradicted the guide: tide set to `not-low`. Only two sources and a 2-star Windy marker: kept free as before, flagged for Ben. |
| Agon-Coutainville | basic | fixed (notes) | Pôle Kitesurf Normandie (mobile school, AFKite) uses the beach by the sailing school, all levels; plages.tv lists the beach by the sailing school as a kite zone; Club Nautique de Coutainville runs a travelling school. No order found. Pin: OSM beach `osm:w195421511`, faces W (262°), agrees. No tide dependence in the sources. |
| Gouville-sur-Mer | pro | fixed (pin, notes) | Pôle Kitesurf Normandie is based here; its page and a spot guide describe the beach opposite the campsite as open and shallow, good for beginners. The old pin was a Nominatim hit on the bathing cabins, and plages.tv says the Cabines de bains beach is reserved for oyster parks. **Pin** now the OSM beach `osm:w198334177` (552 m north), faces W (279°), agrees. |
| Jullouville | pro | fixed (notes) | Fifty Kite (school since 2014, Cale des Plaisanciers): W wind, Jullouville is the main spot at medium and big tides, Kairon-plage on small tides; wide open beach, flat shallow water. Granville-Terre-et-Mer tourist page repeats it. Pin: OSM node `osm:n14064270382`, faces W (275°), agrees. Tide `not-high` kept (no source disagrees, none gives hours). No order found. |
| Siouville-Hague | pro | fixed (notes) | Spot guide: best wave-riding spot in Normandy; Pôle Nautique de la Hague gives lessons here (Normandie Tourisme). Pin: OSM beach `osm:w210570710`, faces WNW (286°), agrees. Notes now say experienced riders. |
| Urville-Nacqueville | pro | fixed (notes) | Pôle Nautique de la Hague, the only kitesurf school of the Cotentin per Visit Cotentin, sits in the old fort here; lessons and kite rental (Normandie Tourisme). Pin: OSM beach `osm:w219863717`, faces NNE (21°), agrees. Notes were empty. |
| Cherbourg – Collignon | pro | fixed (notes) | Kite guide: flat inside the breakwater, W wind steadier inside the curve, strong NE thermal, avoid S (side-off), current at the river mouth, stones on the left at low tide. vvanat repeats "one of the flattest spots" behind the dyke. No school at the spot (the Tourlaville sailing school is on the same beach but lists no kite). Pin: OSM node `osm:n13289366918`, faces NNE (18°), agrees; the old "weak pin" worry is settled. Tide `high` kept. |

## Windy, both ways (browsed 2026-11-05, zoom 9 and 11 around 49.4 N, 1.6 W)

Windy → ours (north and west Cotentin, down to Jullouville, and the east coast to Utah; the Gefosse-Fontenay marker
next to Omaha belongs to the Calvados zone):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Nacqueville (3) | Urville-Nacqueville | matched |
| Le Becquet (4) | Cherbourg – Collignon | matched (same beach east of the breakwater, under 2 km) |
| Siouville (4) | Siouville-Hague | matched |
| Coutainville (2) | Agon-Coutainville | matched |
| Jullouville (4) | Jullouville | matched |
| Utah Beach (2) | Utah Beach | matched |
| Vauville (3) | none | **added (Pro)**: kite guide (S / NW / NE thermal, shorebreak at high tide) and Pôle Nautique de la Hague lessons. Pin OSM `osm:n1723311188`. |
| Biville (4) | none | **left out**: same dune bay as Vauville (1.1 km between the OSM beach points), same water and winds. Only a surf-style guide page (dune carry, rarely any kiters). |
| Sciotot (3) | none | **added (Pro)**: a regional sports article lists Sciotot among the best-known kite beaches of the Manche; the Vauville guide names it for SE wind. Pin OSM beach `osm:w100286484`. One-line sources, flagged in notes. |
| Barneville-Plage (4) | none | **added (Pro)** as `Barneville-Carteret`: kite guide (La Potière: NW cross-shore, rocks at low tide, current at breakwater) and the town's water-sports centre. Pin OSM beach `osm:w223989961`. |
| Anneville sur Mer (2) | none | **added (Pro)**: named as a lesson beach by Pôle Kitesurf Normandie. Pin OSM beach `osm:w202965913`. One school source. |
| Jonville (3) | none | **added (Pro)** as `Jonville (Réville)`: Barfleur tourist guide lists the beach for kitesurf. Pin OSM beach `osm:n13993449146` (Plage de la Vierge, Jonville), faces ESE. Weakest addition: one tourist source, no school, and the exact riding spot on the beach is not documented. Was in TO_CONFIRM "left out as uncertain"; the Windy rule overrides. |
| La Mondrée (2) | none | **left out**: kite guide describes an expert-only cross-shore spot with a right tide window, rocks, current toward cliffs; I found no OSM beach element for the place, so it cannot be pinned (rule: no element fits). |
| Barfleur (3) | none | **left out**: no kite source found at all (harbour town; OSM only returns capes and coves). Cannot be pinned on a beach. |
| Denneville (2) | none | **left out**: no kite source found (only walking and tourist beach pages). |
| Coudeville (1) | none | **left out**: 1-star marker, no kite source found. |

Ours → Windy: 6 of our 7 original spots have a marker. **Gouville-sur-Mer has none** (its nearest marker is Anneville, about 6 km north); it stays on the strength of the Pôle Kitesurf Normandie school being based there.

Counts: 16 Windy kite markers in or next to the zone; 6 matched to our original spots, 5 added as Pro, 5 left out.
Our spots in the zone: 7 → 12 (2 free, 10 Pro, 0 archived).

Gap: after the pass Windy still has 5 markers we don't show (Biville, La Mondrée, Barfleur, Denneville, Coudeville); Biville is the same bay as Vauville, and the others have no kite source or no pinnable beach. "No kite source found" is not one of the listed good reasons: Denneville, Coudeville and Barfleur are the calls to challenge if you want them in anyway.
