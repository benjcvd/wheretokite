# Which forecast model predicts the real wind best? (WHE-58)

27 Oct 2026. The question: should the app keep Open-Meteo's "best match" model on the offshore
grid cell, or use another model, a mix, or the beach cell?

## Recommendation

1. **Use the nearest grid cell (the beach), not the offshore one** (recommended). Every model
   does better on it, in both seasons. It also explains the gap you saw next to Windguru, which
   reads the beach cell.
2. **Then use the mean of AROME, ICON and ECMWF** instead of "best match" (recommended). It
   was the best or joint best in both seasons, on speed, correlation and direction.
3. Together the two cut the app's typical speed error from 3.5 to 3.0 kn in winter and spring,
   and from 2.9 to 2.3 kn in summer. Forecasts also overshoot less: +1.7 kn instead of +2.2.

AROME 1.3 km on its own, the model we assumed was best at short range, came out worst or
nearly worst on the offshore cell. It over-forecasts the most (+3.8 kn).

## What was measured

- **Spots and stations**: Sant Pere Pescador, Torredembarra, Malgrat de Mar, Riumar, El
  Trabucador and Castelldefels, each against the nearest official Meteocat station (1–6 km
  away). Leucate is compared with Météo-France's Leucate station.
- **Periods**: Jan–Jun 2026 (6–7 spots, about 1,900 daylight hours each, tramontane season
  included) and Jul–25 Oct 2026 (6 spots, about 1,290 hours each). Castelldefels' station has
  no data before July. Météo-France's open files stop on 24 June, so Leucate is in the
  first period only.
- **Forecasts**: Open-Meteo's historical forecasts, i.e. the first hours of each model run,
  at the spot's position, offshore cell and beach cell. Daylight hours only (07–18 UTC).
- **Scores**:
  - Speed error: typical gap in knots.
  - Bias: forecast minus measured.
  - Error without bias: the gap left once that constant offset is removed. This is the fair
    comparison, because stations sit on land and some measure at 2 m, so they read lower than
    the water.
  - Correlation with the measured wind.
  - Direction error, counted only when the wind is above 8 kn.

## Results, mean over spots

Error without bias, the fair comparison, in knots (lower is better):

| Model | Jan–Jun, beach cell | Jan–Jun, offshore cell | Jul–Oct, beach cell | Jul–Oct, offshore cell |
|---|---|---|---|---|
| **Mean AROME + ICON + ECMWF** | **2.6** | 3.3 | **1.8** | 2.3 |
| Mean of all 5 | 2.7 | 3.2 | **1.8** | 2.1 |
| Best match (the app today) | 2.7 | 3.0 | 2.1 | 2.2 |
| ECMWF IFS | 2.7 | 4.0 | 2.0 | 3.0 |
| ICON | 2.8 | 3.3 | 2.0 | 2.3 |
| AROME 2.5 km | 3.2 | 3.2 | 2.3 | 2.3 |
| AROME 1.3 km | 3.2 | 3.6 | 2.3 | 2.8 |
| GFS | 3.3 | 4.0 | 2.2 | 2.6 |

App today vs recommended (best match on the offshore cell vs 3-model mean on the beach cell):

| | Speed error | Bias | Correlation | Direction error |
|---|---|---|---|---|
| Jan–Jun, today | 3.5 kn | +2.2 kn | 0.75 | 12° |
| Jan–Jun, recommended | 3.0 kn | +1.7 kn | 0.76 | 12° |
| Jul–Oct, today | 2.9 kn | +2.1 kn | 0.64 | 13° |
| Jul–Oct, recommended | 2.3 kn | +1.6 kn | 0.68 | 11° |

Per spot, the best single model on the offshore cell is usually AROME 2.5 km (Sant Pere,
Torredembarra, Riumar). At Leucate and El Trabucador, "best match" and ICON win. No single
model wins everywhere, which is the usual argument for a mix.

## Next to Windguru (visitor check, 27 Oct)

For Sant Pere on 27 and 28 Oct, Windguru's headline row (their own blend of models) was within
about 1 kn of the 3-model mean on the beach cell. Today's app setup (best match, offshore cell)
read 3–5 kn more. That's a benchmark, not a measurement: it shows the recommended setup
would read like Windguru's main row, not that either is right.

## Limits (read before deciding)

- **Stations are on land, riders are on the water.** Wind over the water is usually
  stronger, so part of the forecasts' positive bias may be real. The beach cell's win on error
  without bias (timing and ups and downs, not level) is the solid part. Its lower level could
  partly come from the stations being on land too.
- **Short range only.** The historical forecasts are each run's first hours. This doesn't
  measure how good tomorrow's or the day after's forecast is. Model rankings usually hold, but
  not always.
- **One region.** Six Catalan spots plus Leucate. Tarifa (levante/poniente) and the Atlantic
  aren't covered yet.
- **Quota.** A 3-model mean asks Open-Meteo for three models per spot. That is roughly twice
  the quota per search, which matters on the free tier.
- **Kiteable or not.** The script also scores whether windy hours (12 kn and up) were
  forecast. It stays noisy with stations on land, so it isn't used for the recommendation.

## Reproduce

```sh
python3 tools/backtest/model_backtest.py --start 2026-01-01 --end 2026-06-23
python3 tools/backtest/model_backtest.py --start 2026-07-01 --end 2026-10-25
```

Station pairs are in `tools/backtest/pairs.json`. `tools/backtest/match_stations.py` finds the
nearest Meteocat station for each Catalan spot. Observations come from official open data
only (Meteocat XEMA, Météo-France), never from competitors.
