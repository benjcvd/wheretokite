# Which forecast model predicts the real wind best? (WHE-58, WHE-61, WHE-72, WHE-78, WHE-81, WHE-84, WHE-86, WHE-80, WHE-87)

27 Oct 2026. The question: should the app keep Open-Meteo's "best match" model on the offshore
grid cell, or use another model, a mix, or the beach cell?

## Which forecast for each day ahead, today to +5 (WHE-87, 2 Nov): one 3-model mix beats today's at every lead

**In plain words.** I tested every source Open-Meteo keeps past forecasts for, each on the beach
point and the sea point, for each day ahead from today to +5, against 32 trusted sites over 84 days
(8 Aug – 30 Oct: 19 French masts, 5 southern Spanish masts, 2 Canary masts, 3 buoys, Barcelona
airport and Port Bocana Sud; 2,618 spot-days, 788 measured go days per lead). One rule wins,
the same everywhere: **the mean of Météo-France seamless (beach point), ECMWF 9 km (sea point) and
GFS (sea point)**. Météo-France has no forecast past day 3, so from day 4 the rule falls back to
ECMWF 9 km + GFS by itself.
For riders (measured): on today and tomorrow it catches about 1 more go day in 10 (66 → 75 %,
65 → 73 %) **and** sends fewer people to a dead beach (false gos 23 → 20 %, 26 → 22 %). On days
2–3 it's a tie on go days, with a smaller best-2 h error. On days 4–5 it's slightly better (borderline).
It reads strong days as strong more often than today's source (it doesn't soften storms).

**What the app reads today is not what you think.** "Best match" is not "AROME, then ARPEGE"
everywhere. In the past forecasts it copies ICON-EU on 76–81 % of hours in Spain and at the buoys;
in France it's mostly something unnamed (ICON-D2/AROME blend). Live this afternoon it was Météo-France at
Sant Pere, ICON at Sète and none of the named models at Castelldefels. So today the app reads an
unnamed, place-dependent mix. Naming the models fixes that.

### Winner per day ahead (all 32 sites; Δ = mix minus today, 95 % interval over dates)

| Day ahead | Recommended source (exact Open-Meteo names) | Go days caught | False gos | CSI* gain | Best-2 h error | Bias today → mix |
|---|---|---|---|---|---|---|
| 0 (today) | `meteofrance_seamless` land + `ecmwf_ifs` sea + `gfs_seamless` sea | 66 → 75 % | 23 → 20 % | **+8 (+5…+11)** | 2.7 → 2.1 kn | −0.8 → −0.3 |
| +1 | same | 65 → 73 % | 26 → 22 % | **+7 (+4…+10)** | 3.1 → 2.4 kn | −0.7 → −0.5 |
| +2 | same | 64 → 64 % | 24 → 21 % | +1 (−3…+4) tie | 3.1 → 2.7 kn | −1.0 → −0.9 |
| +3 | same | 62 → 60 % | 27 → 24 % | −0 (−4…+3) tie | 3.3 → 2.8 kn | −1.1 → −1.0 |
| +4 | `ecmwf_ifs` sea + `gfs_seamless` sea (Météo-France has no forecast this far) | 54 → 58 % | 32 → 30 % | +3 (+0…+6) | 3.7 → 3.2 kn | −1.4 → −0.8 |
| +5 (Pro) | same | 55 → 60 % | 35 → 33 % | +4 (+1…+7) | 4.0 → 3.3 kn | −1.2 → −0.7 |

\*CSI = go days caught ÷ (caught + missed + false gos): one score that punishes missed days and dead
beaches equally. The error gain (best 2 h) is real at every lead (interval excludes 0).

Runners-up, for the record: Météo-France seamless on the beach point alone ties the mix on day 0
(CSI +8) but adds false gos from day 1; AROME HD/2.5 only exist to day 1 and only in AROME's domain
(79 % of spot-days); WHE-61 Option 1 (AROME HD + ICON beach, ECMWF 25 km sea) misses go days at
every lead (−5 to −11 points caught); every model on the beach point reads 1–3 kn low except
Météo-France; ECMWF 9 km beats ECMWF 25 km on error at every lead. Full tables:
[results/whe87.md](../tools/backtest/results/whe87.md).

### Per group (CSI / bias kn, today → mix) and robustness

| Day ahead | Barcelona (2 masts) | Canaries | France | South Spain | POEM near-shore buoy | Begur/Tarragona buoys |
|---|---|---|---|---|---|---|
| 0 | 19 → 42 | 72 → 75 | 56 → 67 | 33 → 41 | **53 → 32** | 69 → 80 |
| +1 | 14 → 28 | 67 → 79 | 55 → 62 | 26 → 48 | **54 → 39** | 73 → 74 |
| +2 | 22 → 20 | 67 → 74 | 57 → 57 | 22 → 41 | **48 → 29** | 67 → 69 |
| +3 | 18 → 16 | 70 → 74 | 53 → 53 | 19 → 32 | **45 → 24** | 65 → 64 |
| +4 | 18 → 10 | 63 → 74 | 44 → 49 | 16 → 32 | 33 → 23 | 56 → 52 |
| +5 | 9 → 9 | 61 → 68 | 44 → 49 | 18 → 33 | 34 → 30 | 60 → 55 |

