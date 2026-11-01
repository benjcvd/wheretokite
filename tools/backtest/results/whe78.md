# WHE-78: AROME 1.3 first, then best match, 2026-08-08 … 2026-10-30

## Where the change does anything: share of day-1 daylight hours where best match (sea cell) already equals AROME 1.3 (sea cell)

| Region | Spots | Already AROME 1.3 (median share) | Spots by share |
|---|---|---|---|
| Brittany | 2 | 100 % | Le Conquet – Blancs Sablons 100 %, Lampaul-Ploudalmézeau – Trois Moutons 100 % |
| Catalonia | 10 | 2 % | Cambrils (Platja del Regueral) 1 %, Altafulla 2 %, Segur de Calafell 2 %, Malgrat de Mar – La Pomareda 2 %, Vilanova i la Geltrú (La Farola) 2 %, Platja d'Aro 2 %, Riumar (Ebro delta) 2 %, Torredembarra 2 %, Creixell 2 %, Sant Pere Pescador 100 % |
| Channel | 5 | 1 % | Gouville-sur-Mer 1 %, Utah Beach 1 %, Cayeux-sur-Mer – La Mollière 1 %, Le Touquet 2 %, Les Hemmes de Marck 2 % |
| French Atlantic | 4 | 2 % | Biscarrosse-Plage 1 %, Bassin d'Arcachon – Les Arbousiers 2 %, Oléron – Plage des Huttes 2 %, Hendaye 2 % |
| Languedoc/Roussillon | 3 | 2 % | Le Grau-du-Roi – L'Espiguette 2 %, Port-Camargue – Plage Sud 2 %, Carnon – Petit Travers 2 % |
| Provence/Corsica | 5 | 2 % | Carro 1 %, Marignane – Le Jaï 1 %, Figari – Baie de Figari 2 %, Hyères – L'Almanarre 100 %, Hyères – Le Mérou 100 % |

## Shore stations, day 0 ahead

### All main stations in AROME's domain

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2487 | +0.7 (+0.5 … +0.9) | 2.7 (2.5–2.9) | 580 | 70 % (64–75) | 35 % (30–39) | +0.7 | 2.6 | 14.9° |
| 2 AROME first, sea cell | 2487 | +2.8 (+2.5 … +3.0) | 3.5 (3.2–3.7) | 580 | 88 % (85–91) | 49 % (45–53) | +2.0 | 3.1 | 13.9° |
| 3 AROME first, beach cell | 2487 | +1.2 (+1.1 … +1.4) | 2.5 (2.4–2.7) | 580 | 78 % (74–82) | 38 % (33–42) | +1.0 | 2.5 | 14.0° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 2487 | +0.3 (+0.1 … +0.4) | 2.2 (2.0–2.3) | 580 | 67 % (62–73) | 28 % (23–32) | +0.7 | 2.2 | 13.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.6 … +0.9), caught (+14 … +23) pts, false alarms (+11 … +17) pts
- 3 AROME first, beach cell: error (-0.3 … -0.1), caught (+5 … +12) pts, false alarms (+0 … +5) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.6 … -0.4), caught (-6 … +1) pts, false alarms (-10 … -4) pts

### Only spots where best match is not AROME 1.3 (24 spots)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1987 | +0.5 (+0.3 … +0.7) | 2.6 (2.4–2.7) | 427 | 67 % (61–74) | 33 % (28–39) | +0.6 | 2.5 | 15.6° |
| 2 AROME first, sea cell | 1987 | +2.9 (+2.7 … +3.2) | 3.4 (3.1–3.6) | 427 | 93 % (90–96) | 50 % (45–54) | +2.1 | 3.0 | 13.6° |
| 3 AROME first, beach cell | 1987 | +1.3 (+1.2 … +1.5) | 2.3 (2.2–2.4) | 427 | 83 % (78–87) | 36 % (31–40) | +1.0 | 2.3 | 13.6° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 1987 | +0.4 (+0.2 … +0.5) | 2.1 (1.9–2.2) | 427 | 69 % (64–75) | 28 % (23–33) | +0.8 | 2.1 | 13.2° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.7 … +0.9), caught (+20 … +32) pts, false alarms (+13 … +21) pts
- 3 AROME first, beach cell: error (-0.4 … -0.2), caught (+11 … +22) pts, false alarms (-2 … +6) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … -0.4), caught (-1 … +6) pts, false alarms (-9 … -2) pts

