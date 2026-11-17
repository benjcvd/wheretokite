# Algarve validation (zone pt-algarve, WHE-168)

Date: 2026-11-14. Method: [validation README](../../tools/spots/validation/README.md). Zone: the
Portuguese Algarve (`PT.csv`, region Algarve): 6 spots before, 12 after (4 free before: Meia Praia,
Alvor, Praia de Faro, Manta Rota; 2 Pro: Fuseta, Cabanas).

Past work: PT pass of 2026-10-22 (si-pt-1/2/3), Windy cross-check of the same day; the open Portugal
questions in `TO_CONFIRM.md` (Alvor launch, Ria Formosa ban) are settled below.

**Limits of this check (said plainly):**
- Overpass was slow and refused connections while I worked; pins were checked from the build review
  (Apple Maps direction check) and not eyeballed on satellite (Chrome was used for Windy only).
- The ICNF Ria Formosa zoning table (PDF, Nov 2021) is the one official text on kiting in the park.
  Its text is stored in a form I could not read, so I could not tell which zones allow kiting. No
  `banned` is set anywhere; the notes tell riders to ask.
- Two sources per spot were not always found: those with one source are said so in the table.

## Settled: the two old Portugal questions for this zone

- **Alvor launch.** Schools run a boat from Alvor town to a sandbar in the middle of the lagoon; other
  riders walk a boardwalk from the beach car park (kiteworldwide, a visitor review on IKSA, Unplug).
  No source names "the sandspit by the dunes" or an inner east shore. The pin stays on the lagoon
  (same water either way, the build direction is W); the notes now describe the two real access
  options and the hazards (wannakitesurf: submerged hazards, currents).
- **Ria Formosa kite ban.** Old press (Portugal Resident, undated, about 2008): the navy banned kiting in
  the park after boat owners complained, until zones could be agreed. The ICNF park document lists
  kitesurf per zone (Praia de Faro, Fuseta, Barra de Tavira-Cabanas are in it), forbidden in some and
  allowed with the harbour master's approval in others, but I could not read which. Cabanas de Tavira
  has a marked kite area on the island (about 300 m, school page). Rule of 2 Nov: assume the worst, no
  `banned`, notes say "ask the Capitania de Faro / ICNF (pnrf@icnf.pt)".

## Spot by spot

