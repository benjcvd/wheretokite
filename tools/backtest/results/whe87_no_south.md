# WHE-87: best forecast source for each day ahead, 2026-08-08 … 2026-10-30

25 truth sites, 84 dates. Groups: Barcelona (airport, Bocana Sud) 2, France 19, Near-shore buoy (POEM) 2, Open-sea buoys (Begur, Tarragona) 2.

**Left out: Canaries, Mainland Spain (south masts).**

Coverage = share of spot-days where the named source answered (else best match, sea cell).
Gains vs today = candidate minus today (best match, sea cell); 95 % interval over dates. MAE gain < 0 is better; caught/CSI gain > 0 better; false-go gain < 0 better.


## Day ahead 0 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: MF seamless, beach cell + MF seamless, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 100 % | +0.3 | 2.2 | -0.5 (-0.6…-0.4) | 80 % | +13 (+10…+17) | 24 % | -0 (-3…+2) | 63.8 | +9 (+6…+12) |
| Mean of best two | 100 % | +0.3 | 2.1 | -0.5 (-0.6…-0.4) | 80 % | +13 (+10…+17) | 24 % | -0 (-3…+2) | 63.8 | +9 (+6…+12) |
| MF seamless, beach cell | 100 % | +0.3 | 2.2 | -0.5 (-0.6…-0.4) | 80 % | +13 (+10…+17) | 24 % | -0 (-3…+2) | 63.7 | +9 (+6…+12) |
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -0.2 | 2.1 | -0.5 (-0.6…-0.4) | 76 % | +9 (+6…+13) | 21 % | -4 (-7…-1) | 63.6 | +9 (+6…+12) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -0.4 | 2.2 | -0.5 (-0.6…-0.4) | 74 % | +7 (+4…+10) | 19 % | -6 (-9…-3) | 63.1 | +8 (+5…+11) |
| AROME 2.5, beach cell | 100 % | +0.6 | 2.4 | -0.2 (-0.4…-0.1) | 80 % | +13 (+9…+17) | 27 % | +2 (-1…+5) | 61.8 | +7 (+4…+10) |
| AROME 2.5, sea cell | 100 % | +0.6 | 2.4 | -0.2 (-0.4…-0.1) | 80 % | +13 (+9…+17) | 27 % | +2 (-1…+5) | 61.8 | +7 (+4…+10) |
| AROME HD, sea cell | 100 % | +1.3 | 2.6 | -0.1 (-0.2…+0.1) | 86 % | +19 (+15…+23) | 32 % | +7 (+4…+10) | 61.0 | +6 (+3…+9) |
| ECMWF 25 km, sea cell | 100 % | -0.4 | 2.8 | +0.1 (+0.0…+0.3) | 76 % | +9 (+5…+13) | 25 % | +1 (-3…+4) | 60.5 | +6 (+2…+9) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.3 | 2.4 | -0.3 (-0.4…-0.1) | 73 % | +6 (+3…+10) | 23 % | -2 (-5…+1) | 60.3 | +5 (+2…+9) |
| AROME HD, beach cell | 100 % | +0.2 | 2.4 | -0.3 (-0.4…-0.2) | 74 % | +7 (+4…+10) | 24 % | -1 (-3…+2) | 59.9 | +5 (+2…+8) |
| GFS, sea cell | 100 % | +0.6 | 2.7 | +0.0 (-0.1…+0.2) | 77 % | +10 (+6…+14) | 31 % | +6 (+2…+9) | 57.3 | +2 (-1…+6) |
| best match, beach cell | 100 % | -0.6 | 2.4 | -0.2 (-0.3…-0.2) | 68 % | +1 (-2…+3) | 22 % | -2 (-5…-0) | 56.7 | +2 (-1…+4) |
| Option 1 mix | 100 % | -1.0 | 2.4 | -0.3 (-0.4…-0.2) | 65 % | -2 (-5…+1) | 19 % | -6 (-10…-3) | 56.4 | +2 (-1…+5) |
| ICON-EU, sea cell | 100 % | -1.4 | 2.7 | +0.1 (-0.1…+0.2) | 63 % | -4 (-7…-2) | 17 % | -7 (-10…-5) | 55.4 | +1 (-2…+3) |
| ECMWF 9 km, sea cell | 100 % | -0.7 | 2.6 | -0.0 (-0.1…+0.1) | 67 % | -0 (-4…+3) | 23 % | -1 (-5…+2) | 55.3 | +0 (-3…+4) |
| **best match, sea cell** (today) | 100 % | -0.5 | 2.7 |  | 67 % |  | 25 % |  | 54.9 |  |
| GFS, beach cell | 100 % | -0.7 | 2.8 | +0.1 (+0.0…+0.3) | 63 % | -4 (-8…+1) | 23 % | -1 (-5…+2) | 53.2 | -2 (-6…+2) |
| ICON seamless, sea cell | 100 % | -1.1 | 2.9 | +0.2 (+0.1…+0.3) | 61 % | -6 (-8…-3) | 22 % | -3 (-5…-1) | 52.5 | -2 (-5…-0) |
| ICON seamless, beach cell | 100 % | -1.9 | 2.9 | +0.2 (+0.1…+0.3) | 52 % | -15 (-19…-12) | 15 % | -9 (-13…-6) | 47.2 | -8 (-11…-4) |
| ICON-EU, beach cell | 100 % | -2.2 | 3.0 | +0.3 (+0.2…+0.4) | 49 % | -18 (-21…-14) | 15 % | -10 (-13…-7) | 45.5 | -9 (-13…-6) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.2 | +0.5 (+0.4…+0.7) | 45 % | -22 (-28…-17) | 13 % | -12 (-16…-8) | 42.0 | -13 (-18…-9) |
| ECMWF 25 km, beach cell | 100 % | -2.9 | 3.6 | +1.0 (+0.8…+1.1) | 42 % | -25 (-30…-20) | 14 % | -11 (-15…-7) | 39.3 | -16 (-20…-11) |