## Shore stations, day 1 ahead

### All main stations in AROME's domain

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2487 | +0.7 (+0.5 … +0.9) | 2.9 (2.7–3.1) | 580 | 66 % (61–71) | 38 % (33–43) | +0.7 | 2.9 | 18.2° |
| 2 AROME first, sea cell | 2487 | +2.5 (+2.3 … +2.7) | 3.5 (3.2–3.7) | 580 | 84 % (81–87) | 50 % (45–53) | +1.9 | 3.2 | 18.1° |
| 3 AROME first, beach cell | 2487 | +1.0 (+0.9 … +1.2) | 2.7 (2.5–2.8) | 580 | 72 % (67–77) | 40 % (35–44) | +0.9 | 2.7 | 18.3° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 2487 | +0.1 (-0.0 … +0.3) | 2.3 (2.1–2.4) | 580 | 66 % (59–71) | 26 % (21–31) | +0.7 | 2.3 | 15.9° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.4 … +0.7), caught (+15 … +22) pts, false alarms (+8 … +14) pts
- 3 AROME first, beach cell: error (-0.3 … -0.2), caught (+2 … +10) pts, false alarms (-1 … +5) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.7 … -0.6), caught (-4 … +3) pts, false alarms (-16 … -9) pts

### Only spots where best match is not AROME 1.3 (24 spots)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1987 | +0.4 (+0.2 … +0.6) | 2.6 (2.5–2.8) | 427 | 65 % (58–71) | 34 % (28–40) | +0.5 | 2.7 | 18.2° |
| 2 AROME first, sea cell | 1987 | +2.7 (+2.4 … +2.9) | 3.3 (3.1–3.6) | 427 | 89 % (86–92) | 50 % (45–54) | +2.0 | 3.2 | 18.0° |
| 3 AROME first, beach cell | 1987 | +1.1 (+0.9 … +1.2) | 2.4 (2.3–2.6) | 427 | 77 % (71–82) | 38 % (32–43) | +0.9 | 2.5 | 18.2° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 1987 | +0.2 (+0.0 … +0.3) | 2.2 (2.0–2.3) | 427 | 67 % (60–73) | 26 % (21–32) | +0.7 | 2.3 | 15.7° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.5 … +0.8), caught (+20 … +30) pts, false alarms (+12 … +20) pts
- 3 AROME first, beach cell: error (-0.3 … -0.1), caught (+7 … +16) pts, false alarms (-0 … +8) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … -0.4), caught (-1 … +6) pts, false alarms (-12 … -4) pts

## Shore stations, day 2 ahead

### All main stations in AROME's domain

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2487 | +0.6 (+0.4 … +0.8) | 2.9 (2.7–3.1) | 580 | 66 % (60–71) | 36 % (30–41) | +0.7 | 3.0 | 20.7° |
| 2 AROME first, sea cell | 2487 | +0.6 (+0.4 … +0.8) | 2.9 (2.7–3.1) | 580 | 66 % (60–71) | 36 % (30–41) | +0.7 | 3.0 | 20.7° |
| 3 AROME first, beach cell | 2487 | +0.6 (+0.4 … +0.8) | 2.9 (2.7–3.1) | 580 | 66 % (60–71) | 36 % (30–41) | +0.7 | 3.0 | 20.7° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 2487 | -0.2 (-0.4 … +0.0) | 2.5 (2.3–2.7) | 580 | 60 % (53–66) | 28 % (22–33) | +0.5 | 2.5 | 18.4° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … -0.3), caught (-10 … -3) pts, false alarms (-12 … -5) pts

