# WHE-80: one correction learned from measurements, the same at every spot

Hours 07–17 UTC, 2026-08-08 … 2026-10-30 (Catalan test to 10-25), days ahead 0–5 (buoys 0–2). 214323 station-hours × day ahead. Fitting stations: 28 (France: 18, Mainland Spain (south masts): 5, Canaries: 2, Near-shore buoy (POEM): 1, Open-sea buoys (Begur, Tarragona): 2). Every hour is corrected with numbers fitted on the other weeks and without its own station (except 'station seen'). Speed-band shrink weight 300 h.

Methods: **speed bands** = add the mean miss for this model, day ahead, forecast speed band and direction vs the beach (classic MOS); **one factor** = multiply by measured ÷ forecast for this model, day ahead and direction; **quantile map** = map the forecast's place in its own spread to the same place in the measured spread (model, day ahead, direction).

## All fitting stations (trusted masts + buoys)

Wind shown = best match, sea cell. MAE = mean absolute error, bias = forecast − measured (kn), Δ MAE 95 % = interval over dates. Kiteable hour = 12–28 kn not offshore: caught / false. Storm = hours measured 25 kn+ shown under 20 kn. Go = WHE-82 chance with its cut-offs unchanged: came true · wrong Go · real go days caught.

| Day ahead | Method | MAE | Δ MAE 95 % | MAE 10 kn+ | Bias | Kiteable caught | False | Storm read < 20 kn | Go came true | Wrong Go | Go days caught |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | today (no correction) | **2.7** |  | 3.7 | -0.3 | 64 % | 32 % | 25 % (547 h) | 86 % | 69 of 510 | 441 of 732 |
| 0 | speed bands, station seen | **2.6** | -0.16 … -0.11 | 3.6 | +0.0 | 65 % | 32 % | 43 % (547 h) |  | |  |
| 0 | speed bands | **2.7** | -0.08 … -0.03 | 3.7 | +0.0 | 63 % | 33 % | 46 % (547 h) | 86 % | 70 of 506 | 436 of 732 |
| 0 | one factor | **2.9** | +0.10 … +0.15 | 3.9 | +0.0 | 65 % | 35 % | 25 % (547 h) | 84 % | 95 of 576 | 481 of 732 |
| 0 | quantile map | **2.8** | +0.06 … +0.13 | 3.9 | -0.0 | 64 % | 34 % | 34 % (547 h) | 84 % | 91 of 559 | 468 of 732 |
| 0 | own station's mean miss (needs a station) | **2.4** | -0.35 … -0.28 | 3.1 | -0.1 | 70 % | 29 % | 13 % (547 h) |  | |  |
| 1 | today (no correction) | **3.0** |  | 4.1 | -0.3 | 61 % | 37 % | 28 % (547 h) | 88 % | 54 of 432 | 378 of 732 |
| 1 | speed bands, station seen | **2.8** | -0.22 … -0.16 | 3.8 | +0.1 | 58 % | 36 % | 47 % (547 h) |  | |  |
| 1 | speed bands | **2.9** | -0.15 … -0.09 | 4.0 | +0.1 | 56 % | 37 % | 50 % (547 h) | 87 % | 54 of 409 | 355 of 732 |
| 1 | one factor | **3.1** | +0.09 … +0.14 | 4.3 | +0.0 | 62 % | 39 % | 27 % (547 h) | 83 % | 84 of 507 | 423 of 732 |
| 1 | quantile map | **3.1** | +0.03 … +0.09 | 4.3 | -0.0 | 59 % | 39 % | 36 % (547 h) | 84 % | 79 of 486 | 407 of 732 |
| 1 | own station's mean miss (needs a station) | **2.7** | -0.33 … -0.26 | 3.6 | -0.1 | 67 % | 34 % | 13 % (547 h) |  | |  |
| 2 | today (no correction) | **3.1** |  | 4.2 | -0.3 | 60 % | 36 % | 24 % (547 h) | 86 % | 58 of 426 | 368 of 732 |
| 2 | speed bands, station seen | **2.9** | -0.26 … -0.19 | 3.9 | +0.1 | 55 % | 34 % | 40 % (547 h) |  | |  |
| 2 | speed bands | **3.0** | -0.19 … -0.12 | 4.0 | +0.1 | 54 % | 35 % | 41 % (547 h) | 86 % | 59 of 422 | 363 of 732 |
| 2 | one factor | **3.2** | +0.07 … +0.11 | 4.4 | +0.0 | 62 % | 39 % | 24 % (547 h) | 82 % | 97 of 547 | 450 of 732 |
| 2 | quantile map | **3.2** | +0.02 … +0.10 | 4.4 | +0.0 | 59 % | 38 % | 34 % (547 h) | 83 % | 88 of 518 | 430 of 732 |
| 2 | own station's mean miss (needs a station) | **2.9** | -0.25 … -0.19 | 3.8 | -0.1 | 63 % | 34 % | 14 % (547 h) |  | |  |
| 3 | today (no correction) | **3.3** |  | 4.5 | -0.4 | 55 % | 40 % | 33 % (480 h) | 89 % | 29 of 256 | 227 of 656 |
| 3 | speed bands, station seen | **3.1** | -0.30 … -0.21 | 4.1 | +0.1 | 52 % | 39 % | 53 % (480 h) |  | |  |
| 3 | speed bands | **3.1** | -0.23 … -0.14 | 4.2 | +0.1 | 50 % | 40 % | 54 % (480 h) | 87 % | 32 of 250 | 218 of 656 |
| 3 | one factor | **3.4** | +0.10 … +0.16 | 4.7 | +0.0 | 59 % | 44 % | 29 % (480 h) | 82 % | 65 of 366 | 301 of 656 |
| 3 | quantile map | **3.4** | +0.01 … +0.08 | 4.6 | +0.0 | 55 % | 43 % | 40 % (480 h) | 83 % | 60 of 345 | 285 of 656 |
| 3 | own station's mean miss (needs a station) | **3.1** | -0.26 … -0.20 | 4.1 | -0.2 | 60 % | 37 % | 24 % (480 h) |  | |  |
| 4 | today (no correction) | **3.5** |  | 4.8 | -0.9 | 50 % | 43 % | 44 % (480 h) | 88 % | 25 of 209 | 184 of 656 |
| 4 | speed bands, station seen | **3.2** | -0.33 … -0.21 | 4.3 | +0.0 | 46 % | 43 % | 63 % (480 h) |  | |  |
| 4 | speed bands | **3.3** | -0.27 … -0.15 | 4.4 | -0.0 | 44 % | 43 % | 65 % (480 h) | 88 % | 21 of 180 | 159 of 656 |
| 4 | one factor | **3.7** | +0.11 … +0.22 | 5.0 | +0.0 | 56 % | 48 % | 35 % (480 h) | 80 % | 67 of 328 | 261 of 656 |
| 4 | quantile map | **3.6** | -0.00 … +0.10 | 4.9 | -0.0 | 54 % | 46 % | 48 % (480 h) | 80 % | 61 of 308 | 247 of 656 |
| 4 | own station's mean miss (needs a station) | **3.3** | -0.27 … -0.19 | 4.4 | -0.3 | 56 % | 42 % | 32 % (480 h) |  | |  |
| 5 | today (no correction) | **4.0** |  | 5.5 | -0.6 | 49 % | 47 % | 49 % (480 h) | 83 % | 20 of 121 | 101 of 656 |
| 5 | speed bands, station seen | **3.6** | -0.52 … -0.35 | 4.7 | +0.1 | 43 % | 45 % | 76 % (480 h) |  | |  |
| 5 | speed bands | **3.7** | -0.45 … -0.29 | 4.8 | +0.1 | 42 % | 46 % | 78 % (480 h) | 83 % | 13 of 77 | 64 of 656 |
| 5 | one factor | **4.2** | +0.14 … +0.23 | 5.8 | +0.0 | 52 % | 51 % | 47 % (480 h) | 77 % | 56 of 247 | 191 of 656 |
| 5 | quantile map | **4.0** | -0.04 … +0.04 | 5.6 | -0.0 | 50 % | 50 % | 59 % (480 h) | 77 % | 52 of 223 | 171 of 656 |
| 5 | own station's mean miss (needs a station) | **3.8** | -0.29 … -0.18 | 5.1 | -0.2 | 54 % | 46 % | 39 % (480 h) |  | |  |

