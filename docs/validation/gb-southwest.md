# Validation: Devon, Cornwall and Somerset (zone `gb-southwest`, WHE-188)

Date: 2026-11-16. Method: [validation method](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov) (Windguru benchmark).
Counts for the zone: 11 rows → 12 rows (free 7 → 6, Pro 4 → 5, archived 0 → 1), 11 live spots.
Build: `spot-check` on `GB.csv`, no PROBLEMS. Direction check: all zone spots agree with Apple Maps (the one `uncertain`, Weymouth – Portland Harbour, belongs to the south-coast zone).
Past work: `git log` on `GB.csv` shows only the UK trim to famous spots and the tiers/bans commits. `TO_CONFIRM.md` only asks about Exmouth's directions (kept, see below). No earlier sourced check redone.

Limits of this pass (said plainly): about 22 searches and page reads. Pins come from OSM elements and were not re-checked on satellite. Directions and `sector` were not changed: no source contradicts them. Several club pages (Kernow Kitesurf Club, kite-and-windsurfing guide) are undated. The East Devon and Torridge council pages returned 403, so Exmouth and Westward Ho! rules rest on guides and search summaries. There is no official UK kite-ban source for any row, so no `banned` rule was added.

| Spot | Verdict | Rules | Sources and notes |
|---|---|---|---|
| Brean | **archived** | Somerset Council: only members of the Brean Land Yacht Club and SWATK may sail on the beach, at organised meetings. That is land kiting, but nothing says anyone kitesurfs here | [Somerset Council beaches](https://somerset.gov.uk/beaches-ports-and-flooding/somerset-beaches). No school, guide or club found for kitesurfing; not on Windguru. Worst case applied. Weston-super-Mare covers the area |
| Saunton Sands | fixed (ban removed) | The old 1 Jul–31 Aug ban has no official source, and the [iKSurfmag guide](https://www.iksurfmag.com/travel-guides/europe/united-kingdom/westward-ho/) describes a lifeguarded May–Sept season with a marked kite area, not a ban. Moved to notes. Lessons are not allowed | [Forum 2011](https://www.extremekites.org/topic/146042-north-devon-beaches-for-kite-surfing/): ride past the rocks, stay clear of the hut. Cross-shore SW/NW per local guides. Windguru "Saunton Sands" |
| Watergate Bay | ok | Marked riding zones; no kiting 2 h either side of high tide; not between lifeguard flags in season; private beach | [Unplug](https://www.unplug-kitesurf.com/spots/watergate-bay-england-uk) (intermediate, winds N–SSW–NNW), [Kiteforum](https://se.kiteforum.com/kitesurf/spot/watergate_bay), [Kernow Kitesurf Club](https://www.kernowkitesurfclub.co.uk/spot-guide) (recommended for beginners). Windguru "Watergate Bay" |
| Gwithian | ok, ban **kept unconfirmed** | Kernow club: stay out of the swim and surf zones in summer, the old zone was withdrawn. Cornwall Council: lifeguards 17 May–28 Sept (2025). The mid-July–early-Sept 10–18 h ban is in the catalogue but no page confirms it; kept (worst case) and flagged in `TO_CONFIRM.md` | [Kernow club Gwithian page](https://www.kernowkitesurfclub.co.uk/?p=741), [IKO Gwithian](https://www.ikointl.com/fr/destinations/kitesurfing-united-kingdom/spots/gwithian), [Cornwall Council beach safety](https://www.cornwall.gov.uk/parks-leisure-and-culture/beaches-in-cornwall/beach-safety). Windguru "Godrevy" (same bay) |
| Marazion – Long Rock | ok (notes) | None found | [Kernow club](https://www.kernowkitesurfclub.co.uk/?p=663): flat water, SW, S, SE good, shore dump at high tide. Schools on the beach: [Ocean High](https://www.marazion.info/ocean-high), Hoxton. [Kite & windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/longrock-devon-cornwall-great-britain.html). Windguru "Marazion" |
| Bantham | ok (notes) | None found | [Kite & windsurfing guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/bantham-devon-cornwall-great-britain.html), [windsurf.co.uk](https://www.windsurf.co.uk/beach-guide/bantham/): low tide, strong ebb in the estuary, gusty in NW. Not individually seen on Windguru |
| Exmouth | ok (notes) | Exe Estuary wildlife refuge active 15 Sept–31 Dec, yellow WR buoys, closed to people on land and water. It was set up at the Duck Pond; no page says whether kiting is excluded, so notes only, no ban | [East Devon DC](https://eastdevon.gov.uk/news/2024/09/call-to-avoid-wildlife-refuges-as-flocks-of-overwintering-birds-return-to-the-exe-estuary) (search summary), [kite & windsurfing guide](https://web.kite-and-windsurfing-guide.com/en/spots/kiteboarding-windsurfing-sup/exmouth-duck-pond-devon-cornwall-great-britain.html): any wind, NW on a rising tide best, E gusty. School: Edge Watersports. Windguru "Exmouth" |
| Weston-super-Mare – Uphill (Pro) | ok (notes fixed) | **Council WindZone** between Royal Sands and Uphill; launch south of the Royal Sands car park; BKSA, RYA or UKWA card or you are asked to leave; no lifeguard; no tide ban listed | [North Somerset Council kite page](https://n-somerset.gov.uk/my-services/libraries-leisure-open-spaces/beaches-coast/kitesurfing-wing-foiling-windsurfing-weston-bay), [Visit Weston WindZone](https://www.visit-westonsupermare.com/experience-weston/windzone-at-weston-beach/). Windguru "Weston-super-Mare" |
| Westward Ho! (Pro) | ok (notes fixed) | May–Sept RNLI season; kite area marked 200 m north of the Sandymere lifeguard hut; 50 m from the pebble ridge; none at high tide | [iKSurfmag](https://www.iksurfmag.com/travel-guides/europe/united-kingdom/westward-ho/), [Torridge DC zones page](https://torridge.gov.uk/article/21687/Westward-Ho-facilities-and-zones) (not readable). Schools: North Devon Kitesurfing (BKSA), 514Elemental. Windguru "Westward Ho!" |
| Daymer Bay (Pro) | ok (notes) | Ban 10–18 h in July–August (Kernow club, [S2AS](https://s2as.blogspot.com/2011/06/cornwall-kitesurf-guide-no-1-daymer-bay.html), [Adventure Sports Holidays](https://adventuresportsholidays.com/local-experts-guide-eight-best-cornwall-kite-beaches/)); not official, kept | [Unplug](https://www.unplug-kitesurf.com/spots/daymer-bay-england-uk): ebb up to 5 knots, Doom Bar. Not individually seen on Windguru |
| Perranporth – Perran Sands (Pro) | ok (notes fixed) | Removed "banned at the town end all year": no source says so; notes now say stay off the town beach | [Kernow club](https://www.kernowkitesurfclub.co.uk/?p=742): kiting access kept at Perranporth and Perran Sands; little space on big high tides. Windguru "Perran Sands" |

## Added from the Windguru list

| Spot | Pin | Why |
|---|---|---|
| Hayle – The Bluff, **Pro** | `w183752234` (Hayle Towans beach) | Windguru "The Bluff". Local source: [Kernow club](https://www.kernowkitesurfclub.co.uk/?p=743) and the [Bluff beach page on Kiteforum](https://se.kiteforum.com/kitesurf/spot/the_bluff): reopened under a permit (insurance, Bluff pass, BKSA card). Nothing odd, so Pro |

## Windguru, both ways (browsed as a visitor, 16 Nov)

Windguru has no kite tag, so I counted points named after a kite beach or at one of our beaches across Devon, Cornwall and Somerset. About 9 relevant points. Matched to ours: 7. Added: 1 (Hayle). Left out: 4 (table). Clusters such as Padstow and Bigbury were not opened, so Bantham, Daymer Bay and Brean were not individually seen. Gap line: none, Windguru shows fewer than we have.

| Windguru point | Ours |
|---|---|
| Saunton Sands | Saunton Sands |
| Westward Ho! | Westward Ho! |
| Watergate Bay | Watergate Bay |
| Perran Sands | Perranporth (Perran Sands) |
| Godrevy | Gwithian (same bay) |
| Marazion | Marazion – Long Rock |
| Weston-super-Mare | Weston-super-Mare – Uphill |
| Exmouth (cluster) | Exmouth |
| The Bluff | **added (Pro)** Hayle – The Bluff |
| E. Pentire / Newquay | left out: Fistral side, surf; Newquay beaches are closed to kites in season (Kernow club) |
| Praa Sands, Porthleven, Pentewan, Sennen Cove, Coverack | left out: surf or village forecast points, no kite source found |
| Stithians Lake | left out: inland sailing and windsurf lake, no kite source found |
| Falmouth (Gyllyngvase, Mylor) | left out: harbour and town beach points, no kite source found |
