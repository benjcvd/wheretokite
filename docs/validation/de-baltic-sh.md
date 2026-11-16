# Validation: Fehmarn, Kiel and the Schleswig-Holstein Baltic (zone `de-baltic-sh`, WHE-176)

Date: 2026-11-14. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru instead of Windy).
Zone = the 11 Baltic rows of `DE.csv` (region Schleswig-Holstein; the North Sea rows belong to WHE-175).
Build: `spot-check` on `DE.csv`, no PROBLEMS; Apple Maps agrees 51 of 51 (all DE rows).
Counts: 11 → 11 rows (free 7 → 7, Pro 4 → 4, archived 0 → 0). No spot added, none archived.
Past work: `git log` on `DE.csv` shows only the Oct catalogue passes and the WHE-91 gap pass; `TO_CONFIRM.md` had two open pin questions (Holnis side, Pelzerhaken launch), still open.

Limits of this pass (said plainly): about 14 web searches and 8 page reads. Pins are unchanged OSM elements, not re-checked on satellite
(Chrome was used for Windguru only). No official kite text found for any spot, so **no `banned` is encoded**; the Fehmarn 2026
beach by-law PDF could not be read (compressed PDF, no text tool here), so Fehmarn beach rules are not confirmed from it.
Notes rewritten from the sources; the sector column stays empty, as before.

