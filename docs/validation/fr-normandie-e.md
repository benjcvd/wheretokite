# Validation: Calvados and Seine-Maritime (Normandy east) (fr-normandie-e, WHE-117)

Done 2026-11-06. Windy browsed as a visitor (hover on kite markers, names and stars only); pins come from OSM, never
from Windy. Past work: none for this zone (`git log` shows only the 2025 audit and tier commits); `TO_CONFIRM.md` had
one line ("Ouistreham Riva-Bella: separate from Merville?"), now settled. Not eyeballed on satellite: pins checked by
OSM element type, distance to the water and the Apple Maps direction check (all agree).

Rules in this zone: **no `banned` rule is encoded**. The only official text found is Merville's order below, which
allows kiting all year (the zone just moves in summer). Elsewhere sources say Calvados beaches are closed to kites in
the day in summer and reopen after 18:00 (gîtes-de-france-calvados.fr, vvanat.fr), but no town order was found, so
this is worded in `notes` ("check with the lifeguard post").

## Spots (original six)

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Merville-Franceville | basic | fixed (notes) | Town order P-2022/003 of 7 Jun 2022, art. 12 (merville-franceville.fr PDF, read through a search summary, the PDF itself returned HTTP 429): kiting allowed all year; 1 Jan to 15 Jun and 16 Sep to 31 Dec the whole beach; 16 Jun to 15 Sep only from the Orne estuary to kite channel no. 1, channels 2 and 3 closed. FFVL terrain sheets, Kite-R Evolution school (since 2002), gîtes-de-france-calvados.fr ("only Calvados beach open in summer"). Pin: the OSM kite school on Boulevard Wattier (`osm:w809904096`), 240 m from the water, no OSM beach exists at that spot; it is on the kite zone access. Direction N, agrees. The "no launch on the last 300 m west (bird reserve)" is only on some sites, no text: notes say ask locally. Tier basic kept. |
| Ouistreham – Riva-Bella | pro | fixed (pin, notes) | La Clinique de la Planche (FFVoile school at the Ouistreham nautical centre, rides 2 h either side of low tide), Let's Kite, FFVL terrain 2234. Low tide, NE or NW wind, wall and houses nearby. **Pin** was a Nominatim snap onto a tennis club; now the OSM beach `osm:w1280345958`, 30 m from water, NE, agrees. Tide `not-high` kept. Separate from Merville (5 km, different water and school): TO_CONFIRM question settled. Apple Maps notes a 270° water arc: warning only. |
| Houlgate | pro | fixed (pin, notes) | Kite Paradise school (tourist office Normandie-Cabourg-Pays d'Auge), Unplug directory (intermediate), vvanat. Natural pools at low tide. Pin was the school shop (124 m inland); now the OSM beach `osm:r11199900` (NNW, agrees). Notes were empty: written, with the after-18:00 summer rule from gîtes-de-france-calvados. |
| Asnelles | pro | fixed (pin, notes) | gîtes-de-france-calvados.fr and vvanat.fr: slalom around the Mulberry harbour, tide coefficient 70+; Unplug: beginner, flat. No school found. **Pin** was a Nominatim snap onto the commune boundary; now the OSM beach `osm:w281098840`, 10 m from water, N, agrees. No order found. |
| Le Havre | pro | fixed (notes) | LH Kite association page (launch below Le Ponant, pebbles, choppy at high tide, signage talks with the town), Petit Futé (Max Kite School, École havraise de kitesurf), LH Beach. Pin: OSM beach `osm:w804964900`, WSW, agrees. No town order found. |
| Quiberville | basic | ok (notes) | Let's Kite: marked kite zone with signs (mandatory), W to NW, no official text found. Kiteloopers: pebbles, sand at low tide, tidal currents; Unplug: intermediate; France 3: first kite school of the Côte d'Albâtre at Saint-Aubin-sur-Mer next door. Pin kept: OSM node on the beach (`osm:n8446819588`), 67 m from the water, NNW, agrees. |

## Added from Windy (all Pro, one source or more, pins from OSM beaches, direction agrees on all)

| Spot | Sources | Notes |
|---|---|---|
| Colleville-Montgomery | sportihome, chilowe, ville-data, OCEAN Espace Glisse (rental) | wide beach, beginner, best at low tide; wind advice varies |
| Langrune-sur-Mer | Cœur de Nacre tourism, normandie-tourisme.fr, Let's Kite (Voiles de Nacre club teaches kite) | NE to NNW, intermediate |
| Courseulles-sur-Mer | kiteloopers, ville-data, Courseulles sailing school | NW to W, coefficient 70+ |
| Ver-sur-Mer | Unplug only (chop, small waves) | weak source, flagged in notes |
| Deauville | The Ridery guide, Let's Kite | supervised swim zone closed to kites in summer |
| Fécamp | ville-data (kite site, in season only), Unplug | pebble beach |
| Saint-Valery-en-Caux | Unplug (beginner), ville-data (kite site) | shallow, choppy |
| Pourville-sur-Mer | Let's Kite (experienced riders), Unplug | short beach under cliffs |
| Dieppe | Let's Kite, ville-data (in season only) | check rules |
| Antifer | Let's Kite, R'Kite forum | tidal, oil terminal, SW wind, not for beginners |

## Windy, both ways (browsed 2026-11-05, zoom 10 to 11, Asnelles to Le Tréport)

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Asnelles (4) | Asnelles | matched |
| Franceville (5) | Merville-Franceville | matched |
| Houlgate (5) | Houlgate | matched |
| Le Havre (5) | Le Havre | matched |
| Saint-Aubin (4) | Quiberville | matched (2 km neighbour, same stretch, school at Saint-Aubin) |
| Coleville (3) | Colleville-Montgomery | **added (Pro)** |
| Langrune (4) | Langrune-sur-Mer | **added (Pro)** |
| Courseulles (5) | Courseulles-sur-Mer | **added (Pro)** |
| Ver sur Mer (2) | Ver-sur-Mer | **added (Pro)**, weak source |
| Deauville (4) | Deauville | **added (Pro)** |
| Fécamp (4) | Fécamp | **added (Pro)** |
| Saint-Valery-en-Caux (3) | Saint-Valery-en-Caux | **added (Pro)** |
| Pourville (3) | Pourville-sur-Mer | **added (Pro)** |
| Dieppe (5) | Dieppe | **added (Pro)** |
| Antifer (3) | Antifer | **added (Pro)** |
| Luc sur Mer (3) | none | **left out**: 1.35 km from Langrune on the same beach and facing (the build rejects it); only directory pages |
| Trouville (5) | none | **left out**: same water as Deauville, 1.5 km, across the Touques mouth |
| Cabourg (4) | none | **left out**: Le Menhir Normandie Kite is there, but no OSM beach fits the spot (the nearest element is a 3 km relation centred east of town), so it cannot be pinned |
| Berneval (1) | none | **left out**: Windy 1 star; a guide mentions a signed kite zone, but no OSM beach found |
| Veulettes (3) | none | **left out**: reef wave spot per kite-and-windsurfing-guide; the only OSM beach is 1 km from the village, unsure it is the same place |
| Petites Dalles (2) | none | **left out**: wave spot, surf sources only, no kite source |
| Unnamed marker near Eu / Le Tréport | none | **left out**: name not readable in the hover; ville-data lists kite sites at Le Tréport (Opale Kite): to do in a follow-up |

Ours → Windy: five of our six have a marker; **Ouistreham – Riva-Bella** has none of its own (the nearest marker,
Coleville, is 2 km west and is now its own spot).

Counts: 22 Windy kite markers in the zone, 5 matched, 10 added as Pro, 7 left out.
Our spots in the zone: 6 → 16 (2 free, 14 Pro, 0 archived).
Windy shows more spots than the original six because the Calvados coast (Côte de Nacre) and the Caux coast were
thin in the catalogue; the gap is mostly closed. Cabourg and Le Tréport are the two real leftovers.
