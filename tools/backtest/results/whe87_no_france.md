# WHE-87: best forecast source for each day ahead, 2026-08-08 … 2026-10-30

13 truth sites, 84 dates. Groups: Barcelona (airport, Bocana Sud) 2, Canaries 2, Mainland Spain (south masts) 5, Near-shore buoy (POEM) 2, Open-sea buoys (Begur, Tarragona) 2.

**Left out: France.**

Coverage = share of spot-days where the named source answered (else best match, sea cell).
Gains vs today = candidate minus today (best match, sea cell); 95 % interval over dates. MAE gain < 0 is better; caught/CSI gain > 0 better; false-go gain < 0 better.


## Day ahead 0 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + MF seamless, sea cell / MF seamless, sea cell + MF seamless, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| AROME HD, sea cell | 46 % | -0.8 | 2.4 | -0.2 (-0.2…-0.1) | 74 % | +16 (+12…+20) | 16 % | +2 (-1…+5) | 64.9 | +12 (+9…+16) |
| MF seamless, beach cell | 100 % | -0.7 | 2.4 | -0.2 (-0.3…-0.1) | 70 % | +12 (+8…+16) | 13 % | -1 (-5…+3) | 63.4 | +11 (+6…+15) |
| AROME 2.5, beach cell | 46 % | -1.1 | 2.4 | -0.2 (-0.2…-0.1) | 70 % | +12 (+9…+16) | 13 % | -1 (-4…+2) | 63.2 | +11 (+7…+14) |
| AROME 2.5, sea cell | 46 % | -1.1 | 2.4 | -0.2 (-0.2…-0.1) | 70 % | +12 (+9…+16) | 13 % | -1 (-4…+2) | 63.2 | +11 (+7…+14) |
| MF seamless, sea cell | 100 % | +0.1 | 2.2 | -0.4 (-0.5…-0.2) | 74 % | +17 (+13…+20) | 22 % | +9 (+5…+13) | 61.2 | +8 (+4…+13) |
| Mean of best two | 100 % | -0.5 | 2.1 | -0.5 (-0.6…-0.3) | 68 % | +10 (+7…+14) | 18 % | +4 (+0…+10) | 59.1 | +6 (+2…+10) |
| GFS, sea cell | 100 % | -0.3 | 2.7 | +0.1 (-0.1…+0.3) | 69 % | +11 (+5…+16) | 23 % | +9 (+5…+13) | 57.1 | +4 (-1…+9) |
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -1.0 | 2.3 | -0.3 (-0.4…-0.2) | 62 % | +5 (-1…+10) | 13 % | -1 (-5…+4) | 56.9 | +4 (-1…+9) |
| AROME HD, beach cell | 46 % | -1.3 | 2.5 | -0.1 (-0.1…+0.0) | 62 % | +5 (+2…+8) | 14 % | -0 (-3…+3) | 56.8 | +4 (+1…+7) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -1.1 | 2.2 | -0.3 (-0.5…-0.2) | 61 % | +3 (-2…+7) | 11 % | -3 (-7…+1) | 56.5 | +4 (-1…+8) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.8 | 2.4 | -0.2 (-0.4…-0.1) | 61 % | +4 (-2…+9) | 18 % | +4 (-0…+9) | 54.2 | +1 (-4…+6) |
| **best match, sea cell** (today) | 100 % | -1.5 | 2.6 |  | 58 % |  | 14 % |  | 52.7 |  |
| ICON-EU, sea cell | 88 % | -1.8 | 2.8 | +0.2 (+0.1…+0.3) | 54 % | -3 (-6…-1) | 13 % | -1 (-3…+1) | 50.3 | -2 (-5…-0) |
| GFS, beach cell | 100 % | -1.4 | 3.3 | +0.7 (+0.5…+0.9) | 57 % | -1 (-8…+5) | 18 % | +5 (+0…+9) | 50.3 | -2 (-9…+3) |
| ICON seamless, sea cell | 100 % | -1.8 | 2.8 | +0.2 (+0.1…+0.3) | 54 % | -4 (-6…-2) | 13 % | -1 (-3…+1) | 49.7 | -3 (-5…-1) |
| ECMWF 25 km, sea cell | 100 % | -1.4 | 3.0 | +0.4 (+0.3…+0.6) | 59 % | +2 (-4…+7) | 25 % | +11 (+6…+16) | 49.5 | -3 (-8…+2) |
| ECMWF 9 km, sea cell | 100 % | -0.9 | 2.4 | -0.2 (-0.3…-0.0) | 55 % | -3 (-8…+2) | 19 % | +6 (+0…+11) | 48.3 | -4 (-10…+0) |
| ICON-EU, beach cell | 88 % | -2.2 | 3.2 | +0.6 (+0.4…+0.7) | 46 % | -11 (-15…-8) | 10 % | -4 (-8…+0) | 44.0 | -9 (-13…-5) |
| Option 1 mix | 46 % | -2.1 | 3.0 | +0.4 (+0.3…+0.5) | 46 % | -11 (-16…-7) | 15 % | +1 (-2…+6) | 42.7 | -10 (-14…-6) |
| best match, beach cell | 100 % | -2.1 | 3.1 | +0.5 (+0.4…+0.6) | 45 % | -13 (-16…-9) | 12 % | -2 (-6…+1) | 42.5 | -10 (-14…-7) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.3 | +0.7 (+0.5…+0.9) | 44 % | -13 (-19…-8) | 13 % | -0 (-6…+5) | 41.3 | -11 (-17…-6) |
| ICON seamless, beach cell | 100 % | -2.5 | 3.5 | +0.9 (+0.7…+1.0) | 39 % | -19 (-23…-14) | 11 % | -2 (-7…+2) | 37.2 | -16 (-20…-11) |
| ECMWF 25 km, beach cell | 100 % | -3.3 | 4.2 | +1.6 (+1.4…+1.8) | 28 % | -29 (-34…-24) | 25 % | +11 (+5…+17) | 26.0 | -27 (-32…-22) |

