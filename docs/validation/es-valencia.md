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
| Guardamar – Els Tossals (pro) | **archived** | No school, kite zone or rule found for this beach; Guardamar courses don't name it; dune protected area. Worst case. |
| Burriana – El Arenal (pro) | **archived** | One regional guide (S–SW wind) and a shop; no school, no kite zone. Windy shows a Burriana marker, which only tells us it exists. |
| Embalse de La Loteta (basic) | ok | Club Kitesurf La Loteta, 260+ members, hub of Aragón kite ([Zaragoza city](https://zaragoza.es/sede/portal/juventud/info-joven/servicio/noticia/339366)); Cierzo Festival 2025 ([zaragozala](https://zaragozala.com/zaragoza-provincia/la-loteta-acoge-el-cierzo-festival-2025/)); stop on the national circuit ([GoAragon](https://www.goaragon.eu/zaragoza-province-a-sea-of-proposals-in-aquatic-activities/)). Cierzo (NW) along the reservoir, sector 360 kept. Pin at the marina still open in TO_CONFIRM. |

Not verified on satellite (Chrome was used for Windy and the decree only): pins come from OSM elements and
the pipeline's Apple Maps direction check; see the build result below.

## Windy, both ways (markers read by hovering as a visitor, 3 Nov)

Windy markers in the zone's coast, north to south, and our spot:

| Windy marker | Ours |
|---|---|
| Burriana | Burriana (archived) |
| La Patacona, El Saler, El Perelló | Perellonet (El Perelló is the nearest marker); El Saler and Patacona: not added, left out earlier, no kite zone (El Saler park ban) |
| Mareny de Barraquetes | Sueca – Mareny (archived, club-only) |
| El Pollo, Río Júcar (Cullera), Playa de Xeraco, Gandía | missing, not added: no second source gathered, none famous nationally |
| Oliva, El Vergel, El Paquebote | Oliva |
| Denia, Xàbia | Dénia – Les Deveses (Xàbia: missing, not added) |
| Santa Pola (x2), La Ermita | Santa Pola – Tamarit (La Gola archived) |
| Guardamar, Playa de la Mata | Guardamar (archived); La Mata not added |
| La Albufereta, other Alicante/Benidorm/Altea markers | not added |

Ours not on Windy by that name: Arenales del Sol, Embalse de La Loteta (Aragón not browsed).
Windy count in the zone coast: about 22 markers; matched 5 of our 8.

Candidates for a later pass (need two sources each): Cullera, Gandía, Xàbia, Torrevieja – La Mata.
