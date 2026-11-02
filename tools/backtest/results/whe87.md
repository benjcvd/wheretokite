# WHE-87: best forecast source for each day ahead, 2026-08-08 … 2026-10-30

32 truth sites, 84 dates. Groups: Barcelona (airport, Bocana Sud) 2, Canaries 2, France 19, Mainland Spain (south masts) 5, Near-shore buoy (POEM) 2, Open-sea buoys (Begur, Tarragona) 2.

Coverage = share of spot-days where the named source answered (else best match, sea cell).
Gains vs today = candidate minus today (best match, sea cell); 95 % interval over dates. MAE gain < 0 is better; caught/CSI gain > 0 better; false-go gain < 0 better.


## Day ahead 0 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: MF seamless, sea cell + MF seamless, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mean of best two | 100 % | +0.2 | 2.2 | -0.5 (-0.6…-0.4) | 79 % | +13 (+11…+16) | 24 % | +1 (-1…+3) | 63.5 | +8 (+6…+11) |
| MF seamless, beach cell | 100 % | +0.1 | 2.3 | -0.4 (-0.5…-0.3) | 78 % | +12 (+9…+15) | 23 % | -0 (-2…+2) | 63.3 | +8 (+6…+11) |
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -0.3 | 2.1 | -0.5 (-0.6…-0.5) | 75 % | +9 (+6…+12) | 20 % | -3 (-6…-1) | 63.1 | +8 (+5…+11) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -0.5 | 2.2 | -0.5 (-0.6…-0.4) | 72 % | +6 (+4…+9) | 18 % | -6 (-8…-3) | 62.7 | +8 (+5…+10) |
| MF seamless, sea cell | 100 % | +0.4 | 2.2 | -0.5 (-0.6…-0.4) | 80 % | +14 (+11…+17) | 26 % | +3 (+0…+5) | 62.5 | +8 (+5…+10) |
| AROME 2.5, beach cell | 79 % | +0.1 | 2.5 | -0.2 (-0.3…-0.1) | 77 % | +11 (+8…+14) | 25 % | +2 (-0…+5) | 60.8 | +6 (+3…+9) |
| AROME 2.5, sea cell | 79 % | +0.1 | 2.5 | -0.2 (-0.3…-0.1) | 77 % | +11 (+8…+14) | 25 % | +2 (-0…+5) | 60.8 | +6 (+3…+9) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.3 | 2.3 | -0.3 (-0.4…-0.3) | 73 % | +7 (+4…+11) | 23 % | -1 (-3…+2) | 60.4 | +5 (+3…+8) |
| AROME HD, sea cell | 79 % | +0.7 | 2.6 | -0.0 (-0.1…+0.1) | 81 % | +15 (+12…+19) | 30 % | +7 (+4…+10) | 60.2 | +5 (+3…+8) |
| AROME HD, beach cell | 79 % | -0.2 | 2.5 | -0.2 (-0.3…-0.1) | 72 % | +6 (+4…+8) | 23 % | -0 (-3…+2) | 59.2 | +4 (+2…+7) |
| GFS, sea cell | 100 % | +0.5 | 2.7 | -0.0 (-0.1…+0.1) | 77 % | +11 (+8…+15) | 30 % | +7 (+4…+10) | 58.0 | +3 (-0…+6) |
| ECMWF 25 km, sea cell | 100 % | -0.7 | 2.9 | +0.2 (+0.1…+0.3) | 72 % | +6 (+2…+10) | 27 % | +4 (+0…+7) | 56.7 | +2 (-2…+5) |
| ICON-EU, sea cell | 95 % | -1.4 | 2.7 | +0.0 (-0.0…+0.1) | 62 % | -4 (-6…-1) | 17 % | -7 (-9…-4) | 55.5 | +0 (-2…+3) |
| ECMWF 9 km, sea cell | 100 % | -0.7 | 2.5 | -0.2 (-0.3…-0.1) | 66 % | +0 (-3…+3) | 23 % | -0 (-3…+2) | 55.2 | +0 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -0.8 | 2.7 |  | 66 % |  | 23 % |  | 55.0 |  |
| best match, beach cell | 100 % | -1.0 | 2.7 | -0.0 (-0.1…+0.0) | 62 % | -4 (-6…-1) | 21 % | -2 (-4…+0) | 53.4 | -2 (-4…+1) |
| Option 1 mix | 79 % | -1.3 | 2.6 | -0.1 (-0.2…-0.0) | 61 % | -5 (-8…-2) | 19 % | -4 (-8…-1) | 53.2 | -2 (-5…+1) |
| GFS, beach cell | 100 % | -0.9 | 2.9 | +0.2 (+0.1…+0.3) | 63 % | -3 (-8…+1) | 23 % | -0 (-4…+3) | 53.0 | -2 (-6…+2) |
| ICON seamless, sea cell | 100 % | -1.2 | 2.9 | +0.2 (+0.1…+0.2) | 61 % | -5 (-7…-3) | 20 % | -3 (-5…-1) | 52.9 | -2 (-4…-0) |
| ICON-EU, beach cell | 95 % | -2.1 | 3.0 | +0.3 (+0.3…+0.4) | 50 % | -16 (-19…-13) | 14 % | -10 (-12…-7) | 46.6 | -8 (-11…-5) |
| ICON seamless, beach cell | 100 % | -2.1 | 3.1 | +0.4 (+0.3…+0.4) | 49 % | -17 (-20…-14) | 15 % | -9 (-11…-6) | 45.1 | -10 (-13…-7) |
| ECMWF 9 km, beach cell | 100 % | -2.3 | 3.2 | +0.5 (+0.4…+0.6) | 45 % | -21 (-25…-17) | 12 % | -11 (-14…-8) | 42.7 | -12 (-16…-8) |
| ECMWF 25 km, beach cell | 100 % | -3.1 | 3.9 | +1.2 (+1.1…+1.3) | 35 % | -31 (-35…-26) | 18 % | -6 (-10…-2) | 32.8 | -22 (-26…-18) |

