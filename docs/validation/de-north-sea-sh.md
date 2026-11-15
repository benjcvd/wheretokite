# Validation: Sylt, St. Peter-Ording and the Schleswig-Holstein North Sea (zone `de-north-sea-sh`, WHE-175)

Date: 2026-11-14. Method: [Windguru variant](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov).
Counts for the zone after the Windy pass (WHE-203, 15 Nov): 9 → 13 rows (free 3 → 3, Pro 6 → 10, archived 0 → 0). 4 Pro added from Windy markers.
Past work: `git log` on `DE.csv` shows only the wave 1/2 curation and WHE-91 gap pass (Prerow, not in this zone); nothing in
`TO_CONFIRM.md` about this zone beyond the general Germany lines. No earlier check redone.

Limits of this pass (said plainly): 4 web searches, 2 official national-park flyers read in Chrome, 1 Kitemana page,
Windguru browsed as a visitor (name search only: its map shows no spot markers at this zoom). Pins unchanged (OSM
elements already in the file); not re-checked on satellite. Tide windows for Husum, Nordstrand, Dagebüll come from spot guides
only (no official text exists for them). Föhr, Amrum and Eiderstedt were not searched on Windguru.

| Spot | Verdict | Rules and sources |
|---|---|---|
| Sylt – Westerland (Buhne 16) | fixed (notes) | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/buhne-16-sylt-nordfriesische-inseln-germany.html) and [Unplug](https://www.unplug-kitesurf.com/spots/sylt-buhne-16-germany): intermediate to expert kite spot; lifeguarded beach. Notes now say "Buhne 16", the name riders use. Windguru "Buhne 16" and "Brandenburger Strand" |
| Sylt – List (Königshafen) | fixed (notes) | Official: [national park flyer 2021](https://www.nationalpark-wattenmeer.de/wp-content/uploads/2022/06/FB_Kiten-und-Surfe_Sylt_web.pdf): protection zone 1, ride only inside the buoy chain, set up and launch only on the kite beach, kite about ±3 h around high water. Second source: [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/koenigshafen-sylt-nordfriesische-inseln-germany.html): only the upper half of the tide. Tide `high` is right. No `banned` (a rule, not a ban). Windguru "Königshafen" |
| Sylt – K4 (Hörnum) | fixed (notes) | Same flyer: K4 at crossing 74 is a named surf and kite beach, big car park, ask schools which tide. Windguru has no K4 |
| Sylt – Hörnum Möwennest | fixed (notes) | Same flyer: kite only ±3 h around **low** water, 300 m from the Hörnum Nehrung bird area, kites included. Tide `low` is right. Windguru "Hörnum Ost" (east side of Hörnum) |
| Sankt Peter-Ording | fixed (notes) | Official: [LKN.SH / municipality flyer 2023](https://www.nationalpark-wattenmeer.de/wp-content/uploads/2024/04/FB_SPO_Kiten-2023_web.pdf): kite area north and south of St. Peter-Ording by the North Sea navigation ordinance, central sandbank quiet zone, Ording bathing area marked by pile rows and a buoy chain. Second: [Kitemana guide](https://www.kitemana.com/en-no/info/blog/kitespot-st-peter-ording-in-germany-1593): zones left and right of the bathing area, about 2 h around high tide, Böhl for beginners; [tourist office](https://www.st-peter-ording.de/en/activities-culture/kiteboarding-surfing/). Windguru "Sankt Peter-Ording" |
| Büsum – Perlebucht | fixed (notes) | [Kitemana](https://www.kitemana.com/en-us/info/blog/kitespot-buesum-in-germany-1596) and [thekitemag](https://www.thekitemag.com/travel-list/busum/): the lagoon is cut off from the sea and not tidal, advanced riders only (VDWS 5), sign in at the school, no E winds. The shallows in front follow the tide. Tide `high` kept (worst case, both views in notes). Windguru "Büsum" |
| Husum – Dockkoog | ok | [Unplug](https://www.unplug-kitesurf.com/spots/dockkoog-germany): intermediate, chop and small waves, high tide, showers and car park. One kite source only, stays Pro. No school found. Not on Windguru |
| Nordstrand – Holmer Siel | ok | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/holmer-siel-nordfriesland-germany.html): sailable about 5 h around high water, 3 h standing depth, mud dams. [Surf-Magazin](https://www.surf-magazin.de/en/spots-and-areas/north-sea/spot-guide-the-best-windsurfing-spots-on-nordstrand/) covers Nordstrand (windsurf-oriented). Two sources, no school. Not on Windguru |
| Dagebüll | ok (weak) | [Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/dagebuell-nordfriesland-germany.html): a warm-up session while waiting for the Föhr/Amrum ferry. One source. Stays Pro (tier is Ben's call). Windguru has only the town |

## Windguru, both ways (browsed as a visitor, 14 Nov)

Windguru spots in the zone: Sylt (13 named beach forecasts), Sankt Peter-Ording, Büsum. **None is named or tagged as a kite
spot**, so the count of kite markers is 0 and nothing needs adding under the Windguru rule. Our spots found on Windguru as a
forecast point: 5 of 9 (Buhne 16 / Brandenburger Strand, Königshafen, Hörnum Ost, St. Peter-Ording, Büsum). Not on Windguru:
K4, Husum, Nordstrand, Dagebüll (town only).

| Windguru point | Ours |
|---|---|
| Buhne 16, Brandenburger Strand | Sylt – Westerland |
| Königshafen, List | Sylt – List |
| Hörnum Ost | Sylt – Hörnum Möwennest |
| Sankt Peter-Ording | Sankt Peter-Ording |
| Büsum | Büsum – Perlebucht |
| Ellenbogenspitze | left out: not kite-tagged; a school page mentions Ellenbogen (List), but it is 3 km from Königshafen, no OSM kite element chosen |
| Rantum Ost, Munkmarsch, Wenningstedt, Kampen, Nordseeklinik, Sansibar, "Sylt" | left out: not kite-tagged, no kite source found (Munkmarsch is a windsurf spot) |

Gap: none. Windguru shows no more kite spots than we have.

## Windy, both ways (browsed as a visitor in Chrome, 15 Nov, WHE-203)

Method: step 2 of the [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time), markers hovered on the kite-spots layer
(Sylt to Büsum, plus Helgoland), stars read as a visitor sees them. 6 web searches. Overpass was down all day: pins come from the
OSM API (`map?bbox`) and Nominatim, not eyeballed on satellite.

**Counts:** 20 Windy kite markers in the zone. Matched to ours: 7 (Sylt, List, Hörnum, St. Peter-Ording, Büsum, Dockkoog, Holmer Siel).
Added as Pro: 4. Left out: 9. Not on Windy: K4 as its own marker (Windy's Rantum / Hörnum cover it), Möwennest, Dagebüll.

| Windy marker (stars) | Ours / result |
|---|---|
| Sylt (4) | matched: Sylt – Westerland |
| List (3) | matched: Sylt – List (Königshafen) |
| Hoernum (4) | matched: Sylt – K4 (Hörnum) / Hörnum Möwennest |
| Rantum (3) | left out, same area as K4: [Kitedrop Sylt](https://www.kitedrop.de/locations/sylt/) names K4 at Rantum as the experienced kiters' spot |
| Wenningstedt (2) | **added (Pro)**: [Kitedrop](https://www.kitedrop.de/spot/wenningstedt/) spot page, [Südkap Surfing](https://www.suedkap-surfing.de/kursueberblick/kitesurfkurse-sylt) school at Wenningstedt. Pin `osm:w830760032` (small beach way, check on satellite) |
| St. Peter-Ording (5) | matched: Sankt Peter-Ording |
| St. Peter-Boehl (4) | **added (Pro)** as Sankt Peter-Böhl: schools meet there ([Kitesurfing Experience](https://www.kitesurfing-experience.de/st-peter-ording), [iKSURFmag](https://www.iksurfmag.com/travel-guides/europe/germany/sankt-peter-ording/)); only tolerated, no official zone (forums 2012-13), said in notes, no ban encoded. Pin `osm:w174287224` |
| Vollerwiek (1) | left out: guide calls it not an official spot, no school or club ([Kitedrop](https://www.kitedrop.de/spot/simonsberg/) / guide list); no OSM element at a kite place |
| Buesum (4) | matched: Büsum – Perlebucht |
| Meldorfer Bucht (4) | left out: sources contradict on legality (south side banned, 400 m north of the harbour mole banned since 2007 per one, allowed per another, Speicherkoog banned), no OSM element at the north-side ramp; worst case per the 2 Nov rule. Sources: [Kite Buddy](https://www.kite-buddy.de/kitespot-meldorf), [ewigkite](https://ewigkite.de/drachesachen/27-spots/225-meldorfer-bucht), [Nordseewindsport school](https://nordseewindsport.de/Konzept/) |
| Dockkoog (1) | matched: Husum – Dockkoog |
| Trender Marsch (1) | left out: one guide ([kite-and-windsurfing-guide Nordfriesland](https://web.kite-and-windsurfing-guide.com/de/europa/deutschland/nordfriesland.html)), dike spot, no OSM element at the riding place, can't be pinned |
| Simonsberg (1) | left out: one guide ([Kitedrop](https://www.kitedrop.de/spot/simonsberg/)), dike spot, no OSM element at the riding place, can't be pinned |
| Holmer Siel (1) | matched: Nordstrand – Holmer Siel |
| Wittduen (2) | **added (Pro)** as Amrum – Wittdün Badebucht: [Surfclub Amrum school](https://www.waterstart.de/de/schulen/surfclub-amrum/), [kite guide](https://web.kite-and-windsurfing-guide.com/de/surfspots/kitesurfen-windsurfen-sup/wittduen-amrum-nordfriesische-inseln-deutschland.html), island news on the rules ([amrum-news, Jul 2025](https://www.amrum-news.de/2025/07/10/hinweise-fuer-wassersportler-an-der-amrumer-odde/)). Bird closure in spring (dates differ by source) in notes only. Pin `osm:w90585466` (south-tip beach, bay side to check on satellite) |
| Norddorfer Strand (2) | left out: school on the beach and a guide say beginners' water, but no OSM beach element at Norddorf (the Kniepsand way centres 4 km away), can't be pinned |
| Nieblum (2) | **added (Pro)** as Föhr – Nieblum: [Nieblumer Wassersport Schule](https://www.spotnetz.de/Foehr_Nieblum), [Sitkite guide](https://keepseated.com/2019/07/08/sitkite-spotguide-nieblum-auf-foehr/), [Kitereisen TV](https://www.kitereisen.tv/foehr-nieblum-nordfriesland-deutschland-kitespot-kitesurfen/); tide `high`. Pin `osm:w221516977` (a `sport=surfing` way at Nieblum beach) |
| Wyk (3) | left out: sources conflict (south beach only in school-marked zones; main beach and harbour closed per a guide); worst case, nothing official read. Source: [foehr.de](https://www.foehr.de/surfen-kiten-sup), [Westend Surfing](https://westendsurfing.com/spotguide-kitesurfen-fohr/) |
| Föhr (1) | left out: no local source tied to this marker (north tip), can't be pinned |
| Helgoland (5) | left out: kiting and kite flying banned by the municipality ([helgoland.de](https://www.helgoland.de/untersagt-kite-surfen-und-drachen-steigen-lassen/)), official, all year |

Gap: Windy shows 20 markers, we match 7 and add 4; the rest are dike spots, conflicting-rules beaches or banned. A second look at Wyk
and Meldorf (official rules) and the Norddorf and dike pins (OSM elements) could add up to 5 more once Overpass is back.

Build (15 Nov, the 13 zone rows, exit 0): no PROBLEMS, Apple Maps agrees 12 of 13. One `uncertain`: Amrum – Wittdün Badebucht (OSM water faces ESE 121°, Apple 72°, 48° apart). The bay is curved at the island's south-east tip, so both are plausible; hint SE kept, pin to be eyeballed on satellite.
