# Validation: Tarifa, the Strait and Málaga (zone `es-strait`, WHE-99)

Date: 2026-11-05. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: WHE-85 settled the Tarifa levante question on 3 Nov ([TO_CONFIRM.md](../../tools/spots/TO_CONFIRM.md#settled-tarifa-levante-whe-85-3-nov-no-change-to-the-catalogue)):
Balneario faces WSW so levante is offshore there; Los Lances 227° and Valdevaqueros 214° agree with Apple Maps. Not redone.
No other sourced pass on these rows (`git log` on `ES.csv`).

Limits of this pass, said plainly: no official kite-zone text (Ayuntamiento de Tarifa, Costas, Aena, Marbella) could be found
online, so every summer rule below is from schools and guides. Satellite checks of pins in Chrome were not done (Chrome used for Windy only).
Overpass was unreliable on 5 Nov, so pin and direction results come from a build of this zone's rows only (see Check).

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Tarifa – Los Lances | fixed (notes) | `w1134220405`, faces 227° (SW), Apple Maps agrees (WHE-85) | Summer: marked zones for bathers, schools and free-riders; south of the beach bathing only. **Removed the dates "15 Jun–15 Sep"** from the note: no source gives them. Not encoded as a ban (none was) | [Kite Fun Tarifa, Los Lances](https://kitefuntarifa.com/en/kitesurf-spots-tarifa/kitesurf-spot-los-lances.html) (zones, levante or poniente, all levels); [andalucia.com kite areas](https://andalucia.com/tarifa/kitesurf/practice-areas) (main zone at Río Jara, yellow buoys, strict in summer). Windy: "Los Lances", "Río Jara", "Arte Vida", all 5 stars |
| Tarifa – Valdevaqueros | fixed (notes) | `w186110526`, faces 214° (SSW), agrees | Narrow summer area shared with bathers and windsurfers; no dates given by anyone. Note rewritten: levante side-offshore (drift), poniente easy, rocks, not for beginners in strong levante. Removed "Also: Bolonia" (own spot) | [Kite Fun Tarifa, Valdevaqueros](https://kitefuntarifa.com/en/kitesurf-spots-tarifa/kitesurf-spot-valdevaqueros.html); [andalucia.com](https://andalucia.com/tarifa/kitesurf/practice-areas): southern part of the beach is the kite zone, rocks at the south end. Windy 5 stars, plus "Punta Paloma" 5 stars (same beach, see below) |
| Tarifa – Balneario | question (ban kept) | `w672119807`, faces 250° (WSW), agrees | `banned 06-15..09-15` has **no official source**; rule: assume the worst, ban kept and the note now says so. Levante is straight offshore: experts only | [Kite Fun Tarifa, Balneario](https://en.kitefuntarifa.com/kitesurf-spots-tarifa/kitesurf-spot-balneario.html) ("strong levante only, expert riders only"); [andalucia.com](https://andalucia.com/tarifa/kitesurf/practice-areas): used off season, dangerous in levante. Windy "Playa Chica" 5 stars (same water) |
| Bolonia | fixed (notes), question (ban kept) | `q:Playa de Bolonia`, faces 223°, agrees | Guide: tolerated only in winter, east of the bay from the village outskirts. Encoded ban 15 Jun–15 Sep has no official source: kept (worst case). Note rewritten | [kite-and-windsurfing-guide Bolonia](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/bolonia-estrecho-de-gibraltar-tarifa-spain.html) (winter waves, less levante than Tarifa); [andalucia.com](https://andalucia.com/tarifa/kitesurf/practice-areas) (kite area in front of La Cabaña bar). Windy "Bolonia" 5 stars |
| Algeciras – Palmones | fixed (notes) | `w236560364`, faces SE (144°), shore 8 m, agrees | Old note said "no kiting in summer": sources disagree. A school says allowed in marked zones, no reserved summer area; river, lagoon and marsh strictly forbidden. No ban found, nothing encoded; note says so | [Kite Fun Tarifa, Palmones](https://kitefuntarifa.com/en/kitesurf-spots-tarifa/kitesurf-spot-palmones.html) (levante only, all levels, hazards: marsh, ships, river-mouth current); [Unplug](https://www.unplug-kitesurf.com/spots/palmones-spain) (E / ESE, crowded). Windy "Palmones" 4 stars |
| Marbella – Los Monteros | fixed (notes) | `r1714644`, faces 191°, agrees | Old note ("summer access only through the buoyed channel") had no source. Now: 300 m kite zone agreed by the town hall with Marbella Kite Club (2019, ratification by the Junta not stated). Dates not found | [Olive Press, 2019](https://theolivepress.es/spain-news/2019/04/29/marbella-announces-new-300-metre-kitesurfing-zone-to-rival-that-of-tarifa) (zone, Río Real rocks); [Marbella Kiteschool](https://holfuy.com/es/weather/1190) (school at Río Real / Los Monteros, east wind thermal in spring and summer). Windy "Los Monteros" 5 stars |
| Málaga – Los Álamos | fixed (notes) | `w1555163983`, faces 127° (SE), shore 28 m, agrees | Old note "official kite zone … moved during the bathing season" had no source. **Aena restricted kiting at Guadalmar in 2015** after a plane accident; schools teach there today, but no official text on the current zone. Not a ban in the catalogue; note tells riders to check with a school | [kite-and-windsurfing-guide Los Álamos](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/los-alamos-costa-del-sol-malaga-spain.html) (afternoon poniente + southerly breeze, evening offshore gusts, up to 40 kites); [Euro Weekly News 2015](https://euroweeklynews.com/2015/07/31/kitesurfers-up-in-arms-over-guadalmar-beach-ban/) (provisional ban, 7 schools, alternative zone offered); [Picuco course](https://www.picuco.com/es-es/activities/kitesurf-malaga). Windy "Guadalmar" 4 stars (same stretch) |

Tide: not applicable (Strait and Mediterranean beaches, tidal range small); the Tarifa lagoon is outside this zone.

## Windy, both ways (browsed as a visitor, 5 Nov, kite markers hovered)

Windy markers in the zone box: 21 (plus Benavides 2 stars just west of it, and Gibraltar, which is not in our countries). Matched to ours: 10 (5 by name, 5 on the same beach). Added as Pro: 5. Left out: 6.

| Windy marker (stars) | Ours |
|---|---|
| Valdevaqueros (5) | Valdevaqueros |
| Los Lances (5) | Los Lances |
| Bolonia (5) | Bolonia |
| Palmones (4) | Palmones |
| Los Monteros (5) | Los Monteros |
| Punta Paloma (5) | matched: same beach as Valdevaqueros (our note already says "includes Punta Paloma"), under 2 km |
| Río Jara (5), Arte Vida (5) | matched: same beach as Los Lances (Río Jara is Los Lances Norte), same water |
| Playa Chica (5) | matched: Tarifa town beach next to Balneario, same water, under 1 km |
| Guadalmar (4) | matched: same stretch as Los Álamos (our note says "Los Álamos / Guadalmar") |
| Playamar (5) | left out: same beach strip as Los Álamos, about 1.5 km, same winds; a guide says windsurfers use it for parking |
| Getares (4) | **added (Pro)** `Algeciras – Getares`, OSM beach `w178722711`; Kite Fun Tarifa + Unplug |
| El Heaven (4) | **added (Pro)** `Estepona – Guadalmansa (Heaven)`, `w576972096`; Heaven Kite School is on that beach |
| San Pedro (4) | **added (Pro)** `San Pedro de Alcántara`, `w322423323`; Costa del Sol spot guide |
| Cabopino East (5) | **added (Pro)** `Marbella – Cabopino`, `w230611183`; spot guide |
| El Chaparral (5) | **added (Pro)** `Mijas – El Chaparral`, `w544536226`; spot guide |
| Estepona (5) | left out: no local source found, and no OSM beach could be tied to the marker without using its position; the kite school nearby is at Guadalmansa (added) |
| Sotogrande (5) | left out: only a marina blog, not a beach; no OSM element tied to where people ride |
| Chilches (3) | left out: no source found at all |
| Torrox (5) | left out: guide lists "Torrox" but not which beach; no OSM element could be tied to it without Windy's position |
| Playa del Chanquete (5) | left out: city bathing beach east of Málaga, no kite source found |
| Benavides (2) | outside the zone (Cádiz coast), recorded for the next zone |

Ours → Windy: every one of our 7 spots has a Windy marker (Balneario via "Playa Chica"; Los Álamos via "Guadalmar").
Gap line: Windy shows 21 markers against our 7 spots plus 5 added; the rest are repeat markers on the same beaches (Lances, Valdevaqueros, Balneario: 6 markers) and Costa del Sol towns where I found no usable source (Estepona, Sotogrande, Chilches, Torrox, Chanquete). These need a local source or a school page; a follow-up card could add them.
Windy names were used only to learn that spots exist, never for positions.

## Check
`spot-check` on this zone's 12 rows (subset CSV; the full ES.csv build stalled on Overpass timeouts): no PROBLEMS, Apple Maps agrees on all 12.
Spots before → after: 7 → 12 (free 3, Pro 9, archived 0).

## Open
- Tarifa Balneario and Bolonia summer bans (15 Jun–15 Sep) have no official source; kept as the safe choice → `TO_CONFIRM.md`.
- Málaga: current status of the Aena restriction at Guadalmar → `TO_CONFIRM.md`.
- Pins not eyeballed on satellite.
