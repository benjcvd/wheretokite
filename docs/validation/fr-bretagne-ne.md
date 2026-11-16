# Validation: North-east Brittany, Plérin to Saint-Malo (fr-bretagne-ne, WHE-115)

Done 5 Nov 2026. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM
(Nominatim ids), never from Windy. No earlier validation of this zone (`git log` on `FR-atlantic.csv` shows only the
2025 audits). Sources are school and spot-guide pages (Emeraude Kite, Let's Kite, KiteCenter22, kiteloopers,
kite-and-windsurfing-guide) plus town-hall and tourism pages where they exist. Bans are encoded only where an official
page confirms them (Saint-Lunaire).

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Cherrueix | basic | ok, notes updated | Bay of Mont-Saint-Michel, known for land yachting (Char en Baie, ille-et-vilaine-tourisme.bzh); kite sources are thin: Kiteforum lists W, WNW, NW and NE winds, flat water, big tides; Breeza; Windy (2 stars). Pin is the beach street 15 m from the dike (no beach element exists; the sea faces N, matches hint). Apple Maps says `disagrees`: the bay dries out far from the dike, so the check is not reliable here. Tide `high` kept (water must cover the flats). Notes: W–NW and NE winds, shared with land yachts. |
| Hillion – Bon Abri | basic | ok, notes updated | Pin is the "Plage de Bon Abri" beach (faces N 15°, agrees). Let's Kite: N to NNW wind, mid to high tide, intermediate, borders the Baie de Saint-Brieuc nature reserve; tourism Bretagne and the reserve's own site confirm the reserve covers the Bon Abri dunes. No kite rule found in the reserve texts. Thin: one kite guide and no Windy marker of this name. Tide `not-low` kept. |
| Lancieux | basic | ok, notes updated | Pin on the bay beach (agrees, faces NNW). Emeraude Kite spot page and regulation page (updated 2021): Tête de Chien for W wind, Rougeret for N–NE, rocks, stay mid-bay; 1 Jul–31 Aug Saint-Sieu and Briantais beaches closed, launch at Tête de Chien or Roche Morin; Let's Kite (Lancieux, Briantais), Evoride school. Not encoded in `banned`: no town order found, sources differ on which beaches are closed. Windy: no marker named Lancieux (see Saint-Jacut). |
| Plérin – Les Rosaires | pro | ok, notes updated | Windy "Les Rosaires" (4). Let's Kite: 2 km sand facing NE, E and N winds (NE, ENE, NW also), gusty, choppy, intermediate, supervised swimming zone, strong tides; Kitesurf 22 school roams the bay by wind and tide; kiteloopers, kitetrip-planner. Direction agrees. No tide window encoded (sources give none). |
| Erquy – Caroual | pro | ok, notes updated | Windy "Caroual" (4). Pin on the Caroual beach (faces NW, agrees). Tourism Bretagne and Let's Kite: kite zone on the west half only, the village half is a supervised swimming area; KiteCenter22 and Centre Nautique d'Erquy teach here; WSW or more for steady wind, gusty at high tide (Pointe de Pléneuf). Erquy town page covers the bathing area; no kite decree found. |
| Sables-d'Or-les-Pins | pro | ok, notes updated | Pin on the beach (faces N, agrees). Let's Kite and sportihome list it; KiteCenter22 uses it as its NE-wind lesson spot; Emeraude Kite mentions the 300 m channel. NW wind is irregular, mid to low tide steadier. Windy has no marker for this beach (its "Cap Frehel" marker is on the Pléhérel side, see below). |
| Saint-Lunaire – Longchamp | pro | ok, source added | Saint-Lunaire town hall ("Les plages" page): kitesurf banned on the four beaches 15 Jun–15 Sep, 10:00–20:00 (arrêté 81-2019 art. 5 per Emeraude Kite). Matches the `banned` rule already encoded. Windy "Longchamps" (4); Emeraude Kite spot page. |
| Saint-Malo – Le Sillon | pro | ok, notes updated | Windy "Les Sillons" (5). 2004 maritime-prefecture order (premar Atlantique, n° 2004/54) reserves a 300 m kite channel; Emeraude Kite: mandatory launch zone 1 Jul–1 Sep (300 m, between the Kyriad hotel and avenue Fuentès, flags); Glissevolution reads the city's beach rules (fiche 11) as a dedicated zone, not a seasonal ban; Let's Kite shows a 9–19 h July–August ban with no source: conflict. Not encoded (the worst case is only a launch zone). Tier left `pro`: your call to make it free given the 5 stars. |

## Windy, both ways (browsed 2026-11-05, zoom 10 around 48.55 N, 2.55 W)

Windy → ours (15 markers between Sillon du Talbert and Cherrueix; Mont-Saint-Michel is Normandy, not counted):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Les Rosaires (4) | Plérin – Les Rosaires | matched |
| Caroual (4) | Erquy – Caroual | matched |
| Longchamps (4) | Saint-Lunaire – Longchamp | matched |
| Les Sillons (5) | Saint-Malo – Le Sillon | matched |
| Cherrueix (2) | Cherrueix | matched |
| Saint-Cast (4) | **Saint-Cast – Grande Plage** | **added (Pro)**: Emeraude Kite, Let's Kite, kite-and-windsurfing-guide, KiteCenter22 |
| Saint-Jacut (4) | **Saint-Jacut – Le Rougeret** | **added (Pro)**: Emeraude Kite, Let's Kite "Baie de Lancieux – Saint-Jacut"; 2.3 km from Lancieux's pin |
| Les Godelins (3) | **Étables – Les Godelins** | **added (Pro)**: sportihome, unplug-kitesurf, local blog, O-Rider'School |
| Le Prat (3) | none | left out: no OSM beach for Le Prat (a locality node only); the neighbouring Val-André beach is banned in summer per a 2026 town order reported by a guide; can't be pinned |
| Cap Frehel (4) | none | left out: sits on the Pléhérel side; no local kite source found, nothing to pin (worst case) |
| Binic (4) | none | left out: no separate local source found (O-Rider'School works Binic-Étables, same bay as Godelins, 3 km) |
| Béliard (2) | none | left out: no OSM element and no source found |
| Hirel (1) | none | left out: 1 star; only a 2019 forum post and a spot site; no OSM beach found to pin (5 km from Cherrueix) |
| Bréhec (3), Sillon du Talbert (2) | none | left out: Trégor coast far west of this zone's spots; not researched (search budget) |

Ours → Windy: Plérin, Erquy, Saint-Lunaire, Saint-Malo, Cherrueix have a marker. Not on Windy under their name: Hillion – Bon Abri, Lancieux, Sables-d'Or-les-Pins (Béliard may be next to Hillion, unconfirmed).

Counts: 15 Windy markers (Mont-Saint-Michel excluded), 5 matched, 3 added (Pro), 7 left out. Our spots in the zone: 8 → 11 (basic 3 → 3, pro 5 → 8, archived 0).

Gap: Windy shows 15 markers against our 11 spots. The 4 not covered are Le Prat, Cap Fréhel, Binic (worth a second pass) and the tiny Béliard / Hirel / Bréhec / Talbert group (unpinnable or unsourced).
