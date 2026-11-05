# Spots to confirm locally

Questions the curation agents could not settle from the web or the maps. Answer what you
know; fixes go in the country CSV (see README.md), then rebuild. Remove a line once settled.

Wave 2 (Italy, Adriatic, Greece, Black Sea, Cyprus, Nordics, Baltics, Central Europe) was
curated **without web verification** (knowledge + OpenStreetMap + Apple Maps checks): a
second pass with web research is worth doing.

## France — Channel / Atlantic (FR-atlantic.csv)
- Oléron – La Perroche: summer ban reported by guides only (WHE-110, 2026-11-05), no town order found; kept in notes, not encoded.
- Charente-Maritime (WHE-110): Ré tip and Oléron west-coast wave spots on Windy (Lizay, Baleines, Grignon, Les Palles, Grand Village, Côte Sauvage) left out: only surf sources, see docs/validation/fr-charente.md. Oléron – Gatseau is thin (one directory listing).
- Gironde (WHE-109, settled 4 Nov, worst case): La Hume stays closed Oct–Nov (town order cited
  by the school, text not found); Le Bétey stays closed Jul–Aug (State guide: only the Andernos
  kite channel in season); Les Arbousiers closed before 19:00 in Jul–Aug (State guide, 2020);
  Claouey archived (no kite channel, school closed, no Windy marker).
- Lac d'Hourtin-Carcans: State guide says kite only 15 Nov–31 Mar (order of 1 Sept 2014),
  encoded; the Hourtin 2025 lake map shows a kite zone with no dates. If the school zone is
  open all year, narrow the ban.
- Gironde candidates (Windy 5★), not added yet: Grand Crohot / L'Horizon (State kite channel
  at L'Horizon; guides: kite zone south of the Grand Crohot blockhaus), Montalivet (Carakas
  kite school). Need a second source each and an OSM pin.

- Cotentin west (WHE-116): no municipal or préfecture kite order found for any of the 7 spots, so no `banned` rule is encoded; Vauville (dune nature reserve), Utah Beach (shellfish beds) and Agon / Jullouville summer limits are worded in `notes` with "check the town hall". Jonville / Réville, once left out as uncertain, is now in as Pro (Windy marker, 3 stars, one tourist-guide source): the pin is the OSM beach of Jonville, to be checked by a local. See docs/validation/fr-cotentin.md.

- Côte d'Opale north (WHE-119, 2026-11-05): Dunkerque summer kite zone (500 m west of Terminus post, 1 Jul–31 Aug) is from a local guide only, prefectoral text not found: kept in notes. Gravelines PFP rules come from the 2024 mayor's order (check 2026). Les Hemmes de Marck pin is still a hamlet node (Apple direction disagrees; OSM N kept). Dunkerque Digue du Braek (Windy 1 star, port sea wall) left out: no OSM element for the riding place. Calais – Blériot-Plage has thin kite sources.
- Hillion – Bon Abri: limits of the Baie de Saint-Brieuc nature reserve for kites.
- Hendaye, Anglet – La Madrague: summer windows.
- Lac du Der, Lac d'Orient, Lac de Madine: club rules (KDA, AWA / Flysurf10, AKL).
- La Baule: settled 2026-11-05 (WHE-111): Plage Benoît stays (flat banks at low to mid tide, rideevolve guide); summer access is only the K13 channel at the Pornichet border (Pornichet order ARR2026-212), so the summer ban stays. The La Baule 2016 order was a 404: find the current one if possible.
- Pays de la Loire / Vendée (WHE-111): 12 Windy markers left out, see docs/validation/fr-loire.md. Revive if a school page names the beach: Barbâtre (Noirmoutier), Les Générelles (La Tranche), Les Conches, Sauveterre. Archived: Notre-Dame-de-Monts. Summer rules for Fromentine, La Tranche, Pen Bron and Saint-Brevin come from guides only: no order found.

