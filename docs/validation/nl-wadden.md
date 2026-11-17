# Validation: Dutch Wadden Islands (zone `nl-wadden`, WHE-182)

Date: 2026-11-15. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru benchmark).
Counts for the zone: 9 → 9 live spots (free 3 → 3, Pro 6 → 6, archived 0 → 0). Seven rows had notes rewritten from official island rules and one got a tide window.
Build: `spot-check` on the 9 zone rows, exit 0, no PROBLEMS, Apple Maps direction check agrees 9/9.
Past work: `git log` on `NL.csv` shows only the Benelux build, the trim, tiers and the seasonal ban column. Nothing in `TO_CONFIRM.md` on the islands. No earlier check redone.

Limits (said plainly): 5 web searches plus official page reads, Windguru browsed as a visitor. Pins come from OSM elements, unchanged and not checked on satellite. `sector` and hints untouched: no source contradicted them. The Texel Strandnota map, the Terschelling decision map and the Schiermonnikoog PDF map were not opened.

| Spot | Verdict | Pin | Rules | Sources and notes |
|---|---|---|---|---|
| Texel – Paal 17 | fixed (notes) | `n3140654634`, unchanged | Kiting only on the "sporty" beach, poles 17.60–18.99; built-up beach 19–28 is closed to kiters; keep 50 m from the hard sea wall by the lighthouse | [Texel municipality](https://www.texel.nl/direct-regelen/toerisme-en-recreeren/recreeren/strandsporten/). [NKV spot map](https://kitesurfvereniging.nl/kitespot/texel-dijkmanshuizen/) and [35 Knots](https://35knots.com/kitespot-texel-paal-17/) agree on the spot |
| Texel – Paal 28 (Pro) | fixed (notes) | `n3140565781`, unchanged | Poles 28.20–32 allowed; 32–33.02 banned | Same municipality page; [Surfclub Texel](http://www.surfclub-texel.nl/Surfclub_Texel/Spot_info.html) lists the spots |
| Texel – Dijkmanshuizen (Pro) | ok (notes) | `w109266468`, unchanged | Only Wadden spot, 1 April–1 October: matches our `banned` 10-01..03-31 | Municipality page; [NKV](https://kitesurfvereniging.nl/kitespot/texel-dijkmanshuizen/) says April–September (one-day gap, official date kept) |
| Vlieland (Pro) | fixed (notes) | `n4586179268`, unchanged | North Sea beach west of the Badhuys only; east of it to the harbour and the Wadden Sea closed | [vlieland.nl](https://www.vlieland.nl/activiteiten-op-het-strand) (about a year old; guides place the limit differently, so worst case: west of the Badhuys). [Kite Club Vlieland](https://vlieland.org/nl/surf/10496/kite-club-vlieland.html): designated zones only |
| Terschelling – Noordzee | fixed (notes) | `n48471300`, unchanged | Whole North Sea coast open; 1 May–1 Oct no kiting within 200 m of beach accesses or within 100 m of the waterline. Partial rule, so not encoded as `banned` | [Gemeente Terschelling, aanwijzingsbesluit kitesurfen](https://decentrale.regelgeving.overheid.nl/cvdr/xhtmloutput/Historie/Terschelling/645044/CVDR645044_1.html); [Kitegids](https://kitegids.nl/kitespots/kitespot-terschelling-noordzee/) (waves, current, horses and swimmers) |
| Terschelling – Groene Strand (Pro) | fixed (notes, tide) | `r16919978`, unchanged | Own designated zone; high water ±3 h; not in the shipping channel; no launching on the pavilion's grass | Same decision; [VVV Terschelling](https://www.vvvterschelling.nl/kitesurfen-op-terschelling/), [35 Knots](https://35knots.com/kitespot-terschelling-groene-strand/). `tide` set to `high` |
| Ameland – Noordzee | fixed (notes) | `n7793664554`, unchanged | 1 Mar–1 Nov only at poles 8.2–11.3, 17.4–19, 3–4; winter 1 Nov–1 Mar allowed elsewhere | [VVV Ameland](https://www.vvvameland.com/about-us/faqs/activities-and-events/is-kitesurfing-allowed-on-ameland), [NKV](https://kitesurfvereniging.nl/kitespot/ameland-noordzee/) |
| Ameland – Waddenzee (Pro) | ok (notes) | `w655410097`, unchanged | West of the Nes ferry dam, designated area; ±3 h of high water per guides | VVV Ameland, [Kitegids](https://kitegids.nl/kitespots/kitespot-ameland/) |
| Schiermonnikoog (Pro) | fixed (notes) | `n503478243`, unchanged | Only the activity beach, Badweg access (east of pavilion Paal 3) to pole 5; no kiting elsewhere on the beach | [Gemeente Schiermonnikoog](https://www.schiermonnikoog.nl/kitesurfen-vliegeren-enz), [NKV](https://kitesurfvereniging.nl/kitespot/schiermonnikoog-noordzee/); Wadden side closed per guides |

## Windguru, both ways (browsed as a visitor, 15 Nov)

Windguru has no kite tag and its point names are towns, beaches and weather stations, so I counted points at our beaches. Kite-tagged markers: 0.
Points seen: Texel (Paal 9, Paal 33, Texel, Dijkmanshuizen), Vlieland, Terschelling (West-Terschelling, Kinnum, Formerum, Oosterend), Ameland (Ballum Strand, Burensteiger, Nes Pier Oost), plus unnamed clusters on Terschelling and Schiermonnikoog. The search box for "kite Wadden" returned nothing.
Matched to ours: 6 (Dijkmanshuizen, Vlieland, West-Terschelling, Burensteiger, Nes Pier, Ballum Strand). Added: 0. Gap line: none, Windguru shows no more kite places than we have.

| Windguru point | Ours |
|---|---|
| Dijkmanshuizen, Texel | Texel – Dijkmanshuizen |
| Texel Paal 9, Texel Paal 33 | left out: Paal 9 is built-up beach where kiting is not allowed (Texel municipality); Paal 33 is in the banned stretch 32–33.02 |
| Vlieland | Vlieland |
| West-Terschelling | Terschelling – Groene Strand |
| Kinnum, Formerum, Oosterend (Terschelling) | left out: village points on the Wadden side, no kite source, Wadden Sea closed |
| Ameland Burensteiger | Ameland – Noordzee (Buren zone) |
| Ameland Nes Pier Oost | Ameland – Waddenzee |
| Ameland Ballum Strand | Ameland – Noordzee (Nes/Ballum zone, same coast) |
| Lauwersoog Waddenzee | other zone (Groningen) |

Our spots with no clear Windguru point: Texel – Paal 17/28 (only Paal 9 and 33 seen, which are not kite beaches), Schiermonnikoog (unnamed clusters not opened).

## Windy, both ways (browsed as a visitor, 16 Nov, WHE-210)

Windy kite markers (`p:kitespots`, zoom 10, hovered one by one for name and stars) on the Dutch Wadden Islands: 6. Matched to ours: 6. Added: 0. Left out: 0. Our spots 9 live → 9 live (free 3, Pro 6, archived 0): no change to the CSV.
Gap line: none. Windy shows no more kite places on the islands than we have.
Markers on the mainland coast, Wieringen and Lauwersmeer belong to other zones (Friesland, North Holland, Groningen) and were not counted here.

| Windy marker (stars) | Ours |
|---|---|
| Texel (5), at De Koog | Texel – Paal 17 (same west beach; Paal 28 and Dijkmanshuizen are further south and east) |
| Vlieland (4) | Vlieland |
| West Terschelling (3) | Terschelling – Groene Strand |
| Terschelling, West aan Zee (2) | Terschelling – Noordzee |
| Ameland (4), at Nes | Ameland – Waddenzee (Nes), with Ameland – Noordzee on the same island |
| Schiermonnikoog (2) | Schiermonnikoog |

Our spots with no Windy marker of their own: Texel – Paal 28, Texel – Dijkmanshuizen (Windy has one Texel marker for the whole island), Ameland – Noordzee (shares the Ameland marker).
Limits: marker positions were not used to place or confirm any pin (OSM and the island rules only). Nothing needed adding, so no pipeline build was needed.