## Go at equal reliability

Fair Go comparison: each method's Go cut-off re-tuned so a Go came true ≥ 85 % on the other weeks (pooled fitting stations), scored on the held-out weeks. Cells: came true · wrong Go · real go days caught.

| Day ahead | Real go days | today (no correction) | speed bands | one factor | quantile map |
|---|---|---|---|---|---|
| 0 | 732 | 85 % · 85 · **486** | 85 % · 82 · **462** | 84 % · 87 · **456** | 85 % · 81 · **450** |
| 1 | 732 | 85 % · 71 · **403** | 85 % · 68 · **387** | 85 % · 69 · **397** | 85 % · 69 · **389** |
| 2 | 732 | 85 % · 68 · **392** | 85 % · 63 · **367** | 84 % · 79 · **401** | 85 % · 70 · **385** |
| 3 | 656 | 85 % · 50 · **284** | 84 % · 48 · **248** | 84 % · 48 · **244** | 84 % · 46 · **237** |
| 4 | 656 | 85 % · 38 · **212** | 84 % · 37 · **194** | 83 % · 43 · **208** | 83 % · 38 · **192** |
| 5 | 656 | 75 % · 16 · **47** | 72 % · 15 · **39** | 83 % · 12 · **59** | – · 0 · **0** |

## By area and day ahead