| Spot | Real and known | Pin / direction | Rules | Verdict |
|---|---|---|---|---|
| Lagos – Meia Praia (basic) | Water Sports Center on Estrada da Meia Praia ([kiterr](https://kiterr.com/kiteschool/active-sports-lagos/)); [kite-and-windsurfing-guide](https://www.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/meia-praia-algarve-portugal.html): offshore N winds, slalom / freeride; Windy marker "Meia Praia" 4 stars | `w1245391449`, unchanged from the 2 Nov pass | None found | fixed (notes): the old text said only "waves can build"; sources agree N wind is offshore, so notes now say so |
| Alvor (basic) | [Unplug](https://www.unplug-kitesurf.com/spots/alvor-portugal), [wannakitesurf](https://en.wannakitesurf.com/spot/Europe/Portugal/Algarve/Ria_do_Alvor), [kiteworldwide](https://kiteworldwide.com/kiteholidays/portugal-lagos/) (VDWS school, waist-deep lagoon), Algarve Kite Center; Windy "Ria de Alvor" 5 stars | `w143915392`, unchanged | None found | fixed (notes: launch, hazards) |
| Praia de Faro (was basic, now **pro**) | Only [kitejungle](https://kitejungle.com/kite-places/portugal/ilha-de-faro) lists the lagoon side; surf schools on the ocean side, **no kite school found**; the ICNF park table lists the beach; Windy "Faro" 5 stars (ocean beach) and "Ria de Faro" 3 stars | `r12567393`, unchanged | Park zoning, see above | fixed: notes now say no kite school and the park rules; moved to Pro because "famous" is not supported by two sources (unclear = no) |
| Manta Rota (basic) | Not re-confirmed: no school or guide for Manta Rota found in this pass (one search). The 22 Oct pass cited the AlturaKites school; Windy marker 4 stars | `w79504187`, unchanged | None found | ok, kept (Windy 4 stars + earlier pass); flagged in the risks |
| Fuseta (Ria Formosa) (pro) | [kite-and-windsurfing-guide Ilha da Fuseta](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ilha-da-fuseta-algarve-portugal.html); lessons and rental on the beach ([checkyeti](https://www.checkyeti.com/en/kite-and-windsurfing/portugal/praia-da-fuseta/windsurfing-kitesurfing)); Clube Naval da Fuzeta hosted a national kiteboard championship ([postal.pt](https://postal.pt/sociedade/2o-campeonato-nacional-de-kiteboard-vai-ser-apresentado-pelo-clube-naval-da-fuzeta/)); Windy "Ilha da Fuseta" 5 stars | `w78427662`, unchanged | Park zoning | ok (stays pro) |
| Cabanas de Tavira (pro) | School with a marked kite area on Ilha de Cabanas ([seabookings](https://www.seabookings.com/experience/kitesurfing-in-tavira), [Unplug](https://www.unplug-kitesurf.com/spots/cabanas-de-tavira-portugal)); Windy 4 stars | `w79509901`, unchanged | Marked kite area per the school | ok (stays pro) |

## Windy, both ways (visitor, 14 Nov, kite layer, names and stars as shown on hover)

25 Windy kite markers between Odeceixe and the Spanish border (Isla Canela, on the Spanish side, is
covered in the Huelva report and not counted).

| Windy marker | Stars | Our spot / decision |
|---|---|---|
| Meia Praia | 4 | Lagos – Meia Praia |
| Ria de Alvor | 5 | Alvor |
| Faro | 5 | Praia de Faro (ocean side) |
| Ilha da Fuseta | 5 | Fuseta |
| Cabanas de Tavira | 4 | Cabanas de Tavira |
| Manta Rota | 4 | Manta Rota |
| Altura | 4 | **added (Pro)**: Altura (Unplug, Kiteforum, lessons page) |
| Monte Gordo | 4 | **added (Pro)**: Monte Gordo (one spot guide) |
| Tonel | 5 | **added (Pro)**: Sagres – Tonel (Unplug, spot guide; experts) |
| Martinhal | 3 | **added (Pro)**: Sagres – Martinhal (Kiteforum, spot guide, Kiterr) |
| Carrapateira | 4 | **added (Pro)**: Carrapateira – Bordeira (Unplug, wannakitesurf, spot guide) |
| Amado | 4 | **added (Pro)**: Carrapateira – Amado (one spot guide, winter) |
| Ria de Faro | 3 | left out: same water as Praia de Faro's lagoon side, which we already have (`hint` N side) |
| Praia de Alvor | 5 | left out: ocean beach 1.3 km from the lagoon; every source I found describes the lagoon, and calls the ocean beaches offshore in the usual N wind; no source names it as a kite beach |
| Ilha da Culatra | 2 | left out: Ria Formosa park, boat access, kite rules unread (assume the worst); rated 2 |
| Ilha de Armona | 2 | left out: same (boat from Olhão, park); rated 2 |
| Ria Formosa (Santa Luzia) | 3 | left out: Tavira lagoon inside the park, no school or town source found |
| Cordoama | 5 | left out: no source calls it a kite spot (surf pages only) |
| Vale Figueiras | 2 | left out: rated 2, no source read, surf beach |
| Luz | 4 | left out: no school or guide found (the Lagos schools meet elsewhere) |
| Praia da Rocha | 5 | left out: no kite source found |
| Ferragudo | 5 | left out: the one guide says sheltered by breakwaters, poor river water and "hardly anyone goes in"; two possible beaches (Angrinha, Molhe), so no safe pin |
| Praia dos Salgados | 3 | left out: no source found |
| Albufeira | 5 | left out: no source found (the "Albufeira" kite pages are the lagoon near Sesimbra) |
| Vila Real de Santo António | 4 | left out: no source; 4 km west of Monte Gordo's beach, same coast |

Our spots on Windy: all 6 have a marker (Praia de Faro two). Windy shows 25 markers, we now have 12
spots (6 matched, 6 added). The gap of 13 is the south-coast resort beaches (Rocha, Albufeira, Luz,
Salgados, Ferragudo) where I found no kite source, the Ria Formosa islands, and surf beaches of the
west coast. Several of these are worth a second look with a local source (Ben or a later pass).

Counts: Windy markers 25; matched 6; added 6; left out 13.
Spots before: 4 free + 2 Pro + 0 archived. After: 3 free + 9 Pro + 0 archived.
