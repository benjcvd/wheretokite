# WHE-72 backtest 2026-08-08 … 2026-10-30

19 spots with a shore station (main: ≤ 1.5 km, or a shore mast ≤ 5 km), 55 with a station further away (weak). Daylight 07–17 UTC, measured wind brought to 10 m, nothing removed. Go day = best 2 h ≥ 12 kn, direction not offshore.

## Forecast made the day before, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1593 | +0.3 (+0.1 … +0.5) | 2.9 (2.7–3.1) | 525 | 71 % (66–77) | 26 % (21–31) | +0.5 | 3.0 | 18.1° |
| 2 AROME only, beach cell | 1593 | +0.6 (+0.4 … +0.8) | 2.6 (2.4–2.7) | 525 | 77 % (73–82) | 29 % (24–33) | +0.7 | 2.7 | 18.2° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 1593 | -0.5 (-0.7 … -0.4) | 2.3 (2.1–2.4) | 525 | 69 % (63–74) | 19 % (15–23) | +0.3 | 2.3 | 15.8° |
| 4 All three on the sea cell, capped at 1.5 km | 1593 | -0.3 (-0.4 … -0.1) | 2.3 (2.1–2.4) | 525 | 73 % (68–78) | 19 % (16–23) | +0.4 | 2.4 | 15.8° |
| 5 Skill-weighted (held-out weeks) | 1593 | -0.8 (-1.0 … -0.7) | 2.3 (2.1–2.4) | 525 | 66 % (61–72) | 17 % (14–21) | -0.0 | 2.3 | 15.7° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (-0.5 … -0.2), caught (+2 … +10) pts, false alarms (-1 … +6) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (-0.7 … -0.5), caught (-7 … +1) pts, false alarms (-10 … -4) pts
- 4 All three on the sea cell, capped at 1.5 km: error (-0.7 … -0.5), caught (-2 … +5) pts, false alarms (-10 … -4) pts
- 5 Skill-weighted (held-out weeks): error (-0.8 … -0.5), caught (-9 … -1) pts, false alarms (-12 … -5) pts

### Forecast made the day before, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 336 | -0.9 | 3.1 | 118 | 55 % | 20 % | -0.4 | 2.9 | 16.2° |
| 2 AROME only, beach cell | 336 | +0.1 | 2.7 | 118 | 68 % | 28 % | +0.2 | 2.6 | 16.2° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 336 | -0.9 | 2.4 | 118 | 58 % | 14 % | -0.2 | 2.2 | 13.5° |
| 4 All three on the sea cell, capped at 1.5 km | 336 | -0.6 | 2.4 | 118 | 64 % | 16 % | +0.0 | 2.3 | 13.7° |
| 5 Skill-weighted (held-out weeks) | 336 | -1.1 | 2.5 | 118 | 55 % | 14 % | -0.3 | 2.3 | 13.7° |

### Forecast made the day before, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 4608 | -0.3 | 3.0 | 1453 | 70 % | 29 % | +0.2 | 3.0 | 17.6° |
| 2 AROME only, beach cell | 4608 | -0.2 | 2.7 | 1453 | 73 % | 28 % | +0.1 | 2.8 | 18.1° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 4608 | -0.8 | 2.6 | 1453 | 69 % | 22 % | +0.1 | 2.6 | 15.6° |
| 4 All three on the sea cell, capped at 1.5 km | 4608 | -0.6 | 2.6 | 1453 | 70 % | 23 % | +0.2 | 2.6 | 15.6° |
| 5 Skill-weighted (held-out weeks) | 4608 | -1.0 | 2.7 | 1453 | 66 % | 21 % | -0.1 | 2.6 | 15.8° |

