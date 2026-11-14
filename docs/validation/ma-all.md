# Validation: Morocco (zone `ma-all`, WHE-172)

Date: 2026-11-14. Method: [validation method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time).
Past work: Morocco was researched on 2026-10-22 (cards si-ma-1, rows pinned from OSM; open questions in `TO_CONFIRM.md`).
Not redone here: pins, which come from OSM elements through the build.

Limits of this pass (said plainly): about 10 web searches, with results from schools' booking pages, spot directories
and guides. No official Moroccan kite-zone or ban text exists that I could find, so no row carries a `banned` rule.
I did not check pins on satellite, and the build's Apple Maps check is the only direction check (see review below).
Most Moroccan "sources" are guides and directories, not clubs or authorities: stated per row.

| Spot | Verdict | Pin / rules | Sources and notes |
|---|---|---|---|
| Dakhla – Speed Spot (PK25 camps) | ok | OSM `n5249527142`, lagoon, W hint. No rules found | Several guides: [kite-and-windsurfing-guide PK25](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/dakhla-pk25-dakhla-sahara-occidental-morocco.html), [Kiteworldwide Dakhla](https://www.kiteworldwide.com/kitespot-guides/kitesurfing-dakhla/): PK25 flat water, all levels. "Speed Spot" proper has one blog source only: already in notes as advanced, low tide. Windy: "Dakhla Camp" 5 stars |
| Dakhla – Dune Blanche | ok | `n5303302622`, `tide=high` kept | Guides call the white dune the best flat water, reached by downwinder or car. No separate school page found for the tide window, kept from the earlier pass. Not a Windy marker |
| Dakhla – Oum Labouir (Westpoint) | ok | `w1500200126` | Several sources: main Dakhla wave spot, lighter and gustier on the ocean side. Windy: "Oum Lambouir" 3 stars |
| Dakhla – Lassarga (pro) | question | `w1338100127`, SE | Sources conflict: the lagoon and the Atlantic side are both called La Sarga (guides say an advanced wave spot, Ocean Vagabond a good lagoon area). Windy "La Sarga" 3 stars. Row kept, question remains in `TO_CONFIRM.md` |
| Essaouira | ok | `w243397848` | [Alex Pastor Kite Club guide](https://alexpastorkiteclub.com/blog/kitesurf/kitesurfing-in-essaouira-morocco-a-complete-guide), [kiterr](https://kiterr.com/kitespots/africa/kitesurfing-essaouira-morocco): sheltered town beach is where beginners learn, cross-onshore wind, season April to September. 12 schools reported. Windy "Essaouira Bay" 5 stars |
| Moulay Bouzerktoun | ok | `w654823110` | Guides: strong wind, hosts competitions, 20 to 25 km north, small beach with rocky slab. Windy 3 stars |
| Sidi Kaouki | ok | `w197452236` | Guides: strong wind and waves, 20 to 25 km south; [wannakitesurf](https://en.wannakitesurf.com/spot/Africa/Morocco/Sidi_Kouki_) lists it. Windy 4 stars |
| Moulay Bousselham (pro) | ok (thin) | `w141084128` | [Spot guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/moulay-bousselham-rabat-casablanca-safi-morocco.html): long beach good for kiting in strong trade wind; lagoon is a bird sanctuary. No school found. Windy 3 stars. Kept pro |
| Oualidia (pro) | ok (thin) | `w323598009` | Only a spot guide and a directory page, no school (Oualidia schools are surf). Windy "Oualidia Lagoon" 2 stars. Kept pro, no change |

## Windy, both ways (browsed as a visitor, 14 Nov; kite markers hovered, names and stars only)

Windy shows 31 Morocco kite markers (none south of Dakhla). Matched to ours: 9. Added as Pro: 3. Left out: 19.

| Windy marker (stars) | Ours / outcome |
|---|---|
| Dakhla Camp (5) | Speed Spot (PK25) |
| Oum Lambouir (3) | Oum Labouir |
| La Sarga (3) | Lassarga |
| Pointe de l'Or (1) | left out: 1 star, no local source; already a question in `TO_CONFIRM.md` (only OSM match is a peak at El Argoub) |
| Essaouira Bay (5), Moulay Bouzerktoun (3), Sidi Kaouki (4) | ours |
| Moulay Bousselham (3), Oualidia Lagoon (2) | ours (Pro) |
| Tangier (5) | **added (Pro)** as Tangier – Achakar: Cap Spartel beach, school on site (Say Say Surf Shop) and two directories |
| Agadir Bay (3) | **added (Pro)**: city beach, thermal wind, busy in summer, notes say so |
| Taghazout (4) | **added (Pro)**: sandy beach with waves, shared with surfers |
| Imsouane (5), Banana Village (3), Tamri (2), Cap Rhir (1), Sidi Rbat (2) | left out: surf breaks, no kite source found |
| Mirhleft (3), Aglou (3), Plage Blanche (1) | left out: [kite guide](https://web.kite-and-windsurfing-guide.com/spots/kiteboarding-windsurfing-sup/mirleft-agadir-morocco.html) says more surfers than kiters, wind only in winter thermals; no school |
| Secret Bay (1), Iftane (1), Tafadna (1), Bibah (1), Achakar (1), Asilah (1) | left out: 1 star, no local source (Achakar is the same beach as Tangier, added) |
| Salé (4), Plage des Nations (2), Mehdia (2), Bouznika (3), Dar Bouazza (2), El Jadida (3) | left out: no kite school or club found (surf-forecast gives Bouznika 1/5 for kite; Mehdia guide says inadvisable in summer). Not one of the method's good reasons: **to look at again with a local source** (see `TO_CONFIRM.md`) |

Ours → Windy: Dune Blanche is not a Windy marker (Windy's Dakhla markers are PK25, Oum Lambouir, La Sarga, Pointe de l'Or).

Gap: Windy shows 31 markers against our 12 after this pass. Most of the gap is one-star or surf markers
(Imsouane, Banana Village, Tamri, Cap Rhir, the 1-star Atlantic beaches) and the Rabat–Casablanca–El Jadida beaches
where I found no kite club. Windy-hovered names were used only to learn that spots exist, never for positions.

## Build check (14 Nov)
`build_spots.py` on `ma.csv`: no PROBLEMS, 12 spots. Apple Maps direction check: 11 agree, 1 uncertain (Oualidia: OSM faces N, Apple water at NW, 43° apart; a lagoon, harmless, row kept). Counts: 9 → 12 spots (6 free, 6 Pro... Moulay Bousselham, Oualidia, Lassarga, Achakar, Agadir Bay, Taghazout are Pro), 0 archived.
