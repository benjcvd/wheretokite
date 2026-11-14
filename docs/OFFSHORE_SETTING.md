# Side-offshore by level (WHE-75): angle limits and before / after

## The rule (Ben, 2 Nov)

Wind angle to the beach: 0° = straight onshore, 90° = side-shore (parallel to the beach), 180° = straight offshore.
Set by the rider's level only: there is no separate setting any more. The rule is written under the level picker in the profile.

| Angle | Name | Beginner, intermediate | Advanced |
|---|---|---|---|
| 0–90° | onshore to side-shore | scores as before | scores as before |
| 90–100° | still side-shore (10° margin for beach direction and forecast error) | fades to 0 at 100° | scores, no warning |
| 100–120° | **slightly side-offshore** | **0** | scores, fading 90 % → 40 % at 110° → 0 at 120°; spot shows **"Side-offshore: advanced only"** |
| 120–180° | **offshore** | 0 | **0, for everyone** |

- Under the level picker: beginner "Wind: onshore or side-onshore only", intermediate "side-shore at most, never from the land", advanced "slightly side-offshore accepted, flagged 'advanced only'. Offshore never."
- Lagoons, points and coves still go through their catalogue water sector first (Leucate's étang still works in winds off the land): unchanged.
- No regional rules. Settings: `ScoringRules.sideShoreMaxDeg` 100, `offshoreFromDeg` 120 (was 130).
- What changed since the 31 Oct version: intermediates can no longer opt in to side-offshore; advanced riders lose 10° (0 at 120° instead of 130°) and can no longer opt out. Beginners: unchanged.

## Before / after for advanced riders (130° → 120°)

`kite --day <day> --slot afternoon --drive 150 --all --straight-line --level advanced`, from Barcelona, 75 kg, 9 and 12 m, archived forecasts. Only spots whose score changed through this rule are shown (⚠ = "advanced only" warning).

| Day | Spot | Before | After |
|---|---|---|---|
| 2 Jul Tramontana | L'Estartit | 68 ⚠ | 62 ⚠ |
| | Sant Pere Pescador | 66 ⚠ | 61 ⚠ |
| 14 May Ponent | Calafell | 65 ⚠ | 59 ⚠ |
| | Segur de Calafell | 50 ⚠ | 39 ⚠ |
| | Cambrils | 44 ⚠ | 28 (now offshore) |
| | Torredembarra, Creixell, L'Ampolla | 32, 29, 14 | 7, 3, 1 |
| 8 Oct Mestral | Salou | 62 ⚠ | 54 ⚠ |
| | Sant Pere Pescador | 62 ⚠ | 55 ⚠ |
| | Palamós La Fosca | 49 ⚠ | 40 (now offshore part of the window, no warning) |
| | L'Estartit, L'Ampolla | 47, 45 ⚠ | 36, 31 ⚠ |
| | Platja d'Aro | 40 ⚠ | 32 |

Top picks are untouched (Castelldefels and the Ebro delta on 14 May, Argelès on 8 Oct, all side-shore or better).
Altafulla 62 → 39, Platja dels Eucaliptus 69 → 39 and Argelès 81 → 79 also moved, through the live "chance of wind" check, which varies from run to run: not this change.

Intermediates: same results as the 31 Oct table (they were already side-shore only by default), see git history of this file.

## Screenshot

Advanced rider, 14 May, Segur de Calafell: [spot page](review/whe75-side-offshore-spot.png). The results list shows the same line in orange under the spot.
