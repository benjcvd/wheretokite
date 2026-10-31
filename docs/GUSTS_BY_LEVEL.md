# Gusts by rider level and session intensity (WHE-73)

31 Oct 2026. Follows finding 2 of the [Barcelona scoring check](SCORING_CHECK_BCN.md#2-gusty-fires-on-almost-every-hour-which-halves-every-score).
Your call: gusts weigh less for advanced riders and intense sessions; beginners stay protected.

## Why "gusty" fired on almost every hour

The forecast blend gives gusts at **1.75× the mean wind on a typical hour** (half of all kiteable hours sit between 1.6× and 1.8×, the range is 1.5–2.1×). Meteocat masts near the spots show the same 1.6–2.5×. The old rule called anything above 1.4× gusty (intermediate, all types), so it fired on every hour and halved every score.

## The new rule

"Gusty" now means gustier than the forecast normally is, and the bar depends on level and intensity.

| | Steady-wind penalty starts above | Penalty per 0.1× above it | Gust limit (too strong) | Mean-wind limit | "Overpowered in gusts" margin over the kite's top |
|---|---|---|---|---|---|
| Beginner, chill → intense | 1.55× → 1.70× (was 1.25× → 1.45×) | −20 % (was −15 %) | **25 kn, unchanged** | 20 kn, unchanged | 5 kn, unchanged |
| Intermediate, chill → intense | 1.70× → 1.90× (was 1.30× → 1.50×) | −15 %, unchanged | 34 → 40 kn (was 34) | 28 kn, unchanged | 5 → 9 kn (was 5) |
| Advanced, chill → intense | 1.80× → 2.10× (was 1.40× → 1.60×) | −10 % (was −15 %) | 48 → 54 kn (was 48) | 40 kn, unchanged | 8 → 12 kn (was 5) |

- "All types" counts as halfway between chill and intense (intermediate: penalty from 1.80×, gust limit 37 kn).
- The "gusty" label now shows only when the penalty takes at least 10 % off, so it tells a gusty day from a normal one.
- Every number is in `ScoringRules` (`Sources/KiteCore/Scoring.swift`): `gustTolerance`, `gustPenaltySlope`, `limits`, `gustOverpowerMarginKn`, `gustyFlagBelow`.

## Before / after on the WHE-64 days

Afternoon, 3 h drive from Barcelona, 75 kg, 9 and 12 m kites, straight-line drive times. Top three spots and their scores.

### Beginner, chill

| Day | Before | After |
|---|---|---|
| 28 Jul Garbí | Trabucador 34, Saint-Cyprien 33, Castelldefels 29 | Trabucador 71, Saint-Cyprien 63, Sant Pere 58 |
| 4 Sep Garbí | Saint-Cyprien 44, Eucaliptus 29, Trabucador 28 | Saint-Cyprien 80, Trabucador 60, Eucaliptus 50 |
| 2 Jul Tramontana | Eucaliptus 14, Riumar 13, Trabucador 10 | Eucaliptus 22, Trabucador 20, Riumar 13 |
| 23 Apr Llevant | Saint-Cyprien 45, Gruissan 34, Cambrils 33 | Saint-Cyprien 84, Cambrils 67, Torreilles 65 |
| 8 Oct Mestral | Vilanova 42, Pals 10 | Vilanova 42, Pals 12 |
| 21 Jun Empordà thermal | Sant Pere 48, L'Estartit 27, Ganguise 27 | Sant Pere 90, Ganguise 58, L'Estartit 41 |

- Still flagged gusty on 294 of 314 kiteable hours: typical forecast gusts still cost a beginner 30–40 %.
- "Too strong for level": 731 hours before and after. Nothing a beginner was kept off is open now.

### Intermediate, all types (your CLI profile)

| Day | Before | After |
|---|---|---|
| 28 Jul Garbí | Trabucador 56, Sant Pere 46, Castelldefels 42 | Malgrat 100, Trabucador 100, Castelldefels 97 |
| 4 Sep Garbí | Saint-Cyprien 56, Trabucador 48, Eucaliptus 37 | Trabucador 89, Eucaliptus 88, Saint-Cyprien 72 |
| 2 Jul Tramontana | Riumar 21, Trabucador 21, Ganguise 20 | Riumar 57, Ganguise 52, Trabucador 43 |
| 14 Apr Tramontana | Gruissan 41, Barcarès 36, L'Escala Riells 34 | L'Escala Riells 100, Barcarès 97, Gruissan 85 |
| 23 Apr Llevant | Saint-Cyprien 66, Cambrils 58, Narbonne 53 | Riumar 100, Fangar 100, Trabucador 100 |
| 19 Oct Mestral + ENE | Trabucador 56, Vilanova 47, L'Ampolla 36 | Vilassar 85, Trabucador 80, Badalona 80 |
| 8 Oct Mestral | Vilanova 36 (one hour), Ganguise 32, Barcarès 21 | Barcarès 86, L'Escala Riells 75, Ganguise 65; Trabucador 51 (was "too strong") |
| 14 May Ponent | Barcarès 39, Platja d'Aro 28, Fangar 26 | Barcarès 87, Fangar 80, Gruissan 73 |
| 21 Jun Empordà thermal | Sant Pere 70, Ganguise 50, Empuriabrava 28 | Sant Pere 96, Ganguise 96, L'Estartit 71 |
| 24 Aug stormy | Saint-Cyprien 78, Barcarès 59, Leucate 51 | Narbonne 95, Saint-Cyprien 92, Leucate 85 |

- Gusty: every kiteable hour before (715 of 716), 341 of 872 after (39 %).
- "Too strong for level": 321 → 165 hours. Riumar at 21 kn gusting 40 and Leucate at 23 kn gusting 42 on 8 Oct stay shut.

### Advanced, intense

| Day | Before | After |
|---|---|---|
| 28 Jul Garbí | Trabucador 65, Malgrat 53, Sant Pere 49 | Malgrat 84, Trabucador 75, Eucaliptus 65 |
| 2 Jul Tramontana | Barcarès 63, Gruissan 63, Leucate Goulet 61 | Barcarès 97, Ganguise 74, La Palme 73 |
| 14 Apr Tramontana | Leucate Goulet 60, Gruissan 57, Barcarès 57 | Leucate Goulet 93, La Palme 93, Barcarès 90 |
| 8 Oct Mestral | Leucate Goulet 65, Riumar 62, Barcarès 62 | Leucate Goulet 98, Riumar 97, La Palme 97 |
| 14 May Ponent | Gruissan 63, Barcarès 53, La Palme 53 | Gruissan 95, La Palme 92, Barcarès 89 |
| 24 Aug stormy | Torreilles 75, Narbonne 66, Saint-Cyprien 65 | Narbonne 97, Saint-Cyprien 90, Leucate 90 |

- Gusty: 996 of 1037 kiteable hours before, 46 after (4 %). "Overpowered in gusts": 729 → 240.

## What to watch

- **Scores bunch near 100 on good days** for intermediates (four spots at 100 on 23 Apr). Gusts were the only thing holding scores down; now ties are broken by drive time and confidence. Fine for picking a spot, but the number says less.
- **24 Aug stays unsafe**: Saint-Cyprien is now 92 for a window that ends an hour before a thunderstorm. That's WHE-74 (storm warning), next on my list.
- The gust ratio is the forecast's, not the station's: if Forecast accuracy changes the blend or calibrates gusts, these tolerances need a second look.