## Day ahead 1 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + AROME HD, beach cell / AROME HD, beach cell + MF seamless, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -0.4 | 2.4 | -0.7 (-0.8…-0.5) | 73 % | +5 (+2…+9) | 24 % | -3 (-7…+0) | 59.3 | +5 (+2…+9) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.3 | 2.6 | -0.5 (-0.7…-0.4) | 71 % | +4 (+0…+8) | 25 % | -2 (-6…+2) | 57.7 | +4 (+0…+7) |
| ECMWF 25 km, sea cell | 100 % | -0.5 | 2.9 | -0.2 (-0.3…-0.0) | 72 % | +5 (+1…+9) | 26 % | -1 (-5…+3) | 57.7 | +4 (+0…+7) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -0.6 | 2.5 | -0.6 (-0.7…-0.5) | 69 % | +2 (-2…+5) | 23 % | -4 (-8…-1) | 57.3 | +3 (-0…+7) |
| Mean of best two | 100 % | -0.2 | 2.6 | -0.4 (-0.6…-0.3) | 71 % | +3 (-0…+7) | 27 % | -1 (-4…+3) | 56.4 | +3 (-1…+6) |
| AROME 2.5, beach cell | 100 % | +0.5 | 2.9 | -0.2 (-0.3…-0.1) | 77 % | +10 (+6…+14) | 33 % | +6 (+3…+9) | 55.8 | +2 (-2…+5) |
| AROME 2.5, sea cell | 100 % | +0.5 | 2.9 | -0.2 (-0.3…-0.1) | 77 % | +10 (+6…+14) | 33 % | +6 (+3…+9) | 55.8 | +2 (-2…+5) |
| Option 1 mix | 100 % | -1.1 | 2.6 | -0.5 (-0.6…-0.3) | 64 % | -4 (-7…+0) | 19 % | -8 (-12…-4) | 55.4 | +1 (-2…+5) |
| MF seamless, sea cell | 100 % | +1.2 | 3.0 | -0.1 (-0.2…+0.0) | 82 % | +14 (+11…+18) | 37 % | +10 (+7…+13) | 55.2 | +1 (-2…+5) |
| AROME HD, sea cell | 100 % | +1.2 | 3.0 | -0.1 (-0.2…+0.0) | 82 % | +14 (+11…+18) | 37 % | +10 (+7…+13) | 55.2 | +1 (-2…+5) |
| MF seamless, beach cell | 100 % | +0.1 | 2.8 | -0.3 (-0.4…-0.2) | 72 % | +4 (+1…+8) | 30 % | +3 (+0…+6) | 54.7 | +1 (-2…+4) |
| AROME HD, beach cell | 100 % | +0.1 | 2.8 | -0.3 (-0.4…-0.2) | 72 % | +4 (+1…+8) | 30 % | +3 (+0…+6) | 54.7 | +1 (-2…+4) |
| ECMWF 9 km, sea cell | 100 % | -0.8 | 2.8 | -0.3 (-0.4…-0.1) | 65 % | -2 (-6…+1) | 24 % | -3 (-7…+1) | 54.0 | +0 (-3…+4) |
| **best match, sea cell** (today) | 100 % | -0.4 | 3.1 |  | 67 % |  | 27 % |  | 53.9 |  |
| GFS, sea cell | 100 % | +0.6 | 2.9 | -0.2 (-0.3…-0.0) | 75 % | +8 (+4…+12) | 35 % | +7 (+4…+12) | 53.8 | -0 (-4…+4) |
| ICON-EU, sea cell | 100 % | -1.4 | 3.0 | -0.1 (-0.2…-0.0) | 61 % | -6 (-9…-3) | 20 % | -7 (-10…-4) | 52.9 | -1 (-3…+1) |
| best match, beach cell | 100 % | -0.8 | 2.9 | -0.2 (-0.3…-0.1) | 64 % | -4 (-7…-1) | 26 % | -1 (-4…+1) | 52.1 | -2 (-4…+0) |
| ICON seamless, sea cell | 100 % | -1.1 | 3.2 | +0.1 (+0.0…+0.2) | 61 % | -7 (-9…-5) | 23 % | -4 (-6…-2) | 51.2 | -3 (-5…-1) |
| GFS, beach cell | 100 % | -0.9 | 3.0 | -0.1 (-0.2…+0.1) | 62 % | -6 (-11…-1) | 27 % | -0 (-4…+4) | 50.3 | -4 (-8…+1) |
| ICON seamless, beach cell | 100 % | -2.0 | 3.1 | +0.0 (-0.1…+0.2) | 51 % | -16 (-20…-13) | 17 % | -10 (-13…-6) | 46.0 | -8 (-11…-5) |
| ICON-EU, beach cell | 100 % | -2.2 | 3.2 | +0.1 (-0.0…+0.2) | 49 % | -18 (-23…-15) | 15 % | -12 (-16…-9) | 45.1 | -9 (-12…-6) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.3 | +0.2 (+0.0…+0.4) | 43 % | -24 (-29…-20) | 15 % | -12 (-16…-8) | 40.2 | -14 (-18…-9) |
| ECMWF 25 km, beach cell | 100 % | -2.9 | 3.6 | +0.6 (+0.4…+0.7) | 42 % | -26 (-31…-21) | 14 % | -13 (-19…-8) | 39.2 | -15 (-20…-10) |