- Without the 19 French masts: the mix still wins day 1 (CSI +6, +2…+11), day 0 borderline (+4, −1…+9), ties after.
- Without the Canaries and southern Spain: same picture as the full set (day 0 +9, day 1 +5, ties 2–3).
- Strong wind (131 spot-days measured ≥ 22 kn, mean 26.5 kn): the mix reads them at 24 kn on day 0 vs 22.6
  today; it reads ≥ 18 kn on 92 % of them vs 79 % (day 0), 76 % vs 63 % at day 4. Safer, not milder.
- [Checks](../tools/backtest/results/whe87_checks.md),
  [without France](../tools/backtest/results/whe87_no_france.md),
  [without the south](../tools/backtest/results/whe87_no_south.md).

### Real days (forecast the day before, best 2 h kn)

| Day | Where | Measured | Today | Mix |
|---|---|---|---|---|
| 26 Aug | Begur buoy | 18, go | 9 | 18, go |
| 1 Oct | Barcelona airport (Castelldefels) | 4 | 9 | 0 |
| 19 Oct | Port Bocana Sud (Barceloneta) | 23, go | 10 | 19, go |
| 27 Aug | Tarragona buoy | 19, go | 21, go | 13, go |
| 27 Oct | Begur buoy | 13 | 7 | 14, false go |

### What could make this wrong

- **Near-shore water (POEM, Roussillon) goes the other way**: there today's source is AROME HD and the
  mix loses badly (CSI 53 → 32 on day 0, reads 3 kn low). One buoy, two spots, 146 spot-days: too few to
  overturn 30 other sites, but it's the one place measured *on the water near a beach*, which is where
  riders are. WHE-62 saw the same. If you know a spot where AROME nails the thermal, that's this effect.
- **Part of the gain is cancellation**: GFS reads high (+0.1…+0.5 kn), ECMWF low (−0.7…−1.2). If one
  model is upgraded the mix shifts; re-run `whe87.py` after any big model change.
- **Day 0 is optimistic**: Previous Runs' day 0 is the latest run (0–6 h ahead); the app's morning look is similar.
- **Masts sit on land**: 21 of 32 sites are shore masts. The result survives dropping France, but the
  mix being slightly low at masts could still mean slightly low on water (buoys: −0.3…+0.0 kn at day 0–1).
- **One autumn**: 84 days, August–October, both thermal and synoptic days, no winter storms. Re-check in spring.
- Barcelona days 2–5 show no gain (157 spot-days, 50 go days: noisy).

### Cost in Open-Meteo calls

Today: 1 request per batch of up to 100 spots (best match, sea point, 6 variables). The mix needs 2
requests per batch (one per point: Météo-France on the beach point; ECMWF 9 km + GFS on the sea point),
like WHE-61 Option 1. Open-Meteo bills per location per request; it doesn't document whether 2 models in
one request count once or twice, so **estimated 2× to 3× today's calls**. New Worker cache keys (one-time
refill). From day 4 the beach-point request can be skipped.

### Recommendation

1. **Ship the mix as one rule for every day ahead (recommended)**: `meteofrance_seamless` on the beach
   point + `ecmwf_ifs` + `gfs_seamless` on the sea point, mean of what answers. Real gain today and
   tomorrow, never worse elsewhere on average, safer on strong days, and the app finally names its models.
   Cost 2–3× calls.
2. Same as 1 but `meteofrance_seamless` beach point alone for today and tomorrow: same day-0 score, more false gos on day 1, two rules instead of one.
3. Keep best match: cheapest, but it reads an unnamed, place-dependent model and misses ~1 go day in 10 at days 0–1.

Before building 1, a one-week live check on POEM-like near-beach spots (WHE-62 buoy) would be wise.

    python3 tools/backtest/whe87.py --fetch      # ~4k weighted Open-Meteo calls, once
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe87.py > tools/backtest/results/whe87.md
    BACKTEST_OFFLINE=1 python3 tools/backtest/whe87_checks.py > tools/backtest/results/whe87_checks.md

## One correction learned from measurements, the same at every spot (WHE-80, 2 Nov): don't ship it

**In plain words.** I learned a correction from 28 trusted stations (18 French masts, 5 southern
Spanish, 2 Canary, the POEM buoy, the Begur and Tarragona buoys) and tested it on weeks it never
saw, at stations it never saw. That second part matters: most spots have no station of their own.
Barcelona airport and Port Bocana Sud were a test only, never used to learn.

Three ways to correct, all the same at every spot (by model, day ahead and wind direction vs the beach):
- **speed bands**: the textbook method (MOS). Add the usual miss for that forecast speed.
- **one factor**: multiply by measured ÷ forecast.
- **quantile map**: stretch the forecast so its spread matches the measured spread.

**What came out (measured, 12 weeks, Aug–Oct 2026):**
- On average the forecast is **already level** at these stations: −0.3 kn, day ahead 0–3. Each
  station is off by its own amount, from −3.7 kn (Gran Canaria) to +4.1 kn (Le Touquet). A
  correction that's the same at every spot can't fix that, because it doesn't know which station
  it's at.
- **Speed bands** cut the average error by only **0.05–0.4 kn** (2–10 %, not the 10–40 % hoped
  for). It does it by pulling every forecast toward the middle: calm hours get +2 to +4 kn,
  25 kn+ forecasts lose 3–5 kn. **Storms vanish**: hours measured 25 kn+ shown under 20 kn go
  from **28 % to 50 %** a day ahead, and from 49 % to 78 % at day 5. Real go days with a Go
  drop (378 → 355 a day ahead).