- Lac du Der, Lac d'Orient, Lac de Madine: club rules (KDA, AWA / Flysurf10, AKL). Lac du Der checked in WHE-120 (2026-11-05): the 15 Jun-15 Sep red zone comes from a club Facebook snippet only, no RPP or town text found; kept in notes, not encoded.
- La Baule: main launch at Plage Benoît, or nearer the Le Pouliguen étier?
- Weak pins (snapped from a village / street): Hemmes de Marck, Wimereux – Pointe aux Oies,
  Cayeux – La Mollière, Landéda – Sainte-Marguerite, Cherbourg – Collignon, Jullouville,
  Les Arbousiers (bus stop beside the beach), Navarrosse.

- La Baule: main launch at Plage Benoît, or nearer the Le Pouliguen étier?
- Weak pins (snapped from a village / street): Hemmes de Marck,
  Cayeux – La Mollière, Landéda – Sainte-Marguerite, Cherbourg – Collignon, Jullouville,
  Les Arbousiers, Navarrosse.
- Côte d'Opale south / Baie de Somme (WHE-118, 2026-11-05): summer kite zones at Berck, Le Touquet, Hardelot, Cayeux come from FFVL sheets and guides only, no arrêté found, so none is encoded in `banned` (docs/validation/fr-opale-s.md). Wimereux town beach, Ambleteuse, Audresselles, Baie de la Canche and Hourdel left out (same shores as spots we have, or no launch).
- Ouistreham Riva-Bella: really a separate spot from Merville (3.5 km)?
- Left out as uncertain: Les Sables-d'Olonne, Jonville / Réville, Saint-Germain-sur-Ay,
  Locmariaquer, Le Rohu, Kerguelen, La Palue, Dunkerque Digue du Break, Cap-Ferret ocean
  beaches, Capbreton / Hossegor, Moisson-Lavacourt.

