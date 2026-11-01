# WHE-72 backtest 2026-08-08 … 2026-10-30

17 spots with a shore station (main: ≤ 1.5 km, or a shore mast ≤ 5 km), 31 with a station further away (weak). Daylight 07–17 UTC, measured wind brought to 10 m, nothing removed. Go day = best 2 h ≥ 12 kn, direction not offshore.

## Forecast made the day before, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1372 | -0.2 (-0.4 … +0.1) | 3.2 (3.0–3.4) | 182 | 51 % (45–59) | 56 % (51–61) | -0.1 | 2.9 | 21.8° |
| 2 AROME only, beach cell | 1372 | -0.4 (-0.7 … -0.2) | 3.5 (3.3–3.7) | 182 | 32 % (25–39) | 66 % (60–73) | -0.3 | 3.1 | 21.0° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 1372 | -0.6 (-0.8 … -0.3) | 3.1 (2.9–3.2) | 182 | 42 % (36–50) | 44 % (36–51) | -0.0 | 2.9 | 20.6° |
| 4 All three on the sea cell, capped at 1.5 km | 1372 | -0.9 (-1.1 … -0.6) | 3.2 (3.0–3.4) | 182 | 26 % (19–35) | 56 % (47–66) | -0.3 | 2.9 | 18.9° |
| 5 Skill-weighted (held-out weeks) | 1372 | -0.9 (-1.1 … -0.7) | 3.0 (2.8–3.1) | 182 | 45 % (36–53) | 39 % (32–46) | -0.4 | 2.8 | 19.7° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (+0.2 … +0.4), caught (-26 … -13) pts, false alarms (+5 … +17) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (-0.2 … -0.0), caught (-14 … -3) pts, false alarms (-18 … -6) pts
- 4 All three on the sea cell, capped at 1.5 km: error (-0.1 … +0.1), caught (-33 … -18) pts, false alarms (-7 … +8) pts
- 5 Skill-weighted (held-out weeks): error (-0.3 … -0.2), caught (-13 … -1) pts, false alarms (-22 … -11) pts

### Forecast made the day before, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 328 | -1.2 | 2.9 | 30 | 20 % | 79 % | -0.8 | 2.8 | 18.4° |
| 2 AROME only, beach cell | 328 | -1.5 | 3.5 | 30 | 10 % | 89 % | -1.1 | 3.2 | 18.0° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 328 | -1.5 | 3.1 | 30 | 23 % | 73 % | -0.6 | 2.9 | 17.6° |
| 4 All three on the sea cell, capped at 1.5 km | 328 | -1.8 | 3.0 | 30 | 23 % | 70 % | -0.9 | 2.7 | 15.6° |
| 5 Skill-weighted (held-out weeks) | 328 | -2.0 | 3.2 | 30 | 23 % | 68 % | -1.2 | 2.8 | 17.3° |

### Forecast made the day before, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2433 | +0.7 | 2.9 | 213 | 58 % | 62 % | +0.6 | 2.7 | 22.8° |
| 2 AROME only, beach cell | 2433 | +0.7 | 3.1 | 213 | 44 % | 70 % | +0.5 | 2.8 | 25.8° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 2433 | +0.3 | 2.6 | 213 | 45 % | 57 % | +0.6 | 2.4 | 20.8° |
| 4 All three on the sea cell, capped at 1.5 km | 2433 | +0.6 | 2.4 | 213 | 64 % | 51 % | +0.8 | 2.4 | 20.3° |
| 5 Skill-weighted (held-out weeks) | 2433 | -0.0 | 2.5 | 213 | 39 % | 52 % | +0.2 | 2.4 | 21.3° |

