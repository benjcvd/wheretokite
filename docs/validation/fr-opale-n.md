# Validation: Côte d'Opale north, Wissant to Dunkerque (fr-opale-n, WHE-119)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-atlantic.csv`: 2025 audit, "famous
spots only" trim, tier and ban columns). `TO_CONFIRM.md` only had the weak Hemmes de Marck pin and "Dunkerque Digue
du Break" left out as uncertain.

Overpass was down all session, so `osm_lookup near` failed; new pins use Nominatim ids and the OSM API (`api.openstreetmap.org`)
for checks. Sources are mostly spot guides, school pages and tourist pages: vvanat.fr (Nord-Pas-de-Calais, Dunkerque Malo,
Hemmes de Marck pages), kite-and-windsurfing-guide, kiteforum spot pages, Manawa (Wissant school), plages.tv, surf-report.com.
One official text found: the **Gravelines mayor's order 2024TEMP011** (Petit-Fort-Philippe beach rules). No prefectoral
or maritime order text was found for Dunkerque, so no `banned` rule is encoded anywhere in the zone (and none of these
rules is a year-round ban).

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Wissant | basic | fixed (notes) | Manawa kite school at Wissant, Bed&Kite (Pointe aux Oies), vvanat Nord-Pas-de-Calais, wannakitesurf, kite-and-windsurfing-guide: often strong wind, waves, confirmed riders; wide at low tide, more swell at high tide; sea-wall rocks and currents; SW wind allows a downwind to Sangatte. Pin: OSM beach `osm:w106357501`, NW (316°), Apple agrees. No tide rule (works at both tides, character changes). No order found. |
| Sangatte | pro | fixed (notes) | vvanat: very strong wind, often over 40 kn, breakwaters on the beach; 2capskite school on site (Calais guide). Pin `osm:r12146698`, NW, agrees. Notes: confirmed riders, groynes. |
| Calais – Blériot-Plage | pro | fixed (notes), flagged thin | kite-and-windsurfing-guide: decent freeride in west wind at low tide, top wave spot in NE storms, busy swimming zone in summer, launch near the jetty; wildopenwater lists kiteboarding at Calais beach. No school or club found there; Windy 2 stars. Kept Pro, not promoted. Pin `osm:w35894485`, NNW, agrees. Notes rewritten. |
| Les Hemmes de Marck | basic | ok (flagged pin) | vvanat has a page on it (quiet, freeride and beginners, next to the Platier d'Oye reserve); plages.tv tags the Huchette beach as a kite zone but mainly char à voile; Windy 3 stars. Pin is still the hamlet node `osm:n7141980706` snapped to the shore (30 m); the only beach feature nearby is the sand-yacht base polygon (`w883839533`, tried: Apple check worse, "1% water", reverted). Build faces N (357°), Apple says 271°: the coast runs ENE here and Calais harbour jetties confuse Apple, so I trust OSM, but it stays flagged. No order found. |
| Gravelines – Petit-Fort-Philippe | pro | fixed (notes, rule) | **Official**: mayor's order 2024TEMP011 art. 7: kitesurfs banned in the bathing and supervised zone; outside it only from 100 m east of the zone; lifeguards 1 Jul–1 Sep 2024, 10:30–18:30. Not a ban of the spot, so in `notes`, not `banned`. vvanat: "pied presque partout", beginner-friendly; surf-report names it one of the two known kite spots of the coast; plages.tv: north beach reserved for sand yachts and kites. Pin `osm:w610168882`, 334°; Apple says 299° (uncertain, the Aa channel jetty sits next to the beach), kept. |
| Malo-les-Bains (Dunkerque) | basic | fixed (notes) | Dunkerque Flysurfing Club; vvanat Malo: open to many winds, short chop in strong wind, south wind offshore and irregular, shared with wingers and sand yachts, wide flats at low tide. Local guide: 1 Jul–31 Aug kite zone limited to 500 m west of the Terminus post (prefect's order, **text not found**), dune zone east open all year. Notes only. Pin `osm:w520745148`, N, agrees. |
| Bray-Dunes | pro | ok (notes) | vvanat: quiet, regular wind, NW most common; kiteforum spot page. Tourist guide lists "high season" beach restrictions, unclear if kites: notes say check. Pin `osm:r10626833`, N, agrees. |
| Leffrinckoucke | pro | **added** | See Windy table. |
| Zuydcoote | pro | **added** | See Windy table. |

Distances: Malo → Leffrinckoucke 3.6 km, Leffrinckoucke → Zuydcoote 3.1 km, Zuydcoote → Bray-Dunes 2.7 km: one continuous
dune beach, but over 2 km apart, so each kept as its own Pro spot.

## Windy, both ways (browsed 2026-11-05, zoom 10 around 51.0 N, 2.0 E)

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Wissant (5) | Wissant | matched |
| Sangatte (5) | Sangatte | matched |
| Blériot Plage (2) | Calais – Blériot-Plage | matched |
| Hoverport (1) | none | **left out**: Calais hovercraft port, a harbour, no kite source. |
| Les Hemmes de Marck (3) | Les Hemmes de Marck | matched |
| La Digue de Break (1) | none | **left out**: it is on the 7 km sea wall inside the Dunkerque port (kite-and-windsurfing-guide, park4night); no OSM beach element where people ride (Nominatim empty, Overpass down); port area. Left in TO_CONFIRM. |
| Plage de Malo (4) | Malo-les-Bains (Dunkerque) | matched |
| Leffrinckoucke (3) | none | **added (Pro)**: `osm:w234115857`. Sources: Dunkerque local guide (dune "batteries" zone free all year), bord-de-mer / local listing (kitesurf allowed, wrecks offshore). |
| Zuydcoote (3) | none | **added (Pro)**: `osm:w234116167`. Sources: kiteforum spot page, campsite listings with kite lessons nearby. One thin source, no school: noted. |
| Bray Dunes (3) | Bray-Dunes | matched |

Ours → Windy: Gravelines – Petit-Fort-Philippe has **no Windy marker** (kept: official order and two guides name it).
The other 6 originals each have a marker.

Counts: 10 Windy kite markers in the zone (Belgian ones excluded); 6 matched to our spots, 2 added as Pro, 2 left out
(Hoverport, Digue de Break). Our spots in the zone: 7 → 9 (3 free, 6 Pro, 0 archived); Gravelines has no Windy marker.
