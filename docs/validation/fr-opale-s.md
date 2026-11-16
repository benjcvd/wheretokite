# Validation: Côte d'Opale south and Baie de Somme (fr-opale-s, WHE-118)

Done 5 Nov 2026. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. No decree or town-hall order for kiting was found for any of these beaches, so nothing is encoded in
`banned`: the summer rules are in the notes, with their source. Pins were not eyeballed on satellite (the build's
Apple Maps direction check agrees on all 11 spots). The build ran on the 11 rows of the zone: no PROBLEMS.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Le Touquet | basic | fixed (pin, notes) | Pin was a Nominatim town boundary; now the Le Touquet beach way (faces W, Apple Maps agrees). School Kitezone launches north of the seafront at the Saint-Jean 2 car park, advises S–W–N winds (kitezone.fr); Let's Kite and Unplug: big tide range, wide beach at low tide, summer bathing zone closed to board sports. Windy (5). "Aqualud" wording dropped (not in any source). |
| Hardelot | pro | fixed (notes) | Beach node kept (faces W). FFVL sheet 2003: take off south of the channel, no crossing of the channel in summer, rocks along it; Kiteforum: bathing zone closed to kites; Let's Kite: SW–W optimal, NE–E offshore. Schools KiteZone 62 (base Georges Pernoud), Shaka Kite School, Kitecamp62; hardelot.fr lists the spot. Windy (4). |
| Berck-sur-Mer | pro | fixed (notes) | Beach way kept (faces WNW). FFVL sheet 2260 (edited July 2025): summer kite zone of about 400 m between two flagged posts, other users have priority, SW–NW good, NE–SE bad, 300–400 m of sand at high tide; school Opale Kite since 2011. No decree cited. Windy (5). |
| Fort-Mahon-Plage | pro | fixed (notes) | Beach way kept (faces W). FFVL sheet 2215 and school page (MSKite, EFK): kite zone north of the nautical-base dike, WSW–NW, dunes accelerate, intermediate. Somme Tourisme lists it as one of the bay's three spots. Windy (4). |
| Le Crotoy | basic | fixed (pin, notes) | Pin was a street 80 m from the shore; now a beach way 9 m from the water (faces SW). Somme Tourisme: do not pass the yellow buoys, kiting banned in the Baie de Somme nature reserve; Akif and Glissevolution: tidal, only around high tide. Local schools are in Cayeux and use Le Crotoy at high tide. Not on Windy. |
| Cayeux-sur-Mer – La Mollière | pro | fixed (notes) | Pin kept (node "La Mollière", build moves it to the WNW shore, Apple Maps agrees); no beach element within 1.5 km. Town page and Somme Tourisme: schools Kitesurf Baie de Somme and Kite Passion; Univers Kite and Akif: about 2 h either side of low tide, pebbles at high tide; a summer closure in front of the chemin des planches entrance is mentioned by guides only. Windy "Cayeux" (5). Note: Le Crotoy (high tide) and Cayeux (low tide) are complementary. |
| Le Portel | pro | fixed (notes) | Beach way kept (faces WNW). School APG on the beach (association-porteloise-de-glisse.com) and Let's Kite: tidal, best mid to high tide, flat in N–NE, choppy in strong SW next to the harbour, 60 m around Fort de l'Heurt and 100 m off Digue Carnot. Not on Windy (the Boulogne marker is the next one). Waves claim removed (not sourced). |
| Wimereux – Pointe aux Oies | pro | fixed (pin, notes) | Pin was a holiday cottage; now the OSM cape "Pointe aux Oies" (faces WNW). Wimkite names it, with Wissant, as the best spots of the coast; Let's Kite (two pages): SW–N via W, rocks, offshore NE–E dangerous, narrow beach at high tide. "No kiting before 19:00 in July–August" is on one guide only: notes. Windy "La Pointe aux Oies" (4). |

## Windy, both ways (browsed 2026-11-05, zoom 10 and 11 around 50.5 N, 1.6 E)

Windy → ours (14 markers in the zone box; Ambleteuse and Audresselles are inside it):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Hardelot (4) | Hardelot | matched |
| Le Touquet (5) | Le Touquet | matched |
| Berck (5) | Berck-sur-Mer | matched |
| Fort-Mahon (4) | Fort-Mahon-Plage | matched |
| Cayeux (5) | Cayeux-sur-Mer – La Mollière | matched |
| La Pointe aux Oies (4) | Wimereux – Pointe aux Oies | matched |
| Boulogne-sur-Mer (4) | **Boulogne-sur-Mer** | **added (Pro)**: Let's Kite page (advanced, SW–W), APG school runs sessions in the Boulogne bay, Wimkite lists "Boulogne (rade)"; OSM beach way, 3 km from Le Portel |
| Sainte-Cécile (3) | **Sainte-Cécile** | **added (Pro)**: Camiers – Sainte-Cécile tourist office "spot de glisse" page, Let's Kite page, Kitecamp62 blog; OSM beach way |
| Stella Plage (3) | **Stella-Plage** | **added (Pro)**: Kitecamp62 school based there, Let's Kite page, Opalenews directory; OSM beach way |
| Wimereux (5) | none | left out: the town beach is 1.4 km from our Pointe aux Oies pin (build limit 2 km, same shore); low-tide-only town beach is in the Pointe aux Oies note |
| Ambleteuse (3) | none | left out: Let's Kite calls the Pointe aux Oies "Ambleteuse"; the Ambleteuse beach is 1.6 km from our pin, same water and winds |
| Audresselles (2) | none | left out: one directory line ("occasional, by wind and tide", Wimkite); no kite beach to pin |
| Baie de la Canche (2) | none | left out: same water as Le Touquet (its note already covers the Canche bay in E winds); no separate launch named |
| Pointe du Hourdel (2) | none | left out: seal-colony point of the nature reserve where kiting is banned (Somme Tourisme); no local source names it as a launch |

Ours → Windy: Le Portel and Le Crotoy have no Windy marker. The other six have one.

Counts: 14 Windy markers, 6 matched, 3 added (Pro), 5 left out. Our spots in the zone: 8 → 11 (basic 2, pro 6 → 9, archived 0).

No big gap: the five left out are neighbours of spots we have or have no launch to pin.

## Open points

- Le Touquet pin: the beach way is south of the school's launch (about 3 km). It faces W like the north end; fine for the forecast, but the app will show the pin there.
- Cayeux – La Mollière: the pin is still a place node (no beach element found by Overpass); retry later.
- Berck, Le Touquet, Hardelot summer zones: FFVL and school pages only, no arrêté found; kept in notes.
