# Validation: Roussillon and Leucate (fr-roussillon, WHE-67)

Done 2026-11-02 (batch 1, commit bc31d5e) and 2026-11-03 (rest of the zone). Windy browsed as a visitor
(hover on the kite markers, names and stars only); pins come from OSM, never from Windy.

## Spots

| Spot | Tier | Verdict | What was checked and sources |
|---|---|---|---|
| Saint-Cyprien / Canet – Pont des Basses | basic | fixed (batch 1) | Department tourist office calls Pont des Basses the kite hotspot of the Pyrénées-Orientales (tourisme-pyreneesorientales.com blog); Canet town page lists a "zone de navigation kitesurf – Pont des Basses"; kite school We Love Kite on site; Windy marker "Le Canet". Unsourced "decree May–Sept" removed from notes. No dated ban found, none encoded. |
| Le Barcarès – Les 3 Colonnes | basic | ok | Named by the department tourist office, Windy marker "Les 3 Colonnes", schools at Barcarès (SurfandKite, UCPA). Pin on the beach element, checked 2 Nov (TO_CONFIRM). |
| Leucate – Les Coussoules / La Franqui | basic | fixed (batch 1) | Leucate tourist office (top spots page, spot guides 2024-26, map 2026-27): kite zone secured by KSL beside the old lifeguard post, windsurf zone upwind (north), La Franqui cliff-side exit channel closed to kites; Windy marker "La Franqui" (5 stars). In-season rules are in the notes, no dated ban (no official text). |
| Étang de La Palme | basic | ok | Schools on the lagoon: Windykite, Kite Odyssey (FFVL / EFK), EB Kite, Unikite, SurfandKite (tourisme-occitanie.com, audetourisme.com); Windy marker "Etang de Lapalme" (5 stars). Shallow flat water, tramontane and marin. |
| Le Barcarès – Parc des Dosses | basic | ok, made free (Ben, 4 Nov) | Department tourist office lists it with 3 Colonnes; Windy marker "Les Dosses" (5 stars); UCPA Éole next door. Only flat-water tramontane spot left in the area now that Le Goulet is archived. Direction check: see build result below. |
| Port-la-Nouvelle | pro | ok | Schools: Kite & Foil (Vieille Nouvelle), WestKiteSchool (Plage Sud); Windy marker "Port La Nouvelle" (4 stars). Summer kite-zone rule stays in notes. |
| Leucate – Le Goulet | archived | archived (batch 1) | Tourist office lists it for windsurf / wingfoil / SUP only; free kite zone is at Coussoules. Worst case applied. |
| Argelès-sur-Mer – Le Racou | archived | archived | No kite school at Argelès (nearest are Saint-Cyprien and Leucate); no official kite-zone page; only a spot guide ("Plage Nord has recently become a kite spot") and Windy markers. The "buoyed zone June–Sept" wording had no source. Worst case applied. |
| Torreilles – Le Blockhaus | archived | archived | Blockhaus beach club reported closed; one school (Free Air) and one blog; no Windy marker; 5 km from Barcarès. |

## Windy, both ways (browsed 2026-11-03, zoom 10 around 42.75 N, 3.0 E)

Windy → ours:

| Windy marker (stars) | Ours | Decision |
|---|---|---|
| Argelès Plage (4) | not in catalogue | not added: no school or kite-zone source (see Racou) |
| Racou Plage (4) | Le Racou (archived) | see above |
| Le Canet (4) | Pont des Basses | matched |
| Les 3 Colonnes (2) | Les 3 Colonnes | matched |
| Les Dosses, Étang de Leucate (5) | Parc des Dosses | matched |
| Étang de Leucate, Salses side (3) | none | not added: no reliable position or source (TO_CONFIRM, 2 Nov) |
| Les Pilotis (3) | none | not added: Leucate Plage, ~5 km from Coussoules with the same conditions; the tourist office says sea navigation there is out of season only |
| La Mine, Étang de Leucate (5) | none | not added: tourist office lists it for windsurf / SUP only (windsurf-driven stars) |
| La Franqui (5) | Coussoules / La Franqui | matched |
| Etang de Lapalme (5) | Étang de La Palme | matched |
| Port La Nouvelle (4) | Port-la-Nouvelle | matched |

Ours → Windy: Pont des Basses, 3 Colonnes, Dosses, Coussoules, La Palme, Port-la-Nouvelle have a marker.
No Windy marker: Le Goulet (archived), Torreilles (archived).

Counts: 9 spots checked, 11 Windy markers, 7 matched, 0 added, 3 archived (Goulet, Racou, Torreilles).

## Windy-only markers: Pro pass (WHE-122, 4 Nov 2026)

Rule: Windy-only markers go in as Pro unless one of the good reasons applies
([method](../../tools/spots/validation/README.md#the-method-slowly-one-spot-at-a-time)). Pins from OSM beach ways only.

| Windy marker | Result | Why / sources |
|---|---|---|
| Les Pilotis (3) | **added (Pro)** `Leucate – Les Pilotis (Leucate Plage)`, OSM way 41749055 | Leucate tourist office top-spots page lists kitesurf / kitefoil there (sea spot, no rule given); kite-and-windsurfing-guide.com: similar to nearby beaches, bigger waves in marin; German spot guide: powerful waves with a more northerly wind. Earlier "5 km from Coussoules" note is not a reason. Summer sea rule from the first pass stays in notes (check town rules). |
| Argelès Plage (4) | **added (Pro)** `Argelès-sur-Mer – Plage Nord`, OSM way 72147216 (unnamed beach at the north end) | One source: kite-and-windsurfing-guide.com "Plage Nord, Argelès: has recently become a kite spot", steep shorebreak. No school or town page, so notes say to check bathing rules. Racou (south end, ~5 km) stays archived. Windy's exact marker position not used. |
| La Mine, Étang de Leucate (5) | left out | Reason 3 (not a kite spot): Leucate tourist office lists La Mine for windsurf / SUP only, a beginners' windsurf launch. |
| Étang de Leucate, Salses side (3) | left out | Reason 4 (no OSM element / no named launch): school pages only mention downwind runs and boat trips on the Étang de Salses (Unikite), KiteSchool Leucate sits at Los Clots on the Saint-Laurent side; no fixed shore to pin. |

Counts: 11 Windy markers, 7 matched, 2 added (Pro), 2 left out. Our spots in the zone: 9 → 11 (Dosses free, 2 new Pro, 3 archived unchanged).