## Day ahead 1 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / ECMWF 9 km, sea cell + MF seamless, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix MF beach + ECMWF 9 km + GFS sea | 100 % | -0.5 | 2.4 | -0.7 (-0.8…-0.5) | 73 % | +7 (+4…+10) | 22 % | -4 (-7…-1) | 60.4 | +7 (+4…+10) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.4 | 2.5 | -0.6 (-0.7…-0.4) | 72 % | +6 (+3…+10) | 24 % | -2 (-5…+1) | 58.6 | +5 (+2…+9) |
| Mix MF beach + ECMWF 9 km sea | 100 % | -0.7 | 2.5 | -0.6 (-0.7…-0.5) | 68 % | +3 (-0…+6) | 21 % | -5 (-8…-2) | 57.9 | +5 (+2…+8) |
| Mean of best two | 100 % | -0.5 | 2.5 | -0.6 (-0.7…-0.4) | 70 % | +5 (+2…+8) | 23 % | -3 (-6…+1) | 57.8 | +5 (+2…+8) |
| MF seamless, sea cell | 100 % | +1.1 | 2.9 | -0.1 (-0.2…-0.0) | 81 % | +16 (+13…+19) | 36 % | +10 (+7…+13) | 56.0 | +3 (-0…+6) |
| MF seamless, beach cell | 100 % | -0.1 | 2.8 | -0.2 (-0.3…-0.1) | 71 % | +6 (+3…+9) | 28 % | +2 (-1…+4) | 55.8 | +3 (-0…+6) |
| ECMWF 25 km, sea cell | 100 % | -0.7 | 3.1 | -0.0 (-0.2…+0.1) | 69 % | +4 (-0…+8) | 27 % | +1 (-3…+5) | 54.9 | +2 (-2…+5) |
| AROME 2.5, beach cell | 79 % | -0.0 | 2.9 | -0.2 (-0.3…-0.1) | 74 % | +8 (+5…+11) | 32 % | +6 (+3…+8) | 54.8 | +2 (-1…+5) |
| AROME 2.5, sea cell | 79 % | -0.0 | 2.9 | -0.2 (-0.3…-0.1) | 74 % | +8 (+5…+11) | 32 % | +6 (+3…+8) | 54.8 | +2 (-1…+5) |
| GFS, sea cell | 100 % | +0.5 | 2.9 | -0.2 (-0.4…-0.1) | 75 % | +10 (+6…+14) | 34 % | +7 (+4…+11) | 54.6 | +1 (-2…+5) |
| ECMWF 9 km, sea cell | 100 % | -0.8 | 2.7 | -0.4 (-0.5…-0.2) | 65 % | -0 (-4…+3) | 23 % | -3 (-7…+1) | 54.5 | +1 (-2…+4) |
| AROME HD, sea cell | 79 % | +0.6 | 3.0 | -0.1 (-0.2…+0.0) | 77 % | +12 (+9…+15) | 35 % | +9 (+6…+12) | 54.4 | +1 (-1…+4) |
| AROME HD, beach cell | 79 % | -0.3 | 2.8 | -0.2 (-0.3…-0.1) | 69 % | +4 (+1…+7) | 29 % | +3 (+0…+5) | 53.9 | +1 (-2…+3) |
| **best match, sea cell** (today) | 100 % | -0.7 | 3.1 |  | 65 % |  | 26 % |  | 53.2 |  |
| Option 1 mix | 79 % | -1.4 | 2.8 | -0.3 (-0.3…-0.2) | 60 % | -5 (-8…-2) | 20 % | -6 (-10…-3) | 52.7 | -1 (-4…+2) |
| ICON-EU, sea cell | 95 % | -1.5 | 3.0 | -0.1 (-0.2…-0.0) | 60 % | -5 (-8…-3) | 20 % | -6 (-9…-3) | 52.3 | -1 (-3…+1) |
| ICON seamless, sea cell | 100 % | -1.3 | 3.2 | +0.1 (+0.0…+0.1) | 60 % | -5 (-7…-4) | 23 % | -3 (-5…-1) | 51.0 | -2 (-4…-1) |
| GFS, beach cell | 100 % | -1.0 | 3.1 | +0.0 (-0.1…+0.2) | 62 % | -4 (-9…+1) | 26 % | -0 (-3…+3) | 50.8 | -2 (-7…+1) |
| best match, beach cell | 100 % | -1.2 | 3.1 | -0.0 (-0.1…+0.1) | 58 % | -7 (-10…-5) | 24 % | -2 (-4…+1) | 49.1 | -4 (-6…-2) |
| ICON-EU, beach cell | 95 % | -2.2 | 3.2 | +0.1 (+0.0…+0.2) | 49 % | -16 (-20…-13) | 14 % | -12 (-16…-9) | 45.5 | -8 (-10…-5) |
| ICON seamless, beach cell | 100 % | -2.1 | 3.3 | +0.2 (+0.1…+0.3) | 48 % | -18 (-21…-15) | 17 % | -9 (-13…-6) | 43.6 | -10 (-13…-7) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.3 | +0.2 (+0.1…+0.3) | 44 % | -21 (-25…-17) | 13 % | -13 (-18…-9) | 41.6 | -12 (-16…-8) |
| ECMWF 25 km, beach cell | 100 % | -3.1 | 3.9 | +0.9 (+0.7…+1.0) | 35 % | -30 (-35…-26) | 17 % | -9 (-14…-5) | 32.7 | -20 (-24…-16) |

