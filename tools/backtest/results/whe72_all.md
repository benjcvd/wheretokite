# WHE-72 backtest 2026-08-08 … 2026-10-30

36 spots with a shore station (main: ≤ 1.5 km, or a shore mast ≤ 5 km), 86 with a station further away (weak). Daylight 07–17 UTC, measured wind brought to 10 m, nothing removed. Go day = best 2 h ≥ 12 kn, direction not offshore.

## Forecast made the day before, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2965 | +0.1 (-0.1 … +0.3) | 3.0 (2.9–3.2) | 707 | 66 % (61–71) | 35 % (30–39) | +0.3 | 2.9 | 19.4° |
| 2 AROME only, beach cell | 2965 | +0.1 (-0.0 … +0.3) | 3.0 (2.9–3.1) | 707 | 65 % (61–70) | 38 % (32–42) | +0.2 | 2.9 | 19.2° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 2965 | -0.6 (-0.7 … -0.4) | 2.6 (2.5–2.7) | 707 | 62 % (56–67) | 25 % (21–29) | +0.1 | 2.6 | 17.4° |
| 4 All three on the sea cell, capped at 1.5 km | 2965 | -0.5 (-0.7 … -0.4) | 2.7 (2.6–2.8) | 707 | 61 % (55–66) | 26 % (22–30) | +0.1 | 2.6 | 16.9° |
| 5 Skill-weighted (held-out weeks) | 2965 | -0.9 (-1.0 … -0.7) | 2.6 (2.5–2.7) | 707 | 61 % (55–66) | 23 % (19–27) | -0.2 | 2.5 | 17.1° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (-0.1 … +0.1), caught (-4 … +2) pts, false alarms (-0 … +6) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … -0.3), caught (-7 … -1) pts, false alarms (-13 … -8) pts
- 4 All three on the sea cell, capped at 1.5 km: error (-0.4 … -0.3), caught (-9 … -2) pts, false alarms (-11 … -6) pts
- 5 Skill-weighted (held-out weeks): error (-0.6 … -0.4), caught (-9 … -2) pts, false alarms (-15 … -9) pts

### Forecast made the day before, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 664 | -1.1 | 3.0 | 148 | 48 % | 35 % | -0.6 | 2.8 | 17.2° |
| 2 AROME only, beach cell | 664 | -0.7 | 3.1 | 148 | 56 % | 40 % | -0.5 | 2.9 | 17.0° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 664 | -1.2 | 2.7 | 148 | 51 % | 28 % | -0.4 | 2.5 | 15.3° |
| 4 All three on the sea cell, capped at 1.5 km | 664 | -1.2 | 2.7 | 148 | 55 % | 27 % | -0.4 | 2.5 | 14.5° |
| 5 Skill-weighted (held-out weeks) | 664 | -1.5 | 2.8 | 148 | 49 % | 27 % | -0.7 | 2.5 | 15.3° |

### Forecast made the day before, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 7041 | +0.1 | 3.0 | 1666 | 69 % | 35 % | +0.3 | 2.9 | 18.5° |
| 2 AROME only, beach cell | 7041 | +0.1 | 2.9 | 1666 | 69 % | 35 % | +0.2 | 2.8 | 19.5° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 7041 | -0.4 | 2.6 | 1666 | 66 % | 27 % | +0.3 | 2.5 | 16.5° |
| 4 All three on the sea cell, capped at 1.5 km | 7041 | -0.2 | 2.6 | 1666 | 69 % | 28 % | +0.4 | 2.5 | 16.4° |
| 5 Skill-weighted (held-out weeks) | 7041 | -0.7 | 2.6 | 1666 | 62 % | 25 % | -0.0 | 2.5 | 16.7° |

## Forecast of the day itself, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2965 | +0.1 (-0.1 … +0.3) | 2.8 (2.7–3.0) | 707 | 69 % (65–74) | 32 % (28–35) | +0.3 | 2.7 | 16.4° |
| 2 AROME only, beach cell | 2965 | +0.3 (+0.2 … +0.5) | 2.9 (2.7–3.0) | 707 | 71 % (67–76) | 35 % (31–39) | +0.3 | 2.7 | 15.4° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 2965 | -0.4 (-0.6 … -0.3) | 2.6 (2.4–2.7) | 707 | 63 % (58–68) | 26 % (22–30) | +0.2 | 2.5 | 15.3° |
| 4 All three on the sea cell, capped at 1.5 km | 2965 | -0.4 (-0.5 … -0.2) | 2.6 (2.5–2.7) | 707 | 62 % (57–67) | 26 % (21–30) | +0.2 | 2.5 | 14.7° |
| 5 Skill-weighted (held-out weeks) | 2965 | -0.7 (-0.8 … -0.6) | 2.4 (2.3–2.5) | 707 | 63 % (58–68) | 22 % (18–25) | -0.2 | 2.3 | 14.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (-0.0 … +0.1), caught (-1 … +6) pts, false alarms (+1 … +7) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (-0.3 … -0.2), caught (-9 … -3) pts, false alarms (-8 … -3) pts
- 4 All three on the sea cell, capped at 1.5 km: error (-0.3 … -0.1), caught (-10 … -4) pts, false alarms (-8 … -4) pts
- 5 Skill-weighted (held-out weeks): error (-0.5 … -0.3), caught (-10 … -4) pts, false alarms (-12 … -7) pts

### Forecast of the day itself, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 664 | -0.9 | 2.8 | 148 | 53 % | 31 % | -0.5 | 2.7 | 14.6° |
| 2 AROME only, beach cell | 664 | -0.5 | 3.0 | 148 | 61 % | 39 % | -0.3 | 2.7 | 13.3° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 664 | -1.1 | 2.6 | 148 | 50 % | 25 % | -0.4 | 2.4 | 13.2° |
| 4 All three on the sea cell, capped at 1.5 km | 664 | -1.1 | 2.6 | 148 | 57 % | 21 % | -0.3 | 2.4 | 12.1° |
| 5 Skill-weighted (held-out weeks) | 664 | -1.5 | 2.8 | 148 | 46 % | 24 % | -0.8 | 2.5 | 12.5° |

### Forecast of the day itself, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 7041 | -0.0 | 2.7 | 1666 | 70 % | 32 % | +0.2 | 2.6 | 15.3° |
| 2 AROME only, beach cell | 7041 | +0.3 | 2.8 | 1666 | 73 % | 35 % | +0.3 | 2.7 | 16.0° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 7041 | -0.3 | 2.5 | 1666 | 70 % | 25 % | +0.4 | 2.4 | 14.4° |
| 4 All three on the sea cell, capped at 1.5 km | 7041 | -0.0 | 2.5 | 1666 | 73 % | 27 % | +0.5 | 2.4 | 14.3° |
| 5 Skill-weighted (held-out weeks) | 7041 | -0.7 | 2.6 | 1666 | 64 % | 23 % | -0.1 | 2.4 | 15.3° |

## Per region, day before, main stations (best 2 h bias / error, go days caught / false)

