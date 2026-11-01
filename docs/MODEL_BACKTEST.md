# Which forecast model predicts the real wind best? (WHE-58, WHE-61, WHE-72)

27 Oct 2026. The question: should the app keep Open-Meteo's "best match" model on the offshore
grid cell, or use another model, a mix, or the beach cell?

## Wind measured on the water (WHE-62, 1 Nov): the sea is windier than the land stations

Until now every truth was a land station. This section uses buoys: open data from the
Copernicus Marine In Situ service (public mirror, no account). Script:
`tools/backtest/buoys.py`; full tables: [buoy tables](docs/MODEL_BACKTEST_BUOYS.md).
Jan–Oct 2026, daylight hours, forecasts made the day before (day 0 and 2 in the full tables).

| Buoy | Where | Anemometer | Used for |
|---|---|---|---|
| POEM (CNRS) | 2.3 km off Canet-en-Roussillon; Torreilles 7.2 km, Saint-Cyprien / Canet 7.8 km along the same sandy coast | 2 m, every 10 min | Level at the beach (question B) |
| Cabo Begur (Puertos del Estado) | 25 km off Begur, 38 km from Pals | 3 m, hourly | Level over open sea (A) |
| Tarragona (Puertos del Estado) | 40 km off Tarragona | 3 m, hourly | Level over open sea (A) |

Barcelona and Tarragona's coastal buoys measure waves only, no wind. There is no open
wind measurement on the water near Barcelona that I could find.

### In plain words

- **Over open sea the models are right.** At Begur and Tarragona every model reads within
  about 1 kn of the buoy, slightly high if anything (measured, 270 days, high confidence).
- **Near the beach, every setup reads low, the new 3-model beach mix the most.** Against the
  Canet buoy, on days the wind isn't offshore, forecast a day ahead (Jul–Oct): the old setup
  reads about 1–2 kn low on the best 2 h; the new 3-model beach mix about 4.5 kn low;
  AROME + ICON beach with ECMWF sea about 4 kn low; AROME 1.3 beach alone is closest (0–2 kn low).
- **So the land stations read low, not the forecasts high.** The 3-model mix "won" on land
  because its inland ECMWF cell shares the stations' shelter. On the water it misses half the
  go days the old setup catches (Canet, Jul–Oct: 33–34 % caught vs 54–64 %).
- **This changes my WHE-61 advice.** I recommended AROME + ICON beach, ECMWF sea (option 1).
  On the water it still reads 1–3 kn below today's setup and catches fewer go days. Today's
  setup (best match, sea cell) is the most honest level we have: above the land stations,
  slightly below the water.
- **Storms are under-forecast, by every setup.** Saint-Cyprien on 24 Aug: buoy 34 kn; the day
  before, the old setup said 29, the new mix 19–21. A blend that lowers the level makes this
  worse (safety: storm scoring stays with Product).

### Results at the beach, forecast a day ahead, wind not offshore

Measured wind brought to 10 m (×1.17 from 2 m, neutral log profile over sea). In brackets: the
bias with no height correction at all, the most favourable reading for the forecasts.

