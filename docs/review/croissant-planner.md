# WhereToKite vs Croissant's trip planner (WHE-217)

16 Nov 2026 · App reviewer · `main` at the WHE-217 merge · free plan · evidence in
[croissant-planner/](croissant-planner/)

Croissant was used as a visitor only, in Chrome, on two searches: no scraping, no API, no spot
lists copied. Their page appeared with a saved rider profile (78 kg, 9 and 12 m, "Confirmé",
14–30 kn, Paris). I used the same profile in our CLI so both apps answered the same rider.

## Verdict

- **Croissant is a richer *planner*; WhereToKite is the more honest *decider*.** On the same two
  days, Croissant headlined "worth the trip" and planned 8 h on the water when its own table marked
  most of those hours as not rideable. We said "no spot" or "Long shot".
- They win on *when*: three days of wind per spot at a glance, plus a safety box per spot written
  for riders. We win on speed (answer on the first screen), the kite size and the model check.
- Take three things: a "leave by" time, a 3-day strip per spot, and per-spot safety notes. Don't
  take the trip plan as it is: it is the part that contradicts their own wind.

## The two test searches

| Question | Croissant | WhereToKite |
|---|---|---|
| **Montpellier, Mon 16 to Wed 18 Nov, car ≤ 3 h** | Headline "Ça vaut le déplacement · Le vent est en Méditerranée" ([05](croissant-planner/05-results-headline.jpg)). #1 Port-Camargue: 14 kn at 9 h, then 3–10 kn ([06](croissant-planner/06-results-list.jpg)). Plan: "Sur l'eau 09:00 → 17:00" Monday ([09](croissant-planner/09-spot-plan.jpg)) | Afternoon: "Aucun spot navigable" ([20](croissant-planner/20-wtk-montpellier-afternoon.png)). Morning (CLI): #1 L'Espiguette **69 Worth a try, 09:00–11:00, 13–15 kn, 12 m, wind uncertain (41 %)**; Port-Camargue 34 "Long shot, too light" |
| **Paris, weekend 21–22 Nov, car or train** | "Ça vaut le déplacement · Le vent est dans le Nord", #1 Berck, **"Prévision fiable"**, Sunday 15–17 kn W, 12 m ([13](croissant-planner/13-weekend-paris-list.jpg), [14](croissant-planner/14-weekend-berck-detail.jpg)) | Sunday (CLI, ≤ 3 h): 15 northern spots all capped at **39 Long shot, "wind unlikely (1 %)"**: ECMWF sees offshore wind there (see finding 1) |

Both apps found the same spots and the same morning window at Montpellier. They differ on
what they *tell* the rider.

CLI commands used (one run each, through our Worker):
```sh
kite --weight 78 --kites 9,12 --level advanced --from 43.6108,3.8767 --day today --slot morning --drive 75 --all
kite --from 43.6108,3.8767 --day today --slot afternoon --drive 60 --all
kite --from 48.8566,2.3522 --day 2026-11-22 --slot full --drive 180 --all
```

## What Croissant does better

1. **Answers "when" across days in one search.** Each spot card shows 3 days × 5 hours of wind,
   the best hour highlighted ([06](croissant-planner/06-results-list.jpg)). Free, up to 14 days.
   Our free plan searches one day and one slot at a time. When nothing works, it says "try another
   day" without saying which one: the free rider has to tap the four days one by one.
2. **A safety box per spot, written for riders**: excluded wind sectors and why, dangers (rock
   groynes downwind), bans, summer kite lane ([11](croissant-planner/11-spot-safety-box.jpg)).
   Our catalogue has bans for 60 of 772 spots and no hazard text at all.
3. **Words for each hour, keyed to the rider's numbers**: "Navigable · dès 16 kt / Limite · ça
   passe tout juste, 12–15 kt / Non navigable / Direction pas bonne / Vigilance +30 kt", with the
   kite from your quiver under each hour ([08](croissant-planner/08-spot-hourly-table.jpg)).
