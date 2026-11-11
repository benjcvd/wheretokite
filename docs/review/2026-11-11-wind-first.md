# Outside review: what to cut so the wind comes first (WHE-158)

Reviewed: `main` at `1f59678` (app code identical to `becdded`), 11 Nov 2026, free plan (no
`-unlockPro`), start Barcelona. Days: today 11 Nov (no wind), tomorrow 12 Nov (real westerly), and
the test day 3 Oct. iPhone 17 (light, English), iPhone 17e (dark, Spanish), iPhone 17 with
accessibility text size L (French). Screenshots in [2026-11-11-wind-first/](2026-11-11-wind-first/).
Already queued with Product and **not repeated here**: WHE-152 (hour by hour without grades, no
catalogue note), WHE-153 (My hours on the home screen), WHE-154 (every kite + kite switch), WHE-155
(Google Maps), WHE-156 (full-screen map with wind arrow).

## Verdict

- **The answer is there, and fast**: the green top card says where, when, how much wind, which kite
  and how far in one look. That card is the app; protect it.
- **What crowds it is repetition, not missing wind**: the grade is said four times on the spot page,
  the search settings twice on the home screen, and two explainers cover the same ground.
- **Three things undermine trust in the wind itself**: a failed search can leave the old answer on
  screen, the gusts shown contradict "Go, everything lines up", and the big number moves when you
  change the drive slider, not the wind.

## Findings, worst first

### 1. A failed search leaves the previous answer on screen · `safety` `bug`

