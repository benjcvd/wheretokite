# Validation: Sardinia (it-sardegna, WHE-169)

Done 14 Nov 2026. Windy browsed as a visitor (hover on kite markers: names and stars only, zoom 9–10); pins
come from OSM beach elements, never from Windy. Sources are schools, tourism pages and spot guides found by web
search (no Windy / Windguru / Windfinder / Kite Croissant). No ban is encoded: the only official text found
(Porto Pollo, order 38/2016) bans kites in the bay, not at the Porto Liscia pin; everything else is in notes.
Build on the 18 Sardinia rows: no PROBLEMS, Apple Maps agrees on all 18.

## Spots we had (9)

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Porto Pollo | basic | fixed (notes) | Capitaneria di Porto La Maddalena order 38/2016 (PDF on bussola.s3...): no kites in the Porto Pollo bay Easter Sunday–10 Nov, buoyed kite corridor at Porto Liscia, 200 m rule; kitesurfing.it + kitesurftheworld.com: Porto Liscia is the kite zone; matosurf.com: bay is windsurf. Pin = OSM `sport=kitesurfing` bay Porto Liscia, faces W (Apple agrees). |
| Punta Trettu | basic | ok | ProKite, Zena Kite School, Kite Village, KiteGeneration all on site; guides: flat shallow lagoon, NW and SE, launch only from kite beach; ProKite page: private area with rescue boat in season. Cape pin snapped to NNE shore, Apple agrees. |
| Porto Botte | basic | ok | kitehousesardinia.com + jerrykitesurf.com: flat/chop bay, NW, schools (il Fortino for freestyle). Pin = OSM beach way (Nominatim), faces WSW, hint SW. |
| Cagliari – Poetto | basic | fixed (notes) | Hyperisland school: usable all year except the bathing season (it says 15 Jun–15 Sep, Comune rule); kitesurf.it/windsurfsardinia: summer needs launch corridor, none at Poetto; kitesurfing.it page. Dates differ between sources and no official text found, so no ban encoded (worst case in notes). OSM beach r14404160, SE, Apple agrees. |
| San Teodoro – La Cinta | basic | ok | San Teodoro municipality page (kite zone authorised by the marine park), KiteGym + Kitesurf San Teodoro schools; kite area mid-beach. OSM way 102780629 faces E, Apple agrees. |
| Putzu Idu | basic | ok | Capo Mannu Kite School (since 2003, FIV/CONI instructors), sardegnaturismo.it (beach sheltered from mistral, all levels), windsurfsardinia (good base, steady wind). OSM beach way via Nominatim, faces WSW. |
| Funtanamare | pro | ok | kitegeneration.com, spotnetz, lets-kite, jerrykitesurf: mistral wave spot, rocks 100 m off, strong currents, no lessons on site, intermediate to advanced. OSM beach w1086210375 faces WNW. |
| Platamona | pro | ok (pin weak) | kiteloopers + kite-and-windsurfing-guide + kiteforum: maestrale side-on, schools with boats in season, corridors by schools. Pin is a Nominatim place node 93 m from shore (no beach element found near it while Overpass was down): faces N, Apple agrees. To redo with a beach way. |
| Rena Majore | pro | ok | kiteforum: NW best, rocks both sides, tricky entry, advanced (checked 24 Oct); sardegnaturismo: kite/windsurf beach with maestrale. No kite school on the beach. OSM w119020437. |

## Windy, both ways (browsed 14 Nov 2026)

