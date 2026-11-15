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