- **One factor** and **quantile map** keep the storms but make the average error **worse** (+0.1 kn).
- **The fair test for riders**: give each method its own Go cut-off, tuned so a Go comes true
  85 % of the time on other weeks. **No correction catches the most real go days** at every day
  ahead from 0 to 4. A day ahead: 403 of 732 with no correction, against 387 / 397 / 389 with a
  correction.
- **Barcelona test** (airport for Castelldefels, Bocana Sud for Barceloneta): speed bands shrink
  the 2.5 kn shortfall to 1.3 kn and the error 3.3 → 2.8 kn. But the gain is in light hours. On
  sea-breeze afternoons the forecast still reads 10 kn against 17–20 measured. Go still fires on
  0–3 of 50 real go days.

**For riders**: nothing would get better. With speed bands, strong and stormy days would look
milder than they are. That's a safety problem, so it rules them out on its own.

**What would work, and where:** a correction per station, learned from **its own** past misses,
beats every pooled method on everything (error 2.7 vs 3.0 kn a day ahead, 10 kn+ hours 3.6 vs
4.1, storms read under 20 kn 13 % vs 28 %). But it only exists where a trusted station sits
next to the spot (about 30 spots). It also learns the mast's own sheltering. A Catalan mast
would teach the spot to read half the wind (WHE-84). So it's a separate decision, not this card's.

**Recommendation**
1. Don't ship a pooled correction. Keep today's wind as the models give it (recommended).
2. Per-spot correction where an open, trusted station sits within ~5 km, learned only from
   coastal/airport/buoy stations Ben accepts. A new card, report first, then a choice.
3. Speed bands for light winds only (never lower a forecast). It lifts calm hours, which nobody
   rides, and does nothing for Go. Not worth it.

**What could make this wrong**
- 12 weeks of late summer and autumn, mostly France (18 of 28 stations). Winter storms and
  spring thermals aren't in it. The per-station biases might also shift by season.
- The truth stations are land masts brought to 10 m, not the water. Where the sea is windier
  (WHE-62: POEM reads 1–3 kn above every model), the right correction is up, and no mast can teach it.
- The Go cut-offs (WHE-82) were tuned on these same stations without a correction. The
  equal-reliability test re-tunes them per method to keep it fair. Its cut-offs are pooled over
  all stations, the scored one included, the same way for every method.
- Only best match is scored for the wind shown. Gusts weren't tested (the cached Previous Runs
  hold speed and direction only).

**Sanity check, a day ahead, measured / today / speed bands / own station (kn):**
- Tarifa, 20 Sep, levante, 12 UTC: 31 / 25 / 23 / 26. Speed bands make a storm milder.
- Castelldefels (airport), 14 Sep, sea breeze, 15 UTC: 19 / 10 / 11 / 12. No correction rescues it.
- Hyères Almanarre, 17 Sep, 14 UTC: 19 / 28 / 24 / 25. Here speed bands help: the forecast was too strong.
- Carro, 8 Oct, mistral, 16 UTC: 29 / 20 / 19 / 20.

Full tables (by area, day ahead, station; Go before and after): `tools/backtest/results/whe80.md`.
Script: `BACKTEST_OFFLINE=1 python3 tools/backtest/mos80.py` (cache only, ~1.5 min).

## Barcelona's open masts: Catalan forecasts read low, not high (WHE-86, 2 Nov)

**In plain words.** Catalonia's open harbour data (Puertos del Estado) has sea level only, no wind.
But the Llobregat delta has five official masts within 8 km, from two networks: Barcelona
airport (AEMET) and four Meteocat masts, two of them in the Port of Barcelona. The airport and
the Port's harbour-mouth mast (Bocana Sud) read the same wind (0.97 to 1.01). The sheltered
Meteocat masts read 0.6 to 0.7 of it. So WHE-84 was right that most Catalan masts read low, and
the cause is where they stand, not the sensors.

Measured against these two open masts, the forecast is **too light, not too strong**: about
**2.5 kn under on the best 2 h** (the airport afternoon averaged 11.7 kn, the 4 models 8.8).
A Go held **98 %** of the time (91–100 %, 41 Go spot-days over 17 dates, days ahead 0–4). But Go
fired on only **13 %** of the days that really were go days (40 of 310). At Castelldefels, read the
way the app reads it, Go never fired, against 100 measured go spot-days at the airport. Météo-France
(AROME) came closest, ICON and ECMWF lowest (table below).

**For riders**: around Barcelona the app misses good sea-breeze afternoons. It doesn't send
people to dead beaches. For Empordà (Sant Pere, Roses) and the Ebro delta there is still no open
shore mast: every Meteocat mast there reads like the sheltered ones (0.5–0.6). This check can't
settle Sant Pere's sea-breeze afternoons. The Begur buoy (WHE-62, forecast about right at sea)
stays the only open measurement up there.

**Recommendation**
1. Add Barcelona airport and Port Bocana Sud to the trusted truth for the Go cut-offs and
   for WHE-80's correction. Keep every other Catalan Meteocat mast out (recommended).
2. Treat Barcelona's ~2.5 kn under-forecast as one input to WHE-80's correction, not as a
   Barcelona-only fix. Two masts on one stretch of coast is too little to tune a region on.
3. For Sant Pere, ask Ben how often a forecast 12–14 kn tramontana or sea-breeze afternoon is
   actually rideable. No open sensor can answer it.

### Masts against the airport, no forecast involved (8 Aug – 25 Oct, 07–17 UTC, airport ≥ 10 kn)