4. **Logistics**: "leave Montpellier 07:57, arrive 08:15", fuel and tolls per person, carpool,
   "train impossible: station 7 km from the beach, too far with the gear"
   ([09](croissant-planner/09-spot-plan.jpg), [14](croissant-planner/14-weekend-berck-detail.jpg)).
5. **Says which forecast it used**: "AROME HD · Météo-France courte échéance", then
   "GFS · au-delà de l'horizon des mailles fines" for the weekend ([12](croissant-planner/12-weekend-paris-map.jpg)).
6. **Retention**: a weekly email of "the same search every week, and when nothing is worth the
   trip we tell you too". Favourite spots watched over two weeks ([07](croissant-planner/07-results-list-end.jpg)).

## What WhereToKite does better

1. **It doesn't oversell.** Croissant's Monday plan puts you on the water 09:00–17:00 at
   Port-Camargue. Its own "NAV." row marks only 9–11 h as "Limite" and 12–17 h as "Non navigable",
   with no kite shown for any hour ([08](croissant-planner/08-spot-hourly-table.jpg)). Wednesday's
   plan says 12:00–14:00 at 8–10 kn. We gave the same morning a 69 "Worth a try" over 2 h and
   called the afternoon a no.
2. **It checks the models before promising.** Croissant labels Berck Sunday "Prévision fiable" on
   GFS alone. Two other models disagree completely (finding 1). We cap the grade at Long shot.
   They are right that it's GFS; they are wrong to call it reliable.
3. **Answer on the first screen.** We search from your position on launch. Croissant needs a form
   (city, format, dates, transport, filters) and about 15 s of loading
   ([02](croissant-planner/02-search-form.jpg), [04](croissant-planner/04-loading-provisional.jpg)).
4. **One kite size for the window**, from weight and quiver, and a 2 h window instead of a full day.
5. **Coverage**: Europe and Morocco, against France only. The phone knows where you are.
6. **Their small slips we don't have**: the start city I picked (Montpellier) reverted to Paris
   twice when the form reopened; "18 min, 28 km" from Montpellier to Port-Camargue (we say 34 min,
   which is more realistic); the budget says "2 nights on site" for a plan that drives home each day.

## Findings for WhereToKite, worst first

### 1. Two models blowing opposite ways are shown as one onshore wind · `safety` · `fragile`
- **What a rider sees**: Paris, Sunday 22 Nov. Berck-sur-Mer: "18 kn (gusts 23) W onshore · 9 m",
  and next to it "wind unlikely (1 %) · models' best 0 kn". Two messages at once.
- **Evidence**: one Open-Meteo call each (16 Nov, 09–17 h local):
  ECMWF 9 km (sea cell) **14–16 kn from 111–115° (ESE: offshore at Berck)**; GFS
  **20–22 kn from 286–291° (WNW: onshore)**. ECMWF 0.25°, ICON and best match: 6–12 kn ESE.
  `Blend.hour` (`Sources/KiteCore/Forecast.swift:526-531`) averages the *speeds* (18 kn) and takes
  the direction from the vector sum, so GFS (the stronger model) wins: 18 kn W. A truly averaged
  vector would be about 3 kn. The scoring and the offshore safety rule then judge that invented wind.
- **Why it matters**: the safety rules (offshore, side-offshore) run on the blended direction. When
  one model sees offshore and another onshore, the offshore case disappears from the hourly chart
  and the grade. Today only the model check (`Recommender.checkChance`) catches it by capping at
  39. That check covers the top spots only (`confidenceTop`), and from +4 days the blend is two
  models, so one of them can flip it alone. I didn't find a live case at a Go grade. How sure:
  the mechanism is confirmed in code and data; a dangerous real-world outcome is not reproduced.
- **Smallest fix**: when blended models differ by more than ~90° in an hour, don't average. Flag
  the hour "models disagree on direction" and score it as the worse case for safety. On the row,
  replace the wind with "Models disagree: onshore or offshore".
- **Effort**: M (engine + one label, plus a backtest by Forecast accuracy). Filed as a high card for
  the Lead (rule: anything that could put a rider in danger).