| Region | Spots | Days | 1 Baseline | 2 AROME only, beach cell | 3 Option 1 | 4 All three on the sea cell, capped at 1.5 km | 5 Skill-weighted (held-out weeks) |
|---|---|---|---|---|---|---|---|
| Andalusia/Tarifa | 4 | 312 | -2.6 / 3.2 · 51 % / 32 % (37) | -3.4 / 3.7 · 30 % / 0 % (37) | -2.9 / 3.3 · 57 % / 28 % (37) | -2.5 / 3.2 · 62 % / 36 % (37) | -2.9 / 3.3 · 59 % / 27 % (37) |
| Brittany | 2 | 168 | +1.2 / 3.6 · 76 % / 31 % (62) | -0.3 / 3.7 · 63 % / 33 % (62) | -0.9 / 3.2 · 68 % / 22 % (62) | -0.9 / 2.7 · 74 % / 18 % (62) | -1.4 / 3.1 · 66 % / 13 % (62) |
| Canaries | 2 | 166 | -4.7 / 4.8 · 71 % / 3 % (90) | -6.9 / 6.9 · 40 % / 3 % (90) | -6.5 / 6.7 · 40 % / 3 % (90) | -8.3 / 8.3 · 10 % / 0 % (90) | -6.8 / 6.9 · 43 % / 2 % (90) |
| Catalonia | 10 | 810 | +1.9 / 3.0 · 19 % / 96 % (26) | +2.3 / 2.9 · 31 % / 93 % (26) | +1.7 / 2.4 · 31 % / 86 % (26) | +1.4 / 2.3 · 15 % / 92 % (26) | +1.1 / 2.2 · 15 % / 91 % (26) |
| Channel | 5 | 420 | +1.0 / 3.2 · 78 % / 30 % (147) | +0.8 / 2.3 · 87 % / 22 % (147) | -0.3 / 2.1 · 82 % / 16 % (147) | +0.1 / 2.4 · 80 % / 23 % (147) | -0.4 / 2.1 · 78 % / 17 % (147) |
| French Atlantic | 4 | 335 | -1.1 / 2.5 · 45 % / 25 % (87) | -0.5 / 2.3 · 53 % / 31 % (87) | -1.0 / 2.2 · 47 % / 21 % (87) | -0.5 / 1.8 · 66 % / 20 % (87) | -1.2 / 2.2 · 45 % / 20 % (87) |
| Languedoc/Roussillon | 3 | 252 | +0.4 / 2.3 · 80 % / 28 % (49) | +2.1 / 2.6 · 90 % / 52 % (49) | +0.1 / 1.8 · 73 % / 27 % (49) | +0.3 / 1.8 · 78 % / 25 % (49) | +0.1 / 1.8 · 73 % / 27 % (49) |
| Provence/Corsica | 5 | 418 | +0.2 / 2.9 · 75 % / 20 % (180) | +0.7 / 2.5 · 82 % / 21 % (180) | -0.7 / 2.4 · 67 % / 17 % (180) | -0.5 / 2.6 · 69 % / 14 % (180) | -1.3 / 2.3 · 66 % / 15 % (180) |
| Valencia/Murcia | 1 | 84 | -2.4 / 2.5 · 17 % / 0 % (29) | -2.4 / 2.5 · 10 % / 0 % (29) | -1.7 / 1.9 · 41 % / 0 % (29) | -1.8 / 2.0 · 41 % / 0 % (29) | -1.1 / 1.5 · 55 % / 0 % (29) |
| Andalusia/Tarifa (weak) | 5 | 311 | -2.5 / 3.3 · 26 % / 50 % (23) | -2.7 / 3.3 · 13 % / 25 % (23) | -2.1 / 2.9 · 30 % / 46 % (23) | -2.4 / 3.0 · 26 % / 45 % (23) | -2.0 / 2.9 · 35 % / 50 % (23) |
| Brittany (weak) | 14 | 1169 | +0.1 / 2.4 · 75 % / 26 % (434) | +0.1 / 2.5 · 71 % / 27 % (434) | -0.5 / 2.3 · 71 % / 21 % (434) | -0.6 / 2.4 · 68 % / 21 % (434) | -1.2 / 2.3 · 63 % / 18 % (434) |
| Canaries (weak) | 1 | 83 | -2.5 / 3.2 · 82 % / 0 % (68) | -12.0 / 12.0 · 13 % / 0 % (68) | -7.2 / 7.2 · 40 % / 0 % (68) | -2.0 / 2.9 · 82 % / 0 % (68) | -9.7 / 9.7 · 16 % / 0 % (68) |
| Catalonia (weak) | 19 | 1537 | +1.9 / 2.7 · 56 % / 84 % (57) | +2.4 / 3.0 · 81 % / 81 % (57) | +1.5 / 2.3 · 63 % / 74 % (57) | +1.6 / 2.4 · 63 % / 75 % (57) | +1.0 / 2.1 · 54 % / 65 % (57) |
| Channel (weak) | 11 | 923 | -1.6 / 3.2 · 74 % / 14 % (449) | -1.8 / 3.0 · 73 % / 10 % (449) | -2.2 / 3.0 · 72 % / 8 % (449) | -1.6 / 2.9 · 73 % / 12 % (449) | -2.4 / 3.1 · 69 % / 8 % (449) |
| French Atlantic (weak) | 9 | 755 | -1.6 / 2.8 · 49 % / 28 % (194) | -0.8 / 2.3 · 69 % / 28 % (194) | -1.4 / 2.3 · 57 % / 20 % (194) | -0.9 / 2.4 · 62 % / 24 % (194) | -1.5 / 2.3 · 56 % / 17 % (194) |
| Galicia/Cantabrian (weak) | 4 | 335 | -1.1 / 3.2 · 48 % / 42 % (46) | -1.2 / 2.2 · 54 % / 29 % (46) | -1.6 / 2.5 · 41 % / 21 % (46) | -1.1 / 1.9 · 57 % / 37 % (46) | -2.1 / 2.6 · 37 % / 6 % (46) |
| Languedoc/Roussillon (weak) | 14 | 1175 | +1.4 / 3.2 · 79 % / 44 % (267) | +1.3 / 2.8 · 79 % / 46 % (267) | +0.6 / 2.6 · 74 % / 37 % (267) | +0.5 / 2.6 · 75 % / 35 % (267) | +0.9 / 2.7 · 77 % / 38 % (267) |
| Provence/Corsica (weak) | 7 | 586 | -0.5 / 3.8 · 54 % / 42 % (109) | -0.6 / 3.0 · 70 % / 33 % (109) | -0.9 / 3.0 · 63 % / 30 % (109) | -0.7 / 3.2 · 67 % / 31 % (109) | -1.5 / 3.1 · 55 % / 29 % (109) |
| Valencia/Murcia (weak) | 2 | 167 | +0.8 / 2.7 · 37 % / 65 % (19) | +0.9 / 2.0 · 58 % / 54 % (19) | +0.5 / 2.2 · 32 % / 68 % (19) | +1.0 / 2.3 · 63 % / 56 % (19) | +0.7 / 2.3 · 42 % / 65 % (19) |

