# Which forecast model predicts the real wind best? (WHE-58)

27 Oct 2026. The question: should the app keep Open-Meteo's "best match" model on the offshore
grid cell, or use another model, a mix, or the beach cell?

## Replay of 20 Sep – 31 Oct from Barcelona: did the top picks have wind? (WHE-63, 1 Nov)

For each of the 42 days: the afternoon slot, 150 min from Barcelona (37 spots in reach), rider
75 kg with 9 and 12 m kites. The app's own ranking code was fed the forecast as it stood **the
day before** (Open-Meteo Previous Runs), then fed what the nearest official station measured.
A "go" is what the rider sees: the app shows a riding window. Script: `tools/backtest/replay.py`
(it drives `kite --replay`).

### In plain words

- **Today's app (best match, offshore cell) says "go" far too often.** It showed a riding window
  on 37 of 42 afternoons; the stations measured a rideable afternoon somewhere in reach on 10
  to 24 of them (depending on how much stronger the wind is on the water than at the mast).
  Of its checked "go" picks, 9 % had wind at the stations' level, 32 % even with a generous
  +30 % allowance for the water. Its top pick was wrong on 12–15 of 16 checkable days.
- **Both beach-cell setups cut the false "go" a lot, at the cost of missing some real days.**
  WHE-58's mix said "go" on 20 days, the WHE-61 pick on 26. Share of good "go" picks:
  19–69 % (WHE-58) and 14–51 % (WHE-61 pick), against 9–32 % today. The gain over today is
  beyond the noise for WHE-58 at every level; for the WHE-61 pick it is small and, without the
  Bay of Roses stations, a tie at the middle level. Missed go days: today 0–1, WHE-61 pick 2–7,
  WHE-58 3–8.
- **I can't give you one honest hit rate.** The answer swings from "1 in 10" to "2 in 3"
  with the land-vs-water gap, which no land station measures. Torredembarra (beach mast) says
  the gap is small; the inland masts say it is large; the one buoy so far (WHE-62, Canet) says
  the models read *low* on the water. Until WHE-62 settles the level, trust the ranking of the
  setups, not the percentages.
- **Half the "go" picks can't be checked at all**: the Roussillon lagoons and beaches
  (Le Barcarès, Saint-Cyprien, Argelès), L'Estartit, Pals and the Ebro delta's Fangar have no
  official mast within 6 km. These are exactly the spots the app likes most on windy days.

### Results (top 5 picks, forecast 1 day ahead, 42 days)

Station level: "as measured" (brought to 10 m), then ×1.15 and ×1.3 as a guess at the water
(log-profile physics says a land mast reads about 10–30 % under open water; a guess, not a
measurement).

| Setup | Station level | "Go" picks checked | had wind | false "go" | share good | Top pick good / bad | Go days (app) | Go days (measured) | Missed go days |
|---|---|---|---|---|---|---|---|---|---|
| Today: best match, offshore cell | as measured | 66 | 6 | 60 | 9 % | 1 / 15 | 37 | 10 | 0 |
| | ×1.15 | 66 | 13 | 53 | 20 % | 4 / 12 | 37 | 17 | 1 |
| | ×1.3 | 66 | 21 | 45 | 32 % | 4 / 12 | 37 | 24 | 1 |
| WHE-58: AROME+ICON+ECMWF, beach cell | as measured | 26 | 5 | 21 | 19 % | 1 / 5 | 20 | 10 | 3 |
| | ×1.15 | 26 | 12 | 14 | 46 % | 5 / 1 | 20 | 17 | 5 |
| | ×1.3 | 26 | 18 | 8 | 69 % | 5 / 1 | 20 | 24 | 8 |
| WHE-61 pick: AROME+ICON beach, ECMWF offshore | as measured | 35 | 5 | 30 | 14 % | 0 / 9 | 26 | 10 | 2 |
| | ×1.15 | 35 | 12 | 23 | 34 % | 2 / 7 | 26 | 17 | 4 |
| | ×1.3 | 35 | 18 | 17 | 51 % | 4 / 5 | 26 | 24 | 7 |

Is the difference real? Share of good "go" picks minus today, 95 % interval over days
resampled: WHE-58 +3…+22 / +12…+46 / +24…+54 points (×1 / ×1.15 / ×1.3); WHE-61 pick
+0…+13 / +4…+27 / +7…+33. Without Sant Pere and Empuriabrava (the two spots where today's
setup is worst): WHE-58 still clearly ahead (+3…+27 / +9…+42 / +17…+47), WHE-61 pick
+0…+12 / −3…+21 / +1…+28 (a tie in the middle). Small samples: 20–66 checked picks.