## Day ahead 1 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / MF seamless, sea cell + ECMWF 9 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 100 % | +0.6 | 2.6 | -0.3 (-0.5…-0.1) | 75 % | +18 (+13…+22) | 26 % | +8 (+4…+12) | 59.7 | +9 (+4…+14) |
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -1.2 | 2.5 | -0.4 (-0.6…-0.3) | 61 % | +4 (-0…+9) | 10 % | -8 (-12…-3) | 57.4 | +6 (+2…+11) |
| Mean of best two | 100 % | -0.9 | 2.5 | -0.4 (-0.6…-0.3) | 65 % | +8 (+3…+13) | 18 % | -0 (-5…+4) | 57.1 | +6 (+1…+11) |
| MF seamless, beach cell | 100 % | -0.8 | 2.9 | -0.1 (-0.3…+0.0) | 63 % | +6 (+1…+10) | 16 % | -2 (-6…+3) | 56.1 | +5 (+0…+10) |
| AROME 2.5, beach cell | 46 % | -1.1 | 2.8 | -0.1 (-0.2…-0.1) | 64 % | +6 (+3…+9) | 19 % | +1 (-2…+4) | 55.3 | +4 (+1…+8) |
| AROME 2.5, sea cell | 46 % | -1.1 | 2.8 | -0.1 (-0.2…-0.1) | 64 % | +6 (+3…+9) | 19 % | +1 (-2…+4) | 55.3 | +4 (+1…+8) |
| AROME HD, sea cell | 46 % | -0.8 | 2.8 | -0.1 (-0.2…-0.1) | 65 % | +8 (+5…+12) | 22 % | +4 (+1…+7) | 55.3 | +4 (+1…+8) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -1.1 | 2.6 | -0.4 (-0.6…-0.2) | 61 % | +4 (-1…+9) | 16 % | -2 (-7…+3) | 54.7 | +4 (-1…+9) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -1.2 | 2.6 | -0.4 (-0.5…-0.2) | 58 % | +0 (-4…+5) | 12 % | -6 (-11…-1) | 53.3 | +2 (-2…+7) |
| GFS, sea cell | 100 % | -0.4 | 2.8 | -0.1 (-0.4…+0.1) | 65 % | +8 (+2…+14) | 26 % | +8 (+3…+13) | 52.9 | +2 (-4…+8) |
| AROME HD, beach cell | 46 % | -1.3 | 2.9 | -0.1 (-0.2…+0.0) | 58 % | +1 (-2…+4) | 19 % | +1 (-2…+5) | 51.0 | +0 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -1.4 | 3.0 |  | 57 % |  | 18 % |  | 50.9 |  |
| ECMWF 9 km, sea cell | 100 % | -1.2 | 2.7 | -0.3 (-0.5…-0.1) | 54 % | -3 (-7…+2) | 16 % | -2 (-7…+3) | 49.2 | -2 (-6…+3) |
| ECMWF 25 km, sea cell | 100 % | -1.6 | 3.2 | +0.3 (+0.1…+0.5) | 57 % | -1 (-7…+5) | 22 % | +4 (-2…+10) | 49.0 | -2 (-8…+4) |
| ICON seamless, sea cell | 100 % | -1.9 | 3.1 | +0.1 (-0.0…+0.2) | 52 % | -6 (-9…-3) | 16 % | -2 (-6…+1) | 47.1 | -4 (-7…-1) |
| ICON-EU, sea cell | 88 % | -1.9 | 3.1 | +0.1 (+0.0…+0.3) | 51 % | -6 (-9…-3) | 16 % | -2 (-6…+1) | 46.9 | -4 (-7…-1) |
| GFS, beach cell | 100 % | -1.6 | 3.5 | +0.5 (+0.3…+0.8) | 54 % | -4 (-10…+3) | 22 % | +4 (-1…+9) | 46.8 | -4 (-11…+2) |
| Option 1 mix | 46 % | -2.2 | 3.3 | +0.3 (+0.1…+0.5) | 46 % | -11 (-16…-7) | 15 % | -3 (-8…+2) | 42.8 | -8 (-13…-3) |
| ICON-EU, beach cell | 88 % | -2.3 | 3.3 | +0.4 (+0.2…+0.6) | 44 % | -13 (-17…-9) | 9 % | -9 (-14…-5) | 42.7 | -8 (-12…-4) |
| best match, beach cell | 100 % | -2.1 | 3.4 | +0.4 (+0.3…+0.5) | 44 % | -13 (-17…-11) | 14 % | -4 (-7…-0) | 40.9 | -10 (-13…-7) |
| ECMWF 9 km, beach cell | 100 % | -2.6 | 3.5 | +0.6 (+0.4…+0.8) | 42 % | -15 (-20…-10) | 8 % | -10 (-16…-4) | 40.8 | -10 (-16…-5) |
| ICON seamless, beach cell | 100 % | -2.6 | 3.7 | +0.7 (+0.5…+0.9) | 38 % | -20 (-24…-16) | 10 % | -8 (-13…-3) | 36.1 | -15 (-20…-10) |
| ECMWF 25 km, beach cell | 100 % | -3.4 | 4.4 | +1.4 (+1.2…+1.6) | 26 % | -31 (-37…-26) | 21 % | +3 (-3…+9) | 24.3 | -27 (-32…-22) |