## Forecast of the day itself, main stations

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1372 | -0.0 (-0.3 … +0.2) | 3.0 (2.8–3.1) | 182 | 59 % (52–68) | 50 % (45–56) | +0.0 | 2.7 | 19.3° |
| 2 AROME only, beach cell | 1372 | -0.1 (-0.3 … +0.1) | 3.6 (3.4–3.7) | 182 | 45 % (38–52) | 63 % (56–68) | -0.1 | 3.1 | 18.4° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 1372 | -0.3 (-0.6 … -0.1) | 3.1 (2.9–3.3) | 182 | 46 % (38–54) | 49 % (41–57) | +0.1 | 2.9 | 18.7° |
| 4 All three on the sea cell, capped at 1.5 km | 1372 | -0.6 (-0.8 … -0.4) | 3.2 (3.0–3.3) | 182 | 30 % (22–38) | 57 % (49–66) | -0.2 | 2.9 | 16.7° |
| 5 Skill-weighted (held-out weeks) | 1372 | -0.8 (-1.0 … -0.6) | 2.9 (2.7–3.0) | 182 | 47 % (39–56) | 41 % (33–47) | -0.4 | 2.7 | 17.4° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME only, beach cell: error (+0.5 … +0.7), caught (-22 … -8) pts, false alarms (+8 … +17) pts
- 3 Option 1: AROME+ICON beach, ECMWF sea: error (+0.0 … +0.2), caught (-20 … -8) pts, false alarms (-7 … +4) pts
- 4 All three on the sea cell, capped at 1.5 km: error (+0.1 … +0.3), caught (-36 … -23) pts, false alarms (+1 … +12) pts
- 5 Skill-weighted (held-out weeks): error (-0.2 … +0.0), caught (-19 … -6) pts, false alarms (-15 … -4) pts

### Forecast of the day itself, only the stations ≤ 1.5 km

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 328 | -1.0 | 2.8 | 30 | 37 % | 69 % | -0.6 | 2.6 | 15.8° |
| 2 AROME only, beach cell | 328 | -1.3 | 3.5 | 30 | 23 % | 81 % | -1.0 | 3.1 | 15.7° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 328 | -1.4 | 3.1 | 30 | 33 % | 66 % | -0.6 | 2.9 | 16.0° |
| 4 All three on the sea cell, capped at 1.5 km | 328 | -1.6 | 2.9 | 30 | 33 % | 62 % | -0.9 | 2.6 | 13.2° |
| 5 Skill-weighted (held-out weeks) | 328 | -2.0 | 3.2 | 30 | 20 % | 73 % | -1.3 | 2.9 | 14.8° |

### Forecast of the day itself, weak stations (further away)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2433 | +0.6 | 2.7 | 213 | 57 % | 62 % | +0.5 | 2.6 | 19.7° |
| 2 AROME only, beach cell | 2433 | +0.8 | 3.2 | 213 | 43 % | 73 % | +0.5 | 2.8 | 23.0° |
| 3 Option 1: AROME+ICON beach, ECMWF sea | 2433 | +0.4 | 2.6 | 213 | 51 % | 54 % | +0.7 | 2.4 | 18.6° |
| 4 All three on the sea cell, capped at 1.5 km | 2433 | +0.8 | 2.4 | 213 | 69 % | 53 % | +0.9 | 2.4 | 18.1° |
| 5 Skill-weighted (held-out weeks) | 2433 | -0.1 | 2.5 | 213 | 36 % | 52 % | +0.0 | 2.4 | 23.4° |

## Per region, day before, main stations (best 2 h bias / error, go days caught / false)