## Day ahead 2 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell / ECMWF 9 km, sea cell + MF seamless, beach cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 99 % | +0.6 | 3.2 | +0.1 (-0.0…+0.3) | 77 % | +12 (+8…+16) | 34 % | +10 (+7…+13) | 55.1 | +2 (-1…+5) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.5 | 2.7 | -0.4 (-0.5…-0.3) | 68 % | +4 (-0…+7) | 27 % | +3 (+0…+6) | 54.5 | +1 (-3…+4) |
| Mix MF beach + ECMWF 9 km + GFS sea | 99 % | -0.9 | 2.7 | -0.4 (-0.6…-0.3) | 64 % | -1 (-4…+3) | 21 % | -3 (-6…+1) | 54.3 | +1 (-3…+4) |
| MF seamless, beach cell | 99 % | -1.2 | 3.1 | -0.0 (-0.1…+0.1) | 63 % | -2 (-5…+2) | 21 % | -3 (-6…+0) | 53.8 | +0 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -1.0 | 3.1 |  | 64 % |  | 24 % |  | 53.6 |  |
| AROME HD, beach cell | 0 % | -1.0 | 3.1 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 24 % | +0 (+0…+0) | 53.6 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.0 | 3.1 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 24 % | +0 (+0…+0) | 53.6 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.0 | 3.1 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 24 % | +0 (+0…+0) | 53.6 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.0 | 3.1 | +0.0 (+0.0…+0.0) | 64 % | +0 (+0…+0) | 24 % | +0 (+0…+0) | 53.6 | +0 (+0…+0) |
| Mean of best two | 99 % | -0.8 | 2.7 | -0.4 (-0.5…-0.3) | 65 % | +0 (-3…+4) | 25 % | +1 (-2…+3) | 53.6 | -0 (-3…+3) |
| Mix MF beach + ECMWF 9 km sea | 99 % | -1.2 | 2.7 | -0.4 (-0.5…-0.3) | 61 % | -3 (-6…+0) | 19 % | -5 (-7…-2) | 53.4 | -0 (-3…+3) |
| GFS, sea cell | 100 % | +0.4 | 3.1 | -0.0 (-0.2…+0.1) | 73 % | +9 (+5…+12) | 35 % | +11 (+8…+15) | 52.4 | -1 (-5…+2) |
| ECMWF 25 km, sea cell | 100 % | -0.8 | 3.2 | +0.0 (-0.1…+0.2) | 68 % | +3 (+0…+7) | 30 % | +6 (+3…+9) | 52.3 | -1 (-4…+2) |
| ECMWF 9 km, sea cell | 100 % | -0.9 | 2.8 | -0.3 (-0.4…-0.2) | 63 % | -1 (-4…+2) | 26 % | +2 (-2…+5) | 51.9 | -2 (-4…+1) |
| ICON seamless, sea cell | 100 % | -1.5 | 3.1 | +0.0 (-0.0…+0.1) | 59 % | -5 (-7…-3) | 20 % | -4 (-5…-2) | 51.6 | -2 (-4…-0) |
| ICON-EU, sea cell | 95 % | -1.5 | 3.1 | +0.0 (-0.0…+0.1) | 59 % | -5 (-7…-4) | 20 % | -4 (-5…-2) | 51.4 | -2 (-4…-0) |
| Option 1 mix | 0 % | -1.8 | 3.1 | -0.0 (-0.1…+0.1) | 57 % | -8 (-11…-4) | 18 % | -6 (-9…-2) | 50.4 | -3 (-6…-0) |
| GFS, beach cell | 100 % | -1.1 | 3.4 | +0.3 (+0.1…+0.4) | 55 % | -9 (-14…-5) | 30 % | +6 (+3…+10) | 44.5 | -9 (-13…-6) |
| ICON-EU, beach cell | 95 % | -2.2 | 3.3 | +0.2 (+0.1…+0.3) | 48 % | -17 (-19…-14) | 16 % | -8 (-11…-5) | 43.9 | -10 (-12…-7) |
| best match, beach cell | 100 % | -2.0 | 3.3 | +0.2 (+0.1…+0.3) | 49 % | -15 (-19…-12) | 19 % | -5 (-7…-2) | 43.8 | -10 (-13…-7) |
| ICON seamless, beach cell | 100 % | -2.3 | 3.4 | +0.3 (+0.2…+0.4) | 45 % | -20 (-23…-16) | 17 % | -7 (-10…-5) | 41.1 | -12 (-16…-10) |
| ECMWF 9 km, beach cell | 100 % | -2.4 | 3.4 | +0.3 (+0.2…+0.4) | 43 % | -21 (-25…-18) | 15 % | -9 (-13…-6) | 40.1 | -13 (-17…-10) |
| ECMWF 25 km, beach cell | 100 % | -3.1 | 4.0 | +0.9 (+0.8…+1.1) | 35 % | -30 (-34…-25) | 20 % | -4 (-8…+1) | 32.1 | -21 (-26…-17) |