## Day ahead 2 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / MF seamless, sea cell + ECMWF 9 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 99 % | +0.3 | 2.9 | -0.2 (-0.4…-0.0) | 71 % | +17 (+13…+22) | 25 % | +8 (+5…+12) | 57.6 | +9 (+5…+13) |
| MF seamless, beach cell | 99 % | -1.1 | 3.2 | +0.0 (-0.1…+0.2) | 59 % | +5 (+1…+10) | 15 % | -2 (-7…+3) | 53.8 | +5 (+0…+10) |
| Mean of best two | 99 % | -1.0 | 2.6 | -0.5 (-0.7…-0.3) | 59 % | +4 (-1…+10) | 17 % | +0 (-4…+4) | 52.4 | +4 (-2…+9) |
| GFS, sea cell | 100 % | -0.4 | 3.0 | -0.2 (-0.4…+0.0) | 64 % | +10 (+3…+16) | 26 % | +10 (+5…+15) | 51.8 | +3 (-2…+9) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -1.2 | 2.8 | -0.4 (-0.5…-0.2) | 57 % | +3 (-2…+9) | 19 % | +2 (-3…+7) | 50.7 | +2 (-3…+7) |
| Mix MF beach + ECMWF 9 km + GFS sea | 99 % | -1.4 | 2.7 | -0.4 (-0.6…-0.2) | 55 % | +1 (-5…+6) | 14 % | -3 (-7…+1) | 50.3 | +1 (-3…+6) |
| Mix MF beach + ECMWF 9 km sea | 99 % | -1.5 | 2.8 | -0.3 (-0.4…-0.2) | 53 % | -1 (-6…+4) | 12 % | -4 (-9…-0) | 49.4 | +1 (-4…+5) |
| **best match, sea cell** (today) | 100 % | -1.7 | 3.1 |  | 54 % |  | 17 % |  | 48.8 |  |
| AROME HD, beach cell | 0 % | -1.7 | 3.1 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 17 % | +0 (+0…+0) | 48.8 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.7 | 3.1 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 17 % | +0 (+0…+0) | 48.8 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.7 | 3.1 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 17 % | +0 (+0…+0) | 48.8 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.7 | 3.1 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 17 % | +0 (+0…+0) | 48.8 | +0 (+0…+0) |
| ECMWF 9 km, sea cell | 100 % | -1.4 | 2.8 | -0.3 (-0.5…-0.1) | 53 % | -1 (-6…+3) | 18 % | +2 (-4…+7) | 47.2 | -2 (-6…+3) |
| ICON seamless, sea cell | 100 % | -1.9 | 3.2 | +0.1 (-0.0…+0.2) | 51 % | -3 (-6…-0) | 16 % | -0 (-3…+2) | 46.5 | -2 (-5…+0) |
| ICON-EU, sea cell | 88 % | -1.9 | 3.2 | +0.1 (+0.0…+0.2) | 50 % | -4 (-6…-1) | 16 % | -0 (-3…+3) | 45.9 | -3 (-6…-0) |
| ECMWF 25 km, sea cell | 100 % | -1.6 | 3.3 | +0.2 (+0.0…+0.4) | 55 % | +1 (-4…+6) | 27 % | +10 (+4…+16) | 45.7 | -3 (-8…+2) |
| GFS, beach cell | 100 % | -1.7 | 3.7 | +0.5 (+0.3…+0.8) | 49 % | -5 (-12…+2) | 24 % | +7 (+2…+13) | 42.5 | -6 (-12…-0) |
| ICON-EU, beach cell | 88 % | -2.3 | 3.4 | +0.3 (+0.2…+0.4) | 44 % | -10 (-14…-6) | 12 % | -4 (-8…-1) | 41.3 | -7 (-11…-4) |
| Option 1 mix | 0 % | -2.4 | 3.5 | +0.3 (+0.2…+0.5) | 43 % | -11 (-16…-7) | 15 % | -1 (-7…+4) | 39.6 | -9 (-14…-5) |
| ECMWF 9 km, beach cell | 100 % | -2.7 | 3.7 | +0.5 (+0.4…+0.7) | 41 % | -13 (-18…-8) | 12 % | -4 (-10…+2) | 38.7 | -10 (-15…-5) |
| best match, beach cell | 100 % | -2.5 | 3.7 | +0.5 (+0.4…+0.6) | 39 % | -15 (-18…-11) | 15 % | -1 (-4…+2) | 36.5 | -12 (-16…-9) |
| ICON seamless, beach cell | 100 % | -2.6 | 3.7 | +0.6 (+0.5…+0.8) | 37 % | -17 (-21…-13) | 15 % | -2 (-6…+2) | 34.6 | -14 (-18…-10) |
| ECMWF 25 km, beach cell | 100 % | -3.4 | 4.5 | +1.4 (+1.1…+1.6) | 25 % | -29 (-35…-23) | 25 % | +8 (+1…+16) | 23.1 | -26 (-31…-20) |