Stations (≤ 6.2 km, ≤ 40 m up; hilltop and rooftop masts left out): 20 of the 37 spots, all
Meteocat except Météo-France Torreilles. Full output, per spot and day by day:
[replay output](tools/backtest/replay_2026-09-20_2026-10-31.md).

### Spots that are systematically wrong

| Spot | What happens | Whose job |
|---|---|---|
| Sant Pere Pescador, Empuriabrava (Bay of Roses) | Today's setup: "go" on 19 and 14 days, station measured go on 0–4 and 1. Best 2 h reads +4–5 kn over the mast. The beach cell fixes most of it (+1–2 kn). | Forecast (cell choice), already covered by WHE-61. Station 1.6 km inland: your experience on SE days there would help. |
| Riumar, El Trabucador (Ebro delta) | Every setup +2.5–3 kn and 5–9 false "go", mostly in mestral (NW): models 15–21 kn, Illa de Buda measured 6–10 kn (21–23 Oct). NW is cross-offshore at Riumar (beach faces NNE); the app counts it as usable. | **Ben**: is Riumar rideable in mestral, and does it blow that hard there? If not, it's a direction rule (Spot improvement: side/sector). |
| Torredembarra, Altafulla, Creixell | Real go days missed by every setup on easterlies (4 and 31 Oct: beach mast 13–14 kn, AROME and ICON beach cells 6–9 kn, only ECMWF offshore got it). | Forecast: new card, check easterly days on the Tarragona coast. |
| Torreilles | Today's setup "go" on 10 days, 6 false; beach-cell setups 1–3 false. | Covered by WHE-61. |

No spot position problems found (no pin on land or wrong beach) in this sample.

### Real days (sanity check)

- **28 Sep, Sant Pere, SE wind**: station 9–10 kn; today's app 21 kn ("go"), AROME beach
  16–19, ICON 11–13, ECMWF 13–14. False "go" at the mast's level, a hit with +30 %.
- **21 Oct, Riumar, mestral**: station 7–10 kn; every model 15–21 kn. False "go" for every
  setup, even at +30 %.
- **31 Oct, Torredembarra, easterly**: beach mast 12–14 kn from 13:00 to 15:00; all setups said
  no go (best match 10, AROME 6–9, ICON 7). Missed day.

### What could make this wrong

- **The land-vs-water gap**, as above: it decides the percentages. A factor that suits an inland
  mast over-corrects a beach mast like Torredembarra.
- **Not replayed**: the models-disagree penalty (it needs live runs; it would trim a few "go"
  scores on the mixed setups), real drive times (straight-line reach), tides, ECMWF gusts
  (missing from the archive, so the mixes read slightly calmer gusts than live).
- **Gusts left out of the measured side** (the measured wind uses gust = mean), so the station
  side can't be "too gusty": it only judges strength and direction.
- **6 weeks of autumn**, 42 days, one rider profile; Meteocat has no data 27–29 Oct.
- **Half the top picks unchecked** (no station), and those are the windiest spots.

### Recommendation

1. Don't keep today's setup for testers: whatever the water level, it sends people out on
   too many dead afternoons.
2. Between the two beach-cell setups, this replay leans to WHE-58 on false "go", the WHE-61
   pick on missed days; the difference between them sits inside the noise. Keep the WHE-61
   pick as the candidate and let WHE-62 (buoy level) and WHE-72 (wider test) settle it, rather
   than re-opening the choice on 6 weeks of land masts. (recommended)
3. Ben: answer the Riumar mestral question; a new card checks easterlies at Torredembarra.

## Second look (WHE-61, 27 Oct): the new setup reads too low

Forecast accuracy re-ran the comparison the way riders use the app: the level as shown (no
offset removed), windy hours and "go days" instead of average error only, forecasts made 1 and
2 days ahead, and 95 % intervals over days. Script: `tools/backtest/review.py`.

### In plain words

- **The beach cell is a real gain for AROME and ICON.** Their beach cell is 0.2–1.4 km from
  the spot. Measured: lower error at every lead time, both seasons, beyond the noise.