## Day ahead 3 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + best match, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| MF seamless, sea cell | 98 % | +0.5 | 3.5 | +0.2 (+0.1…+0.4) | 72 % | +10 (+7…+14) | 37 % | +10 (+7…+13) | 51.0 | +0 (-3…+3) |
| Mean of best two | 100 % | -1.3 | 3.0 | -0.3 (-0.4…-0.2) | 60 % | -2 (-4…+0) | 23 % | -3 (-6…-1) | 50.9 | +0 (-2…+2) |
| **best match, sea cell** (today) | 100 % | -1.1 | 3.3 |  | 62 % |  | 27 % |  | 50.7 |  |
| AROME HD, beach cell | 0 % | -1.1 | 3.3 | +0.0 (+0.0…+0.0) | 62 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 50.7 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.1 | 3.3 | +0.0 (+0.0…+0.0) | 62 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 50.7 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.1 | 3.3 | +0.0 (+0.0…+0.0) | 62 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 50.7 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.1 | 3.3 | +0.0 (+0.0…+0.0) | 62 % | +0 (+0…+0) | 27 % | +0 (+0…+0) | 50.7 | +0 (+0…+0) |
| ECMWF 9 km, sea cell | 100 % | -1.0 | 3.1 | -0.3 (-0.4…-0.1) | 62 % | -0 (-4…+3) | 27 % | -0 (-3…+3) | 50.5 | -0 (-3…+3) |
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.6 | 2.9 | -0.4 (-0.5…-0.3) | 63 % | +1 (-3…+4) | 28 % | +1 (-2…+4) | 50.5 | -0 (-3…+3) |
| Mix MF beach + ECMWF 9 km + GFS sea | 98 % | -1.0 | 2.8 | -0.5 (-0.6…-0.3) | 60 % | -2 (-6…+1) | 24 % | -3 (-6…+0) | 50.3 | -0 (-4…+3) |
| Mix MF beach + ECMWF 9 km sea | 98 % | -1.3 | 2.9 | -0.4 (-0.5…-0.2) | 58 % | -4 (-7…-1) | 22 % | -5 (-8…-2) | 49.9 | -1 (-4…+2) |
| ECMWF 25 km, sea cell | 100 % | -0.9 | 3.4 | +0.1 (-0.0…+0.3) | 63 % | +1 (-3…+5) | 31 % | +4 (+1…+7) | 49.6 | -1 (-4…+2) |
| ICON seamless, sea cell | 100 % | -1.7 | 3.4 | +0.1 (-0.0…+0.1) | 57 % | -5 (-7…-3) | 23 % | -4 (-6…-2) | 49.0 | -2 (-4…+0) |
| ICON-EU, sea cell | 95 % | -1.7 | 3.4 | +0.1 (-0.0…+0.2) | 57 % | -5 (-7…-3) | 23 % | -4 (-6…-2) | 49.0 | -2 (-4…+0) |
| MF seamless, beach cell | 98 % | -1.2 | 3.3 | -0.0 (-0.1…+0.1) | 58 % | -5 (-8…-1) | 26 % | -0 (-4…+3) | 47.8 | -3 (-6…+0) |
| GFS, sea cell | 100 % | +0.2 | 3.3 | +0.0 (-0.1…+0.2) | 66 % | +4 (+0…+8) | 38 % | +11 (+8…+15) | 47.2 | -3 (-6…-1) |
| Option 1 mix | 0 % | -2.0 | 3.3 | -0.0 (-0.2…+0.1) | 52 % | -10 (-14…-7) | 21 % | -6 (-9…-2) | 45.4 | -5 (-9…-2) |
| GFS, beach cell | 100 % | -1.1 | 3.5 | +0.2 (+0.1…+0.4) | 53 % | -9 (-14…-5) | 32 % | +5 (+1…+9) | 42.6 | -8 (-12…-4) |
| ICON-EU, beach cell | 95 % | -2.3 | 3.5 | +0.2 (+0.1…+0.3) | 45 % | -18 (-21…-15) | 20 % | -6 (-10…-3) | 40.0 | -11 (-14…-8) |
| ECMWF 9 km, beach cell | 100 % | -2.5 | 3.5 | +0.2 (+0.1…+0.4) | 43 % | -19 (-23…-16) | 17 % | -10 (-14…-6) | 39.4 | -11 (-15…-8) |
| best match, beach cell | 100 % | -2.1 | 3.6 | +0.2 (+0.2…+0.3) | 44 % | -18 (-21…-15) | 24 % | -2 (-5…+1) | 38.7 | -12 (-15…-9) |
| ICON seamless, beach cell | 100 % | -2.5 | 3.7 | +0.4 (+0.3…+0.5) | 41 % | -21 (-24…-18) | 21 % | -5 (-9…-2) | 37.1 | -14 (-17…-10) |
| ECMWF 25 km, beach cell | 100 % | -3.2 | 4.1 | +0.8 (+0.7…+1.0) | 32 % | -30 (-34…-26) | 21 % | -5 (-10…-1) | 29.3 | -21 (-25…-18) |