| Mast | Height | km | Ratio to airport | Sea breeze (S–SW) |
|---|---|---|---|---|
| AEMET airport SYNOP (same mast, other feed) | 10 m | 0 | 1.00 | 1.00 |
| Meteocat Port de Barcelona – Bocana Sud (harbour mouth) | 10 m | 7.6 | **0.97** | 1.01 |
| Meteocat Port de Barcelona – ZAL Prat (behind the docks) | 10 m | 5.5 | 0.62 | 0.61 |
| Meteocat El Prat (town edge) | 10 m | 4.8 | 0.69 | 0.78 |
| Meteocat Viladecans – les Filipines (behind the beach) | 2 m → 10 m | 3.0 | 0.70 | 0.81 |

### Forecast at each mast (any direction counts), WHE-84 85 % cut-offs, not refitted

| Mast | Measured ÷ forecast | Forecast − measured, best 2 h | Go came true (all days ahead) |
|---|---|---|---|
| Barcelona airport | 1.06 | −2.7 kn | 5 of 5 |
| Port Bocana Sud | 1.06 | −2.4 kn | 35 of 36 (98 %) |
| Port ZAL Prat | 0.64 | +1.5 kn | 9 of 25 |
| Illa de Buda (Ebro delta) | 0.51 | +3.4 kn | 4 of 80 |
| Sant Pere Pescador | 0.62 | +4.2 kn | 9 of 68 |
| Roses | 0.56 | +5.1 kn | 32 of 71 |

Full tables, per day ahead and with intervals: `tools/backtest/results/whe86.md`.

### Sanity check: the windiest airport afternoons (day-ahead forecasts, best 2 h, kn)

| Day | Airport | Port Bocana Sud | Best match | Météo-France | ICON | ECMWF |
|---|---|---|---|---|---|---|
| 14 Sep | 19.5 | 18.9 | 12.4 | 15.3 | 9.4 | 10.8 |
| 4 Sep | 18.5 | 16.4 | 12.4 | 16.6 | 9.2 | 9.4 |
| 14 Aug | 17.0 | 16.1 | 9.3 | 14.6 | 7.2 | 9.0 |
| 9 Oct | 15.5 | 13.2 | 6.9 | 11.5 | 5.7 | 6.1 |

The two masts agree to about 2 kn on each day. The models sit 3 to 10 kn under them.

### What could make this wrong
- **Land vs water**: both masts are on land, on a flat delta and a breakwater. Water is usually
  windier still, so the under-forecast is more likely an underestimate than an overstatement.
- **Distance**: Castelldefels and Barceloneta are 7–9 km from the masts, beyond the 5 km rule.
  The Llobregat delta may be windier than the beaches either side.
- **Sample**: 17 Go dates. 98 % has a 91 % floor, but the "only 13 % caught" figure carries more
  weight than the hit rate.
- **Units**: METAR speeds are whole knots and 10-min means. Meteocat values are 30-min means. That
  can't explain Bocana Sud matching the airport while ZAL Prat, 3 km away, reads 0.62.
- **Not tested**: whether Illa de Buda's low reading is siting (it looks exposed on the map) or the
  sensor. I can't check that without a site visit or Meteocat's metadata.

## Why a Go so rarely came true in Spain, and Go set at 80 % (WHE-84, 1 Nov)

**In plain words.** The 24 % wasn't "Spain". It came from the **Catalan Meteocat masts**. Whenever
the forecast says 10 kn or more, they measure about **half** of it, in every wind direction. French
masts measure about 0.85 of the forecast, the southern Spanish masts about 1.0, and the two open-sea
buoys off Catalonia (Begur, Tarragona) 0.94. So the models are about right at sea off Catalonia, and
the masts can't see a kiteable day: on 9 Sep the Begur buoy measured 35 kn of tramontana (forecast
36) while the Sant Pere mast showed 8. Leave the Catalan masts out as truth and the method works
everywhere I can check: **Go came true 82–97 %** in France, the south of Spain and at the buoys,
tomorrow and today. On the rest of mainland Spain the sample is too small to prove it beyond day 1.
A separate "Most likely" (≥ 70 %) band doesn't hold up: below the Go cut the hit rate drops straight
under 70 %, so the band is almost always empty.

**What changes for riders:** nothing yet (report only). If you pick the recommendation, a Go means
"8 times out of 10 you ride", and it flags about 6 days out of 10 of the real go days tomorrow (France).

### 1. Cause, checked one suspect at a time (day-ahead forecasts, 8 Aug – 30 Oct)

Scripts: `tools/backtest/diag84.py` (collect), `diag84_report.py` (tables). Full per-station tables:
[whe84_diag.md](../tools/backtest/results/whe84_diag.md).

