# Validation: North Holland coast and lakes (zone `nl-noord-holland`, WHE-181)

Date: 2026-11-15. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru as benchmark).
Past work: the Benelux catalogue passes (commits 02d9070, 2c1557a, d7f4125); no open question in `TO_CONFIRM.md` for these 17 rows.

Limits (said plainly): pins are the OSM elements already in the CSV, unchanged, not re-checked on satellite. No official kite-zone text was
found for any spot except the 2020-era Zandvoort zones (news report; the date range is kept from the first pass). The provincial Natura 2000 kitesurf
study (Tauw, waddenzee.nl PDF) could not be read here (binary PDF), so seasonal rules for the lakes are unconfirmed. About 12 web searches and 6 page reads.

## Our 17 spots

| Spot | Verdict | Sources and notes |
|---|---|---|
| Zandvoort | ok | [NH Nieuws](https://www.nhnieuws.nl/nieuws/284094/nieuwe-duidelijke-grenzen-voor-watersportzones-om-ongelukken-te-voorkomen): six watersport zones 15 Apr–1 Oct; [Zandvoort tourist site](https://www.zandvoort-holland.com/recreation/sports/kitesurfing/kitesurfing-faqs/) and schools (North Sea Watersports, Moana) |
| IJmuiden | fixed (notes) | [Decathlon guide](https://www.decathlon.nl/c/wtp/kitespots-nederland-dit-zijn-de-beste-surfplekken_c4721b29-8ec3-4f94-aded-14ae91fc28cb): windier than Wijk aan Zee, don't launch in offshore wind; [unplug](https://www.unplug-kitesurf.com/spots/ijmuiden-netherlands); [gemeente IJmuiden](https://ijmuiden.nl/en/?p=2027) |
| Wijk aan Zee | ok | Schools on site (Wijkiki, Kiteflow, Sports at Sea via [IKO](https://beta.ikointl.com/fr/centre/netherlands/netherlands/wijkiki-kitesurfschool)); [guide listing](https://www.kite-and-windsurfing-guide.com/en/continents/countries/regions/noord-holland-) |
| Camperduin | ok | [unplug](https://www.unplug-kitesurf.com/spots/camperduin-netherlands): frontal SW–NW, shallow, any level; NorthWest Kiteboarding school ([kiterr](https://kiterr.com/kiteschool/northwest-kiteboarding)) |
| Muiderberg | fixed (notes) | [kiteforum](https://se.kiteforum.com/kitesurf/spot/markermeer___muiderberg), [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/muiderberg-gooimeer-veluwemeer-netherlands.html), [NH Nieuws](https://www.nhnieuws.nl/nieuws/323305/frustratie-voor-kitesurfers-kitesurfen-nog-steeds-illegaal-voor-kust-huizen-en-blaricum): one of the few legal IJmeer launches; WakeStyle school |
| Schellinkhout | fixed (notes) | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/schellinkhout-ijsselmeer-netherlands.html), [unplug / KiteFEEL](https://www.unplug-kitesurf.com/schools/kitefeel): designated by Rijkswaterstaat (per local news), school on the dike |
| Bloemendaal aan Zee (Pro) | fixed (notes) | [Mifune Watersports (IKO)](https://www.ikointl.com/school/netherlands/bloemendaal-aan-zee/mifune-watersports), [kiteforum](https://se.kiteforum.com/kitesurf/spot/bloemendaal_aan_zee); guide warns of strong currents along the whole coast |
| Castricum aan Zee (Pro) | fixed (notes) | [kiteforum](https://se.kiteforum.com/kitesurf/spot/castricum_aan_zee): lifeguards, showers; Surfschool Castricum teaches kite; guide listing |
| Egmond aan Zee (Pro) | fixed (notes) | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/egmond-aan-zee-noord-holland-netherlands.html), [kiteforum](https://se.kiteforum.com/kitesurf/spot/egmond_aan_zee); [NH Nieuws rescue report](https://www.nhnieuws.nl/nieuws/363566/kitesurfers-in-nood-uit-zee-gered-bij-egmond-aan-zee) shows the current drift |
| Bergen aan Zee (Pro) | ok | [unplug](https://www.unplug-kitesurf.com/spots/bergen-aan-zee-netherlands), guide listing; orange-zone note kept from the first pass |
| Petten (Pro) | fixed (notes) | [unplug](https://www.unplug-kitesurf.com/spots/petten-netherlands): groynes every 100 m, stones, currents, lifeguards check ability, riding zones; [Petten Kitesurfschool](https://www.visitwadden.nl/en/visit/activities/2206205637/petten-kitesurfschool) |
| Callantsoog (Pro) | fixed (notes) | [Visit Kop van Holland](https://visitkopvanholland.nl/en/locations/kitesurfspot-callantsoog-2/): kite spot at beach pavilion De Stern; [unplug](https://www.unplug-kitesurf.com/spots/callantsoog-netherlands). Sources say any level; we keep the currents warning |
| Julianadorp (Pro) | **archived** | Only a surf school (Foamball, Paal 6) and a recreation page; no kite school, club or kite-guide spot. Not in the guide's North Holland list. Callantsoog and Petten cover it. Revive if a source appears |
| Den Helder – Huisduinen (Pro) | fixed (notes) | [Visit Wadden](https://www.visitwadden.nl/en/visit/activities/3313783968/kitesurfspot-den-helder), guide lists Den Helder and Huisduinen: Citadel beach club, strong Marsdiep currents. One local page calls the Razende Bol seal area a rest zone: put in notes, not `banned` |
| Edam – Galgenveld (Pro) | fixed (notes) | [kiteforum](https://se.kiteforum.com/kitesurf/spot/markermeer___edam), [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/edam-ijsselmeer-netherlands.html): only good in easterlies, barbed wire at the launch. Natura 2000 study not readable |
| Medemblik (Pro) | ok | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/medemblik-ijsselmeer-netherlands.html), [unplug](https://www.unplug-kitesurf.com/spots/ijsselmeer-medemblik-netherlands): flat water. The April–September season is from the first pass and not re-confirmed (open point) |
| Amstelmeer (Pro) | fixed (notes) | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/amstelmeer-ijsselmeer-netherlands.html), [Visit Wadden Lutjestrand](https://www.visitwadden.nl/en/visit/activities/603853712/amstelmeer-kite-windsurfspot-lutjestrand): kiters on the south side. The "max 6 riders" limit from the first pass was not found again; removed from the note |

## Windguru, both ways (browsed as a visitor, 15 Nov)

Windguru markers in the zone named or tagged as kite: **0**. The search "kite Netherlands" returns only Brouwersdam (Zeeland) and Hindeloopen (Friesland).
The map shows plain forecast points on this coast (Bergen aan Zee, Castricum aan Zee, Petten, Medemblik, Enkhuizen, IJmuiden area, Julianadorp, Den Oever):
towns and beaches, none tagged kite. Matched to ours: 0 kite-tagged (by name, Bergen aan Zee, Castricum aan Zee, Petten, Medemblik and Julianadorp have a point). Added: 0. Left out: none.

Guide spots we don't have, not added (no Windguru marker to follow): Hargen aan Zee (about 2 km from Bergen aan Zee, same beach) and Uitgestermeer (inland lake at Uitgeest, no school found).
No big gap.

## Windy, both ways (browsed as a visitor in Chrome, 16 Nov, WHE-209)

Windy kite markers read by hovering (name and stars), zoom 10–11, on the coast from Zandvoort to Texel, the IJsselmeer and Markermeer shore, and the IJmeer.
Markers seen in the zone: **21** (a 22nd, Trintelhaven, sits on the Houtribdijk in Flevoland, outside this zone, and is already archived in `NL.csv`).
**Matched to ours: 16** (Edam matches our archived Galgenveld row; Texel matches Texel – Paal 17, in the Wadden Islands region). **Added as Pro: 2.** **Left out: 3.**
Our rows in the zone before this pass: 17 (15 live, 2 archived: Julianadorp and Edam – Galgenveld, the latter by WHE-214). After: 19 (17 live, 2 archived).

### Windy marker → ours

| Windy marker (stars) | Ours |
|---|---|
| Zandvoort aan Zee (5) | Zandvoort |
| Bloemendaal aan Zee (4) | Bloemendaal aan Zee |
| IJmuiden (5) | IJmuiden |
| Wijk aan Zee (5) | Wijk aan Zee |
| Castricum aan Zee (5) | Castricum aan Zee |
| Egmond aan Zee (5) | Egmond aan Zee |
| Camperduin (4) | Camperduin |
| Bergen aan Zee (4) | Bergen aan Zee |
| Petten (4) | Petten |
| Callantsoog (4) | Callantsoog |
| Huisduinen (3) | Den Helder – Huisduinen |
| Texel (5, at De Koog) | Texel – Paal 17 |
| Medemblik (5) | Medemblik |
| Schellinkhout (5) | Schellinkhout |
| Edam (4) | Edam – Galgenveld (archived, WHE-214) |
| Muiderberg (5) | Muiderberg |

### Windy marker we didn't have

| Windy marker (stars) | Result |
|---|---|
| Enkhuizen (5) | **added (Pro)**. [Kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/enkhuizen-ijsselmeer-netherlands.html): shallow strip about 500 m by 2 km north of the old town, easterly wind. Pin: OSM beach `w90172365`, north of the old town. Only the guide as source, no school |
| Gouwzee (3) | **added (Pro)**. [Kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/gouwsee-ijsselmeer-netherlands.html): calm dyke-sheltered water, launch at Hemmeland. Pin: OSM beach `w103802217` on the Gouwzee shore. Only the guide as source, no school |
| Uitgeestermeer (4) | left out: [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/uitgestermeer-noord-holland-netherlands.html) says kiteboarding is prohibited there (windsurf only); no school or club. Same call as the Windguru pass |
| IJburg (4) | left out: the [guide page](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/markermeer-ijburg-noord-holland-netherlands.html) is windsurf and SUP only, with a windsurf school on site; no source says kiting is allowed on this city beach, and kiting is illegal on much of the IJmeer (NH Nieuws, see Muiderberg). Worst case |
| Den Oever (4) | left out: no kite school, club, guide page or town page found for Den Oever or Wieringen in two searches, so there is no source for sector or rules. Revive if one appears |

### Ours not on Windy

Julianadorp (already archived) and Amstelmeer have no Windy kite marker.

Gap line: no big gap, Windy shows 5 markers we lacked; 2 added, 3 left out for the reasons above. Added rows are thin (one guide source each, no school): second look if a local rider can confirm them.
Limits: the two new pins are OSM beach polygons picked from the OSM map data (Overpass was down), not viewed on satellite.
