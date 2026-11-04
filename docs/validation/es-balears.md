# Balearic Islands validation (zone es-balears, WHE-94)

Date: 2026-11-03. Method: [validation README](../../tools/spots/validation/README.md). 7 spots in
`tools/spots/ES.csv`, no change needed. Past work: the rows come from the initial Spain pass and
the 2026-10 trimming (no earlier sourced check, `git log` shows no Balearic-specific commit).

**Limits of this check (said plainly):**
- Pins and directions were read from the last committed build (`Data/spots.json`, Apple Maps check
  `agrees` on all 7). The build could not be re-run today: the Overpass servers timed out
  (504 / SSL errors) for 20+ minutes, so there is no fresh `spot-check` output.
- No official text found for the summer rules (Capitanía Marítima, Govern, ayuntamientos). Per the
  2 Nov rule: assume the worst, keep the ban in `notes`, no `banned` field (no official source).
- Satellite check of each pin was not done (Windy was used for markers only).

## Rules for the whole zone (sources)

- Spain's tourism board: Pollença Bay is ridden year-round; Alcúdia Bay has a summer ban because
  of bathers; Ibiza only November–May; Ses Illetes (Formentera) banned May–October in the Ses Salines
  park. [spain.info](https://www.spain.info/en/discover-spain/flying-over-balearic-islands-best-kitesurfing-spots/)
- Mallorca tourism guide: kitesurfing "not officially allowed" in high season along the Alcúdia
  stretch (bathing zones), best outside the main season.
  [mallorca.com](https://www.mallorca.com/en/guide/activities/sport/wassersport/kitesurfen-mallorca)
- Govern balear bulletin (BOIB 2025, no. 38): public notice for an application to run a kitesurf
  channel at Playa de Sa Marina by a kitesurf professionals' association. Outcome not readable.
  [BOIB](https://intranet.caib.es/eboibfront/pdf/es/2025/38/1185905)
- Local press: bather / kiter dispute at Sa Marina; Guardia Civil fines for kiting in bathing zones
  ([Última Hora tag page](https://www.ultimahora.es/etiqueta/kitesurf.html)).

## Spot by spot

| Spot | Real and known (2 sources) | Pin / direction | Rules | Verdict |
|---|---|---|---|---|
| Mallorca – Pollença (Sa Marina), basic | spain.info (Pollença Bay, year-round); mallorca.com guide; Windy.app spot "Pollenca Kite Spot"; schools in Pollença area (Mallorca Kiteboarding, Cuatro Vientos) | Beach way `w100786510`, 39.873 / 3.086, faces ENE (63°), hint E, Apple Maps agrees | Summer: notes say authorised zone; BOIB notice shows the Sa Marina channel was still being requested in 2025, so the status is not settled. Notes already neutral | ok. TO_CONFIRM question on Can Cullerassa settled: stays on Sa Marina (see below) |
| Mallorca – Son Serra de Marina, basic | mallorca.com (number one Oct–May); unplug-kitesurf spot page; kite-and-windsurfing-guide page; Windy marker | 39.732 / 3.236, faces NNE (31°), hint N, agrees | No official kite zone found. Notes say summer restrictions | ok |
| Mallorca – Platja de Muro, pro | Mallorca school listings (Cuatro Vientos, Water Sports Mallorca on Yumping); kite-and-windsurfing-guide page; Windy marker | 39.808 / 3.119, faces ENE (77°), hint NE, agrees | Muro is in the bathing-zone stretch; notes already say "small authorised channel, best off-season" | ok, stays pro |
| Mallorca – Es Barcarès (Alcúdia), pro | unplug-kitesurf and Kiteforum spot pages (N–E winds, thermal May–Oct, tramontana winter) | 39.863 / 3.121, faces N (3°), hint N, agrees | Summer restriction in notes | ok, stays pro (only 3 km from Sa Marina, different shore) |
| Mallorca – Platja d'Alcúdia, pro | spain.info (Alcúdia Bay, N or E wind, summer ban); mallorca.com | 39.835 / 3.126, faces SE (127°), hint E, agrees | Summer ban, notes only | ok, stays pro |
| Menorca – Cala Tirant, basic | spain.info (tramuntana); windfornells blog (best known kite spot of Menorca, launch areas in summer); Kiteforum; kite-and-windsurfing-guide | 40.045 / 4.105, faces N (357°), agrees | Summer: designated launch areas (windfornells) | ok |
| Menorca – Son Bou, pro | spain.info (west wind, best in winter); kite-and-windsurfing-guide (biggest beach, most used by locals, naturist-zone launch in summer); Kiteforum | 39.902 / 4.066, faces SW (216°), hint S, agrees | Summer launch area only (notes) | ok, stays pro |

Can Cullerassa (Pollença): sources only call it a windsurf beach with strong easterlies; no kite
zone source. Assumed worst case: no change, Sa Marina stays as the Pollença pin.

## Ibiza and Formentera

No row added. Sources: spain.info says Ibiza kiting is allowed only November–May, Cala Martina has a
small beach with launch only from a boat per one guide, and no kite school was found on Ibiza or
Formentera. Ses Illetes is banned May–October (park). Rule of 2 Nov: unclear → not added. Es Cavallet:
only a windsurf-guide mention, no kite reputation. Es Trucadors (Formentera): a Windy marker, but
the same park rules and no second source.

## Windy, both ways (visitor, 3 Nov, kite layer)

Windy markers (name = Windy's nearest-place label, not a position we use):

| Windy marker | Our spot |
|---|---|
| Ses Veles, Sa Marina (Alcúdia bay west) | Pollença (Sa Marina) / Es Barcarès |
| ses Casetes des Capellans (Muro) | Platja de Muro |
| Ses Roquetes, Artà (east of the bay) | Son Serra de Marina |
| Llucalari, Alaior (Menorca south) | Son Bou |
| Penyal de sa Miloca, Sant Tomàs (Menorca south) | not ours; 3 km W of Son Bou, same beach family. Not famous separately: Sant Tomàs only named as Son Bou's rough-day alternative |
| Serra des Boc, ses Salines (Fornells, Menorca north) | not ours (Cala Tirant is 4 km W). Fornells stays left out: it is a windsurf bay, the windfornells blog itself says there is no kite centre |
| Windy markers at Cala Rajada, Palma bay (3), Sant Elm / Dragonera (2), Menorca SE, Ibiza (4), Formentera (2) | missing, not added: Palma bay is banned or crowded in summer (spain.info) and none has two kite sources; Ibiza and Formentera see above |

Ours with no Windy marker: Platja d'Alcúdia (marker not distinct from Sa Marina's) and Cala Tirant
(nearest marker is Fornells, 4 km east). Counts: about 18 Windy markers seen across the islands (not all hovered), 4 matched
to our spots, 0 added, 0 archived.

## Windy markers added as Pro (WHE-123, 2026-11-04)

Rule of 4 Nov: a Windy kite marker we don't have goes in as Pro unless one of the four good reasons
applies. Markers re-read as a visitor (hover, kite layer): 17 in the islands, 4 matched to our
spots (Es Barcares, El Buzón ~ Platja de Muro, Son Serra de Marina, Son Bou), 9 added as Pro,
4 left out. Pins are OSM elements, never Windy's positions. Spots: 7 → 16 (3 free, 13 Pro).

**Not yet checked:** `spot-check` could not run (Overpass down on 4 Nov); the Apple Maps direction check of the 9 new rows is still to do.

| Windy marker | Result | Sources (one is enough for Pro) |
|---|---|---|
| Ciudad Jardín (Playa de Palma) | added (Pro) `osm:r2174956` | [unplug-kitesurf spot page](https://www.unplug-kitesurf.com/spots/mallorca-ciudad-jardin-spain) (S/SW winds, winter); [mallorca.com guide](https://www.mallorca.com/en/guide/activities/sport/wassersport/kitesurfen-mallorca) names Playa de Palma a main kite hotspot |
| S'Arenal | added (Pro) `osm:n13825691265` | mallorca.com guide; Club Náutico S'Arenal kite services; Mallorca Magazin 2013 (kiting possible year-round in the Bay of Palma). 7 km from Ciudad Jardín, so a separate launch |
| Santa Ponça | added (Pro) `osm:w5257679` | [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/santa-ponca-mallorca-spain.html): winter spot |
| Sa Rapita | added (Pro) `osm:w57737438` | [unplug-kitesurf](https://www.unplug-kitesurf.com/spots/mallorca-sa-rapita-spain); [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/sa-rapita-mallorca-spain.html); school Cuatro Vientos |
| Punta Prima (Menorca) | added (Pro) `osm:r1581445` | kite-and-windsurfing-guide Punta Prima page: Club Kitesurf Menorca station, Nov–May |
| Playa d'en Bossa (Ibiza) | added (Pro) `osm:w119370890` | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/Ibiza___Playa_d_en_Bossa); Wikiloc (NE/E/SE from October, closed in summer) |
| Cala Martina (Ibiza) | added (Pro) `osm:w132655686` | [unplug-kitesurf](https://www.unplug-kitesurf.com/spots/ibiza-cala-martina-spain) (S/SW, Oct–May); Kiteforum page |
| Ses Illetes (Formentera) | added (Pro) `osm:w737053149` | spain.info (best Balearic spot out of season; park ban May–Oct); Yumping rental at Playa de Illetes |
| Ca Marí / Platja Migjorn (Formentera) | added (Pro) `osm:w1381403167` | [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/platja-migjorn-ca-mari-formentera-spain.html) |
| Son Moll / Cala Rajada | left out: no OSM element fits | Only a webcam page and generic water-sports providers found; no source says kiters launch there and no kite beach can be named |
| Fornells (Menorca) | left out: windsurf only per a local source | windfornells.com says a kite centre is not viable in the bay; Cala Tirant (4 km) is ours |
| Es Carbó (Mallorca) | left out: private beach per a guide | kite-and-windsurfing-guide: beach belongs to a private finca, almost nobody rides; Es Trenc / Sa Ràpita (3 km) is added |
| San Antoni (Ibiza) | left out: no OSM element fits | Only a guide page for "Cala Pinet", not found in OSM; the town beach is a bay of moored boats; no school |

Summer rules: no official text found, so every new row keeps the restriction in `notes` and has no
`banned` field (2 Nov rule). Ibiza is Nov–May only per spain.info; Illetes is banned May–Oct per the park.