## Where to read AROME: beach, 500 m, 1 km, sea cell (day before, main stations)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| AROME 1.3 beach cell | 2403 | +1.2 (+1.0 … +1.3) | 2.7 (2.5–2.8) | 551 | 75 % (70–80) | 40 % (35–45) | +1.0 | 2.7 | 18.4° |
| AROME 1.3 nearest cell at the pin | 2403 | +1.5 (+1.3 … +1.7) | 2.7 (2.5–2.8) | 551 | 79 % (74–84) | 42 % (37–46) | +1.2 | 2.7 | 18.2° |
| AROME 1.3 at 500 m out | 2403 | +2.3 (+2.0 … +2.5) | 3.2 (3.0–3.4) | 551 | 85 % (81–88) | 47 % (42–51) | +1.8 | 3.1 | 18.1° |
| AROME 1.3 at 1 km out | 2403 | +2.7 (+2.5 … +3.0) | 3.6 (3.3–3.8) | 551 | 88 % (84–91) | 50 % (45–54) | +2.1 | 3.3 | 18.2° |
| AROME 1.3 sea cell | 2403 | +2.7 (+2.4 … +2.9) | 3.5 (3.2–3.7) | 551 | 88 % (84–91) | 50 % (45–54) | +2.1 | 3.3 | 18.1° |

Difference with **AROME 1.3 beach cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- AROME 1.3 nearest cell at the pin: error (-0.0 … +0.0), caught (+3 … +6) pts, false alarms (+1 … +3) pts
- AROME 1.3 at 500 m out: error (+0.5 … +0.6), caught (+7 … +13) pts, false alarms (+5 … +9) pts
- AROME 1.3 at 1 km out: error (+0.8 … +1.0), caught (+9 … +17) pts, false alarms (+8 … +12) pts
- AROME 1.3 sea cell: error (+0.7 … +0.9), caught (+9 … +16) pts, false alarms (+7 … +12) pts

## Weights fitted for setup 5 (AROME 1.3 / ICON / ECMWF, day before)

- Andalusia/Tarifa, weeks odd trained on the others: 0.0 / 0.5 / 0.5
- Andalusia/Tarifa, weeks even trained on the others: 0.1 / 0.4 / 0.5
- Brittany, weeks odd trained on the others: 0.0 / 0.7 / 0.3
- Brittany, weeks even trained on the others: 0.0 / 0.7 / 0.3
- Canaries, weeks odd trained on the others: 0.0 / 0.7 / 0.3
- Canaries, weeks even trained on the others: 0.1 / 0.7 / 0.2
- Catalonia, weeks odd trained on the others: 0.4 / 0.6 / 0.0
- Catalonia, weeks even trained on the others: 0.3 / 0.7 / 0.0
- Channel, weeks odd trained on the others: 0.3 / 0.4 / 0.3
- Channel, weeks even trained on the others: 0.2 / 0.5 / 0.3
- French Atlantic, weeks odd trained on the others: 0.4 / 0.3 / 0.3
- French Atlantic, weeks even trained on the others: 0.4 / 0.4 / 0.2
- Galicia/Cantabrian, weeks odd trained on the others: 0.3 / 0.5 / 0.2
- Galicia/Cantabrian, weeks even trained on the others: 0.3 / 0.5 / 0.2
- Languedoc/Roussillon, weeks odd trained on the others: 0.3 / 0.3 / 0.4
- Languedoc/Roussillon, weeks even trained on the others: 0.4 / 0.1 / 0.5
- Provence/Corsica, weeks odd trained on the others: 0.4 / 0.5 / 0.1
- Provence/Corsica, weeks even trained on the others: 0.4 / 0.5 / 0.1
- Valencia/Murcia, weeks odd trained on the others: 0.4 / 0.1 / 0.5
- Valencia/Murcia, weeks even trained on the others: 0.2 / 0.2 / 0.6

## Robustness: drop one main station at a time (day before, change Option 1 vs Baseline)

- without 08433: best 2 h error 3.06 → 2.66 (opt 1) / 2.71 (sea capped); caught 68 % → 63 % / 62 %; false 35 % → 25 % / 27 %
- without 08452: best 2 h error 3.03 → 2.63 (opt 1) / 2.68 (sea capped); caught 67 % → 62 % / 61 %; false 35 % → 25 % / 27 %
- without 08458: best 2 h error 3.04 → 2.57 (opt 1) / 2.65 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 24 % / 26 %
- without 08488: best 2 h error 3.03 → 2.62 (opt 1) / 2.67 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 24 % / 26 %
- without 13054001: best 2 h error 3.07 → 2.64 (opt 1) / 2.70 (sea capped); caught 66 % → 61 % / 60 %; false 36 % → 25 % / 28 %
- without 13056002: best 2 h error 3.06 → 2.66 (opt 1) / 2.71 (sea capped); caught 66 % → 61 % / 60 %; false 35 % → 25 % / 26 %
- without 17323001: best 2 h error 3.07 → 2.66 (opt 1) / 2.73 (sea capped); caught 66 % → 61 % / 60 %; false 36 % → 25 % / 27 %
- without 29178001: best 2 h error 3.00 → 2.64 (opt 1) / 2.71 (sea capped); caught 66 % → 61 % / 60 %; false 34 % → 24 % / 26 %
- without 29190001: best 2 h error 3.05 → 2.60 (opt 1) / 2.67 (sea capped); caught 66 % → 62 % / 60 %; false 36 % → 25 % / 27 %
- without 30133005: best 2 h error 3.09 → 2.68 (opt 1) / 2.74 (sea capped); caught 65 % → 61 % / 60 %; false 35 % → 25 % / 26 %
- without 33236002: best 2 h error 3.07 → 2.66 (opt 1) / 2.73 (sea capped); caught 67 % → 63 % / 61 %; false 35 % → 25 % / 26 %
- without 34154001: best 2 h error 3.06 → 2.66 (opt 1) / 2.72 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 25 % / 26 %
- without 40046001: best 2 h error 3.02 → 2.61 (opt 1) / 2.69 (sea capped); caught 68 % → 64 % / 62 %; false 35 % → 25 % / 27 %
- without 50215002: best 2 h error 3.02 → 2.64 (opt 1) / 2.68 (sea capped); caught 67 % → 61 % / 61 %; false 36 % → 26 % / 28 %
- without 50509002: best 2 h error 3.07 → 2.67 (opt 1) / 2.71 (sea capped); caught 66 % → 62 % / 60 %; false 35 % → 25 % / 26 %
- without 62548002: best 2 h error 3.07 → 2.66 (opt 1) / 2.72 (sea capped); caught 66 % → 61 % / 60 %; false 35 % → 25 % / 27 %
- without 62826001: best 2 h error 2.98 → 2.62 (opt 1) / 2.68 (sea capped); caught 65 % → 61 % / 60 %; false 34 % → 24 % / 25 %
- without 80182003: best 2 h error 3.04 → 2.67 (opt 1) / 2.72 (sea capped); caught 65 % → 60 % / 59 %; false 35 % → 25 % / 26 %
- without 83069001: best 2 h error 3.05 → 2.65 (opt 1) / 2.71 (sea capped); caught 65 % → 63 % / 61 %; false 35 % → 25 % / 27 %
- without DK: best 2 h error 3.14 → 2.72 (opt 1) / 2.78 (sea capped); caught 68 % → 63 % / 63 %; false 35 % → 24 % / 26 %
- without DL: best 2 h error 3.01 → 2.61 (opt 1) / 2.68 (sea capped); caught 66 % → 62 % / 61 %; false 33 % → 22 % / 25 %
- without DO: best 2 h error 3.04 → 2.66 (opt 1) / 2.70 (sea capped); caught 66 % → 62 % / 61 %; false 34 % → 24 % / 25 %
- without GCLP: best 2 h error 2.97 → 2.42 (opt 1) / 2.41 (sea capped); caught 64 % → 63 % / 67 %; false 38 % → 26 % / 27 %
- without GCRR: best 2 h error 3.01 → 2.61 (opt 1) / 2.65 (sea capped); caught 67 % → 63 % / 62 %; false 35 % → 25 % / 26 %
- without LERT: best 2 h error 3.05 → 2.64 (opt 1) / 2.71 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 25 % / 27 %
- without LESO: best 2 h error 3.06 → 2.66 (opt 1) / 2.73 (sea capped); caught 66 % → 62 % / 61 %; false 34 % → 24 % / 26 %
- without LFKF: best 2 h error 3.04 → 2.63 (opt 1) / 2.69 (sea capped); caught 66 % → 62 % / 61 %; false 36 % → 26 % / 28 %
- without LFTH: best 2 h error 3.01 → 2.63 (opt 1) / 2.68 (sea capped); caught 65 % → 61 % / 60 %; false 35 % → 25 % / 26 %
- without U2: best 2 h error 2.93 → 2.62 (opt 1) / 2.70 (sea capped); caught 66 % → 62 % / 61 %; false 29 % → 23 % / 25 %
- without U6: best 2 h error 3.04 → 2.61 (opt 1) / 2.66 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 24 % / 26 %
- without WT: best 2 h error 3.06 → 2.65 (opt 1) / 2.72 (sea capped); caught 66 % → 62 % / 61 %; false 33 % → 23 % / 25 %
- without WZ: best 2 h error 3.06 → 2.62 (opt 1) / 2.70 (sea capped); caught 66 % → 62 % / 61 %; false 35 % → 25 % / 26 %
- without YR: best 2 h error 3.08 → 2.67 (opt 1) / 2.73 (sea capped); caught 66 % → 62 % / 61 %; false 34 % → 25 % / 26 %

