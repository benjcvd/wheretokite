# Validation: Montpellier coast to L'Espiguette (fr-montpellier, WHE-97)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-mediterranean.csv` shows only the
tier / ban column changes); `TO_CONFIRM.md` only listed the Carnon and L'Espiguette weak pins.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Carnon – Petit Travers | basic | fixed | Real and famous: Mauguio-Carnon town page and tourist office describe one kite zone at access points 73 and 74 ("labellisée et homologuée" by the sailing federation), FFVL practice-site sheet no. 2277 (zone of 200 m with two 50 m buffers, summer channel), schools Axel'Air, Monki, Ride Academy (kitesurfmontpellier.com), spot guides (Let's Kite). **Pin moved** from a bus-stop node (1.2 km west of the zone) to the OSM `sport=kitesurfing` area "Zone de Kite Surf" (`osm:w1072067254`, between entrances 73 and 74). Direction: build says SSE (157°), agrees with the hint. Sector: S–SW thermal and SE marin, tramontane/mistral offshore (FFVL, Monki, Let's Kite). Notes rewritten (level, shallow water, dune posts). Roquilles closure is only in Monki's guide, so it stays in notes, no ban encoded. |
| La Grande-Motte | pro | fixed (notes) | Town page lagrandemotte.com/les-plages: marked kite area at the Couchant beach; schools' guides (Monki, Universkite, Zoomkite) agree: port-side zone, SE best, summer channel along the jetty, intermediate. Zoomkite also links the 2014 town order n°156 (two zones, active with S/SE wind above force 5). I could not confirm that order is still in force, so no ban or hours encoded. Pin: OSM beach "Couchant" (`osm:r5342689`, 23 m from the water), next to the port. Direction S (185°), agrees. Notes rewritten; the old "two zones" text now lives in the new Grand Travers row. |
| Le Grau-du-Roi – L'Espiguette | basic | ok (notes rewritten) | Schools on the beach: Club 30 Kite, Hibiskite, OKLM School (letsgrau.com town tourist office; campingespiguette.fr; school pages); Monki guide gives S, SE, SW and NW. Students are taken by boat (15 min); summer kite zone marked with yellow buoys. Pin: OSM node of the beach restaurant at the main car park, 43 m from the water. Kept: the OSM beach polygons here are long relations whose centres fall 1.5 km away, the restaurant is the main access where everyone lands. Direction SSW (203°), agrees. |
| Le Grau-du-Roi – Le Boucanet | pro | ok (notes rewritten) | Universkite spot sheet and Let's Kite: W / NW wave spot of the bay, evening shadow behind buildings; tourist office lists it for kitesurf. Both guides say closed 1 Jun–15 Sep but quote different decrees (90-2015 vs 051/2018) and I found no town or préfecture page: **not encoded as a ban**, worded in notes ("check the town hall"). Pin: OSM beach "Plage du Boucanet" (`osm:w66097905`), a 3 km strip: the centre is on the sand, 600 m west of the access the guides give. Same forecast. Direction SW (215°), agrees. |
| Port-Camargue – Plage Sud | pro | ok (notes rewritten) | Monki guide (NW best, W onshore, N side-shore, experienced), town tourist office (hard to get past the jetties, schools use Plage Sud), Let's Kite, Bob Kite School. Pin: OSM beach "Port Camargue Plage Sud" (`osm:w66033678`). Direction W (270°), agrees; the build flags an irregular shoreline, the beach faces W behind the jetties. No ban found. |
| Villeneuve-lès-Maguelone – Maguelone | pro | ok (notes rewritten) | Universkite (official kite zone between the cathedral and the Prévost car park), FFVL practice-site sheet no. 2261 (channel June–September), KWM club (secures the zone), Monki ("only spot authorised in summer"), GlissEvolution (Prévost beach closed April–September, refers to town order n°162, not seen). Pin: OSM way "Plage de Maguelone" (`osm:w389802445`). Direction SE (143°), agrees. No official text found, so no ban encoded. Sector SW and NW per Monki; NW (tramontane) offshore, safety boat. |

## Windy, both ways (browsed 2026-11-05, zoom 11 around 43.54 N, 4.05 E)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Plage de Maguelone (4) | Maguelone | matched |
| Palavas-les-Flots (5) | none | **left out** (reason 3, not a kite spot): Let's Kite says there is no kite zone on Palavas beach itself; Palavas schools (L'Effet Kiteschool, Monki) boat their students to Petit Travers or Maguelone. The Prévost beach on Palavas's edge is the Maguelone spot. |
| Le Grand Travers (3) | none | **added (Pro)** `La Grande-Motte – Grand Travers`, OSM beach `osm:w26478845`: second zone of the town order (access 59–60), Universkite, Monki, Zoomkite and Toploc agree. Between Petit Travers and the port; the 2 km "same beach" reason was judged not to apply (separate official zone, ~2 km from both neighbours). |
| Étang de l'Or (1) | none | **left out** (reason 3): Hérault windsurf guide says the lagoon is unsuitable for kitesurf; tourist office promotes the sea spot at Carnon instead; lowest rating on the map. |
| La Grande Motte (5) | La Grande-Motte | matched |
| Étang du Ponant (5) | none | **left out** (reasons 3 and 4): GlissEvolution lists the lagoon for windsurf, wing, catamaran and SUP only, run from the Windsurf Park base; an older Hérault guide says no kitesurf; two school listings mention kite but are unclear. Protected lagoon, and no OSM beach or kite feature to pin (only the water body). Worst case applied. |
| Le Boucanet (5) | Boucanet | matched |
| Port Camargue (5) | Plage Sud | matched |
| L'Espiguette (5) | L'Espiguette | matched |
| *(no marker)* | Carnon – Petit Travers | Windy has no marker named Petit Travers; its "Le Grand Travers" pin sits between Petit Travers and the port. Our spot is sourced independently (FFVL, town hall, schools). |

Ours → Windy: Maguelone, La Grande-Motte, Boucanet, Port-Camargue, L'Espiguette have a marker; Carnon – Petit Travers has none under that name.

Counts: 9 Windy markers in the zone (Palavas included, it falls inside the box), 5 matched, 1 added (Pro), 3 left out.
Our spots in the zone: 6 → 7 (2 free, 5 Pro, 0 archived).
Gap: none worth a line; the three left out are a lagoon, a windsurf pond and a town beach with no kite zone.