MAE and bias of the wind shown, best 2 h bias (best match), Go wrong / caught. Cells: today → speed bands / one factor / quantile map.

| Area | Day ahead | Hours | MAE | Bias | Best 2 h bias | Wrong Go | Go days caught (of) | Storm read < 20 kn |
|---|---|---|---|---|---|---|---|---|
| France | 0 | 16967 | 2.6 → 2.6 / 2.8 / 2.8 | +0.4 → +0.8 / +0.8 / +0.8 | -0.3 → -0.3 / +0.1 / -0.1 | 54 → 56 / 79 / 73 | 290 → 292 / 322 / 313 (449) | 15 % → 34 % / 14 % / 25 % |
| France | 1 | 16967 | 3.0 → 2.8 / 3.1 / 3.0 | +0.5 → +0.8 / +0.8 / +0.7 | -0.4 → -0.4 / -0.0 / -0.2 | 46 → 46 / 73 / 68 | 248 → 239 / 282 / 275 (449) | 22 % → 47 % / 20 % / 35 % |
| France | 2 | 16967 | 3.1 → 2.8 / 3.1 / 3.1 | +0.5 → +0.8 / +0.8 / +0.8 | -0.6 → -0.5 / +0.0 / -0.1 | 45 → 49 / 75 / 70 | 246 → 246 / 298 / 288 (449) | 17 % → 28 % / 13 % / 21 % |
| France | 3 | 16967 | 3.2 → 3.0 / 3.4 / 3.3 | +0.3 → +0.8 / +0.9 / +0.9 | -0.9 → -0.8 / -0.0 / -0.2 | 25 → 28 / 58 / 54 | 185 → 183 / 245 / 236 (449) | 24 % → 38 % / 17 % / 27 % |
| France | 4 | 16967 | 3.3 → 3.1 / 3.6 / 3.4 | -0.1 → +0.8 / +0.9 / +0.8 | -1.2 → -0.8 / -0.0 / -0.2 | 24 → 20 / 56 / 51 | 158 → 141 / 219 / 212 (449) | 29 % → 44 % / 19 % / 26 % |
| France | 5 | 16967 | 3.9 → 3.5 / 4.2 / 4.0 | +0.4 → +1.1 / +1.2 / +1.1 | -0.8 → -0.7 / +0.2 / -0.1 | 19 → 12 / 50 / 47 | 93 → 60 / 166 / 152 (449) | 34 % → 52 % / 31 % / 38 % |
| Mainland Spain (south masts) | 0 | 3888 | 2.8 → 2.5 / 2.7 / 2.7 | -2.0 → -1.4 / -1.9 / -1.8 | -2.2 → -1.9 / -2.1 / -2.1 | 3 → 3 / 3 / 3 | 16 → 15 / 16 / 15 (52) | 31 % → 49 % / 32 % / 28 % |
| Mainland Spain (south masts) | 1 | 3888 | 2.9 → 2.6 / 2.9 / 2.8 | -2.0 → -1.3 / -2.0 / -1.8 | -2.4 → -1.8 / -2.3 / -2.1 | 2 → 2 / 2 / 2 | 12 → 8 / 13 / 12 (52) | 29 % → 49 % / 29 % / 25 % |
| Mainland Spain (south masts) | 2 | 3888 | 3.0 → 2.6 / 3.0 / 2.9 | -1.9 → -1.2 / -1.9 / -1.8 | -2.3 → -1.8 / -2.2 / -2.1 | 3 → 3 / 8 / 6 | 12 → 12 / 15 / 14 (52) | 22 % → 59 % / 29 % / 34 % |
| Mainland Spain (south masts) | 3 | 3888 | 3.1 → 2.8 / 3.2 / 3.0 | -1.9 → -1.0 / -1.7 / -1.6 | -2.1 → -1.3 / -1.8 / -1.8 | 4 → 4 / 7 / 6 | 6 → 5 / 10 / 10 (52) | 28 % → 68 % / 32 % / 35 % |
| Mainland Spain (south masts) | 4 | 3888 | 3.5 → 3.0 / 3.5 / 3.3 | -1.8 → -0.6 / -1.2 / -1.0 | -2.2 → -1.2 / -1.7 / -1.6 | 1 → 1 / 10 / 9 | 5 → 4 / 8 / 7 (52) | 29 % → 50 % / 26 % / 25 % |
| Mainland Spain (south masts) | 5 | 3888 | 3.8 → 3.3 / 3.9 / 3.7 | -2.3 → -0.9 / -2.1 / -1.8 | -2.0 → -1.0 / -1.8 / -1.4 | 1 → 1 / 5 / 4 | 0 → 0 / 4 / 3 (52) | 44 % → 90 % / 44 % / 46 % |
| Canaries | 0 | 1779 | 3.6 → 4.0 / 3.6 / 3.9 | -2.7 → -3.2 / -2.6 / -3.1 | -3.6 → -4.2 / -3.5 / -4.1 | 2 → 1 / 2 / 2 | 47 → 41 / 48 / 47 (85) | 53 % → 83 % / 51 % / 73 % |
| Canaries | 1 | 1779 | 4.0 → 4.5 / 4.0 / 4.4 | -3.1 → -3.8 / -3.2 / -3.7 | -3.7 → -4.6 / -3.7 / -4.3 | 0 → 0 / 1 / 1 | 37 → 31 / 40 / 37 (85) | 62 % → 95 % / 64 % / 76 % |
| Canaries | 2 | 1779 | 4.2 → 4.8 / 4.3 / 4.6 | -3.4 → -4.1 / -3.6 / -4.0 | -3.8 → -4.7 / -3.8 / -4.3 | 2 → 2 / 2 / 2 | 37 → 35 / 47 / 41 (85) | 54 % → 85 % / 59 % / 82 % |
| Canaries | 3 | 1779 | 4.4 → 5.0 / 4.5 / 4.8 | -3.7 → -4.2 / -3.7 / -4.1 | -3.9 → -4.7 / -3.8 / -4.3 | 0 → 0 / 0 / 0 | 22 → 16 / 27 / 22 (85) | 57 % → 90 % / 57 % / 78 % |
| Canaries | 4 | 1779 | 4.6 → 5.0 / 4.4 / 4.7 | -3.6 → -4.0 / -3.1 / -3.6 | -4.2 → -4.9 / -3.8 / -4.4 | 0 → 0 / 0 / 0 | 10 → 5 / 18 / 12 (85) | 57 % → 88 % / 51 % / 81 % |
| Canaries | 5 | 1779 | 4.8 → 5.3 / 4.6 / 4.9 | -3.6 → -4.2 / -3.3 / -3.9 | -4.0 → -4.9 / -3.6 / -4.3 | 0 → 0 / 0 / 0 | 4 → 1 / 11 / 6 (85) | 58 % → 98 % / 53 % / 84 % |
| Near-shore buoy (POEM) | 0 | 1612 | 3.3 → 3.4 / 3.3 / 3.2 | -2.3 → -2.1 / -2.1 / -2.1 | -1.5 → -1.7 / -1.2 / -1.6 | 2 → 2 / 2 / 2 | 25 → 26 / 30 / 29 (70) | 18 % → 48 % / 18 % / 19 % |
| Near-shore buoy (POEM) | 1 | 1612 | 3.4 → 3.4 / 3.4 / 3.2 | -0.9 → -1.0 / -0.8 / -0.7 | +0.2 → -0.3 / +0.6 / +0.3 | 2 → 2 / 3 / 3 | 25 → 24 / 30 / 27 (70) | 1 % → 19 % / 1 % / 5 % |
| Near-shore buoy (POEM) | 2 | 1612 | 3.3 → 3.1 / 3.3 / 3.2 | -0.8 → -0.9 / -0.7 / -0.5 | -2.0 → -2.2 / -1.6 / -1.7 | 0 → 0 / 0 / 0 | 21 → 22 / 27 / 25 (70) | 4 % → 8 % / 1 % / 2 % |
| Near-shore buoy (POEM) | 3 | 1612 | 3.5 → 3.3 / 3.4 / 3.4 | -1.2 → -1.1 / -0.9 / -0.7 | -1.6 → -1.8 / -1.0 / -1.2 | 0 → 0 / 0 / 0 | 14 → 14 / 19 / 17 (70) | 15 % → 21 % / 11 % / 15 % |
| Near-shore buoy (POEM) | 4 | 1612 | 4.7 → 4.4 / 4.4 / 4.4 | -3.6 → -2.8 / -3.0 / -2.9 | -3.3 → -2.9 / -2.6 / -2.6 | 0 → 0 / 1 / 1 | 11 → 9 / 16 / 16 (70) | 70 % → 88 % / 52 % / 66 % |
| Near-shore buoy (POEM) | 5 | 1612 | 4.9 → 4.8 / 4.8 / 4.7 | -3.5 → -2.8 / -3.2 / -3.1 | -2.7 → -2.4 / -2.1 / -2.2 | 0 → 0 / 1 / 1 | 4 → 3 / 10 / 10 (70) | 78 % → 95 % / 78 % / 81 % |
| Open-sea buoys (Begur, Tarragona) | 0 | 1783 | 2.1 → 2.3 / 2.5 / 2.4 | +0.3 → +0.7 / +1.2 / +1.1 | -0.1 → -0.2 / +1.2 / +0.8 | 8 → 8 / 9 / 11 | 63 → 62 / 65 / 64 (76) | 3 % → 3 % / 3 % / 3 % |
| Open-sea buoys (Begur, Tarragona) | 1 | 1783 | 2.6 → 2.7 / 3.0 / 2.9 | +0.1 → +0.6 / +1.0 / +0.9 | -0.3 → -0.6 / +1.0 / +0.5 | 4 → 4 / 5 / 5 | 56 → 53 / 58 / 56 (76) | 3 % → 7 % / 1 % / 4 % |
| Open-sea buoys (Begur, Tarragona) | 2 | 1783 | 3.1 → 3.1 / 3.4 / 3.3 | +0.3 → +0.7 / +1.1 / +1.1 | -0.4 → -0.7 / +0.9 / +0.4 | 8 → 5 / 12 / 10 | 52 → 48 / 63 / 62 (76) | 9 % → 12 % / 6 % / 9 % |
| Catalonia test (airport, Bocana Sud) | 0 | 1696 | 3.0 → 2.5 / 2.9 / 2.8 | -2.3 → -1.3 / -2.1 / -1.9 | -2.3 → -1.8 / -2.0 / -1.9 | 0 → 0 / 0 / 0 | 2 → 3 / 10 / 9 (50) | – → – / – / – |
| Catalonia test (airport, Bocana Sud) | 1 | 1696 | 3.3 → 2.8 / 3.3 / 3.1 | -2.5 → -1.3 / -2.4 / -2.1 | -2.7 → -2.1 / -2.5 / -2.3 | 0 → 0 / 0 / 0 | 0 → 0 / 2 / 1 (50) | – → – / – / – |
| Catalonia test (airport, Bocana Sud) | 2 | 1696 | 3.3 → 2.8 / 3.3 / 3.1 | -2.3 → -1.0 / -2.0 / -1.8 | -2.6 → -1.9 / -2.1 / -2.1 | 0 → 0 / 0 / 0 | 0 → 0 / 9 / 6 (50) | – → – / – / – |
| Catalonia test (airport, Bocana Sud) | 3 | 1696 | 3.4 → 2.8 / 3.3 / 3.1 | -2.3 → -0.8 / -2.0 / -1.7 | -2.7 → -1.8 / -2.1 / -2.1 | 0 → 1 / 1 / 1 | 1 → 1 / 4 / 4 (50) | – → – / – / – |
| Catalonia test (airport, Bocana Sud) | 4 | 1696 | 3.6 → 2.9 / 3.5 / 3.3 | -2.5 → -0.6 / -1.9 / -1.7 | -2.7 → -1.6 / -1.8 / -1.7 | 0 → 0 / 0 / 0 | 1 → 1 / 3 / 2 (50) | – → – / – / – |
| Catalonia test (airport, Bocana Sud) | 5 | 1696 | 3.8 → 3.0 / 3.7 / 3.5 | -2.6 → -0.4 / -2.1 / -1.8 | -3.0 → -1.6 / -2.2 / -2.1 | 0 → 0 / 0 / 0 | 0 → 0 / 0 / 0 (50) | – → – / – / – |

