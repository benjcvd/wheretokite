# Validation: Zeeland (zone `nl-zeeland`, WHE-179)

Date: 2026-11-14. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru benchmark).
Counts for the zone: 14 → 15 rows (free 6 → 6, Pro 8 → 6, archived 0 → 3), 12 live spots.
Build: `spot-check` on `NL.csv`, no PROBLEMS. Direction check, zone spots only: Vrouwenpolder **disagrees** (OSM 350°, Apple Maps water at 224°): the pin is a node on the Veerse Gatdam with water on both sides, hint NW (North Sea side) kept as the guides describe the dam sides, not one beach; flagged in `TO_CONFIRM.md`. IJmuiden and Zandmotor (uncertain) belong to other zones.
Past work: `git log` on `NL.csv` shows only the Benelux build, the trim to famous spots, tiers and the seasonal ban column. Nothing in
`TO_CONFIRM.md` for Zeeland. No earlier check redone.

Limits of this pass (said plainly): about 22 web searches and page reads, Windguru browsed as a visitor. Official text found for the
Oosterschelde (Rijkswaterstaat folder, March 2020) and, through a search summary only, for the Westerschelde (Staatscourant 2017 and July 2019 notices of
the Westerschelde nautical authority). The Staatscourant site was down all session, so I could not read the 2019 notice itself:
the Westerschelde rows rest on the summaries plus spot guides. Pins come from OSM elements; not checked on satellite. Directions and
`sector` untouched except where said: no school gave a contradicting wind.

