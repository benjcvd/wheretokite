# Validation: Mainland Greece and Lefkada (zone `gr-mainland`, WHE-174)

Date: 2026-11-14. Method: [Windguru variant](../../tools/spots/validation/README.md#windguru-instead-of-windy-from-14-nov).
Past work: none sourced for these five (they came from the first Greece pass). 7 web searches, Windguru browsed in Chrome as a visitor. Pins are the existing locators; satellite checks were not done.

| Spot | Verdict | Sources and notes |
|---|---|---|
| Lefkada – Agios Ioannis | fixed (notes) | [kite-and-windsurfing-guide](https://www.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/agios-ioannis-lefkas-lefkada-ionian-islands-greece.html), [The Kitemag](https://www.thekitemag.com/features/lefkada-hidden-gem/), [Greeka Lefkada kite spots](https://www.greeka.com/ionian/lefkada/sports/kitesurfing/spots/), [surf-magazin](https://www.surf-magazin.de/en/spots-and-areas/international/greece/vasiliki-milos-and-co-the-best-windsurfing-spots-on-lefkada/). Real, school on site, yellow-buoy zones (kite one side). Sources say kiting is prohibited at Vassiliki all year, so Vassiliki is not added (worst case, no official text found). Myloi, a kite-only beach, is next door (same beach, not added) |
| Thessaloniki – Epanomi – Potamos | fixed (notes) | Kite school "Mindloop" on the 11 km beach south of Epanomi (all year, rescue boat) per [Manawa](https://www.manawa.com/en-GB/view-activity/5920) and Expedia/Clicatour listings. Only booking sites, no school page: one source family, kept because the beach is real and the school operates. Old note "sandy spit, flat water inside" was not supported: removed |
| Thessaloniki – Angelochori (Pro) | fixed (notes) | [Kitejungle](https://kitejungle.com/kite-places/greece/thessaloniki-angelohori) (kite spot, sea beach, all levels), [Greeka Thessaloniki watersports](https://www.greeka.com/macedonia/thessaloniki/sports/watersports/) (windsurf club on the beach). No kite school. The lagoon is Natura 2000, so the old "flat lagoon, good for learning" claim is replaced: stay on the sea side. Kept Pro |
| Attica – Loutsa (Artemida) | ok | [Kitejungle](https://kitejungle.com/kite-places/greece/artemida-loutsa-beach), [This is Athens](https://www.thisisathens.org/activities/sports-outdoors/windsurfing-kitesurfing), [Greeka Athens Watersports](https://greeka.com/attica/athens/sports/watersports/loutsa/athens-watersports). Strongest northerlies of Attica, schools open year round |
| Attica – Schinias | fixed (notes) | [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/schinias-attica-euboea-skyros-greece.html), [Magic Ride lessons](https://sites.google.com/view/magicridegreece/wind/kite-lessons). Sources disagree on the wind (south in the off-season vs summer thermal) and the bay is sheltered from the north: the old "meltemi side-offshore" note was wrong in tone. Notes rewritten with the disagreement. Open: `hint` SE kept, to confirm on site |

## Windguru, both ways (visitor, 14 Nov: searches "Greece kite", "Greece surf center", plus local names)

Windguru kite-named markers in Greece: 9 (AIR RIDERS, Chalikounas, Mikri Vigla, Mykonos Korfos, Paros, Prasonisi, Psalidi, 2× Theologos) plus 2 windsurf centres (Marmari, Prasonisi). **None is on the mainland or Lefkada** except Chalikounas (Corfu, outside the zone). The name search for Vasiliki and Epanomi returned nothing relevant (the search box kept showing earlier results).

| Windguru marker | Ours |
|---|---|
| Chalikounas, Kite Club Corfu | **added (Pro)**, new row `Chalikounas` (Corfu): [visit.corfu.gr kite club](https://visit.corfu.gr/activities/kite-corfu-club/), [unplug-kitesurf](https://www.unplug-kitesurf.com/spots/corfu-chalikounas-greece), [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/chalikounas-corfu-kerkyra-corfu-ionian-islands-greece.html). Pin on OSM beach way `w385774236` |
| Islands markers (Rhodes, Kos, Naxos, Paros, Mykonos) | out of zone, see [gr-islands](gr-islands.md); AIR RIDERS left out there |

Ours with no Windguru kite marker: all five mainland spots. Mainland Windguru coverage is thin, so the gap is on Windguru's side, not ours.
Windguru names were used only to learn that spots exist, never for positions.

Not done: Corfu has no zone of its own (Corfu is in none of the zones); Issos Beach and Surf Center Corfu not checked. Evia (Nissakia) and the Peloponnese mainland not looked at.

## Windy, both ways (visitor, Chrome, 15 Nov 2026, WHE-202)

Method: [step 2](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time), kite-spots layer browsed from Lefkada to Thessaloniki and the Peloponnese, each marker hovered for its name and star rating. Islands (Corfu, Zakynthos, Cyclades, Crete…) are out of this zone. Names only: pins come from OSM, never from Windy.
Windy shows **24 kite markers** on the mainland, Lefkada, Evia and the Peloponnese. All carry stars (none unrated). Matched to ours: 4. Added as Pro: 11. Left out: 9.

| Windy marker (stars) | Ours / decision |
|---|---|
| Agios Ioannis, Lefkada (5) | ours: `Lefkada – Agios Ioannis` |
| Angelohori (3) | ours: `Thessaloniki – Angelochori` |
| Schinias (5) | ours: `Attica – Schinias` |
| Nissakia Loutsa (5) | ours: `Attica – Loutsa (Artemida)` |
| Oropos (5) | **added (Pro)**: Magic Ride lessons page (east thermal after 15:00), [unplug-kitesurf Athens list](https://www.unplug-kitesurf.com/destinations/athens) |
| Anavyssos (5) | **added (Pro)**: [kite-and-windsurfing-guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/anavyssos-attica-euboea-skyros-greece.html), unplug list (beginner) |
| Lavrio (5) | **added (Pro)**: unplug list (beginner, flat and chop), guide list. Thin on wind: noted as such |
| Vouliagmeni (5) | **added (Pro)**: unplug list (expert, waves), guide (SE gales, powerful waves). Private beach clubs: access limited |
| Alepoxori (4) | **added (Pro)**: unplug list (Kato Alepochori, beginner, flat), guide list |
| Lefkandi, Evia (3) | **added (Pro)**: KiteGreece school and Kitepark Lefkadi on the waterfront (unplug list), [Amazing Evia](https://amazingevia.com/en/explore/outdoors-evia/kite-surfing-kai-wind-surfing-stin-evia/) (thermal, beginners) |
| Raches (5) | **added (Pro)**: Surf Camp Raches school, [unplug Raches page](https://www.unplug-kitesurf.com/spots/raches-greece), [allovergreece](https://www.allovergreece.com/Kitesurf-Spot/Descr/607/903/en) |
| Astros (3) | **added (Pro)**: [unplug Astros page](https://www.unplug-kitesurf.com/spots/peloponnese-astros-greece) and Athens list (beginner). Single source family |
| Nafplio (4) | **added (Pro)**: Radical Kite Center, Unlimited Adrenaline courses ([discovernafplio](https://discovernafplio.gr/en/listings/activities/kite-surf-nafplio)), unplug list. Pin: Karathona beach |
| Mavrovouni, Gythio (3) | **added (Pro)**: [unplug Mavrovouni page](https://www.unplug-kitesurf.com/spots/peloponnese-mavrovouni-greece) (south wind, riding zones) |
| Faros, Rio–Patras (5) | **added (Pro)**: [Cape Drepano Kite Center](https://www.greeka.com/peloponnese/patra/sports/kitesurfing/patra/cape-drepano-kite-center/), unplug list, surf-magazin Drepano guide. Pin: OSM "Drepano Kite Surfer's Paradise Beach" |
| Lefkada Lagoon (4) | left out: a guide says the lagoon behind Agios Ioannis is off-limits to kiting (fishing nets); no school or club found |
| Aghios Nikolaos, Lefkada (4) | left out: sources exist (unplug page, Kleopatra Kite) but no OSM beach could be found to pin it (searches returned nothing) |
| Vasiliki (5) | left out: guides say kiting is prohibited all year (no official text found, a German magazine mentions kiters at the north end). Worst case kept, as in the Windguru pass |
| Golden Beach, Karystos (3) | left out: no OSM beach found to pin it |
| Patra (4), Agia Anna, Evia (2), Agiokambos, Thessaly (4), Finikounda (4), Elafonisos (3) | **left out, no local kite source found** in 12 searches (Finikounda: a 2013 windsurf log only; Elafonisos: a passing mention in a tour article; Agia Anna: only Naxos results; Agiokambos: only the Evia namesake). Not one of the method's listed reasons: Ben to decide if they should go in as bare Pro rows |

Ours with no Windy marker on the mainland: `Epanomi – Potamos`. `Chalikounas` (Corfu) was not checked on Windy.
Gap: Windy had 24 markers, we had 4. After this pass we cover 15 of 24. Mainland Greece, Attica and the Peloponnese are much denser on Windy than in the Windguru pass, which is why the rows jump from 6 to 17.
Notes: 11 of the new rows have only guide-level sources, so their sectors are rough (hint from the OSM beach orientation, Apple Maps agrees on all 28 Greek rows). `Vouliagmeni` is a bay node pin and `Lefkandi` a bay node pin; satellite checks not done.