## Day ahead 2 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + ECMWF 25 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| ECMWF 25 km, sea cell | 100 % | -0.5 | 3.0 | -0.1 (-0.2…+0.1) | 71 % | +4 (+1…+8) | 29 % | +5 (+1…+8) | 54.9 | +0 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -0.8 | 3.1 |  | 67 % |  | 25 % |  | 54.7 |  |
| AROME HD, beach cell | 0 % | -0.8 | 3.1 | +0.0 (+0.0…+0.0) | 67 % | +0 (+0…+0) | 25 % | +0 (+0…+0) | 54.7 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -0.8 | 3.1 | +0.0 (+0.0…+0.0) | 67 % | +0 (+0…+0) | 25 % | +0 (+0…+0) | 54.7 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -0.8 | 3.1 | +0.0 (+0.0…+0.0) | 67 % | +0 (+0…+0) | 25 % | +0 (+0…+0) | 54.7 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -0.8 | 3.1 | +0.0 (+0.0…+0.0) | 67 % | +0 (+0…+0) | 25 % | +0 (+0…+0) | 54.7 | +0 (+0…+0) |
| Mean of best two | 100 % | -0.8 | 3.0 | -0.1 (-0.3…-0.0) | 67 % | +1 (-3…+5) | 26 % | +1 (-2…+5) | 54.5 | -0 (-4…+3) |
| MF seamless, sea cell | 99 % | +0.6 | 3.3 | +0.2 (+0.1…+0.4) | 76 % | +9 (+5…+13) | 34 % | +10 (+6…+13) | 54.5 | -0 (-3…+3) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.5 | 2.8 | -0.3 (-0.4…-0.2) | 68 % | +1 (-3…+5) | 28 % | +4 (-0…+7) | 53.5 | -1 (-5…+2) |
| Option 1 mix | 0 % | -1.6 | 2.9 | -0.2 (-0.3…-0.0) | 61 % | -6 (-10…-3) | 18 % | -7 (-10…-3) | 53.5 | -1 (-5…+2) |
| Mix MF beach + ECMWF 9 km + GFS sea | 99 % | -0.9 | 2.7 | -0.4 (-0.5…-0.3) | 63 % | -4 (-8…-0) | 22 % | -2 (-6…+1) | 53.1 | -2 (-5…+2) |
| Mix MF beach + ECMWF 9 km sea | 99 % | -1.2 | 2.7 | -0.3 (-0.5…-0.2) | 61 % | -6 (-10…-2) | 21 % | -4 (-7…-1) | 52.6 | -2 (-6…+1) |
| MF seamless, beach cell | 99 % | -1.3 | 3.1 | -0.0 (-0.2…+0.1) | 62 % | -5 (-9…-1) | 22 % | -3 (-6…+1) | 52.5 | -2 (-6…+1) |
| ICON seamless, sea cell | 100 % | -1.4 | 3.1 | +0.0 (-0.1…+0.1) | 60 % | -6 (-9…-4) | 21 % | -4 (-6…-2) | 52.1 | -3 (-5…-0) |
| ICON-EU, sea cell | 100 % | -1.4 | 3.1 | +0.0 (-0.1…+0.1) | 60 % | -6 (-9…-4) | 21 % | -4 (-6…-2) | 52.1 | -3 (-5…-0) |
| ECMWF 9 km, sea cell | 100 % | -0.8 | 2.9 | -0.2 (-0.3…-0.1) | 64 % | -3 (-7…+1) | 27 % | +2 (-2…+5) | 51.8 | -3 (-6…+0) |
| GFS, sea cell | 100 % | +0.5 | 3.2 | +0.1 (-0.1…+0.3) | 73 % | +6 (+2…+10) | 37 % | +12 (+8…+16) | 51.2 | -4 (-7…+0) |
| best match, beach cell | 100 % | -1.8 | 3.2 | +0.1 (-0.0…+0.2) | 52 % | -14 (-18…-11) | 20 % | -5 (-8…-2) | 46.4 | -8 (-12…-5) |
| GFS, beach cell | 100 % | -0.9 | 3.3 | +0.2 (+0.0…+0.4) | 55 % | -12 (-17…-7) | 32 % | +7 (+3…+11) | 43.5 | -11 (-15…-8) |
| ICON seamless, beach cell | 100 % | -2.2 | 3.3 | +0.2 (+0.1…+0.3) | 48 % | -19 (-23…-15) | 17 % | -8 (-11…-5) | 43.5 | -11 (-15…-8) |
| ICON-EU, beach cell | 100 % | -2.2 | 3.3 | +0.2 (+0.1…+0.3) | 48 % | -19 (-23…-15) | 17 % | -8 (-11…-5) | 43.5 | -11 (-15…-8) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.4 | +0.3 (+0.2…+0.4) | 43 % | -24 (-29…-19) | 17 % | -8 (-12…-4) | 39.4 | -15 (-20…-11) |
| ECMWF 25 km, beach cell | 100 % | -2.9 | 3.7 | +0.7 (+0.5…+0.8) | 41 % | -25 (-31…-20) | 17 % | -7 (-12…-3) | 38.1 | -17 (-22…-12) |

