# Side-offshore setting (WHE-75): angle limits and before / after

## The rule

Wind angle to the beach: 0° = straight onshore, 90° = side-shore (parallel to the beach), 180° = straight offshore.

| Angle | Name | "Not at all" (default beginner, intermediate) | "A little side-offshore" (default advanced) |
|---|---|---|---|
| 0–90° | onshore to side-shore | scores as before | scores as before |
| 90–100° | still side-shore (10° margin for beach direction and forecast error) | fades to 0 at 100° | scores, no warning |
| 100–130° | **side-offshore** | **0** | scores, fading 90 % → 40 % at 115° → 0 at 130°; spot shows **"Side-offshore: advanced only"** |
| 130–180° | **offshore** | 0 | **0, for everyone** |

- Beginners can't pick "A little side-offshore" (greyed out; the engine ignores it even if saved).
- Lagoons, points and coves still go through their catalogue water sector first (Leucate's étang still works in winds off the land): unchanged.
- No regional rules. Settings: `ScoringRules.sideShoreMaxDeg` 100, `offshoreFromDeg` 130.
- What changed for whom: intermediates used to keep 30–85 % up to 110° and some score up to 125°; now 0 from 100° unless they opt in. Advanced: the curve is exactly the old one (0 at 130°), plus the warning. Beginners: unchanged (0 from 100°).

## Before / after on the WHE-64 days

`kite --day <day> --slot afternoon --drive 150 --all --straight-line`, from Barcelona, 75 kg, 9 and 12 m, archived forecasts. Both versions read the same cached forecast. Only spots whose score or label changed are shown.

### Intermediate (default "Not at all")

| Day | Spot | Before | After |
|---|---|---|---|
| 2 Jul Tramontana | L'Estartit, N 22 kn | 55 | 2 (offshore) |
| | Sant Pere Pescador, NNW 23 kn | 39 | 0 (offshore) |
| 14 May Ponent | Calafell, W 16 kn | 51 | 0 (offshore) |
| | Altafulla | 46 | 0 |
| | Segur de Calafell | 31 | 0 |
| | Cambrils | 24 | 0 |
| | Torredembarra, Creixell, L'Ampolla | 14, 11, 5 | 0 |
| 8 Oct Mestral | Salou, WNW 17 kn | 46 | 0 |
| | Sant Pere Pescador | 41 | 0 |
| | Palamós La Fosca, L'Estartit | 31, 29 | 0 |
| | L'Ampolla, Platja d'Aro | 25, 25 | 0 |

Spots still scoring: 2 Jul 7 → 6, 14 May 16 → 9, 8 Oct 21 → 15. The top picks are untouched (Argelès Le Racou on 2 Jul, Castelldefels on 14 May, both side-shore).
Castelldefels 92 → 69, Platja dels Eucaliptus 69 → 39 and Argelès 58 → 46 also moved, but through the live "chance of wind" check, which varies from run to run: not this change (their wind is cross-shore or side-onshore).

### Advanced (default "A little side-offshore")

Every score is identical; these spots now carry the warning:

| Day | Spots with "Side-offshore: advanced only" |
|---|---|
| 2 Jul | L'Estartit 68, Sant Pere Pescador 66 |
| 14 May | Calafell 65, Altafulla 62, Segur de Calafell 50, Cambrils 44 |
| 8 Oct | Salou 62, Sant Pere Pescador 62, Palamós 49, L'Estartit 47, L'Ampolla 45, Platja d'Aro 40 |

## Screenshot

Advanced rider, 14 May, Segur de Calafell: [spot page](review/whe75-side-offshore-spot.png). The results list shows the same line in orange under the spot.