| Suspect | What I found | Verdict |
|---|---|---|
| Mast height | Meteocat publishes which height each station reports: all Catalan pairs are 10 m except Cambrils (Vinyols, 2 m, corrected). Castelló d'Empúries (Empuriabrava) has no wind sensor at all | not the cause (measured) |
| Time base | Meteocat's dataset metadata: times in UTC, each value labelled by the start of its 30 min period. Measured and forecast afternoon peaks fall at the same hour (12–14 UTC) | not the cause (measured) |
| Averaging | Meteocat: 30 min scalar mean; Météo-France and AEMET: 10 min mean; model: hourly value. Explains a few %, not a factor of 2 | not the cause (estimated) |
| Go rule vs sea breeze | Catalan peaks 12–14 UTC sit well inside 07–17 UTC; on forecast-go days measured and forecast direction agree (off by > 45° in 10–24 % of hours, France 3–18 %, Hendaye 34 %) | not the cause (measured) |
| Offshore rule | At most 2 measured go days per Catalan station lost to it. **But Tarifa loses 46** (levante, which Balneario rides) and Lanzarote 52 (trades, really offshore) | not the Catalan cause; Tarifa needs a look (Spot improvement) |
| Shelter and siting | Measured ÷ forecast speed when the forecast says ≥ 10 kn: **Catalonia 0.56 onshore / 0.47 other**, France 0.88 / 0.82, south Spain 0.92 / 1.16, POEM near-shore buoy 0.95 / 1.12, Begur + Tarragona buoys 0.94. Meteocat sites: a farm (Sant Pere, 1.6 km inland), a fire station in town (Castell d'Aro), a school at 30 m (Cambrils), wetland (Torredembarra), delta farmland (Illa de Buda) | **the cause (measured)** |

Which stations drive it: of 99 day-ahead best-match Go days in Catalonia, **51 are Sant Pere**
(2 came true; measured median 8.7 kn), then Illa de Buda/Riumar 15 (0), Castell d'Aro 12 (0),
Malgrat 11 (0). Dropping Sant Pere doesn't rescue the rest: 2 of the other 48 came true.

The "Spain reads 4 kn high" from WHE-81 (A2 b = −4.5 / −2.0) is a mix, not one offset: on
average over all days the forecast at Catalan masts is only +1.7 kn high, but **+5 to +7 kn on
forecast-windy days**. Meanwhile it reads 2.2 kn *low* in the south of Spain and 4 kn low in
the Canaries. Pooled into one "Spain" number, it came out as −4.5 kn with a very wide spread.

Is the forecast high at Sant Pere too? Partly, I think. On SE sea-breeze days it says 22–25 kn
where Begur measured 13–18 kn (26 Aug: forecast 24, buoy 18, mast 10). The truth at the beach is
probably in between. Only your experience or a measurement on the water can settle it.

### 2. Go and Most likely, one method everywhere

Chance = WHE-81's A2 (4 models' mean best 2 h against 12 kn, widened by their spread). Per day
ahead, on even weeks: fit the formula, then pick the lowest Go cut-off whose Go days came true
≥ target, and a Most likely cut-off whose band came true ≥ 70 %. Score the odd weeks, then swap.
Nothing is tuned per country. Truth for tuning: France masts, southern Spain masts, POEM and the
two open-sea buoys (Catalan masts and Canaries left out; the Canaries were never in the tuning).
Script `tools/backtest/thresholds84.py`, run offline from the cache. Buoys have days 0–2 only.

**Tuned to 85 % on the tuning weeks (recommended, it lands ≥ 80 % on unseen weeks):**

| Day ahead | Group | Go came true (95 % range) · spot-days | Wrong gos | Real go days flagged Go |
|---|---|---|---|---|
| 0 | France | **83 %** (79–86) · 369 | 17 % | 68 % |
| 0 | Mainland Spain, south masts | **85 %** (67–100) · 20 | 15 % | 33 % |
| 0 | POEM near-shore buoy | **97 %** (89–100) · 29 | 3 % | 40 % |
| 0 | Open-sea buoys | **89 %** (80–95) · 71 | 11 % | 83 % |
| 1 | France | **82 %** (77–87) · 317 | 18 % | 58 % |
| 1 | Mainland Spain, south masts | **87 %** (67–100) · 15 | 13 % | 25 % |
| 1 | POEM near-shore buoy | **93 %** (79–100) · 29 | 7 % | 39 % |
| 1 | Open-sea buoys | **93 %** (86–98) · 60 | 7 % | 74 % |
| 2 | France | **84 %** (80–89) · 299 | 16 % | 56 % |
| 2 | Mainland Spain, south masts | 71 % (44–94) · 17 | 29 % | 23 % |
| 2 | POEM / open-sea buoys | **100 %** · 21 / **85 %** · 60 | 0 / 15 % | 30 / 67 % |
| 3 | France | **85 %** (81–90) · 219 | 15 % | 41 % |
| 3 | Mainland Spain, south masts | 60 % (30–90) · 10 | 40 % | 12 % |
| 4 | France | **85 %** (81–90) · 204 | 15 % | 38 % |
| 4 | Mainland Spain, south masts | 75 % (50–100) · 8 | 25 % | 12 % |
| any | Catalan masts (not trusted) | 4–15 % | 85–96 % | 4–32 % |

Go cut-offs found: about 0.61–0.73 of the A2 chance for days 0–2, 0.66–0.79 for days 3–4.
Tuned to exactly 80 % instead, the unseen weeks land at 76–80 % in France and 41–81 % in southern
Spain, with more days flagged (France 67–77 % of go days on days 0–2):
[whe84_thresholds_trusted80.md](../tools/backtest/results/whe84_thresholds_trusted80.md). With
the Catalan masts kept in the tuning (as WHE-81 did), the cut-offs rise and France flags only
53–58 % of its go days, for nothing gained in Catalonia (6–18 %):
[whe84_thresholds_all80.md](../tools/backtest/results/whe84_thresholds_all80.md). 85 % run:
[whe84_thresholds_trusted85.md](../tools/backtest/results/whe84_thresholds_trusted85.md).

**Most likely (≥ 70 %)**: the method finds a band in only 1 of 10 lead/week fits; the rest of the
time, no band just under the Go cut-off reaches 70 % with 30+ spot-days. With today's 4 models, "70–80 % sure"
is too thin a slice to show reliably.

### What could make this wrong