## France — Mediterranean (FR-mediterranean.csv)
- Exact launches: Saint-Cyprien – Pont des Basses (Ganguise settled in WHE-95).
- Bonifacio – Balistra: still kited since the school closed in 2023? Settled 2026-11-05 (WHE-104): Windy marker (4 stars) and unplug-kitesurf.com page still list it, stays Pro; school closure not confirmed either way.
- Corsica (WHE-104, 2026-11-05): Figari bay "closed to kites in summer" (vvanat.fr, single blog) and Lozari "no kiting in summer" (kite-and-windsurfing-guide.com) have no official text: kept in notes, no ban encoded. 16 Windy-only Corsica markers (Palombaggia, Tizzano, Propriano, Macinaggio, Saleccia, L'Ostriconi...) not added yet, no kite source found: see docs/validation/fr-corse.md.
- Weak pins (bus stop / place node): Narbonne – La Nautique and Ganguise re-pinned (WHE-95).
  Settled 2026-11-05 (WHE-97): Carnon – Petit Travers now sits on the OSM kite-zone area; L'Espiguette stays on the
  restaurant node at the main car park (the beach polygons are long relations with centres 1.5 km away).
- Camargue and Provence (WHE-102, 2026-11-05): the summer bans on Marseille – Pointe Rouge and Fos – Le Cavaou
  (about 15 Jun–15 Sep) have no official text I could find (a blog cites a 2020 prefectoral order for Marseille, a
  kite guide says Cavaou's signs show no dates). Worst case applied: bans stay, wording in notes says unconfirmed.
  Saintes-Maries Plage Est restored as Pro. Left out: Saintes-Maries "Wave" (west of the harbour, no source names
  the beach), Les Renaires (Côte Bleue rocks, no source), Plage Olga (town beach on the Carteau bay).
- Montpellier coast (WHE-97, 2026-11-05): Le Boucanet's 1 Jun–15 Sep closure and the 2014 La Grande-Motte order
  (n°156) come from guides only, no official page found: kept in notes, no ban encoded. Palavas-les-Flots, Étang du
  Ponant and Étang de l'Or (Windy markers) left out, reasons in docs/validation/fr-montpellier.md.
- Settled (WHE-96, 3 Nov, [report](../../docs/validation/fr-thau.md)): Marseillan stays at Maldormir
  (the launch the spot guides name). Frontignan – Étang d'Ingril archived: free kiting suspended,
  schools only (Hérault Tourisme; ActuNautique June 2026; earlier order premar 318/2023).
- Frontignan sea side / Les Aresquiers: added as Pro (WHE-125, Windy rule). Position of the official kite zone (Aresquiers end vs west end of Frontignan-Plage) still unsettled; note tells riders to check the town's beach rules.
- Sète – La Corniche (Windy marker): added as Pro once the build kept different-water spots apart (WHE-127).
- Mèze – La Pinède: the school is at Le Taurus / Plage du Thalassa; "La Pinède" is unconfirmed. Not renamed (id).
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
- Mallorca – Pollença: zone at Can Cullerassa? Settled 2026-11-03 (WHE-94): no kite-zone source for it (only a windsurf beach), pin stays on Sa Marina. Details in docs/validation/es-balears.md.
- Embalse de La Loteta: launch (pinned at the marina, not the club's south spot).
- Huelva summer zones.
- Left out (Ibiza and Formentera re-checked 2026-11-03, WHE-94: kiting Nov–May only, no school, Ses Illetes banned May–Oct, stays out): Ibiza, Basque Country, Embalse del Ebro, Lo Pagán, El Saler, Patacona, Cullera,
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

## Settled: Tarifa levante (WHE-85, 3 Nov, no change to the catalogue)
- Balneario faces WSW (250°, Apple Maps agrees), so levante (E) is **straight offshore** there. Schools describe
  it exactly so: "Levante spot, offshore wind, experts only" (kitefuntarifa.com Balneario page; alexpastorkiteclub.com
  Tarifa guide; iksurfmag.com Tarifa guide). So the offshore rule is right to score it 0 for normal riders: the
  geometry is correct, the riders who use it in levante are experts accepting offshore.
- Los Lances / Valdevaqueros: guides call levante side-offshore / "works with both winds"; Los Lances is 227°,
  Valdevaqueros 214° from OSM coastline (agrees). Not changed: no official or first-hand source to widen them.
- Faking it with a wide `sector` would make levante look safe for everyone; refused (worst case = offshore stays 0).
- Real fix would be a scoring decision (e.g. an expert-only offshore allowance), not a catalogue one: card for the Lead.

## Gap pass Italy / Greece / Germany (WHE-91, settled without Ben, 2026-11-03)
- Added: Kos – Psalidi (GR, basic; sportif.travel Kos Kitesurf Centre + greeka/Kos guides), Prerow (DE, pro; visit-mv.com
  Kiteschule Darss + Surfspot Prerow; 8 km from Zingst; Nordstrand lies in the national park, zoning not checked).
- Not added (worst case, sources too thin): Eckernförde (only a tourism page), Puzziteddu IT (only a promotional listing, no school
  on site found), Kos – Kefalos/Kohilari (kite school mention but no OSM beach reachable; revisit), Torre Mozza IT, Torbole (Garda kite limits).
- Windy's lists were not re-browsed this run; the larger gap (IT 7%, GR 10%) needs a Chrome pass per country, one card each.

## Settled: Murcia, Almería, Granada (WHE-98, 3 Nov, rule of 2 Nov)
- **El Zapillo summer ban (15 Jun–15 Sep)**: no official text found (town hall, beach ordinance, BOP searched). Worst case applies: ban stays, notes say the source is missing. If a local school or the Almería bando shows kiting is allowed, lift it.
- **Los Nietos / Roquetas summer rules**: no kite-specific rule found. Roquetas ordinance art. 12 bans sail craft only inside buoyed bathing zones; notes updated.

## Roussillon / Leucate (WHE-67), settled 2 Nov 2026
- Leucate – Le Goulet: archived. Leucate tourist office (en.tourisme-leucate.com, "Leucate top spots") lists Le Goulet for windsurf / wingfoil / SUP only; its 2024-25 guide puts the free kite zone at Coussoules (KSL). Blogs mention a kite sector towards Île de la Rascasse, unconfirmed → worst case.
- Coussoules: kite zone secured by KSL by the old lifeguard post, windsurf zone upwind; La Franqui cliff-side exit channel closed to kites (OT guide 2025-26 and spot map 2026-27). No dated ban encoded (no official text found).
- Canet / Saint-Cyprien: no source found for the "municipal decree May–Sept" wording; notes now only say a kite area is signed (Pont des Basses; Saint-Cyprien north beach, per tourisme-saint-cyprien.com and tourisme-pyreneesorientales.com). Check with the town halls if a dated ban is wanted.
- Not re-verified: Argelès Le Racou, Torreilles, La Palme, Port-la-Nouvelle, Barcarès (3 Colonnes / Dosses) kept as they were.
- WHE-67 second pass (3 Nov 2026), settled: Argelès – Le Racou and Torreilles – Le Blockhaus archived (no school or official kite-zone page; worst case). Not added: Argelès Plage, Les Pilotis (Leucate Plage), La Mine (windsurf / SUP per the tourist office). Parc des Dosses kept pro; Ben may want it basic now that Le Goulet is archived (the only flat-water Tramontane spot in the area).

## South Brittany: Lorient to Quiberon, Morbihan (WHE-112), settled 5 Nov 2026
- Penvins tide: sources disagree (Penvins guide and Parcs & Loisirs: best around low tide, avoid the last 2 h of the flood because of shorebreak; other guides: flat and safe at high tide). Worst case applied: no tide window (the old `not-low` removed), both views in the notes.
- Penthièvre / Saint-Pierre-Quiberon: no official text found for the 29 May–11 Sep bay-side ban (school and guide blogs only), so it stays in notes, not in `banned`. On 14 April 2026 the mayor said she is considering a kite ban on some beaches from summer 2026 (ici.fr, franceinfo): no decree found. Re-check before the summer.
- Carnac: "kiting banned in summer in the whole commune except Carnac Evasion members" comes from a guide, no decree found. Not encoded; Carnac spots not added.
- WHE-131 (5 Nov): under the 1 km rule, added as Pro Carnac Grande Plage, Saint-Colomban, Mané Guen, Sainte-Barbe, Larmor-Plage – Toulhars and Hossegor – Plage Sud (docs/validation/fr-atlantic-1km-pass.md). Carnac summer ban stays in notes (guide only). The line below is superseded.
- (superseded) Not added because the build rejects spots under 2 km apart (kept the ones we already had): Kerhostin / Port d'Orange (0.6 km from Penthièvre), Sainte-Barbe (1.8 km from Kerhillio), Mané Guen (1.9 km from Les Sables Blancs, but on the ocean side of the isthmus), Saint-Colomban (1.9 km from Les Sables Blancs), Carnac Grande Plage (1.6 km from Men Du, summer ban). Ben may want Mané Guen or Saint-Colomban to replace Les Sables Blancs; that needs a rule decision.
- Not added, no local source found (worst case): Île d'Arz, Golfe du Morbihan, Saint-Pierre (Locmariaquer), Govelins, Roaliguen, Le Chel, Damgan (beach not identifiable).

## Var and Côte d'Azur (WHE-103, 2026-11-05), settled without Ben (rule of 2 Nov)
- Six-Fours – Le Brusc: the 1 Jun–30 Sep ban stays (kiteforum: no kite while the lifeguard post runs; another guide: officially banned all year, tolerated off season). No town or préfecture text found, worst case kept.
- Added as Pro from Windy: Les Lecques (Saint-Cyr tourist office listing, open 16 Oct–14 Mar) and Cabasson (Bormes tourism listing, open 1 Oct–31 May). Both seasonal bans come from those listings only; no wind or level text found for Les Lecques.
- Left out for lack of a local kite source (worst case, not added): Bandol, La Coudoulière, Brutal Beach, Les Sablettes, Gigaro, Pampelonne, La Nartelle / La Tour / Plage des Éléphants (Sainte-Maxime), Port Miramar. Le Lavandou: a campsite page says kiting is banned all year at Saint-Clair, Le Lavandou and La Favière. Details in docs/validation/fr-var.md.

## Settled: Tarifa, the Strait and Málaga (WHE-99, 5 Nov, rule of 2 Nov)
- Tarifa Balneario and Bolonia: the 15 Jun–15 Sep ban has no official source (no Ayuntamiento de Tarifa text found; schools and
  guides only say "strict in summer" and "winter only" for Bolonia). Worst case: ban kept as encoded, notes say the source is missing.
- Tarifa Los Lances: the "15 Jun–15 Sep" dates were removed from the note (no source); marked summer zones stay in the note, no ban encoded.
- Málaga Los Álamos: Aena restricted kiting at Guadalmar in 2015 (plane accident, Euro Weekly News); schools work there today but I
  found no official text on the current zone. Kept as a free spot with the warning in the note.
- Palmones: sources disagree on summer; one school says allowed in marked zones. No ban encoded.
- Windy-only Costa del Sol markers left out for lack of any local source or pinnable beach: Estepona town, Sotogrande, Chilches,
  Torrox, Playa del Chanquete (a follow-up with school pages could add them).

## Settled: Cádiz coast (WHE-100, 5 Nov, rule of 2 Nov)
- Summer kite bans at La Barrosa / Sancti Petri, El Palmar, Rota (all three beaches) and the reserved summer area at Caños de Meca come only from spot guides and school pages; no town or Costas text found. Rule applied: `banned` stays empty (no official source), the notes say to treat summer as closed or ask a school. Details in `docs/validation/es-cadiz.md`.
- Windy markers left out: Buzo (no OSM beach fits, sources don't say which beach), Cádiz city (no kite source), Barbate (surf listings only), Sanlúcar de Barrameda (OSM has only unnamed beaches there, can't tell which one kiters use).

## South Finistère, Crozon to Bénodet (WHE-113), settled 5 Nov 2026
- Letty lagoon pin faces N (the dune spit looking over the lagoon) but riders launch on the north shore at the UCPA slipway, where the guides say it works in S winds. The app therefore sees S wind as offshore. No OSM element sits on the north shore (checked: only the spit and Pointe Saint-Gilles beaches), and a second side in the hint cannot be set there. Needs either an OSM beach or kite feature on that shore or a build option for a manual facing: card for the Lead. Left as is (worst case: spot stays Pro).
- Summer rules, none found in an official text, so notes only, `banned` empty: Île-Tudy midday ban (reported, lifeguards 13:00 to 19:00 in July and August), Le Ster ban in summer thermal winds and Kersidan ban in high summer (both from the kite guide), La Torche signs. Worst case for riders: obey the signs.
- Not added: La Palue (surf beach, one blog line on kites), Saint-Tugen (surf), Audierne (beach cannot be told apart), Pointe Saint-Gilles (no source), Glénan (boat access).

## North Finistère and Brest (WHE-114), settled 5 Nov 2026
- Brest – Moulin Blanc: the summer closure (1 Jul–31 Aug 09:00–19:00) in `banned` has no source we could find; the Brittany tourist office page only lists lifeguards 13–19 h, and a kite guide mentions a "kite channel in summer". Worst case kept (ban stays). If a Brest or Le Relecq-Kerhuon text shows a kite channel, the ban could become a corridor rule.
- Landéda – Sainte-Marguerite: sources disagree on the tide (flat at low tide vs. navigable only about 2 h either side of high water). No tide window set; both views in the notes. Local check welcome.
- Summer swimming zones at Dossen (1 Jun–15 Sep), Sainte-Marguerite south (1 Jul–30 Aug) and Blancs Sablons west (1 Jul–31 Aug) come from one blog (vvanat.fr), no town text found. In notes only, not in `banned`.
- Left out of the catalogue, no local kite source or nothing to pin: Les Amiets, Boutrouilles, Île de Vierge, Trez Hir, Saint-Jean-du-Doigt, Trezmeur, Grève Rose, Kernisi (no launch place), Térénez and Île Grande (no beach in OSM).