## Day ahead 3 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / ECMWF 9 km, sea cell + MF seamless, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 97 % | +0.2 | 3.1 | -0.2 (-0.4…+0.1) | 67 % | +12 (+7…+17) | 28 % | +5 (+1…+10) | 52.8 | +6 (+1…+10) |
| MF seamless, beach cell | 97 % | -1.1 | 3.3 | +0.0 (-0.1…+0.2) | 56 % | +2 (-3…+7) | 21 % | -3 (-7…+2) | 49.2 | +2 (-2…+7) |
| Mean of best two | 97 % | -1.1 | 2.8 | -0.5 (-0.6…-0.3) | 56 % | +1 (-4…+7) | 21 % | -2 (-7…+2) | 48.8 | +2 (-3…+7) |
| Mix MF beach + ECMWF 9 km sea | 97 % | -1.5 | 3.0 | -0.3 (-0.4…-0.1) | 52 % | -3 (-8…+2) | 15 % | -8 (-12…-4) | 47.5 | +1 (-4…+5) |
| **best match, sea cell** (today) | 100 % | -1.6 | 3.3 |  | 55 % |  | 23 % |  | 46.9 |  |
| AROME HD, beach cell | 0 % | -1.6 | 3.3 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 23 % | +0 (+0…+0) | 46.9 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.6 | 3.3 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 23 % | +0 (+0…+0) | 46.9 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.6 | 3.3 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 23 % | +0 (+0…+0) | 46.9 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.6 | 3.3 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 23 % | +0 (+0…+0) | 46.9 | +0 (+0…+0) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -1.2 | 2.9 | -0.4 (-0.5…-0.2) | 53 % | -2 (-7…+3) | 21 % | -2 (-7…+4) | 46.2 | -1 (-6…+4) |
| Mix MF beach + ECMWF 9 km + GFS sea | 97 % | -1.4 | 2.9 | -0.4 (-0.5…-0.3) | 51 % | -4 (-9…+1) | 17 % | -6 (-11…-2) | 46.1 | -1 (-5…+3) |
| GFS, sea cell | 100 % | -0.4 | 3.2 | -0.1 (-0.3…+0.1) | 58 % | +3 (-2…+8) | 31 % | +8 (+2…+14) | 45.6 | -1 (-6…+4) |
| ICON seamless, sea cell | 100 % | -1.9 | 3.4 | +0.1 (+0.0…+0.2) | 52 % | -2 (-6…+1) | 23 % | -1 (-3…+1) | 45.3 | -2 (-5…+2) |
| ICON-EU, sea cell | 88 % | -1.9 | 3.4 | +0.1 (+0.0…+0.2) | 52 % | -2 (-6…+1) | 23 % | -1 (-3…+1) | 45.3 | -2 (-5…+1) |
| ECMWF 9 km, sea cell | 100 % | -1.4 | 3.0 | -0.3 (-0.5…-0.1) | 51 % | -4 (-8…+1) | 21 % | -2 (-7…+3) | 45.0 | -2 (-6…+2) |
| ECMWF 25 km, sea cell | 100 % | -1.8 | 3.6 | +0.3 (+0.2…+0.5) | 50 % | -5 (-12…+1) | 28 % | +5 (-1…+11) | 41.5 | -5 (-12…+0) |
| GFS, beach cell | 100 % | -1.7 | 3.8 | +0.5 (+0.3…+0.8) | 47 % | -7 (-14…-1) | 25 % | +2 (-5…+8) | 41.1 | -6 (-12…-0) |
| ICON-EU, beach cell | 88 % | -2.3 | 3.6 | +0.3 (+0.2…+0.5) | 44 % | -10 (-14…-6) | 19 % | -4 (-7…+0) | 40.2 | -7 (-10…-3) |
| ECMWF 9 km, beach cell | 100 % | -2.8 | 3.8 | +0.5 (+0.3…+0.7) | 40 % | -14 (-20…-9) | 14 % | -9 (-15…-3) | 37.8 | -9 (-14…-4) |
| Option 1 mix | 0 % | -2.5 | 3.6 | +0.3 (+0.2…+0.5) | 39 % | -16 (-21…-11) | 22 % | -1 (-6…+5) | 34.7 | -12 (-17…-8) |
| best match, beach cell | 100 % | -2.4 | 3.8 | +0.5 (+0.4…+0.7) | 37 % | -18 (-22…-14) | 23 % | -0 (-4…+4) | 33.3 | -14 (-17…-10) |
| ICON seamless, beach cell | 100 % | -2.6 | 3.9 | +0.6 (+0.5…+0.8) | 37 % | -18 (-22…-14) | 22 % | -1 (-5…+3) | 33.2 | -14 (-18…-10) |
| ECMWF 25 km, beach cell | 100 % | -3.6 | 4.6 | +1.3 (+1.1…+1.5) | 24 % | -30 (-36…-25) | 27 % | +4 (-4…+10) | 22.5 | -24 (-29…-20) |

