# Validation: Portugal north and centre (zone `pt-north-centro`, WHE-166)

Date: 2026-11-12. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Build: `spot-check` on `PT.csv`, no PROBLEMS; Apple Maps agrees 19, corrected 1 (Óbidos, hint N still right), uncertain 4 (two are in this zone: Murtosa and Estacas, see below).
Counts for the zone: 8 → 13 rows (free 4 → 4, Pro 4 → 8, archived 0 → 1), 12 live spots.
Past work: `git log` on `PT.csv` shows only the 22 Oct web pass and the Windy cross-check (Matosinhos added). Nothing in
`TO_CONFIRM.md` beyond the open questions answered below. No earlier check redone.

Limits of this pass (said plainly): about 13 web searches plus about 20 guide-page reads, Windy browsed as a visitor
(hover on every kite marker from Caminha to Peniche). No official kite text (Capitania, câmara) found for any spot, so no
`banned` is encoded. Pins come from OSM elements; not checked on satellite (Chrome used for Windy only).

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Viana do Castelo – Cabedelo | ok (notes) | `w1384166636`, faces W (274°), Apple Maps agrees | None found | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/viana-do-castelo-regiao-norte-portugal.html): flat by the big breakwater, rocks in the water. [Wannakitesurf](http://en.wannakitesurf.com/spot/Europe/Portugal/Viana_do_Castelo/Cabedelo/): N thermal above 25 kn, school on site. Schools: Kite Voodoo, Vianalocals, Viana Beach Center. Windy 5 stars |
| Esposende – Ofir | ok (notes) | `w340980132` (sea beach, 267°, agrees). The lagoon itself has no OSM element | Nature reserve, boat access only | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/esposende-lagoa-regiao-norte-portugal.html): knee-deep lagoon, boat transfer from Esposende port by the school, current and boat traffic at the mouth. [Kite Control / thekitespot page](https://locations.thekitespot.com/locations/kitesurf-esposende-cavado-river-portugal). Windy "Esposende River" 4 stars |
| Murtosa – Ria de Aveiro | ok (notes) | `w1107052996` = Praia do Bico, with an OSM kitesurfing pitch next to it. Apple Maps check uncertain (water at 294° vs OSM 241°): the lagoon shore bends; the pitch node sits on this beach, kept | None found | [Guide, Bico](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/bico-regiao-centro-portugal.html): standing depth, S winter wind onshore, summer thermal, cable downwind of the road launch, mussels. [Kiteforum](https://se.kiteforum.com/kitesurf/spot/ria_de_aveiro___cais_do_bico). Clube Nortada school ([listing](https://www.manawa.com/en-GB/activity/portugal/aveiro/kitesurfing/kitesurfing-lessons-and-courses-in-murtosa/8041)). Windy "Murtosa" 3 and "Bico" 1, same place. `not-low` kept: ankle deep at low tide |
| Lagoa de Óbidos | ok (notes) | `n1828415085`, unchanged | Summer closure near the mouth reported by a guide only; no official text found, no ban encoded | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/foz-do-arelho-regiao-centro-portugal.html) and [Kite Control](https://francois-berck-kitecontrol.squarespace.com/kitesurf-spot-portugal-obidos-kite-control); Escola de Vela da Lagoa teaches kite. Windy "Foz do Arelho" 5 stars |
| Caminha – Moledo (Pro) | ok (notes) | `w1474542134`, unchanged, agrees | None found | [Kite Control school at Moledo beach](https://francois-berck-kitecontrol.squarespace.com/en/kitesurf-moledo-portugal-kite-control): nortada May–Oct, flat protected areas and sandbanks; [Unplug](https://www.unplug-kitesurf.com/spots/moledo-beach-portugal). Windy "Moledo" 4 stars. Stays Pro (tier is Ben's call) |
| Matosinhos (Pro) | ok (notes) | `w338635402`, unchanged | **Summer ban reported by two guides, no official text.** Search of Capitania / câmara found only water-quality closures and a 2020–21 Covid edital: not encoded | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/matosinhos-regiao-norte-portugal.html): S best, mid-low tide, poor water, "banned in summer". Earlier pass: wannakitesurf. Windy 5 stars |
| Peniche – Baleal (Pro) | ok (notes), 1 question | `w138709494`, unchanged | Kiteforum: kiting not allowed in the swimming zones in July–August | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/baleal_bay), [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/baleal-regiao-centro-portugal.html), Unplug. Windy "Peniche" 5 stars. Question: the guides' "Baleal Bay" is the south bay (Peniche kite centre at the south end, Praia do Cerro), our pin is the north side. Kept: no source says the north side fails. In `TO_CONFIRM.md` |
| Aveiro – Praia da Barra | **archived** | `w168740954` | – | No kite source found (forecast pages only). Archived, easy to revive. Windy "Aveiro Barra" 3 stars: unrated-style bar, no local source |

## Added as Pro from the Windy list

| Spot | Pin | Why it goes in |
|---|---|---|
| Foz do Douro – Cabedelo | `w1224542321` | Windy "Foz do Douro" 3 stars; [Kiteforum](https://se.kiteforum.com/kitesurf/spot/cabedelo_porto___foz_do_douro): N–NW, flat water on the river bank, ships and the mole, intermediate to expert |
| Vila Praia de Âncora | `r4830178` | Windy "Ancora" 4 stars; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ancora-regiao-norte-portugal.html): S–SW only, launch left of the south breakwater |
| Furadouro | `w440122681` | Windy 3 stars; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/furadouro-regiao-centro-portugal.html): kiteable in both usual winds, few riders, shorebreak at high tide. One source |
| Aveiro – Estacas (Costa Nova ria) | `w355335635`, faces E (88°); Apple Maps uncertain (135°), the ria shore bends, OSM kitesurfing pitches sit on it | Windy "Costa Nova" 3 stars; [wannakitesurf](http://en.wannakitesurf.com/spot/Europe/Portugal/Aveiro/Costa_Nova__lagoon_/) and [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/estacas-regiao-centro-portugal.html); OSM kitesurfing pitches next to it |
| Praia da Vieira | `r6196011` | Windy 2 stars; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/praia-da-vieira-regiao-centro-portugal.html): strong nortada plus swell, few locals. One source |

