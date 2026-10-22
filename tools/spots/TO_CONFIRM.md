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

## Spain / Portugal (ES.csv, PT.csv)
- Torredembarra: where do kiters actually launch (Platja de Baix a Mar pinned)?
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
- Barcelona-area additions (2026-10-22): every new Catalan spot gets the Catalan summer ban
  (1 Jun–30 Sep). Which have an authorised summer kite zone, so the ban should go? Likely:
  Sant Carles de la Ràpita, Segur de Calafell, Cambrils, Palamós, Pals, Roses.
- El Prat: the kite zone there is Can Camins (OSM `sport=kitesurfing`), which was ruled out
  earlier. Still no?
- Leucate, not added (no reliable OSM position, possibly duplicates): La Mine (likely = Le Goulet),
  Les Pilotis (Port Leucate?), the west shore of the Étang de Leucate near Salses.
- Not added as duplicates (< 2 km, same beach and direction): Blanes – S'Abanell (= Malgrat –
  La Pomareda, Tordera mouth), Argelès-Plage (= Le Racou), Roses town beach (2 km from Empuriabrava – La Rubina).
- New positions to check on the map: Punta del Fangar (pinned on the locality; launch on the bay
  side?), Badalona (info board by the Pont del Petroli).

## UK / Ireland (GB.csv, IE.csv)
- Weymouth – Portland Harbour: pinned at Hamm Beach facing N into the harbour; right launch?
- Exmouth: Duck Pond (estuary) side faces NW, seafront SW — correct?
- Calshot: faces E across Southampton Water?
- Achill – Keel Lough side; Lady's Island Lake direction (no hint).
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
- Left out: Slovenia, Albania, Campania, Lazio, Liguria, Friuli, Chia, Trasimeno, Follonica,
  Bol (Brač: windsurf spot, kiting unclear).

## Greece / Black Sea / Cyprus (GR.csv, BG.csv, RO.csv, CY.csv)
- Pounta (Paros): pinned on the village, not the beach.
- Mamaia Nord: pinned on a beach venue (Plaja Curacao).
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