## Day ahead 4 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / GFS, sea cell + ECMWF 9 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| ECMWF 9 km, sea cell | 100 % | -1.6 | 3.4 | -0.4 (-0.5…-0.2) | 50 % | +3 (-2…+8) | 26 % | -1 (-8…+5) | 43.0 | +3 (-2…+8) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -1.6 | 3.4 | -0.4 (-0.5…-0.2) | 50 % | +3 (-2…+8) | 26 % | -1 (-8…+5) | 43.0 | +3 (-2…+8) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -1.3 | 3.2 | -0.6 (-0.8…-0.4) | 48 % | +1 (-5…+6) | 24 % | -3 (-9…+4) | 42.0 | +2 (-4…+7) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -1.3 | 3.2 | -0.6 (-0.8…-0.4) | 48 % | +1 (-5…+6) | 24 % | -3 (-9…+4) | 42.0 | +2 (-4…+7) |
| Mean of best two | 100 % | -1.3 | 3.2 | -0.6 (-0.8…-0.4) | 48 % | +1 (-5…+6) | 24 % | -3 (-9…+4) | 42.0 | +2 (-4…+7) |
| GFS, sea cell | 100 % | -0.4 | 3.5 | -0.3 (-0.5…-0.1) | 55 % | +8 (+1…+13) | 36 % | +10 (+3…+16) | 41.9 | +2 (-3…+7) |
| ICON seamless, sea cell | 100 % | -1.9 | 3.7 | +0.0 (-0.1…+0.1) | 47 % | +0 (-3…+3) | 26 % | -1 (-3…+2) | 40.8 | +0 (-2…+3) |
| ICON-EU, sea cell | 88 % | -2.0 | 3.8 | +0.0 (-0.1…+0.1) | 47 % | +0 (-3…+3) | 26 % | -1 (-3…+2) | 40.8 | +0 (-2…+3) |
| **best match, sea cell** (today) | 100 % | -1.9 | 3.7 |  | 47 % |  | 27 % |  | 40.3 |  |
| MF seamless, beach cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.9 | 3.7 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.3 | +0 (+0…+0) |
| ECMWF 25 km, sea cell | 100 % | -1.9 | 3.9 | +0.2 (+0.0…+0.3) | 48 % | +1 (-6…+7) | 33 % | +7 (+1…+13) | 38.8 | -2 (-7…+4) |
| ICON-EU, beach cell | 88 % | -2.3 | 3.9 | +0.2 (+0.0…+0.3) | 42 % | -5 (-8…-2) | 21 % | -5 (-9…-2) | 38.1 | -2 (-5…+1) |
| GFS, beach cell | 100 % | -1.8 | 4.1 | +0.4 (+0.1…+0.6) | 44 % | -3 (-10…+3) | 29 % | +2 (-4…+9) | 37.5 | -3 (-9…+2) |
| ECMWF 9 km, beach cell | 100 % | -2.9 | 4.0 | +0.3 (+0.1…+0.4) | 38 % | -9 (-15…-4) | 20 % | -7 (-14…+0) | 34.7 | -6 (-11…-1) |
| ICON seamless, beach cell | 100 % | -2.7 | 4.2 | +0.5 (+0.4…+0.6) | 36 % | -12 (-16…-7) | 24 % | -3 (-7…+2) | 32.0 | -8 (-13…-4) |
| best match, beach cell | 100 % | -2.7 | 4.3 | +0.5 (+0.4…+0.7) | 33 % | -14 (-19…-10) | 25 % | -1 (-6…+4) | 29.6 | -11 (-15…-7) |
| Option 1 mix | 0 % | -2.5 | 3.9 | +0.2 (+0.0…+0.3) | 33 % | -14 (-19…-9) | 28 % | +2 (-5…+8) | 29.6 | -11 (-15…-6) |
| ECMWF 25 km, beach cell | 100 % | -3.5 | 4.8 | +1.0 (+0.9…+1.2) | 22 % | -25 (-30…-20) | 36 % | +9 (+1…+17) | 19.7 | -21 (-25…-16) |