### 2. A no-wind day is a dead end on the free plan · `confusing`
- **What a rider sees**: "Aucun spot navigable. Essaie un autre jour ou une autre session…"
  ([20](croissant-planner/20-wtk-montpellier-afternoon.png)). Which day? The rider taps Tomorrow,
  Wed, Thu, each a new search. Croissant shows three days on one screen.
- **Evidence**: `App/WhereToKite/Views/ResultsView.swift:105-116`. "Next good window" is Pro
  (`Plan.swift:32`). In `.freeOnly` the Pro row is hidden, so nothing points anywhere.
- **Decided by Ben** (Pro sells "next window", HANDOFF 16 Nov). New argument: in v1, which ships
  free only, this is the one screen where the competitor answers and we don't. The cheapest
  version is to tell the rider which of the 4 free days has wind, without ranking spots.
- **Cost**: every no-wind search fetches 3 more days (Open-Meteo quota, card WHE-12).
- **Effort**: S if Ben opens `nextWindow` to free; M for a lighter "wind on Wed morning" line.

### 3. Morning wind is hidden behind the default afternoon slot · `confusing`
- **What a rider sees**: Montpellier today, afternoon (the default): no spot. The morning has a 69
  "Worth a try" at L'Espiguette (CLI above). Nothing on the no-spot card says "the morning
  works". Croissant shows the 9 h best hour on every card.
- **Fix**: when the searched slot fails, check the other slots of the same day (same forecast:
  no extra calls, the day is already fetched) and say "Morning works: L'Espiguette 13–15 kn".
- **Effort**: S–M. How sure: high (the forecast request covers the whole day).

### 4. "Not navigable" has no reason a rider can scan · `polish`
- Croissant's legend gives one meaning per colour, tied to the rider's thresholds ("dès 16 kt",
  "12–15 kt", "direction pas bonne"). Our list says "Pas navigables (4)" and the reasons sit inside
  each spot. A one-word reason on each row (too light / offshore / storm / banned) would tell the
  rider whether to wait or give up.
- **Effort**: S. The reasons already exist in the engine ("too light" in the CLI).

## Ideas to borrow, ranked

| # | Idea | Why for us | Effort | Risk / cost |
|---|---|---|---|---|
| 1 | **"Leave by 08:20"** on the top spot (window start minus drive time) | Turns "where" into an action; we already have both numbers | S | Apple Maps ETA has no traffic for future times: say "about" |
| 2 | **Same-day other slots** when the searched slot fails (finding 3) | The answer is already in the fetched forecast | S–M | None on quota |
| 3 | **Per-spot safety notes**: excluded sectors, hazards, seasonal lanes, from official sources | Trust and safety, our weakest spot data | L (catalogue work, one region per card) | Wrong notes are worse than none: source each one, as for `banned` |
| 4 | **3-day strip** (3 days × a few hours) on the spot page, not the list | Answers "when" without new screens | M | 3× forecast calls per search. Keep it to the spot page to respect the "focus on wind" brief |
| 5 | **One-word reason** on not-kiteable rows (finding 4) | Scannable, no clutter | S | — |
| 6 | **Name the model used** when the forecast is far ahead ("GFS, 6 days out") | Honest; explains a Long shot | S | Jargon: one discreet line, in the confidence sheet |
| 7 | Weekly "this weekend" notification | Retention; already planned as "It's on" alerts | M | Push needs the server; Pro or free is Ben's call |

**Not worth copying**: the full trip plan (the part that contradicts their own wind), fuel and
toll costs, carpool, the train option, the progressive map of 105 spots while loading. Each
adds a screen and none helps decide where the wind is.

## What to cut or merge (focus on wind)

This comparison argues *against* adding Croissant's extras. The things worth taking (1, 2, 5) are
one line each and are about wind or timing. Nothing on our screens needs cutting because of it.

## What is good and should not be touched

- The honest no-spot card and the Long shot cap: on both test days they gave the safer answer.
- Search on launch from the rider's position, with no form to fill.
- One kite size and one 2 h window per spot.
- The model check (`checkChance`). Finding 1 is about the blend *before* it, not the check.