## Forecast of the day itself, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1593 | +0.2 (+0.0 … +0.4) | 2.7 (2.5–2.9) | 525 | 73 % (67–78) | 23 % (19–28) | +0.5 | 2.6 | 14.8° |
| 2 AROME only, beach cell | 1593 | +0.7 (+0.5 … +0.8) | 2.3 (2.1–2.4) | 525 | 81 % (76–84) | 25 % (20–29) | +0.7 | 2.4 | 13.9° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 1593 | -0.5 (-0.6 … -0.4) | 2.1 (1.9–2.2) | 525 | 69 % (64–75) | 18 % (14–22) | +0.3 | 2.1 | 13.5° |
| 4 All three on the sea cell, capped at 1.5 km | 1593 | -0.2 (-0.3 … -0.1) | 2.1 (2.0–2.2) | 525 | 73 % (68–79) | 17 % (14–21) | +0.5 | 2.2 | 13.6° |
| 5 Skill-weighted (held-out weeks) | 1593 | -0.7 (-0.8 … -0.6) | 2.0 (1.9–2.2) | 525 | 68 % (63–73) | 15 % (12–19) | -0.0 | 2.0 | 13.1° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (-0.5 … -0.3), caught (+4 … +13) pts, false alarms (-1 … +4) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (-0.7 … -0.5), caught (-7 … +0) pts, false alarms (-9 … -3) pts
- 4 All three on the sea cell, capped at 1.5 km: error (-0.7 … -0.5), caught (-3 … +3) pts, false alarms (-9 … -4) pts
- 5 Skill-weighted (held-out weeks): error (-0.8 … -0.5), caught (-8 … -2) pts, false alarms (-11 … -5) pts

### Forecast of the day itself, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 336 | -0.9 | 2.9 | 118 | 57 % | 14 % | -0.4 | 2.7 | 13.7° |
| 2 AROME only, beach cell | 336 | +0.3 | 2.4 | 118 | 71 % | 25 % | +0.4 | 2.3 | 11.5° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 336 | -0.9 | 2.2 | 118 | 54 % | 9 % | -0.1 | 2.0 | 10.9° |
| 4 All three on the sea cell, capped at 1.5 km | 336 | -0.6 | 2.2 | 118 | 63 % | 9 % | +0.1 | 2.2 | 11.3° |
| 5 Skill-weighted (held-out weeks) | 336 | -1.0 | 2.3 | 118 | 53 % | 9 % | -0.3 | 2.1 | 10.7° |

### Forecast of the day itself, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 4608 | -0.3 | 2.7 | 1453 | 72 % | 24 % | +0.1 | 2.7 | 14.3° |
| 2 AROME only, beach cell | 4608 | -0.0 | 2.5 | 1453 | 78 % | 27 % | +0.2 | 2.6 | 14.5° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 4608 | -0.6 | 2.4 | 1453 | 72 % | 20 % | +0.2 | 2.4 | 13.5° |
| 4 All three on the sea cell, capped at 1.5 km | 4608 | -0.4 | 2.5 | 1453 | 74 % | 22 % | +0.3 | 2.4 | 13.4° |
| 5 Skill-weighted (held-out weeks) | 4608 | -1.0 | 2.5 | 1453 | 68 % | 20 % | -0.2 | 2.4 | 13.6° |

## Per region, day before, main stations (best 2 h bias / error, go days caught / false)

