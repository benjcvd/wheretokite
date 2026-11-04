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
  Pont des Basses.
- Bonifacio – Balistra: still kited since the school closed in 2023?
- Weak pins (bus stop / place node): Carnon – Petit Travers, Ingril; L'Espiguette is on a restaurant at the main car park.
- Leucate, not added (no reliable OSM position, possibly duplicates): La Mine (likely = Le Goulet),
  Les Pilotis (Port Leucate?), the west shore of the Étang de Leucate near Salses.
- Not added as duplicate: Argelès-Plage (= Le Racou).
- Pin check (WHE-59): Parc des Dosses on the beach, direction matches.
- Le Barcarès Les 3 Colonnes: pin on the beach element, 680 m from an old community GPS (7 years). Same beach, left as is.
- Leucate Le Goulet: pin is the spot's camper-van car park, about 200 m from the lagoon. No beach or kite feature is
  mapped on that shore, so nothing better to point at; the forecast grid is kilometres wide, so it reads the same wind.

### Narbonne to Agde, settled without Ben (WHE-95, 2026-11-04, rule of 2 Nov)
- Lac de la Ganguise: archived. VNF says a prefectoral decree bans kitesurfing on the lake.
- Sérignan – La Grande Maïre: archived. No kite school or kite guide found, not on Windy.
- Gruissan – Les Chalets: Étang du Grazel side removed (kiting reported banned by town decree; text not found).
- Narbonne – La Nautique: harbour-node pin kept (no beach mapped nearer; same forecast cell).
- Not added: Cap d'Agde Richelieu (4 km from La Tamarissière), Lac de Jouarres (minor lake).
- Report: [fr-narbonne](../../docs/validation/fr-narbonne.md).

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