## Day ahead 4 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.8 | 3.2 | -0.5 (-0.6…-0.4) | 58 % | +4 (+0…+7) | 30 % | -2 (-5…+1) | 46.1 | +3 (+0…+6) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -0.8 | 3.2 | -0.5 (-0.6…-0.4) | 58 % | +4 (+0…+7) | 30 % | -2 (-5…+1) | 46.1 | +3 (+0…+6) |
| Mean of best two | 100 % | -0.8 | 3.2 | -0.5 (-0.6…-0.4) | 58 % | +4 (+0…+7) | 30 % | -2 (-5…+1) | 46.1 | +3 (+0…+6) |
| ECMWF 25 km, sea cell | 100 % | -1.0 | 3.7 | +0.0 (-0.1…+0.1) | 60 % | +6 (+2…+10) | 35 % | +3 (-0…+6) | 45.2 | +2 (-1…+6) |
| ECMWF 9 km, sea cell | 100 % | -1.2 | 3.4 | -0.3 (-0.4…-0.1) | 57 % | +3 (-1…+6) | 31 % | -1 (-5…+2) | 45.1 | +2 (-1…+5) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -1.2 | 3.4 | -0.3 (-0.4…-0.1) | 57 % | +3 (-1…+6) | 31 % | -1 (-5…+2) | 45.1 | +2 (-1…+5) |
| GFS, sea cell | 100 % | +0.3 | 3.6 | -0.1 (-0.2…+0.1) | 65 % | +11 (+7…+16) | 42 % | +10 (+6…+14) | 44.1 | +1 (-2…+5) |
| **best match, sea cell** (today) | 100 % | -1.4 | 3.7 |  | 54 % |  | 32 % |  | 42.8 |  |
| MF seamless, beach cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.4 | 3.7 | +0.0 (+0.0…+0.0) | 54 % | +0 (+0…+0) | 32 % | +0 (+0…+0) | 42.8 | +0 (+0…+0) |
| ICON seamless, sea cell | 100 % | -1.6 | 3.7 | +0.1 (+0.0…+0.1) | 53 % | -1 (-3…+1) | 30 % | -2 (-4…-0) | 42.8 | -0 (-2…+2) |
| ICON-EU, sea cell | 95 % | -1.6 | 3.7 | +0.1 (+0.0…+0.1) | 53 % | -1 (-3…+1) | 30 % | -2 (-4…-0) | 42.8 | -0 (-2…+2) |
| Option 1 mix | 0 % | -2.0 | 3.5 | -0.1 (-0.3…-0.0) | 47 % | -7 (-10…-3) | 26 % | -6 (-9…-3) | 40.4 | -2 (-6…+1) |
| ICON-EU, beach cell | 95 % | -2.3 | 3.8 | +0.2 (+0.1…+0.2) | 45 % | -9 (-11…-6) | 26 % | -7 (-9…-4) | 39.2 | -4 (-6…-1) |
| GFS, beach cell | 100 % | -1.1 | 3.8 | +0.1 (-0.1…+0.2) | 50 % | -4 (-8…+0) | 36 % | +3 (-1…+8) | 39.2 | -4 (-7…-0) |
| ICON seamless, beach cell | 100 % | -2.4 | 4.0 | +0.3 (+0.2…+0.4) | 42 % | -11 (-15…-9) | 27 % | -6 (-8…-3) | 36.7 | -6 (-9…-4) |
| ECMWF 9 km, beach cell | 100 % | -2.7 | 3.9 | +0.2 (+0.0…+0.3) | 38 % | -16 (-20…-11) | 20 % | -12 (-17…-8) | 34.9 | -8 (-12…-4) |
| best match, beach cell | 100 % | -2.5 | 4.0 | +0.3 (+0.2…+0.4) | 38 % | -15 (-19…-12) | 26 % | -6 (-10…-3) | 33.8 | -9 (-12…-6) |
| ECMWF 25 km, beach cell | 100 % | -3.2 | 4.3 | +0.7 (+0.5…+0.8) | 30 % | -24 (-29…-20) | 26 % | -6 (-11…-1) | 26.7 | -16 (-20…-12) |

## Day ahead 5 — 2618 spot-days, 84 dates, 788 measured go days

Mean of best two picked: ECMWF 9 km, sea cell + GFS, sea cell