| Region | Spots | Days | 1 Baseline | 2 AROME only, beach cell | 3 Option 1 | 4 All three on the sea cell, capped at 1.5 km | 5 Skill-weighted (held-out weeks) |
|---|---|---|---|---|---|---|---|
| Brittany | 2 | 168 | +1.2 / 3.6 · 76 % / 31 % (62) | -0.3 / 3.7 · 63 % / 33 % (62) | -0.9 / 3.2 · 68 % / 22 % (62) | -0.9 / 2.7 · 74 % / 18 % (62) | -1.4 / 3.1 · 66 % / 13 % (62) |
| Channel | 5 | 420 | +1.0 / 3.2 · 78 % / 30 % (147) | +0.8 / 2.3 · 87 % / 22 % (147) | -0.3 / 2.1 · 82 % / 16 % (147) | +0.1 / 2.4 · 80 % / 23 % (147) | -0.4 / 2.1 · 78 % / 17 % (147) |
| French Atlantic | 4 | 335 | -1.1 / 2.5 · 45 % / 25 % (87) | -0.5 / 2.3 · 53 % / 31 % (87) | -1.0 / 2.2 · 47 % / 21 % (87) | -0.5 / 1.8 · 66 % / 20 % (87) | -1.2 / 2.2 · 45 % / 20 % (87) |
| Languedoc/Roussillon | 3 | 252 | +0.4 / 2.3 · 80 % / 28 % (49) | +2.1 / 2.6 · 90 % / 52 % (49) | +0.1 / 1.8 · 73 % / 27 % (49) | +0.3 / 1.8 · 78 % / 25 % (49) | +0.1 / 1.8 · 73 % / 27 % (49) |
| Provence/Corsica | 5 | 418 | +0.2 / 2.9 · 75 % / 20 % (180) | +0.7 / 2.5 · 82 % / 21 % (180) | -0.7 / 2.4 · 67 % / 17 % (180) | -0.5 / 2.6 · 69 % / 14 % (180) | -1.3 / 2.3 · 66 % / 15 % (180) |
| Brittany (weak) | 14 | 1169 | +0.1 / 2.4 · 75 % / 26 % (434) | +0.1 / 2.5 · 71 % / 27 % (434) | -0.5 / 2.3 · 71 % / 21 % (434) | -0.6 / 2.4 · 68 % / 21 % (434) | -1.2 / 2.3 · 63 % / 18 % (434) |
| Channel (weak) | 11 | 923 | -1.6 / 3.2 · 74 % / 14 % (449) | -1.8 / 3.0 · 73 % / 10 % (449) | -2.2 / 3.0 · 72 % / 8 % (449) | -1.6 / 2.9 · 73 % / 12 % (449) | -2.4 / 3.1 · 69 % / 8 % (449) |
| French Atlantic (weak) | 9 | 755 | -1.6 / 2.8 · 49 % / 28 % (194) | -0.8 / 2.3 · 69 % / 28 % (194) | -1.4 / 2.3 · 57 % / 20 % (194) | -0.9 / 2.4 · 62 % / 24 % (194) | -1.5 / 2.3 · 56 % / 17 % (194) |
| Languedoc/Roussillon (weak) | 14 | 1175 | +1.4 / 3.2 · 79 % / 44 % (267) | +1.3 / 2.8 · 79 % / 46 % (267) | +0.6 / 2.6 · 74 % / 37 % (267) | +0.5 / 2.6 · 75 % / 35 % (267) | +0.9 / 2.7 · 77 % / 38 % (267) |
| Provence/Corsica (weak) | 7 | 586 | -0.5 / 3.8 · 54 % / 42 % (109) | -0.6 / 3.0 · 70 % / 33 % (109) | -0.9 / 3.0 · 63 % / 30 % (109) | -0.7 / 3.2 · 67 % / 31 % (109) | -1.5 / 3.1 · 55 % / 29 % (109) |

## Where to read AROME: beach, 500 m, 1 km, sea cell (day before, main stations)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| AROME 1.3 beach cell | 1593 | +0.6 (+0.4 … +0.8) | 2.6 (2.4–2.7) | 525 | 77 % (73–82) | 29 % (24–33) | +0.7 | 2.7 | 18.2° |
| AROME 1.3 nearest cell at the pin | 1593 | +1.1 (+0.9 … +1.3) | 2.6 (2.4–2.7) | 525 | 82 % (78–86) | 32 % (27–37) | +1.0 | 2.8 | 18.0° |
| AROME 1.3 at 500 m out | 1593 | +1.7 (+1.5 … +1.9) | 2.9 (2.7–3.1) | 525 | 87 % (83–90) | 34 % (30–39) | +1.4 | 3.0 | 18.0° |
| AROME 1.3 at 1 km out | 1593 | +2.0 (+1.8 … +2.2) | 3.1 (2.9–3.3) | 525 | 89 % (85–92) | 36 % (31–40) | +1.7 | 3.2 | 18.0° |
| AROME 1.3 sea cell | 1593 | +1.9 (+1.7 … +2.1) | 3.0 (2.8–3.2) | 525 | 88 % (84–91) | 35 % (31–40) | +1.6 | 3.1 | 17.9° |

Difference with **AROME 1.3 beach cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- AROME 1.3 nearest cell at the pin: error (-0.0 … +0.1), caught (+3 … +7) pts, false alarms (+2 … +4) pts
- AROME 1.3 at 500 m out: error (+0.3 … +0.4), caught (+7 … +12) pts, false alarms (+4 … +8) pts
- AROME 1.3 at 1 km out: error (+0.5 … +0.6), caught (+8 … +15) pts, false alarms (+5 … +9) pts
- AROME 1.3 sea cell: error (+0.4 … +0.5), caught (+8 … +14) pts, false alarms (+4 … +9) pts

## Weights fitted for setup 5 (AROME 1.3 / ICON / ECMWF, day before)

