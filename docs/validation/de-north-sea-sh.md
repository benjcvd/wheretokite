# Validation: Sylt, St. Peter-Ording and the Schleswig-Holstein North Sea (zone `de-north-sea-sh`, WHE-175)

Date: 2026-11-14. Method: [Windguru variant](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov).
Counts for the zone: 9 → 9 rows (free 3 → 3, Pro 6 → 6, archived 0 → 0). No spot added or archived.
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