## Day ahead 3 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: best match, beach cell + ECMWF 9 km, sea cell / ECMWF 9 km, sea cell + ECMWF 25 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| ECMWF 25 km, sea cell | 100 % | -0.7 | 3.3 | -0.0 (-0.2…+0.2) | 67 % | +4 (-0…+8) | 29 % | +2 (-1…+5) | 52.7 | +1 (-2…+4) |
| **best match, sea cell** (today) | 100 % | -0.9 | 3.3 |  | 64 % |  | 27 % |  | 51.5 |  |
| AROME HD, beach cell | 0 % | -0.9 | 3.3 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 51.5 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -0.9 | 3.3 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 51.5 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -0.9 | 3.3 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 51.5 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -0.9 | 3.3 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 51.5 | +0 (+0…+0) |
| ECMWF 9 km, sea cell | 100 % | -1.0 | 3.2 | -0.1 (-0.3…+0.0) | 62 % | -2 (-6…+2) | 27 % | -0 (-3…+3) | 50.1 | -1 (-5…+2) |
| MF seamless, sea cell | 98 % | +0.4 | 3.7 | +0.3 (+0.2…+0.5) | 71 % | +7 (+4…+11) | 38 % | +10 (+8…+13) | 49.7 | -2 (-5…+1) |
| ICON seamless, sea cell | 100 % | -1.6 | 3.4 | +0.1 (-0.0…+0.2) | 58 % | -6 (-8…-4) | 23 % | -4 (-7…-2) | 49.5 | -2 (-4…+0) |
| ICON-EU, sea cell | 100 % | -1.6 | 3.4 | +0.1 (-0.0…+0.2) | 58 % | -6 (-8…-4) | 23 % | -4 (-7…-2) | 49.5 | -2 (-4…+0) |
| Option 1 mix | 0 % | -1.8 | 3.2 | -0.2 (-0.3…+0.0) | 56 % | -8 (-11…-5) | 20 % | -8 (-11…-4) | 49.2 | -2 (-6…+1) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.6 | 3.0 | -0.3 (-0.4…-0.1) | 61 % | -2 (-6…+2) | 29 % | +2 (-1…+5) | 49.1 | -2 (-6…+1) |
| Mix MF beach + ECMWF 9 km + GFS sea | 98 % | -1.0 | 2.9 | -0.4 (-0.6…-0.3) | 59 % | -5 (-9…-1) | 25 % | -2 (-5…+1) | 49.1 | -2 (-6…+1) |
| Mix MF beach + ECMWF 9 km sea | 98 % | -1.4 | 3.0 | -0.4 (-0.5…-0.2) | 57 % | -7 (-11…-4) | 23 % | -4 (-7…-0) | 48.3 | -3 (-7…-0) |
| Mean of best two | 100 % | -1.4 | 3.2 | -0.1 (-0.3…+0.0) | 57 % | -6 (-10…-3) | 26 % | -1 (-5…+2) | 47.9 | -4 (-7…-0) |
| GFS, sea cell | 100 % | +0.2 | 3.4 | +0.1 (-0.1…+0.3) | 64 % | +1 (-4…+5) | 39 % | +12 (+8…+16) | 45.6 | -6 (-9…-2) |
| MF seamless, beach cell | 98 % | -1.4 | 3.3 | -0.0 (-0.1…+0.1) | 55 % | -8 (-12…-5) | 28 % | +1 (-3…+4) | 45.6 | -6 (-9…-3) |
| best match, beach cell | 100 % | -2.0 | 3.4 | +0.1 (+0.0…+0.2) | 48 % | -16 (-19…-13) | 24 % | -3 (-6…+0) | 41.4 | -10 (-13…-7) |
| GFS, beach cell | 100 % | -0.9 | 3.5 | +0.2 (-0.0…+0.4) | 52 % | -12 (-16…-7) | 34 % | +7 (+2…+11) | 41.1 | -10 (-14…-7) |
| ICON seamless, beach cell | 100 % | -2.4 | 3.6 | +0.3 (+0.1…+0.4) | 44 % | -20 (-23…-16) | 21 % | -7 (-11…-3) | 39.6 | -12 (-15…-8) |
| ICON-EU, beach cell | 100 % | -2.4 | 3.6 | +0.3 (+0.1…+0.4) | 44 % | -20 (-23…-16) | 21 % | -7 (-11…-3) | 39.6 | -12 (-15…-8) |
| ECMWF 9 km, beach cell | 100 % | -2.5 | 3.6 | +0.3 (+0.1…+0.4) | 42 % | -22 (-26…-18) | 19 % | -9 (-12…-5) | 38.3 | -13 (-17…-9) |
| ECMWF 25 km, beach cell | 100 % | -3.0 | 3.9 | +0.6 (+0.4…+0.7) | 38 % | -26 (-31…-22) | 18 % | -10 (-14…-5) | 34.8 | -17 (-21…-13) |