### Only spots where best match is not AROME 1.3 (24 spots)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1987 | +0.3 (+0.0 … +0.5) | 2.6 (2.4–2.8) | 427 | 67 % (60–73) | 32 % (26–37) | +0.4 | 2.7 | 20.5° |
| 2 AROME first, sea cell | 1987 | +0.3 (+0.0 … +0.5) | 2.6 (2.4–2.8) | 427 | 67 % (60–73) | 32 % (26–37) | +0.4 | 2.7 | 20.5° |
| 3 AROME first, beach cell | 1987 | +0.3 (+0.0 … +0.5) | 2.6 (2.4–2.8) | 427 | 67 % (60–73) | 32 % (26–37) | +0.4 | 2.7 | 20.5° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 1987 | -0.1 (-0.3 … +0.1) | 2.4 (2.3–2.6) | 427 | 61 % (53–68) | 29 % (23–35) | +0.5 | 2.5 | 18.3° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.2 … -0.1), caught (-9 … -2) pts, false alarms (-7 … +1) pts

## Shore stations, day 3 ahead

### All main stations in AROME's domain

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 2487 | +0.6 (+0.3 … +0.8) | 3.0 (2.8–3.2) | 580 | 63 % (56–68) | 37 % (32–43) | +0.6 | 3.1 | 23.5° |
| 2 AROME first, sea cell | 2487 | +0.6 (+0.3 … +0.8) | 3.0 (2.8–3.2) | 580 | 63 % (56–68) | 37 % (32–43) | +0.6 | 3.1 | 23.5° |
| 3 AROME first, beach cell | 2487 | +0.6 (+0.3 … +0.8) | 3.0 (2.8–3.2) | 580 | 63 % (56–68) | 37 % (32–43) | +0.6 | 3.1 | 23.5° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 2487 | -0.3 (-0.5 … -0.1) | 2.6 (2.4–2.8) | 580 | 55 % (48–61) | 31 % (25–37) | +0.3 | 2.6 | 20.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … -0.3), caught (-11 … -4) pts, false alarms (-10 … -3) pts

### Only spots where best match is not AROME 1.3 (24 spots)

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 1987 | +0.2 (-0.1 … +0.4) | 2.7 (2.6–2.9) | 427 | 61 % (53–67) | 33 % (27–40) | +0.3 | 2.8 | 23.0° |
| 2 AROME first, sea cell | 1987 | +0.2 (-0.1 … +0.4) | 2.7 (2.6–2.9) | 427 | 61 % (53–67) | 33 % (27–40) | +0.3 | 2.8 | 23.0° |
| 3 AROME first, beach cell | 1987 | +0.2 (-0.1 … +0.4) | 2.7 (2.6–2.9) | 427 | 61 % (53–67) | 33 % (27–40) | +0.3 | 2.8 | 23.0° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 1987 | -0.2 (-0.4 … -0.0) | 2.6 (2.4–2.7) | 427 | 56 % (48–63) | 31 % (24–37) | +0.4 | 2.6 | 20.4° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.3 … -0.1), caught (-8 … -1) pts, false alarms (-7 … +2) pts

## Per region, day 1 ahead (best 2 h bias / error · go days caught / false)