## By station, day ahead 1 (MAE today → speed bands / one factor / quantile map)

| Area | Station | Hours | Bias today | MAE |
|---|---|---|---|---|
| Canaries | es-gran-canaria-vargas|GCLP | 904 | -3.7 | 4.4 → 5.4 / 4.5 / 5.0 |
| Canaries | es-lanzarote-playa-honda|GCRR | 875 | -2.6 | 3.5 → 3.7 / 3.6 / 3.7 |
| Catalonia masts (not trusted) | es-altafulla|DK | 2667 | -0.2 | 2.2 → 2.2 / 2.2 / 2.1 |
| Catalonia masts (not trusted) | es-riumar-ebro-delta|DL | 889 | +2.9 | 3.7 → 3.8 / 3.8 / 3.8 |
| Catalonia masts (not trusted) | es-platja-d-aro|DO | 886 | +1.9 | 2.9 → 3.2 / 3.1 / 3.0 |
| Catalonia masts (not trusted) | es-sant-pere-pescador|U2 | 889 | +4.7 | 5.1 → 5.1 / 5.3 / 5.3 |
| Catalonia masts (not trusted) | es-cambrils-platja-del-regueral|U6 | 889 | +2.3 | 2.7 → 3.6 / 2.8 / 3.0 |
| Catalonia masts (not trusted) | es-malgrat-de-mar-la-pomareda|WT | 889 | +1.0 | 2.5 → 2.5 / 2.6 / 2.5 |
| Catalonia masts (not trusted) | es-segur-de-calafell|WZ | 889 | +1.6 | 2.2 → 3.1 / 2.3 / 2.4 |
| Catalonia masts (not trusted) | es-vilanova-i-la-geltru-la-farola|YR | 889 | +0.3 | 1.9 → 2.0 / 1.9 / 1.8 |
| Catalonia test (airport, Bocana Sud) | es-castelldefels|LEBL | 827 | -2.9 | 3.4 → 2.6 / 3.4 / 3.1 |
| Catalonia test (airport, Bocana Sud) | es-barcelona-barceloneta|Y7 | 869 | -2.1 | 3.2 → 2.9 / 3.2 / 3.1 |
| France | fr-marignane-le-jai|13054001 | 922 | -0.4 | 2.6 → 2.4 / 2.7 / 2.7 |
| France | fr-carro|13056002 | 923 | -0.3 | 2.8 → 2.5 / 2.8 / 2.8 |
| France | fr-oleron-plage-des-huttes|17323001 | 896 | -0.8 | 2.2 → 2.3 / 2.2 / 2.2 |
| France | fr-lampaul-ploudalmezeau-trois-moutons|29178001 | 921 | +3.4 | 4.0 → 3.6 / 4.4 / 4.3 |
| France | fr-le-conquet-blancs-sablons|29190001 | 924 | -1.0 | 2.8 → 2.9 / 2.8 / 2.7 |
| France | fr-le-grau-du-roi-l-espiguette|30133005 | 1840 | +0.9 | 2.5 → 2.5 / 2.6 / 2.5 |
| France | fr-bassin-d-arcachon-les-arbousiers|33236002 | 921 | -1.1 | 2.2 → 2.0 / 2.2 / 2.1 |
| France | fr-carnon-petit-travers|34154001 | 922 | -0.6 | 2.5 → 2.3 / 2.5 / 2.5 |
| France | fr-biscarrosse-plage|40046001 | 921 | -2.1 | 3.1 → 2.7 / 3.1 / 3.0 |
| France | fr-gouville-sur-mer|50215002 | 924 | -2.6 | 3.3 → 3.4 / 3.3 / 3.4 |
| France | fr-utah-beach|50509002 | 923 | +1.8 | 2.6 → 2.4 / 2.9 / 2.8 |
| France | fr-les-hemmes-de-marck|62548002 | 922 | +0.6 | 2.3 → 2.2 / 2.4 / 2.3 |
| France | fr-le-touquet|62826001 | 921 | +4.1 | 4.9 → 4.4 / 5.4 / 5.0 |
| France | fr-cayeux-sur-mer-la-molliere|80182003 | 795 | +2.6 | 3.1 → 2.8 / 3.5 / 3.6 |
| France | fr-hyeres-le-merou|83069001 | 922 | +1.6 | 3.0 → 2.8 / 3.2 / 3.1 |
| France | fr-hendaye|LESO | 700 | +1.2 | 2.5 → 2.7 / 2.7 / 2.6 |
| France | fr-figari-baie-de-figari|LFKF | 826 | -1.7 | 2.9 → 2.8 / 2.9 / 2.9 |
| France | fr-hyeres-l-almanarre|LFTH | 844 | +2.9 | 4.4 → 3.6 / 4.7 / 4.3 |
| Mainland Spain (south masts) | es-mar-menor-los-narejos|08433 | 917 | -1.9 | 2.3 → 1.9 / 2.3 / 2.2 |
| Mainland Spain (south masts) | es-cadiz-cortadura|08452 | 757 | -2.1 | 2.9 → 2.6 / 2.9 / 2.8 |
| Mainland Spain (south masts) | es-tarifa-balneario|08458 | 753 | -1.9 | 3.0 → 3.2 / 3.0 / 2.9 |
| Mainland Spain (south masts) | es-almeria-el-zapillo|08488 | 593 | -2.7 | 4.1 → 3.3 / 4.1 / 3.9 |
| Mainland Spain (south masts) | es-rota-el-rompidillo|LERT | 868 | -1.7 | 2.5 → 2.1 / 2.5 / 2.4 |
| Near-shore buoy (POEM) | fr-torreilles-le-blockhaus|POEM | 1612 | -0.9 | 3.4 → 3.4 / 3.4 / 3.2 |
| Open-sea buoys (Begur, Tarragona) | buoy-6100196|6100196 | 895 | +0.2 | 2.6 → 2.6 / 3.1 / 3.0 |
| Open-sea buoys (Begur, Tarragona) | buoy-6100280|6100280 | 888 | +0.0 | 2.7 → 2.8 / 2.8 / 2.8 |

