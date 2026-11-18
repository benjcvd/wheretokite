# Validation: east of England (zone `gb-east`, WHE-190)

Date: 2026-11-17. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru instead of Windy).
Zone = 8 rows of `GB.csv` (Essex, Suffolk, Norfolk, Lincolnshire). Counts: 8 → 8 (free 5 → 5, Pro 3 → 3, archived 0 → 0). No spot added, archived or revived. Notes changed on all 8 rows.
Past work: UK catalogue pass (`509e3b3`), tiers (`4a031c3`), Pro trim (`799c003`). Not redone.

Limits (said plainly): 8 web searches (snippets only, no page reads). Pins are unchanged OSM elements or place searches, **not re-checked on satellite**. No `banned` encoded: no official kite text found. Few schools on this coast, so several rows rest on guides.

| Spot | Verdict | Sources | Rules and notes |
|---|---|---|---|
| Shoebury East Beach | fixed (notes) | [Visit Southend](https://www.visitsouthend.co.uk/venue/southend-kitesurfing/); [Unplug](https://www.unplug-kitesurf.com/spots/east-beach-england-uk); [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/shoebury-east-beach-thames-estuary-great-britain.html); [QinetiQ access page](https://www.qinetiq.com/shoeburyness/public-access/prohibited-beaches) | Real, Essex Kitesurf Club and school. "Designated" comes from guides, no council map found: now said so. MOD foreshore, fast tide added |
| Felixstowe Ferry | fixed (notes) | [Unplug](https://www.unplug-kitesurf.com/spots/felixstowe-ferry-england-uk); [Kiteforum](https://se.kiteforum.com/kitesurf/spot/felixstowe_ferry); [BigSalty](https://bigsalty.com/en/windsurfing/guide/276/) | Low tide and SW agree with ours. School uses the area (name not found), limited space added |
| Sea Palling | ok (one source) | [Visit Norfolk](https://visitnorfolk.co.uk/points-of-interest/sea-palling-beach) | Only the reefs are confirmed. No school or rule found: note says so. Kept free, worst case would drop it: left for a second pass |
| Hunstanton | fixed (notes) | [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/hunstanton-east-north-east-england-great-britain.html); [BigSalty](https://bigsalty.com/en/windsurfing/guide/113/); [Kitejungle Old Hunstanton](https://kitejungle.com/kite-places/united-kingdom/old-hunstanton); [Kite Eze school](https://www.yumping.com/de/kitesurfen/kite-eze-kitesurfing-school--e19717072) | West-facing, SW, low tide agree. Added the high-tide alternative (Old Hunstanton) and crowd note. No official zone found |
| Cleethorpes (Humberston) | fixed (notes) | [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/cleethorpes-east-north-east-england-great-britain.html); [Discover NE Lincolnshire](https://www.discovernortheastlincolnshire.co.uk/?p=2289); [council habitat plan](https://www.nelincs.gov.uk/assets/uploads/2020/06/9.-Cleethorpes-Habitat-Management-Plan.pdf) | The "kites zoned" claim had no council page: now "reported". School at the Fitties end. Pin from a place name (already in TO_CONFIRM family) |
| Frinton-on-Sea (Pro) | fixed (notes) | [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/frinton-on-sea-thames-estuary-great-britain.html); [boards.co.uk](https://boards.co.uk/travel/uk-travel/frinton-sea-essex.html); [Push Kiting](https://www.yumping.com/en/water-sports/push-kiting--e19665709) | Greensward and tide window agree. Winds NE/S/SW added, light-wind rescue (Essex Police, May 2026) |
| Kessingland (Pro) | fixed (notes) | [Kiteforum Pakefield](https://se.kiteforum.com/kitesurf/spot/pakefield_corner); [Coast Radar](https://coastradar.com/places/united-kingdom/suffolk/kessingland-beach); [Kite and Windsurfing Guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/kessingland-east-north-east-england-great-britain.html) | "Council-approved" is an old Waveney approval, no East Suffolk page: softened. Nesting birds noted |
| Brancaster (Pro) | fixed (notes) | [National Trust kite sports](https://nationaltrust.org.uk/visit/norfolk/brancaster-estate/kite-sports-at-brancaster-beach); [NT safety](https://www.nationaltrust.org.uk/visit/norfolk/brancaster-estate/safety-at-brancaster-beach) | Official NT launch/landing zone at the entrance confirmed. Channel buoys and tern colonies added |

## Windguru, both ways (browsed as a visitor, 17 Nov, map)

Windguru markers in the zone that are named or tagged as a kite beach: **0 readable**. Matched: 0. Added: 0. Left out: 0.
The map shows plain forecast points with no kite tag: Brancaster Bay, Deepdale, Wells, Blakeney Harbour, East Runton, Mundesley, Hunstanton (2 markers) on the north Norfolk coast; unlabelled clusters along Suffolk and Essex (Frinton, Clacton, Southend side). Not a full zoom-by-zoom sweep of Lincolnshire.

| Windguru marker we don't have | Result |
|---|---|
| East Runton | not added: not kite-named on Windguru; a spot guide lists it but no school or local source read this pass |
| Mundesley, Wells, Blakeney, Deepdale | not added: not kite-named, no kite source found |

Our spots on Windguru: Hunstanton and Frinton show as plain forecast points; the others were not searched.

Gap line: no gap.

Open points (second pass): Sea Palling kite source, East Runton, Cleethorpes council rule, Felixstowe school name.

Build: `spot-check` on `GB.csv`, no PROBLEMS. Apple Maps agrees 87, uncertain 1 (Weymouth – Portland Harbour, outside this zone).