## Day ahead 5 — 1025 spot-days, 84 dates, 335 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / GFS, sea cell + ECMWF 9 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix ECMWF 9 km + GFS, sea | 100 % | -1.2 | 3.4 | -0.5 (-0.7…-0.3) | 51 % | +4 (-1…+9) | 27 % | +0 (-5…+6) | 42.8 | +3 (-2…+7) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -1.2 | 3.4 | -0.5 (-0.7…-0.3) | 51 % | +4 (-1…+9) | 27 % | +0 (-5…+6) | 42.8 | +3 (-2…+7) |
| Mean of best two | 100 % | -1.2 | 3.4 | -0.5 (-0.7…-0.3) | 51 % | +4 (-1…+9) | 27 % | +0 (-5…+6) | 42.8 | +3 (-2…+7) |
| ECMWF 9 km, sea cell | 100 % | -1.4 | 3.6 | -0.3 (-0.5…-0.1) | 49 % | +2 (-2…+7) | 27 % | +0 (-5…+6) | 41.8 | +2 (-3…+6) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -1.4 | 3.6 | -0.3 (-0.5…-0.1) | 49 % | +2 (-2…+7) | 27 % | +0 (-5…+6) | 41.8 | +2 (-3…+6) |
| GFS, sea cell | 100 % | -0.6 | 3.6 | -0.3 (-0.5…-0.0) | 53 % | +7 (+1…+12) | 38 % | +11 (+5…+17) | 40.2 | +0 (-5…+5) |
| **best match, sea cell** (today) | 100 % | -1.9 | 3.9 |  | 47 % |  | 27 % |  | 40.1 |  |
| MF seamless, beach cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| ICON-EU, beach cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| ICON-EU, sea cell | 0 % | -1.9 | 3.9 | +0.0 (+0.0…+0.0) | 47 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 40.1 | +0 (+0…+0) |
| ICON seamless, sea cell | 100 % | -2.0 | 4.1 | +0.2 (+0.1…+0.3) | 46 % | -1 (-4…+3) | 28 % | +2 (-1…+4) | 38.9 | -1 (-4…+2) |
| ECMWF 25 km, sea cell | 100 % | -1.6 | 4.2 | +0.3 (+0.1…+0.5) | 46 % | -1 (-7…+5) | 34 % | +8 (+1…+15) | 37.0 | -3 (-9…+2) |
| GFS, beach cell | 100 % | -1.8 | 4.3 | +0.4 (+0.1…+0.7) | 43 % | -4 (-10…+1) | 33 % | +6 (-1…+13) | 35.4 | -5 (-10…+0) |
| ECMWF 9 km, beach cell | 100 % | -2.7 | 4.2 | +0.3 (+0.1…+0.6) | 38 % | -9 (-15…-4) | 20 % | -7 (-14…+0) | 34.4 | -6 (-11…-1) |
| best match, beach cell | 100 % | -2.8 | 4.5 | +0.6 (+0.5…+0.7) | 33 % | -13 (-18…-10) | 22 % | -4 (-9…+0) | 30.5 | -10 (-14…-6) |
| ICON seamless, beach cell | 100 % | -2.8 | 4.5 | +0.6 (+0.5…+0.8) | 33 % | -13 (-19…-9) | 24 % | -3 (-8…+2) | 30.3 | -10 (-15…-5) |
| Option 1 mix | 0 % | -2.5 | 4.1 | +0.3 (+0.1…+0.4) | 33 % | -14 (-19…-10) | 30 % | +3 (-2…+10) | 28.5 | -12 (-16…-7) |
| ECMWF 25 km, beach cell | 100 % | -3.3 | 4.9 | +1.1 (+0.8…+1.3) | 23 % | -24 (-29…-19) | 35 % | +8 (+0…+17) | 20.7 | -19 (-25…-14) |

## Summary: winner per day ahead

Winner = highest CSI among sources (and mixes) that answered themselves on ≥ 90 % of spot-days; 'real' when its CSI gain interval excludes 0.

