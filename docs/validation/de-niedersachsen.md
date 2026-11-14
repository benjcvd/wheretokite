# Validation: Lower Saxony coast and East Frisian islands (zone `de-niedersachsen`, WHE-177)

Date: 2026-11-14. Method: [Windguru variant](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov).
Counts for the zone: 14 rows → 15 rows (free 6 → 6, Pro 8 → 9, archived 0 → 0).
Past work: `git log` on `DE.csv` shows the earlier web pass only; no tide window or pin was changed in this pass.

**Limits of this pass (said plainly).** About 9 web searches and 9 page reads, plus Windguru browsed as a visitor.
The existing 14 rows were **not re-verified one by one**: their pins, tide windows and notes come from the earlier pass and
were only cross-checked against what turned up in the searches below (Schillig, Hooksiel, Neuharlingersiel, Sahlenburg,
Norddeich, Norderney, Wangerooge, Borkum all have kite listings; nothing contradicted our notes). Pins were not looked at on
satellite. The national park visitor guide for Weser–Jade (zone list) returned 403, so no official zone list was read, and
the Butjadingen kite-zone PDF was not opened. This zone is therefore **not fully validated**: the card stays `review` for the
Windguru comparison and the Dornumersiel addition, with the row-by-row check listed as the remaining work.

| Spot | Verdict | Sources and notes |
|---|---|---|
| Cuxhaven – Kugelbake, Sahlenburg | ok (earlier pass) | [Kiteforum Sahlenburg](https://se.kiteforum.com/kitesurf/spot/sahlenburg), kitemana guide: zone between groynes marked by white and yellow buoys, bathing area and nature reserve closed; tide about 3 h either side; school Kiterei. Matches our notes |
| Schillig, Hooksiel | ok (earlier pass) | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/schillig), Unplug lists a kite zone at Schillig; Hooksiel zone is signposted, kites only launched and landed in it |
| Neuharlingersiel | ok (earlier pass) | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/neuharlinger_siel), [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/neuharlingersiel-ostfriesland-germany.html) |
| Norddeich, Norderney, Borkum, Langeoog, Otterndorf, Dorum-Neufeld, Wremen, Tossens, Steinhuder Meer, Dümmer | not rechecked | Kept as they were. Norderney: Unplug Januskopf page mentions a car-use rule and a 300 m walk from Café Nordstrand; no kite-zone times found on the town side |
| **Dornumersiel (new, Pro)** | added | OSM `w263031767` is tagged `sport=kitesurfing` "Kitesurfzone Dornumersiel". [Lower Saxony tourism](https://www.niedersachsen-tourism.com/poi/kitesurfen-dornumersiel): official marked 80 ha zone in the national park, 3 h either side of high tide, open 1 May–15 Sep, kite school Vertigo on the beach. [Unplug](https://www.unplug-kitesurf.com/spots/dornumersiel-germany): shallow flat water, intermediate, NE–E and W–NW. Sources disagree on the season start (1 May vs 1 June): the earlier date is kept, the closure 16 Sep–30 Apr is encoded from the tourism page |

## Windguru, both ways (browsed as a visitor, 14 Nov, map "Spots" layer, coast from Borkum to Cuxhaven plus the two lakes)

Windguru's map markers carry only a place name: none says "kite" (only "Surfstrand" on Borkum, which is windsurf). So
"kite-named markers" in the zone: **0**. The table lists the markers on or near our spots and every other beach marker.

| Windguru marker | Ours / result |
|---|---|
| Cuxhaven (cluster), Sahlenburg | Cuxhaven – Kugelbake, Cuxhaven – Sahlenburg |
| Steinmarne (Cuxhaven) | left out: same coast as Kugelbake, no kite source found |
| Dorum | Dorum-Neufeld |
| Wremen | Wremen |
| Fedderwardersiel | left out: [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/fedderwardersiel-ostfriesland-germany.html) and a Feratel line mention a kite school and a Burhave–Fedderwardersiel zone, but the zone is "a few hundred metres south-east" and the nearest OSM beaches are 1.4 km away: no element fits where people ride, so it can't be pinned. Revive with the Butjadingen zone PDF |
| Schillig | Schillig |
| Hooksiel (Wilhelmshaven) | Hooksiel |
| Wilhelmshaven Geniusbank, Südstrand | left out: [guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/wilhelmshaven-suedstrand-ostfriesland-germany.html) says kiting is officially banned there, only tolerated; no school |
| Norddeich | Norddeich |
| Norderney, Norderney Weiße Düne (and cluster) | Norderney – Nordstrand |
| Borkum Nordstrand | Borkum – Nordstrand |
| Borkum Surfstrand, Borkum | left out: windsurf beach / town |
| Langeoog | Langeoog – Nordstrand |
| Baltrum, Neßmersiel, Bensersiel | left out: no kite source found for any of them |
| Spiekeroog (cluster) | left out: guide advises staying out of the national park, no zone found |
| Wangerooge (cluster) | left out: only Unplug (north beach, 1 Apr–31 Oct, 10:00 to 1 h before sunset, no school); one source, no school or town page, not pinned |
| Juist (cluster) | left out: kite school on the beach ([Juist tourism](https://juist.de/en/the-island/poi/detail/ju-i-st-kite-die-kite-surf-schule-auf-juist-1)) but no zone, rules or ride place stated, so it can't be pinned |
| Dümmersee (Lembruch), Steinhuder Meer | Dümmer, Steinhuder Meer |
| Otterndorf, Tossens | no Windguru marker seen at this zoom |

Counts: Windguru markers on the coast I could place about 28, kite-named 0, matched to ours 12, added as Pro 1
(Dornumersiel, which Windguru does not list under that name), left out 9 places above. Our spots on Windguru: Otterndorf and
Tossens not seen. Gap line: Windguru shows more markers than we have, but they are forecast points for towns and harbours, not
kite spots, so there is no real gap; the real open items are Fedderwardersiel/Burhave (pin), Wangerooge and Juist (no zone text).
