# Validation: Murcia, Almería and Granada (zone `es-murcia-almeria`, WHE-98)

Date: 2026-11-03. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: no earlier sourced pass on these rows (`git log` on `ES.csv` only shows pipeline/Catalan commits). Pins and facing
come from the build on the full `ES.csv` (OSM elements, Apple Maps check, no PROBLEMS).

Limits of this pass (said plainly): web search budget used (about 15 of 25); I did not open school pages one by one,
so "sources" below are search results (school listings, spot guides, town hall ordinance). Satellite checks of pins
in Chrome were not done (Chrome was used for Windy only). No official kite-zone text was found for any of the 7 spots.

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Mar Menor – Los Narejos | ok | OSM beach `w107723436`, faces S (172°), hint SE, shore 263 m. Build flags "water arc 360°" = lagoon, expected; flat water, `sector` unchanged | None found; no summer ban recorded | Schools on the seafront ([Insideout Kite](https://www.yumping.com/kitesurf/insideout-kite--e19753), Sea Ryders, Mas Kite); [spot guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/los-narejos-costa-calida-mar-menor-spain.html): works almost year-round, many directions. Windy 5 stars |
| Mar Menor – Los Nietos | fixed (notes) | `w294026685`, faces NNE, hint N, shore 99 m: south shore, onshore N–E | Old note said "no summer restriction at the end of the promenade": no source, removed. Now: bathing areas off limits in summer, ask schools | [Sea Ryders](https://www.yumping.com/en/kitesurfing/sea-ryders--e17080) has an office at Los Nietos; [Los Nietos beach listing](https://www.wildopenwater.com/swimspot/playa-los-nietos-murcia-región-de-murcia-spain) says suitable for kiteboarding. Thin: 1 school + 1 listing. No Windy marker (nearest, Lo Pollo, 3 stars). Kept as pro |
| La Manga – Isla del Ciervo | ok | `r3974793` ("Bahía de las Palmeras"), faces SW, hint SW, shore 39 m | Jellyfish nets until about end Sep: stays in notes ([nets report](https://www.ecoticias.com/naturaleza/103875_instalacion-kilometros-redes-control-preventivo-medusas-mar-menor)). Island is a protected bird area; no kite ban found | [Kiteforum spot page](https://se.kiteforum.com/kitesurf/spot/mar_menor___isla_del_ciervo), [Mas Kite](https://www.yumping.com/deportes-acuaticos/mas-kite--e7071) (La Manga since 2000). Windy 5 stars |
| Almerimar | ok | `w1474402756` ("Playa Poniente de Almerimar"), faces SW, hint S, shore 83 m. Hint S vs SW: within tolerance, kept | None found | [El Ejido tourism leaflet](https://turismo.elejido.es/wp-content/uploads/2021/06/triptico-actividades.pdf): federated windsurf/kite club on Poniente beach; [Yumping Kitesurfing Almería](https://www.yumping.com/kitesurf/kitesurfing-almeria--e6963) schools at Almerimar. Windy has no "Almerimar" marker but two next to it (Culoperro 4 stars, Punta Entinas 3 stars) |
| Almería – El Zapillo | question | `w1289258387`, faces SW, hint S, shore 39 m | `banned 06-15..09-15` has no official source I could find (searched town hall, ordinance). Rule: assume the worst, ban kept. Notes now say the source is missing. Town-wide: no sail or powered craft inside buoyed bathing zones | [Spot guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/el-zapillo-costa-tropical-almeria-spain.html): locals kite here in poniente, thermally boosted, schools on site. Windy 4 stars |
| Roquetas de Mar – Las Salinas | fixed (notes) | `w186053977`, faces ESE (123°), hint E, shore 3 m, OSM kite tag present | Town [beach ordinance](https://www.roquetasdemar.es/sites/default/files/2025-04/ORDENANZA_PLAYAS.pdf) art. 12: no sailing craft in buoyed bathing zones; unbuoyed strip of 200 m is bathing area, 3 kn limit. No kite article. Note now cites it | [Spot guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/salinas-costa-tropical-almeria-spain.html) (popular with local kiters), [Yumping course listings](https://www.yumping.com/en/deals/kitesurfing/almeria/beginner-kitesurfing-course-in-roquetas-de-mar-3-h--o46128) give Las Salinas or Villa África. **Fixed**: the beach faces ESE, so poniente is offshore; "poniente and levante" removed here and on the Almerimar note |
| Motril – Playa Granada | ok | `w96307227`, faces SSW (207°), hint S, shore 2 m | None found. Kitejungle warns not to drift past the cape on poniente (port) | [AWA Watersports](https://en.yumping.com/multiadventure/awa-watersports-granada--e19713029) (school on the beach), [Kitejungle](https://kitejungle.com/kite-places/spain/salobrena). Windy marker "Salobreña" next to it, 4 stars |

## Windy, both ways (browsed as a visitor, 3 Nov, kite markers hovered)

Windy marker → ours:

| Windy marker (stars) | Ours |
|---|---|
| Los Narejos (5) | Los Narejos |
| Isla del Ciervo (5) | Isla del Ciervo |
| El Zapillo (4) | El Zapillo |
| Roquetas de Mar (4) | Roquetas – Las Salinas (same stretch of coast) |
| Salobreña (4) | Motril – Playa Granada (neighbouring beach; probable match) |
| Culoperro (4), Punta Entinas (3) | Almerimar (neighbours, within 10 km, not added) |
| Playa de Levante (5), Torre Derribada (4), Pudrimel (3), Pueblo Cálido (3), Lo Pollo (3) | Mar Menor, all within about 10 km of Narejos / Ciervo / Nietos: not added, same lagoon |
| Torrenueva (4), Carchuna (2) | within 10 km of Playa Granada (Torrenueva), Carchuna is minor: not added |
| Retamar (3) | missing; 3 stars, suburb of Almería, not added. Cabo de Gata, San José, Las Negras are outside this zone |

Ours → Windy: Nietos is the only spot without a Windy marker (Lo Pollo nearby). Almerimar has none by name (see above).
Not added: nothing reaches the two-independent-sources bar on a different-conditions argument, and each is within 10 km of a kept spot.
Windy-hovered names were used only to learn that spots exist, never for positions.
Not hovered: two Almuñécar markers (outside this zone).

## Open
- El Zapillo summer ban has no official source → `TO_CONFIRM.md`.
- Pins not eyeballed on satellite; Chrome was only used for Windy.

## Windy follow-up: missing markers added as Pro (WHE-124, 5 Nov)

WHE-98 left out every marker below under the old "famous only" rule. Under the 4 Nov rule they go in as Pro unless
one of the listed good reasons applies. Pins are OSM elements found by name search or the OSM lookup tool; Windy was
used only to learn the marker names (from the table above), never for positions. Facing is whatever the build computes.

| Windy marker (stars) | Result | Source / reason |
|---|---|---|
| Playa de Levante (5) | added (Pro) – Cabo de Palos – Playa de Levante, `r2115915` | Only a swim-spot listing ([Wild Open Water](https://wildopenwater.com/swimspot/playa-levante-cabo-palos-murcia-región-de-murcia-spain)) mentions kiteboarding. Thin; notes say so and warn about the marine reserve |
| Torre Derribada (4) | added (Pro) – San Pedro del Pinatar – Torre Derribada, `n1459233700` | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/torre_derribada) (flat/shallow, all levels, parking), [Wild Open Water](https://wildopenwater.com/swimspot/playa-torre-derribada-murcia-regi%C3%B3n-de-murcia-spain) |
| Pudrimel (3) | added (Pro) – La Manga – Playa del Pudrimel, `w478799430` | [Kite & windsurfing guide, Costa Cálida page](https://kite-and-windsurfing-guide.com/en/continents/countries/regions/costa-clida--mar-menor) (shallow, flat, medium launch area); the winds the guide lists look offshore on the lagoon side, so the note says to check |
| Pueblo Cálido (3) | **left out** – no pin | [Guide page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/pueblo-calido-costa-calida-mar-menor-spain.html) gives no town or position; OSM only has a bus stop of that name in La Manga. No beach element can be tied to it, so it can't be pinned |
| Lo Pollo (3) | left out – same beach as Los Nietos | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/lo-pollo-costa-calida-mar-menor-spain.html): "500 m west of Los Nietos", same water and winds |
| Culoperro (4) | added (Pro) – Guardias Viejas – Culoperro, `w1474398096` (Los Baños beach) | [Wannakitesurf](https://wannakitesurf.com/spot/Europe/Spain/Andalucia/Culoperro/) (E wind onshore, waves/freeride, Oct–May), [Barceló](https://www.barcelo.com/guia-turismo/es/espana/almeria/que-ver/surf-en-almeria-las-mejores-playas/) places Culo Perro by Los Baños de Guardias Viejas |
| Punta Entinas (3) | added (Pro) – Punta Entinas, `w895905424` | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/punta-entinas-costa-tropical-almeria-spain.html), Yumping lessons ([1](https://en.yumping.com/deals/kitesurfing/almeria/private-kitesurfing-class-at-punta-entinas-beach-2-h--o57260), [2](https://en.yumping.com/deals/kitesurfing/almeria/kitesurf-initiation-class-punta-entinas-beach--o57266)) |
| Retamar (3) | added (Pro) – Almería – Retamar, `w170338804` | [Unplug](https://www.unplug-kitesurf.com/schools/borakiteschool) lists it as a beginner spot; no school on site. Thin |
| Torrenueva (4) | **left out** – no kite source | Only generic water-sports listings; no school, guide or forum page names it for kiting. Same stretch of coast as Carchuna / Playa Granada. Not one of the listed good reasons: Ben may overrule |
| Carchuna (2) | added (Pro) – Carchuna, `n13093975140` (Playa Salmonete) | [Kite & windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/carchuna-costa-tropical-almeria-spain.html), [granadaspain.co.uk](https://granadaspain.co.uk/carchuna-playa/), AWA Watersports Carchuna courses |
| Salobreña (4) | matched earlier to Playa Granada | The school 18 Nudos runs from Punta del Río in Salobreña ([Yumping](https://en.yumping.com/water-sports/18-nudos-surf-club--e19703478)); a few km from Playa Granada. Left as matched |

Duplicate rule (fb58a7b, 1 km, same water and facing): only Lo Pollo is left out for closeness; it is about 500 m from Los Nietos on the same shore, so it stays a duplicate. Nothing else here was left out as "too close".

Unrated rule (5 Nov): every missing marker above had 2 to 5 stars when I browsed it as a visitor on 3 Nov, so the unrated rule (Pro only with a local source, else archived) does not apply to any of them.

Counts: 15 Windy kite markers in the zone: 5 matched to our existing spots, 7 added as Pro, 3 left out (Pueblo Cálido: can't be pinned;
Lo Pollo: same beach as Los Nietos; Torrenueva: no kite source). Our spots 7 → 14 (2 free, 12 Pro, 0 archived).
