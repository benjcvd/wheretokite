# Validation: Belgium (zone `be-all`, WHE-195)

Date: 2026-11-18. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru instead of Windy).
Zone = 11 rows of `BE.csv`. Counts: 11 → 11 (free 4 → 4, Pro 0 → 0, archived 7 → 7). No spot added, archived or revived. Notes changed on all 4 live rows.
Past work: Benelux pass (`2c1557a`), tiers (`4a031c3`), archive of the 7 club-only beaches (WHE-214, `799c003`). Archive not redone.

Limits (said plainly): 6 web searches (snippets only, no page reads). Pins are the unchanged OSM elements, **not re-checked on satellite**; Apple Maps agrees on all 4. No `banned` encoded: no official page found. A French blog mentions a national royal decree on kite zones, hours and insurance, but gives no text, so it is not used. The old notes said "club day membership required" as fact: no source confirms it, now worded "reported, check on site".

| Spot | Verdict | Sources | Rules and notes |
|---|---|---|---|
| De Panne | fixed (notes) | [IKO: Stevo Kitesurf, De Panne](https://app.ikointl.com/school/belgium/de-panne/stevo-kitesurf); [Unplug](https://www.unplug-kitesurf.com/spots/de-panne-belgium); [Kitejungle](https://kitejungle.com/kite-places/belgium/de-panne) | School on the wide beach, no breakwaters, best at high tide (the old note said low tide). Winds SW to NE per Unplug; our `NW` hint kept. No kite-zone page found |
| Oostende | fixed (notes) | [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/ostende-belgium.html); [Oostende tourism: Surf club Outside](https://oostende.org/en/surf/9228/surfcluboutside.html); [IKO Belgium](https://www.ikointl.com/destination/kitesurfing-belgium) | Real kite spot per guides. Inside Outside teaches surf and windsurf, kite lessons not confirmed, so the note no longer implies a kite club. Weakest of the four (one kite source) |
| Zeebrugge | fixed (notes) | [Visit Bruges: Icarus surf and kitesurf club](https://acc.visitbruges.be/en/icarus-surf-en-kitesurfclub-zeebrugge); [Unplug](https://www.unplug-kitesurf.com/spots/zeebrugge-belgium); [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/zeebrugge-belgium.html) | Icarus gives kite lessons, big surf zone free of breakwaters. Forum: leash compulsory, respect swim and surf zones. Build moved the pin to the NW-facing shore (warning, expected) |
| Knokke-Heist | fixed (notes) | [Knokke-Heist: Anemos Beach Club](https://www.myknokke-heist.be/en/sportinfrastructuur/anemos-beach-club); [Kiteforum Duinbergen](https://se.kiteforum.com/kitesurf/spot/duinbergen); [IKO Belgium](https://www.ikointl.com/destination/kitesurfing-belgium) | Anemos has a kite and windsurf desk; guides: strong wind, choppy, all levels. Pin on Anemos (Duinbergen). Het Zoute / Surfers Paradise only as a mention, no kite source found |

## Windguru, both ways (browsed as a visitor, 18 Nov, map)

Windguru markers on the Belgian coast that are named or tagged as a kite beach: **0 readable**. Matched: 0. Added: 0. Left out: 0.
Markers are plain forecast points, many clustered. The visible names were De Panne, Nieuwpoort Spaarbekken, Veurne-Voorstad and (just over the Dutch border) Zoute, Cadzand Bad. None is kite-tagged. Clusters were not expanded one by one, so this is not a full sweep. Our 4 spots: the map has a forecast point near De Panne and near Zoute; none flagged kite.

| Windguru marker we don't have | Result |
|---|---|
| none kite-named | nothing to add |

Gap line: no gap. Belgium's coast is short and kiting runs through clubs; the 7 club-only beaches stay archived (WHE-214).

Open points: whether day membership or a royal-decree rule really applies to visiting kiters (ask a school), kite lessons at Inside Outside.

Build: `spot-check` on `BE.csv`, no PROBLEMS. Apple Maps agrees 4, uncertain 0.