| Region | Spots | Days | 1 Baseline | 2 AROME only, beach cell | 3 Option 1 | 4 All three on the sea cell, capped at 1.5 km | 5 Skill-weighted (held-out weeks) |
|---|---|---|---|---|---|---|---|
| Andalusia/Tarifa | 4 | 312 | -2.6 / 3.2 · 51 % / 32 % (37) | -3.4 / 3.7 · 30 % / 0 % (37) | -2.9 / 3.3 · 57 % / 28 % (37) | -2.5 / 3.2 · 62 % / 36 % (37) | -2.9 / 3.3 · 59 % / 27 % (37) |
| Canaries | 2 | 166 | -4.7 / 4.8 · 71 % / 3 % (90) | -6.9 / 6.9 · 40 % / 3 % (90) | -6.5 / 6.7 · 40 % / 3 % (90) | -8.3 / 8.3 · 10 % / 0 % (90) | -6.8 / 6.9 · 43 % / 2 % (90) |
| Catalonia | 10 | 810 | +1.9 / 3.0 · 19 % / 96 % (26) | +2.3 / 2.9 · 31 % / 93 % (26) | +1.7 / 2.4 · 31 % / 86 % (26) | +1.4 / 2.3 · 15 % / 92 % (26) | +1.1 / 2.2 · 15 % / 91 % (26) |
| Valencia/Murcia | 1 | 84 | -2.4 / 2.5 · 17 % / 0 % (29) | -2.4 / 2.5 · 10 % / 0 % (29) | -1.7 / 1.9 · 41 % / 0 % (29) | -1.8 / 2.0 · 41 % / 0 % (29) | -1.1 / 1.5 · 55 % / 0 % (29) |
| Andalusia/Tarifa (weak) | 5 | 311 | -2.5 / 3.3 · 26 % / 50 % (23) | -2.7 / 3.3 · 13 % / 25 % (23) | -2.1 / 2.9 · 30 % / 46 % (23) | -2.4 / 3.0 · 26 % / 45 % (23) | -2.0 / 2.9 · 35 % / 50 % (23) |
| Canaries (weak) | 1 | 83 | -2.5 / 3.2 · 82 % / 0 % (68) | -12.0 / 12.0 · 13 % / 0 % (68) | -7.2 / 7.2 · 40 % / 0 % (68) | -2.0 / 2.9 · 82 % / 0 % (68) | -9.7 / 9.7 · 16 % / 0 % (68) |
| Catalonia (weak) | 19 | 1537 | +1.9 / 2.7 · 56 % / 84 % (57) | +2.4 / 3.0 · 81 % / 81 % (57) | +1.5 / 2.3 · 63 % / 74 % (57) | +1.6 / 2.4 · 63 % / 75 % (57) | +1.0 / 2.1 · 54 % / 65 % (57) |
| Galicia/Cantabrian (weak) | 4 | 335 | -1.1 / 3.2 · 48 % / 42 % (46) | -1.2 / 2.2 · 54 % / 29 % (46) | -1.6 / 2.5 · 41 % / 21 % (46) | -1.1 / 1.9 · 57 % / 37 % (46) | -1.2 / 2.2 · 54 % / 29 % (46) |
| Valencia/Murcia (weak) | 2 | 167 | +0.8 / 2.7 · 37 % / 65 % (19) | +0.9 / 2.0 · 58 % / 54 % (19) | +0.5 / 2.2 · 32 % / 68 % (19) | +1.0 / 2.3 · 63 % / 56 % (19) | +0.7 / 2.3 · 42 % / 65 % (19) |

## Where to read AROME: beach, 500 m, 1 km, sea cell (day before, main stations)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| AROME 1.3 beach cell | 810 | +2.3 (+1.9 … +2.6) | 2.9 (2.6–3.2) | 26 | 31 % (7–58) | 93 % (87–99) | +1.8 | 2.6 | 19.4° |
| AROME 1.3 nearest cell at the pin | 810 | +2.3 (+1.9 … +2.6) | 2.9 (2.6–3.2) | 26 | 31 % (7–58) | 93 % (87–99) | +1.8 | 2.6 | 19.4° |
| AROME 1.3 at 500 m out | 810 | +3.3 (+2.9 … +3.7) | 3.8 (3.4–4.1) | 26 | 54 % (30–80) | 93 % (87–97) | +2.4 | 3.2 | 19.6° |
| AROME 1.3 at 1 km out | 810 | +4.2 (+3.6 … +4.6) | 4.5 (4.0–4.9) | 26 | 73 % (50–92) | 92 % (87–97) | +3.0 | 3.6 | 19.6° |
| AROME 1.3 sea cell | 810 | +4.2 (+3.7 … +4.7) | 4.5 (4.0–4.9) | 26 | 85 % (61–100) | 91 % (86–97) | +3.0 | 3.6 | 19.7° |

Difference with **AROME 1.3 beach cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- AROME 1.3 nearest cell at the pin: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- AROME 1.3 at 500 m out: error (+0.8 … +1.0), caught (+11 … +37) pts, false alarms (-4 … +2) pts
- AROME 1.3 at 1 km out: error (+1.4 … +1.8), caught (+19 … +65) pts, false alarms (-6 … +3) pts
- AROME 1.3 sea cell: error (+1.4 … +1.8), caught (+25 … +80) pts, false alarms (-7 … +2) pts

