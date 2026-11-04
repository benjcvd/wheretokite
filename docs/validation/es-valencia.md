# Validation: Valencia and Aragón (es-valencia)

Card WHE-93, 2026-11-03. Method: [validation README](../../tools/spots/validation/README.md).
Past work: Loteta pin question already in `TO_CONFIRM.md` (Spain section); the Valencia rows had
no earlier source check (commits `eae2cab`, `0056b9c`, curation only).

Web-search budget was exceeded slightly (12 searches) to settle the Santa Pola finding.

## Spots

| Spot | Verdict | Why / sources |
|---|---|---|
| Valencia – El Perellonet (basic) | ok, notes fixed | Kitezone Club school (Yumping listing) and a kite guide ([El Pollo / Perellonet page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/el-pollo-costa-del-azahar-valencia-spain.html)) agree: buoyed zone south of the river mouth in summer. Municipal lifeguard tenders for the zone, 14:30–19:30 mid-Jun–mid-Sep ([FDM 2018](https://www.fdmvalencia.es/wp-content/uploads/2018/04/CONDICIONES-contratación-SEGURIDAD-KITESURF-2018-un-vigilante.pdf)). Caveat: in 2023 the Albufera park refused the sea canals at El Perellonet, kite included ([Valencia Plaza, 17 May 2023](https://valenciaplaza.com/valenciaplaza/deportes-nauticos-perellonet-se-nos-trata-vecinos-de-segunda)); outcome not found. Note no longer says "open year-round". No `banned` (not official for 2026). |
| Oliva (basic) | ok | Kite Surf Oliva school, April–September ([Comunitat Valenciana](https://www.comunitatvalenciana.com/es/valencia/oliva/nautica/kite-surf-oliva)); Windy shows Oliva as 5-star. |
| Dénia – Les Deveses (pro) | ok | Two schools, Costa Blanca Kiteschool and KITE 45º ([denia.net](https://denia.net/en/naturaleza/kitesurf/)), plus Denisurf ([IKO](https://www.ikointl.com/school/espa%C3%B1a/denia/denisurf)); regional tourism calls Les Deveses a best-known summer spot. |
| Santa Pola – La Gola (was basic) | **archived** | The council says each year the authorities refuse kites at La Gola and the kite channel is at Tamarit ([Alicante Plaza, 27 Aug 2023](https://alicanteplaza.es/el-gobierno-de-santa-pola-se-defiende-las-criticas-en-el-tamarit-y-asevera-que-el-kitesurf-no-puede-ir-a-la-gola)). Old note "open year-round" was wrong. |
| Santa Pola – Tamarit (**added**, basic) | added | Pin: OSM beach way `w71365123`. Official council decree 5779/2022, no. 2024-2016 of 9 Jul 2024 ([PDF](https://santapola.es/wp-content/uploads/2024/07/Decreto-Kitesurf.pdf)): channel 120 m wide; Oct–May free; June and September free weekdays, weekends 14–17 h; Holy Week, July, August weekdays 14–17 h, weekends banned. Decree runs to 31 May 2025 "unless agreed otherwise" and is renewed each year; 2026 text not found. Schools: Escuela Española Kitesurf Alicante, Parrés Center ([Comunitat Valenciana](https://www.comunitatvalenciana.com/es/alacant-alicante/santa-pola/nautica/parres-center)). `banned` encodes only July–August outside 14–17 h; the weekday/weekend rule can't be encoded, so it is in notes. |
| Elche – Arenales del Sol (pro) | ok, notes fixed | Kite courses and Parrés WaterSports ([listing](https://www.comunitatvalenciana.com/es/alacant-alicante/elx-elche/nautica/parres-watersports)); no official channel or rules found. Stays pro; note now says to ask the school. |
| Guardamar – Els Tossals (pro) | **kept Pro** (4 Nov rule; was archived) | No school, kite zone or rule found for this beach; Guardamar courses don't name it; dune protected area. Worst case. |
| Burriana – El Arenal (pro) | **kept Pro** (4 Nov rule; was archived) | One regional guide (S–SW wind) and a shop; no school, no kite zone. Windy shows a Burriana marker, which only tells us it exists. |
| Embalse de La Loteta (basic) | ok | Club Kitesurf La Loteta, 260+ members, hub of Aragón kite ([Zaragoza city](https://zaragoza.es/sede/portal/juventud/info-joven/servicio/noticia/339366)); Cierzo Festival 2025 ([zaragozala](https://zaragozala.com/zaragoza-provincia/la-loteta-acoge-el-cierzo-festival-2025/)); stop on the national circuit ([GoAragon](https://www.goaragon.eu/zaragoza-province-a-sea-of-proposals-in-aquatic-activities/)). Cierzo (NW) along the reservoir, sector 360 kept. Pin at the marina still open in TO_CONFIRM. |

Not verified on satellite (Chrome was used for Windy and the decree only): pins come from OSM elements and
the pipeline's Apple Maps direction check; see the build result below.

## Windy, both ways (markers read by hovering as a visitor, 3–4 Nov)

Rule of 4 Nov applied: every Windy kite marker we lacked is added as Pro unless a listed reason holds.
About 36 markers named in the Comunitat Valenciana (Aragón not browsed): 33 now covered by a spot of ours, 3 not added (below).

| Windy marker | Ours |
|---|---|
| Peñíscola | **added (Pro)** Peñíscola – Playa Norte |
| Benicàssim | **added (Pro)** Benicàssim – Voramar |
| Burriana | Burriana – El Arenal (back to Pro) |
| El Port de Sagunt | **added (Pro)** Sagunto – Platja del Port de Sagunt |
| Pobla de Farnals | **added (Pro)** Pobla de Farnals – Platja Nord |
| La Patacona | **added (Pro)** Valencia – La Patacona |
| El Saler | **added (Pro)** Valencia – El Saler |
| El Perelló | same beach as Valencia – El Perellonet (3 km, same water and winds) |
| Mareny de Barraquetes | Sueca – Mareny (back to Pro: the club-only note has no official source) |
| El Pollo | **not added**: no OSM beach carries that name, no pin |
| Río Júcar | same beach as Cullera – Platja del Racó |
| Playa de Xeraco | **added (Pro)** Xeraco – Platja de Xeraco |
| Gandía | Gandía – Playa Norte (Pro) |
| Oliva | Oliva |
| El Vergel | **not added**: no OSM beach found for the name, no pin |
| El Paquebote | **added (Pro)** Dénia – L'Almadrava (El Paquebote) |
| Denia | Dénia – Les Deveses |
| Xàbia | **added (Pro)** Xàbia – Platja de l'Arenal (calm family beach) |
| Calpe | **added (Pro)** Calp – Platja de l'Arenal |
| Altea | **added (Pro)** Altea – Albir (Algar mouth) |
| La Vila Joiosa | **added (Pro)** La Vila Joiosa – Platja Centre (mostly surf) |
| El Campello, San Juan (2 markers) | El Campello – Muchavista (Pro); San Juan is the same beach |
| La Albufereta (+ one more in Alicante) | **added (Pro)** Alicante – La Albufereta; the other marker is the same beach |
| Santa Pola (2) | Santa Pola – Tamarit (Playa Lisa is 0.6 km away, same water) |
| La Ermita | **not added**: not found in OSM by that name, no pin |
| Guardamar | Guardamar – Els Tossals (back to Pro) |
| Playa de la Mata | **added (Pro)** Torrevieja – La Mata |
| Playa Chica | **not added**: the only OSM "Playa Chica" is in Tenerife, no pin |
| Torre Derribada and markers further south | Murcia zone |
| La Gola (our old spot) | archived: the council says the authorities refuse kites there |

Ours not on Windy: Arenales del Sol, Embalse de La Loteta (Aragón not browsed).
Counts: 14 new Pro rows this pass plus Gandía, Cullera, El Campello and Tamarit earlier; Burriana, Guardamar and Mareny restored to Pro; 1 archived (La Gola).

Sources for the new rows: [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/la-patacona-costa-del-azahar-valencia-spain.html) (Patacona, Pobla, Port de Sagunt, Peñíscola, Benicàssim, Xeraco), [Unplug](https://www.unplug-kitesurf.com/spots/el-saler-spain) (El Saler), [kitejungle](https://kitejungle.com/kite-places/spain/calp) and [wannakitesurf](https://en.wannakitesurf.com/spot/Europe/Spain/Comunidad_Valenciana/Calpe) (Calpe, Altea), [Barceló guide](https://www.barcelo.com/guia-turismo/en/spain/alicante/things-to-do/surfing-in-alicante/) (Alicante coast), [regional kite page](https://nautica.comunitatvalenciana.com/en/recursos/kitesurfing-and-windsurfing) (Dénia, Burriana), [Zoak](https://en.yumping.com/water-sports/centro-nautico-zoak--e19647740) (Guardamar).

## Build check (4 Nov)

`build_spots.py` on the zone rows: no PROBLEMS; Apple Maps direction check agrees 26 of 26 (Benicàssim faces SSE, Albufereta S, L'Almadrava N: hints set to match).
