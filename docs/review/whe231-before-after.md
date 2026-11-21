# WHE-231: score the worse direction when the models disagree

Rule (Ben's option 1 on WHE-218): when the forecast models blow more than 90° apart, each hour
is scored with every model's direction and the blend, and the worst score is kept. The hour is
flagged "models disagree on direction". When every offshore hour of a no-go spot is offshore
only because of this, the row says **Unsure direction** instead of **Offshore**, and the spot
page's sentence says "The weather models disagree on the wind direction, and one says offshore."

Evidence: [backtest](../MODEL_BACKTEST.md#when-the-models-blow-opposite-ways-whe-218-17-nov-score-the-worse-direction).

## Before / after (live forecast run 19 Nov, `swift run kite --drive 240 --all --straight-line`)

Only spots whose grade changed. No spot went up, no Go changed.

```
== Barcelona +3: 50 spots, 1 changed (0 up)
  Empuriabrava – La Rubina            34 Long shot    ->   0 No go        | offshore · 11–14 kn (gusts 23) NNW · ~1h51
== Barcelona +6: 50 spots, 7 changed (0 up)
  La Grande-Motte – Le Grand Trav…    39 Long shot    ->   0 No go        | offshore · 12–13 kn (gusts 26) SSE · ~3h44
  La Grande-Motte                     39 Long shot    ->   4 No go        | offshore · 12–13 kn (gusts 26) SSE · ~3h44
  Saintes-Maries-de-la-Mer – Plag…    37 Long shot    ->  13 No go        | models disagree on direction · 11–12 kn (gusts 33) SSE · ~3h
  Le Barcarès – Les 3 Colonnes        20 Long shot    ->   0 No go        | offshore · 6 kn (gusts 15) WSW · ~2h26
  Le Grau-du-Roi – Le Boucanet        62 Worth a try  ->  54 Worth a try  | 09:00–11:00 · 12–13 kn (gusts 26) SSE cross-shore · 12 m · ~
  Le Grau-du-Roi – L'Espiguette       36 Long shot    ->  31 Long shot    | offshore · 13–14 kn (gusts 30) SSE · ~3h42
  Salin-de-Giraud – Piémanson         34 Long shot    ->  31 Long shot    | models disagree on direction · 16–17 kn (gusts 37) SE · ~3h5
== Berck +3: 83 spots, 7 changed (0 up)
  Anneville-sur-Mer                   69 Worth a try  ->   0 No go        | offshore · 11–12 kn (gusts 18) E · ~3h28
  Courseulles-sur-Mer                 69 Worth a try  ->  10 No go        | offshore · 13 kn (gusts 18) ESE · ~2h34
  Ver-sur-Mer                         69 Worth a try  ->  12 No go        | offshore · 13 kn (gusts 18) ESE · ~2h37
  Vauville                            49 Long shot    ->   0 No go        | offshore · 14 kn (gusts 21) ESE · ~3h23
  Siouville-Hague                     46 Long shot    ->   0 No go        | offshore · 13–14 kn (gusts 20) E · ~3h25
  Sciotot                             46 Long shot    ->   0 No go        | offshore · 14–15 kn (gusts 21) E · ~3h27
  Cherbourg – Collignon               46 Long shot    ->  40 Long shot    | 09:00–10:00 · 15 kn (gusts 23) ESE cross-shore · 12 m · ~3h0
== Berck +6: 83 spots, 6 changed (0 up)
  Vauville                            39 Long shot    ->   0 No go        | models disagree on direction · 9–10 kn (gusts 14) W · ~3h23
  Siouville-Hague                     39 Long shot    ->   0 No go        | models disagree on direction · 9–10 kn (gusts 14) W · ~3h25
  Sciotot                             39 Long shot    ->   0 No go        | models disagree on direction · 10–11 kn (gusts 15) NW · ~3h2
  Anneville-sur-Mer                   39 Long shot    ->   0 No go        | models disagree on direction · 7–10 kn (gusts 13) E · ~3h28
  Agon-Coutainville                   39 Long shot    ->   0 No go        | models disagree on direction · 7–9 kn (gusts 14) ESE · ~3h34
  Barneville-Carteret                 19 No go        ->   4 No go        | offshore · 11–12 kn (gusts 15) NW · ~3h28 · wind uncertain (
```