- **For ECMWF the "beach" cell is not the beach.** Its 25 km grid puts it 16.7 km inland at
  Pals and 11 km inland at Sant Pere (measured from Open-Meteo's answer). Inland air is
  calmer, and in a 3-model mean that cell is a third of the wind, half from day 2 on (AROME
  1.3 km stops after about 2 days, so the mix becomes ICON + ECMWF).
- **The new setup mostly wins by reading lower, and the stations read low.** All the stations
  are on land, 1–10 km from the water. The setup closest to them in level wins on error; ECMWF's
  inland cell alone does nearly as well, which is the trap: it shares the stations' shelter.
- **It misses windy days.** Forecast a day ahead, the new setup caught 70 % of the days with
  12 kn+ for 2 h (old: 85 %) in Jan–Jun, and 22 % vs 40 % in Jul–Oct. It does cry wolf less
  (39 % false alarms vs 52 %).
- **At Pals it reads below an inland station.** On good summer days the Palafrugell station,
  10 km inland and 35 m up, measured 14–19 kn; the new setup forecast 11–15 kn. Wind on the
  water at Pals is very likely stronger than at Palafrugell (I think, not measured).
- **Much of the gain comes from two stations.** Leaving out Sant Pere and Riumar (stations that
  read far below every model in tramontane), the error gain halves in summer and the go-day gain
  in winter becomes a tie.

### Results, forecast 1 day ahead (what riders plan on)

Best 2 h window of each day (07–17 UTC), at all spots. Bias and error in knots against the
stations, measured wind brought to 10 m. "Caught" = days with 12 kn+ for 2 h that were forecast;
"false" = forecast go days that didn't come.

| Setup | Jan–Jun bias | error | caught | false | Jul–Oct bias | error | caught | false |
|---|---|---|---|---|---|---|---|---|
| Old: best match, offshore cell | +2.3 | 3.7 | 85 % | 52 % | +2.0 | 3.0 | 40 % | 90 % |
| New: mean AROME 1.3 + ICON + ECMWF, beach cell | +0.2 | 2.7 | 70 % | 39 % | +0.6 | 2.0 | 22 % | 86 % |
| **Mean AROME 1.3 + ICON on the beach cell, ECMWF on its sea cell** | +2.0 | 3.3 | 81 % | 52 % | +1.5 | 2.4 | 49 % | 83 % |
| Best match, beach cell | +0.7 | 2.9 | 72 % | 45 % | +1.2 | 2.5 | 27 % | 90 % |
| ECMWF alone, beach cell (inland) | 0.0 | 2.7 | 69 % | 38 % | -0.1 | 2.1 | 13 % | 86 % |

Change against the old setup, 95 % interval over days (a day 1 ahead):

| Setup | Best 2 h error, Jan–Jun | Jul–Oct | Jul–Oct without Sant Pere and Riumar | Go-day score, Jan–Jun | without the two |
|---|---|---|---|---|---|
| New (3-model mean, beach) | −1.2 … −0.8 kn | −1.2 … −0.9 kn | −0.55 … −0.28 kn | +0.01 … +0.08 | −0.03 … +0.06 (tie) |
| AROME + ICON beach, ECMWF sea | −0.5 … −0.3 kn | −0.8 … −0.6 kn | −0.31 … −0.09 kn | −0.04 … +0.02 (tie) | −0.06 … +0.02 (tie) |

Same picture on the day itself and 2 days ahead (full tables: run the script). In Jul–Oct the
stations measured only 161 kiteable hours: summer hit rates rest on few days.

### Real days (forecast a day ahead, best 2 h, kn)

| Day | Measured | Old | New | AROME + ICON beach, ECMWF sea |
|---|---|---|---|---|
| Pals, 8 Sep (sea breeze), Palafrugell station | 19 | 21 | 15 | 17 |
| Pals, 27 Aug (sea breeze) | 16 | 19 | 14 | 16 |
| Pals, 31 Mar (strong east/north wind) | 24 | 32 | 25 | 30 |
| Sant Pere, 29 Mar (tramontane), station 1.2 km inland | 18 | 32 | 30 | 36 |

Sant Pere's station reads far below every model in tramontane: it says more about the
station's shelter than about the models.

### What could make this wrong

- **No measurement on the water.** Every truth here is a land station. If the sea really
  reads as low as the stations, the new setup is right and the old one over-reads. Only a buoy
  or a beach mast can settle the level (card: test against wind measured on the water).
- **Height correction** uses one roughness for all stations (open land, 3 cm). Sheltered
  stations need more; that would raise the measured wind and make the new setup look worse.
- **Lead time from Jan to Jun is partial:** Open-Meteo's archive has no AROME 1.3 km forecasts
  made a day or more ahead before the summer, so "day 1, Jan–Jun" is really ICON + ECMWF.
- **Pals has no close station.** Torroella de Montgrí (UE), planned for Pals and L'Estartit,
  measures no wind at all; Palafrugell is 10 km inland. Leucate (Météo-France) has data to
  23 June only.
- **Gusts and direction "usable" rules are simplified** (gusts not scored; "usable" = not
  offshore, as the app flags it). Averaging gusts with an inland cell also lowers the gusts
  shown, which matters for the "too strong for your level" limit (not measured yet).

### Options

1. **Keep the beach cell for AROME and ICON, but read ECMWF on its sea cell** (recommended).
   Keeps a real error gain over today at every lead time, catches windy days about as well as
   today, and removes the inland cell. The level stays close to today's until water
   measurements tell us more. Costs one extra request per batch.
2. Keep the new setup as built. Lowest error against land stations, but it reads 1.5–2 kn
   lower than today on average, much more at Pals, and catches 15–18 points fewer go days.
3. Best match on the beach cell only (one model, cheapest). Smaller gain, level in between.
4. Go back to today's setup until buoys are in. Safest for "don't miss a day", over-reads at
   sheltered spots.

## Recent days on the Costa Brava (WHE-60, 31 Oct): two light days

The plan was to check 28 Oct (the day Pals dropped from 14 to 7–8 kn) against the stations.
**That day can't be checked yet:** Meteocat's open feed has no data at any station from
26 Oct 18 UTC to 30 Oct (hourly and daily datasets both). The saved forecast
(`tools/backtest/snapshot_2026-10-28.json`) is kept in case Meteocat fills the gap.

Instead: the two days after the backtest window that do have data, 26 and 30 Oct, rebuilt from
Open-Meteo's archive of forecasts made the day before. Afternoon 11–17 UTC, best 2 h, kn,
measured wind at 10 m masts.

| Day, spot (station) | Wind measured | Gusts, max | Old | New (3 models, beach) | **Option 1** (ECMWF sea) | AROME + ICON beach |
|---|---|---|---|---|---|---|
| 26 Oct, Sant Pere (U2, 1.3 km) | 5, east, onshore | 8 | 7 | 4 | 5 | 5 |
| 26 Oct, Palamós (Palafrugell, 6 km inland) | 11, south-southwest | 16 | 8 | 8 | 10 | 9 |
| 26 Oct, Pals (Palafrugell, 10 km) | 11 | 16 | 8 | 6 | 7 | 7 |
| 30 Oct, Sant Pere (U2) | 5, east-southeast, onshore | 9 | **13** | 8 | 10 | 9 |
| 30 Oct, Palamós (Palafrugell) | 5, northeast | 10 | 11 | 7 | 9 | 8 |
| 30 Oct, Pals (Palafrugell) | 5 | 10 | 11 | 8 | 9 | 9 |

In plain words:

- **30 Oct was a dead day, and the old setup called it a go at Sant Pere** (13 kn a day ahead,
  13 kn two days ahead; measured 5 kn, gusts never above 9 kn). The wind was onshore, so the
  land mast is a fair witness here. No new setup crossed 12 kn. One false alarm avoided.
- **On 30 Oct the new setup was closest, and Option 1 (my pick on WHE-61) read 3–5 kn high.**
  That's a point against my own pick. One day, though: the backtest above says the opposite
  on go days, and this was not a go day.
- **26 Oct: everyone under-read the south-southwest wind at Palafrugell** (11 kn, gusts 16).
  Option 1 was closest at Palamós (10). The new setup read 6 at Pals, against 11 at a station
  10 km inland: the same "too low at Pals" pattern as the backtest.
- **Verdict: a tie.** Four independent station-days (two stations × two days), both light. This
  neither confirms nor overturns the backtest, and it says nothing about windy days.

What could make this wrong: Palafrugell is inland and 35 m up, so it judges Pals and Palamós
loosely; the archive's "day before" forecast is the run from about 24 h earlier, close to but
not exactly what the app showed. Full hour-by-hour tables, also 2 days ahead:
`python3 tools/backtest/check_recent.py 2026-10-26 2026-10-30`.

## First recommendation (WHE-58, 27 Oct: under review, see above)

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
python3 tools/backtest/review.py --start 2026-01-01 --end 2026-06-23     # rider scores, day 0–2
python3 tools/backtest/review.py --start 2026-07-01 --end 2026-10-25 --drop es-sant-pere-pescador
python3 tools/backtest/check_day.py tools/backtest/snapshot_2026-10-28.json   # one saved day
```

Station pairs are in `tools/backtest/pairs.json`. `tools/backtest/match_stations.py` finds the
nearest Meteocat station for each Catalan spot. Observations come from official open data
only (Meteocat XEMA, Météo-France), never from competitors.
