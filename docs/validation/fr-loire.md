# Validation: Pays de la Loire and Vendée (fr-loire, WHE-111)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-atlantic.csv` shows only the 2025
audit, tier and ban-column commits); `TO_CONFIRM.md` only had "La Baule: main launch at Plage Benoît or nearer the
Pouliguen étier?".

Sources are mostly tourist offices, school pages and spot guides (vvanat.fr, kite-and-windsurfing-guide.com,
unplug-kitesurf.com, guide-de-la-vendee.com, atlantic-loire-valley.com). The only official text I could read is the
**Pornichet town hall order ARR2026-212** (ville-pornichet.fr, signed 22 May 2026, in force from 15 June 2026). The La
Baule 2016 order on labaule.fr returned a 404, so La Baule is judged from the Pornichet order (the K13 channel is shared
by the two towns) plus guides. No other order was found, so no new `banned` rule is encoded.

Duplicate rule used (Lead, main fb58a7b): same water and under 1 km and same facing = one spot; otherwise kept.

## Our 8 spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Assérac – Pont-Mahé | basic | ok (notes) | vvanat Pont-Mahé guides, labaule-guerande.com tourist office, Plaisir Kite & Wingfoil school (atlantic-loire-valley.com): SW to W wind, shallow bay, stand almost everywhere, school on site, yellow-buoy swimmer zone, dries at low tide and tight at high tide. Pin: OSM beach (`osm:w467953849`), SW, Apple Maps agrees. Notes rewritten, wrong "Pen Bron 8 km south" line removed. Windy: Pont Mahé 5 stars. |
| La Baule | basic | fixed (pin, notes) | **Pin was a beach-club playground** (Nominatim). Now the OSM beach relation (`osm:r2899419`). Pornichet order ARR2026-212 (official): from 15 June kiting only beyond the 300 m strip and only through the K13 channel while buoyed, experienced riders only, schools forbidden, lifeguards open it (wind above 6 kn, wet sand); free outside the buoyed period. Existing `06-15..09-15` ban kept (careful side: K13 is not a launch from the beach). Plage Benoît: flat banks at low to mid tide, W to SE wind (rideevolve guide). TO_CONFIRM question closed: Plage Benoît stays. Windy: La Baule 5 stars. |
| Notre-Dame-de-Monts | basic | **archived** | No kite school, club or guide names this beach: the vvanat area guide lists Fromentine, Le Gois, Barbâtre, Les Sableaux, not Notre-Dame-de-Monts itself, and Windy has no marker there. It is the same long ocean beach as Fromentine, 4 km south. Pin was also a Nominatim guess. Archived, easy to revive. |
| La Tranche-sur-Mer | basic | ok (notes) | vvanat (two pages), kite-and-windsurfing-guide, guide-de-la-vendee: Plage du Phare, waves, wind and current, good level; May to September the only beach where kiting is allowed, off season everywhere except Belle Henriette (guides only, no order found, so notes). Pin: OSM `osm:w107576526` "Le Phare", SW, agrees. Windy: Le Phare 3 stars. |
| La Turballe – Pen Bron | pro | fixed (notes) | kite-and-windsurfing-guide: ocean side between La Turballe and Pointe de Pen Bron, freeride and bump-and-jump, strong shore break at high tide; vvanat Batz guide: kiting strictly banned in summer at La Turballe (blog only, no order). Not a wave spot as the old note said. Conservatoire du littoral / Natura 2000, naturist beach (pin is on it). No school. Kept Pro. Windy: "Plage de Guérande" 2 stars, the nearest marker, about 1 km east: matched with doubt. |
| Saint-Brevin-les-Pins | pro | fixed (notes) | Saint-Brevin and Pornichet tourist pages, vvanat: Rochelets is the official spot, open all year; schools H2AIR (Pointeau), Kite A.Traction (Ermitage), Line Up (Val d'Or). Old note said schools at "Plage du Billard": not found, dropped. Summer rule: guides disagree (one says 15 May to 15 June, no order), notes say check the town hall. Pin OSM beach `osm:w301713272`, SW, agrees. Windy: Saint-Brevin-les-Pins 5 stars. |
| Fromentine | pro | fixed (notes) | vvanat Notre-Dame-de-Monts area guide and kite-and-windsurfing-guide: La Grande Côte, ocean side, shallow lagoons about 1 m, no rocks, N to SE wind at low tide ±2 h, shore break at high tide; port exit channel off limits (ferries); Fromentine Kite school (paysdesaintjeandemonts.fr). **The old note said "flat channel facing Noirmoutier"**: that is Le Gois, not this pin. Pin stays on the Grande Côte beach (`osm:r2982134`, W, agrees). 15 May to 15 Sept ban in guides only, notes. Tide `not-high` kept. Windy: Pointe de la Fosse 4 stars (matched, 700 m). |
| Bretignolles-sur-Mer | pro | ok (notes) | plages.tv, vvanat, Bréti-Kiteschool listing (parcsetloisirs.fr): kite zone south of Plage des Dunes, near the Dunes 2 lifeguard post, buoyed in July and August; learning area for the school. Pin: OSM kitesurfing node on the club (`osm:n13123697769`), WSW, agrees. No Windy marker on this beach (La Sauzaie 3.5 km north is a different, surf-led beach). Not on Windy. |

## Windy, both ways (browsed 2026-11-05, zoom 10 to 11, La Bernerie to La Tranche and Île d'Yeu)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Pont Mahé (5) | Assérac – Pont-Mahé | matched |
| La Baule (5) | La Baule | matched |
| Plage de Guérande (2) | La Turballe – Pen Bron | matched with doubt (1 km) |
| Saint-Brevin-les-Pins (5) | Saint-Brevin-les-Pins | matched |
| Pointe de la Fosse (4) | Fromentine | matched |
| Le Phare (3) | La Tranche-sur-Mer | matched |
| Pornichet (5) | none | **added (Pro)** `Pornichet`: official town order, school H2AIR; pin OSM beach Plage des Libraires. 3 km from La Baule, different beach. Same K13 summer rule, ban encoded. |
| Sorlock (4) | none | **added (Pro)** `Mesquer – Sorlock`: one guide only, no school; notes tell riders to check the wind direction. |
| Le Pointeau (4) | none | **added (Pro)** `Saint-Brevin – Le Pointeau`: tourist office, H2AIR on site, flat lagoon. 1.9 km from Rochelets. |
| Tharon (4) | none | **added (Pro)** `Saint-Michel-Chef-Chef – Tharon`: Glisse Academy has a reserved zone. Thin: one source. |
| La Bernerie (4, name cut off) | none | **added (Pro)** `La Bernerie-en-Retz – Grande Plage`: beach directory kite zone plus tourist pages, two schools. |
| Saint-Jean-de-Monts (3) | none | **added (Pro)** `Saint-Jean-de-Monts – Estacade`: base nautique teaches kitesurf with a supervised zone. One source. |
| Saint Gilles-Croix-de-Vie (5) | none | **added (Pro)** `Saint-Hilaire-de-Riez – Les Becs`: tourist office kite zone Salins–Becs, Saint Gilles Kite School; pin OSM `sport=kitesurfing` node. The marker sits on this coast north of Saint-Gilles, I read it as the same spot. |
| Les Sables d'Olonne (5) | none | **added (Pro)** `Les Sables-d'Olonne – Grande Plage`: Ocean Players school, guide. |
| Le Veillon (4) | none | **added (Pro)** `Le Veillon`: vvanat and unplug-kitesurf, school on the estuary side; pin the OSM school/kite node. |
| Barbâtre (4) | none | **left out**: guides and the Mouv'n Kite school page give no beach name for the launch, so no OSM element can be chosen. Revive if a school page names the beach. |
| Kerlédé (3), Les Dunes (3) | none | **left out**: no kite source found at all (urban Saint-Nazaire shore, Saint-Brevin / Saint-Michel coast). |
| La Govelle (1), La Luzéronde (2), Petite Conche (2, Île d'Yeu), La Maison Clémenceau (2) | none | **left out**: no kite source found (vvanat Batz and Jard pages do not mention them). |
| La Sauzaie (3), Plage de Sauveterre (3), Les Conches (4) | none | **left out**: only surf schools and surf guides name them (vvanat lists La Sauzaie among sand and wind spots without detail). |
| Les Générelles (5) | none | **left out**: no source describes it as a kite spot; in summer La Tranche allows kiting only at the Phare. |
| La Belle Henriette (1) | none | **left out**: guides say kitesurf is forbidden there. |

Ours → Windy: 6 of our 8 have a marker; Bretignolles has none (La Sauzaie is elsewhere); Notre-Dame-de-Monts has none.

Counts: 27 Windy kite markers browsed (Damgan on the Morbihan side not counted); 6 matched to our original spots, 9 added as Pro, 12 left out.
Our spots in the zone: 8 → 17 (3 free, 13 Pro, 1 archived; before: 4 free, 4 Pro).

Gap, in one line: Windy has 12 markers we left out because the Vendée coast between Saint-Gilles and La Tranche is a surf coast where the markers are mostly surf beaches with no kite source (plus Kerlédé, Barbâtre and Générelles, which have no usable source or beach name).