| Source | Coverage | Bias kn | MAE kn | Δ MAE | Caught | Δ caught | False go | Δ false go | CSI | Δ CSI |
|---|---|---|---|---|---|---|---|---|---|---|
| Mix ECMWF 9 km + GFS, sea | 100 % | -0.7 | 3.3 | -0.7 (-0.8…-0.5) | 60 % | +5 (+1…+8) | 33 % | -2 (-6…+1) | 46.4 | +4 (+1…+7) |
| Mix MF beach + ECMWF 9 km + GFS sea | 0 % | -0.7 | 3.3 | -0.7 (-0.8…-0.5) | 60 % | +5 (+1…+8) | 33 % | -2 (-6…+1) | 46.4 | +4 (+1…+7) |
| Mean of best two | 100 % | -0.7 | 3.3 | -0.7 (-0.8…-0.5) | 60 % | +5 (+1…+8) | 33 % | -2 (-6…+1) | 46.4 | +4 (+1…+7) |
| GFS, sea cell | 100 % | +0.1 | 3.8 | -0.2 (-0.4…+0.0) | 63 % | +8 (+4…+12) | 42 % | +7 (+3…+11) | 43.3 | +1 (-2…+4) |
| ECMWF 9 km, sea cell | 100 % | -0.9 | 3.7 | -0.3 (-0.5…-0.2) | 56 % | +1 (-3…+4) | 35 % | -0 (-4…+3) | 42.9 | +1 (-3…+3) |
| Mix MF beach + ECMWF 9 km sea | 0 % | -0.9 | 3.7 | -0.3 (-0.5…-0.2) | 56 % | +1 (-3…+4) | 35 % | -0 (-4…+3) | 42.9 | +1 (-3…+3) |
| **best match, sea cell** (today) | 100 % | -1.2 | 4.0 |  | 55 % |  | 35 % |  | 42.3 |  |
| MF seamless, beach cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| MF seamless, sea cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| AROME HD, beach cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| AROME HD, sea cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| AROME 2.5, beach cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| AROME 2.5, sea cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| ICON-EU, beach cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| ICON-EU, sea cell | 0 % | -1.2 | 4.0 | +0.0 (+0.0…+0.0) | 55 % | +0 (+0…+0) | 35 % | +0 (+0…+0) | 42.3 | +0 (+0…+0) |
| ECMWF 25 km, sea cell | 100 % | -0.7 | 4.0 | +0.0 (-0.1…+0.2) | 58 % | +3 (-1…+6) | 39 % | +4 (+0…+8) | 42.1 | -0 (-4…+3) |
| ICON seamless, sea cell | 100 % | -1.3 | 4.2 | +0.2 (+0.1…+0.3) | 54 % | -1 (-3…+1) | 36 % | +1 (-1…+3) | 41.3 | -1 (-3…+1) |
| GFS, beach cell | 100 % | -1.3 | 4.1 | +0.1 (-0.1…+0.3) | 48 % | -7 (-11…-2) | 38 % | +3 (-2…+7) | 37.3 | -5 (-9…-1) |
| Option 1 mix | 0 % | -2.0 | 3.8 | -0.2 (-0.3…-0.0) | 44 % | -11 (-14…-8) | 31 % | -4 (-7…-1) | 37.0 | -5 (-8…-3) |
| ECMWF 9 km, beach cell | 100 % | -2.5 | 4.0 | +0.0 (-0.1…+0.2) | 40 % | -15 (-19…-12) | 24 % | -11 (-15…-7) | 35.4 | -7 (-11…-3) |
| ICON seamless, beach cell | 100 % | -2.6 | 4.4 | +0.4 (+0.2…+0.5) | 39 % | -16 (-19…-12) | 29 % | -6 (-10…-3) | 34.0 | -8 (-12…-5) |
| best match, beach cell | 100 % | -2.5 | 4.2 | +0.2 (+0.1…+0.3) | 38 % | -17 (-21…-14) | 27 % | -9 (-12…-5) | 33.1 | -9 (-12…-6) |
| ECMWF 25 km, beach cell | 100 % | -3.0 | 4.5 | +0.5 (+0.3…+0.6) | 31 % | -24 (-28…-20) | 31 % | -4 (-8…+1) | 27.1 | -15 (-19…-12) |

## Summary: winner per day ahead

Winner = highest CSI among sources (and mixes) that answered themselves on ≥ 90 % of spot-days; 'real' when its CSI gain interval excludes 0.

| Day ahead | Today: CSI / MAE / bias | Best on CSI | CSI gain | MAE gain | Real? | Best on MAE | MAE gain |
|---|---|---|---|---|---|---|---|
| 0 | 55 / 2.7 / -0.8 | Mean of best two | +8 (+6…+11) | -0.5 | yes | Mix MF beach + ECMWF 9 km + GFS sea | -0.5 (-0.6…-0.5) |
| 1 | 53 / 3.1 / -0.7 | Mix MF beach + ECMWF 9 km + GFS sea | +7 (+4…+10) | -0.7 | yes | Mix MF beach + ECMWF 9 km + GFS sea | -0.7 (-0.8…-0.5) |
| 2 | 54 / 3.1 / -1.0 | MF seamless, sea cell | +2 (-1…+5) | +0.1 | no (tie) | Mix MF beach + ECMWF 9 km + GFS sea | -0.4 (-0.6…-0.3) |
| 3 | 51 / 3.3 / -1.1 | MF seamless, sea cell | +0 (-3…+3) | +0.2 | no (tie) | Mix MF beach + ECMWF 9 km + GFS sea | -0.5 (-0.6…-0.3) |
| 4 | 43 / 3.7 / -1.4 | Mix ECMWF 9 km + GFS, sea | +3 (+0…+6) | -0.5 | yes | Mix ECMWF 9 km + GFS, sea | -0.5 (-0.6…-0.4) |
| 5 | 42 / 4.0 / -1.2 | Mix ECMWF 9 km + GFS, sea | +4 (+1…+7) | -0.7 | yes | Mix ECMWF 9 km + GFS, sea | -0.7 (-0.8…-0.5) |