| Spot | Verdict | Sources (two independent where found) | Rules and notes |
|---|---|---|---|
| Holnis | fixed (notes) | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/holnis); [Flensburger Förde tourism](https://www.flensburger-foerde.de/en/water-sports/surfing-kitesurfing-foiling) names Holnis as a kite beach; Windguru "Holnis Strand – Foerdekiter" | Kite left of the mole, swimmers only to the south (guide, no official text). Which side our pin is on: still in TO_CONFIRM |
| Flensburger Förde – Schausende (Pro) | ok (notes) | [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/schausende-foerdenland-germany.html); Windguru "Schausende Hafen" (flag marker). One kite source only: stays Pro | About 1 km from Holnis, same fjord; not merged into Holnis because it faces another way |
| Laboe | fixed (notes) | [Kite and windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/laboe-kieler-bucht-germany.html) (SW works; kite only between breakwater and east nature reserve); [Surf magazine](https://www.surf-magazin.de/spots-und-reviere/ostsee/laboe-spot-am-hafen-fuer-wassersportler-gesperrt/); [Kitemana](https://www.kitemana.com/info/blog/kitesurfing-spots-in-germany-1577) (NE–E) | Harbour-front beach closed to water sports in the bathing season, by the municipality per the magazine, no date and no official text: in notes, not `banned` |
| Stein (Pro) | fixed (notes) | [Unplug](https://www.unplug-kitesurf.com/spots/stein-germany) (W–NW, E gusty); school Tatort Hawaii offers kite on the beach (its brochure); [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/stein-kieler-bucht-germany.html) | The "Also: Stein" line removed from Laboe: Stein is its own row |
| Heiligenhafen | fixed (notes), 1 question | [Kitemana](https://www.kitemana.com/info/blog/kitespot-heiligenhafen-1620) (Graswarder only, Steinwarder and Binnensee banned, experienced only); [Unplug](https://www.unplug-kitesurf.com/spots/heiligenhafen-germany) (marked zone east Steinwarder); [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/heiligenhafen-fehmarn-germany.html) (NW waves) | The old note said "beginner zone": wrong, all sources say experienced. Sources disagree on Steinwarder vs Graswarder; our pin is the water sports centre on the marina side. Kept free, no ban encoded, TO_CONFIRM |
| Fehmarn – Gold | ok (notes) | [Kitemana, Fehmarn](https://www.kitemana.com/en-us/info/blog/kitespot-fehmarn-1613); [Kitemana, Germany](https://www.kitemana.com/info/blog/kitesurfing-spots-in-germany-1577); [t-online](https://www.t-online.de/gesundheit/fitness/id_69663126/kitespots-in-deutschland-die-besten-orte-zum-kitesurfen.html) (W: Lemkenhafen, Gold, Orther Reede); Windguru forecast point "Gold" | Learn-to-kite reference for the Baltic; the "Also: Lemkenhafen" line removed (own row) |
| Fehmarn – Wulfener Hals | fixed (notes) | [Kiteforum](https://se.kiteforum.com/kitesurf/spot/fehmarn___wulfener_hals) (best E, bay standing depth, **kiting 18:00–10:00, daytime for courses only**); Kitemana (E, standing depth); [Surf magazine](https://www.surf-magazin.de/en/spots-and-areas/baltic-sea/fehmarn-guide-the-best-windsurfing-spots-on-fehmarn/) (W–NW gusty) | The time limit comes from one user-written page (camping runs the bay), not from a decree. Kept with a clear note; riders arriving at midday should ask first |
| Fehmarn – Grüner Brink | ok (notes) | [Kitejungle](https://kitejungle.com/kite-places/germany/fehmarn-gruner-brink) and Kitemana (E through W, not S, reserve closed); [Surf magazine](https://www.surf-magazin.de/en/spots-and-areas/baltic-sea/fehmarn-guide-the-best-windsurfing-spots-on-fehmarn/) (expect kiters); Windguru forecast point | Nature reserve by state decree, text not read: its edge stays out of bounds. No kite ban encoded |
| Pelzerhaken | ok (notes) | [Windfinder guide](https://www.windfinder.com/spotguide/pelzerhaken) (designated kite zone); [Unplug](https://www.unplug-kitesurf.com/spots/pelzerhaken-germany) (SW–NW); [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/pelzerhaken-luebecker-bucht-germany.html); Windguru forecast point | Launch side still in TO_CONFIRM |
| Großenbrode (Pro) | ok (notes) | Kitemana (west beach flat SW–N with stones, south beach NE–SE); Windguru "Großenbrode" and "Großenbrode Südstrand". One kite source: stays Pro | Which beach our pin is on is shown by the Apple Maps check below |
| Fehmarn – Lemkenhafen (Pro) | ok (notes) | [KiteWorldWide school](https://kiteworldwide.com/kitespots/fehmarn-lemkenhafen) on site; t-online (W wind); Windguru forecast point | |

## Windguru, both ways (browsed as a visitor, 14 Nov, map search by place name)

Windguru's map shows forecast points, not kite ratings. I searched each of our spot names and "Fehmarn", "Kiel", "Hohwacht", "Großenbrode":
the markers that carry the school/club flag in the zone are four. Matched to ours: 2. Added: 0. Left out: 2.
Plain forecast points with no flag (Gold, Grüner Brink, Lemkenhafen, Klausdorfer Strand, Burgtiefe, Presen, Flügge, Großenbrode and Südstrand,
Hohwacht, Kiel, Pelzerhaken, Laboe, Heiligenhafen, Stein) are not kite markers: counted as "ours or not kite".
Not a full map sweep: Lübeck Bay beyond Pelzerhaken and Eckernförde Bay were not searched (outside the zone's spots).

| Windguru marker | Ours |
|---|---|
| Holnis Strand – Foerdekiter (flag) | Holnis |
| Schausende Hafen (flag) | Flensburger Förde – Schausende |
| Gollendorf Primesurf, Fehmarn (flag) | left out: a windsurf school; no kite source and no OSM kite element, only a forecast point |
| Strande, Surf Club Kiel e.V. (flag) | left out: a windsurf club; Kiel tourism tags Strande beach as a surf spot, no kite source |

Gap: none. Windguru shows no kite-named spot we lack. Fehmarn spots without a Windguru flag (Gold, Wulfener Hals, Lemkenhafen) are in our list from schools and guides.

## Windy, both ways (WHE-204, browsed as a visitor in Chrome, 15 Nov; hover on `p:kitespots` markers, ratings as shown)

**Partly done: stopped here, card stays in `doing`.** Windy has many more kite markers on this coast than the 11 rows we had (about 44 read).
Adding every one as Pro needs an OSM pin and a local source each (no search tool gives that cheaply), so I did a first tranche
of the best-supported ones and left the rest listed, undecided. Nothing here is judged from memory: "open" means not yet researched.
Not browsed on Windy: the Flensburg Förde (Holnis, Schausende: "not checked on Windy"), and one unread marker west of Eckernförde bay.

Third session (16 Nov): 3 rows added as Pro (Schönberger Strand incl. Kalifornien, Kellenhusen, Dahme); Pro 11 → 14; open markers 26 → 20 (one merged into Schönberger Strand). Overpass was down for a while; builds were slow.

Counts (second session, 15 Nov): 44 markers read; 10 matched to 9 of our rows; 7 added as Pro (3 + 4 on Fehmarn); 1 left out (no OSM element); 26 open. Ours before → after: free 7 → 7, Pro 4 → 11, archived 0 → 0 (DE Baltic SH).

| Windy marker (stars) | Ours / outcome |
|---|---|
| Grüner Brink (5), Gold (5), Wulfener Hals (5), Lemkenhafen (5) | ours |
| Heiligenhafen (5), Pelzerhaken (5), Laboe (5), Stein (4) | ours |
| Großenbrode Südstrand (5), Großenbrode West (4) | ours: Großenbrode (one row, west and south beach) |
| Strande (5) | **added (Pro)**: [kitejungle](https://kitejungle.com/kite-places/germany/strande), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/strande-kieler-bucht-germany.html), [Kiel Sailing City](https://kiel-sailing-city.de/en/active/windsurfing-and-kiting). Pin: beach `w553002928` (town beach). Build faces 121°, Apple Maps agrees |
| Heidkate (5) | **added (Pro)**: [VDWS Surfschule Heidkate](https://www.vdws.de/en/watersport-center/surfschule-heidkate), [kitejungle](https://kitejungle.com/kite-places/germany/heidkate), [Unplug](https://www.unplug-kitesurf.com/spots/heidkate-germany), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/heidkate-kieler-bucht-germany.html). Pin `w35094502`, faces 12°, agrees |
| Hohwacht (4) | **added (Pro)**: [Unplug, Hohwacht Hafen](https://www.unplug-kitesurf.com/spots/hohwacht-hafen-germany), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/hohwacht-kieler-bucht-germany.html). No school found, so Pro, guides only. Pin `w34035919`, faces 40°, agrees |
| Orth East (5) | **added (Pro)** as Fehmarn – Orth (Orther Bucht): [kiteforum](https://se.kiteforum.com/kitesurf/spot/fehmarn___orth_east), [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/orth-fehmarn-fehmarn-germany.html), [Kitemana](https://www.kitemana.com/info/blog/kitespot-fehmarn-1613). Pin: OSM bay `w24943928` (tagged kitesurfing). Facing flips between 268° and 323° with the hint (bay polygon, not a beach); Apple Maps agrees; about 1.5 km from Lemkenhafen on the other shore |
| Bojendorf (3) | **added (Pro)** as Fehmarn – Bojendorf (Wallnau): [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/bojendorf-fehmarn-fehmarn-germany.html), [Unplug Wallnau](https://www.unplug-kitesurf.com/spots/fehmarn-wallnau-germany). Pin: Wallnau beach `n2491080542` (naturist beach, in notes); faces 289°, agrees |
| Miramar (3) | **added (Pro)** as Fehmarn – Miramar (Fehmarnsund): [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/miramar-fehmarn-fehmarn-germany.html), [Surf magazine](https://www.surf-magazin.de/en/spots-and-areas/baltic-sea/fehmarn-guide-the-best-windsurfing-spots-on-fehmarn/). Pin `w464928948`, faces 183°, agrees |
| Meeschendorf (3) | **added (Pro)**: [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/meeschendorf-fehmarn-fehmarn-germany.html), Surf magazine (same page). Pin `w51000890`, faces 186°, agrees |
| Westermarkelsdorf (4) | left out: no OSM beach element within 5 km of the village (the spot is a dike), so it can't be pinned. Sources exist ([Windfinder](https://en.windfinder.com/spotguide/westermarkelsdorf), [kiteforum](https://se.kiteforum.com/kitesurf/spot/fehmarn___westermakelsdorf), school Primesurf takes students there) |
| Fehmarn: Teichhof (2), Niobe (2), Presen (1), 1 unnamed north-coast marker | open |
| Kellenhusen (4) | **added (Pro)** (third session, 16 Nov): [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/kellenhusen-luebecker-bucht-germany.html), [Unplug](https://www.unplug-kitesurf.com/spots/kellenhusen-germany). Pin: Badestrand `w245451559`; build result below |
| Dahme (4) | **added (Pro)**: [Kiteforum](https://se.kiteforum.com/kitesurf/spot/dahme), [Hamburg tourism](https://www.hamburg-tourism.de/sehen-erleben/veranstaltungen/veranstaltungskalender/schnupperkurs-kitesurfen/) (Surfschule Dahme kite taster). Pin: beach `w233630237` |
| Grömitz (5) | open: searched again, no kite school or spot page found, no local source |
| Damshöved (3), Klostersee (1) | open: [Unplug Dahmeshöved](https://www.unplug-kitesurf.com/spots/dahmeshoeved-germany) and [Klostersee](https://www.unplug-kitesurf.com/spots/klostersee-germany) pages exist, not read; Damshöved is 2 km from Dahme |
| Haffkrug (3), Dazendorf (2) | open |
| Schönberger Strand (3) and Kalifornien (3) | **added (Pro)** as one row, Schönberger Strand (Kalifornien): same beach (Kalifornien and Brasilien are sections of the 6 km dyke beach per [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/schoenberger-strand-kieler-bucht-germany.html)); [Unplug](https://www.unplug-kitesurf.com/spots/schoenberger-strand-germany), [Kitemana](https://www.kitemana.com/en-us/info/blog/kitespot-laboe-und-schoeneberg-1610). Pin `w37393111` |
| Kiel Bay: Falkenstein (3), Weissenhaus (3), Lippe (2), Behrensdorf (1), Hohenfelde (1) | open (guide pages exist for [Falkenstein](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/falkensteiner-strand-kieler-bucht-germany.html) and [Weissenhaus](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/weissenhaus-kieler-bucht-germany.html), not read; no OSM element found for Falkenstein by name) |
| Eckernförde bay: Grönwold (4), Surendorf (3), Stohl (3), Langholz (2), Karlsminde (2), Aschau (1), Kiekut (1) + one unread | open (Eckernförde tourism has a surf and kite page) |

Gap: yes, 26 Windy markers are still open (about half rated 3 or more). Many of the low-rated ones are probably tiny user-added points; each still needs a source before it goes in.