## What each correction does to best match (fitted on all weeks pooled)

Speed bands, kn added (hours behind it):

| Day ahead | Direction | 0–4 kn | 4–8 kn | 8–12 kn | 12–16 kn | 16–20 kn | 20–25 kn | 25–+ kn | One factor |
|---|---|---|---|---|---|---|---|---|---|
| 0 | on | +2.4 (914) | +1.1 (2651) | +0.3 (2071) | -0.2 (964) | -1.2 (438) | -3.7 (308) | -4.5 (154) | ×1.03 |
| 0 | cross | +2.3 (780) | +1.0 (1852) | +0.2 (1637) | -0.1 (972) | -0.3 (621) | -1.7 (327) | -3.4 (112) | ×1.05 |
| 0 | off | +2.1 (1234) | +0.6 (2511) | -0.1 (2113) | -0.5 (1541) | -0.6 (827) | -1.5 (311) | -3.1 (69) | ×1.02 |
| 0 | open | +1.8 (643) | +0.7 (1381) | +0.3 (866) | -0.4 (342) | -0.7 (218) | -1.8 (100) | -2.9 (72) | ×1.05 |
| 1 | on | +2.7 (895) | +1.3 (2606) | +0.2 (1948) | -0.7 (989) | -2.2 (474) | -4.5 (339) | -4.3 (139) | ×1.02 |
| 1 | cross | +2.8 (754) | +1.2 (1828) | +0.3 (1608) | -0.6 (958) | -0.8 (683) | -2.8 (326) | -3.4 (117) | ×1.04 |
| 1 | off | +2.4 (1189) | +0.7 (2612) | -0.2 (2134) | -0.8 (1528) | -1.1 (845) | -2.3 (349) | -3.0 (86) | ×1.01 |
| 1 | open | +2.1 (682) | +1.1 (1395) | +0.2 (814) | -0.6 (341) | -1.3 (184) | -2.7 (129) | -3.0 (77) | ×1.06 |
| 3 | on | +3.4 (914) | +1.8 (2694) | +0.2 (1891) | -0.8 (937) | -1.6 (369) | -3.2 (233) | -4.2 (95) | ×1.09 |
| 3 | cross | +3.5 (761) | +1.5 (1886) | +0.3 (1504) | -0.5 (1027) | -1.1 (634) | -2.5 (282) | -2.9 (122) | ×1.07 |
| 3 | off | +2.8 (1363) | +0.9 (2667) | -0.4 (2018) | -1.3 (1517) | -1.7 (901) | -3.3 (484) | -3.4 (108) | ×0.99 |
| 3 | open | +2.6 (414) | +1.7 (726) | +0.3 (424) | -0.8 (161) | -1.8 (75) | -3.1 (35) | -2.9 (4) | ×1.13 |
| 5 | on | +4.2 (981) | +2.5 (2768) | +0.2 (1766) | -1.3 (886) | -3.3 (475) | -4.8 (235) | -4.1 (85) | ×1.10 |
| 5 | cross | +4.1 (902) | +2.2 (1955) | +0.4 (1371) | -1.1 (936) | -1.6 (595) | -3.6 (355) | -4.4 (93) | ×1.09 |
| 5 | off | +3.9 (1443) | +1.5 (2731) | -0.2 (1982) | -1.6 (1503) | -2.8 (853) | -5.0 (392) | -5.1 (100) | ×1.01 |
| 5 | open | +3.5 (330) | +2.1 (827) | -0.2 (372) | -1.8 (164) | -2.8 (74) | -4.6 (51) | -4.2 (21) | ×1.08 |

Quantile map, day ahead 1, onshore, even-week fit: forecast → corrected at 8 / 12 / 15 / 20 / 25 / 30 kn: 8 → 8.6, 12 → 11.8, 15 → 14.3, 20 → 16.9, 25 → 21.8, 30 → 27.1