## Per group, top 3 on CSI and today


### Day ahead 0

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 19 / 2.9 / -2.2 | AROME HD, sea cell 66 / 1.9 / +0.2 | AROME 2.5, beach cell 56 / 2.0 / -1.2 | AROME 2.5, sea cell 56 / 2.0 / -1.2 |
| Canaries | 166 | 87 | 72 / 4.2 / -3.9 | GFS, sea cell 78 / 2.9 / -2.1 | MF seamless, sea cell 78 / 2.1 / -0.1 | Mix ECMWF 9 km + GFS, sea 77 / 2.5 / -2.0 |
| France | 1593 | 453 | 56 / 2.8 / -0.3 | Mix MF beach + ECMWF 9 km + GFS sea 67 / 2.1 / +0.1 | Mix MF beach + ECMWF 9 km sea 67 / 2.1 / -0.1 | Mix ECMWF 9 km + GFS, sea 65 / 2.3 / +0.1 |
| Mainland Spain (south masts) | 391 | 52 | 33 / 2.2 / -0.9 | GFS, beach cell 45 / 2.2 / +0.4 | GFS, sea cell 44 / 2.4 / +1.1 | Mean of best two 43 / 2.2 / +0.6 |
| Near-shore buoy (POEM) | 146 | 70 | 53 / 2.3 / -1.5 | AROME HD, sea cell 65 / 2.3 / -0.1 | AROME 2.5, beach cell 63 / 2.2 / -0.9 | AROME 2.5, sea cell 63 / 2.2 / -0.9 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 69 / 1.8 / -0.2 | MF seamless, beach cell 83 / 1.5 / +0.3 | MF seamless, sea cell 83 / 1.5 / +0.3 | Mean of best two 83 / 1.5 / +0.3 |

### Day ahead 1

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 14 / 3.4 / -2.5 | MF seamless, sea cell 47 / 2.3 / -0.2 | AROME HD, sea cell 47 / 2.3 / -0.2 | AROME 2.5, beach cell 46 / 2.5 / -1.4 |
| Canaries | 166 | 87 | 67 / 4.5 / -4.0 | Mix MF beach + ECMWF 9 km + GFS sea 79 / 3.2 / -2.8 | ECMWF 9 km, sea cell 78 / 2.7 / -2.1 | Mix ECMWF 9 km + GFS, sea 77 / 2.9 / -2.3 |
| France | 1593 | 453 | 55 / 3.1 / -0.3 | Mix MF beach + ECMWF 9 km + GFS sea 62 / 2.4 / -0.0 | Mix ECMWF 9 km + GFS, sea 61 / 2.4 / +0.1 | Mix MF beach + ECMWF 9 km sea 61 / 2.4 / -0.3 |
| Mainland Spain (south masts) | 391 | 52 | 26 / 2.4 / -0.9 | Mix MF beach + ECMWF 9 km + GFS sea 48 / 2.0 / +0.0 | GFS, beach cell 47 / 2.3 / +0.4 | MF seamless, sea cell 45 / 2.7 / +1.1 |
| Near-shore buoy (POEM) | 146 | 70 | 54 / 3.2 / +0.2 | AROME 2.5, beach cell 55 / 3.0 / -0.5 | AROME 2.5, sea cell 55 / 3.0 / -0.5 | best match, sea cell 54 / 3.2 / +0.2 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 73 / 2.2 / -0.4 | ECMWF 25 km, beach cell 74 / 2.2 / -0.1 | ECMWF 25 km, sea cell 74 / 2.2 / -0.1 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 1.9 / -0.2 |

### Day ahead 2

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 22 / 3.3 / -2.3 | MF seamless, sea cell 52 / 2.6 / +0.2 | MF seamless, beach cell 35 / 2.8 / -1.6 | GFS, sea cell 34 / 3.1 / +0.3 |
| Canaries | 166 | 87 | 67 / 4.7 / -4.1 | Mix ECMWF 9 km + GFS, sea 75 / 3.0 / -2.5 | MF seamless, beach cell 74 / 3.7 / -3.2 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 3.2 / -2.9 |
| France | 1593 | 453 | 57 / 3.1 / -0.5 | Option 1 mix 58 / 2.8 / -1.4 | Mix MF beach + ECMWF 9 km + GFS sea 57 / 2.6 / -0.7 | Mix ECMWF 9 km + GFS, sea 57 / 2.7 / -0.1 |
| Mainland Spain (south masts) | 391 | 52 | 22 / 2.6 / -1.0 | GFS, beach cell 45 / 2.5 / +0.2 | GFS, sea cell 43 / 2.6 / +0.8 | ECMWF 25 km, sea cell 41 / 2.2 / +0.2 |
| Near-shore buoy (POEM) | 146 | 70 | 48 / 3.4 / -2.0 | best match, sea cell 48 / 3.4 / -2.0 | MF seamless, sea cell 48 / 3.4 / -2.0 | AROME HD, beach cell 48 / 3.4 / -2.0 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 67 / 2.6 / -0.3 | Option 1 mix 73 / 2.2 / -0.7 | Mix MF beach + ECMWF 9 km sea 71 / 2.2 / -0.0 | ECMWF 25 km, beach cell 70 / 2.4 / -0.3 |