| Region | Spots | Days | 1 Baseline | 2 AROME first, sea cell | 3 AROME first, beach cell | 4 Option 1 |
|---|---|---|---|---|---|---|
| Brittany | 2 | 168 | +1.2 / 3.6 · 76 % / 31 % (62) | +1.2 / 3.6 · 76 % / 31 % (62) | -0.3 / 3.7 · 63 % / 33 % (62) | -0.9 / 3.2 · 68 % / 22 % (62) |
| Catalonia | 10 | 810 | +1.9 / 3.0 · 19 % / 96 % (26) | +4.2 / 4.5 · 85 % / 91 % (26) | +2.3 / 2.9 · 31 % / 93 % (26) | +1.7 / 2.4 · 31 % / 86 % (26) |
| Channel | 5 | 420 | +1.0 / 3.2 · 78 % / 30 % (147) | +2.7 / 3.4 · 96 % / 33 % (147) | +0.8 / 2.3 · 87 % / 22 % (147) | -0.3 / 2.1 · 82 % / 16 % (147) |
| French Atlantic | 4 | 335 | -1.1 / 2.5 · 45 % / 25 % (87) | +0.9 / 2.4 · 78 % / 41 % (87) | -0.5 / 2.3 · 53 % / 31 % (87) | -1.0 / 2.2 · 47 % / 21 % (87) |
| Languedoc/Roussillon | 3 | 252 | +0.4 / 2.3 · 80 % / 28 % (49) | +2.8 / 3.1 · 92 % / 58 % (49) | +2.1 / 2.6 · 90 % / 52 % (49) | +0.1 / 1.8 · 73 % / 27 % (49) |
| Provence/Corsica | 5 | 418 | +0.2 / 2.9 · 75 % / 20 % (180) | +1.7 / 2.8 · 89 % / 25 % (180) | +0.7 / 2.5 · 82 % / 21 % (180) | -0.7 / 2.4 · 67 % / 17 % (180) |
| Valencia/Murcia | 1 | 84 | -2.4 / 2.5 · 17 % / 0 % (29) | -2.4 / 2.5 · 17 % / 0 % (29) | -2.4 / 2.5 · 17 % / 0 % (29) | -1.7 / 1.9 · 41 % / 0 % (29) |

## Robustness: drop one station at a time (day 1, only spots where the change does something)

- without 13054001: best 2 h error 2.67 → 3.39, bias +0.47 → +2.72; caught 64 % → 89 %; false 36 % → 52 %
- without 13056002: best 2 h error 2.65 → 3.37, bias +0.45 → +2.69; caught 64 % → 90 %; false 35 % → 51 %
- without 17323001: best 2 h error 2.67 → 3.41, bias +0.48 → +2.77; caught 64 % → 89 %; false 35 % → 51 %
- without 30133005: best 2 h error 2.68 → 3.33, bias +0.33 → +2.59; caught 63 % → 89 %; false 35 % → 49 %
- without 33236002: best 2 h error 2.67 → 3.41, bias +0.48 → +2.74; caught 66 % → 90 %; false 34 % → 51 %
- without 34154001: best 2 h error 2.66 → 3.40, bias +0.47 → +2.70; caught 65 % → 89 %; false 34 % → 50 %
- without 40046001: best 2 h error 2.60 → 3.39, bias +0.56 → +2.78; caught 69 % → 91 %; false 34 % → 51 %
- without 50215002: best 2 h error 2.59 → 3.40, bias +0.58 → +2.73; caught 66 % → 88 %; false 36 % → 53 %
- without 50509002: best 2 h error 2.66 → 3.37, bias +0.34 → +2.65; caught 64 % → 89 %; false 34 % → 50 %
- without 62548002: best 2 h error 2.67 → 3.40, bias +0.42 → +2.74; caught 64 % → 89 %; false 35 % → 51 %
- without 62826001: best 2 h error 2.54 → 3.25, bias +0.23 → +2.54; caught 62 % → 88 %; false 33 % → 50 %
- without 80182003: best 2 h error 2.63 → 3.33, bias +0.30 → +2.61; caught 63 % → 88 %; false 34 % → 51 %
- without DK: best 2 h error 2.74 → 3.45, bias +0.53 → +2.74; caught 68 % → 90 %; false 33 % → 49 %
- without DL: best 2 h error 2.58 → 3.25, bias +0.26 → +2.54; caught 65 % → 89 %; false 31 % → 48 %
- without DO: best 2 h error 2.63 → 3.26, bias +0.31 → +2.54; caught 65 % → 89 %; false 32 % → 48 %
- without LESO: best 2 h error 2.66 → 3.35, bias +0.35 → +2.64; caught 65 % → 89 %; false 33 % → 49 %
- without LFKF: best 2 h error 2.62 → 3.40, bias +0.53 → +2.76; caught 65 % → 89 %; false 36 % → 52 %
- without U6: best 2 h error 2.63 → 3.22, bias +0.29 → +2.50; caught 65 % → 89 %; false 34 % → 49 %
- without WT: best 2 h error 2.65 → 3.32, bias +0.35 → +2.60; caught 65 % → 89 %; false 32 % → 48 %
- without WZ: best 2 h error 2.65 → 3.27, bias +0.32 → +2.55; caught 65 % → 89 %; false 34 % → 49 %
- without YR: best 2 h error 2.69 → 3.36, bias +0.38 → +2.65; caught 65 % → 89 %; false 33 % → 49 %