| Setup | Torreilles: hourly bias | best 2 h bias | go days 12+ caught | false | Saint-Cyprien: hourly bias | best 2 h bias | caught | false |
|---|---|---|---|---|---|---|---|---|
| Old: best match, sea cell (live today) | −1.5 (+0.2) | −2.1 | 54 % | 14 % | −1.2 (+0.5) | −1.1 | 64 % | 20 % |
| New: 3-model mean, beach cell (WHE-58) | −2.9 (−1.2) | −4.7 | 33 % | 0 % | −3.1 (−1.4) | −4.6 | 34 % | 12 % |
| AROME + ICON beach, ECMWF sea (WHE-61 option 1) | −2.5 (−0.8) | −4.0 | 41 % | 10 % | −2.7 (−0.9) | −3.9 | 45 % | 5 % |
| AROME 1.3 alone, beach cell (2 days' range) | −1.6 (+0.1) | −1.9 | 52 % | 12 % | −0.7 (+1.0) | +0.4 | 88 % | 19 % |

Jul–Oct, 76 days (AROME 1.3 day-ahead runs only exist from the summer). Over all of Jan–Oct
and all directions the ranking is the same, with bigger gaps (tramontane days). Change in best
2 h error against the old setup, 95 % interval over days, a day ahead, all Jan–Oct: new mix
+0.4 … +1.9 kn worse at both spots (beyond the noise); option 1 −1.2 … +0.2 kn (a tie or slightly better); go-day score a tie for both (these intervals use all directions).

Open sea, a day ahead, best 2 h bias: Begur −0.4 (ICON / best match) to +0.9 (AROME 1.3);
Tarragona +0.1 to +0.8.

### Real days at Saint-Cyprien / Canet (wind not offshore, best 2 h, kn, a day ahead)

| Day | Buoy | Old | New 3-model beach | Option 1 | AROME 1.3 beach |
|---|---|---|---|---|---|
| 14 Aug | 18 | 17 | 10 | 12 | 14 |
| 24 Aug (storm afternoon) | 34 | 29 | 19 | 22 | 25 |
| 27 Aug | 34 | 33 | 22 | 24 | 30 |
| 30 Aug | 20 | 23 | 16 | 17 | 21 |
| 28 Sep | 24 | 27 | 20 | 20 | 26 |

### What could make this wrong

- **One buoy near a beach, on one coast.** Roussillon gets tramontane and its coast may
  accelerate wind more than the Costa Brava or Barcelona. Begur and Tarragona agree on the
  "models are right at sea" half, but are 25–40 km out; they say nothing about the last km
  to a Catalan beach. Confidence: high for Canet, medium for Catalonia.
- **The buoy is 2.3 km out; riders are within a few hundred metres.** In onshore and
  sideshore wind the buoy is upwind of the riders, so it's a fair truth; that's why the table
  keeps only those hours. A rider may still meet slightly less than the buoy.
- **Height correction.** 2 m → 10 m with a neutral profile (×1.17). Air was warmer than the
  sea in about a third to half of the hours (measured on the buoys): those stable hours need
  a bigger correction, unstable ones a smaller one. With no correction at all (brackets),
  the ranking doesn't change; the old setup then reads about right.
- **Buoys tend to read low in rough seas** (waves shelter a low anemometer). That would make
  the true wind higher, not lower.
- **Spots 7–8 km from the buoy.** Same straight sandy coast and exposure, but not the same
  point; the spot positions themselves are fine.

### Options

1. **Keep today's setup live (best match, sea cell); don't ship the 3-model beach mix nor
   option 1 for now** (recommended). Next card: test "AROME 1.3 first 2 days, then best
   match" on the sea cell against both buoys and land stations.
2. Ship option 1 (AROME + ICON beach, ECMWF sea) anyway: lower error against land stations,
   but 1–3 kn low on the water and fewer go days caught.
3. Ship the 3-model beach mix as built: reads lowest on the water and misses the most go days.

## Spain and France, 5 setups (WHE-72, 1 Nov): Option 1 wins, except in the Canaries

The question: which of five forecast setups best matches the wind measured near the water, on
the spots testers will use, and where should the forecast be read (beach, 500 m out, 1 km out,
the sea cell)? Forecasts made **the day before** (what riders plan on) and on the day itself,
8 Aug – 30 Oct 2026 (84 days: AROME's day-ahead archive starts on 8 Aug). Scripts:
`tools/backtest/stations.py`, `tools/backtest/esfr_backtest.py`; full tables in
[the combined results](../tools/backtest/results/whe72_all.md), [Spain](../tools/backtest/results/whe72_es.md),
[France](../tools/backtest/results/whe72_fr.md).

### In plain words

- **Option 1 (AROME + ICON on the beach cell, ECMWF on its sea cell) is the best everyday setup.**
  Measured against shore masts, a day ahead: best 2 h error 2.6 kn vs 3.0 today, false "go"
  days 25 % vs 35 %. Both gains are outside the noise and survive dropping any single station.
- **The price: it misses a few more go days and reads a bit low.** Caught 62 % of the go days
  vs 66 % today (95 % interval −7 … −1 points), and it reads 0.6 kn below the shore masts, which
  themselves probably read a little below the water (measured: land masts; on the water: not
  measured yet).
- **In France it's a clear win** (error −0.6 kn, false alarms −7 points, caught a tie).
  **In mainland Spain it wins too** (Catalonia, Valencia/Murcia, Andalusia: fewer false alarms
  and more days caught). **In the Canaries it's much worse:** shore masts at Gran Canaria and
  Lanzarote measured 30–32 kn on the windiest days; Option 1 said 13–15, today's setup 24. There
  is no AROME there and ICON and ECMWF are coarse; whatever "best match" picks is closer.
- **Not worth it:** AROME alone (no better than today, more false alarms); the skill-weighted
  mix (barely better on error, reads lowest, misses more days, and its weights jump between
  regions: it mostly learns to match land stations); all three on the sea cell (ties Option 1 in
  France but in Spain it catches 26 % of go days: ECMWF's sea cell is 13 km out at the median,
  so the 1.5 km cap sends it back to its nearest cell, often inland: the WHE-61 trap again).
- **Where to read AROME: the beach cell.** Reading 500 m out, 1 km out or the sea cell raises
  the forecast by 1.1–1.5 kn: more go days caught (+10 points) but more false alarms (+7 to +10)
  and a higher error against the shore masts. Whether the water is really that much windier
  can't be told without measurements on the water (WHE-62). ICON (cells 2–3 km apart) and
  ECMWF (25 km) are too coarse to tell beach from 500 m.
- **Storm days:** on 23 Oct at Gouville-sur-Mer (Normandy) the mast measured 47 kn for 2 h;
  today's setup forecast 37 the day before, Option 1 46. Under-reading storms is the safety risk,
  and Option 1 does better there.

### Results, forecast made the day before, shore masts

36 spots (17 Spain, 19 France) with an official mast within 1.5 km of the spot, or a shore mast
(about 1 km from the water, ≤ 40 m up) within 5 km. 2,965 spot-days. Best 2 h window of each day
(07–17 UTC), kn, nothing removed. Go day = 12 kn+ for 2 h, direction not offshore. 95 % interval
over days in brackets.

| Setup | Best 2 h bias | Best 2 h error | Go days caught | False alarms | Direction error |
|---|---|---|---|---|---|
| 1 Today: best match, sea cell | +0.1 | 3.0 (2.9–3.2) | 66 % (61–71) | 35 % (30–39) | 19° |
| 2 AROME only, beach cell | +0.1 | 3.0 (2.9–3.1) | 65 % (61–70) | 38 % (32–42) | 19° |
| **3 Option 1: AROME + ICON beach, ECMWF sea** | −0.6 | **2.6** (2.5–2.7) | 62 % (56–67) | **25 %** (21–29) | 17° |
| 4 All three on the sea cell, capped at 1.5 km | −0.5 | 2.7 (2.6–2.8) | 61 % (55–66) | 26 % (22–30) | 17° |
| 5 Skill-weighted (weights fitted on other weeks) | −0.9 | 2.6 (2.5–2.7) | 61 % (55–66) | 23 % (19–27) | 17° |

707 measured go days. Change against today, Option 1: error −0.5 … −0.3 kn, caught −7 … −1 points,
false alarms −13 … −8 points. Same order on the day itself (error 2.6 vs 2.8, caught 63 % vs 69 %,
false 26 % vs 32 %). Weak stations (86 spots, inland or 5–10 km away) give the same ranking.

### Per region (day before, shore masts: best 2 h bias / error · caught / false)

| Region | Spots | Go days | Today | **Option 1** | Verdict |
|---|---|---|---|---|---|
| Catalonia | 10 | 26 | +1.9 / 3.0 · 19 % / 96 % | +1.7 / 2.4 · 31 % / 86 % | Option 1 better; few go days, everyone over-reads |
| Valencia/Murcia | 1 | 29 | −2.4 / 2.5 · 17 % / 0 % | −1.7 / 1.9 · 41 % / 0 % | Option 1 better; one station only |
| Andalusia/Tarifa | 4 | 37 | −2.6 / 3.2 · 51 % / 32 % | −2.9 / 3.3 · 57 % / 28 % | Tie; everyone reads 2–3 kn low |
| Canaries | 2 | 90 | −4.7 / 4.8 · 71 % / 3 % | −6.5 / 6.7 · 40 % / 3 % | **Today's setup much better** |
| Galicia/Cantabrian | 0 | – | – | – | No shore mast; weak stations: Option 1 fewer false alarms, fewer caught |
| Balearics | 0 | – | – | – | No station within 10 km of the spots |
| Languedoc/Roussillon | 3 | 49 | +0.4 / 2.3 · 80 % / 28 % | +0.1 / 1.8 · 73 % / 27 % | Option 1 better on error, tie on days |
| Provence/Corsica | 5 | 180 | +0.2 / 2.9 · 75 % / 20 % | −0.7 / 2.4 · 67 % / 17 % | Option 1 better on error, misses a few days |
| French Atlantic | 4 | 87 | −1.1 / 2.5 · 45 % / 25 % | −1.0 / 2.2 · 47 % / 21 % | Option 1 slightly better (sea-capped best here) |
| Brittany | 2 | 62 | +1.2 / 3.6 · 76 % / 31 % | −0.9 / 3.2 · 68 % / 22 % | Option 1 better on error and false alarms |
| Channel | 5 | 147 | +1.0 / 3.2 · 78 % / 30 % | −0.3 / 2.1 · 82 % / 16 % | Option 1 clearly better |

Regions with 1–2 stations (Valencia/Murcia, Canaries, Brittany) are indications, not proof.

### Where to read AROME 1.3 km (day before, 2,403 spot-days inside AROME's area)

| Read point | Bias | Best 2 h error | Caught | False alarms |
|---|---|---|---|---|
| **Beach cell (today in Option 1)** | +1.2 | **2.7** | 75 % | **40 %** |
| Nearest cell at the pin | +1.5 | 2.7 | 79 % | 42 % |
| 500 m out | +2.3 | 3.2 | 85 % | 47 % |
| 1 km out | +2.7 | 3.6 | 88 % | 50 % |
| Sea cell | +2.7 | 3.5 | 88 % | 50 % |

AROME's cells: beach cell 0.4 km from the pin (median), sea cell 0.7 km. ICON's beach cell is
3.2 km away (median), its sea cell 1.9 km; ECMWF's nearest cell 9.9 km, its sea cell 13.4 km.

### Real days (forecast the day before, best 2 h, kn)

| Day, spot (station, distance) | Measured | Today | AROME only | Option 1 | Sea capped |
|---|---|---|---|---|---|
| 23 Oct, Gouville-sur-Mer (Météo-France Gouville, 1.5 km), storm | 47 | 37 | 47 | 46 | 41 |
| 8 Sep, Gouville-sur-Mer | 35 | 14 | 22 | 19 | 18 |
| 6 Sep, Gran Canaria – Vargas (airport mast, 3.6 km) | 32 | 24 | 14 | 13 | 11 |
| 27 Aug, L'Espiguette (Météo-France, 0.8 km) | 22 | 17 | 22 | 18 | 19 |
| 25 Aug, Torredembarra (Meteocat, 0.6 km) | 14 | 13 | 12 | 14 | 12 |

8 Sep at Gouville: every setup missed a 35 kn day by 13–21 kn; a reminder that a day-ahead
forecast can be badly wrong whatever the setup.

### What could make this wrong

- **Still no measurement on the water.** Shore masts are the best truth found, but they sit on
  land; EMODnet's buoy data server was down (catalogue only) and Copernicus needs an account
  (WHE-62). If the water reads 1–2 kn above the masts, Option 1's −0.6 kn becomes −2 kn and the
  offshore read points start to look right.
- **84 days, late summer to autumn.** No winter, little spring; thermal days only in August–
  September. Catalonia had only 26 go days at shore masts.
- **Station placement.** 9 of 36 main stations are within 1.5 km; the rest are shore masts
  1.5–5 km away. With only the ≤ 1.5 km stations, Option 1 still wins on error (2.7 vs 3.0) and
  false alarms (28 % vs 35 %), and catches about as many go days (51 % vs 48 %). AEMET SYNOP
  positions are rounded to 0.01° (up to ~500 m off). The shore check uses the distance to the
  nearest AROME sea cell (about 1 km precision) and by-hand values south of AROME's area.
- **Spots share stations and days share weather.** Intervals resample whole days, all spots
  together, which is conservative; hours are not counted as independent.
- **Mast heights:** Meteocat masts are corrected to 10 m; Météo-France, AEMET and airports are
  assumed 10 m. Semaphores and cliff stations above 40 m are kept out of the main truth.
- **Earlier Leucate gap explained:** WHE-58's "Leucate data to 23 June only" came from a
  Météo-France mirror on data.gouv that froze on 24 Jun 2026; the scripts now read the live copy.
- **Calais airport** had only one hour of METARs in the period; Calais spots use the
  Météo-France Calais-Marck mast instead.

### Recommendation (settles WHE-61)

1. **Ship Option 1 everywhere except the Canaries; keep today's setup (best match, sea cell)
   for the Canaries** (recommended). Best on error and false alarms in mainland Spain and France,
   better on storm days, and it avoids a 5–10 kn drop at Gran Canaria / Lanzarote. Needs one
   extra rule in KiteCore (by latitude or region), a small follow-up change after your yes.
2. Ship Option 1 everywhere as built. Same gains, but Canaries spots would read 2 kn lower than
   today on average and catch 40 % of go days instead of 71 %.
3. Keep today's setup. Catches 4 points more go days, but 10 points more false alarms and a
   higher error.

Keep AROME on the beach cell (no 500 m / 1 km offset) until water measurements say otherwise.

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