## Day ahead 4 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + best match, sea cell / ECMWF 25 km, sea cell + ECMWF 9 km, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| ECMWF 25 km, sea cell | 100 % | -0.8 | 3.5 | -0.1 (-0.3…+0.0) | 63 % | +9 (+4…+13) | 34 % | +2 (-2…+5) | 47.6 | +4 (+1…+8) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.8 | 3.3 | -0.4 (-0.6…-0.3) | 56 % | +1 (-3…+5) | 32 % | -1 (-4…+3) | 44.3 | +1 (-2…+4) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -0.8 | 3.3 | -0.4 (-0.6…-0.3) | 56 % | +1 (-3…+5) | 32 % | -1 (-4…+3) | 44.3 | +1 (-2…+4) |
| Mean of best two | 100 % | -1.3 | 3.5 | -0.2 (-0.3…-0.1) | 55 % | +0 (-3…+3) | 31 % | -2 (-5…+1) | 44.1 | +1 (-2…+3) |
| Option 1 mix | 0 % | -1.8 | 3.4 | -0.3 (-0.4…-0.2) | 51 % | -4 (-7…-0) | 24 % | -8 (-11…-5) | 43.7 | +0 (-3…+4) |
| ECMWF 9 km, sea cell | 100 % | -1.2 | 3.5 | -0.2 (-0.3…+0.0) | 55 % | +1 (-3…+5) | 33 % | +0 (-4…+4) | 43.6 | +0 (-3…+3) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -1.2 | 3.5 | -0.2 (-0.3…+0.0) | 55 % | +1 (-3…+5) | 33 % | +0 (-4…+4) | 43.6 | +0 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -1.3 | 3.7 |  | 55 % |  | 32 % |  | 43.2 |  |
| MF seamless, beach cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.3 | 3.7 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 43.2 | +0 (+0…+0) |
| ICON seamless, sea cell | 100 % | -1.6 | 3.8 | +0.1 (+0.0…+0.2) | 53 % | -1 (-4…+1) | 31 % | -2 (-4…+0) | 43.1 | -0 (-2…+2) |
| ICON-EU, sea cell | 100 % | -1.6 | 3.8 | +0.1 (+0.0…+0.2) | 53 % | -1 (-4…+1) | 31 % | -2 (-4…+0) | 43.1 | -0 (-2…+2) |
| GFS, sea cell | 100 % | +0.4 | 3.7 | +0.1 (-0.1…+0.2) | 63 % | +9 (+4…+14) | 43 % | +11 (+7…+15) | 42.8 | -0 (-4…+3) |
| GFS, beach cell | 100 % | -0.9 | 3.7 | -0.0 (-0.2…+0.1) | 50 % | -4 (-9…+0) | 37 % | +5 (+0…+10) | 38.6 | -5 (-8…-1) |
| ICON seamless, beach cell | 100 % | -2.3 | 3.9 | +0.2 (+0.1…+0.3) | 45 % | -10 (-13…-7) | 27 % | -5 (-8…-2) | 38.5 | -5 (-8…-2) |
| ICON-EU, beach cell | 100 % | -2.3 | 3.9 | +0.2 (+0.1…+0.3) | 45 % | -10 (-13…-7) | 27 % | -5 (-8…-2) | 38.5 | -5 (-8…-2) |
| best match, beach cell | 100 % | -2.4 | 3.9 | +0.2 (+0.1…+0.3) | 40 % | -15 (-18…-11) | 27 % | -6 (-10…-2) | 34.9 | -8 (-12…-5) |
| ECMWF 9 km, beach cell | 100 % | -2.7 | 3.9 | +0.2 (+0.1…+0.4) | 36 % | -18 (-23…-14) | 23 % | -10 (-14…-5) | 32.8 | -10 (-14…-6) |
| ECMWF 25 km, beach cell | 100 % | -3.0 | 4.1 | +0.4 (+0.2…+0.6) | 35 % | -19 (-24…-15) | 24 % | -9 (-14…-4) | 31.9 | -11 (-15…-7) |