## Buoy: POEM buoy, 2.3 km off Canet-en-Roussillon (CNRS) (read at Saint-Cyprien / Canet – Pont des Basses, Torreilles – Le Blockhaus, 7.2 km)

### Day 0 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 146 | -2.3 (-2.9 … -1.7) | 3.1 (2.6–3.5) | 72 | 56 % (42–69) | 11 % (2–22) | -2.3 | 3.3 | 16.4° |
| 2 AROME first, sea cell | 146 | -0.7 (-1.4 … -0.1) | 2.7 (2.3–3.1) | 72 | 76 % (65–86) | 18 % (8–30) | -1.2 | 3.0 | 16.5° |
| 3 AROME first, beach cell | 146 | -2.4 (-3.1 … -1.8) | 3.3 (2.8–3.8) | 72 | 58 % (46–70) | 11 % (2–22) | -2.4 | 3.4 | 16.9° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 146 | -3.9 (-4.5 … -3.3) | 4.0 (3.5–4.6) | 72 | 40 % (26–54) | 15 % (0–32) | -2.5 | 3.3 | 16.2° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (-0.7 … -0.1), caught (+11 … +32) pts, false alarms (-1 … +16) pts
- 3 AROME first, beach cell: error (+0.0 … +0.5), caught (-4 … +10) pts, false alarms (-8 … +8) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (+0.6 … +1.4), caught (-24 … -6) pts, false alarms (-7 … +15) pts

### Day 1 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 146 | -0.4 (-1.5 … +0.6) | 3.5 (2.9–4.2) | 72 | 71 % (58–83) | 20 % (9–33) | -0.9 | 3.4 | 22.0° |
| 2 AROME first, sea cell | 146 | -0.4 (-1.5 … +0.6) | 3.5 (2.9–4.2) | 72 | 71 % (58–83) | 20 % (9–33) | -0.9 | 3.4 | 22.0° |
| 3 AROME first, beach cell | 146 | -2.1 (-3.1 … -1.1) | 3.8 (3.1–4.4) | 72 | 62 % (50–75) | 18 % (7–31) | -2.1 | 3.7 | 21.6° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 146 | -3.8 (-4.5 … -3.0) | 4.1 (3.4–4.7) | 72 | 42 % (29–57) | 12 % (0–27) | -2.4 | 3.4 | 19.8° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (-0.1 … +0.6), caught (-14 … -3) pts, false alarms (-6 … +2) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.2 … +1.3), caught (-40 … -17) pts, false alarms (-19 … +1) pts