## Windy, both ways (browsed as a visitor, 12 Nov, every kite marker hovered, Caminha to Peniche)

20 kite markers in the zone (Figueira da Foz shows two icons on one name, counted once). Matched to ours: 8
(Moledo, Viana, Esposende River, Matosinhos, Murtosa + Bico, Aveiro Barra, Foz do Arelho, Peniche). Added as Pro: 5.
Left out: 6.

| Windy marker (stars) | Ours |
|---|---|
| Moledo (4) | Caminha – Moledo |
| Viana do Castelo (5) | Viana do Castelo – Cabedelo |
| Esposende River (4) | Esposende – Ofir |
| Matosinhos (5) | Matosinhos |
| Murtosa (3), Bico (1) | Murtosa – Ria de Aveiro (Bico is the beach we pin) |
| Aveiro Barra (3) | Aveiro – Praia da Barra (now archived) |
| Foz do Arelho (5) | Lagoa de Óbidos |
| Peniche (5) | Peniche – Baleal |
| Ancora (4) | **added (Pro)** |
| Foz do Douro (3) | **added (Pro)** |
| Furadouro (3) | **added (Pro)** |
| Costa Nova (3) | **added (Pro)** as Estacas |
| Praia da Vieira (2) | **added (Pro)** |
| Afife (3) | left out: surf beach, the guide says it "belongs to the surfers"; no kite source |
| Espinho (5) | left out: only Unplug (N/S, intermediate); no source says which of the Espinho beaches people ride, so it can't be pinned |
| Maceda (2) | left out: guide describes a deserted surf beach behind an airbase, no kite wording, no wind given |
| Figueira da Foz (5) | left out: the guide says the launch is behind the breakwater at Praia da Cova but sessions are "a handful per year" and it is a surf break; Cabedelo / Cova beaches are ambiguous, so no pin |
| Pedrógão (2) | left out: no kite source at all |
| Praia do Norte, Nazaré (5) | left out: giant-wave surf break, no kite source for that beach; Nazaré kite listings give no launch |

Ours → Windy: every one of our 8 has a marker. Windy positions were used only to learn that spots exist, never for pins.

Gap: Windy shows 20 markers, we now have 12 live spots. The 6 missing are surf beaches or have no usable local source
(reasons above); several Windy stars here mix surf and kite.
