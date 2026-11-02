# Scoring check on typical Barcelona wind days (WHE-64)

Checked on 31 Oct 2026. No scoring rule was changed: every fix below is a proposal for you to decide.

## How it was run

- `swift run kite --day <day> --slot afternoon --drive 180 --hourly 6 --all`, from Barcelona centre.
- Rider: 75 kg, 9 and 12 m kites, intermediate, all types (the saved CLI profile).
- Forecast: the current app setup (AROME HD + ICON + ECMWF mean, beach cell), read from Open-Meteo's archive of past forecasts.
- Days were picked from AROME's afternoon winds at Castelldefels, Sant Pere Pescador, the Ebro delta and Leucate, April to October 2026.
- Raw outputs: `/tmp/whe64/` (not committed).

## The days

| Day | Regime | Top of the list | Verdict |
|---|---|---|---|
| 28 Jul | Garbí (SW sea breeze, 14 kn at Castelldefels in AROME) | Trabucador 56, Sant Pere 46, Castelldefels 42 | Right spots, scores far too low: every hour is "gusty" |
| 4 Sep | Strong Garbí (14.7 kn SW in AROME) | Saint-Cyprien 56, Trabucador 48; Castelldefels 0, "too light 10–11 kn" | Forecast problem: the blend loses the Garbí (see [Forecast side](#forecast-side-not-scoring)) |
| 2 Jul | Tramontana (24 kn NNW Empordà, 22 NW g44 Leucate) | Riumar 21 **"offshore"**, Trabucador 21, Estartit 10 "offshore" | Laughable: #1 is labelled offshore; Leucate shut out by the gust limit |
| 14 Apr | Tramontana, moderate (20 kn NNW Empordà) | Grazel 41, Barcarès 36, L'Escala Riells 34 | Plausible ranking; scores low (gusts) |
| 23 Apr | Llevant (E/ENE 13 kn) | Saint-Cyprien 66, Cambrils 58, Narbonne 53, Malgrat 50 | Sensible |
| 19 Oct | Mestral at the delta (NNW 17–22 kn) + ENE at Barcelona | Trabucador bay side 56, Vilanova 47 | Sensible; Badalona "too light" at 13–14 kn is a wrong label |
| 8 Oct | Mestral + Tramontana (NW 20 kn, gusts 40+) | Vilanova 36 from **one hour**, then 20s | Ebro delta all "too strong for level" at 21 kn mean; Vilanova is a fluke |
| 14 May | Ponent (W, offshore at Barcelona) | Barcarès 39, then a list of "offshore" spots scoring 1–26 | Castelldefels 20 "offshore" is listed as an option; Leucate lagoons "too strong" at 21 kn |
| 21 Jun | Empordà summer thermal (ESE) | Sant Pere 70 | Exactly right |
| 24 Aug | Stormy SE day | Saint-Cyprien **78**, 13–15 h, storm from 16 h | Unsafe: top pick ends one hour before a thunderstorm |
| 15 Oct | Flat | Lac de la Ganguise 45, everything else 0 | Fine |

## Findings, worst first

### 1. A thunderstorm one hour after the session doesn't lower the score

- 24 Aug, Saint-Cyprien: 95 at 13 h, 68 at 14 h, 31 at 15 h, then "thunderstorm risk" from 16 h. It's the #1 pick at 78, window 13–15 h.
- The storm hours themselves score 0 (your rule works), but nothing protects the hour before. Storm cells arrive early more often than late, and the outflow gust comes ahead of the cell.
- Same day: Sant Pere 34, Empuriabrava 33 and Trabucador 32 are listed with "thunderstorm risk" as their label, from the hours either side of a storm.

**Options**
1. Hours within 2 h of a storm hour score 0, flagged "thunderstorm nearby" (recommended).
2. Keep the score, add a red warning on the card when a storm is forecast later in the slot.
3. Leave as is.

### 2. "Gusty" fires on almost every hour, which halves every score

- 131 of the 132 kiteable hours across these days are flagged gusty. Average forecast gust / mean wind: **1.77**.
- The rule tolerates gusts up to 1.4× the mean (intermediate, all types). At 1.77× the steadiness factor is 0.45, so a clean Garbí at Castelldefels (13 kn, gusts 23) scores 42 instead of about 90.
- Knock-on: the "go" card needs 40, so on good days it barely shows, and the flag no longer tells a gusty day from a steady one.
- The same ratio trips the intermediate gust limit (34 kn) at about 19 kn mean wind: Leucate lagoons at 21 kn (14 May), the whole Ebro delta at 21 kn Mestral (8 Oct) are "too strong for level", where an intermediate on a 9 m would ride.
- Caveat: the Meteocat stations near the spots (2–10 m masts) also show gusts 1.6–2.5× the mean, so the model isn't simply wrong. The rule was written for a lower ratio than the forecast actually gives.

**Options**
1. Judge gustiness against what the forecast normally gives: tolerance from about 1.4× to about 1.8× the mean, same shape (recommended). Before / after on 28 Jul Castelldefels: 42 → about 90.
2. Same as 1, and base the "too strong" limit on the mean wind plus a wider gust margin (intermediate: 28 kn mean, 38 kn gusts instead of 34).
3. Leave the rule; ask Forecast accuracy to calibrate gusts against stations first, then retune.

### 3. Offshore-ish winds still score and get listed

- For intermediates, wind 100–125° off the beach normal (side-offshore to offshore) keeps 30–60 % of its direction score. Beginners already drop to 0 at 100°.
- 2 Jul: L'Estartit scores 8–11 in a 16 kn N wind gusting 33, angle 103–108°, blowing towards the Medes. 14 May: Castelldefels 20 in a Ponent, Salou 18, Cambrils 6, all with "offshore" as their label.
- The app lists every spot above 0, so free users can see these in their top results.

**Options**
1. Score 0 from 100° for intermediates too (same as beginners); advanced keeps its curve (recommended).
2. Keep scoring them, but never list a spot whose label is "offshore" among the options.
3. Leave as is.

### 4. Marginal spots show the wrong reason

- A spot with no good window shows the worst problem of the whole slot, not of the hours it was scored on.
- 2 Jul: Riumar is **#1** with "offshore", but its 21 points come from 13–14 h NNW side-onshore; the offshore is at 17 h.
- 19 Oct: Badalona "too light" while its scored hours are 13–14 kn on a 12 m. 4 Sep: Eucaliptus "too light" with 37.
- Display only, no effect on the score.

**Fix**: describe the scored hours (the same 2 h the score comes from), and fall back to the whole slot only when they score 0 (recommended). Small change in the engine and the card text; I can do it as its own card.

### 5. One good hour can top the list

- 8 Oct, Vilanova: 4.5, 4.7, 7.3 kn, then one hour of 12 kn, then 9.5 kn, with the direction swinging SW → SE → W → ESE. That single hour gives it 36 and the #1 spot on a day with 20 kn elsewhere.
- The 2 h average lets one good hour plus one dead hour reach about 37.

**Options**
1. Rank a spot by its 2 h average only if both hours are kiteable; otherwise cap it at 20 (recommended).
2. Leave it: it never reaches the "go" card (needs 40).

### 6. A question for you: Tramontana at Sant Pere and the Bay of Roses

- In Tramontana the Empordà beaches facing east (Sant Pere, Empuriabrava, Estartit) get N/NNW: side-offshore, so they score 0 to 15. Only L'Escala Riells and Pals keep a score.
- If locals do ride Sant Pere in Tramontana (with the schools' rescue boats), that's a spot rule (per-spot sector), not a scoring rule. Tell me and I'll pass it to Spot improvement.

## Forecast side (not scoring)

- 4 Sep: AROME alone gives Castelldefels 14.7 kn SW; the three-model blend gives 10–11 kn, "too light". Same ECMWF drag seen at Pals on 28 Oct (WHE-58, in review). On Garbí days the blend may hide Barcelona's main spot.
- 28 Jul: Sant Pere's station read 9 kn (10 m mast) against a 12–13 kn forecast.
- Both belong to Forecast accuracy: they're the strongest argument for checking the blend on Garbí days before TestFlight.

## What works

- Summer thermal at Sant Pere (21 Jun): 70, top spot, right window.
- Llevant (23 Apr): cross-shore and side-onshore spots on top, Barcelona beaches below.
- Bans: Barcelona beaches 0 in summer and allowed in October and April, as encoded.
- Two-sided spots: Trabucador switches sea side (Garbí) / bay side (Mestral) correctly; Fangar too.
- Flat day: one honest option, everything else 0.
