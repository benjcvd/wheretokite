# WHE-71: beach cell vs sea cell for the chance to kite

25 station-spot pairs, 100 days, 9637 spot-day-leads. Truth: trusted masts + POEM buoy.

### Where each model's cell falls (km from the spot pin)

| Spot | ECMWF beach | ECMWF sea | best match beach | best match sea | MF beach | ICON beach |
|---|---|---|---|---|---|---|
| es-tarifa-balneario | 10 | 10 | 4 | 6 | 13 | 6 |
| es-cadiz-cortadura | 29 | 2 | 7 | 2 | 6 | 7 |
| es-rota-el-rompidillo | 17 | 16 | 5 | 3 | 10 | 4 |
| es-almeria-el-zapillo | 20 | 9 | 6 | 1 | 9 | 6 |
| es-mar-menor-los-narejos | 14 | 8 | 4 | 3 | 0 | 3 |
| fr-figari-baie-de-figari | 7 | 24 | 3 | 3 | 1 | 6 |
| fr-hyeres-l-almanarre | 23 | 12 | 1 | 0 | 1 | 7 |
| fr-hyeres-le-merou | 17 | 13 | 0 | 1 | 0 | 2 |
| fr-carro | 18 | 10 | 0 | 1 | 0 | 5 |
| fr-hendaye | 14 | 14 | 1 | 1 | 1 | 2 |
| fr-marignane-le-jai | 11 | 20 | 0 | 1 | 0 | 5 |
| fr-le-grau-du-roi-l-espiguette | 9 | 12 | 1 | 3 | 0 | 1 |
| fr-port-camargue-plage-sud | 10 | 10 | 1 | 1 | 1 | 1 |
| fr-carnon-petit-travers | 22 | 6 | 0 | 0 | 1 | 0 |
| fr-biscarrosse-plage | 21 | 6 | 1 | 0 | 1 | 6 |
| fr-bassin-d-arcachon-les-arbousiers | 20 | 12 | 0 | 1 | 0 | 3 |
| fr-oleron-plage-des-huttes | 8 | 8 | 0 | 1 | 0 | 2 |
| fr-le-conquet-blancs-sablons | 15 | 13 | 1 | 0 | 1 | 1 |
| fr-lampaul-ploudalmezeau-trois-moutons | 10 | 21 | 0 | 1 | 0 | 2 |
| fr-gouville-sur-mer | 14 | 15 | 4 | 1 | 0 | 4 |
| fr-utah-beach | 19 | 11 | 1 | 1 | 0 | 1 |
| fr-cayeux-sur-mer-la-molliere | 16 | 5 | 0 | 2 | 0 | 0 |
| fr-le-touquet | 12 | 6 | 1 | 1 | 0 | 1 |
| fr-les-hemmes-de-marck | 26 | 3 | 1 | 2 | 0 | 1 |
| fr-saint-cyprien-canet-pont-des-basses | 13 | 22 | 0 | 0 | 0 | 3 |

ECMWF beach cell: median 15 km from the pin, max 29 km.

### Each model's best 2 h (kn), days 0–1, on days with and without kiteable wind

| Model, cell | Mean, all | Mean, kite days | Mean, other days |
|---|---|---|---|
| best_match, sea | 8.7 | 15.8 | 6.4 |
| best_match, land | 8.5 | 15.2 | 6.3 |
| meteofrance_seamless, land | 9.4 | 16.5 | 7.0 |
| icon_seamless, land | 7.4 | 13.1 | 5.5 |
| ecmwf_ifs025, sea | 9.0 | 16.1 | 6.7 |
| ecmwf_ifs025, land | 6.4 | 11.3 | 4.8 |

### Tuning period 2026-08-08 – 2026-10-30