- Brittany, weeks odd trained on the others: 0.0 / 0.7 / 0.3
- Brittany, weeks even trained on the others: 0.0 / 0.7 / 0.3
- Channel, weeks odd trained on the others: 0.3 / 0.4 / 0.3
- Channel, weeks even trained on the others: 0.2 / 0.5 / 0.3
- French Atlantic, weeks odd trained on the others: 0.4 / 0.3 / 0.3
- French Atlantic, weeks even trained on the others: 0.4 / 0.4 / 0.2
- Languedoc/Roussillon, weeks odd trained on the others: 0.3 / 0.3 / 0.4
- Languedoc/Roussillon, weeks even trained on the others: 0.4 / 0.1 / 0.5
- Provence/Corsica, weeks odd trained on the others: 0.4 / 0.5 / 0.1
- Provence/Corsica, weeks even trained on the others: 0.4 / 0.5 / 0.1

## Robustness: drop one main station at a time (day before, change Option 1 vs Baseline)

- without 13054001: best 2 h error 2.94 → 2.25 (opt 1) / 2.24 (sea capped); caught 71 % → 68 % / 73 %; false 27 % → 19 % / 20 %
- without 13056002: best 2 h error 2.92 → 2.28 (opt 1) / 2.26 (sea capped); caught 71 % → 68 % / 73 %; false 26 % → 18 % / 19 %
- without 17323001: best 2 h error 2.95 → 2.29 (opt 1) / 2.29 (sea capped); caught 71 % → 67 % / 72 %; false 27 % → 19 % / 20 %
- without 29178001: best 2 h error 2.81 → 2.25 (opt 1) / 2.27 (sea capped); caught 71 % → 68 % / 72 %; false 24 % → 18 % / 19 %
- without 29190001: best 2 h error 2.90 → 2.16 (opt 1) / 2.19 (sea capped); caught 71 % → 69 % / 73 %; false 27 % → 19 % / 20 %
- without 30133005: best 2 h error 2.97 → 2.31 (opt 1) / 2.30 (sea capped); caught 70 % → 67 % / 72 %; false 26 % → 18 % / 19 %
- without 33236002: best 2 h error 2.94 → 2.29 (opt 1) / 2.30 (sea capped); caught 73 % → 70 % / 73 %; false 26 % → 19 % / 19 %
- without 34154001: best 2 h error 2.93 → 2.28 (opt 1) / 2.28 (sea capped); caught 72 % → 69 % / 74 %; false 26 % → 18 % / 19 %
- without 40046001: best 2 h error 2.85 → 2.19 (opt 1) / 2.23 (sea capped); caught 75 % → 72 % / 75 %; false 26 % → 19 % / 20 %
- without 50215002: best 2 h error 2.84 → 2.24 (opt 1) / 2.21 (sea capped); caught 73 % → 68 % / 74 %; false 27 % → 20 % / 20 %
- without 50509002: best 2 h error 2.93 → 2.29 (opt 1) / 2.27 (sea capped); caught 71 % → 69 % / 72 %; false 25 % → 19 % / 19 %
- without 62548002: best 2 h error 2.95 → 2.28 (opt 1) / 2.28 (sea capped); caught 71 % → 68 % / 72 %; false 26 % → 19 % / 20 %
- without 62826001: best 2 h error 2.78 → 2.21 (opt 1) / 2.20 (sea capped); caught 70 % → 67 % / 72 %; false 24 % → 17 % / 18 %
- without 80182003: best 2 h error 2.89 → 2.31 (opt 1) / 2.28 (sea capped); caught 70 % → 67 % / 72 %; false 25 % → 19 % / 19 %
- without 83069001: best 2 h error 2.91 → 2.27 (opt 1) / 2.26 (sea capped); caught 70 % → 70 % / 74 %; false 26 % → 19 % / 20 %
- without LESO: best 2 h error 2.92 → 2.28 (opt 1) / 2.30 (sea capped); caught 71 % → 69 % / 73 %; false 25 % → 18 % / 19 %
- without LFKF: best 2 h error 2.88 → 2.22 (opt 1) / 2.22 (sea capped); caught 72 % → 69 % / 74 %; false 27 % → 20 % / 21 %
- without LFTH: best 2 h error 2.82 → 2.23 (opt 1) / 2.21 (sea capped); caught 70 % → 68 % / 72 %; false 26 % → 18 % / 19 %

## Pairs and where each model's cell falls (km from the pin)

| Spot | Region | Station | Kind | km | Height | AROME 1.3 beach / nearest / sea / 500 m / 1 km | ICON beach / nearest / sea | ECMWF nearest / sea |
|---|---|---|---|---|---|---|---|---|
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