### Settled without Ben (WHE-2, 2026-11-02, rule of 2 Nov: look online, else assume the worst)
- **Summer bans**: all stay. No town page, Capitania notice or beach plan shows an authorised summer kite zone at
  Sant Carles de la Ràpita, Segur de Calafell or Cambrils (searched in Catalan and Spanish; only school listings and
  forecast pages). Roses: the summer zone is La Rubina (Castelló d'Empúries), already in the catalogue with no ban
  (council allowed controlled kiting there from 2005, bibgirona.cat press archive; kite-and-windsurfing-guide "Rubina").
- **Torredembarra**: archived. No school, club, marked zone or Windy kite marker (WHE-83); the only trace is a
  user-made forecast point on windy.app. Creixell (3 km) and Altafulla (4 km) cover the same beach and winds.
- **El Prat, Can Camins**: not added. Only swimming/windsurf listings (wildopenwater.com) and a sailing club forecast
  point; no kite school, zone or rider report found.
- **Punta del Fangar**: pin kept (sea side + bay side, directions agree). No school or zone found (schools ride at
  Trabucador / Punta de la Banya, terresdelebre.travel); the app note now says so.
- **Badalona**: pin verified on the beach Platja Pont del Petroli (`osm:r2154291`, 41 m from the old pin), now
  locked to that element instead of a name search. No kite-specific source for the pier itself.
- **Sant Pere / Empuriabrava / L'Estartit in Tramontana (WHE-64)**: sectors unchanged. Windsurf guides say
  Tramontana is side-shore at Sant Pere and ridden by experienced riders (surf-magazin.de "Sant Pere Pescador",
  waterwind.it "San Pere Pescador"); no kite school or kite source says NNW (side-off) is ridden. N already counts as
  cross-shore on Sant Pere's east-facing beach; widening the sector would score side-off gusts as rideable.
  Empuriabrava (faces SSE) and L'Estartit stay side-off in N/NNW.

### Barcelona → Ebro delta check (WHE-66, 2026-11-01)
- **Castelldefels**: the council's summer zone is open weekdays 15–19 h only (2026), closed weekends and holidays.
  The app now scores 0 outside 15–19 h from 1 Jun to 30 Sep, but it can't block weekends yet (code card for the Lead).
  Hours were 16–20 h in 2024: re-check each spring.
- **Ebro delta (Riumar, Trabucador, Eucaliptus)**: no official summer rule found (no council, park or Capitania page),
  only schools ("signposted zones, no restrictions") and one guide saying Riumar is closed to kites in summer.
  No ban encoded; notes say "check the signs". Do you know if Riumar is ridable in July–August? (a) yes, leave as is
  (recommended if you've seen kiters there in summer); (b) add the 1 Jun–30 Sep ban.
- **L'Hospitalet de l'Infant**: the council once opened a marked kite zone on Platja de l'Arenal (undated article,
  https://www.cambrils.com/es_ES/noticia/arte/ayuntamiento-habilita-zona-practica-kitesurf-playa-arenal-lhospitalet).
  Summer ban kept until a current official page says it still runs.
- Not added: Cubelles / Cunit (under 5 km from Segur de Calafell, same beach and winds), Garraf (small cove, no kite
  reputation found), Sitges (no school or zone found). Tell me if any of them deserves its own row.

### Checked, for the record
- Settled (Ben, 2026-11-02): Palamós (La Fosca) moved to pro, not archived. El Trabucador (mid-bar pin) and the
  Sant Pere Pescador pin both stay as they are (WHE-59).
- Not added as duplicates (< 2 km, same beach and direction): Blanes – S'Abanell (= Malgrat – La Pomareda, Tordera
  mouth), Roses town beach (2 km from Empuriabrava – La Rubina).
- Pin check (WHE-59, 2026-10-27 and 31, OSM reverse lookups; Overpass down): Sant Martí d'Empúries, L'Escala, Pals,
  Riumar, L'Ampolla, Punta del Fangar all on the beach or promenade, 14-80 m from the water, directions match.
- Platja dels Eucaliptus: was a mapper's point 270 m inland (campsite); now on the beach sand area `osm:r14500385`,
  90 m from the water, same direction (151°).
- L'Estartit pin moved from the kite school's shop (a street 270 m inland) to the beach `osm:r1692854`, centre at
  La Pletera, where the kite concession is.

## Catalonia vs Windy (WHE-83, 2026-11-01)
Windy kite layer read as a visitor (names and stars only, no pins copied): 33 Catalan markers. We have 32 rows.
Every Windy name maps to one of our spots except Blanes, Premià and Sant Antoni, which failed the two-source bar.
**Nothing added.** Stars are Windy's "popularity", not a kite source.

| Windy name (stars) | Our spot (tier) | Verdict |
|---|---|---|
| Roses (5) | Empuriabrava – La Rubina (pro) | Same place: the official zone near Roses is La Rubina (kite-and-windsurfing-guide "Rubina"; Yumping school listings). Not added. |
| St. Pere Pescador (5) | Sant Pere Pescador (basic) | Match |
| Sant Martí d'Empúries (5) | Sant Martí d'Empúries (pro) | Match |
| Playa de Riells (5) | L'Escala (Platja dels Riells) (pro) | Match |
| L'Estartit (5) | L'Estartit – Gola del Ter (basic) | Match |
| Pals (5) | Pals (basic) | Match |
| Sant Antoni (5) | Palamós (La Fosca) (pro), ~4 km | Same bay. One kite source only (kite-and-windsurfing-guide: Sant Antoni beach, best in light garbí). Not added (settled, Ben 2026-11-02). |
| Platja d'Aro (5) | Platja d'Aro (pro) | Match |
| Blanes (5) | Malgrat de Mar – La Pomareda (pro) | Re-checked: no school, club or zone in Blanes itself; the school and municipal zone are in Malgrat, across the Tordera mouth. Still a duplicate. |
| Malgrat (5) | Malgrat de Mar – La Pomareda (pro) | Match |
| Vilassar de Mar (5) | Vilassar de Mar (pro) | Match |
| Premia (5) | Vilassar de Mar (pro), ~2 km | Next-door beach, no kite school or zone found. Not added. |
| Montgat (4) | Montgat (pro) | Match |
| Badalona (5) | Badalona (pro) | Match |
| Mar Bella (5) | Barcelona – Nova Mar Bella (pro) | Match |
| Barceloneta (5) | Barcelona – Barceloneta (pro) | Match |
| Castelldefels (5) | Castelldefels (basic) | Match |
| Vilanova (4) | Vilanova i la Geltrú (La Farola) (pro) | Match |
| Segur de Calafell (5) | Segur de Calafell (basic) | Match |
| Calafell (4) | Calafell (pro) | Match |
| Creixell (3) | Creixell (pro) | Match |
| Altafulla (4) | Altafulla (pro) | Match |
| La Pineda (4) | La Pineda (pro) | Match |
| Salou (5) | Salou (Platja de Llevant) (pro) | Match |
| Cambrils (5) | Cambrils (Platja del Regueral) (basic) | Match |
| L'Hospitalet de l'Infant (5) | L'Hospitalet de l'Infant (pro) | Match |
| L'Almadrava (3) | L'Almadrava (Vandellòs) (pro) | Match |
| L'Ampolla (3) | L'Ampolla (Platja de l'Arenal) (pro) | Match |
| Punta del Fangar (1) | Punta del Fangar (pro) | Match |
| Riumar (5) | Riumar (basic) | Match |
| Playa del Trabucador (5), root of the bar | Platja dels Eucaliptus (basic) | Match (schools teach at the root) |
| Trabucador (4), mid-bar | El Trabucador (basic) | Match |
| St. Carles de la Ràpita (5) | Sant Carles de la Ràpita (basic) | Match |
| (none) | Torredembarra (archived) | Ours only. Archived in WHE-2: no kite source, 3–4 km from Creixell and Altafulla. |

Questions:
- **Palamós bay**: settled (Ben, 2026-11-02): La Fosca stays, moved to pro. Sant Antoni de Calonge not added.
- **La Rubina**: it's the official summer zone kiters call "Roses", and it works in easterlies when Sant Pere is
  side-off. Promote it from pro to free? (recommended: yes)
- Sources: https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/rubina-costa-brava-barcelona-spain.html,
  https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/sant-antoni-costa-brava-barcelona-spain.html,
  https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/palamos-costa-brava-barcelona-spain.html,
  https://en.yumping.com/water-sports/kite-paddelsurf-center-catalunya--e19679852

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