### Day 2 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 146 | -1.1 (-1.8 … -0.3) | 3.0 (2.5–3.4) | 72 | 56 % (40–71) | 17 % (5–32) | -0.8 | 3.3 | 25.9° |
| 2 AROME first, sea cell | 146 | -1.1 (-1.8 … -0.3) | 3.0 (2.5–3.4) | 72 | 56 % (40–71) | 17 % (5–32) | -0.8 | 3.3 | 25.9° |
| 3 AROME first, beach cell | 146 | -1.1 (-1.8 … -0.3) | 3.0 (2.5–3.4) | 72 | 56 % (40–71) | 17 % (5–32) | -0.8 | 3.3 | 25.9° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 146 | -4.1 (-4.8 … -3.4) | 4.4 (3.8–5.0) | 72 | 31 % (19–45) | 12 % (0–29) | -2.7 | 3.7 | 23.3° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (+0.8 … +1.9), caught (-38 … -14) pts, false alarms (-27 … +14) pts

### Day 3 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 146 | -1.4 (-2.2 … -0.4) | 3.3 (2.7–3.9) | 72 | 57 % (43–71) | 18 % (6–33) | -1.2 | 3.5 | 30.4° |
| 2 AROME first, sea cell | 146 | -1.4 (-2.2 … -0.4) | 3.3 (2.7–3.9) | 72 | 57 % (43–71) | 18 % (6–33) | -1.2 | 3.5 | 30.4° |
| 3 AROME first, beach cell | 146 | -1.4 (-2.2 … -0.4) | 3.3 (2.7–3.9) | 72 | 57 % (43–71) | 18 % (6–33) | -1.2 | 3.5 | 30.4° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 146 | -4.3 (-5.1 … -3.5) | 4.4 (3.7–5.2) | 72 | 25 % (12–38) | 10 % (0–30) | -2.8 | 3.8 | 25.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (+0.5 … +1.9), caught (-46 … -18) pts, false alarms (-26 … +8) pts

Best match already equals AROME 1.3 here on 100 % of day-1 hours.

## Buoy: Cabo Begur buoy, 25 km off Begur (Puertos del Estado) (read at Cabo Begur buoy, 25 km off Begur (Puertos del Estado), 0.0 km)

### Day 0 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 84 | -0.1 (-0.6 … +0.5) | 1.7 (1.4–2.1) | 51 | 82 % (71–93) | 9 % (2–18) | +0.2 | 2.0 | 14.3° |
| 2 AROME first, sea cell | 84 | +1.2 (+0.7 … +1.7) | 1.9 (1.6–2.3) | 51 | 98 % (93–100) | 17 % (7–27) | +0.9 | 2.2 | 13.3° |
| 3 AROME first, beach cell | 84 | +1.2 (+0.7 … +1.7) | 1.9 (1.6–2.3) | 51 | 98 % (93–100) | 17 % (7–27) | +0.9 | 2.2 | 13.3° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 84 | +0.2 (-0.3 … +0.7) | 1.4 (1.1–1.7) | 51 | 90 % (81–98) | 8 % (2–17) | +0.6 | 1.8 | 11.8° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (-0.2 … +0.6), caught (+5 … +26) pts, false alarms (+1 … +17) pts
- 3 AROME first, beach cell: error (-0.2 … +0.6), caught (+5 … +26) pts, false alarms (+1 … +17) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.6 … -0.1), caught (+0 … +17) pts, false alarms (-7 … +5) pts

### Day 1 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 84 | -0.2 (-0.9 … +0.5) | 2.3 (1.9–2.8) | 51 | 75 % (64–85) | 12 % (3–22) | +0.2 | 2.6 | 17.3° |
| 2 AROME first, sea cell | 84 | +1.1 (+0.4 … +1.8) | 2.5 (1.9–3.0) | 51 | 88 % (79–96) | 15 % (6–27) | +1.1 | 2.9 | 16.3° |
| 3 AROME first, beach cell | 84 | +1.1 (+0.4 … +1.8) | 2.5 (1.9–3.0) | 51 | 88 % (79–96) | 15 % (6–27) | +1.1 | 2.9 | 16.3° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 84 | -0.1 (-0.7 … +0.5) | 1.9 (1.6–2.3) | 51 | 82 % (71–92) | 11 % (2–20) | +0.5 | 2.3 | 13.1° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (-0.4 … +0.7), caught (+2 … +25) pts, false alarms (-4 … +12) pts
- 3 AROME first, beach cell: error (-0.4 … +0.7), caught (+2 … +25) pts, false alarms (-4 … +12) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.8 … -0.1), caught (+0 … +17) pts, false alarms (-9 … +7) pts

