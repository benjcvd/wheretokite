# Canary Islands validation (zone es-canarias, WHE-107)

Date: 2026-11-05. Method: [validation README](../../tools/spots/validation/README.md). 10 spots in
`tools/spots/ES.csv` before, 14 after (4 added as Pro). Past work: initial Spain pass and the 2026-10
trimming only; no Canary-specific sourced check in `git log`.

**Limits (said plainly):**
- Overpass was very slow today; pins were checked from the last committed build (`Data/spots.json`, Apple Maps
  `agrees` on all 10) and OSM element names, not on satellite.
- No official kite rules found for any island (ayuntamientos, Cabildos, Capitanía). Per the 2 Nov rule: nothing
  is `banned`; doubts are written in `notes`. No tide field set anywhere (sources disagree for Sotavento).
- Trade wind is NE; all sources agree the season is roughly April–October, with wind all year in the south of Fuerteventura.

## Spot by spot

| Spot | Real and known (sources) | Pin / direction | Rules / tide | Verdict |
|---|---|---|---|---|
| Fuerteventura – Sotavento (free) | thekitespot, Kiteforum, wannakitesurf, René Egli and ION schools, sportif.travel | 28.116 / -14.254, faces SE (131°), agrees | Tidal lagoon: sources say flat water mostly around high tide on spring tides, long walk at low tide; one tracker says the opposite. Old note said "flat at low tide": **fixed** to neutral "check the tide table", no `tide` field | fixed (note) |
| Fuerteventura – Costa Calma (pro) | Kiteforum, unplug-kitesurf, Matas Bay centre, Yumping course listing | OSM r1543928, SE (129°), agrees. It is Playa de la Barca, the northern half of the Sotavento beach, 5 km from our Sotavento pin | Same tide behaviour as Sotavento | fixed (note), stays pro |
| Fuerteventura – Flag Beach (Corralejo) (free) | kitejungle, Kiteforum, unplug-kitesurf, hellocanaryislands, Flag Beach Kitesurfing School (since 1999) | OSM w684867252, faces ENE (67°), agrees | About 3 km of the beach is a marked kite zone; winter wind unreliable (N, NW, NE best). Notes were empty: **left empty** (no confirmed text to add) | ok |
| Lanzarote – Famara (free) | thekitespot, Kiteforum, unplug, lavozdelanzarote, schools in Caleta de Famara | q:Playa de Famara, faces NW (310°), agrees | Beach break, currents and big tide: stay near a school. Note OK | ok |
| Lanzarote – Costa Teguise (free) | Kiteforum, kite-and-windsurfing-guide, lavozdelanzarote, vvanat guide | OSM w96680017 (Las Cucharas), faces SE (124°), agrees | Teguise beach regulation exists, text not found, nothing encoded. Note now mentions Los Charcos | fixed (note) |
| Lanzarote – Playa Honda (pro) | Lanzarote guidebook (SE winds cross-onshore), kite-and-windsurfing-guide (flat, 1 km in front of the airport, NE trade) | OSM r18367853, faces SSE (161°), agrees | Sources disagree on NE vs SE; airport next to the beach (keep clear). Note kept | ok, stays pro |
| Gran Canaria – Pozo Izquierdo (free) | Kiteforum, hanglos, surf-magazin (Dunkerbeck guide), kitejungle | OSM way "Pozo Izquierdo" beach, faces E (88°), agrees. Kiters actually launch from Salinas, 1.5 km south, same water | Kitejungle and one guide say kiting in the bay is prohibited; no official text. Not encoded, written in notes. Old note referenced Vargas and Bahía Feliz (separate rows): **removed** | fixed (note), question settled in TO_CONFIRM |
| Gran Canaria – Vargas (pro) | surf-magazin (beach zoned: north bathers, middle windsurf, south kiters), Kiteforum | OSM w473890331, faces E (101°), agrees | Zoned beach, no official text; note kept | ok, stays pro |
| Gran Canaria – Bahía Feliz (pro) | sportif.travel, kite-and-windsurfing-guide, school Club Mistral | OSM w133266290, faces SSE (166°), agrees | Gentle sideshore, flat inside the bay | ok, stays pro |
| Tenerife – El Médano (free) | spain.info, hellocanaryislands, Club Adrián, vvanat guide, Windy marker | OSM w28492650, faces ESE (118°), agrees | 2016 Cabildo buoy plan put kitesurf in zone 4 near Montaña Roja; no current text, nothing encoded. Sources say low tide best in places: not encoded | ok |