| Spot | Verdict | Pin | Rules | Sources and notes |
|---|---|---|---|---|
| Brouwersdam | ok (notes) | `w61728057`, unchanged | Kiting only on the south part of the dam, inside the yellow buoys; avoid summer and holiday weekends | [iKsurfmag Zeeland guide](https://www.iksurfmag.com/travel-guides/europe/netherlands/zeeland/): onshore SW–NE, easy at low tide, shorebreak at high tide. [Zeeland.com kite page](https://zeeland.com/en/visit/things-to-do/water-sports/kite-surfing). Windguru: several points (kite school, Zeil- & Surfcentrum) |
| Neeltje Jans | ok (notes) | `r6971055`, unchanged | None found; not on the Rijkswaterstaat Oosterschelde kite map (it is the North Sea side) | [Kite & windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/neeltje-jans-zeeland-netherlands.html): wide shallow area at low tide (walk of 500 m+), surf zone at high tide, currents. [Kitegids](https://kitegids.nl/kitesurf-tips/pagina-naam-met-kitesurfen-in-zeeland-erin/). Windguru "Neeltje Jans" |
| Vrouwenpolder | ok (notes fixed) | `n8941093562`, unchanged | Removed "from May a buoyed zone": no source says so. Official spot starts right of the Vertigo Sports club | [iKsurfmag](https://www.iksurfmag.com/travel-guides/europe/netherlands/zeeland/): onshore W–E, lagoon at high tide, both sides of the dam. [Kiteforum](https://se.kiteforum.com/kitesurf/spot/breezand___vrouwenpolder). Vertigo Sports school. Windguru "Vrouwenpolder" |
| Kamperland – Roompot | ok (notes) | `w822498441`, unchanged | Official kite zone since 1 April 2009: stay inside; swimmers, current, oyster shells; on the Rijkswaterstaat kite map | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/Oosterschelde___Roompot_Strand): tide independent, many directions N–E and W–NW. Movement Sports school on site, April to October ([IKO](https://www.ikointl.com/school/netherlands/kamperland-zeeland/movement-sports-bv)). [Rijkswaterstaat folder](https://www.watersportverbond.nl/media/leohwbbb/oosterschelde-folder-010720.pdf). Windguru "Kamperland" and "Snackpoint Wimpie" |
| Domburg | ok (unchanged) | `w80401276`, unchanged | No kite rule found. A municipal beach rule about launch areas turned up, municipality not stated: not encoded | [Kitegids](https://kitegids.nl/kitesurf-tips/pagina-naam-met-kitesurfen-in-zeeland-erin/): waves, strong currents, submerged pile rows, experts. [iKsurfmag](https://www.iksurfmag.com/travel-guides/europe/netherlands/zeeland/): "serious wave spot". Windguru "Domburg" |
| Cadzand-Bad – Zwin | ok (unchanged) | `w548694875`, unchanged | Cadzand-bad west is on the 2017 Westerschelde list; I could not read the current list | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/cadzand_bad): intermediate to expert, flat water inside the Zwin at high tide. [Unplug](https://www.unplug-kitesurf.com/spots/cadzand-bad-netherlands): W wind, high tide, rescue on the spot. Windguru "Cadzand Bad" |
| Breskens – Oost (Pro) | ok (notes) | `w491657990`, unchanged | Official area, "Breskens oost" on the 2017 and 2019 Westerschelde lists | Westerschelde nautical authority list, via search summary of the [Staatscourant 2019](https://zoek.officielebekendmakingen.nl/stcrt-2019-37238.pdf) (site down, not read). Not seen on Windguru |
| Borssele – De Kaloot (Pro) | ok (notes) | `w702126930`, unchanged | Kite zone marked by yellow buoys; shipping channel with red buoys | [35 Knots](https://35knots.com/kitespot-borssele/): SW wind, choppy, sharp stones at the channel mouth at low water, warmer water near the plant. Windguru "Borssele" |
| Baarland (Pro) | ok (notes) | `w491657989`, unchanged | Kite between the buoys; do not enter the inlet to the left | [35 Knots](https://35knots.com/kitespot-baarland/): safe wind E (our hint S kept: the beach faces S, E is side-shore), strong current, lots of mud at low tide, free parking. Not seen on Windguru |
| Paulinapolder (Pro) | ok (notes) | `w491657962`, unchanged | Official area along the high-water line (2019 notice, search summary) | [Kitegids](https://kitegids.nl/kitesurf-tips/pagina-naam-met-kitesurfen-in-zeeland-erin/) lists it as a Westerschelde alternative. Not seen on Windguru |
| Oesterdam (Pro) | ok (notes) | `w822498440`, unchanged | On the Rijkswaterstaat Oosterschelde kite map (two icons at the dam) | [Unplug](https://www.unplug-kitesurf.com/spots/oosterschelde-oesterdam-netherlands): chop, small launch, March–May and Sept–Nov. Schools [Kiteboardschool](https://kiteboardschool.nl/kitesurfing-lessons-holland/kiteschool-oesterdam/) and SALT ([IKO](https://www.ikointl.com/school/netherlands/oesterdam/salt-kitesurfschool)). Windguru "Oesterdam" |
| Ouwerkerk (Pro) | ok, ban confirmed | `w621302487`, unchanged | **Closed 1 May to 1 October for bathers**, Rijkswaterstaat Oosterschelde folder (March 2020): matches our `banned` 05-01..09-30 | [Rijkswaterstaat folder](https://www.watersportverbond.nl/media/leohwbbb/oosterschelde-folder-010720.pdf): light-green kite icon, "open 1 October to 30 April". Not seen on Windguru |
| Cadzand-Bad – Vlamingpolder | **archived** | `w491657992` | "Cadzand-bad oost" kite area lifted by the Westerschelde authority in July 2019, buoys removed | Search summary of the [2019 notice](https://zoek.officielebekendmakingen.nl/stcrt-2019-37238.pdf). No current zone found; worst case applied. Easy to revive if a zone is confirmed |
| Terneuzen – Put van Terneuzen | **archived** | `w702126929` | Westerschelde kiting only in designated zones; none found for Terneuzen in either notice | Only [Kitegids](https://kitegids.nl/kitesurf-tips/pagina-naam-met-kitesurfen-in-zeeland-erin/) mentions it, as an "alternative". Not seen on Windguru |

## Added from the Windguru list

| Spot | Pin | Why |
|---|---|---|
| Grevelingendam, **archived** | `w141929167` (only candidate beach, ~700 m from the dam; **not checked on the right side of the dam**) | Windguru "Grevelingendam"; [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/grevelingendam-zeeland-netherlands.html): kiters keep right of the windsurf zone; [Kiteforum](https://se.kiteforum.com/kitesurf/spot/grevelingenmeer___grevelingendam): probably not officially allowed; Kitegids says the north side has seasonal limits; the Rijkswaterstaat map has a kite icon at Plaat van Oude-Tonge. Sources disagree on legality and side, so it goes in as archived (Windguru rule: anything odd) |

## Windguru, both ways (browsed as a visitor, 14 Nov)

Windguru's map has no kite tag, so I counted points named after a kite or windsurf centre or at one of our beaches, from Cadzand to the Grevelingen. About 12
distinct places. Matched to ours: 9. Added: 1 (archived). Left out: 4 (table). Gap line: none, Windguru shows fewer than we have.

| Windguru point | Ours |
|---|---|
| Brouwersdam (kite school, Natural High, Zeil- & Surfcentrum) | Brouwersdam |
| Neeltje Jans | Neeltje Jans |
| Domburg | Domburg |
| Vrouwenpolder | Vrouwenpolder |
| Kamperland, Snackpoint Wimpie | Kamperland – Roompot |
| Cadzand Bad | Cadzand-Bad – Zwin |
| Borssele | Borssele – De Kaloot |
| Oesterdam | Oesterdam (Tholen) |
| Grevelingendam | **added (archived)** |
| Westkapelle | left out: same wave coast as Domburg (our pin sits at the Westkapelse Zeedijk side); no separate kite source |
| Veerse Meer | left out: a sailing lake, no kite source, no OSM kite place |
| Krabbendijke | left out: not a designated kite location on the Rijkswaterstaat Oosterschelde map, which allows kiting only at designated locations (forums and [Kiteforum](https://se.kiteforum.com/kitesurf/spot/oosterschelde___krabbendijke) do list it) |
| Renesse – Kijkduin | left out: bathing beach, no kite source |

Our spots with no Windguru point I could see: Breskens – Oost, Baarland, Paulinapolder, Ouwerkerk, Terneuzen, Vlamingpolder (I did not hover every point east of Breskens).