## Day ahead 5 — 2061 spot-days, 84 dates, 649 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + ECMWF 25 km, sea cell / ECMWF 9 km, sea cell + GFS, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.8 | 3.5 | -0.6 (-0.8…-0.4) | 59 % | +3 (-1…+6) | 34 % | -3 (-6…+1) | 45.2 | +3 (-0…+5) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -0.8 | 3.5 | -0.6 (-0.8…-0.4) | 59 % | +3 (-1…+6) | 34 % | -3 (-6…+1) | 45.2 | +3 (-0…+5) |
| ECMWF 25 km, sea cell | 100 % | -0.5 | 3.9 | -0.2 (-0.3…+0.0) | 61 % | +6 (+1…+10) | 38 % | +2 (-2…+6) | 44.6 | +2 (-2…+5) |
| **best match, sea cell** (today) | 100 % | -1.0 | 4.1 |  | 56 % |  | 36 % |  | 42.5 |  |
| MF seamless, beach cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| ICON-EU, beach cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| ICON-EU, sea cell | 0 % | -1.0 | 4.1 | +0.0 (+0.0…+0.0) | 56 % | +0 (+0…+0) | 36 % | +0 (+0…+0) | 42.5 | +0 (+0…+0) |
| GFS, sea cell | 100 % | +0.1 | 4.0 | -0.1 (-0.3…+0.2) | 61 % | +6 (+1…+10) | 43 % | +7 (+3…+11) | 42.1 | -0 (-4…+3) |
| ICON seamless, sea cell | 100 % | -1.1 | 4.3 | +0.2 (+0.2…+0.3) | 54 % | -2 (-4…+1) | 37 % | +1 (-1…+3) | 41.1 | -1 (-4…+1) |
| ECMWF 9 km, sea cell | 100 % | -0.9 | 3.8 | -0.3 (-0.4…-0.1) | 53 % | -3 (-6…+1) | 37 % | +1 (-3…+5) | 40.6 | -2 (-5…+1) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -0.9 | 3.8 | -0.3 (-0.4…-0.1) | 53 % | -3 (-6…+1) | 37 % | +1 (-3…+5) | 40.6 | -2 (-5…+1) |
| Mean of best two | 100 % | -1.1 | 3.7 | -0.4 (-0.5…-0.2) | 52 % | -4 (-8…-0) | 35 % | -1 (-4…+2) | 40.6 | -2 (-5…+1) |
| Option 1 mix | 0 % | -1.9 | 3.7 | -0.3 (-0.5…-0.2) | 47 % | -9 (-12…-6) | 30 % | -6 (-10…-2) | 39.2 | -3 (-6…-0) |
| GFS, beach cell | 100 % | -1.2 | 4.1 | -0.0 (-0.3…+0.2) | 47 % | -9 (-14…-4) | 39 % | +3 (-1…+8) | 36.2 | -6 (-11…-2) |
| ICON seamless, beach cell | 100 % | -2.5 | 4.4 | +0.3 (+0.1…+0.5) | 41 % | -14 (-18…-10) | 30 % | -7 (-11…-2) | 35.3 | -7 (-11…-4) |
| best match, beach cell | 100 % | -2.5 | 4.2 | +0.1 (-0.1…+0.2) | 39 % | -16 (-20…-13) | 27 % | -9 (-13…-5) | 34.4 | -8 (-12…-5) |
| ECMWF 9 km, beach cell | 100 % | -2.5 | 4.1 | -0.0 (-0.2…+0.2) | 38 % | -18 (-22…-14) | 27 % | -9 (-14…-4) | 33.5 | -9 (-13…-5) |
| ECMWF 25 km, beach cell | 100 % | -2.8 | 4.3 | +0.2 (-0.0…+0.4) | 36 % | -20 (-24…-16) | 29 % | -7 (-12…-2) | 31.7 | -11 (-15…-7) |