Windy → ours (29 kite markers in Sardinia):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Porto Pollo (5) | Porto Pollo | matched |
| Punta Trettu (5) | Punta Trettu | matched |
| Porto Botte (5) | Porto Botte | matched |
| Cagliari (5) | Cagliari – Poetto | matched |
| La Cinta (5) | San Teodoro – La Cinta | matched |
| Fontanamare (4) | Funtanamare | matched |
| Rena Majore (5) | Rena Majore | matched |
| Petrol Beach (4) | Cagliari – Petrol Beach | **added (Pro)**, OSM w589672450; kitesurfing.it (only school, launch corridor), prokitesardegna, kitezone.it |
| La Caletta (5) | La Caletta (Siniscola) | **added (Pro)**, OSM n648866767; Kitesurf La Caletta + Active Kite Sardinia schools, kitesurfing.it |
| Villasimius (5) | Villasimius – Campulongu | **added (Pro)**, OSM w367206115; sardegnaturismo.it kite page (lift service in high season), kitegeneration guide (Campulongu W-SW, Porto Giunco NE) |
| Capo Mannu (5) | Capo Mannu | **added (Pro)**, OSM cape n5375888619 (2.2 km from Putzu Idu); Capo Mannu Kite School, breeza, surftribe: wave spot, experts |
| Porto Pino (5) | Porto Pino | **added (Pro)**, OSM w137708402; kitehousesardinia + kitezone.it: school with authorised zone at Lido Oasi Azzurra 1 Jun–30 Sep for its guests, summer open kiting not allowed |
| Chia (5) | Chia | **added (Pro)**, OSM w137839773; prokitesardegna (school, lift in summer), jerrykitesurf (SE, NE, SW; crowded Jun–Sep) |
| Vignola (5) | Vignola Mare | **added (Pro)**, OSM w119142991; Vignola Sports school, kiteforum, tabularasateam.it: steadiest wind of the north shore, small kite area |
| San Pietro (5) | Valledoria – La Foce | **added (Pro)**, OSM beach Pirotto w119752405 (about 750 m west of Camping La Foce, where kiteforum puts the entry); prokitesardegna + kiteforum: lagoon, school, shop |
| Funtana Meiga (4) | Funtana Meiga | **added (Pro)**, OSM w72445524; surftribe spot guide (alternative to Capo Mannu in big mistral); only one source, no school |
| Mari Ermi (5) | – | left out: no kite source found (Sinis, next to Funtana Meiga); second look |
| Porto Ferro (5) | – | left out: surf beach; only an old windsurf guide mentions kite schools, local schools there are surf (Bonga, Ocean Tribe) |
| Alghero (5) | – | left out: lets-kite / kiteguide say kite schools run in summer on the long beach south of the centre, but no OSM element could be tied to where riders launch |
| Isola Rossa (5) | – | left out: name only in a school's spot list, no details or school |
| Vecchie Saline (5) | – | left out: name only in a school's spot list (Olbia, "Punta Saline"), nothing else |
| Capo Comino (4) | – | left out: no local source found (Cardedu listed instead as an east-coast spot by a school) |
| Geremeas (4) | – | left out: jerrykitesurf blog only (SW best, intermediate+), no school or club, not pinned |
| Pula (4) | – | left out: no source found |
| Porto Pirastu (2) | – | left out: only a name in a winter list |
| San Giovanni (2) | – | left out: no source (a municipality name, Punta Trettu is there) |
| Mugoni (3) | – | left out: no source found |
| Maritza (2), Marina di Sorso (2) | – | left out: same coast as Platamona, names only in a school list, no kite details |

Ours → Windy: all 9 original spots have a marker except **Putzu Idu** (nearest markers are Capo Mannu and Mari Ermi, a few km north).

Counts: Windy markers 29; matched 7 (plus Putzu Idu has none); added as Pro 9; left out 13.
Our spots: 9 (6 free, 3 Pro) → 18 (6 free, 12 Pro, 0 archived).

Gap: Windy still shows 13 more markers than we kept. Most are 2–4 star beaches or names that only appear in school lists, with no local text saying people kite there. They are second-look candidates (Alghero, Mari Ermi, Geremeas first).

## Open points (also in TO_CONFIRM.md)

- Platamona pin is a place node: redo on a beach way once Overpass answers.
- Porto Pollo: our pin is the Porto Liscia kite zone, but the site portopollo.com says the dedicated zone is on the east side of the bay: checked against the 2016 order only.
- Porto Pino summer access is for school guests only; kept Pro with the rule in notes (not official text in hand).
- Villasimius pin is Campulongu; Porto Giunco (r1851526) is a beginner NE alternative 1.5 km away.