## Weights fitted for setup 5 (AROME 1.3 / ICON / ECMWF, day before)

- Andalusia/Tarifa, weeks odd trained on the others: 0.0 / 0.5 / 0.5
- Andalusia/Tarifa, weeks even trained on the others: 0.1 / 0.4 / 0.5
- Canaries, weeks odd trained on the others: 0.0 / 0.7 / 0.3
- Canaries, weeks even trained on the others: 0.1 / 0.7 / 0.2
- Catalonia, weeks odd trained on the others: 0.4 / 0.6 / 0.0
- Catalonia, weeks even trained on the others: 0.3 / 0.7 / 0.0
- Galicia/Cantabrian, weeks odd trained on the others: 1.0 / 0.0 / 0.0
- Galicia/Cantabrian, weeks even trained on the others: 1.0 / 0.0 / 0.0
- Valencia/Murcia, weeks odd trained on the others: 0.4 / 0.1 / 0.5
- Valencia/Murcia, weeks even trained on the others: 0.2 / 0.2 / 0.6

## Robustness: drop one main station at a time (day before, change Option 1 vs Baseline)

- without 08433: best 2 h error 3.25 → 3.15 (opt 1) / 3.28 (sea capped); caught 58 % → 42 % / 24 %; false 57 % → 48 % / 63 %
- without 08452: best 2 h error 3.20 → 3.09 (opt 1) / 3.21 (sea capped); caught 54 % → 43 % / 26 %; false 56 % → 45 % / 58 %
- without 08458: best 2 h error 3.22 → 2.96 (opt 1) / 3.14 (sea capped); caught 50 % → 41 % / 24 %; false 56 % → 44 % / 56 %
- without 08488: best 2 h error 3.18 → 3.07 (opt 1) / 3.17 (sea capped); caught 50 % → 41 % / 25 %; false 56 % → 44 % / 56 %
- without DK: best 2 h error 3.48 → 3.37 (opt 1) / 3.53 (sea capped); caught 57 % → 45 % / 30 %; false 56 % → 43 % / 56 %
- without DL: best 2 h error 3.16 → 3.05 (opt 1) / 3.20 (sea capped); caught 51 % → 43 % / 27 %; false 53 % → 36 % / 50 %
- without DO: best 2 h error 3.22 → 3.15 (opt 1) / 3.24 (sea capped); caught 51 % → 42 % / 26 %; false 53 % → 42 % / 53 %
- without GCLP: best 2 h error 3.05 → 2.63 (opt 1) / 2.61 (sea capped); caught 27 % → 38 % / 36 %; false 80 % → 59 % / 61 %
- without GCRR: best 2 h error 3.16 → 3.05 (opt 1) / 3.13 (sea capped); caught 56 % → 46 % / 29 %; false 56 % → 43 % / 56 %
- without LERT: best 2 h error 3.25 → 3.12 (opt 1) / 3.27 (sea capped); caught 50 % → 41 % / 23 %; false 58 % → 46 % / 62 %
- without U2: best 2 h error 2.97 → 3.08 (opt 1) / 3.25 (sea capped); caught 50 % → 41 % / 25 %; false 41 % → 40 % / 54 %
- without U6: best 2 h error 3.22 → 3.05 (opt 1) / 3.15 (sea capped); caught 51 % → 42 % / 26 %; false 56 % → 43 % / 54 %
- without WT: best 2 h error 3.25 → 3.13 (opt 1) / 3.29 (sea capped); caught 51 % → 42 % / 26 %; false 53 % → 39 % / 54 %
- without WZ: best 2 h error 3.26 → 3.07 (opt 1) / 3.24 (sea capped); caught 51 % → 42 % / 26 %; false 56 % → 43 % / 56 %
- without YR: best 2 h error 3.32 → 3.18 (opt 1) / 3.32 (sea capped); caught 51 % → 42 % / 26 %; false 55 % → 43 % / 56 %

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