### Day ahead 3

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | MF seamless, sea cell 34 / 3.2 / -0.7 | MF seamless, beach cell 26 / 3.0 / -1.8 | GFS, sea cell 25 / 3.4 / -0.1 |
| Canaries | 166 | 87 | 70 / 4.8 / -4.2 | Mix MF beach + ECMWF 9 km sea 76 / 3.4 / -2.9 | MF seamless, beach cell 75 / 3.9 / -3.4 | MF seamless, sea cell 74 / 3.1 / -0.1 |
| France | 1593 | 453 | 53 / 3.3 / -0.8 | ECMWF 25 km, sea cell 55 / 3.3 / -0.4 | Mean of best two 54 / 3.0 / -1.0 | ECMWF 9 km, sea cell 54 / 3.1 / -0.7 |
| Mainland Spain (south masts) | 391 | 52 | 19 / 2.7 / -0.9 | GFS, beach cell 48 / 2.6 / +0.2 | MF seamless, sea cell 38 / 3.1 / +1.1 | MF seamless, beach cell 38 / 3.0 / +0.3 |
| Near-shore buoy (POEM) | 146 | 70 | 45 / 3.2 / -1.5 | best match, sea cell 45 / 3.2 / -1.5 | MF seamless, sea cell 45 / 3.2 / -1.5 | AROME HD, beach cell 45 / 3.2 / -1.5 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 65 / 2.9 / +0.0 | Option 1 mix 69 / 2.5 / -0.8 | Mean of best two 68 / 2.5 / -0.7 | ICON seamless, beach cell 66 / 2.9 / +0.0 |

### Day ahead 4

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 18 / 3.6 / -2.4 | ECMWF 25 km, sea cell 28 / 3.7 / -2.0 | GFS, beach cell 18 / 3.4 / -0.5 | best match, sea cell 18 / 3.6 / -2.4 |
| Canaries | 166 | 87 | 63 / 4.9 / -4.3 | Mix ECMWF 9 km + GFS, sea 74 / 3.2 / -2.2 | Mix MF beach + ECMWF 9 km + GFS sea 74 / 3.2 / -2.2 | Mean of best two 74 / 3.2 / -2.2 |
| France | 1593 | 453 | 44 / 3.6 / -1.1 | ECMWF 25 km, sea cell 49 / 3.5 / -0.5 | Mix ECMWF 9 km + GFS, sea 49 / 3.1 / -0.4 | Mix MF beach + ECMWF 9 km + GFS sea 49 / 3.1 / -0.4 |
| Mainland Spain (south masts) | 391 | 52 | 16 / 3.1 / -0.9 | GFS, beach cell 40 / 2.8 / +0.2 | Mix ECMWF 9 km + GFS, sea 32 / 2.6 / -0.2 | Mix MF beach + ECMWF 9 km + GFS sea 32 / 2.6 / -0.2 |
| Near-shore buoy (POEM) | 146 | 70 | 33 / 4.5 / -3.3 | ECMWF 25 km, sea cell 41 / 4.1 / -2.5 | ICON seamless, sea cell 36 / 4.6 / -3.8 | ICON-EU, sea cell 36 / 4.6 / -3.8 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 56 / 3.6 / +0.1 | best match, beach cell 56 / 3.6 / +0.1 | best match, sea cell 56 / 3.6 / +0.1 | MF seamless, beach cell 56 / 3.6 / +0.1 |

### Day ahead 5

| Group | Spot-days | Go days | Today CSI / MAE / bias | 1st | 2nd | 3rd |
|---|---|---|---|---|---|---|
| Barcelona (airport, Bocana Sud) | 157 | 50 | 9 / 3.9 / -2.6 | ECMWF 25 km, sea cell 18 / 3.9 / -2.2 | GFS, beach cell 17 / 3.5 / -0.9 | GFS, sea cell 17 / 3.5 / -0.2 |
| Canaries | 166 | 87 | 61 / 4.8 / -4.2 | ECMWF 9 km, sea cell 72 / 3.1 / -2.4 | Mix MF beach + ECMWF 9 km sea 72 / 3.1 / -2.4 | GFS, sea cell 68 / 3.5 / -2.2 |
| France | 1593 | 453 | 44 / 4.1 / -0.8 | Mix ECMWF 9 km + GFS, sea 49 / 3.3 / -0.4 | Mix MF beach + ECMWF 9 km + GFS sea 49 / 3.3 / -0.4 | Mean of best two 49 / 3.3 / -0.4 |
| Mainland Spain (south masts) | 391 | 52 | 18 / 3.2 / -1.1 | GFS, beach cell 36 / 2.8 / +0.4 | Mix ECMWF 9 km + GFS, sea 33 / 2.8 / +0.0 | Mix MF beach + ECMWF 9 km + GFS sea 33 / 2.8 / +0.0 |
| Near-shore buoy (POEM) | 146 | 70 | 34 / 4.5 / -2.7 | ECMWF 25 km, sea cell 52 / 3.9 / -1.7 | best match, sea cell 34 / 4.5 / -2.7 | MF seamless, beach cell 34 / 4.5 / -2.7 |
| Open-sea buoys (Begur, Tarragona) | 165 | 76 | 60 / 4.0 / +0.1 | best match, beach cell 60 / 4.0 / +0.1 | best match, sea cell 60 / 4.0 / +0.1 | MF seamless, beach cell 60 / 4.0 / +0.1 |
