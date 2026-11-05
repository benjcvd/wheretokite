# Validation: Alpine and inland lakes (fr-lakes, WHE-120)

Done 2026-11-05. Windy browsed as a visitor (hover on the kite markers, names and stars only); pins come from OSM,
never from Windy. Past work: no earlier validation of this zone; `TO_CONFIRM.md` only had the line on Der / Orient /
Madine club rules. No official text (prefectoral order, lake police regulation) could be read for any of the three
lakes, so **no `banned` rule is encoded**; restrictions are worded in `notes`.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Lac de Monteynard | basic | fixed (notes) | vvanat.fr Monteynard guide and kiteforum spot page: two schools on the water, one small launch beach run by the Onekite club at Treffort, paid parking, not supervised, leash and marked zones only, ferry has priority; summer thermal from the **north**, about 13:00 to 18:00, 8-12 kt; NE / NW turbulent; south wind gusty and irregular (often before storms). The old note said "strong south wind", which was wrong: rewritten. Windy marker "Lac de Monteynard" (5 stars). Pin: OSM node `osm:n4390731413` (Treffort), faces E (84°), Apple Maps agrees; N and S winds are side-shore on this beach, which matches the lake axis. Sector 180 kept. No official rules text found (SIVOM / prefecture not online). |
| Lac de Serre-Ponçon – Boscodon / Crots | pro | fixed (notes) | Altitude Kite school on Plage des Eaux Douces, Crots (serreponcon.com and hautes-alpes.net listings, season May-September; yumping listing); regional tourism pages call it the only kite beach of the lake; vvanat.fr: afternoon thermal, sudden gusts, accident reports at Crots. Lake police regulation (RPP, June 2020) governs navigation; the zone text itself was not readable (the PDF link returned 404), so the old claim "forbidden near the bridge" is dropped and bathing areas are kept as a general rule. Windy marker (5 stars). Pin: OSM node `osm:n1128590012`, faces NW (307°), Apple Maps agrees. Kept Pro. |
| Lac du Der – Giffaumont | basic | fixed (pin, notes) | KDA kitesurf club (Arrigny port; Facebook page, France 3 Champagne-Ardenne report), Let's Kite guide: intermediate, SW to W (WSW) wind, flat, best March to early September, lake drawn down in winter, kiting regulated, ask the club; bird zones. lacduder.com (tourist board) lists no kite page. Red zone 15 Jun-15 Sep stays "reported" in notes only. **Pin moved**: the old Nominatim point faced NE, offshore in SW / W wind. Now OSM beach `osm:w96321410` on the east shore, facing WNW in OSM, WSW 242° with hint W (Apple Maps agrees). The guide's "access near the sailing school" could not be tied to a single OSM element. Windy marker "Lac du Der" (4 stars). |

## Windy, both ways (browsed 2026-11-05, zoom 10)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Lac de Monteynard (5) | Lac de Monteynard | matched |
| Lac de Serre-Ponçon (5) | Serre-Ponçon – Boscodon / Crots | matched |
| Lac du Der (4) | Lac du Der – Giffaumont | matched |

Ours → Windy: all three have a marker. Neighbouring markers (Lac d'Orient) belong to other zones.

Counts: 3 Windy markers in the zone, 3 matched, 0 added, 0 left out. Our spots: 3 → 3 (free 2, Pro 1, archived 0).
No gap with Windy.
