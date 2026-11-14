# Validation: Lisbon area and Madeira (zone `pt-lisboa-madeira`, WHE-167)

Date: 2026-11-12. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: `PT.csv` had a web-verified pass (22 Oct, 3e28a79) and a Windy cross-check (98f328b); open questions in
`TO_CONFIRM.md` (Portugal pass). Those sources are reused, plus fresh searches (about 16 of 25).

Limits (said plainly): pins come from the OSM elements already in the CSV; I did not eyeball them on satellite.
Overpass was down for most of the session, so I could not run `osm_lookup near`, only name searches. No official kite-zone
text (Capitania do Porto de Lisboa, Cascais, Almada) was found for any spot.

## Our 6 spots

| Spot | Verdict | Pin / facing | Rules | Sources and notes |
|---|---|---|---|---|
| Guincho | fixed (notes) | OSM `w147727446`, unchanged | None official. One guide says a permit or club membership may be needed; the beach is inside the Sintra-Cascais natural park. Kept in notes | Schools on the beach: [Gustykite](https://www.timeout.pt/lisboa/pt/desporto/gustykite), [Nortada Aventura / Kitesurf Adventures](https://visitportugal.com/en/node/156414); guides [Kitejungle](https://kitejungle.com/kite-places/portugal/praia-do-guincho), [unplug](https://www.unplug-kitesurf.com/spots/guincho-portugal), [kiteforum](https://se.kiteforum.com/kitesurf/spot/guincho). Windy 5 stars |
| Fonte da Telha | fixed (notes) | `w222678478`, unchanged | None official. Guide: [Nova Vaga is the official kite beach](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/nova-vaga-kitebeach-setubal-peninsula-portugal.html), lifeguards may move kiters elsewhere. Schools are on Fonte da Telha, so it stays; note says ride away from the crowd | [Wind Spirit Club](https://app.ikointl.com/school/portugal/praia-da-fonte-da-telha/wind-spirit-club), Gustykite base on the beach ([listing](https://www.checkyeti.com/en/d/1532/11649)), [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/fonte-da-telha-setubal-peninsula-portugal.html). Windy 5 stars |
| Alcochete | fixed (notes) | `w255048764`, unchanged | None found | [Time Out Lisboa](https://www.timeout.pt/lisboa/pt/atraccoes/praia-dos-moinhos): Alkitesurf school at Praia dos Moinhos; [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/alcochete-setubal-peninsula-portugal.html). Windy 4 stars. `not-low` question stays in TO_CONFIRM (no new source) |
| Lagoa de Albufeira | fixed (notes) | `w8136034`, unchanged | None found; guides warn about swimmers in summer | School on site: [Meira Pro Center / Escola Rui Meira](https://lifecooler.com/artigo/comer/pro-center-rui-meira/381213); [kiteforum](https://se.kiteforum.com/kitesurf/spot/lagoa_de_albufeira), [wannakitesurf](https://wannakitesurf.com/spot/Europe/Portugal/Setubal/Lagoa_de_Albufeira). Windy 5 stars |
| Santa Cruz (Pro) | ok | `w25695668`, unchanged | None found | Two sources from the earlier pass (unplug, kiteforum); [unplug page](https://www.unplug-kitesurf.com/spots/santa-cruz-portugal) re-read: waves, best Apr–Sep, big car park north of town. No school found on the beach itself this time. Windy 5 stars |
| Porto Santo | fixed (notes) | `w142721877`, unchanged (the question of where on the 9 km beach people launch stays open) | None found | [unplug](https://www.unplug-kitesurf.com/spots/ilha-de-porto-santo-porto-santo-portugal): N wind side-offshore, gusty in summer, no rescue, very experienced only; [Visit Madeira](https://visitmadeira.com/en/what-to-do/sea-lovers/activities/windsurf/) lists Porto Santo as a kite area; school lessons listed on [Musement](https://www.musement.com/us/porto-santo/porto-santo-kite-surfing-13-153902). Windy 5 stars |

Build check (`spot-check` on `PT.csv`, 12 Nov): no PROBLEMS. All 12 spots of this zone agree with Apple Maps except Lagoa de Albufeira, `uncertain` (water arc 45° off the N hint): a lagoon behind a sandbar, `hint` N kept. Praia Formosa and Porto Santo need a ferry from the mainland (expected, islands). Overpass was flaky, so the build took several retries.

## Windy, both ways (browsed as a visitor, 12 Nov, kite markers hovered)

Windy kite markers in the zone: 19 (17 mainland between Santa Cruz and Comporta, 2 in Madeira). Matched to ours: 6.
Ours not on Windy: none (all 6 have a marker).

| Windy marker (stars) | Result |
|---|---|
| Santa Cruz (5), Guincho (5), Fonte da Telha (5), Lagoa de Albufeira (5), Alcochete (4), Porto Santo (5) | ours |
| Nova Vaga (4) | **added (Pro)**, `w222678470`; official kite beach ([guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/nova-vaga-kitebeach-setubal-peninsula-portugal.html), [kiteforum](https://se.kiteforum.com/kitesurf/spot/nova_vaga), [unplug](https://www.unplug-kitesurf.com/spots/nova-vaga-portugal), Boarder Club school) |
| Cova do Vapor (4) | **added (Pro)**, `w222122955`; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/sao-joao-cova-do-vapor-setubal-peninsula-portugal.html), [unplug](https://www.unplug-kitesurf.com/spots/cova-do-vapor-portugal). Dirty water, rules unclear: said in notes |
| Carcavelos (5) | **added (Pro)**, `w157464438`; [Visit Portugal](https://www.visitportugal.com/en/content/windsurfing-and-kitesurfing), [wannakitesurf](https://en.wannakitesurf.com/spot/Europe/Portugal/Lisboa/Carcavelos); winter-only per one guide |
| Oeiras (5) | **added (Pro)** as Oeiras – Santo Amaro, `w180126358`; [Time Out Lisboa](https://www.timeout.pt/lisboa/pt/atraccoes/praia-de-santo-amaro-de-oeiras). Marker name is the town: I picked the beach the source names |
| Comporta (3) | **added (Pro)**, `w208100412`; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/comporta-alentejo-portugal.html), one source |
| Praia Formosa (3, Madeira) | **added (Pro)**, `w162445881`; [Visit Madeira](https://visitmadeira.com/en/what-to-do/sea-lovers/activities/windsurf/), [Visit Portugal](https://www.visitportugal.com/en/content/windsurfing-and-kitesurfing) name it as a kite area |
| Costa da Caparica (5) | left out: the town beaches, no spot of their own; the kite beaches on that coast are Nova Vaga, Cova do Vapor and Fonte da Telha (all in). Guides say kiting is for Nova Vaga only |
| Ribeira das Ilhas (5) | left out: famous surf wave; [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ribeira-d-ilhas-grande-lisboa-portugal.html) says windsurf only, rocky launch (only unplug lists it, for experts) |
| Praia Grande (4) | left out: no kite source found (the kiteforum hit is the Algarve beach of the same name) |
| Tróia (4) | left out: sources exist ([kiteforum](https://se.kiteforum.com/kitesurf/spot/troia), [wannakitesurf](https://en.wannakitesurf.com/spot/Europe/Portugal/Setubal/SolTroia)) but the only OSM beach is on the ocean side and I could not confirm where people ride (Overpass down): not pinned. To retry |
| Sesimbra (5) | left out: no kite source for the town beach; kiting in the area is Lagoa de Albufeira (ours) |
| Barreiro (4), Ponta dos Corvos (3) | left out: Barreiro has no source; Ponta dos Corvos has only a guide page ("brown waters") and no OSM beach by that name |
| Not in this zone | Foz do Arelho, Peniche, Praia Areia Branca (north/centre card); Carvalhal (2), Aberta Nova (4), Santo André (2), Sines (3), São Torpes (3): Alentejo coast, belongs to no zone yet |

Gap: Windy shows 19 markers against our 6; after this pass we have 12. The rest are surf breaks, estuary or town
beaches without a kite source, or not pinnable.

## Open
- Tróia: needs a kite-area pin (retry when Overpass is back).
- Praia Grande, Barreiro, Ponta dos Corvos, Sesimbra: no source, left out.
- Alentejo coast (Sines to Carvalhal): no zone; suggest a card.