| Day ahead | Setup | Spot-days | Go shown | Go came true | Kite days caught by Go | Uncertain came true | Kite days left in 'unlikely' | Brier | Models' spread (kn) | Models' mean best 2 h (kn) |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | tuned | 2061 | 375 | 85 % | 59 % | 51 % | 20 % | 0.088 | 1.7 | 8.9 |
| 0 | app | 2061 | 272 | 89 % | 45 % | 68 % | 28 % | 0.090 | 1.8 | 8.3 |
| 0 | ec-sea | 2061 | 370 | 85 % | 58 % | 55 % | 20 % | 0.086 | 1.6 | 8.9 |
| 1 | tuned | 2061 | 324 | 85 % | 51 % | 54 % | 21 % | 0.097 | 1.7 | 8.9 |
| 1 | app | 2061 | 235 | 89 % | 39 % | 62 % | 32 % | 0.102 | 1.8 | 8.2 |
| 1 | ec-sea | 2061 | 306 | 85 % | 48 % | 57 % | 22 % | 0.097 | 1.7 | 8.8 |
| 2 | tuned | 2036 | 319 | 85 % | 51 % | 55 % | 27 % | 0.099 | 1.7 | 8.4 |
| 2 | app | 2036 | 215 | 91 % | 37 % | 64 % | 40 % | 0.110 | 1.4 | 7.5 |
| 2 | ec-sea | 2036 | 281 | 88 % | 46 % | 56 % | 31 % | 0.100 | 1.6 | 8.2 |
| 3 | tuned | 2011 | 228 | 88 % | 38 % | 58 % | 29 % | 0.111 | 1.9 | 8.3 |
| 3 | app | 2011 | 136 | 89 % | 23 % | 70 % | 42 % | 0.120 | 1.6 | 7.4 |
| 3 | ec-sea | 2011 | 190 | 87 % | 31 % | 62 % | 32 % | 0.112 | 1.8 | 8.0 |

### After the tuning, 2026-10-31 – 2026-11-15 (never seen by the tuning)

| Day ahead | Setup | Spot-days | Go shown | Go came true | Kite days caught by Go | Uncertain came true | Kite days left in 'unlikely' | Brier | Models' spread (kn) | Models' mean best 2 h (kn) |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | tuned | 367 | 57 | 75 % | 69 % | 30 % | 18 % | 0.070 | 1.5 | 6.8 |
| 0 | app | 367 | 42 | 90 % | 61 % | 41 % | 27 % | 0.058 | 1.5 | 6.0 |
| 0 | ec-sea | 367 | 56 | 79 % | 71 % | 29 % | 18 % | 0.066 | 1.5 | 6.7 |
| 1 | tuned | 367 | 56 | 73 % | 66 % | 23 % | 24 % | 0.081 | 1.7 | 6.8 |
| 1 | app | 367 | 40 | 85 % | 55 % | 33 % | 31 % | 0.071 | 1.5 | 6.0 |
| 1 | ec-sea | 367 | 53 | 74 % | 63 % | 29 % | 26 % | 0.080 | 1.6 | 6.7 |
| 2 | tuned | 367 | 61 | 66 % | 65 % | 31 % | 21 % | 0.093 | 1.8 | 6.8 |
| 2 | app | 367 | 44 | 84 % | 60 % | 26 % | 32 % | 0.076 | 1.4 | 5.8 |
| 2 | ec-sea | 367 | 56 | 70 % | 63 % | 35 % | 23 % | 0.086 | 1.7 | 6.5 |
| 3 | tuned | 367 | 44 | 77 % | 55 % | 31 % | 21 % | 0.091 | 2.0 | 6.7 |
| 3 | app | 367 | 27 | 93 % | 40 % | 45 % | 31 % | 0.076 | 1.5 | 5.7 |
| 3 | ec-sea | 367 | 33 | 91 % | 48 % | 35 % | 21 % | 0.083 | 1.9 | 6.4 |

### Both periods together