## Summary: winner per day ahead

Winner = highest CSI among sources (and mixes) that answered themselves on ≥ 90 % of spot-days; 'real' when its CSI gain interval excludes 0.

| Day ahead | Today: CSI / MAE / bias | Best on CSI | CSI gain | MAE gain | Real? | Best on MAE | MAE gain |
|---|---|---|---|---|---|---|---|
| 0 | 55 / 2.7 / -0.5 | MF seamless, sea cell | +9 (+6…+12) | -0.5 | yes | Mix MF beach + ECMWF 9 km + GFS sea | -0.5 (-0.6…-0.4) |
| 1 | 54 / 3.1 / -0.4 | Mix MF beach + ECMWF 9 km + GFS sea | +5 (+2…+9) | -0.7 | yes | Mix MF beach + ECMWF 9 km + GFS sea | -0.7 (-0.8…-0.5) |
| 2 | 55 / 3.1 / -0.8 | ECMWF 25 km, sea cell | +0 (-3…+3) | -0.1 | no (tie) | Mix MF beach + ECMWF 9 km + GFS sea | -0.4 (-0.5…-0.3) |
| 3 | 51 / 3.3 / -0.9 | ECMWF 25 km, sea cell | +1 (-2…+4) | -0.0 | no (tie) | Mix MF beach + ECMWF 9 km + GFS sea | -0.4 (-0.6…-0.3) |
| 4 | 43 / 3.7 / -1.3 | ECMWF 25 km, sea cell | +4 (+1…+8) | -0.1 | yes | Mix ECMWF 9 km + GFS, sea | -0.4 (-0.6…-0.3) |
| 5 | 43 / 4.1 / -1.0 | Mix ECMWF 9 km + GFS, sea | +3 (-0…+5) | -0.6 | no (tie) | Mix ECMWF 9 km + GFS, sea | -0.6 (-0.8…-0.4) |

## Per group, top 3 on CSI and today


### Day ahead 0

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 19 / 2.9 / -2.2 | AROME HD, sea cell 66 / 1.9 / +0.2 | AROME 2.5, beach cell 56 / 2.0 / -1.2 | AROME 2.5, sea cell 56 / 2.0 / -1.2 |
| France | 1593 | 453 | 56 / 2.8 / -0.3 | Mix MF beach + ECMWF 9 km + GFS sea 67 / 2.1 / +0.1 | Mix MF beach + ECMWF 9 km sea 67 / 2.1 / -0.1 | Mix ECMWF 9 km + GFS, sea 65 / 2.3 / +0.1 |
| Near-shore buoy (POEM) | 146 | 70 | 53 / 2.3 / -1.5 | AROME HD, sea cell 65 / 2.3 / -0.1 | AROME 2.5, beach cell 63 / 2.2 / -0.9 | AROME 2.5, sea cell 63 / 2.2 / -0.9 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 69 / 1.8 / -0.2 | MF seamless, beach cell 83 / 1.5 / +0.3 | MF seamless, sea cell 83 / 1.5 / +0.3 | Mean of best two 83 / 1.5 / +0.3 |

### Day ahead 1

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 14 / 3.4 / -2.5 | MF seamless, sea cell 47 / 2.3 / -0.2 | AROME HD, sea cell 47 / 2.3 / -0.2 | AROME 2.5, beach cell 46 / 2.5 / -1.4 |
| France | 1593 | 453 | 55 / 3.1 / -0.3 | Mix MF beach + ECMWF 9 km + GFS sea 62 / 2.4 / -0.0 | Mix ECMWF 9 km + GFS, sea 61 / 2.4 / +0.1 | Mix MF beach + ECMWF 9 km sea 61 / 2.4 / -0.3 |
| Near-shore buoy (POEM) | 146 | 70 | 54 / 3.2 / +0.2 | AROME 2.5, beach cell 55 / 3.0 / -0.5 | AROME 2.5, sea cell 55 / 3.0 / -0.5 | best match, sea cell 54 / 3.2 / +0.2 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 73 / 2.2 / -0.4 | ECMWF 25 km, beach cell 74 / 2.2 / -0.1 | ECMWF 25 km, sea cell 74 / 2.2 / -0.1 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 1.9 / -0.2 |