## Windy, both ways (visitor, 5 Nov, kite layer)

Windy kite markers in the zone: **24** (Fuerteventura 6, Lanzarote 6, Gran Canaria 9, Tenerife 3; none on La Palma/La Gomera/El Hierro read).
Matched to ours: 7 (Sotavento, Flag Beach, Famara, Playa Honda, Vargas, Salinas de Pozo = our Pozo Izquierdo, Medano Bay).
Added Pro: 4. Left out: 13.

| Windy marker (★) | Result |
|---|---|
| Sotavento (5) | our Sotavento |
| Flag Beach (5) | our Flag Beach |
| Famara (5) | our Famara |
| Playa Honda (5) | our Playa Honda |
| Vargas (4) | our Vargas |
| Salinas de Pozo (5) | our Pozo Izquierdo |
| Medano Bay (5) | our El Médano |
| Majanicho (5) | **added (Pro)**, OSM w188309585, kite-and-windsurfing-guide (wave kite spot) |
| Arinaga (4) | **added (Pro)**, OSM w289064914, unplug-kitesurf (flat to chop, intermediate) |
| El Cotillo (5) | left out: kite area (Piedra Playa) not identified on an OSM beach, no safe pin yet. Sources: kitejungle, vvanat. To redo with a pin |
| Playa del Garcey (2) | left out: unrated-ish, no kite source found |
| La Pared (4) | left out: surf spot, weak wind per a Dutch spot guide (hanglos/guides) |
| La Santa (4) | left out for now: sources conflict (reef surf spot), no pin checked |
| La Garita (3) | left out for now: beginner beach, one guide, no pin checked |
| Los Charcos (5) | left out: 662 m from Costa Teguise and faces 132° vs 124° (8° apart): duplicate under the 1 km rule (main fb58a7b). Named in Costa Teguise's notes |
| La Graciosa north (1) | left out: 1 star, island only by boat, no pin |
| Playa del Hombre (4) | **added (Pro)**, OSM w124154837, Kiteforum (experts only, cliffs downwind) |
| Gáldar (3), Jinámar (2), Punta Blanca (3) | left out: no kite source found |
| Maspalomas (5), Ketchup (3), Güímar (4) | left out for now: kite sources exist (unplug, kite-and-windsurfing-guide) but Maspalomas is a nature-reserve dune beach shared with bathers and naturists, and Ketchup / Güímar could not be pinned (Overpass timeouts). Second pass |
| Playa del Águila (4) | **added (Pro)**, OSM w204938457, 1.2 km from Bahía Feliz and faces 142° vs 166°; kite-and-windsurfing-guide (more swell in easterlies) |

Ours → Windy: Costa Calma, Bahía Feliz: no marker of their own (Costa Calma sits inside Windy's Sotavento marker area; Bahía Feliz next to Playa del Águila).

**Gap:** Windy shows 24 markers and we cover 11 of them. Most missing ones are secondary or surf beaches, but 5 have kite sources
(El Cotillo, Maspalomas, Ketchup, Güímar, La Santa) and need a second pass once Overpass answers.

## Second look (WHE-133, 6 Nov)

Ketchup, Güímar, La Santa, La Garita, Maspalomas and El Cotillo re-checked with 6 more searches: **none added**.
- Ketchup (Gran Canaria south), Puerto de Güímar (Tenerife), La Santa and La Garita (Lanzarote): one kite guide each
  (kite-and-windsurfing-guide.com), no school or town page naming them as kite spots, so the two-source rule fails. La Garita's only
  kite hint is a Windy page listing a rental school, which is not a local source. Güímar is a fallback for northerly wind only, narrow
  beach inside breakwaters; La Santa is a surf break with a small lagoon.
- Maspalomas (Faro / Punta): same guide says police have stopped kiters there, only windsurf is clearly allowed; no ordinance found. Worst case applies: stays out.
- El Cotillo: unchanged (WHE-92: no safe pin).

## Sources
unplug-kitesurf.com (Arinaga, Costa Calma, Los Charcos), kitejungle.com (Flag Beach, Pozo/Salinas, El Cotillo), se.kiteforum.com spot pages,
kite-and-windsurfing-guide.com (Majanicho, Playa Honda, Ketchup), thekitespot.com, wannakitesurf.com, surf-magazin.de (Pozo, Vargas), lanzaroteguidebook.com,
spain.info, Diario de Avisos 2016 (El Médano zones).