| Day ahead | Today: CSI / MAE / bias | Best on CSI | CSI gain | MAE gain | Real? | Best on MAE | MAE gain |
|---|---|---|---|---|---|---|---|
| 0 | 53 / 2.6 / -1.5 | MF seamless, beach cell | +11 (+6…+15) | -0.2 | yes | Mean of best two | -0.5 (-0.6…-0.3) |
| 1 | 51 / 3.0 / -1.4 | MF seamless, sea cell | +9 (+4…+14) | -0.3 | yes | Mix MF beach + ECMWF 9 km + GFS sea | -0.4 (-0.6…-0.3) |
| 2 | 49 / 3.1 / -1.7 | MF seamless, sea cell | +9 (+5…+13) | -0.2 | yes | Mean of best two | -0.5 (-0.7…-0.3) |
| 3 | 47 / 3.3 / -1.6 | MF seamless, sea cell | +6 (+1…+10) | -0.2 | yes | Mean of best two | -0.5 (-0.6…-0.3) |
| 4 | 40 / 3.7 / -1.9 | ECMWF 9 km, sea cell | +3 (-2…+8) | -0.4 | no (tie) | Mix ECMWF 9 km + GFS, sea | -0.6 (-0.8…-0.4) |
| 5 | 40 / 3.9 / -1.9 | Mix ECMWF 9 km + GFS, sea | +3 (-2…+7) | -0.5 | no (tie) | Mix ECMWF 9 km + GFS, sea | -0.5 (-0.7…-0.3) |

## Per group, top 3 on CSI and today


### Day ahead 0

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 19 / 2.9 / -2.2 | AROME HD, sea cell 66 / 1.9 / +0.2 | AROME 2.5, beach cell 56 / 2.0 / -1.2 | AROME 2.5, sea cell 56 / 2.0 / -1.2 |
| Canaries | 166 | 87 | 72 / 4.2 / -3.9 | GFS, sea cell 78 / 2.9 / -2.1 | Mean of best two 78 / 2.1 / -1.6 | MF seamless, sea cell 78 / 2.1 / -0.1 |
| Mainland Spain (south masts) | 391 | 52 | 33 / 2.2 / -0.9 | GFS, beach cell 45 / 2.2 / +0.4 | GFS, sea cell 44 / 2.4 / +1.1 | ECMWF 25 km, sea cell 43 / 1.9 / +0.4 |
| Near-shore buoy (POEM) | 146 | 70 | 53 / 2.3 / -1.5 | AROME HD, sea cell 65 / 2.3 / -0.1 | AROME 2.5, beach cell 63 / 2.2 / -0.9 | AROME 2.5, sea cell 63 / 2.2 / -0.9 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 69 / 1.8 / -0.2 | MF seamless, beach cell 83 / 1.5 / +0.3 | MF seamless, sea cell 83 / 1.5 / +0.3 | AROME 2.5, beach cell 81 / 1.8 / +1.2 |

### Day ahead 1

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 14 / 3.4 / -2.5 | MF seamless, sea cell 47 / 2.3 / -0.2 | AROME HD, sea cell 47 / 2.3 / -0.2 | AROME 2.5, beach cell 46 / 2.5 / -1.4 |
| Canaries | 166 | 87 | 67 / 4.5 / -4.0 | Mix MF beach + ECMWF 9 km + GFS sea 79 / 3.2 / -2.8 | ECMWF 9 km, sea cell 78 / 2.7 / -2.1 | Mix ECMWF 9 km + GFS, sea 77 / 2.9 / -2.3 |
| Mainland Spain (south masts) | 391 | 52 | 26 / 2.4 / -0.9 | Mean of best two 49 / 2.1 / +0.1 | Mix MF beach + ECMWF 9 km + GFS sea 48 / 2.0 / +0.0 | GFS, beach cell 47 / 2.3 / +0.4 |
| Near-shore buoy (POEM) | 146 | 70 | 54 / 3.2 / +0.2 | AROME 2.5, beach cell 55 / 3.0 / -0.5 | AROME 2.5, sea cell 55 / 3.0 / -0.5 | best match, sea cell 54 / 3.2 / +0.2 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 73 / 2.2 / -0.4 | ECMWF 25 km, beach cell 74 / 2.2 / -0.1 | ECMWF 25 km, sea cell 74 / 2.2 / -0.1 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 1.9 / -0.2 |

