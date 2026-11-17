# Validation: southern Italy and Sicily (it-south, WHE-170)

Done 2026-11-14. Windy browsed as a visitor (hover on the kite markers, names and stars only; positions never copied).
Past work: Sicily 3f0c078 (Santa Maria del Focallo added), Puglia and Calabria rows from the first catalogue waves; `TO_CONFIRM.md`
(Italy section) listed Gizzeria, Torre Canne and Margherita di Savoia as "pinned from the town name". No earlier hand check of this zone.
Not eyeballed on satellite. Overpass was flaky (429s, timeouts): pins come from the OSM cache, Nominatim and `osm_lookup near`.
Build on the 16 rows of the zone (`/tmp` subset of `IT.csv`, main OSM cache): no PROBLEMS, Apple Maps agrees on 16 of 16.
The zone covers the CSV regions Puglia, Calabria and Sicilia (not Sardegna). The Windy markers of Molise (Termoli, Campomarino) are out of the zone and not counted.

## Spots (the 8 we had)

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Lo Stagnone (Marsala) | basic | ok, notes fixed, **question** | Real and famous: schools KiteClub Marsala, Sicily Kite Academy, WindBusters, Kitesurf Stagnone (their sites), Stagnone Kite Games guide. Pin `osm:n12407041259`, faces WSW (238°), agrees. **Legal status is contested**: tp24.it (27 Jul 2024) says the rules are in harbour-office ordinance 1/2019 and the reserve regulation of 24 Jun 2000; tp24.it (7 Nov 2026) reports Legambiente reading the new Natura 2000 measures for ITA010001 as a kite ban. That is an advocacy reading, not an official text, and I found no official ordinance text, so no `banned` is encoded. Kept as a free spot (schools operate openly); notes now say it's contested. In TO_CONFIRM. |
| Mazara del Vallo – Capo Feto | basic | ok, notes fixed | School on the spot: Kitesurf Mazara Kite School (IKO centre; own site, kitesurfing.it, KitesurfScout, TripAdvisor). Guides kitegirlsitalia, pkrstagnone.it. NW thermal 16–19 kn, works W and SE; tramontana (N) offshore and gusty, dangerous. Pin `osm:w154960274`, faces S (188°), agrees with hint SW. Notes now carry the tramontana warning and the sandy access track. |
| Santa Maria del Focallo | basic | ok, notes fixed | Schools Floripa (kitesurfing.it, nauticareport), Sicily Kite School; guides kiteloopers, einfachkiten.de. W thermal April–October; a kite zone is marked June–September, keep about 200 m out (guides, not an official text, so no ban). Pin `osm:w381744232`, faces SW (216°), agrees. |
| Gizzeria – Hang Loose Beach | basic | ok, notes fixed | School Hang Loose Beach (hangloosebeach.it, open 1 Apr–30 Sep; kitesurfing.it), kitepoint.it and kiteloopers guides: thermal, about 17 kn average. Pin from the town name (`q:Gizzeria Lido`), the build moves it to the W-facing shore (233°), agrees. Left as is: the pin sits 30 m from the water. |
| Porto Cesareo – Torre Lapillo | basic | ok, notes fixed | Schools Freedome, Alex Kite, Locals Salento Kitesurf, La Strea school; kitesurfing.it spot page: best S to WNW, waves over a reef on the north side, flat Strea lagoon to the south. The old note said "kite corridors only" in summer: no Porto Cesareo ordinance found (searched), so that was unsourced and is now "check the local rules". Pin `osm:r3205744`, faces S (187°), 121 m from the water, agrees with hint SW. |
| Torre Canne | basic | ok, notes fixed | School Scuola Kitesurf Puglia, since 2011 (kitesurfy.com spot guide, placenpeople listing, school page); Parco delle Dune Costiere gave a favourable opinion to a kite association in 2014. Same unsourced "corridors only" wording replaced. Pin from the town name (`q:Torre Canne`, a village node): 222 m from the water, faces E (79°), agrees with hint NE. A better beach element would be tidier; left for a second pass. |
| Margherita di Savoia | basic | ok, notes fixed | Schools Wind People (Lido Valerio, kitesurfing.it), Garganosurf; Unplug and Surftribe spot pages: chop and small waves, long sandy beach. Pin from the town name, moved to the NE-facing shore (36°), agrees. |
| Manfredonia – Siponto | pro | ok | School Banzai Wave Academy (own site, bluedreaming.it; IKO / OPES / CONI), at Scalo dei Saraceni about 5 km away, office at Siponto; Unplug page. Pin `osm:n493697888`, faces ESE (107°), 272 m from the water, agrees. Stays Pro (close to Margherita, same gulf). Windy has a 4-star "Manfredonia" marker here. |

## Windy, both ways (browsed 2026-11-14, zooms 8–10: Gargano to Salento, Calabria, Strait of Messina, Sicily)

