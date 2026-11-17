# Validation: Friesland, Groningen, IJsselmeer and inland lakes (zone `nl-friesland-inland`, WHE-183)

Date: 2026-11-16. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time), Windy as benchmark (Ben's call of 15 Nov).
Past work: `NL.csv` history (Benelux trim, tiers, WHE-214 archive pass of 16 Nov). No open question in `TO_CONFIRM.md` for these rows.
Counts: 17 rows before and after. Before: 5 free, 5 Pro (Elburg, Kornwerderzand, Mirns, Harlingen, Delfzijl), 7 archived. After: 5 free, 7 Pro, 5 archived (Muiderzand, Bataviastrand, Trintelhaven, Lemmer, Oldambtmeer).

Limits (said plainly): pins are the OSM elements already in the CSV, unchanged, not re-checked on satellite. Rules come from the NKV (federation) spot pages, which say they are government-approved, not from decrees. About 12 web searches plus NKV page reads. The Elburg zone map photo was not readable.

## Our 17 spots

| Spot | Verdict | Sources and notes |
|---|---|---|
| Strand Horst (free) | fixed (notes) | [35 Knots](https://35knots.com/kitespot-horst/), [Kitedrop](https://www.kitedrop.de/spot/strand-horst/), school [Leer Kitesurfen](https://leerkitesurfen.eu/kitesurfles-strand-horst/); NKV Gelderland: open all year, shallow |
| Workum (free) | fixed (notes) | [NKV Friesland](https://kitesurfvereniging.nl/provincie/friesland/): all year, beginner, NW–SW; [KiteMobile](https://kitemobile.nl/waar-mag-je-kitesurfen-in-friesland-friese-ijsselmeer-kust/): lessons on site |
| Makkum (free) | fixed (notes) | [NKV Makkum](https://kitesurfvereniging.nl/kitespot/makkum/): October–April only, NW zone of the bay, N–S winds; ban `05-01..09-30` matches; KiteMobile agrees |
| Stavoren (free) | fixed (notes) | [NKV Stavoren](https://kitesurfvereniging.nl/kitespot/stavoren/): all year, advanced, W–S; municipality wants to close the swim spot in 2026; [Michaël's Kiteschool](https://www.michaels-kiteschool.nl/stavoren/). Depth disagrees between sources |
| Lauwersoog (free) | fixed (notes) | NKV: Wadden side all year, beginner, N–NW–W; [Lauwersmeer page](https://kitesurfvereniging.nl/kitespot/lauwersmeer/): June–September, yellow buoys, SW–SE; [kitegids](https://kitegids.nl/kitespots/lauwersmeer/) |
| Elburg (Pro) | fixed (notes) | [NKV Elburg](https://kitesurfvereniging.nl/kitespot/elburg/): April–September, advanced, launch from the water, max 10 kiters; school [Windy Waters](https://windywaters.nl/kitesurfen/) teaches there. Ban `10-01..03-31` matches |
| Kornwerderzand (Pro) | fixed (notes) | [NKV](https://kitesurfvereniging.nl/kitespot/kornwerderzand/): May–September, buoy zone; [KiteMobile](https://kitemobile.nl/waar-mag-je-kitesurfen-in-friesland-friese-ijsselmeer-kust/) lesson site. Ban `10-01..04-30` matches |
| Mirns (Pro) | fixed (notes) | NKV: all year, beginner, SE–W; KiteMobile lessons |
| Harlingen (Pro) | fixed (notes) | [Harlingen tourist office](https://www.harlingenwelkomaanzee.nl/en/highlights/water-sports-in-harlingen/kitesurfing) and [35 Knots](https://35knots.com/kitespot-harlingen/): advanced, best near high water, buoys 1 April–31 August; schools on site |
| Delfzijl (Pro) | fixed (notes) | [NKV](https://kitesurfvereniging.nl/kitespot/delfzijl/): all year, about 2 h around high water; [kite-and-windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/delfzijl-groningen-friesland-netherlands.html) |
| Hindeloopen | **revived → Pro** | Campsite school KBC (since 2000) at the spot: [camping Hindeloopen](https://www.campinghindeloopen.nl/faciliteiten/kitesurfen_amp_wingfoilen), [Kiteschool Hindeloopen](https://kiteschoolhindeloopen.com/); NKV all year; KiteMobile overflow for Workum |
| Zuidlaardermeer | **revived → Pro** | NKV Groningen: all year, advanced, SW–SE; [KiteMobile](https://kitemobile.nl/kitesurfen-in-groningen/) lessons on the lake. Older forum: tolerated (2010) |
| Lelystad – Bataviastrand | stays archived (tried as Pro) | [Visit Lelystad](https://www.visitlelystad.nl/nl/locaties/4205158778/bataviastrand): sports beach, info board shows kite sections; NKV Flevoland: all year, advanced, N–S winds. Build check failed: the OSM beach faces 35° (NE), the riding side is west, so it needs a better OSM element first |
| Almere – Muiderzand | stays archived | NKV lists Almere (advanced, all year) but no second source found |
| Lelystad – Trintelhaven | stays archived | NKV: April–July only; one source |
| Lemmer | stays archived | NKV October–April, KiteMobile "tolerated"; seasonal, one federation source |
| Oldambtmeer | stays archived | NKV October–April, SE–E, advanced; one source |

## Windy, both ways (browsed as a visitor, 16 Nov)

Windy kite markers in the zone: **19** (excluding Wadden Islands, North Holland and German markers). Matched to ours: **11**. Added: **0 new**, 2 of our archived spots revived as Pro. Left out: **8**.

| Windy marker | Result |
|---|---|
| Riviera 1★ | matched to our Elburg (campsite beach on the Veluwemeer, same water) |
| Harlingen 5★, Kornwerderzand 5★, Makkum 5★, Stavoren 5★, Mirns 5★, Lauwersoog Haven 5★, Strand Horst 5★ | matched, ours |
| Trintelhaven 4★, Zuidlaardermeer 3★, Oldambtmeer 1★ | matched (ours archived; Zuidlaardermeer revived to Pro, other two stay archived) |
| Heegermeer 4★ | left out: no kite source (forum thread says unclear if allowed) |
| Oostmahorn 3★ | left out: same Lauwersmeer water as our Lauwersoog; one older forum says kiting not allowed there |
| Leekstermeer 2★ | left out: no official zone, not a kite spot per KiteMobile |
| Polsmaten 3★, Hoophuizen 3★ | left out: no kite permission found in any source |
| Harderwijk 4★ | left out: town beach, no kite zone (spot guides) |
| Flevostrand 2★ | left out: Zeewolde zone, NKV says kiting not allowed there |
| Strand Nulde 2★ | left out: kiting prohibited (spot guides) |

Not on Windy: Workum, Hindeloopen, Lemmer, Delfzijl, Muiderzand, Bataviastrand (6 of ours; Workum and Delfzijl are well sourced).

Gap: Windy shows 19 markers against our 13 live, but 7 of the 8 left out are Veluwemeer lake spots where kiting is forbidden or unconfirmed. NKV also lists Oudega, Tjeukemeer and Eemshaven (not on Windy, not in our catalogue): a second pass could look at them.

Build check: `spot-check` on the 17 zone rows, see the card note for the result.
