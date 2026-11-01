# Spots to confirm locally

Questions the curation agents could not settle from the web or the maps. Answer what you
know; fixes go in the country CSV (see README.md), then rebuild. Remove a line once settled.

Wave 2 (Italy, Adriatic, Greece, Black Sea, Cyprus, Nordics, Baltics, Central Europe) was
curated **without web verification** (knowledge + OpenStreetMap + Apple Maps checks): a
second pass with web research is worth doing.

## France — Channel / Atlantic (FR-atlantic.csv)
- Bassin d'Arcachon – La Hume: closed during the hunting season (Oct–Nov)?
- Arcachon – Les Arbousiers, Claouey, Andernos – Le Bétey: exact summer bans.
- Oléron – La Perroche: banned in summer?
- Hillion – Bon Abri: limits of the Baie de Saint-Brieuc nature reserve for kites.
- Hendaye, Anglet – La Madrague: summer windows.
- Lac du Der, Lac d'Orient, Lac de Madine: club rules (KDA, AWA / Flysurf10, AKL).
- La Baule: main launch at Plage Benoît, or nearer the Le Pouliguen étier?
- Weak pins (snapped from a village / street): Hemmes de Marck, Wimereux – Pointe aux Oies,
  Cayeux – La Mollière, Landéda – Sainte-Marguerite, Cherbourg – Collignon, Jullouville,
  Les Arbousiers, Navarrosse.
- Ouistreham Riva-Bella: really a separate spot from Merville (3.5 km)?
- Left out as uncertain: Les Sables-d'Olonne, Jonville / Réville, Saint-Germain-sur-Ay,
  Locmariaquer, Le Rohu, Kerguelen, La Palue, Dunkerque Digue du Break, Cap-Ferret ocean
  beaches, Capbreton / Hossegor, Moisson-Lavacourt.

## France — Mediterranean (FR-mediterranean.csv)
- Exact launches: Marseillan (pinned at Maldormir), Frontignan – Ingril, Saint-Cyprien –
  Pont des Basses, Lac de la Ganguise (Auberge Le Cathare?).
- Bonifacio – Balistra: still kited since the school closed in 2023?
- Weak pins (bus stop / place node): Carnon – Petit Travers, Narbonne – La Nautique,
  Ganguise, Ingril; L'Espiguette is on a restaurant at the main car park.
- Leucate, not added (no reliable OSM position, possibly duplicates): La Mine (likely = Le Goulet),
  Les Pilotis (Port Leucate?), the west shore of the Étang de Leucate near Salses.
- Not added as duplicate: Argelès-Plage (= Le Racou).
- Pin check (WHE-59): Parc des Dosses on the beach, direction matches.
- Le Barcarès Les 3 Colonnes: pin on the beach element, 680 m from an old community GPS (7 years). Same beach, left as is.
- Leucate Le Goulet: pin is the spot's camper-van car park, about 200 m from the lagoon. No beach or kite feature is
  mapped on that shore, so nothing better to point at; the forecast grid is kilometres wide, so it reads the same wind.

