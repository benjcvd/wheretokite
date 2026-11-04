# Validation: Gironde and Arcachon (fr-gironde, WHE-109)

Done 2026-11-03/04. Past work: rows came from the France Atlantic catalogue (3b0e02a) and the
famous-only trim (d96ef24); no earlier sourced check of this zone, only the open
`TO_CONFIRM.md` questions (La Hume hunting closure, basin summer bans, Arbousiers weak pin).
Windy browsed as a visitor (hover on kite markers, names and stars only); pins come from OSM.

Main official sources:
- **State boating guide, Gironde** (gironde.gouv.fr, *Guide Plaisance*): sheet 11 "Balisage des
  plages" (Feb 2024, and its July 2020 version) lists the kite channels per town on the basin;
  sheet 4 "Règles de navigation sur les lacs" (Feb 2024) summarises the 1 Sept 2014 prefectoral
  orders for the Hourtin-Carcans and Lacanau lakes; sheet 16 covers Lège-Cap Ferret.
- **La Teste-de-Buch order 2019-358** (latestedebuch.fr) on beach activities, article 10 kitesurf.
- **Maritime prefect order 2020/040** (premar-atlantique.gouv.fr) for the Arcachon basin (speed
  limits, restricted zones; nothing kite-specific at Claouey).

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Bassin d'Arcachon – Andernos (Le Bétey) | pro → basic | fixed | Pin: OSM beach "Plage du Bétey" (w540519748). Sources: Cap Ferret Kiteschool spot page (±3 h around high tide, sandbank at low tide, winds E through W to NW); apprendrelekitesurf.fr ("good learning spot", W winds); Windy marker "Le Betey" (4★). Rules: State guide lists an Andernos kite channel (boulevard de l'Océan) inside the 300 m strip. The July–August ban stays (worst case: in-season access only by that channel, no dated official text). Promoted to basic as the basin's main spot now that Claouey is archived. |
| Bassin d'Arcachon – Claouey | basic → archived | archived | Pin was Plage de la Croix des Marins (w570377210), not the Bertic beach riders named. The State guide lists no kite channel on the basin side of Lège-Cap Ferret (only windsurf channels for the Claouey and Le Boque clubs). The Cap Ferret Kiteschool has closed (my-capferret.com: no kite school left on the peninsula). No Windy marker at Claouey (zoom 10 and 12). Worst case applied. |
| Bassin d'Arcachon – La Hume | pro | fixed (pin, notes) | Re-pinned from a `q:` search to the OSM beach "Plage de la Hume" (w172893400). Sources: State guide (kite launch channel at La Hume harbour); Cap Ferret Kiteschool page (±3 h high tide, W to NE winds, FFVL-listed site, municipal order in the hunting season); apprendrelekitesurf.fr (hunting hides on the right); wannakitesurf; Windy "La Hume, Bassin d'Arcachon" (4★). October–November closure kept (worst case; town order cited by the school, text not found). |
| Bassin d'Arcachon – Les Arbousiers | pro | fixed (ban hours, notes) | Sources: State guide (kite only through the Arbousiers channel; 2020 edition: "after 19:00 only during the bathing-supervision period"; 2024 edition: hours by town order); Cap Ferret Kiteschool page (beginner at low tide, expert at high tide, moorings); zoomkite.com; kite-and-windsurfing-guide. Ban narrowed from all day to before 19:00 in July–August. No Windy kite marker. Pin still a `q:` search that lands on the "Plage des Arbousiers" bus stop beside the beach (Overpass unreachable to find the beach way; see Risks). |
| La Teste – La Salie | pro | fixed (notes) | Pin: OSM beach "Plage de la Salie" (n13034064294). La Teste order 2019-358 art. 10: from 25 June to 5 September kites launch only in two flagged 100 m zones, La Salie Nord (100 m north of the bathing area) and La Lagune; 50 m exclusion around the Wharf (art. 16). Also a State guide kite zone. Sources for use: apprendrelekitesurf.fr (La Salie Sud), APC Kite Surf (La Teste school, guide-bordeaux-gironde); Windy "La Salie" (3★). No dated ban (kiting stays allowed in the zone). |
| Lac d'Hourtin-Carcans | basic | fixed (pin, ban, notes) | Re-pinned from the "Hourtin Port" place node to the OSM beach "Plage du Port" (w127254533). Sources: Kite Zone School (EFK, Hourtin); kite-and-windsurfing-guide "Hourtin-Port"; Windy "Hourtin" (5★). Rules: State lakes sheet (Feb 2024), from the prefectoral order of 1 Sept 2014: **kite only from 15/11 to 31/03**, north of the Pointe Blanche – Lacanau channel line, away from the shore strip. Encoded as `04-01..11-14` (official source). The Hourtin 2025 lake guide shows a "zone de kitesurf" without dates, so a year-round school zone may exist: in `TO_CONFIRM.md`. The old "south of the yellow buoys" note had no source and is gone. |
| Lac de Lacanau | basic | fixed (notes) | Pin: OSM `sport=kitesurfing` "Kite Area" (w340755108), ~1.5 km south of the Talaris marina. State lakes sheet: kite only on the sites either side of the crossing channel to the Talaris marina (order of 1 Sept 2014). Schools: Evolution 2 Lacanau and Lacanau Kite & Wake Center (Le Moutchic). Windy "Lac Lacanau" (4★). |
| Lacanau-Océan | pro | fixed (notes) | Pin: OSM beach "Plage Super Sud" (w697650794). Sources: plages.tv lists a kite zone at Super Sud; Kite Surf Club Lacanau (guide-bordeaux-gironde); Windy "Lacanau Ocean" (5★). The "before 19:00" summer rule had no source and was removed; notes now say summer rules are set yearly by the town. |
| Le Verdon – La Chambrette | pro | ok | Pin: OSM beach "Plage de la Chambrette" (w577835350), estuary side. Sources: plages.tv (kite zone among the beach's facilities, fallback when the ocean swell is too big); Météo Consult has a "La Chambrette" wind-sports spot; Windy "Le Verdon sur Mer" (4★). E–NE winds and the high-tide window kept (estuary flats). |

## Windy, both ways (browsed 2026-11-04, zoom 10 at 45.25 N 1.0 W and 44.72 N 1.1 W, zoom 12 on the basin)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Le Verdon sur Mer (4) | Le Verdon – La Chambrette | matched |
| Soulac (4) | none | not added: ocean beach break, surf schools only found |
| Montalivet (5) | none | not added yet: one kite school (Carakas) and spot pages; candidate in `TO_CONFIRM.md` |
| Hourtin Plage (3) | none | not added: ocean beach 3 km from the lake, same conditions as Lacanau-Océan |
| Hourtin (5) | Lac d'Hourtin-Carcans | matched |
| Carcans Plage (5) | none | not added: no kite zone or school on site (the kite zone listed is on the lake at Maubuisson); 12 km from Lacanau-Océan |
| Lacanau Ocean (5) | Lacanau-Océan | matched |
| Lac Lacanau (4) | Lac de Lacanau | matched |
| Grand Crohot (5) | none | not added yet: guides describe a kite zone south of the blockhaus, State guide lists a kite channel at L'Horizon; candidate in `TO_CONFIRM.md` |
| Le Truc Vert (2) | none | not added: low stars, between Grand Crohot and L'Horizon |
| Le Betey (4) | Andernos (Le Bétey) | matched |
| La Hume, Bassin d'Arcachon (4) | La Hume | matched |
| La Pointe (2) | none | not added: Cap Ferret point, strong currents of the basin entrance, low stars |
| Dune du Pyla (5) | La Salie (nearest) | not added: the official summer kite zones are La Lagune and La Salie Nord, which our La Salie row covers (notes name La Lagune) |
| La Salie (3) | La Teste – La Salie | matched |
| Cazaux (4) and the Sanguinet markers | none in this zone | Lac de Cazaux-Sanguinet rows are region Landes (fr-basque-landes zone) |

Ours → Windy: Le Bétey, La Hume, La Salie, Hourtin, Lacanau lake, Lacanau-Océan, Le Verdon have
a marker. No Windy marker: Claouey (archived), Les Arbousiers (kept pro: official kite channel).

Counts: 9 spots checked, 17 Windy markers in the zone, 7 matched, 0 added, 1 archived (Claouey),
1 promoted (Le Bétey → basic). Basic 3 → 3 (Claouey out, Le Bétey in), pro 6 → 5, archived 0 → 1.

## Risks

- **Spot check**: see the build result in the card. Python 3.9 (LibreSSL 2.8.3) fails the TLS
  handshake with overpass-api.de and the mail.ru mirror times out, so the build stalled twice.
- Hourtin summer ban rests on the State's summary of the 2014 order; if the school zone is open
  all year, the ban is too strict (safe direction).