### Day ahead 2

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 22 / 3.3 / -2.3 | MF seamless, sea cell 52 / 2.6 / +0.2 | MF seamless, beach cell 35 / 2.8 / -1.6 | GFS, sea cell 34 / 3.1 / +0.3 |
| France | 1593 | 453 | 57 / 3.1 / -0.5 | Option 1 mix 58 / 2.8 / -1.4 | Mean of best two 57 / 2.9 / -0.5 | Mix MF beach + ECMWF 9 km + GFS sea 57 / 2.6 / -0.7 |
| Near-shore buoy (POEM) | 146 | 70 | 48 / 3.4 / -2.0 | best match, sea cell 48 / 3.4 / -2.0 | MF seamless, sea cell 48 / 3.4 / -2.0 | AROME HD, beach cell 48 / 3.4 / -2.0 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 67 / 2.6 / -0.3 | Option 1 mix 73 / 2.2 / -0.7 | Mean of best two 72 / 2.3 / -0.3 | Mix MF beach + ECMWF 9 km sea 71 / 2.2 / -0.0 |

### Day ahead 3

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | MF seamless, sea cell 34 / 3.2 / -0.7 | MF seamless, beach cell 26 / 3.0 / -1.8 | GFS, sea cell 25 / 3.4 / -0.1 |
| France | 1593 | 453 | 53 / 3.3 / -0.8 | ECMWF 25 km, sea cell 55 / 3.3 / -0.4 | ECMWF 9 km, sea cell 54 / 3.1 / -0.7 | Mix ECMWF 9 km + GFS, sea 53 / 2.9 / -0.2 |
| Near-shore buoy (POEM) | 146 | 70 | 45 / 3.2 / -1.5 | best match, sea cell 45 / 3.2 / -1.5 | MF seamless, sea cell 45 / 3.2 / -1.5 | AROME HD, beach cell 45 / 3.2 / -1.5 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 65 / 2.9 / +0.0 | Option 1 mix 69 / 2.5 / -0.8 | Mean of best two 67 / 2.7 / -0.8 | ICON seamless, beach cell 66 / 2.9 / +0.0 |

### Day ahead 4

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | ECMWF 25 km, sea cell 28 / 3.7 / -2.0 | GFS, beach cell 18 / 3.4 / -0.5 | best match, sea cell 18 / 3.6 / -2.4 |
| France | 1593 | 453 | 44 / 3.6 / -1.1 | ECMWF 25 km, sea cell 49 / 3.5 / -0.5 | Mix ECMWF 9 km + GFS, sea 49 / 3.1 / -0.4 | Mix MF beach + ECMWF 9 km + GFS sea 49 / 3.1 / -0.4 |
| Near-shore buoy (POEM) | 146 | 70 | 33 / 4.5 / -3.3 | ECMWF 25 km, sea cell 41 / 4.1 / -2.5 | ICON seamless, sea cell 36 / 4.6 / -3.8 | ICON-EU, sea cell 36 / 4.6 / -3.8 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 56 / 3.6 / +0.1 | best match, beach cell 56 / 3.6 / +0.1 | best match, sea cell 56 / 3.6 / +0.1 | MF seamless, beach cell 56 / 3.6 / +0.1 |

### Day ahead 5

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 9 / 3.9 / -2.6 | ECMWF 25 km, sea cell 18 / 3.9 / -2.2 | GFS, beach cell 17 / 3.5 / -0.9 | GFS, sea cell 17 / 3.5 / -0.2 |
| France | 1593 | 453 | 44 / 4.1 / -0.8 | Mix ECMWF 9 km + GFS, sea 49 / 3.3 / -0.4 | Mix MF beach + ECMWF 9 km + GFS sea 49 / 3.3 / -0.4 | GFS, sea cell 45 / 4.0 / +0.5 |
| Near-shore buoy (POEM) | 146 | 70 | 34 / 4.5 / -2.7 | ECMWF 25 km, sea cell 52 / 3.9 / -1.7 | best match, sea cell 34 / 4.5 / -2.7 | MF seamless, beach cell 34 / 4.5 / -2.7 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 60 / 4.0 / +0.1 | best match, beach cell 60 / 4.0 / +0.1 | best match, sea cell 60 / 4.0 / +0.1 | MF seamless, beach cell 60 / 4.0 / +0.1 |