## Spain outside Catalonia / Portugal (ES.csv, PT.csv)
- Mar Menor: rules after the lagoon's environmental crisis.
- Mallorca – Pollença: zone at Can Cullerassa?
- Embalse de La Loteta: launch (pinned at the marina, not the club's south spot).
- Huelva summer zones.
- Left out: Ibiza, Basque Country, Embalse del Ebro, Lo Pagán, El Saler, Patacona, Cullera,
  Fornells, El Cotillo.
- Portugal pass (2026-10-22), still open:
  - Porto Santo: really famous for kiting? Pinned on Praia da Fontinha (middle of the 9 km
    beach); no source says where people launch.
  - Alvor: launch on the inner east shore facing W (pinned, 1 km W of the village) or on the
    sandspit across the mouth?
  - Ria Formosa (Faro, Fuseta, Cabanas): is the old navy kite ban (press, ~2008) still in force,
    and is there an official kite zone today? Nothing official found, so no `banned`.
  - Lagoa de Óbidos: pinned on the sailing club, not the summer kite zone. Fine?
  - Martinhal (flat but offshore in the usual N wind) and Tróia / Comporta (one weak source):
    worth a row? Left out. Azores, Madeira main island, Foz do Arelho (= Óbidos), Figueira da
    Foz, São Martinho: left out, no kite reputation found.
  - Windy cross-check (2026-10-22) added Alcochete and Manta Rota (basic), Matosinhos and Santa
    Cruz (pro). Alcochete: is `not-low` right on the Tagus flats? Matosinhos: official summer
    ban dates? Santa Cruz: launch pinned at Praia do Mirante, right? Windy also lists Figueira
    da Foz, Carcavelos, Sesimbra, Tróia, Vila Nova de Milfontes (mostly surf; left out).

## Catalunya (Catalan rows of ES.csv)

### Questions for you
- **El Trabucador, question for you**: our pin is mid-bar (la Ràpita side), about 4 km south of where the schools say
  they teach ("start of the beach, next to Eucaliptus":
  https://www.kitesurfdeltakitesup.es/playa-del-trabucador/, https://terresdelebre.travel/es/actividades-que-hacer/turismo-activo/kitesurf/kitesurf-trabucador).
  No official zone map found. Do riders actually use the whole bar? Options: (a) leave it, Trabucador = mid-bar for
  experienced riders, Eucaliptus = the root and schools (recommended); (b) merge the two into one spot at the root.
- **Palamós (La Fosca), question for you**: no kite school, kite zone or real kite guide found there (paddle and kayak
  only; one surf portal lists N/NW winds, which blow offshore at this SE-facing cove). Options: (a) archive it, the
  Empordà already has Pals and Platja d'Aro nearby (recommended); (b) move it to pro; (c) keep it free.
- Sant Pere Pescador zone: the town lists two kite areas (Cortal de la Vila, Cortal de la Devesa), now in the notes.
  Guide coordinates disagree on where they sit (Buscokite 42.182/3.110, Yumping 42.184/3.109, Kiteloopers 42.171/3.114);
  schools sit at Can Martinet / Camping La Gaviota. Our pin (42.1887, 3.1080) is a school shop on the same beach: leave it?
  Windy (visitor look, 2026-10-27): markers on the same beach and a second cluster 1.5 km south (Can Martinet side).
- Summer bans (1 Jun–30 Sep on every new Catalan spot): which have an authorised summer kite zone, so the ban should go?
  Likely Sant Carles de la Ràpita, Segur de Calafell, Cambrils, Roses. Pals is settled: the town page confirms the
  restriction. L'Escala, Sant Martí d'Empúries, Palamós, Platja d'Aro: no town page found, Catalan default kept.
- Torredembarra: where do kiters actually launch (Platja de Baix a Mar pinned)?
- El Prat: the kite zone there is Can Camins (OSM `sport=kitesurfing`), which was ruled out earlier. Still no?
- Positions to check on the map: Punta del Fangar (pinned on the locality; launch on the bay side?), Badalona (info
  board by the Pont del Petroli).

### Checked, for the record
- Not added as duplicates (< 2 km, same beach and direction): Blanes – S'Abanell (= Malgrat – La Pomareda, Tordera
  mouth), Roses town beach (2 km from Empuriabrava – La Rubina).
- Pin check (WHE-59, 2026-10-27 and 31, OSM reverse lookups; Overpass down): Sant Martí d'Empúries, L'Escala, Pals,
  Riumar, L'Ampolla, Punta del Fangar all on the beach or promenade, 14-80 m from the water, directions match.
- Platja dels Eucaliptus: was a mapper's point 270 m inland (campsite); now on the beach sand area `osm:r14500385`,
  90 m from the water, same direction (151°).
- L'Estartit pin moved from the kite school's shop (a street 270 m inland) to the beach `osm:r1692854`, centre at
  La Pletera, where the kite concession is.

## Morocco (MA.csv)
- Lassarga: our row is the lagoon shore, but guides describe "La Sarga" as an Atlantic wave
  spot. Which one do kiters mean?
- Moulay Bousselham and Oualidia (added as pro, sources are blogs and rentals): basic? Neither
  coast has a basic spot. Oualidia: tide window? One source says SE wind is best.
- Point de l'Or (Dakhla): worth a row? Only OSM match is a peak at El Argoub: launch unknown.
- Tahaddart (Tangier), Agadir beach: one weak source each, left out. Tarfaya, Imsouane, Lalla
  Takerkoust: no kite source found.
- Speed Spot proper (low tide only, ~5–10 km from the PK25 camps): its own row with
  `tide=low`, or keep it in the PK25 notes?

## UK / Ireland (GB.csv, IE.csv)
- Weymouth – Portland Harbour: pinned at Hamm Beach facing N into the harbour; right launch?
- Exmouth: Duck Pond (estuary) side faces NW, seafront SW — correct?
- Calshot: faces E across Southampton Water?
- Achill – Keel Lough side; Lady's Island Lake direction (no hint).
- Ireland coverage check (2026-10-22): Windy's map shows no kite spots in Ireland, so no
  benchmark there. Independent sources agree with our list. To add when OSM is reachable:
  Ballynamona (East Cork, E winds; ballycotton.ie + unplug-kitesurf), probably as pro.
- Pins from village / bay names: Walney Island, Kinmel Bay, Fraserburgh, Machrihanish,
  Balephuil, Ballyholme, Cranfield, Mulranny, Portnoo (Narin), Culdaff.

## Netherlands / Belgium / Germany (NL.csv, BE.csv, DE.csv)
- Lelystad – Bataviastrand: maps say it faces NE, NKV safe winds suggest W (hint empty).
- Dümmer, Brombachsee: exact launch; Brombachsee season.
- Holnis: which side the zone faces. Pelzerhaken: launch (pinned east side).
- Salzhaff – Pepelow: computed NNW, check against the launch shore. Wustrow Bodden side (SSE).

## Italy / Adriatic / Malta (IT.csv, HR.csv, ME.csv, MT.csv)
- Lake Como: no row any more (Colico pin faced N, the Breva would read offshore). Add the
  real launch (Dervio? Gera Lario? Domaso?) if you know it.
- Pins from town / area names: Viganj, Pakoštane, Gizzeria, Torre Canne, Margherita di
  Savoia, Talamone, Rosolina Mare, Premantura.
- Porto Pollo: pinned on the Porto Liscia kite zone (west), not the windsurf bay.
- Sardinia Windy cross-check (2026-10-24): added Punta Trettu (basic) and Rena Majore (pro).
  Is Punta Trettu well enough known to stay basic next to Porto Botte (about 10 km apart, both
  flat)? Trettu pin is the cape, hint NNE (sheltered shore). Left out: Porto Ferro (Alghero;
  wave-surf school, conflicting kite sources), Capo Mannu (in the Putzu Idu notes), Isola Rossa,
  San Pietro, Vecchie Saline, Pula (no kite source checked), Punta Tretu summer fee: ok to mention?
- Sicily (2026-10-24): Windy shows no kite spots in Sicily (not even the Stagnone), so
  no benchmark. Added Santa Maria del Focallo (basic; 5 guides + 2 schools). Not added: Agnone
  Bagni (flat east coast, Etna Kite School; no OSM beach found), Puzziteddu / Granitola and
  Manfria (Gela): one guide each. Add any of them?
- Croatia / Malta pass (2026-10-27): added Bol (Brač) as pro (4 guides + 2 schools; strong gusty maestral, launch
  restricted near Zlatni Rat in peak season; pin is the Zlatni Rat beach, riders launch 1–2 km away): ok as pro, or
  basic? Pakoštane stays archived (no source found). Malta: Golden Bay is called the top spot by some guides and
  Mellieħa by others; summer swimming-zone closure of all beaches is only in guides, no Transport Malta page found,
  so no ban encoded. Golden Bay added as pro (you said yes; Bol stays pro).
- Left out: Slovenia, Albania, Campania, Lazio, Liguria, Friuli, Chia, Trasimeno, Follonica,
  Bol (now added as pro, see below).

## Greece / Black Sea / Cyprus (GR.csv, BG.csv, RO.csv, CY.csv)
- Pounta (Paros): pinned on the village, not the beach. No OSM beach element at the kite
  spot (checked 2026-10-26: nearest ones are Psaraliki, 1.5 km west): is there a better pin?
- Cyclades pass (2026-10-26): Mikri Vigla (now on its beach element), Pounta and Korfos
  re-checked against 3 to 9 independent guides and schools each; notes rewritten from them.
  Kite judgement for you: Mikri Vigla "some experience needed" (narrow beach, rocky cape) ok?
- Mamaia Nord: pinned on a beach venue (Plaja Curacao).
- Dodecanese pass (2026-10-27): Prasonisi, Marmari, Afiartis checked against 5 to 10 guides and
  schools each; notes rewritten. Open for you:
  - Karpathos: one tour operator says kiting is not allowed in the three bays while the
    windsurf centres are open (9:00–19:00), and that the real kite beach is Agrilaopotamos (a few
    km away). Not official, so not encoded as a ban. Is that right? Should Agrilaopotamos be
    the pin (one source only so far)?
  - Prasonisi: one local site says kiting is banned on the flat (lagoon) side, but the schools
    teach there. Which side is it allowed on today?
  - Marmari: the permitted kite zone moved downwind to a narrow beach with trees; our pin is on
    the long beach. OK?
- Left out: Lesvos, Naxos Laguna, Drepano, other Crete spots.

## Nordics (DK.csv, NO.csv, SE.csv, FI.csv)
- Sjællands Odde: launch on the Sejerø Bugt (south) side, or the north side?
- Sønderby (Juelsminde): exact launch; computed facing SE.
- Helsinki – Aurinkolahti: established kite spot, or mostly windsurf / bathing?
- Öland – Böda: which beach (pin is a guess). Kalajoki: no beach in OSM, name search.
- Lista: one pin for a peninsula with several launches; SW hint.
- Rømø Lakolk / Sønderstrand: is `not-low` right, or do the low-tide lagoons work?
- Left out: Iceland, Ystad, Hanko, Gothenburg area.

## Baltics / Poland / Central Europe (EE, LV, LT, PL, AT, CH, CZ, HU, DE Bavarian lakes)
- Czarnocin (Szczecin Lagoon): really an established spot?
- Nové Mlýny: is Pasohlávky (upper reservoir) where kiters launch?
- Urnersee – Flüelen: kiting allowed, and is the Strandbad the launch?
- Chałupy, Kuźnica: exact kite-camp beaches (pins are the villages).
- Liepāja: pin is the town centre, moved to the beach by the build.
- Neusiedl am See: zone rules. Siófok: only Hungarian spot (Velence, other Balaton launches?).
- Left out: Walchensee, Kochelsee, Ammersee, Lipno (kite rules unclear), Slovakia, Slovenia.