## Pairs and where each model's cell falls (km from the pin)

| Spot | Region | Station | Kind | km | Height | AROME 1.3 beach / nearest / sea / 500 m / 1 km | ICON beach / nearest / sea | ECMWF nearest / sea |
|---|---|---|---|---|---|---|---|---|
| Gran Canaria – Vargas | Canaries | Airport Gran Canaria | airport (a2) | 3.62 |  | – / – / – / – / – | 3.6 / 3.2 / 3.2 | 16.0 / 18.7 |
| Tenerife – El Médano | Canaries | Airport Tenerife | airport (c) | 2.0 |  | – / – / – / – / – | 3.7 / 1.6 / 1.6 | 6.1 / 6.1 |
| Lanzarote – Playa Honda | Canaries | Airport Arrecife | airport (a) | 0.66 |  | – / – / – / – / – | 1.3 / 1.3 / 6.1 | 10.8 / 23.9 |
| Tarifa – Balneario | Andalusia/Tarifa | AEMET Tarifa | synop (a) | 1.34 |  | – / – / – / – / – | 6.0 / 1.8 / 1.8 | 9.8 / 9.8 |
| Tarifa – Los Lances | Andalusia/Tarifa | AEMET Tarifa | synop (c) | 6.32 |  | – / – / – / – / – | 2.2 / 2.2 / 5.4 | 11.2 / 11.2 |
| Algeciras – Palmones | Andalusia/Tarifa | Airport Algeciras | airport (c) | 5.23 |  | – / – / – / – / – | 1.6 / 1.6 / 5.6 | 10.6 / 20.5 |
| San Fernando – Camposoto | Andalusia/Tarifa | AEMET San Fernando | synop (c) | 6.5 |  | – / – / – / – / – | 4.2 / 3.8 / 3.8 | 10.2 / 10.2 |
| Cádiz – Cortadura | Andalusia/Tarifa | AEMET Cadiz Obs | synop (a2) | 2.08 |  | – / – / – / – / – | 7.3 / 2.1 / 2.1 | 2.1 / 2.1 |
| El Puerto – Valdelagrana | Andalusia/Tarifa | AEMET Cadiz Obs | synop (c) | 8.45 |  | – / – / – / – / – | 3.8 / 2.4 / 2.4 | 8.5 / 8.5 |
| Rota – El Rompidillo | Andalusia/Tarifa | Airport Rota | airport (a2) | 2.76 |  | – / – / – / – / – | 3.8 / 1.8 / 1.8 | 16.4 / 16.4 |
| Málaga – Los Álamos | Andalusia/Tarifa | Airport Malaga | airport (c) | 3.7 |  | – / – / – / – / – | 5.1 / 3.1 / 3.1 | 11.8 / 16.3 |
| Almería – El Zapillo | Andalusia/Tarifa | AEMET Almeria | synop (a2) | 1.96 |  | – / – / – / – / – | 5.7 / 1.6 / 1.6 | 9.5 / 9.5 |
| Mar Menor – Los Narejos | Valencia/Murcia | AEMET Murcia San Javier | synop (a2) | 3.58 |  | 0.4 / 0.4 / 0.4 / 1.1 / 1.1 | 3.4 / 2.1 / 2.1 | 7.6 / 7.6 |
| Elche – Arenales del Sol | Valencia/Murcia | AEMET Alicante | synop (c) | 5.12 |  | 0.3 / 0.3 / 0.5 / 0.5 / 1.4 | 4.1 / 1.4 / 1.4 | 1.4 / 1.4 |
| Burriana – El Arenal | Valencia/Murcia | AEMET Castellon-Almazora | synop (c) | 8.93 |  | 0.0 / 0.0 / 0.8 / 0.0 / 1.4 | 0.6 / 0.6 / 6.4 | 14.3 / 14.3 |
| El Trabucador (Ebro delta) | Catalonia | Meteocat els Alfacs | mast (c) | 5.77 |  | 0.3 / 0.3 / 0.3 / 0.3 / 1.1 | 9.0 / 2.9 / 2.9 | 12.3 / 12.3 |
| Sant Carles de la Ràpita (Badia dels Alfacs) | Catalonia | Meteocat els Alfacs | mast (c) | 5.79 |  | 0.5 / 0.5 / 0.7 / 0.5 / 1.5 | 3.0 / 2.9 / 6.2 | 14.9 / 14.9 |
| Platja dels Eucaliptus (Ebro delta) | Catalonia | Meteocat Illa de Buda | mast (c) | 7.57 |  | 0.4 / 0.4 / 0.9 / 0.4 / 0.9 | 4.6 / 4.0 / 4.0 | 11.1 / 17.2 |
| Riumar (Ebro delta) | Catalonia | Meteocat Illa de Buda | mast (a2) | 2.68 |  | 0.4 / 0.4 / 1.0 / 1.1 / 1.1 | 2.8 / 2.8 / 4.0 | 7.4 / 14.1 |
| Punta del Fangar (Ebro delta) | Catalonia | Meteocat el Perelló | mast (c) | 9.73 |  | 1.4 / 0.4 / 0.4 / 0.8 / 1.0 | 6.4 / 2.4 / 2.4 | 4.9 / 20.6 |
| L'Ampolla (Platja de l'Arenal) | Catalonia | Meteocat l'Aldea | mast (c) | 7.89 |  | 0.5 / 0.5 / 0.6 / 0.9 / 1.5 | 2.6 / 2.6 / 4.4 | 6.2 / 32.9 |
| L'Almadrava (Vandellòs) | Catalonia | Meteocat l'Ametlla de Mar | mast (c) | 8.19 |  | 0.2 / 0.2 / 1.1 / 0.2 / 1.0 | 3.8 / 1.4 / 1.4 | 11.3 / 13.7 |
| L'Hospitalet de l'Infant | Catalonia | Meteocat Miami Platja | mast (c) | 4.51 |  | 0.5 / 0.5 / 1.5 / 0.6 / 0.6 | 3.8 / 2.7 / 2.7 | 7.5 / 7.5 |
| Cambrils (Platja del Regueral) | Catalonia | Meteocat Vinyols i els Arcs - Cambrils | mast (a2) | 1.63 |  | 0.5 / 0.5 / 0.6 / 0.6 / 0.6 | 0.7 / 0.7 / 4.7 | 9.3 / 9.3 |
| Salou (Platja de Llevant) | Catalonia | Meteocat Vinyols i els Arcs - Cambrils | mast (c) | 6.1 |  | 0.8 / 0.3 / 0.3 / 0.3 / 1.4 | 6.0 / 1.6 / 1.6 | 12.3 / 12.3 |
| La Pineda | Catalonia | Meteocat Tarragona - Complex Educatiu | mast (c) | 1.78 |  | 0.3 / 0.3 / 1.2 / 0.6 / 1.2 | 4.0 / 3.0 / 3.0 | 11.0 / 11.0 |
| Altafulla | Catalonia | Meteocat Torredembarra | mast (a2) | 3.81 |  | 0.4 / 0.4 / 1.5 / 0.4 / 1.5 | 5.5 / 0.9 / 0.9 | 16.6 / 18.0 |
| Torredembarra | Catalonia | Meteocat Torredembarra | mast (a) | 0.64 |  | 0.4 / 0.4 / 1.5 / 0.7 / 0.7 | 5.3 / 2.9 / 2.9 | 13.9 / 17.5 |
| Creixell | Catalonia | Meteocat Torredembarra | mast (a2) | 3.29 |  | 0.3 / 0.3 / 0.6 / 0.6 / 1.3 | 3.3 / 3.3 / 4.2 | 10.7 / 18.3 |
| Calafell | Catalonia | Meteocat Cunit | mast (c) | 5.24 |  | 0.5 / 0.5 / 0.5 / 0.8 / 0.9 | 4.3 / 1.0 / 1.0 | 9.4 / 21.7 |
| Segur de Calafell | Catalonia | Meteocat Cunit | mast (a2) | 2.22 |  | 0.2 / 0.2 / 1.1 / 0.2 / 1.2 | 1.1 / 1.1 / 4.2 | 11.6 / 23.1 |
| Vilanova i la Geltrú (La Farola) | Catalonia | Meteocat Vilanova i la Geltrú | mast (a2) | 2.28 |  | 0.4 / 0.4 / 1.1 / 0.7 / 1.1 | 3.8 / 3.3 / 3.3 | 3.8 / 24.1 |
| Castelldefels | Catalonia | Meteocat Viladecans - les Filipines | mast (c) | 6.1 |  | 0.6 / 0.5 / 0.5 / 0.5 / 0.5 | 5.6 / 2.4 / 2.4 | 2.4 / 2.4 |
| Barcelona – Barceloneta | Catalonia | Meteocat Barcelona - el Raval | mast (c) | 2.2 |  | 0.3 / 0.3 / 1.1 / 0.6 / 1.2 | 6.5 / 0.7 / 0.7 | 14.2 / 15.1 |
| Barcelona – Nova Mar Bella | Catalonia | Meteocat Barcelona - el Raval | mast (c) | 4.42 |  | 0.5 / 0.5 / 0.5 / 0.5 / 0.5 | 4.6 / 3.8 / 3.8 | 11.3 / 17.1 |
| Badalona | Catalonia | Meteocat Badalona - Museu | mast (c) | 1.15 |  | 0.3 / 0.3 / 1.3 / 0.3 / 1.1 | 5.0 / 0.6 / 0.6 | 6.5 / 21.3 |
| Montgat | Catalonia | Meteocat Badalona - Museu | mast (c) | 3.3 |  | 0.5 / 0.5 / 0.7 / 0.9 / 0.9 | 4.6 / 4.1 / 4.1 | 4.6 / 24.2 |
| Vilassar de Mar | Catalonia | Meteocat Cabrils | mast (c) | 2.41 |  | 0.4 / 0.4 / 1.0 / 0.7 / 1.0 | 0.7 / 0.7 / 4.7 | 9.9 / 9.9 |
| Malgrat de Mar – La Pomareda | Catalonia | Meteocat Malgrat de Mar | mast (a) | 1.31 |  | 0.2 / 0.2 / 1.0 / 1.0 / 1.2 | 4.7 / 3.2 / 3.2 | 11.4 / 16.6 |
| Platja d'Aro | Catalonia | Meteocat Castell d'Aro | mast (a2) | 3.27 |  | 0.4 / 0.4 / 0.8 / 1.1 / 1.1 | 0.8 / 0.8 / 4.6 | 9.4 / 9.4 |
| Palamós (La Fosca) | Catalonia | Meteocat Palafrugell | mast (c) | 5.75 |  | 0.4 / 0.4 / 0.9 / 0.9 / 0.9 | 2.5 / 2.5 / 4.2 | 14.8 / 14.8 |
| L'Escala (Platja dels Riells) | Catalonia | Meteocat Sant Pere Pescador | mast (c) | 7.7 |  | 0.5 / 0.5 / 1.0 / 0.5 / 1.0 | 1.6 / 1.6 / 4.1 | 15.8 / 15.8 |
| Sant Martí d'Empúries | Catalonia | Meteocat Sant Pere Pescador | mast (c) | 5.21 |  | 0.5 / 0.5 / 0.8 / 0.9 / 0.9 | 1.1 / 1.1 / 5.5 | 16.3 / 16.6 |
| Sant Pere Pescador | Catalonia | Meteocat Sant Pere Pescador | mast (a2) | 1.58 |  | 0.2 / 0.2 / 1.0 / 0.2 / 1.0 | 1.4 / 1.4 / 6.5 | 11.2 / 13.5 |
| Redondela – Cesantes | Galicia/Cantabrian | Airport Vigo | airport (c) | 7.3 |  | 0.6 / 0.6 / 1.0 / 0.6 / 1.0 | 0.9 / 0.9 / 0.9 | 11.6 / 12.3 |
| Somo | Galicia/Cantabrian | AEMET Santander | synop (c) | 6.12 |  | 0.1 / 0.1 / 0.7 / 0.1 / 1.4 | 2.9 / 2.9 / 0.7 | 4.7 / 4.7 |
| Santander – Los Peligros | Galicia/Cantabrian | AEMET Santander | synop (c) | 2.66 |  | 0.5 / 0.5 / 0.6 / 0.9 / 0.9 | 3.8 / 3.8 / 0.6 | 4.4 / 4.4 |
| Salinas – San Juan de Nieva | Galicia/Cantabrian | AEMET Asturias | synop (c) | 7.03 |  | 0.1 / 0.1 / 1.3 / 0.1 / 1.3 | 2.3 / 2.3 / 5.0 | 9.8 / 19.2 |
| Bonifacio – Piantarella | Provence/Corsica | Météo-France Cap Pertusato | semaphore (c) | 3.31 |  | 0.5 / 0.5 / 1.1 / 0.5 / 1.2 | 7.5 / 2.5 / 2.5 | 14.1 / 14.1 |
| Bonifacio – Tonnara | Provence/Corsica | Airport Figari | airport (c) | 8.28 |  | 1.6 / 0.6 / 0.6 / 0.6 / 1.3 | 2.1 / 2.1 / 3.8 | 12.0 / 21.5 |
| Bonifacio – Balistra | Provence/Corsica | Météo-France Cap Pertusato | semaphore (c) | 8.03 |  | 0.3 / 0.3 / 1.2 / 0.6 / 0.6 | 2.9 / 2.3 / 2.3 | 7.2 / 21.1 |
| Figari – Baie de Figari | Provence/Corsica | Airport Figari | airport (a2) | 4.99 |  | 0.7 / 0.2 / 0.2 / 0.7 / 0.7 | 6.4 / 2.7 / 2.7 | 7.1 / 24.2 |
| Calvi – La Pinède | Provence/Corsica | Météo-France Calvi | mast (c) | 3.26 |  | 0.8 / 0.5 / 0.5 / 0.5 / 1.6 | 3.1 / 2.2 / 2.2 | 6.6 / 21.6 |
| Torreilles – Le Blockhaus | Languedoc/Roussillon | Météo-France Torreilles | mast (c) | 5.01 |  | 0.5 / 0.5 / 1.1 / 0.5 / 1.1 | 3.5 / 2.6 / 2.6 | 3.5 / 17.4 |
| Le Barcarès – Les 3 Colonnes | Languedoc/Roussillon | Météo-France Torreilles | mast (c) | 8.8 |  | 0.1 / 0.1 / 0.7 / 0.7 / 0.7 | 8.4 / 1.9 / 1.9 | 8.4 / 18.7 |
| Le Barcarès – Parc des Dosses (Étang de Leucate) | Languedoc/Roussillon | Météo-France Leucate | mast (c) | 8.75 |  | 0.2 / 0.2 / 0.2 / 0.2 / 1.0 | 10.5 / 4.1 / 4.1 | 10.5 / 20.5 |
| Leucate – Le Goulet | Languedoc/Roussillon | Météo-France Leucate | mast (c) | 3.32 |  | 0.3 / 0.3 / 0.3 / 0.8 / 0.8 | 3.1 / 3.1 / 4.5 | 9.8 / 21.1 |
| Leucate – Les Coussoules / La Franqui | Languedoc/Roussillon | Météo-France Leucate | mast (c) | 3.79 |  | 0.4 / 0.4 / 1.1 / 0.4 / 1.1 | 3.2 / 2.3 / 2.3 | 6.6 / 18.2 |
| Étang de La Palme | Languedoc/Roussillon | Météo-France Leucate | mast (c) | 6.85 |  | 0.2 / 0.2 / 0.2 / 0.7 / 0.7 | 3.6 / 3.6 / 4.8 | 3.6 / 19.1 |
| Hyères – L'Almanarre | Provence/Corsica | Airport Hyeres | airport (a2) | 3.84 |  | 0.7 / 0.2 / 0.2 / 0.2 / 1.0 | 7.1 / 0.6 / 0.6 | 11.8 / 11.8 |
| Six-Fours – Le Brusc | Provence/Corsica | Météo-France Toulon | mast (c) | 8.74 |  | 0.5 / 0.3 / 0.3 / 0.3 / 1.1 | 5.2 / 2.0 / 2.0 | 9.8 / 9.8 |
| Hyères – Le Mérou | Provence/Corsica | Météo-France Hyeres | mast (a2) | 2.88 |  | 0.3 / 0.3 / 0.8 / 1.1 / 1.1 | 2.0 / 2.0 / 5.0 | 13.2 / 13.2 |
| Narbonne – La Nautique | Languedoc/Roussillon | Météo-France Narbonne | mast (c) | 4.17 |  | 0.5 / 0.5 / 0.5 / 0.6 / 1.6 | 2.1 / 2.1 / 10.1 | 11.9 / 25.4 |
| Sérignan – La Grande Maïre | Languedoc/Roussillon | Météo-France Beziers-Vias | mast (c) | 6.07 |  | 0.2 / 0.2 / 0.9 / 0.9 / 1.2 | 5.5 / 3.1 / 0.9 | 7.6 / 13.0 |
| Agde – La Tamarissière | Languedoc/Roussillon | Airport Beziers | airport (c) | 7.81 |  | 0.5 / 0.5 / 0.8 / 0.9 / 0.9 | 2.8 / 2.8 / 0.8 | 6.6 / 6.6 |
| Carro | Provence/Corsica | Météo-France Cap Couronne | semaphore (a2) | 1.9 |  | 0.5 / 0.5 / 0.7 / 0.7 / 1.1 | 5.0 / 3.6 / 0.9 | 9.9 / 9.9 |
| Sète – Les 3 Digues | Languedoc/Roussillon | Météo-France Sete | mast (c) | 7.08 |  | 0.6 / 0.6 / 0.7 / 0.7 / 0.7 | 8.0 / 1.3 / 0.7 | 15.9 / 15.9 |
| Hendaye | French Atlantic | Airport San Sebastian | airport (a2) | 1.67 |  | 0.5 / 0.5 / 0.9 / 0.9 / 0.9 | 2.1 / 2.1 / 0.9 | 13.8 / 14.3 |
| Fréjus – Saint-Aygulf | Provence/Corsica | Météo-France Frejus | mast (c) | 2.75 |  | 0.1 / 0.1 / 0.8 / 0.8 / 0.8 | 4.5 / 3.1 / 0.8 | 11.3 / 16.7 |
| Sète – Pont-Levis | Languedoc/Roussillon | Météo-France Sete | mast (c) | 2.85 |  | 0.3 / 0.3 / 0.3 / 0.6 / 1.1 | 4.8 / 3.8 / 0.3 | 13.3 / 18.4 |
| Marignane – Le Jaï | Provence/Corsica | Météo-France Marignane | mast (a2) | 4.16 |  | 0.4 / 0.4 / 0.4 / 0.8 / 0.8 | 4.8 / 2.8 / 0.8 | 11.4 / 19.6 |
| Mèze – La Pinède | Languedoc/Roussillon | Météo-France Sete | mast (c) | 7.74 |  | 0.1 / 0.1 / 0.1 / 0.1 / 1.3 | 3.9 / 0.1 / 0.1 | 12.1 / 20.6 |
| Le Grau-du-Roi – L'Espiguette | Languedoc/Roussillon | Météo-France L'Espiguette | mast (a) | 0.83 |  | 0.5 / 0.4 / 0.4 / 0.4 / 1.3 | 1.0 / 1.0 / 2.9 | 8.8 / 11.8 |
| Anglet – La Madrague | French Atlantic | Airport Biarritz-bayonne | airport (c) | 4.58 |  | 0.3 / 0.3 / 0.5 / 0.5 / 1.1 | 3.0 / 2.6 / 1.1 | 3.0 / 17.4 |
| Port-Camargue – Plage Sud | Languedoc/Roussillon | Météo-France L'Espiguette | mast (a2) | 3.4 |  | 0.6 / 0.6 / 0.6 / 0.6 / 1.1 | 0.9 / 0.9 / 1.0 | 9.9 / 9.9 |
| Cannes – Palm Beach | Provence/Corsica | Airport Cannes | airport (c) | 6.9 |  | 0.6 / 0.6 / 0.6 / 0.6 / 1.1 | 3.6 / 3.6 / 0.6 | 5.0 / 5.0 |
| Le Grau-du-Roi – Le Boucanet | Languedoc/Roussillon | Météo-France L'Espiguette | mast (c) | 6.69 |  | 0.5 / 0.5 / 0.7 / 0.9 / 0.9 | 1.5 / 0.5 / 0.5 | 10.8 / 10.8 |
| Carnon – Petit Travers | Languedoc/Roussillon | Météo-France Montpellier-Aeroport | mast (a2) | 4.33 |  | 0.4 / 0.4 / 1.0 / 0.4 / 1.4 | 1.0 / 1.0 / 1.0 | 5.9 / 5.9 |
| La Grande-Motte | Languedoc/Roussillon | Météo-France Montpellier-Aeroport | mast (c) | 8.55 |  | 0.4 / 0.4 / 0.8 / 0.8 / 0.8 | 1.4 / 1.0 / 1.0 | 8.4 / 8.4 |
| Seignosse – Les Estagnots | French Atlantic | Météo-France Capbreton | mast (c) | 6.75 |  | 0.3 / 0.3 / 0.8 / 0.8 / 0.8 | 7.0 / 0.3 / 0.8 | 8.4 / 8.4 |
| Biscarrosse-Plage | French Atlantic | Météo-France Biscarrosse | mast (a) | 1.39 |  | 0.6 / 0.4 / 0.4 / 0.4 / 1.1 | 6.4 / 0.8 / 0.4 | 6.4 / 6.4 |
| La Teste – La Salie | French Atlantic | Météo-France Cazaux | mast (c) | 9.88 |  | 0.3 / 0.3 / 1.1 / 0.3 / 1.1 | 3.3 / 3.3 / 1.1 | 3.3 / 3.3 |
| Bassin d'Arcachon – Les Arbousiers | French Atlantic | Météo-France Cap-Ferret | mast (a2) | 4.43 |  | 0.5 / 0.5 / 0.9 / 0.9 / 0.9 | 2.5 / 2.5 / 0.7 | 12.2 / 12.2 |
| Oléron – Plaisance | French Atlantic | Météo-France Chassiron | mast (c) | 9.08 |  | 0.3 / 0.3 / 1.6 / 0.7 / 0.7 | 0.5 / 0.5 / 0.3 | 5.3 / 5.3 |
| Oléron – Plage des Huttes | French Atlantic | Météo-France Chassiron | mast (a2) | 4.68 |  | 0.4 / 0.4 / 0.4 / 0.7 / 1.0 | 1.5 / 1.5 / 1.0 | 8.4 / 8.4 |
| La Rochelle – Aytré | French Atlantic | Météo-France La Rochelle-Ile De Re | mast (c) | 8.82 |  | 0.5 / 0.5 / 0.5 / 0.8 / 0.8 | 4.7 / 1.0 / 0.5 | 16.0 / 16.3 |
| Île de Ré – Rivedoux | French Atlantic | Météo-France La Rochelle-Ile De Re | mast (c) | 5.73 |  | 0.4 / 0.4 / 0.9 / 0.9 / 0.9 | 4.6 / 3.0 / 0.4 | 9.8 / 9.8 |
| Île de Ré – Les Portes (Trousse-Chemise) | French Atlantic | Météo-France Saint-Clement Des Baleines | mast (c) | 6.67 |  | 0.6 / 0.6 / 0.6 / 0.7 / 1.3 | 2.5 / 2.5 / 0.6 | 2.5 / 2.5 |
| La Tranche-sur-Mer | French Atlantic | Météo-France Grues | mast (c) | 9.71 |  | 0.7 / 0.5 / 0.5 / 0.5 / 0.5 | 3.9 / 3.9 / 0.5 | 10.9 / 10.9 |
| Saint-Brevin-les-Pins | French Atlantic | Météo-France Pte De Chemoulin | semaphore (c) | 9.88 |  | 1.1 / 0.2 / 0.2 / 0.8 / 1.2 | 4.9 / 3.6 / 0.8 | 7.0 / 7.0 |
| Penthièvre | Brittany | Météo-France Quiberon-Aerodrome | mast (c) | 7.42 |  | 0.4 / 0.4 / 1.0 / 0.4 / 1.1 | 9.2 / 2.4 / 0.5 | 9.9 / 9.9 |
| Fort-Bloqué | Brittany | Météo-France Lorient-Lann Bihoue | mast (c) | 5.96 |  | 0.8 / 0.3 / 0.3 / 0.3 / 0.9 | 3.1 / 3.1 / 0.7 | 3.1 / 24.8 |
| La Torche | Brittany | Météo-France Pte De Penmarch | semaphore (c) | 5.45 |  | 0.4 / 0.4 / 1.0 / 0.4 / 1.0 | 4.3 / 4.0 / 4.0 | 12.7 / 12.7 |
| Mousterlin | Brittany | Météo-France Beg_Meil | mast (c) | 5.05 |  | 0.4 / 0.4 / 0.9 / 0.9 / 0.9 | 3.5 / 3.5 / 4.1 | 11.2 / 11.2 |
| Bénodet – Lagune du Letty | Brittany | Météo-France Beg_Meil | mast (c) | 7.48 |  | 0.3 / 0.3 / 1.3 / 1.1 / 1.1 | 1.8 / 1.8 / 5.5 | 13.6 / 13.6 |
| Crozon – Goulien | Brittany | Airport Lanvedoc | airport (c) | 8.49 |  | 0.6 / 0.6 / 1.2 / 0.6 / 1.2 | 1.4 / 1.4 / 6.5 | 3.4 / 15.1 |
| Le Conquet – Blancs Sablons | Brittany | Météo-France Plougonvelin | mast (a2) | 4.56 |  | 0.4 / 0.3 / 0.3 / 0.3 / 1.5 | 1.3 / 1.3 / 3.5 | 13.5 / 13.5 |
| Brest – Moulin Blanc | Brittany | Airport Brest | airport (c) | 5.43 |  | 0.4 / 0.4 / 0.4 / 0.7 / 0.7 | 2.5 / 2.5 / 5.8 | 12.6 / 28.8 |
| Plérin – Les Rosaires | Brittany | Airport St.-brieuc Armor | airport (c) | 8.06 |  | 0.5 / 0.5 / 0.7 / 0.7 / 0.7 | 4.5 / 0.2 / 0.8 | 7.1 / 20.7 |
| Lampaul-Ploudalmézeau – Trois Moutons | Brittany | Météo-France Ploudalmezeau | mast (a2) | 2.71 |  | 0.2 / 0.2 / 1.1 / 0.9 / 0.9 | 2.3 / 2.3 / 6.2 | 10.4 / 20.9 |
| Landéda – Sainte-Marguerite | Brittany | Météo-France Ploudalmezeau | mast (c) | 6.94 |  | 0.5 / 0.5 / 0.5 / 0.6 / 1.4 | 4.0 / 3.6 / 3.6 | 13.1 / 18.7 |
| Lancieux | Brittany | Airport Dinard | airport (c) | 6.4 |  | 0.3 / 0.3 / 1.6 / 0.3 / 1.3 | 2.9 / 2.9 / 1.0 | 13.9 / 17.1 |
| Saint-Lunaire – Longchamp | Brittany | Airport Dinard | airport (c) | 6.37 |  | 0.4 / 0.4 / 0.7 / 0.7 / 0.7 | 1.3 / 1.3 / 0.4 | 15.5 / 15.5 |
| Keremma | Brittany | Météo-France Brignogan | mast (c) | 7.18 |  | 0.1 / 0.1 / 0.1 / 0.1 / 1.1 | 2.8 / 2.8 / 4.2 | 11.1 / 11.1 |
| Saint-Malo – Le Sillon | Brittany | Airport Dinard | airport (c) | 8.78 |  | 0.4 / 0.4 / 1.5 / 0.6 / 0.6 | 3.7 / 3.6 / 0.6 | 10.4 / 10.4 |
| Santec – Le Dossen | Brittany | Météo-France Sibiril S A | mast (c) | 4.03 |  | 0.5 / 0.5 / 0.5 / 1.0 / 1.0 | 0.8 / 0.8 / 6.2 | 7.5 / 7.5 |
| Jullouville | Channel | Météo-France Granville | mast (c) | 8.79 |  | 1.2 / 0.1 / 0.1 / 0.8 / 0.8 | 0.7 / 0.7 / 0.7 | 5.2 / 13.3 |
| Agon-Coutainville | Channel | Météo-France Gouville | mast (c) | 7.93 |  | 0.4 / 0.4 / 0.8 / 0.4 / 1.0 | 3.8 / 3.5 / 0.4 | 8.2 / 11.9 |
| Gouville-sur-Mer | Channel | Météo-France Gouville | mast (a) | 1.48 |  | 0.5 / 0.5 / 0.9 / 0.9 / 0.9 | 1.0 / 1.0 / 1.0 | 13.2 / 14.6 |
| Utah Beach | Channel | Météo-France Ste Marie Du Mo | mast (a) | 1.32 |  | 0.6 / 0.6 / 0.6 / 0.6 / 1.2 | 1.4 / 0.5 / 0.5 | 10.8 / 10.8 |
| Le Havre | Channel | Airport Le Havre | airport (c) | 1.99 |  | 1.0 / 0.5 / 0.5 / 0.9 / 0.9 | 2.4 / 1.3 / 1.3 | 6.5 / 6.5 |
| Cherbourg – Collignon | Channel | Météo-France Cherbourg-Homet | mast (c) | 5.07 |  | 0.5 / 0.5 / 0.7 / 0.7 / 0.7 | 0.8 / 0.8 / 1.9 | 11.6 / 11.6 |
| Urville-Nacqueville | Channel | Météo-France Cherbourg-Homet | mast (c) | 5.17 |  | 0.5 / 0.3 / 0.3 / 0.9 / 0.9 | 0.5 / 0.5 / 1.4 | 9.3 / 9.3 |
| Cayeux-sur-Mer – La Mollière | Channel | Météo-France Cayeux-Sur-Mer | mast (a2) | 2.33 |  | 0.3 / 0.3 / 0.7 / 0.3 / 1.5 | 0.3 / 0.3 / 1.6 | 5.1 / 5.1 |
| Le Crotoy | Channel | Météo-France Cayeux-Sur-Mer | mast (c) | 7.89 |  | 0.5 / 0.5 / 0.7 / 0.7 / 1.1 | 0.6 / 0.6 / 1.4 | 9.5 / 9.5 |
| Le Touquet | Channel | Météo-France Le-Touquet | mast (a2) | 3.21 |  | 0.1 / 0.1 / 0.6 / 0.6 / 1.3 | 0.7 / 0.7 / 1.5 | 6.0 / 6.0 |
| Le Portel | Channel | Météo-France Boulogne-Sem | mast (c) | 3.05 |  | 0.2 / 0.2 / 0.8 / 0.8 / 0.8 | 1.4 / 1.4 / 1.5 | 6.6 / 6.6 |
| Wimereux – Pointe aux Oies | Channel | Météo-France Boulogne-Sem | mast (c) | 6.27 |  | 0.3 / 0.3 / 0.5 / 0.5 / 1.2 | 1.3 / 1.3 / 1.7 | 8.7 / 8.7 |
| Wissant | Channel | Météo-France Cap-Gris-Nez | mast (c) | 5.95 |  | 0.5 / 0.5 / 1.5 / 0.5 / 1.0 | 0.8 / 0.8 / 1.5 | 14.0 / 14.0 |
| Calais – Blériot-Plage | Channel | Météo-France Calais-Marck | mast (c) | 8.43 |  | 0.6 / 0.6 / 1.7 / 0.7 / 0.7 | 1.1 / 0.8 / 0.8 | 7.2 / 7.2 |
| Les Hemmes de Marck | Channel | Météo-France Calais-Marck | mast (a2) | 3.01 |  | 0.4 / 0.4 / 0.4 / 0.4 / 1.5 | 1.2 / 1.2 / 2.0 | 3.0 / 3.0 |
| Malo-les-Bains (Dunkerque) | Channel | Météo-France Dunkerque | mast (c) | 4.19 |  | 0.4 / 0.4 / 1.0 / 0.7 / 0.7 | 1.2 / 1.2 / 1.4 | 9.2 / 22.9 |
