# Validation: South Holland coast (zone `nl-zuid-holland`, WHE-180)

Date: 2026-11-14. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru as benchmark).
Past work: the Benelux catalogue passes (commits 02d9070, 2c1557a, d7f4125); no open question in `TO_CONFIRM.md` for these 13 rows.

Limits (said plainly): pins are the OSM elements already in the CSV, unchanged; I did not re-check them on satellite.
No official kite-zone text was found for Scheveningen, Kijkduin, Zandmotor, Ouddorp, Rockanje or the Haringvliet.
Rules at Hoek van Holland come from a search summary of the Rotterdam order, not a full read (the page failed to load).
About 9 web searches and 8 page reads.

## Our 13 spots

| Spot | Verdict | Sources and notes |
|---|---|---|
| Oostvoorne | fixed (notes) | [kite-and-windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/oostvoorne-autostrand-zuid-holland-netherlands.html): shallow bay, car-free (about 500 m walk, schools use trolleys), wooden posts; [EuroParcs](https://www.europarcs.com/holiday-parks/poort-van-zeeland/surroundings/kitesurfschool-rockanje) calls the former car beach popular with kiters |
| Hoek van Holland | fixed (notes) | Rotterdam designation order ([CVDR721779](https://lokaleregelgeving.overheid.nl/CVDR721779)): 500 m zone, 1 May to 1 Oct. Guide listing [here](https://www.kite-and-windsurfing-guide.com/en/continents/countries/regions/zuid-holland--). Rule put in notes, not `banned` (exact stretch unclear) |
| Zandmotor | ok | School on site: [Kiteboardschool, Zandmotor](https://kiteboardschool.nl/?p=4078); [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/kijkduin-zuid-holland-netherlands.html): speed strip downwind of the Zandmotor. Earlier note (restrictions 15 May–15 Sep) kept from the first pass |
| Scheveningen | fixed (notes) | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/scheveningen-zuid-holland-netherlands.html): SW best, pier-to-groyne water reserved for surfers; school: Kiteboardschool Scheveningen (page above) |
| Noordwijk | fixed (notes) | [Noordwijk tourist office](https://noordwijk.info/en/discover-noordwijk/activities/sportive-active): three zones (free at Langevelderslag, members-only KSN zone exits 2–4, lesson zone exit 21); [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/noordwijk-aan-zee-zuid-holland-netherlands.html). Our pin is the boulevard side; the free zone is 3–4 km north (open question: add Langevelderslag, a guide spot, later) |
| Ouddorp (Pro) | ok | [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/t-hekje-ouddorp-zeeland-netherlands.html): the Brouwersdam–Ouddorp area is the main Dutch hotspot, advanced in W–NW. No official zone found; seal-sandbank note kept from the first pass |
| Hellevoetsluis – Haringvliet (Pro) | fixed (notes) | [unplug](https://www.unplug-kitesurf.com/spots/haringvliet-quackstrand-netherlands): SW–NW, riding zones apply; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/haringvlietdam-zuid-holland-netherlands.html): chaotic currents at the locks |
| Rockanje (Pro) | ok | School on the beach: [Kitesurf Rockanje via EuroParcs](https://www.europarcs.com/holiday-parks/poort-van-zeeland/surroundings/kitesurfschool-rockanje); beach is a Natura 2000 area ([Voorne aan Zee](https://en.voorneaanzee.nl/evenementenlocatie-strand-rockanje)). Seasonal notes kept from the first pass; guide listed [here](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/rockanje-zuid-holland-netherlands.html) |
| Maasvlakte – Slufter (Pro) | ok | Guides list [Maasvlakte Bay, Point and Dead Men's Point](https://www.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/maasvlakte-bay-zuid-holland-netherlands.html), [kiteforum](https://se.kiteforum.com/kitesurf/spot/maasvlakte). The old Maasvlakte 2 order expired in 2021: the seasonal wording in our note is from the first pass and should be re-read |
| Kijkduin (Pro) | ok | [Kiteschool Kijkduin](https://kiteboardschool.nl/?p=4080), [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/kijkduin-zuid-holland-netherlands.html): moving sandbars |
| Katwijk (Pro) | fixed (notes) | [kiteforum](https://se.kiteforum.com/kitesurf/spot/katwijk_aan_zee): kiting only in three areas (surf club, kitesurf club, sailing club), SW–NW, currents and shore break |
| Wassenaarse Slag (Pro) | **archived** | No kite school, club or guide spot found; only surf and beach pages. Kijkduin and Katwijk cover the coast. Revive if a source appears |
| 's-Gravenzande – Slag Beukel (Pro) | **archived** | Same: no kite source found. Not in the guide's South Holland list either |

## Windguru, both ways (browsed as a visitor, 14 Nov)

Windguru markers in the zone named or tagged as kite: **0**. The search "Netherlands kite" returns only Brouwersdam (Zeeland) and Hindeloopen (Friesland), both in other zones. The map shows plain place markers on this coast (Katwijk aan Zee, Wassenaar, Scheveningen, Oostvoornse Meer, Rockanje, Haringvlietdam, Ouddorp): forecast points of towns and beaches, not kite-tagged. Matched to ours: 0 kite-tagged; by name, Scheveningen, Katwijk, Rockanje, Oostvoorne/Oostvoornse Meer, Ouddorp, Maasvlakte (also a Maasvlakte strand beach point) have a point. Added: 0. Left out: none.

Not on Windguru by name: Hoek van Holland, Zandmotor, Noordwijk, Kijkduin, Hellevoetsluis (not checked individually).
Note: Oostvoornse Meer (guide spot, flat-water lake) is mentioned in our Oostvoorne note, not a row of its own.

Build check: NOT run to the end. Overpass was down (504s, connection refused) and two attempts were killed. The edits change only notes and two tiers (no `locate`), and the CSV parses (71 rows, 11 columns). Rerun `spot-check` on `NL.csv` when Overpass is back, before merging.

## Windy, both ways (browsed as a visitor, 16 Nov, WHE-208)

Method: [validation method, step 2](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time). Windy kite markers hovered at zoom 10–11 from Noordwijkerhout to Goeree-Overflakkee, plus the Rotterdam area. The Windguru pass above found no kite-tagged markers, so Windy is the real benchmark here. Pins come from OSM only. About 9 web searches, plus the Dutch kite federation (NKV) province list and spot pages, which are the main local source and also list who may kite.

**Counts: 20 Windy markers in the zone. 10 matched to ours, 3 added as Pro (Monster, Langevelderslag, Oostvoornse Meer), 7 left out.** One archived row was also revived (Slag Beukel, NKV spot, not a Windy marker). Three more markers (Brouwersdam, Kabelaarsbank, Grevelingendam) sit on the Zeeland border and belong to the Zeeland zone (WHE-207). Our spots before → after: 13 rows, 5 free / 6 Pro / 2 archived → 16 rows, 5 free / 10 Pro / 1 archived.

| Windy marker (stars) | Ours / verdict |
|---|---|
| Noordwijk aan Zee (5) | Noordwijk |
| Katwijk aan Zee (5) | Katwijk |
| Scheveningen (5) | Scheveningen |
| Kijkduin (5) | Kijkduin |
| Hoek van Holland (5) | Hoek van Holland |
| De Slufter (5) | Maasvlakte – Slufter |
| Oostvoorne (5) | Oostvoorne |
| Rockanje (5) | Rockanje |
| Ouddorp (5) | Ouddorp |
| Haringvlietdam (2) | Hellevoetsluis – Haringvliet (NKV spot, same dam) |
| Oostvoornse Meer (4) | **added (Pro)**: NKV spot open all year, kite school at the Brunotti Beach Club; pin on the beach by the club (`osm:r17980280`) |
| Monster (4) | **added (Pro)**: kite school lessons at Monster ([Kiteboardschool Monster](https://kiteboardschool.nl/kitesurfles-3/kitesurfles-monster/)), [35 Knots](https://35knots.com/en/kitesurf-spot-zandmotor/); tolerated only, no formal zone, said in the notes; pin `Strand Monster` |
| Noordwijkerhout (3) | **added (Pro) as Noordwijk – Langevelderslag**: the marker is on the open coast north of Noordwijk; the legal free kite zone there is Langevelderslag ([NKV](https://kitesurfvereniging.nl/kitespot/noordwijk-langevelderslag/), [KSN kite zones](https://www.ksnoordwijk.nl/kitezone?lang=en)). Kiting elsewhere in Noordwijkerhout is reported banned (Hanglos, no official text) |
| Wassenaar (4) | left out: our row Wassenaarse Slag stays archived, kiting only for members of Surfclub Wassenaar or the Kustzeilvereniging ([NKV spot page](https://kitesurfvereniging.nl/kitespot/wassenaarse-slag/), 35 Knots). Reason 1: access only through a club |
| Quackstrand (1) | left out: a spot guide says kiting is not allowed at the Quackstrand ([Kiteforum](http://se.kiteforum.com/kitesurf/spot/haringvliet___quackstrand)); the allowed part of the Haringvliet is our Hellevoetsluis row. No official text, worst case |
| 't Hekje (1) | left out: not on the NKV list, no kite school, forums contradict each other; worst case. Ouddorp (NKV, accesses 7–9) covers the coast |
| Vuurtoren, Ouddorp (5) | left out: not on the NKV list, a kite school says it does not teach in Ouddorp because of waves and current, forum posts on controls and a ban near the lighthouse and sandbank ([Kitehigh](https://www.kitehigh.nl/forum/index.php?topic=17733.0)); no official zone text found, worst case |
| Herkingen, Grevelingenmeer (5) | left out: reported forbidden outside the Grevelingendam zone ([Hanglos](https://hanglos.nl/spot/153238/herkingen.html), [Kiteforum](http://se.kiteforum.com/kitesurf/spot/grevelingenmeer___herkingen)); a windsurf spot; no official text, worst case |
| Zevenhuizen (3) | left out: the Zevenhuizerplas is a windsurf lake, no kite school or club found, an old forum thread says kiting is banned (power lines); not on the NKV list |
| Numansdorp (2) | left out: one old guide says a few locals kite there, no school, not on the NKV list |

Ours not on Windy: none of the old 13 (Zandmotor matches the Windy Monster / Kijkduin area but has its own beach element; Windy has no marker named Zandmotor).

**Gap:** Windy shows 20 markers against our 16 rows: the 7 left out are places the sources describe as banned, members-only or unconfirmed, not famous open spots.

Also in this pass: **'s-Gravenzande – Slag Beukel is back to Pro** (it was archived by WHE-180 for lack of a source; the [NKV spot page](https://kitesurfvereniging.nl/kitespot/s-gravenzande-slag-beukel/) lists it: kite zone about 300 m left of the groyne, advanced, N–SW, all year).
The Wassenaarse Slag archive reason now says why (members only), replacing "no source".

Build check (16 Nov): `spot-check` on the 16 zone rows, exit 0, no PROBLEMS; Apple Maps agrees 14, uncertain 1 (Oostvoorne, a cove). Oostvoornse Meer is a lake: the build facing of its beach polygon is unstable, so its hint is N (the club shore).