| Day ahead | Setup | Spot-days | Go shown | Go came true | Kite days caught by Go | Uncertain came true | Kite days left in 'unlikely' | Brier | Models' spread (kn) | Models' mean best 2 h (kn) |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | tuned | 2428 | 432 | 84 % | 60 % | 49 % | 20 % | 0.085 | 1.7 | 8.6 |
| 0 | app | 2428 | 314 | 89 % | 47 % | 66 % | 28 % | 0.085 | 1.8 | 7.9 |
| 0 | ec-sea | 2428 | 426 | 84 % | 60 % | 52 % | 19 % | 0.083 | 1.6 | 8.6 |
| 1 | tuned | 2428 | 380 | 83 % | 53 % | 51 % | 21 % | 0.094 | 1.7 | 8.6 |
| 1 | app | 2428 | 275 | 89 % | 41 % | 59 % | 32 % | 0.097 | 1.7 | 7.9 |
| 1 | ec-sea | 2428 | 359 | 83 % | 50 % | 55 % | 23 % | 0.094 | 1.7 | 8.5 |
| 2 | tuned | 2403 | 380 | 82 % | 52 % | 52 % | 26 % | 0.098 | 1.7 | 8.2 |
| 2 | app | 2403 | 259 | 90 % | 39 % | 61 % | 39 % | 0.105 | 1.4 | 7.3 |
| 2 | ec-sea | 2403 | 337 | 85 % | 48 % | 54 % | 30 % | 0.098 | 1.6 | 7.9 |
| 3 | tuned | 2378 | 272 | 86 % | 39 % | 54 % | 28 % | 0.107 | 1.9 | 8.0 |
| 3 | app | 2378 | 163 | 90 % | 25 % | 67 % | 41 % | 0.113 | 1.6 | 7.2 |
| 3 | ec-sea | 2378 | 223 | 88 % | 33 % | 58 % | 31 % | 0.108 | 1.8 | 7.8 |

### Both periods: app minus tuned, 95 % interval over days

| Day ahead | Go came true | Kite days caught | Brier |
|---|---|---|---|
| 0 | +5 pts (+3…+8) | -14 pts (-17…-11) | -0.000 (-0.004…+0.003) |
| 1 | +6 pts (+3…+9) | -12 pts (-15…-9) | +0.003 (-0.001…+0.007) |
| 2 | +8 pts (+5…+12) | -13 pts (-16…-10) | +0.007 (+0.001…+0.011) |
| 3 | +4 pts (+0…+7) | -15 pts (-18…-12) | +0.006 (+0.001…+0.011) |

### How often the shown outlook changes (app vs tuned), days 0–3

| Day ahead | Spot-days | Same | Go in tuned, not in app | Go in app, not in tuned | Other change |
|---|---|---|---|---|---|
| 0 | 2428 | 89 % | 120 (84 had wind) | 2 (2 had wind) | 135 |
| 1 | 2428 | 89 % | 109 (75 had wind) | 4 (3 had wind) | 147 |
| 2 | 2403 | 88 % | 124 (80 had wind) | 3 (2 had wind) | 160 |
| 3 | 2378 | 88 % | 110 (88 had wind) | 1 (0 had wind) | 172 |

### Masts only (POEM dropped), both periods

| Day ahead | Setup | Spot-days | Go shown | Go came true | Kite days caught by Go | Uncertain came true | Kite days left in 'unlikely' | Brier | Models' spread (kn) | Models' mean best 2 h (kn) |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | tuned | 2351 | 419 | 83 % | 62 % | 48 % | 18 % | 0.081 | 1.7 | 8.6 |
| 0 | app | 2351 | 303 | 89 % | 48 % | 65 % | 26 % | 0.081 | 1.8 | 7.9 |
| 0 | ec-sea | 2351 | 413 | 84 % | 61 % | 52 % | 17 % | 0.079 | 1.6 | 8.6 |
| 1 | tuned | 2351 | 366 | 83 % | 54 % | 51 % | 20 % | 0.092 | 1.7 | 8.6 |
| 1 | app | 2351 | 262 | 89 % | 41 % | 59 % | 31 % | 0.093 | 1.7 | 7.8 |
| 1 | ec-sea | 2351 | 345 | 83 % | 51 % | 54 % | 21 % | 0.091 | 1.6 | 8.5 |
| 2 | tuned | 2327 | 369 | 81 % | 54 % | 51 % | 24 % | 0.094 | 1.7 | 8.2 |
| 2 | app | 2327 | 251 | 90 % | 40 % | 60 % | 37 % | 0.099 | 1.4 | 7.3 |
| 2 | ec-sea | 2327 | 327 | 84 % | 49 % | 53 % | 28 % | 0.093 | 1.6 | 7.9 |
| 3 | tuned | 2303 | 264 | 86 % | 41 % | 54 % | 27 % | 0.104 | 1.9 | 8.0 |
| 3 | app | 2303 | 156 | 89 % | 25 % | 67 % | 39 % | 0.108 | 1.6 | 7.2 |
| 3 | ec-sea | 2303 | 215 | 87 % | 34 % | 58 % | 29 % | 0.103 | 1.8 | 7.8 |