- The southern Spain sample is small (8–29 Go spot-days per lead): 80 % holds on days 0–1 and is
  unproven on days 2–4 (60–75 %, wide ranges).
- Truth for "the water" is two open-sea buoys 25–40 km out and one near-shore buoy in France. I
  have **no** wind measured on the water near a Catalan beach, so I can't say how far the beach
  sits between the mast (half) and the open sea (full). Catalonia stays unverified.
- 84 days, late summer to autumn only. Winter tramontana and mestral days are barely in it.
- Torredembarra's mast serves three spots: its days count three times in the Catalan totals.
- The forecast at Sant Pere may itself be high in SE sea breezes (see above). Dropping the masts
  doesn't make the app right there; it only stops them hiding the question.
- Open-Meteo's daily quota was spent during this run, so everything came from the WHE-81/WHE-62
  cache. The POEM spots were read with WHE-62's AROME 1.3 in place of Météo-France seamless (the
  same model at days 0–2).

### Recommendation

1. **Go = A2 chance above the per-day cut-off tuned to 85 % on France + southern Spain + buoys,
   Catalan masts out of the truth (recommended).** On unseen weeks: 82–85 % in France at every day ahead,
   85–100 % at the buoys, 85–87 % in southern Spain on days 0–1 (too few days after that).
2. Same, tuned to 80 %: catches more go days, but France lands at 76–80 % on unseen weeks.
3. Keep WHE-81's truth (Catalan masts in): stricter cut-offs, fewer go days caught, Catalonia
   still fails.

Drop "Most likely" as a 70 % band; if the app needs a second label, make it a plain "Maybe"
(chance 40 % up to the Go cut-off) with no promise attached. For Catalonia, the next step is
ground truth: your memory of a few dated days at Sant Pere and Riumar, or a water station.

## "Chance you'll kite": models agreeing or a 51-member ensemble? (WHE-81, 1 Nov)

**In plain words.** Each spot-day gets a label: **Go** (chance ≥ 70 %), **Probably** (40–70 %),
**Long shot** (15–40 %), **No** (< 15 %). Your pass bar: each label's real hit rate must land in its
own band, on days not used to tune it, separately for tomorrow and for 3 days out, per country, with
enough days behind it (I used ≥ 30 spot-days over ≥ 15 dates). Truth: 36 shore masts in Spain and
France plus the POEM buoy, 84 days (8 Aug – 30 Oct). A real go = two hours in a row at 12–28 kn,
direction not offshore.

- **(A) Agreement rule** (your idea): how far the 4 models' best 2 h sits above 12 kn, and how
  much they disagree, becomes a chance. Two numbers to tune, the same everywhere.
- **(B) Existing go rule run on each of ECMWF's 51 ensemble members**: chance = share that say go.

**Verdict (measured).**
- **France passes with A, both lead times.** Tomorrow: Go 86 % came true, Probably 59 %, Long
  shot 29 %, No 4 %. 3 days out: 86 / 61 / 30 / 6 %. Wrong gos on "Go": 14 %, against 38 % for
  today's yes/no forecast. It also passes at 15 kn+.
- **Spain fails, with every method.** That's Catalonia: its masts measured a go on only 3 % of days,
  so even "Go" days were windy at the mast 8 % of the time. Andalusia + Valencia look right (Go
  75 %, Probably 61 %, Long shot 40 % tomorrow) but have only 8 Go days: too few to pass. The
  Canaries are too few on their own as well.
- **B is never clearly better, and usually worse.** It passes in France at 12 kn (Go 76 %), but
  it's too sure overall (Go 63 % tomorrow) and fails France at 15 kn. It costs about 7–8× the
  Open-Meteo quota. **Keep A.**
- **One offset per country doesn't rescue Spain.** The two halves of the data disagree (−4.5 kn
  vs −2 kn), so it's tuning to noise, and Go days get too few to judge.
- **3 days out holds up almost as well as tomorrow** (skill +0.38 vs +0.41). That's
  summer-autumn: steady thermals are easy to see coming. Expect winter to be worse.

**What this means.** A works and can be trusted in France. In Catalonia, where testers start, it
can't be shown to work yet. I can't tell whether the models are wrong or the masts are sheltered:
WHE-62 found the sea windier than these land stations, and the POEM buoy (water) says every
method under-calls (Long shot days were windy 63 % of the time). There's not enough buoy data to
pass or fail anything.

**Recommendation.**
1. Adopt A as the method. Show labels in France now; in Spain show them only after WHE-80 (the
   land-vs-water correction) and a Catalan check on the water or against your own sessions.
   (recommended)
2. Adopt A everywhere now and accept that Catalan labels are unproven.
3. Ensemble members (B): no. Not better, much more expensive.

### Labels at 12 kn+: share that came true (spot-days / dates), held-out weeks