Windy → ours (44 kite markers read in the zone: 21 Puglia, 19 Calabria, 4 Sicily):

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Porto Cesareo (5) | Porto Cesareo – Torre Lapillo | matched |
| Torre Canne (4) | Torre Canne | matched |
| Margherita di Savoia (3) | Margherita di Savoia | matched |
| Manfredonia (4) | Manfredonia – Siponto | matched |
| Gizzeria Lido (4) | Gizzeria – Hang Loose Beach | matched |
| Punta Pellaro (5) | none | **added (Pro)** `osm:w448166364`: four schools on the spit (NewKiteZone, Kiteloop, SeaWind, Sway), Visit Reggio Calabria guide (Oct 2026). Faces NNW (329°), Apple Maps agrees. |
| Spiaggia Lunga, Vieste (5) | none | **added (Pro)** `osm:w89583921` (Scialmarino, the name some guides use for the same beach): Gargano Kitesurf School, SurfConcept, Let's Kite guide. Faces NE (34°), agrees. |
| San Foca (5) | none | **added (Pro)** `osm:w611308428`: Kite Salento, Locals Salento Kitesurf, AK; Salento Kiter spot page. Faces NE (38°), agrees. Pin is the beach element next to the San Foca resorts; I could not tell which beach the school corridor is on. |
| Alimini (4) | none | **added (Pro)** `osm:w359667847`: AK school at Voi Alimini (IKO), Unplug. Faces E, agrees. |
| Apani (4) | none | **added (Pro)** `osm:w484762138`: Let's Kite spot guide, Puglia school listing naming it a regular tramontana / maestrale spot. No school on the beach. Faces NE, agrees. |
| Capo Peloro (3) | none | **added (Pro)** `osm:n683117714` (the cape node): visitcapopeloro.com tourism page, Kite Jungle, Breeza. Experts only, strong current. Faces E (80°), agrees. Pin is the cape, not a beach: check the launch (Il Pilone / Punta del Faro) in a second pass. |
| Baia Verde, Gallipoli (3) | none | **added (Pro) as Lido Pizzo** `osm:n7522558069` (OSM `sport=kitesurfing` pitch, 1.7 km from the Baia Verde marker): school Salento Coast Ovest (FIV and IKO) teaches at Baia Verde or Lido Pizzo. One older Surftribe page says the bay is closed to kites in summer; the school's own site says all year. Kept in notes only. Pitch faces N (349°), agrees; the school says NW–SW winds work, so the sector may be too narrow: second look. |
| Marina di Lesina (3) | none | **added (Pro) as Acquarotta** `osm:n11775800619`: Crazykiter and Gargano Lake Kite schools at Acquarotta, Let's Kite guide. Beach faces NE (42°), agrees. The marker sits by the river-mouth jetty, about 2 km east: same coast, same wind. |
| Steccato di Cutro (3) | none | **left out for now** (reason 4): schools exist (Portokaleo, Ninnedusa; kitesurfcalabria.com says SW/S/SE ideal) but `osm_lookup` found no beach element near the town (Overpass failed twice). Retry when Overpass is healthy. |
| Pizzomunno (3), Mattinata (2), Torre Mileto (2), Zapponeta (1) | none | **left out**: no kite source found in the budget. Pizzomunno is a Vieste town beach, 5 km from Spiaggia Lunga. |
| Barletta (3), Giovinazzo (3), Santo Spirito (2) | none | **left out**: no kite source found. |
| Ostuni (3), Chiatona (3), Marina di Lizzano (3), Lido Denise (2) | none | **left out**: Chiatona / Lizzano have schools listed (Kitesurf Taranto, Blue Sun Beach) but the spot guides describe a reef break for surf and give no kite wind; no source on Ostuni or Lido Denise. Second pass worth doing for Lizzano. |
| Calabria: Reggio Calabria (3), Catona (2), Cannitello (1), Gioia Tauro (2), Joppolo (1), a 1-star marker near Nicotera, Lazzaro (1), Capo Spartivento (1), Brancaleone (3), Ardore (1), Marina di Gioiosa Jonica (1), Badolato Marina (1), Sellia Marina (2) | none | **left out**: no kite source found. Reggio, Catona, Cannitello, Lazzaro are on the same strait coast as Pellaro (under 15 km) with the same wind, and Windy rates most 1–2 stars. |
| Le Castella (3), Capo Rizzuto (3), Contrada Gabella (2), Steccato (see above) | none | **left out**: calabriadascoprire and kitesurfcalabria name Gabella, Strongoli, Cirò Marina and Steccato as spots, but no school or club page for Le Castella or Capo Rizzuto. Gabella (N/NE, 12–35 kn) is a candidate once a school page is found. |
| Pace (2), Tremestrieri (1), Capo Peloro neighbours | none | **left out**: same strait as Capo Peloro, no kite source. |
| Stromboli (5) | none | **left out**: Aeolian volcano island, no kite source found, worst case. |

Ours → Windy: Stagnone, Capo Feto and Santa Maria del Focallo are **not on Windy** (the Sicilian coast has no markers; the only Sicilian
ones are at the Strait of Messina). The other five have a marker.

Counts: 44 Windy markers read, 5 matched, 8 added as Pro, 31 left out. Our spots in the zone: 8 → 16 (7 free, 9 Pro, 0 archived).
Gap: Windy shows 31 markers we don't have. About 20 are 1–2 star markers (Calabrian Ionian coast, Strait of Messina), most with no kite
source I could find in a 25-search budget. The rest are rated 3 stars with a school listed but no kite-specific guide (Chiatona, Lizzano,
Le Castella, Capo Rizzuto, Steccato). A second pass on Calabria and the Taranto gulf is worth a card.