### Day 2 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 84 | -0.0 (-0.7 … +0.8) | 2.6 (2.1–3.1) | 51 | 76 % (65–89) | 15 % (5–27) | +0.4 | 3.1 | 17.8° |
| 2 AROME first, sea cell | 84 | -0.0 (-0.7 … +0.8) | 2.6 (2.1–3.1) | 51 | 76 % (65–89) | 15 % (5–27) | +0.4 | 3.1 | 17.8° |
| 3 AROME first, beach cell | 84 | -0.0 (-0.7 … +0.8) | 2.6 (2.1–3.1) | 51 | 76 % (65–89) | 15 % (5–27) | +0.4 | 3.1 | 17.8° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 84 | -0.5 (-1.1 … +0.3) | 2.3 (1.9–2.8) | 51 | 80 % (68–91) | 13 % (4–24) | +0.1 | 2.6 | 14.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.5 … +0.0), caught (-6 … +14) pts, false alarms (-10 … +3) pts

### Day 3 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 84 | +0.2 (-0.5 … +1.0) | 2.8 (2.4–3.3) | 51 | 76 % (65–88) | 20 % (9–33) | +0.5 | 3.8 | 20.1° |
| 2 AROME first, sea cell | 84 | +0.2 (-0.5 … +1.0) | 2.8 (2.4–3.3) | 51 | 76 % (65–88) | 20 % (9–33) | +0.5 | 3.8 | 20.1° |
| 3 AROME first, beach cell | 84 | +0.2 (-0.5 … +1.0) | 2.8 (2.4–3.3) | 51 | 76 % (65–88) | 20 % (9–33) | +0.5 | 3.8 | 20.1° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 84 | -0.6 (-1.2 … +0.0) | 2.3 (2.0–2.8) | 51 | 78 % (67–89) | 9 % (2–20) | -0.0 | 3.0 | 17.2° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.8 … -0.1), caught (-10 … +13) pts, false alarms (-21 … -4) pts

Best match already equals AROME 1.3 here on 2 % of day-1 hours.

## Buoy: Tarragona buoy, 40 km off Tarragona (Puertos del Estado) (read at Tarragona buoy, 40 km off Tarragona (Puertos del Estado), 0.0 km)

### Day 0 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 83 | -0.3 (-0.8 … +0.1) | 1.8 (1.6–2.1) | 35 | 83 % (70–94) | 17 % (6–30) | +0.4 | 2.2 | 15.5° |
| 2 AROME first, sea cell | 83 | +1.1 (+0.6 … +1.5) | 1.8 (1.5–2.0) | 35 | 94 % (85–100) | 20 % (9–32) | +1.1 | 2.3 | 14.4° |
| 3 AROME first, beach cell | 83 | +1.1 (+0.6 … +1.5) | 1.8 (1.5–2.0) | 35 | 94 % (85–100) | 20 % (9–32) | +1.1 | 2.3 | 14.4° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 83 | -0.3 (-0.8 … +0.1) | 1.5 (1.2–1.8) | 35 | 86 % (73–97) | 9 % (0–21) | +0.6 | 1.9 | 12.9° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (-0.4 … +0.2), caught (+0 … +24) pts, false alarms (-8 … +13) pts
- 3 AROME first, beach cell: error (-0.4 … +0.2), caught (+0 … +24) pts, false alarms (-8 … +13) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.6 … -0.2), caught (-6 … +12) pts, false alarms (-18 … +3) pts