| Method · lead | Group | Go | Probably | Long shot | No | Wrong gos on Go | Bar |
|---|---|---|---|---|---|---|---|
| A · tomorrow | France | 86 % (260/58) | 59 % (206/71) | 29 % (268/74) | 4 % | 14 % | **pass** |
| A · 3 days | France | 86 % (221/59) | 61 % (189/68) | 30 % (315/79) | 6 % | 14 % | **pass** |
| A · tomorrow | Spain | 52 % (54/41) | 47 % (125/61) | 17 % (235/72) | 4 % | 48 % | fail: Go too sure |
| A · 3 days | Spain | 58 % (59/44) | 43 % (127/57) | 17 % (240/72) | 4 % | 42 % | fail: Go too sure |
| A · tomorrow | Catalonia | 8 % (26/21) | 9 % (57/33) | 7 % (181/60) | 1 % | 92 % | fail (truth in doubt) |
| A · tomorrow | Andalusia + Valencia | 75 % (8/8) | 61 % (31/22) | 40 % (40/30) | 4 % | 25 % | too few days |
| B · tomorrow | France | 76 % (411/72) | 43 % (90/54) | 34 % (85/50) | 7 % | 24 % | pass |
| B · 3 days | France | 79 % (341/65) | 44 % (138/60) | 29 % (193/69) | 7 % | 21 % | pass |
| B · tomorrow | Spain | 35 % (195/66) | 27 % (79/44) | 22 % (108/45) | 5 % | 65 % | fail |
| B · 3 days | Spain | 37 % (154/55) | 21 % (117/50) | 13 % (152/57) | 7 % | 63 % | fail |
| A · tomorrow | POEM buoy (water) | 92 % (24/13) | 73 % (22/16) | 63 % (30/23) | 19 % | 8 % | too few days |

At 15 kn+: A passes France for both leads (tomorrow Go 74 %, 3 days 78 %); B fails France (Go 64–66 %).
Today's yes/no forecast is wrong on 38 % (tomorrow) and 39 % (3 days) of its gos on all masts.
Overall skill (Brier, all masts): A +0.41 / +0.38 (tomorrow / 3 days), B +0.20 / +0.22, today +0.05 /
+0.03. The A − B gap is outside the 95 % interval at both leads. Full tables, the 15 kn labels and
the regions: `tools/backtest/results/whe81.md`.

