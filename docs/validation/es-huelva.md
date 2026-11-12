# Huelva validation (zone es-huelva, WHE-101)

Date: 2026-11-05. Method: [validation README](../../tools/spots/validation/README.md). Zone: Huelva
province coast (4 spots before, 8 after). Past work: rows come from the initial Spain pass (89 → 44
trimming); `git log` shows no Huelva-specific check, and `TO_CONFIRM.md` only said "Huelva summer
zones" (settled below).

**Limits of this check (said plainly):**
- The Overpass servers were slow and timing out while I worked (same as WHE-94). The build did finish
  at the end on the 8 Huelva rows (cached on the shared cache): no PROBLEMS, Apple Maps check `agrees`
  on all 8. New pins: La Antilla 37.205 / -7.212 (faces S, 177°), Playa Central 37.190 / -7.326 (the
  OSM beach `Playa de la Gola`, faces SSE 149°), Mazagón Playa de las Dunas 37.124 / -6.811 (SSW 196°),
  Matalascañas 36.991 / -6.544 (SSW 219°). Playa Central's pin is about 400 m from Windy's marker.
- Pins were not eyeballed on satellite (Chrome was used for the Windy step only).
- No official text found for summer rules (Ayuntamientos of Isla Cristina, Lepe, Punta Umbría,
  Cartaya; Costas; Capitanía de Huelva). Rule of 2 Nov: assume the worst, say it in `notes`, no
  `banned` field.

## Settled: "Huelva summer zones"

The old note on Isla Cristina – La Casita Azul said "designated kite zone; restricted from 15 Jun".
Three searches (Spanish and English) found no zone, decree or date for it, so the claim was
unsourced and is removed. Notes now say: no official zone found, keep clear of bathers, check signs.
No spot in Huelva gets a `banned` field.

## Spot by spot

| Spot | Real and known (2 sources) | Pin / direction | Rules | Verdict |
|---|---|---|---|---|
| El Portil (basic) | Flecha Extreme school at the Río Piedras mouth ([andalucia.org](https://andalucia.org/en/punta-umbria-sports-flecha-extreme)); Nómadas del Kite ([yumping](https://www.yumping.com/kitesurf/nomadas-del-kite--e14245)); Windy marker 4 stars | beach way `w1156218337`, 37.209 / -7.049, faces SSW (195°), hint S, Apple Maps agrees; Windy marker sits on the same beach | None found | fixed: notes rewritten from the school pages (the old text said "behind the sandspit, cross the river", which is the Rompido side) |
| Punta Umbría (pro) | Nalú school on Punta Umbría beach (Barceló guide), Nómadas del Kite, beginner courses ([yumping](https://en.yumping.com/deals/kitesurfing/huelva/kitesurfing-for-beginners-at-punta-umbria-beach--o45505)); kite-and-windsurfing-guide calls it one of the two main breaks of the coast; Windy marker "Punta Umbria Playa" 4 stars | `w889930861`, 37.190 / -6.995, faces SSW (210°), hint S, agrees | "Summer restrictions near bathers" had no source: reworded as "no official zone found" | fixed (notes), stays pro |
| Isla Cristina – La Casita Azul (pro) | Waterproof Kite School ([andalucia.org](https://www.andalucia.org/en/isla-cristina-sport-activities-waterproof-kite-school), address Playa Casita Azul); Windy.app spot page (E–W winds, best May–Sep, kites 11–13 m) | `w225560425`, 37.200 / -7.284, faces SSE (168°), agrees | The "designated kite zone, restricted from 15 Jun" claim had no source: removed | fixed (notes), stays pro |
| Ayamonte – Isla Canela (now basic) | Isla Canela Kite El Paradise, Kanela Kites, Nómadas del Kite, Ocean Beach Center ([yumping](https://www.yumping.com/en/kitesurfing/huelva)); The Olive Press 2023 ("one of the best kitesurfing beaches in Spain"); kite-and-windsurfing-guide page; Windy marker 5 stars | `w123911782`, 37.172 / -7.374, faces S (170°), agrees | None found | fixed (notes list the schools), moved to basic by Ben (5 stars, 4 schools) |

Tide: the Atlantic range here is about 3 m, but no school page says the spots depend on it, so no
`tide` value is set. Left empty.

## Windy, both ways (visitor, 5 Nov, kite layer)

Windy kite markers on the Huelva coast (names are Windy's labels, not positions we use):

| Windy marker | Stars | Our spot / decision |
|---|---|---|
| Isla Canela | 5 | Ayamonte – Isla Canela |
| El Portil | 4 | El Portil |
| Punta Umbria Playa | 4 | Punta Umbría |
| Isla Cristina (town beach, east of the harbour mouth) | 4 | **added (Pro)**: Isla Cristina – Playa Central. 3.3 km from La Casita Azul, so not the same beach; Playa Central is where yumping courses meet |
| La Antilla | 4 | **added (Pro)**: La Antilla. School at Playa de Poniente, spot guide, Windy page |
| Mazagón | 4 | **added (Pro)**: Mazagón – Playa de las Dunas. One source (spot guide), enough for Pro |
| Matalascañas | 4 | **added (Pro)**: Matalascañas. School in town, spot guide. Lies just east of the zone box (-6.55) but is Huelva coast |
| Espigón de Huelva | 3 | left out: see below |
| Punta Umbria Bajos | 1 | left out: sits on Isla Saltés, a sandbar in the Marismas del Odiel nature park reached by boat; no source, no OSM beach to pin |

Vila Real de Santo António (Portugal) is outside the catalogue's Spanish file, not counted.

Our spots on Windy: all 4 have a Windy marker (Isla Canela, El Portil, Punta Umbría, and Casita Azul
is covered by Windy's "Isla Cristina" marker 3.3 km west of it, plus Windy.app's own "La Casita Azul"
spot page). Windy's coast has 8 Spanish markers; after this pass we have 8 spots (7 matched or added,
Espigón and Punta Umbría Bajos open).

## Open

- Espigón de Huelva: one guide mentions kitesurf on this spit across the Odiel marshes; the OSM lookup
  timed out so I could not find a beach element to pin. Not added; retry when Overpass answers.
- Isla Canela moved to free (basic) on Ben's answer, 2026-11-05.
