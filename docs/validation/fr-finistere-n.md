# Validation: North Finistère and Brest (fr-finistere-n, WHE-114)

Done 5 Nov 2026. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone (`git log` on `FR-atlantic.csv` shows only the 2025
audit, tier and ban-column commits; `TO_CONFIRM.md` had nothing on it). Sources are spot guides
(kite-and-windsurfing-guide.com, unplug-kitesurf.com, tourist offices, one regional blog, vvanat.fr, which is not
independent of the others) and school listings. No decree or town page could be found for any rule, so nothing
new is encoded in `banned`. Overpass was down: pins were found through Nominatim and the build used its cache.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Saint-Michel-en-Grève (Lieue de Grève) | basic | fixed | Pin now the OSM sand element "La Lieue de Grève" (build: faces N, Apple Maps agrees; snapped to shore 27 m). Brittany tourism and Baie de Morlaix tourism: Kite's Cool school on the beach, 3 km wide at low tide, no rocks, beginners; kite guide: waves ideal for novices, long walk at low tide. Windy: Saint-Michel-en-Grève (3). Notes were empty. |
| Santec – Le Dossen | basic | fixed | Pin was a text search; now beach way "Plage du Dossen" (faces W). Kite guide: best S–SW, westerlies blocked inshore at high tide so ride low tide, visible rocks; Kite Sans Frontière school teaches at Dossen. Summer bathing zone (1 Jun–15 Sep) from one blog only: notes. Windy: Dossen (5) and Le Dossen (3). Notes were empty. |
| Keremma | basic | ok, notes rewritten | Reference spot. FFVL-labelled, run by the Finistère Kite Association (blog), Natura 2000 dunes (INPN site FR5300016), Goulven bird reserve closed to boats (guide). unplug-kitesurf: NW best, low tide flat like a lagoon, rocks, no special rules; kite guide agrees on low tide. Pin kept (named beach node, faces N). Windy (5). |
| Guissény – Le Vougot | pro | ok, notes added | Kite guide: thermal stronger than Dossen, stones in the water, shorebreak at high tide; bord-de-mer.com lists a kite zone; Abers tourism lists the beach. No school on site found. Pin kept (beach way "Grève du Vougot", faces NW). Not on Windy. |
| Landéda – Sainte-Marguerite | pro | ok, notes rewritten | Regional blog: one of the two big kite sites around Brest, sheltered flat bay; vvanat: S–NNE works, strong current on big tides, reefs, south-part swimming zone 1 Jul–30 Aug; school AvelWest in Landéda. Tide sources disagree (TO_CONFIRM): no tide field. Windy (5). Pin kept (faces W, Apple Maps agrees). |
| Lampaul-Ploudalmézeau – Trois Moutons | pro | ok, notes corrected | Old note said "calm water"; guides say waves and one of the windiest beaches, W–NW best, long walk at low tide, marked kite zones left of the beach in July–August. Same dunes as Windy's Tréompan (4). Pin kept (faces N). |
| Le Conquet – Blancs Sablons | pro | fixed (pin) | Pin was a text search; now beach way "Plage des Blancs Sablons" (faces NW). Kite guide: best at mid tide, huge shorebreak and gusty at high tide, waves close out at low; vvanat: SW–N, not for beginners, west swimming zone in summer. Windy (5). |
| Brest – Moulin Blanc | pro | ok, ban question | Kite guide: popular city spot, strong SW onshore, kite channel in summer. Tourist office page: lifeguards 1 Jul–31 Aug 13–19 h, no kite rule. No text backs the `banned` closure; kept as worst case, see TO_CONFIRM. Windy (5). |
| Primel-Trégastel | pro (new) | added | Windy-only marker (2). Kite guide: NE best, experienced only, rocks both sides and under water, risky towards low tide. Pin: OSM beach "Plage de Primel" (faces W; the NE wind the guide likes is offshore here, said in notes). |
| Lannion – Beg Léguer | pro (new) | added | Windy-only marker (3). Kite guide: freeride, wave spot above 20 kn, cross-on from the left, best on the rising tide, rocks right, shorebreak at high tide. Pin: OSM beach "Plage de Goas-Lagorn" at Beg-Léguer (faces W). One source only. |

## Windy, both ways (browsed 2026-11-05, zoom 10 and 12 around 48.6 N, 4.4 W)

Windy → ours (21 markers in the zone box):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Moulin Blanc (5) | Brest – Moulin Blanc | matched |
| Blancs Sablons (5) | Le Conquet – Blancs Sablons | matched |
| Sainte Marguerite (5) | Landéda – Sainte-Marguerite | matched |
| Tréompan (4) | Trois Moutons | matched (same dunes) |
| Keremma (5) | Keremma | matched |
| Dossen (5), Le Dossen (3) | Santec – Le Dossen | matched (two markers, one beach) |
| Saint-Michel-en-Grève (3) | Lieue de Grève | matched |
| Saint-Efflam (3) | none | left out: same 4 km beach as the Lieue de Grève (about 2 km west of our pin, same water and winds) |
| Primel Trégastel (2) | **Primel-Trégastel** | **added (Pro)**: kite guide |
| Beg Leguer (3) | **Lannion – Beg Léguer** | **added (Pro)**: kite guide, pinned on Goas-Lagorn beach |
| Térénez (3) | none | left out: guide says surf school and freeride, but OSM has only the village, no beach to pin |
| Île Grande (4) | none | left out: guide page exists, but no OSM beach where people launch (island and bay) |
| Kernisi (3) | none | left out: guide says there is no launch place (pebbles, forest edge), nothing to pin |
| Trezmeur (4), Grève Rose (3) | none | left out: no local source found, no beach identified |
| Les Amiets (3), Boutrouilles (2), Île de Vierge (1) | none | left out: no local kite source found |
| Trez Hir (3) | none | left out: only a swimming-spot page found, no kite source |
| Saint-Jean-du-Doigt (1) | none | left out: no local source found |

Ours → Windy: all of ours have a marker except Guissény – Le Vougot (not on Windy).

Counts: 21 Windy markers (8 distinct beaches matched to our 7, the Dossen pair counting once), 2 added (Pro), 12 left out. Our spots in the zone: 8 → 10 (basic 3 → 3, pro 5 → 7, archived 0).

Gap: Windy shows 21 markers against our 10. Most of the rest have no local kite source, or no beach to pin (Térénez, Île Grande, Kernisi), or are the same beach as one of ours.