**How A works.** chance = Φ((models' mean best 2 h − 12 kn + b) / √(spread² + s²)), with b ≈ −1 kn and
s ≈ 2.5–3 kn, fitted per lead time on the other weeks. Both halves of the data gave nearly the same
numbers. Models: best match (sea cell), AROME 1.3 (beach cell), ICON (beach cell), ECMWF (sea cell);
at 3 days AROME has stopped, so Météo-France's seamless model stands in for it. The app's confidence
request already fetches 4 models, so A needs no new requests.

**Concrete days.** Sant Pere Pescador, 15 Aug: today said go, A gave 21 % (Long shot), the
ensemble 0 %; measured dead. Cayeux-sur-Mer, 9 Oct: today said no, A and the ensemble said 100 %;
measured go. Segur de Calafell, 28 Aug: ensemble 90 %, A 21 %; measured dead.

**What could make this wrong.**
- Truth is land masts. In Catalonia they look sheltered (3 % go days), so the Spain result may be
  about the masts rather than the forecast. Only water or rider data can settle it.
- Summer and early autumn only. Winter storms and day-3 decay in winter aren't tested.
- One rider (75 kg, 9 + 12 m, intermediate: 12–28 kn). No gusts in the station data, so the
  gust part of the score isn't tested. B used the go rule (range + direction) on each member, not
  the full Swift scorer; gusts are the only part missing, and they're untested for A too.
- Ensemble read every 3 h from the 12 UTC run, interpolated. Spot-days aren't independent:
  intervals resample whole dates.

## AROME 1.3 first, then best match, on the sea point (WHE-78, 1 Nov): don't ship it

**In plain words.** The idea (from WHE-62): read AROME 1.3 on the sea point while it has data,
best match after. Three things came out:

- **It changes less than expected.** AROME's runs stop after 2 days, so from day 2 on it *is*
  today's setup. And for the forecast made the day before, best match already equals AROME 1.3
  at Sant Pere Pescador, Torreilles / Saint-Cyprien (the spots next to the POEM buoy), Hyères
  and Brittany (measured: 100 % of hours identical). So the near-shore buoy result in WHE-62
  ("AROME closest on the water") was today's setup all along for day 1. The change only does
  something at the other 24 checked spots, on days 0 and 1.
- **Where it changes something, it reads about 2–3 kn higher than today.** Against shore
  stations: best 2 h +2.7 kn high (today +0.4), error 3.3 kn (today 2.6). It catches 89 % of
  go days (today 65 %), but half its "go" calls are false (today a third). Against the two
  open-sea buoys it is +0.7–1.2 kn high where today's setup is about right.
- **Worst in Catalonia**, where testers start: light days read +4 kn high, so thermal
  afternoons measured at 9–10 kn show as 17–18 kn (Segur de Calafell, 21 and 23 Oct; the wind direction kept those two out of the go count).

The one real upside: on strong days (18 kn+ measured) it is the only setup that doesn't read
low (+1.0 kn vs −2.3 today at shore stations; Carnon 30 Sep: 28 kn measured, 29 forecast, 16
today). That is a safety point worth keeping in mind, but it comes from reading everything
~2 kn higher, not from catching storms specifically.

**Recommendation.**

1. **Don't ship AROME-first on the sea point** (recommended). The choice stays between today's
   setup and option 1 (WHE-62 / WHE-72).
2. AROME first on the *beach* point, best match after. Against shore stations it's a small,
   real gain (best 2 h error −0.1 … −0.3 kn, go days caught +7 … +16 pts, false alarms about the
   same), but next to the POEM buoy it reads 2 kn low on day 1 and misses go days. Not enough
   water truth to ship it.
3. Ship AROME-first on the sea point anyway, for its strong-day level. Half the go calls false.

**Numbers.** Shore stations: 37 WHE-72 main pairs inside AROME's domain, 24 where the change
does anything; 8 Aug–30 Oct (AROME's day-ahead archive starts 8 Aug); daylight 07–17 UTC;
station wind brought to 10 m; nothing removed; 95 % intervals from a bootstrap over days.
Go day = best 2 h ≥ 12 kn, wind not offshore. Full tables, including days 0 and 2–3:
`tools/backtest/results/whe78.md`; script `tools/backtest/arome_first.py`.

Day 1 ahead, the 24 spots where it changes something (1,987 spot-days, 427 go days):

| Setup | Best 2 h bias | Best 2 h error | Go days caught | False alarms |
|---|---|---|---|---|
| Today: best match, sea point | +0.4 | 2.6 | 65 % | 34 % |
| AROME first, sea point | +2.7 | 3.3 | 89 % | 50 % |
| AROME first, beach point | +1.1 | 2.4 | 77 % | 38 % |
| Option 1 (reference) | +0.2 | 2.2 | 67 % | 26 % |

Difference AROME-first sea − today, 95 % interval: error +0.5 … +0.8 kn, caught +20 … +30 pts,
false alarms +12 … +20 pts. Dropping any one station moves the error by under 0.1 kn.

Buoys, day 1 (best 2 h bias / error, kn):

| Buoy | Today | AROME first, sea | Option 1 |
|---|---|---|---|
| Cabo Begur, 25 km out (84 days) | −0.2 / 2.3 | +1.1 / 2.5 | −0.1 / 1.9 |
| Tarragona, 40 km out (83 days) | −0.7 / 2.1 | +0.7 / 2.1 | −0.6 / 1.7 |
| POEM, 2.3 km off Canet, read at the 2 spots (146 days) | −0.4 / 3.5 | same as today | −3.8 / 4.1 |

On day 0 at POEM, AROME-first sea *is* better (bias −0.7 vs −2.3, error 2.7 vs 3.1): best match
on the same-day run is not AROME there. Day 0 matters less: riders plan 1–4 days ahead.

Best 2 h bias by how windy the day was measured (day 1, the 24 spots): under 12 kn: today
+1.0, AROME first +3.1; 12–18 kn: −0.6 vs +1.8; 18 kn+: −2.3 vs +1.0. Careful: sorting days by
the measured wind pushes every forecast low on windy days and high on calm ones (regression to
the mean), so read only the gap between setups, not the levels.

**Sanity check, three days (forecast made the day before, best 2 h, kn).**

| Day, spot (station) | Measured | Today | AROME first sea |
|---|---|---|---|
| 30 Sep, Carnon (Météo-France 34154001) | 28 | 16 | 29 |
| 4 Oct, Torredembarra (Meteocat DK) | 14 | 10 | 13 (go) |
| 23 Oct, Segur de Calafell (Meteocat WZ) | 10 | 15 | 17 |

**What could make this wrong.**

- Shore stations read low behind dunes and buildings (WHE-62). If riders get ~2 kn more on the
  water than the masts, part of AROME-first's "too high" is real. Against that: the open-sea
  buoys, which have no shelter, also say it reads ~1 kn high.
- Only one buoy near a beach (POEM), and there the change does nothing on day 1. Near-shore
  water truth is still the gap; none is open near Barcelona.
- Autumn only (Aug–Oct, 12 weeks): no winter tramontana season, few thermal days left after
  mid-September.
- Why best match equals AROME 1.3 at those 5 spots on day 1 but not on day 0 is
  observed, not explained (I think Open-Meteo picks its best match differently for the
  same-day run). If Open-Meteo changes that logic, today's setup changes with it.

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

> Read this with the buoy section above (WHE-62): on the water, Option 1 still reads 1–3 kn
> low and catches fewer go days than today's setup, so the land-station win here is partly shelter.

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

## Built: option 1 (WHE-61, 31 Oct, waiting for Ben's yes)

> Since built, the buoys (WHE-62, top of this report) show option 1 reads 1–3 kn low on the
> water: the current recommendation is to keep best match on the sea cell until the next test.

The Lead picked option 1 below; it's now what the app reads on branch `atlas/forecast-accuracy`
(commit 6e9894c), not on `main` yet.

- **What riders see**: AROME 1.3 and ICON read on the beach cell, ECMWF on its nearest sea
  cell, then averaged. On light or onshore days the level is close to today's; where ECMWF's
  beach cell sat inland, the new setup no longer drags the wind down.
- **Live check, Salou, 1 Nov 14:00** (forecast, not yet measured): AROME 12.4, ICON 10.2,
  ECMWF sea cell 15.0 → app shows **12.5 kn** (matches the hand-computed mean). ECMWF's beach
  cell is ~19 km inland and reads 3.2 kn: the WHE-58 build would have shown 8.6 kn, "too light".
- **Cost**: two Open-Meteo requests per batch instead of one (one per cell), so about twice
  the calls per uncached spot. The Worker keys its cache on the full query: no server change,
  but its old cache entries won't be reused.
- **Still open**: the confidence badge compares its 4 models on the beach cell, ECMWF
  included, so an inland ECMWF can make it look less sure than it is (new card). Revisit the
  whole choice once wind on the water (WHE-62) and the Barcelona replay (WHE-63) are in.
- **Against it**: on 30 Oct (one light day) option 1 read 3–5 kn high (see
  [Recent days on the Costa Brava](docs/MODEL_BACKTEST.md#recent-days-on-the-costa-brava-whe-60-31-oct-two-light-days)).
  One day proves nothing either way, but if the replay shows false go days on light
  afternoons, that's the weak spot to look at.

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
