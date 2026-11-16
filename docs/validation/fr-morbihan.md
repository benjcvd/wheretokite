# Validation: South Brittany, Lorient to Quiberon (fr-morbihan, WHE-112)

Done 5 Nov 2026. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come
from OSM, never from Windy. Sources are mostly tourist offices, school pages and spot guides: no decree
or town-hall page could be found for the rules, so none is encoded in `banned`.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Gâvres | basic | fixed | Was pinned on a bus stop; now on the Grande Plage beach way next to the village (build: faces WSW, Apple Maps `uncertain` only because of the Petite Mer lagoon side). Lorient tourist office calls the Grande Plage one of the favourite kite spots of South Brittany; kite-and-windsurfing-guide lists La Caserne (W sideshore, best mid tide, shorebreak at high tide); You Kite school. Windy: La Caserne (4). Military zone and tide-dependent areas in notes (guide). Distance to Fort-Bloqué corrected to 11 km. |
| Penthièvre | basic | ok, notes updated | Windy marker (4). Rules from school and guide blogs (vvanat.fr, Carnac / Penthièvre pages): bay side kite ban 29 May–11 Sep, ocean side take-off and landing zones, ride 3 h either side of low tide. April 2026: the mayor of Saint-Pierre-Quiberon said she may ban kites on some beaches from this summer (ici.fr, 14 Apr): added to notes, no decree found. Not encoded in `banned` (no official text). |
| Fort-Bloqué | pro | fixed (pin) | Pin was on the naturist Kaolins beach 2 km from the main beach; moved to Pen er Malo, the beach with the car park and surf school (build: faces WSW). Lorient tourist office: kitesurf at Guidel "notably Fort-Bloqué"; surf-report.com: waves, crowded with kitesurfers. Windy (4). Unsourced "rocks mid-spot, mid to low tide" removed. |
| Erdeven – Kerhillio | basic (was pro) | fixed | Pin now the named beach node. Brittany tourism: kite zone in the south-east of the beach beyond the yellow buoys, marked all year; schools Rêve de Glisse (EFK) and You Kite; Windy (5), described as the reference spot of the area. Tide window kept (3 h either side of low). High-season zone (posts 27–28) and coefficient > 85 rule are from a school blog, kept in notes. Made free because it is the reference spot: your call to reverse. |
| Plouharnel – Les Sables Blancs | pro | fixed (pin) | Was pinned on a railway halt; now the "Plage des Sables Blancs" beach on the bay side (faces ESE). Kite-and-windsurfing-guide: Quiberon Bay's only unrestricted kite venue, wide beach, oyster beds at La Piscine; NKS school at Plouharnel, Eko Kite lists it. Not on Windy under this name. |
| Sarzeau – Penvins | basic (was pro) | fixed | Sources agree it is the reference spot of the Morbihan: Kitesurf KKS, Eko Kite and Kite2Rhuys schools, labelled FFVL; Windy "Pointe de Penvins" (5). Tide `not-low` removed (sources disagree, see TO_CONFIRM); offshore W–NW winds and Vilaine currents added to notes. Made free: your call to reverse. |

## Windy, both ways (browsed 2026-11-05, zoom 10 and 12 around 47.6 N, 3.2 W)

Windy → ours (24 markers in the zone; Pont Mahé and Sorlock are in Loire-Atlantique, zone fr-loire, not counted):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Fort Bloque (4) | Fort-Bloqué | matched |
| La Caserne (4) | Gâvres | matched |
| Kerhillio (5) | Erdeven – Kerhillio | matched |
| Penthievre (4) | Penthièvre | matched |
| Pointe de Penvins (5) | Sarzeau – Penvins | matched |
| Kerguelen (5) | **Larmor-Plage – Kerguelen** | **added (Pro)**: Lorient tourist office (kite photo, page of Larmor-Plage), kite guide lists it |
| Le Linnes (3) | **Gâvres – Le Linès** | **added (Pro)**: kite guide lists "Le Linès, Gâvres" |
| Mendu (3) | **La Trinité-sur-Mer – Men Du** | **added (Pro)**: kite guide + two guides; schools teach here in summer |
| Larmor Plage (4) | none | left out: same shore as Kerguelen (1.3 km) |
| Guidel Plage (5) | none | left out: tourist office names only Fort-Bloqué for Guidel; Plage du Loc'h is 1.7 km from our Pen er Malo pin, no Lannénec in OSM |
| Le Chel (4) | none | left out: no local source, no OSM place found |
| Carnac Plage (5) | none | left out: 1.6 km from Men Du (build limit); summer kite ban in Carnac per guides |
| Légénèse (5) | none | left out: Carnac, 1.9 km from Les Sables Blancs (build limit); summer ban |
| Sainte-Barbe (5) | none | left out: 1.8 km from Kerhillio, same beach |
| Les Crevettes (5) | none | left out: same beach as Mané Guen / Sainte-Barbe (< 2 km) |
| Mane Gwen (4) | none | left out: 1.9 km from Les Sables Blancs (build limit, but ocean side). Needs a rule call, see TO_CONFIRM |
| Port d'Orange (4) | none | left out: same bay shore as Penthièvre (0.6 km) |
| Baie de Quiberon (4) | none | left out: no named beach (Happy Kite School launches from Port Haliguen harbour); nothing to pin |
| Saint-Pierre, Locmariaquer (3) | none | left out: no local source found |
| Golfe du Morbihan (3), Île d'Arz (4) | none | left out: no local source beyond one blog line; island access (worst case) |
| Plage des Govelins (3), Le Roaliguen (2) | none | left out: no local source found (worst case) |
| Damgan (5) | none | left out: only one guide, no beach named; cannot be pinned |

Ours → Windy: Fort-Bloqué, Gâvres (La Caserne), Kerhillio, Penthièvre, Penvins have a marker. Les Sables Blancs has no marker of its own.

Counts: 24 Windy markers, 5 matched, 3 added (Pro), 16 left out. Our spots in the zone: 6 → 9 (basic 2 → 4, pro 4 → 5, archived 0).

Big gap: Windy has 24 markers against our 9. The main reasons are the 2 km build rule (the Plouharnel / Carnac / Quiberon coast has a marker every 1–2 km), the Carnac summer ban, and Golfe du Morbihan / Rhuys markers with no local source.
