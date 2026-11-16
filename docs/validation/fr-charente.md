# Validation: Charente-Maritime (Ré, Oléron, La Rochelle) (fr-charente, WHE-110)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-atlantic.csv` shows only the 2025
audit, tier and ban-column commits); `TO_CONFIRM.md` only had "Oléron – La Perroche: banned in summer?".

Sources are mostly tourist offices, school and booking pages and spot guides: I found **no municipal order or
préfecture text** for any spot in this zone, so no `banned` rule is encoded; summer limits are worded in `notes` with
"check the town hall". The Oléron island tourist page (oleron.fr), the Île de Ré tourist office (iledere.com), the
Charente-Maritime tourist guide (guide-charente-maritime.com), IKO and the Windy-independent spot guides
(kite-and-windsurfing-guide.com, vvanat.fr) are the base.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Île de Ré – Rivedoux | basic | fixed (notes) | Tourist office iledere.com: north beach "partly reserved for kitesurfing"; guide-charente-maritime: NW, N, NE wind, protected from waves, shallow, oyster beds cut the space at low tide, school on the beach (Île de Ré Kitesurf). vvanat: summer limits belong to the mayor (300 m band), no Rivedoux order found; off-season zone is south of the beach before the jetty. Pin: OSM beach (`osm:w1497408059`), build N-NNW, Apple Maps agrees. Tide `not-low` kept (oyster beds; Albeau says it is rideable at the lowest tides, so it is the careful side). Notes rewritten. |
| Île de Ré – Les Portes (Trousse-Chemise) | pro | fixed (notes) | guide-charente-maritime and vvanat describe the Banc du Bucheron at Les Portes: sandbank at low tide, E / N / NE wind, flat, strong current along the bank, travelling school Philo Vent; Club Nautique des Portes-en-Ré (iledere.com). The old note already described this (flat bay, sandbank, Fier d'Ars current). The Bucheron bank is 1.3 km from the pin, so treated as the same spot. Pin: OSM beach Trousse-Chemise (`osm:w260764654`), 2 m from water, ENE, agrees. Notes reworded, "confirmed riders". |
| Châtelaillon-Plage | basic | fixed (pin) | Chatel Kite School (Manawa, IKO-style booking pages, guide-charente-maritime), tourist guide: kite zone south of the beach, before the sea wall, two blue flags in summer, restricted in season, flat at low tide with rocks offshore, good at high tide, swell exposure. **Pin moved** from a park polygon to the OSM `sport=kitesurfing` node (`osm:n6620491493`) 1.6 km south. Direction W (278°), agrees. No order found: restriction in notes only. |
| La Rochelle – Aytré | pro | ok (notes) | guide-charente-maritime and Chatel Kite School: SW / W / NW, rideable 2 h either side of high water, muddy bottom with shells and mussels, crowded on windy days. Pin kept: OSM node on the beach (`osm:n6801705155`), 169 m from the water, direction W, agrees; the beach is a 2 km strip with no single launch. Tide `high` kept. |
| Châtelaillon / Aytré distance | | ok | 6 km apart, different water. |
| La Palmyre – Bonne Anse | basic | ok (notes) | Accrokite (IKO centre since 2003, esplanade of the Bonne Anse bay), guide-charente-maritime, vvanat: all winds except N and NE, shallow muddy bay, ride the rising tide, strong ebb currents. Pin: OSM beach (`osm:r2953870`), SW, agrees. Tide `not-low` kept. |
| Oléron – Plage des Huttes | basic | fixed (notes) | oleron.fr island page: 5 km, constantly windy but sheltered from the open Atlantic, wind S to NW, kite zone reserved in summer, rocks / waves / currents on big tides, schools on the beach. Guide-charente-maritime: Seulières end is the NW-wind kite spot, two blue flags in summer. vvanat: hour limits in summer (11:00 / 19:00) but the text is about the north tip, unconfirmed: notes say "check". Pin: OSM beach (`osm:w1494402921`), WSW, agrees. |
| Oléron – Plaisance | pro | fixed (notes) | oleron.fr, guide-charente-maritime, vvanat: calm, shallow, no swell or rocks, works both tides, N to NE wind, SE in the morning, mussels (shoes), summer: allowed zone on the left and navigation only before 11:00 and after 19:00 (blog source, no order found). Pin: OSM beach (`osm:w1238604909`), NE, agrees. |
| Oléron – La Perroche | pro | ok (notes) | vvanat: "banned to kites in summer" with La Rémigeasse next door; a local guide mentions town orders since 2022 and a Treuil beach zone for 2024; figaronautisme (Jan 2026): Rémigeasse closed ~12 weeks for works. **No official text found**, so the ban stays in notes, not encoded (rule of 2 Nov: the worst case, riders warned and told to ask the town hall). Intermediate to expert, SW to W, big shore break at high tide. Pin: OSM beach, SSW, agrees. TO_CONFIRM line updated. |
| Oléron – Gatseau | pro | fixed (pin id) | Weakest spot of the zone: only a beach directory (plages.tv) lists a "zone kitesurf", with difficult access, and a Windy marker (1 star). No school, no kite page. Pin now written as `osm:w1238639059` (was a Nominatim query that resolved to the same beach, 62 m from the old point). Direction SSE, agrees. Notes: no school, Maumusson pass currents. Kept as Pro, flagged for Ben. |

## Windy, both ways (browsed 2026-11-05, zoom 10 to 11 around 46.0 N, 1.25 W)

Windy → ours (Charente-Maritime coast, Ré, Oléron, Fouras, La Palmyre; Royan / Soulac belong to other zones):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Rivedoux (5) | Île de Ré – Rivedoux | matched |
| Banc du Bucheron (3) | Les Portes (Trousse-Chemise) | matched (same sandbank, 1.3 km) |
| La Couarde (5) | none | **added (Pro)** as `Île de Ré – La Couarde (Peu Ragot)`: Philovent kite school at La Couarde, kite zone listed at Peu Ragot, thermal wind. Pin OSM beach `osm:w194912872`. |
| Le Gros Jonc (3) | none | **added (Pro)** `Île de Ré – Le Gros Jonc`: island guides name it a kite spot, zone kept for gliding sports. Pin OSM beach `osm:w194912874`. One source, no school: flagged in notes. |
| Pointe du Lizay (3) | none | **left out**: guide describes a reef wave spot (surf / wave riding), no kite source, no kite page found. |
| Phares des Baleines (3), Saint-Clément-des-Baleines (3) | none | **left out**: only surf / windsurf wave sources ("fast powerful waves below the lighthouse"), no kite source. They are also about 1 km apart (one place). |
| Pointe de Grignon (2) | none | **left out**: swell-exposed, only surf / windsurf sources, no kite source. |
| Le Matray (1), Plage des Prises (1) | none | **left out**: no source at all about kiting there (1-star markers; only surf pages). |
| Les Palles (5) | none | **left out**: kite-and-windsurfing guide: wave break, low tide only, advanced, needs swell, no kite zone mentioned. |
| La Brée (3) | none | **left out**: the La Brée-les-Bains beach page lists jet-ski and windsurf zone only; no kite source. |
| Les Huttes (4) | Oléron – Plage des Huttes | matched |
| Le Douhet (3) | Oléron – Plaisance | matched (harbour name; Plaisance is the beach just south, 2 km) |
| La Perroche (4) | Oléron – La Perroche | matched |
| Grand Village (3) | none | **left out**: guide calls it a very demanding surf spot, heavy shore break and current; no kite source. |
| Côte Sauvage (2) | none | **left out**: wave coast, surf sources only. |
| Baie de Gatseau (1) | Oléron – Gatseau | matched |
| Plage Nord, Fouras (4) | none | **added (Pro)** `Fouras – Plage Nord`: Charente-Maritime tourist guide says kitesurf is possible, rocks at low tide. Pin OSM beach `osm:w89679888`. |
| Port des Barques (1) | none | **left out**: harbour / estuary mouth, only a bare guide page, nothing about kiting. |
| Châtelaillon (5) | Châtelaillon-Plage | matched |
| Aytré (5) | La Rochelle – Aytré | matched |
| La Palmyre (4) | La Palmyre – Bonne Anse | matched |
| Royan (4), one unnamed marker near Royan | none | **left out**: Royan is the Gironde estuary side, another zone; only a beach directory lists a kite zone at the Grande Conche, no kite zone, school or order found, so it cannot be pinned with confidence. |

Ours → Windy: all nine of our original spots have a marker (Rivedoux, Les Portes, Châtelaillon, Aytré, Palmyre, Huttes, Plaisance as Le Douhet, Perroche, Gatseau).

Counts: 24 Windy kite markers browsed in or next to the zone (Royan and the Marennes marker I could not name are not counted); 9 matched to our original spots, 3 added as Pro, 12 left out.
Our spots in the zone: 9 → 12 (3 free, 9 Pro, 0 archived).

Gap: Windy shows 12 markers we left out. Nine of them are Ré tip and Oléron west coast wave spots (surf-like, advanced) for which I only found surf or windsurf sources, no kiting. This is a reading of the sources, not an official rule: if Ben knows local riders use Lizay, Les Palles or Baleines for kite, they can be added as Pro.