### Day 1 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 83 | -0.7 (-1.3 … -0.1) | 2.1 (1.7–2.4) | 35 | 80 % (66–91) | 3 % (0–12) | +0.0 | 2.7 | 21.0° |
| 2 AROME first, sea cell | 83 | +0.7 (+0.1 … +1.2) | 2.1 (1.7–2.5) | 35 | 89 % (79–97) | 18 % (6–32) | +0.9 | 2.7 | 22.0° |
| 3 AROME first, beach cell | 83 | +0.7 (+0.1 … +1.2) | 2.1 (1.7–2.5) | 35 | 89 % (79–97) | 18 % (6–32) | +0.9 | 2.7 | 22.0° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 83 | -0.6 (-1.1 … -0.2) | 1.7 (1.4–2.0) | 35 | 77 % (63–89) | 4 % (0–11) | +0.3 | 2.3 | 15.9° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (-0.5 … +0.5), caught (+0 … +19) pts, false alarms (+2 … +30) pts
- 3 AROME first, beach cell: error (-0.5 … +0.5), caught (+0 … +19) pts, false alarms (+2 … +30) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.6 … -0.1), caught (-9 … +0) pts, false alarms (-9 … +10) pts

### Day 2 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 83 | -0.6 (-1.3 … +0.0) | 2.4 (2.0–3.0) | 35 | 80 % (66–94) | 12 % (3–25) | +0.2 | 3.0 | 25.0° |
| 2 AROME first, sea cell | 83 | -0.6 (-1.3 … +0.0) | 2.4 (2.0–3.0) | 35 | 80 % (66–94) | 12 % (3–25) | +0.2 | 3.0 | 25.0° |
| 3 AROME first, beach cell | 83 | -0.6 (-1.3 … +0.0) | 2.4 (2.0–3.0) | 35 | 80 % (66–94) | 12 % (3–25) | +0.2 | 3.0 | 25.0° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 83 | -0.9 (-1.7 … -0.3) | 2.1 (1.7–2.7) | 35 | 83 % (69–94) | 6 % (0–16) | +0.2 | 2.7 | 20.6° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.6 … -0.0), caught (-9 … +16) pts, false alarms (-17 … +5) pts

### Day 3 ahead

| Setup | Days | Best 2 h bias | Best 2 h error | Go days | caught | false alarms | Hour bias | Hour error | Direction error |
|---|---|---|---|---|---|---|---|---|---|
| 1 Baseline: best match, sea cell | 83 | -0.2 (-0.9 … +0.7) | 3.0 (2.5–3.5) | 35 | 83 % (68–95) | 24 % (11–39) | +0.4 | 3.5 | 27.5° |
| 2 AROME first, sea cell | 83 | -0.2 (-0.9 … +0.7) | 3.0 (2.5–3.5) | 35 | 83 % (68–95) | 24 % (11–39) | +0.4 | 3.5 | 27.5° |
| 3 AROME first, beach cell | 83 | -0.2 (-0.9 … +0.7) | 3.0 (2.5–3.5) | 35 | 83 % (68–95) | 24 % (11–39) | +0.4 | 3.5 | 27.5° |
| 4 Option 1: AROME+ICON beach, ECMWF sea | 83 | -1.0 (-1.7 … -0.2) | 2.7 (2.3–3.2) | 35 | 80 % (65–91) | 20 % (8–35) | +0.1 | 3.0 | 23.3° |

Difference with **1 Baseline: best match, sea cell**, 95 % interval over days (best 2 h error kn, go days caught, false alarms):

- 2 AROME first, sea cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 3 AROME first, beach cell: error (+0.0 … +0.0), caught (+0 … +0) pts, false alarms (+0 … +0) pts
- 4 Option 1: AROME+ICON beach, ECMWF sea: error (-0.7 … +0.1), caught (-13 … +6) pts, false alarms (-14 … +5) pts

Best match already equals AROME 1.3 here on 1 % of day-1 hours.