### Day ahead 2

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 22 / 3.3 / -2.3 | MF seamless, sea cell 52 / 2.6 / +0.2 | MF seamless, beach cell 35 / 2.8 / -1.6 | GFS, sea cell 34 / 3.1 / +0.3 |
| Canaries | 166 | 87 | 67 / 4.7 / -4.1 | Mean of best two 77 / 2.9 / -1.9 | Mix ECMWF 9 km + GFS, sea 75 / 3.0 / -2.5 | MF seamless, beach cell 74 / 3.7 / -3.2 |
| Mainland Spain (south masts) | 391 | 52 | 22 / 2.6 / -1.0 | GFS, beach cell 45 / 2.5 / +0.2 | GFS, sea cell 43 / 2.6 / +0.8 | ECMWF 25 km, sea cell 41 / 2.2 / +0.2 |
| Near-shore buoy (POEM) | 146 | 70 | 48 / 3.4 / -2.0 | best match, sea cell 48 / 3.4 / -2.0 | MF seamless, sea cell 48 / 3.4 / -2.0 | AROME HD, beach cell 48 / 3.4 / -2.0 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 67 / 2.6 / -0.3 | Option 1 mix 73 / 2.2 / -0.7 | Mix MF beach + ECMWF 9 km sea 71 / 2.2 / -0.0 | ECMWF 25 km, beach cell 70 / 2.4 / -0.3 |

### Day ahead 3

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | MF seamless, sea cell 34 / 3.2 / -0.7 | MF seamless, beach cell 26 / 3.0 / -1.8 | GFS, sea cell 25 / 3.4 / -0.1 |
| Canaries | 166 | 87 | 70 / 4.8 / -4.2 | Mix MF beach + ECMWF 9 km sea 76 / 3.4 / -2.9 | MF seamless, beach cell 75 / 3.9 / -3.4 | MF seamless, sea cell 74 / 3.1 / -0.1 |
| Mainland Spain (south masts) | 391 | 52 | 19 / 2.7 / -0.9 | GFS, beach cell 48 / 2.6 / +0.2 | MF seamless, sea cell 38 / 3.1 / +1.1 | MF seamless, beach cell 38 / 3.0 / +0.3 |
| Near-shore buoy (POEM) | 146 | 70 | 45 / 3.2 / -1.5 | best match, sea cell 45 / 3.2 / -1.5 | MF seamless, sea cell 45 / 3.2 / -1.5 | AROME HD, beach cell 45 / 3.2 / -1.5 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 65 / 2.9 / +0.0 | Option 1 mix 69 / 2.5 / -0.8 | ICON seamless, beach cell 66 / 2.9 / +0.0 | ICON seamless, sea cell 66 / 2.9 / +0.0 |

### Day ahead 4

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | ECMWF 25 km, sea cell 28 / 3.7 / -2.0 | GFS, beach cell 18 / 3.4 / -0.5 | best match, sea cell 18 / 3.6 / -2.4 |
| Canaries | 166 | 87 | 63 / 4.9 / -4.3 | Mix ECMWF 9 km + GFS, sea 74 / 3.2 / -2.2 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 3.2 / -2.2 | Mean of best two 74 / 3.2 / -2.2 |
| Mainland Spain (south masts) | 391 | 52 | 16 / 3.1 / -0.9 | GFS, beach cell 40 / 2.8 / +0.2 | Mix ECMWF 9 km + GFS, sea 32 / 2.6 / -0.2 | Mix MF beach + ECMWF 9 km + GFS sea 32 / 2.6 / -0.2 |
| Near-shore buoy (POEM) | 146 | 70 | 33 / 4.5 / -3.3 | ECMWF 25 km, sea cell 41 / 4.1 / -2.5 | ICON seamless, sea cell 36 / 4.6 / -3.8 | ICON-EU, sea cell 36 / 4.6 / -3.8 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 56 / 3.6 / +0.1 | best match, beach cell 56 / 3.6 / +0.1 | best match, sea cell 56 / 3.6 / +0.1 | MF seamless, beach cell 56 / 3.6 / +0.1 |

### Day ahead 5

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 9 / 3.9 / -2.6 | ECMWF 25 km, sea cell 18 / 3.9 / -2.2 | GFS, beach cell 17 / 3.5 / -0.9 | GFS, sea cell 17 / 3.5 / -0.2 |
| Canaries | 166 | 87 | 61 / 4.8 / -4.2 | ECMWF 9 km, sea cell 72 / 3.1 / -2.4 | Mix MF beach + ECMWF 9 km sea 72 / 3.1 / -2.4 | GFS, sea cell 68 / 3.5 / -2.2 |
| Mainland Spain (south masts) | 391 | 52 | 18 / 3.2 / -1.1 | GFS, beach cell 36 / 2.8 / +0.4 | Mix ECMWF 9 km + GFS, sea 33 / 2.8 / +0.0 | Mix MF beach + ECMWF 9 km + GFS sea 33 / 2.8 / +0.0 |
| Near-shore buoy (POEM) | 146 | 70 | 34 / 4.5 / -2.7 | ECMWF 25 km, sea cell 52 / 3.9 / -1.7 | best match, sea cell 34 / 4.5 / -2.7 | MF seamless, beach cell 34 / 4.5 / -2.7 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 60 / 4.0 / +0.1 | best match, beach cell 60 / 4.0 / +0.1 | best match, sea cell 60 / 4.0 / +0.1 | MF seamless, beach cell 60 / 4.0 / +0.1 |
