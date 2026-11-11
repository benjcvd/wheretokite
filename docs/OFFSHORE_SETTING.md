# Side-offshore: the rider chooses, the level caps it (WHE-160)

## The rule (proposal, waiting for your OK on the angles)

Wind angle to the beach: 0° = straight onshore, 90° = side-shore (parallel to the beach), 180° = straight offshore.
Profile → under **Level**, a new **Wind off the land** choice: *Side-shore only* or *Slightly side-offshore*.
A rider can always choose less than their level allows, never more.

| Level | Choices | Default | Side-offshore scores until |
|---|---|---|---|
| Beginner | none (choice hidden) | side-shore only | – (0 from 100°) |
| Intermediate | side-shore only, slightly side-offshore | **side-shore only** | **110°** (20° past side-shore) |
| Advanced | side-shore only, slightly side-offshore | **slightly side-offshore** (as today) | **120°** (30° past side-shore) |

Direction factor by angle (what the score is multiplied by):

| Angle | 90° | 95° | 100° | 105° | 110° | 115° | 120°+ |
|---|---|---|---|---|---|---|---|
| Side-shore only (int. / adv.) | 0.85 / 0.9 | 0.43 / 0.45 | 0 | 0 | 0 | 0 | 0 |
| Intermediate, side-offshore | 0.85 | 0.63 | 0.4 | 0.2 | 0 | 0 | 0 |
| Advanced, side-offshore (unchanged) | 0.9 | 0.78 | 0.65 | 0.53 | 0.4 | 0.2 | 0 |

- Straight offshore (120° and beyond) stays 0 for everyone. Lagoons, points and coves keep their own water sector.
- Every side-offshore hour that scores is flagged on the spot: the warning now reads **"Side-offshore: stay upwind"** (it said "advanced only", wrong now that intermediates can opt in).
- Changing level resets the choice to the new level's default, so dropping to intermediate never keeps side-offshore by accident.
- A profile saved by the 31 Oct build (which had an intermediate opt-in) is not opted back in: the new choice is stored under a new name.
- Advanced riders on the default and every beginner: **no change** in scores.
- Settings: `ScoringRules.intermediateSideOffshoreToDeg` 110, `offshoreFromDeg` 120.

## Before / after: an intermediate who opts in

`kite --day <day> --slot afternoon --drive 150 --all --straight-line --level intermediate --offshore side-shore|side-offshore`, from Barcelona, 75 kg, 9 and 12 m, archived forecasts, same days as below. Only spots whose score changed:

| Day | Spot | Side-shore only | Slightly side-offshore |
|---|---|---|---|
| 2 Jul Tramontana | L'Estartit | 4 | 37 |
| | Sant Pere Pescador | 0 | 25 |
| 14 May Ponent | Calafell | 0 | 31 |
| | Altafulla | 0 | 24 |
| | Segur de Calafell | 0 | 3 |
| | Castelldefels | 69 | 92 (grade 92 both times; the "chance of wind" check moved 55 % → 83 %, partly run-to-run noise) |
| 8 Oct Mestral | Salou | 0 | 23 |
| | Sant Pere Pescador | 0 | 22 |
| | Palamós, L'Estartit, Platja d'Aro | 0 | 4, 4, 2 |

For comparison, an advanced rider got 62 at L'Estartit and 61 at Sant Pere on 2 Jul: the intermediate gets less because the window stops 10° earlier. Top picks don't change on any day.

Screenshots: [intermediate, opted in](review/whe160-offshore-intermediate.png) · [advanced default](review/whe160-offshore-advanced.png).

---

# Previous rule: side-offshore by level (WHE-75), angle limits and before / after

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