**What a rider sees.** On 3 Oct I widened the drive from 1 h to 3 h. The search failed ("The
forecast service didn't answer properly"), but the screen kept the 1 h result under the new
settings: the chip says **≤ 3 h**, the line below still says **"within 1 h of you"**, and the big
card says **"No kiteable spot · Not enough good wind"**. That's a fetch failure presented as a
weather verdict.

**Evidence.** [09-failed-search-stale-result.png](2026-11-11-wind-first/09-failed-search-stale-result.png).
In code, the error branch sets the message but never clears or marks the old result
(`App/WhereToKite/Models/SearchModel.swift:241-247`); `self.result` is only replaced on success
(`:233`).

**Why it matters.** The same path works the other way: Saturday is a **Go**, you tap Sunday, the
fetch fails, and Saturday's Go card stays under Sunday's chip with only a small orange line above
it. Someone in a hurry drives off on the wrong day's forecast. Confidence: high for what I saw;
the wrong-day Go is from the code, not reproduced (I can't make the server fail on demand).

**Smallest fix.** On error, clear the result (show the error card alone), or keep it greyed with
"Last result: Sat 3 Oct, within 1 h" so it can't be read as current. **Effort S.** Risk: none
beyond losing the old list on a flaky connection. I filed a `todo` card for the Lead.

### 2. The gusts shown contradict the verdict · `confusing`

**What a rider sees.** Castelldefels, 12 Nov: **Go 86 · "Everything lines up"**, kite **9 m**,
wind **14–18 kn, gusts 29**. The profile says the 9 m covers **15–27 kn**. The score sheet says
**Steady wind 100 %** right above "gusts up to 29 kn". At 16:00 the hour by hour switches to the
**12 m** (11–20 kn) with **gusts 25**. Any kiter reads that as "overpowered and gusty", while the
app says perfect.

**Evidence.** [04-spot-top.png](2026-11-11-wind-first/04-spot-top.png),
[05-spot-hourly-bans.png](2026-11-11-wind-first/05-spot-hourly-bans.png),
[06-score-explainer.png](2026-11-11-wind-first/06-score-explainer.png),
[17-es-rider-profile.png](2026-11-11-wind-first/17-es-rider-profile.png).
`Sources/KiteCore/Scoring.swift:85-118`: gusts are judged against the forecast's normal ratio
(~1.75× the mean), so 29 on 17 kn counts as normal.

**Decided by Ben on 31 Oct 2026** (WHE-73: forecast gusts run high, tolerance calibrated to them).
I'm not questioning the rule. The new argument is about **display**: the app scores with
"forecast gusts are inflated" but shows the raw number next to a kite range it exceeds. The rider
gets two answers.

**Smallest fix (display only).** Show gusts as a word the score agrees with ("normal gusts" /
"gusty"), or keep the number but drop it from the top card and the explainer's "100 %" line.
Longer term, Forecast accuracy could calibrate gusts against stations so the number shown is the
number felt. **Effort S** (wording) / **L** (calibration). Risk: hiding the number removes
information experienced riders like; the word must come from the same rule as the score.

### 3. The big number changes with the drive slider, not the wind · `confusing`

**What a rider sees.** Same spot, same wind, same 28 min drive: Castelldefels scores **77** with
max drive 1 h and **86** with 3 h.

**Evidence.** [01-home-1h-score77.png](2026-11-11-wind-first/01-home-1h-score77.png) vs
[02-home-3h-score86.png](2026-11-11-wind-first/02-home-3h-score86.png).
`Sources/KiteCore/Recommender.swift:424-427`: the drive penalty is `drive / maxDriveMinutes`, and
"Closer is better" is on by default. The explainer shows it as a fourth bar, "Drive 86 %"
([06](2026-11-11-wind-first/06-score-explainer.png)).

**Why it matters.** The ring reads as "how good is the wind there". Moving an unrelated slider and
watching it jump makes the number look arbitrary, which is the opposite of "focus on the wind".

**Smallest fix.** Show the wind grade in the ring and on the card; use the drive only to order
the list. Before/after on this day: Castelldefels shows 86 whatever the slider (today 77 or 86);
ranking unchanged. **Effort M.** Risk: two spots with the same ring can appear in a non-obvious
order; a small "closer" hint on the list solves it. Ranking rules are yours.

### 4. The ban line dumps the raw rule, in orange, on days it doesn't apply · `clutter` `confusing`

**What a rider sees.** On 12 Nov (and 3 Oct), Castelldefels shows in orange: *"Kiting banned
1 Jun – 30 Sep, 0–15 h; 1 Jun – 30 Sep, 19–24 h; 1 Jun – 30 Sep, Sat, Sun; 24 Jun – 24 Jun;
15 Aug – 15 Aug; 11 Sep – 11 Sep"*. In November none of it applies; "24 Jun – 24 Jun" is a
database row, not a sentence.

**Evidence.** [05-spot-hourly-bans.png](2026-11-11-wind-first/05-spot-hourly-bans.png);
`App/WhereToKite/Views/SpotDetailView.swift:61-66` (shown whenever the spot has bans) and
`:167-181` (formatting).

**Smallest fix.** Show the line only when the searched day falls inside a ban period, and merge it
into one sentence ("Summer: weekdays 15–19 h only, closed weekends and 24 Jun, 15 Aug, 11 Sep").
Out of season, nothing. **Effort S.** Risk: none; the score already applies bans per hour.

### 5. The spot page says the grade four times · `clutter`

**What a rider sees.** Ring **86**, then "**Go** · Tomorrow", then a whole row "● **Go** —
Everything lines up", then the explainer. On a no-go day: ring **0**, "**No go**", a row "**No
go** — Not worth the trip today", plus empty tiles "Best window –" and "Kite –".

**Evidence.** [04-spot-top.png](2026-11-11-wind-first/04-spot-top.png),
[11-nogo-spot-top.png](2026-11-11-wind-first/11-nogo-spot-top.png).
`SpotDetailView.swift:57` (`VerdictBanner`).

**Smallest fix.** Remove the verdict row; the ring's (i) already opens the explanation. On a no
go, hide the empty tiles and show the reason (too light, offshore, storm) in their place.
**Effort S.**

### 6. "No kiteable spot" hides the wind it found · `confusing`

**What a rider sees.** A big grey card "Not enough good wind", with the actual numbers folded away
behind "Not kiteable (2)". Tapping it shows "Castelldefels · too light · 7–8 kn (gusts 12) NNE",
exactly what a rider wants to know ("is it close?").

**Evidence.** [10-no-spot-card.png](2026-11-11-wind-first/10-no-spot-card.png) →
[09](2026-11-11-wind-first/09-failed-search-stale-result.png) (expanded).

**Smallest fix.** When there's no verdict, open the list by default, or put the best wind found in
the card ("Best nearby: 8 kn at Castelldefels"). **Effort S.**

### 7. The home screen says the search settings twice, and the chips overflow · `clutter`

**What a rider sees.** Chips (profile, Near me, ≤ 1 h, a fourth chip cut off), day buttons, session
buttons, then a grey line repeating all of it: "Tomorrow, 12 Nov · Afternoon 13:00–18:00 · within
1 h of you". The fourth chip ("Any style") is off-screen at default; in French with large text the
drive chip is off-screen too, and the sessions truncate ("Après-…", "Mes h…").

**Evidence.** [01](2026-11-11-wind-first/01-home-1h-score77.png),
[15-fr-large-text-home.png](2026-11-11-wind-first/15-fr-large-text-home.png).

**Smallest fix.** Drop the grey summary line (the selected buttons already say it). Move "Any
style" into Search options only: "session style" is jargon on the home screen. **Effort S.**

### 8. The results map steals the scroll and shows little · `clutter`

**What a rider sees.** With one good spot, "On the map" is a full-width map under the card.
Scrolling with a thumb on it pans the map instead of the page; after a few swipes it showed Moià,
40 km inland, with no spot in view.

**Evidence.** [12-home-map-panned-inland.png](2026-11-11-wind-first/12-home-map-panned-inland.png);
`ResultsView.swift:121` and `:146-148` (map shown alone when there's one spot).

**Smallest fix.** With one spot, show no map (the spot page has one, and WHE-156 makes it
full-screen); otherwise make the list map a non-scrollable thumbnail that opens full screen.
**Effort S.**

### 9. Two long explainers for one number · `clutter`

**What a rider sees.** The ring's (i) opens "How is this scored?" (four bars, "raised to your
weights", tides, distance, four models); the verdict row's (i) opens "What the labels mean"
(four labels, "Looks promising", models again, an 85 % accuracy claim). Both repeat the model
caveat; neither fits a glance.

**Evidence.** [06](2026-11-11-wind-first/06-score-explainer.png),
[07](2026-11-11-wind-first/07-score-explainer-2.png),
[08-labels-popover.png](2026-11-11-wind-first/08-labels-popover.png).

**Smallest fix.** One sheet: this spot's three bars (wind, gusts, direction) and the label scale;
the "how the score works" text behind a "More" link. Goes with finding 5. **Effort S.**

### 10. The same wind has three names; Spanish reads "NO" · `polish`

- English results say **"W cross-shore"**; the English level text says **"side-shore at most"**;
  the explainer says "cross-shore is harder". French says **"O side-shore"** for the same wind.
  ([02](2026-11-11-wind-first/02-home-3h-score86.png),
  [00-onboarding.png](2026-11-11-wind-first/00-onboarding.png),
  [16](2026-11-11-wind-first/16-fr-large-text-spot.png)). Pick one term per language.
- Spanish: northwest is **"NO"** ("rachas 27 · NO") which reads as "no"; "Go / No go" stay English;
  the tile says "Kite" while the card says "Cometa de 9 m"; labels truncate on the iPhone 17e
  ("Merece la p…", "Poco proba…").
  ([13-es-small-dark-list.png](2026-11-11-wind-first/13-es-small-dark-list.png),
  [14-es-spot.png](2026-11-11-wind-first/14-es-spot.png)).
- "Not worth the trip **today**" shows for any day (`App/WhereToKite/Models/Vocabulary.swift:114`).

**Effort S** (strings only).

### 11. The disclaimer sits on every top card · `clutter`

"Forecast-based estimate. Check conditions on site; you ride at your own risk." is inside the
answer card on every search (`ResultsView.swift:285`), after the rider already ticked the same
terms at onboarding. In French with large text it takes a third of the card
([15](2026-11-11-wind-first/15-fr-large-text-home.png)). **Smallest fix:** move it to the footer
next to the Open-Meteo credit. **Effort S.** Risk: it may be there on purpose for App Review or
liability; if so, keep it but shorten it ("Forecast, not a guarantee").

## What to cut or merge, per screen

**Home / results**
- Cut the grey summary line under the session buttons (finding 7).
- Move "Any style" off the chip row into Search options.
- Cut the single-spot map; make the list map a thumbnail (finding 8).
- Move the disclaimer out of the top card (finding 11).
- Add gusts to the top card only if they're shown as a word the score agrees with (finding 2).
- Merge "Other spots" rows that are "No go" into "Not kiteable": today the list shows Riumar
  "No go 4 · offshore" above a separate "Not kiteable (11)" ([03](2026-11-11-wind-first/03-other-spots.png)).
- On a no-spot day, open the wind found instead of hiding it (finding 6).
- The list rows say the grade three ways (number, colour, label): keep number + colour, drop the
  label pill, which truncates in Spanish.

**Spot page**
- Cut the verdict row (finding 5); hide empty tiles on a no go.
- Cut "Beach faces S" as a tile: the direction label ("W cross-shore") already says what matters;
  keep the facing on the map (WHE-156's arrow does it better).
- Keep the "Best window", "Kite" and "Drive" tiles: they're the facts you act on.
- Ban line only when in force, one sentence (finding 4).
- Chart: "coloured by score" goes once WHE-152 removes per-hour grades; colour by "fits your kite"
  instead, or one colour.
- One explainer instead of two (finding 9).

**Onboarding**: fine as is. One sheet, sensible defaults, clear terms.

## What is good and should not be touched

- **The top card.** Spot, window, knots, direction, kite, drive in one block, readable in two
  seconds, in all three languages and in dark mode.
- **Safety reasons in plain words** in the list: "too light", "thunderstorm risk", "offshore",
  "unstable air". The offshore hours are flagged in orange on the hour by hour.
- **The day and session buttons**: one tap, no menus, the search reruns on its own.
- **Onboarding**: weight, kites with their wind range drawn, level; the range bars teach the rider
  what the app will do with the kites.
- **Directions as the one big button** on the spot page.
- **Dark mode and the small iPhone** hold up; only Spanish labels truncate.

## How this was done

Throwaway UI test `App/WhereToKiteUITests/ReviewWalkthroughTests.swift` (reviewer branch only) on
my own simulators ("Reviewer", "Reviewer SE"); about eight searches through the Worker, no loops,
nothing posted to `/v1/report`. Note: with `-searchDay` the day buttons still highlight "Today";
that's the test override, not a finding.
