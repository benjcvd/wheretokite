# Session handoff

Read this first in a new session, then `docs/TODO.md` (what's pending) and
`tools/spots/TO_CONFIRM.md` (spot questions). Last updated 2026-10-25.

## Working with Ben
- Ben is the kite domain expert (rides around Barcelona). Claude builds the code and explains
  the decisions; Ben decides on spots, rules and product.
- Ben writes in English or French; answer in the language of his message.
- Ben reviews and merges; he wants processes automated, with his review as the only manual step.
- Run at most ~2 subagents at a time (usage limits).

## Hard rules
- Signing: since 2026-10-22, Ben commits `DEVELOPMENT_TEAM = YMM4B4C582` in
  `App/WhereToKite.xcodeproj/project.pbxproj`. It isn't in `App/project.yml`, so `xcodegen`
  drops it: check it's still there after a regeneration.
- `.atlas/` (board, stream notes) is Atlas working state, gitignored. Keep the board up to date
  as described in `CLAUDE.md`.
- Project overview, layout, commands and rules: `CLAUDE.md`.
- Competitor data (Windy, Windguru, Kite Croissant…): look at it like a visitor, as a benchmark
  only. Never scrape, never read their internal APIs or page code, never copy positions or
  lists into the catalogue. Every spot is located from OpenStreetMap through our pipeline.
- Accepting consent banners, publishing anything public (releases, pages) and account actions
  need Ben's explicit OK.
- Test server changes at real size (a 100-spot forecast request), not with 2 spots.
- Don't send Ben's email anywhere.

## What exists
- **App** (`App/`, SwiftUI, XcodeGen): version 1.0, `PaywallMode.freeOnly` (Pro hidden).
  Free plan: 1 own spot, 3 h drive, top 5, 4 days ahead; water sector, second side and tide
  rule are free; "Next good window" and score weights are Pro.
- **Engine** (`Sources/KiteCore`): scoring, safety (thunderstorm, dark, seasonal bans = score 0;
  rain −15% from 2 mm/h, −40% from 5 mm/h), tides, next good window. CLI in `Sources/kite`.
- **Catalogue**: 618 spots (307 free, 311 Pro), 54 with bans, 29 countries.
  Source of truth: `tools/spots/*.csv` → `python3 tools/build_spots.py` → `Data/spots.json`.
  Rules in `tools/spots/README.md` (famous spots only; tiers basic / pro / archived; `banned`
  column; Catalan beaches banned 1 Jun–30 Sep outside authorised zones, applied by default).
- **Server** (`server/`, Cloudflare Worker) — live at
  `https://wheretokite-api.wheretokite-api.workers.dev` and used by the app (`AppConfig.serverURL`).
  Forecast / archive / marine proxy with a per-location cache, `/v1/catalog` (from GitHub
  `main`), `/v1/report` → GitHub issue, `/v1/feedback`, `/v1/diagnostics`, `/privacy`,
  `/support`. Deploy: `cd server && PATH=~/.local/node/bin:$PATH npx wrangler deploy`.
  Secrets set: `GITHUB_TOKEN` (Issues on the repo). Not set yet: `OPEN_METEO_API_KEY`,
  `OPERATOR_NAME` / `CONTACT_EMAIL` vars. Free plan limit: 50 subrequests per request →
  the cache makes at most 40 Cache API calls per request (none on workers.dev).
- **GitHub automation** (`.github/`):
  - `report-triage.yml`: a `report` issue (filed by the server as Ben) → Claude checks the claim
    with sources → PR editing `tools/spots/` only, or a comment (closed / needs-human /
    app diagnosis). Prompt in `.github/triage/prompt.md`. Add the `triage` label to re-run.
    Daily cap 20. Secret `CLAUDE_CODE_OAUTH_TOKEN` (Ben's subscription).
  - `claude-followup.yml`: Ben comments `@claude …` on an issue or PR.
  - `catalog-build.yml`: push to `tools/spots/**` on main → rebuild and commit `Data/spots.json`
    (refuses if the Apple Maps check is unavailable or the spot count drops > 10%).
  - CI starts from the `osm-cache` release (snapshot of `tools/.osm_cache`); refresh it after big
    catalogue changes (command in `server/README.md`, needs Ben's OK: it's public).
  - Verified end to end on 2026-10-21 (issue #1 closed with sources).
- Node is in `~/.local/node/bin`; `gh` is logged in as benjcvd with the `workflow` scope;
  Wrangler is logged in to Ben's Cloudflare account; the Claude Chrome extension is connected.

## Decisions taken
- No user accounts (Apple ID holds purchases, iCloud for own spots, anonymous install id for
  alerts). Sign in with Apple only for community features / Android later.
- Pro sold through the App Store (StoreKit 2), Small Business Program (15%).
- Costs at ~10K free users ≈ €40–45/month (mostly fixed: Open-Meteo plan, Cloudflare) + Apple
  €99/yr + domain; a custom domain is needed for the shared cache before scaling.
- Every launch is its own spot for now; sub-spots / grouping is an open design question
  (proposal in `docs/TODO.md`).

## Where we stopped (2026-10-22)
- Barcelona-area benchmark vs Windy done; 24 spots added (commit 1aed7f2). Open questions
  for those are in `TO_CONFIRM.md`; Ben has no answers yet: keep them flagged as is.
- Next on Claude's side: App Store text and screenshots for TestFlight.
- Next on Ben's side: name + contact email for the privacy policy, Apple Developer account,
  domain.
- Web-verified pass on the wave-2 countries still to do (fresh session = fresh web budget).
- Team (2026-10-24): a Lead (Ben's main session: board, merges, anything public) and three
  workstreams so topics run in parallel without touching the same files: **Spot improvement**
  (catalogue only, Sonnet, one region per card, commit then stop, because long runs hit usage
  limits and lost work twice), **Release** (store page, privacy answers, TestFlight; no
  features) and **App** (app, engine, server; `backend-engineer` as its server helper). Roles
  in `.claude/agents/`, skills in `.claude/skills/` (`merge-workstream`, `deploy-worker`,
  `store-screenshots` added); not committed yet. Release and App still have to be created in Atlas.

## Where we stopped (2026-10-23)
- Spot improvement merged into main (c261e03): Portugal and Morocco web-verified, 4 PT spots
  added, Moroccan spots routed from Moroccan cities (they were all `access: ferry`, so hidden).
- App fix (6994a96): searches keep spots on the origin's continent (`Continent` in
  `DriveTime.swift`), otherwise Tarifa would get Tangier as a 40 min drive.
- Pushed on 2026-10-25; CI rebuilt the catalogue (cadff53, 626 spots, 9 in Morocco) and the server serves it.
- v1 / App Store: the list of what's missing is on the board (`v1-*`, `tf-*` cards): privacy
  contact, App Store Connect app, EU trader status, App Privacy answers, store text and
  screenshots (Claude), archive and upload.
- 2026-10-25: v1 ships in English, Spanish and French (Ben's call), with a Language row in
  the Me tab that opens iOS's per-app language setting (chosen over a flag: flags are
  countries, and iOS's picker also switches dates and the store page). The contact email is
  necessary (GDPR, App Review) but the repo is public, so it's a Wrangler secret and the
  pages write it as HTML character references; the deploy itself is blocked for Claude, so
  Ben runs it.
- 2026-10-25 16:30: from Ben's connection, the Worker's two IPs (188.114.96.5 / .97.5) timed
  out while other Cloudflare sites answered: probably a Spanish ISP block during football
  matches (unconfirmed). The app has no fallback yet, so Spanish riders could lose search on
  weekend afternoons; Product has a card to fall back to Open-Meteo directly.

## Where the Lead stopped (2026-10-25, 23:45)
- Everything is merged and pushed (main d9fd046) and the Worker is deployed with the privacy
  text about the direct Open-Meteo fallback. Team setup (`.claude/`) is committed. Deploys and
  pushes worked for Claude tonight after Ben's OK.
- Server fallback (WHE-50, Product): after 3 s without an answer the phone also asks
  Open-Meteo directly and keeps the first answer, then skips the server for 10 min. Cause:
  Spanish ISPs block shared Cloudflare IPs during LaLiga matches (parked card on a real fix).
  To check the live Worker during a block: `curl --resolve <host>:443:104.21.48.1 …`.
- Free plan is now 4 forecast days (Ben: "2 days is shit"); Pro keeps 7. Store texts in
  EN/ES/FR say "four days ahead".
- Screenshots (WHE-9, review): Ben wants real forecast days, not archived ones. The test
  `StoreScreenshotsTests` uses the live forecast from Barcelona; `TEST_RUNNER_SHOTS_DAY=N`
  picks day N (0–3). Dedicated simulators "Shots 6.9" / "Shots 6.3" (don't share the booted
  ones with workstreams). Current set: Wed 28 Oct, Leucate top, 8 per size in `docs/store/`.
  Ben is uploading them; `07-add-spot-map.png` was rejected as "invalid dimensions" though it
  is 1320×2868 (probably dragged from the 6.3 folder): a JPEG copy sits next to it.
- `xcodegen` drops `DEVELOPMENT_TEAM` (happened again tonight): re-add it after every regen.
- Next for v1: Ben finishes the screenshots, Spanish/French store pages (WHE-49), Windguru
  check (WHE-51), then the first TestFlight build (WHE-10).

## Product stopped (2026-10-26, 20:10)
- Forecast confidence is now per spot (WHE-54, in review): the models are compared at the top
  10 spots in one request, after ranking, instead of at the start point. Why: on 27 Oct the
  check said "High" from a calm Barcelona while the question was Sant Pere, 2 h away. Spots
  where the models disagree lose up to 15 % (`ScoringRules.agreementFactor`), which Ben must OK
  since it touches ranking. Tricky: the start area no longer leaves the phone for this check,
  so the privacy texts over-declare (safe, left as is).
- Model backtest (WHE-58, in review), 27 Oct: [docs/MODEL_BACKTEST.md](MODEL_BACKTEST.md). Against
  official stations, the beach grid cell beats the offshore one for every model, and a mean of
  AROME, ICON and ECMWF beats "best match". Ben decides whether the app switches. Tricky: the
  stations are on land, so the absolute bias is not the water's.

**Forecast accuracy, 27 Oct.** The second look at the 3-model blend (WHE-61) found it reads too
low for riders: ECMWF's "beach" cell sits 11–17 km inland, and the blend's win on error comes
mostly from matching land stations that read low. Recommended to Ben: AROME and ICON on the beach
cell, ECMWF on its sea cell. Waiting for his pick before any app change; WHE-58 stays unmerged.
Torroella de Montgrí has no wind sensor, so Pals has no close station. Wind measured on the water
(buoys) is the missing piece.

**Forecast accuracy, 31 Oct.** The 28 Oct station check (WHE-60) couldn't run: Meteocat's open
feed has a network-wide hole from 26 Oct evening to 30 Oct. Checked 26 and 30 Oct instead from
the day-ahead forecast archive: two light days, a tie between setups; the old offshore cell
called a false go at Sant Pere on 30 Oct, and the WHE-61 pick read a few knots high that day.
Windy-day evidence still has to come from the buoys card (WHE-62).

**Forecast accuracy, 1 Nov.** The Spain/France backtest (WHE-72, in review) scored five setups
against 36 shore masts and 86 weaker stations over 8 Aug–30 Oct (AROME's day-ahead archive
starts 8 Aug). Option 1 (AROME + ICON beach, ECMWF sea) wins on error and false alarms in France
and mainland Spain but reads far too low in the Canaries (no AROME; ICON and ECMWF coarse), so
the recommendation is Option 1 with the Canaries kept on best match; Ben's answer there settles
WHE-61. Tricky: the Météo-France mirror on data.gouv froze in June (use the OVH bucket);
Open-Meteo silently drops out-of-range models from multi-model requests; ECMWF's sea cell is
~13 km out, so any "cap the sea cell" rule sends it back inland. Still no water truth (WHE-62).

**Forecast accuracy, 1 Nov.** Buoys settled the level question (WHE-62, in review). Open
Copernicus buoy data, no account. Offshore (Begur, Tarragona) the models are right; 2.3 km off
Canet every setup reads low, and the 3-model beach mix is the lowest (about 4.5 kn on the best
2 h, half the go days missed). The land stations were reading low because of shelter. That
reverses the WHE-61 pick: the recommendation is now to keep today's best-match sea-cell setup and
test an AROME-first blend on the sea cell next. Weak spot: only one near-shore buoy, in France;
there's no open wind measurement on the water near Barcelona.

**Forecast accuracy, 1 Nov.** WHE-63 replayed 42 afternoons (20 Sep–31 Oct, 150 min from
Barcelona) through the app's real ranking, forecast a day ahead (`kite --replay`, fed by
`tools/backtest/replay.py`). Today's offshore best-match setup says "go" on almost every day and
most of its checked picks had no wind; the beach-cell setups are much better on that, at the cost
of a few missed days. Tricky: the absolute hit rates swing with the land-vs-water gap, which only
buoys (WHE-62) can settle, and half the top picks (Roussillon, L'Estartit, Pals, Fangar) have no
station at all. Open question to Ben on Riumar in mestral; easterlies at Torredembarra are under-read
by AROME and ICON (new card).

**Forecast accuracy, 31 Oct (later).** Option 1 is built (WHE-61, commit 6e9894c on the
forecast branch): AROME and ICON on the beach cell, ECMWF on its sea cell, two Open-Meteo
requests per batch merged before the blend, forecast cache key v4. Verified live at Salou
(app value = hand mean). Not on main until Ben says yes. Tricky: the confidence badge still
reads ECMWF on the beach cell; and a failed request for either cell fails the whole batch on
purpose, so the app never shows a blend missing a member.

**Forecast accuracy, 1 Nov (later).** WHE-78 tested "AROME 1.3 on the sea point for 2 days, then
best match" (in review, recommend not shipping). AROME stops at 2 days, so days 2+ are today's
setup; and on the day-before forecast, best match already *is* AROME 1.3 at Sant Pere, the POEM
spots, Hyères and Brittany, so WHE-62's near-shore buoy win was today's setup all along. At the
other 24 spots it reads 2–3 kn high on masts and ~1 kn high at open-sea buoys: more go days caught,
half of them false, worst in Catalonia. The open choice is still today's setup vs option 1.
Tricky: the previous month's Copernicus buoy file appears late; `buoys.py` falls back to daily files.

**Forecast accuracy, 1 Nov (WHE-84).** The 24 % Spain Go hit rate came from the Catalan Meteocat
masts, which read about half the forecast in every direction while the Begur and Tarragona buoys
agree with the models. Height, time base, averaging and the go/offshore rules were checked and
cleared. With those masts out of the truth, a Go tuned to 85 % per day ahead (one method
everywhere) lands at 82–97 % on unseen weeks in France, southern Spain (days 0–1) and at the buoys;
a separate 70 % "Most likely" band doesn't hold up. Catalonia itself stays unverified (no wind
measured on the water near its beaches). Tricky: Open-Meteo's daily quota is shared across agents.
Run the backtests with `BACKTEST_OFFLINE=1` to use the cache only.

**Forecast accuracy, 2 Nov (WHE-86).** The Catalan ports publish no open wind data (Puertos del
Estado serves sea level only). But Barcelona airport and Meteocat's Port of Barcelona
harbour-mouth mast read the same wind, and that settles WHE-84's question: the other Meteocat
masts are sheltered, not broken. Against those two open masts the forecast is about 2.5 kn too
light. A Go almost always comes true (98 %), but it catches only 13 % of the real go days.
Empordà and the Ebro delta still have no open sensor. Tricky: the Open-Meteo quota resets at
01:00 CET, and `whe86.py` buffers its output until the end.

**Forecast accuracy, 2 Nov (WHE-80).** One correction learned from measurements and applied the
same way at every spot doesn't help riders. On average the forecast is already level at the
trusted stations. Each station is off by its own few knots, and one rule for all spots can't
know which. The textbook version cuts the error a little only by pulling strong winds down
(storms would look milder), so it's ruled out for safety. With a fair Go cut-off, no correction
catches the most real go days. The only real gain is a correction per spot from its own
station's past misses, which exists only where an open, trusted station sits next to the spot.
Tricky: an error gain from a correction tied to the forecast speed is regression to the mean;
always check the 25 kn+ hours.

**Forecast accuracy, 2 Nov (WHE-81).** "Chance you'll kite" checked against Ben's refined bar:
labels Go / Probably / Long shot / No, every day ahead (today to +5), grouped by place, sea and day
type, one method everywhere. The agreement rule (4 models' margin above 12 kn and their spread, one
fit for all) passes on all masts at every lead and fails, reported not tuned, in Catalonia (masts
measure a go on 3 % of days), on +4/+5 in the Mediterranean (too sure), and on sea-breeze days, but
only through Catalonia. The ECMWF ensemble fails everywhere except the Atlantic. Islands, lagoons,
Tarifa/Calais and the buoy have too few days. Tricky: AWS's ECMWF bucket throttled to a crawl, so
`ens_fetch.py` uses the Google Cloud mirror. This study used up Open-Meteo's free daily limit on this
machine once: Previous Runs with 12 variables over 38 sites is heavy.

**Forecast accuracy, 2 Nov (WHE-87).** Which source for each day ahead (0–5): 9 Open-Meteo sources
× beach/sea point + mixes, 32 trusted sites, 84 days (`tools/backtest/whe87.py`, `whe87_checks.py`).
Today's "best match" turns out to be an unnamed, place-dependent model (mostly ICON-EU in Spain in the
archive). One rule wins at every lead: mean of `meteofrance_seamless` (beach point) + `ecmwf_ifs` +
`gfs_seamless` (sea point); Météo-France drops out from day 4. Real gain days 0–1, tie 2–3, slight
gain 4–5, strong days read stronger. Only dissent: the POEM near-shore buoy, where AROME is better.
Report only; waiting for Ben's pick. Open-Meteo's archive answered "no data" while overloaded:
the script never caches refusals.
## Lead, 31 Oct: Spain/France reliability task force
Ben's top priority: forecasts and spots in Spain and France must be reliable before he shares
the app with riders in Barcelona (testers' build = card WHE-70). Ben asked to **finish the work
in progress before starting anything new**; WHE-75 (side-offshore) and the session-length card
wait in the backlog on purpose.
- **Forecast setup.** Lead recommended WHE-61 option 1 (AROME + ICON on the beach cell, ECMWF on
  its sea cell): land stations read ~15 % below open water, so setups that "win" by matching them
  under-read; ECMWF's nearest cell is 11–17 km inland; averaging smooths strong-wind peaks.
  Forecast accuracy built it (unmerged). Ben wants proof first: WHE-72 tests 5 setups on the main
  ES/FR spots against masts at the water's edge (buoys = level check only) and where to read the
  forecast (pin / 500 m / 1 km / sea cell). Its result settles WHE-61. Don't merge before.
- **Scoring (WHE-64, Ben's calls):** gusts soften by rider level *and* session intensity
  (WHE-73); storms: hours with a storm stay 0, add a "Storm from 4 pm" alert instead of a heavy
  penalty (WHE-74); side-offshore for advanced riders only, profile setting, pure offshore always 0
  except lagoon-type spots (WHE-75, backlog); ask the session length instead of a fixed 2 h
  (backlog). Sant Pere Tramontana question (finding 6) still open for Ben.
- Spain 96 spots, France 141. Verified-pass cards per region: WHE-65/66 running, Languedoc,
  south-east Spain, French Atlantic in backlog.
- Gotcha: Meteocat's open feed has a hole 26 Oct 18 UTC → 30 Oct (no 28 Oct check possible).

## Lead, 1 Nov: freeze on new work
Ben: no new ticket is started until the five in progress are finished: WHE-72 → WHE-62 → WHE-63
(Forecast accuracy) and WHE-65 → WHE-66 (Spot improvement). Nothing else goes to `ready`. The
Lead hands over the next card in each chain when the one before it ends. WHE-74: Ben keeps 80 %
on the hour before a storm.

## Lead, 1 Nov evening: forecast accuracy, where it stands
- Five setups tested on 36 ES/FR shore masts (WHE-72): Option 1 (AROME+ICON beach cell, ECMWF sea
  cell) best, 2.6 kn error vs 3.0 today, false "go" 25 % vs 35 %; better at 26 of 36 spots; much
  worse in the Canaries and at Tarifa. Buoys (WHE-62) say the water is windier than land masts, so
  every beach setup may read low. The three-model beach mix (WHE-58, b5aa464 on atlas/product, on
  Ben's phone) reads too low: drop it; strip it before merging WHE-54.
- Ben: **no per-spot or per-region methods**, one method everywhere. He finds the numbers bad.
  Lead's literature check: our error matches published day-ahead station scores (~2 m/s RMSE);
  the next lever is one statistical correction learned from all masts + buoys (MOS, ~10–20 %),
  card WHE-79 (todo, waits for WHE-78 and Ben's go). Ben put WHE-78 (AROME-first, sea point) in
  progress himself; its result + WHE-79 decide the setup. Nothing ships before Ben picks.
- Freeze still on: start nothing else without Ben. 14 cards in review; Lead's grouping for him:
  forecast (58/60/61/62/63/72), scoring OKs (73 numbers, 74 wording; 80 % pre-storm hour decided),
  Catalan spots in one map session (59/65/66 + WHE-2; Riumar in 63 and 66; Castelldefels in 66
  and WHE-77), then WHE-54, Greece last. Branches with reports to merge (docs/tools only):
  atlas/t/whe-62, whe-63, whe-72, atlas/forecast-accuracy.
- Gotcha: Atlas reverted the Lead's `ready` edits on `doing` cards; the per-spot numbers came
  from `/tmp/whe72spot/perspot.py` run on the whe-72 worktree's `.cache` (temporary).

## Lead, 1 Nov late: the likelihood label
- Ben's goal: avoid wrong gos and missed gos; the grade stays, a plain label goes next to it.
- WHE-81: a simple agreement rule (how far 4 models sit above the rider's minimum, and how much
  they disagree) beat running the scoring on 50 ensemble members (the ensemble was overconfident).
- WHE-84: Spain's terrible score came from the Catalan weather-service masts (farm, school,
  wetland sites) reading ~half the wind; the buoys off Begur and Tarragona agree with the models.
  Ben picked: Go only at the 85 % cut-off per day ahead, one method everywhere, those masts out of
  the truth. "Most likely" (70 %) didn't hold, so the labels are Go / Not sure / No.
- Open: no trustworthy beach-level measurement in Catalonia yet (harbour sensors card queued).
- Where the Lead stopped (1 Nov, 23:58): WHE-82 (label in the app, Product) and WHE-86 (Catalan
  harbour sensors, Forecast accuracy) queued as ready. Then WHE-70 TestFlight. Still to merge to
  main: study branches atlas/t/whe-62/63/72/78/81/84 (tools + reports only), atlas/product (drop
  b5aa464 first), spot branches atlas/t/whe-65/66 + atlas/spot-improvement (ES.csv notes conflict
  on the 5 Catalan zone rows: take whe-66's text, keep whe-65's Sant Pere note).
- Ben on Windy: looking at their site to stay close is fine; we still never copy their pins.
  WHE-83 found Windy's 33 Catalan markers all covered or unconfirmed; 2 questions for Ben.
- docs/catalan_spots_map.html (uncommitted) is a one-off map Ben used to review Catalan pins.

## Lead, 2 Nov afternoon: decision label and forecast per day
- Ben built an old copy (`/Users/ben/Documents/claude_projects/wheretokite`, main of 27 Oct) by mistake. Ticket
  builds live under `atlas-dev/data/worktrees/wheretokite-849ae358c260/tickets/<ticket>/App/`; open them for him
  with `open …/WhereToKite.xcodeproj` and check DerivedData `WorkspacePath` when "the change isn't there".
- WHE-82, Ben's call: the label is the **overall decision read off the final grade**, not the wind chance alone.
  Four levels: Go 70–100, Worth a try 50–69, Long shot 20–49, No go 0–19 (ES Go / Merece la pena / Poco probable /
  No go; FR Go / Ça vaut le coup / Peu probable / No go). Chance caps stay (uncertain ≤ 69, unlikely ≤ 39); ranking on
  the grade, so Go always comes first. The spot page shows one plain sentence per level. Product is building; Ben
  checks on his phone.
- Models per day ahead (Le Goulet, 2 Nov run): best match = AROME to ~+2 (Wed 10:00), ARPEGE (Météo-France
  seamless) to ~+4 (Fri 13:00), then an unnamed global model (neither ICON nor ECMWF). ICON-EU to ~+5, ECMWF all
  week. Ben wants the exact, best source for each day ahead: WHE-87 (Forecast accuracy) tests all candidates per
  lead 0→+5; nothing ships before he picks.
- WHE-80 (one MOS correction): failed, recommend shipping nothing (Ben to confirm). WHE-81/86 picks still open
  (option 1 recommended on both). WHE-65 finished, waits on Ben's Palamós answer.
- Freeze still on for anything else. Next for the Lead: once WHE-82 and WHE-87 are approved and the Catalan answers
  are in, merge and prepare WHE-70.
## Product: Barcelona scoring check (2026-10-31)

WHE-64 is in review with [the report](docs/SCORING_CHECK_BCN.md#findings-worst-first). No rule changed. The ranking is sensible on Llevant, Mestral and the Empordà thermal, but four things would embarrass us with Barcelona testers: a top pick ending an hour before a thunderstorm, a "gusty" flag that fires on almost every hour (the forecast's gusts average 1.77× the mean, the rule expects 1.4×) and halves every score, side-offshore spots still listed, and marginal spots showing the wrong reason. Each fix waits on Ben's pick and becomes its own card with a before/after.

## Product: storm alert (2026-10-31, WHE-74)

Ben chose not to penalise storms ahead much: the spot now says "Storm from 4:00 PM" (card, top card, spot page) when a storm starts during the session, the rest of the slot or within 2 h after the window, and only the hour just before a storm is docked (×0.8). Storm hours still score 0. Rules in `ScoringRules.stormAlertHoursAfter` / `preStormFactor`. In review: Ben to OK the 80 % and the wording. Not handled: a storm just *before* the window.

## Product: gusts by level and intensity (2026-10-31)

WHE-73 is in review with [the before/after](docs/GUSTS_BY_LEVEL.md#before--after-on-the-whe-64-days). Gust tolerance is now judged against the forecast's normal gust ratio (~1.75× the mean) and graded by level and intensity; the gust limit and the "overpowered" margin rise with intensity for intermediate and advanced riders, never for beginners; mean-wind limits are untouched. "Gusty" shows only when it costs ≥10 %. Side effect to keep in mind: good days now bunch near 100 for intermediates, so the score separates spots less. If Forecast accuracy changes the blend or calibrates gusts, revisit the tolerances in `ScoringRules`.

## Product: chance to kite (2026-11-02, WHE-82)

Each top spot now carries Go / Not sure / No from the four weather models (WHE-81 method, WHE-84 cut-offs tuned so a Go came true ~85 %). It replaces the models-disagree penalty and the confidence badge. Not sure caps the grade at 69 and No at 39 so a high grade never says No; this re-ranks marginal days (24 Oct: La Palme 97 → 69). In review: Ben tests on his phone and settles the wording. Unproven in Catalonia (no trustworthy ground truth there). The CLI's `--server` flag goes through the Worker when Open-Meteo's per-IP quota is spent.
Ben's first test (2 Nov): a "Not sure" ranked above a "Go" confused him. The ranking is now verdict first (Go, Not sure, No, unchecked), then grade; the top card follows the same order.
Then Ben's final rule (same day): the label reads off the final grade (Go 70+, Maybe 40–69, No under 40); the wind chance only caps the grade (uncertain ≤ 69, unlikely ≤ 39); ranking is on the grade again. Colours and headings use the same bands so the app never says two things.
Final shape (Ben, 2 Nov): five levels off the grade (Go 70+, Worth a try 55, Coin flip 40, Long shot 20, No go), each with its own colour; the big card's heading is gone because it repeated the label.
Then four levels (Ben dropped Coin flip): Go 70+, Worth a try 50–69, Long shot 20–49, No go; the spot page shows Ben's sentence per level, or the safety reason for a No go. The big card shows from 50.

**Forecast accuracy, 2 Nov (WHE-88).** Built Ben's WHE-81 pick on top of Product's WHE-82 grade
levels (this branch merges atlas/product). `GoPolicy` in `Sources/KiteCore/Chance.swift` holds a
models-agree Go back to "Worth a try" beyond +3 days, with a reason in `KiteChance.goHeldBack` that
the app doesn't show yet (needs a small Product card). Ben: all app logic must be global, no
regional rules, so the Catalonia hold was removed.

## Lead, 2 Nov evening: everything merged locally, TestFlight next

All three workstreams are merged into local `main` (a2ba377). Ben's decisions today: WHE-80 ship nothing, WHE-86 dropped, WHE-81/88 models-agree with no Go beyond +3 days (global, no Catalonia rule), WHE-87 three-model mix, Palamós to Pro, WHE-59 approved. For spot facts Ben doesn't know: research online (Windy only as a visitor, to see which beach riders use; pins always from OSM, never copied from Windy, which Ben accepted), otherwise assume the worst. This is now in the Spot improvement role. Ben tested main on his iPhone ("looks clean"). Gotcha: Xcode kept building old copies of the project; they are renamed `*-OLD` and the only project is `atlas-dev/projects/wheretokite`. Install to the phone with `xcodebuild … -destination 'platform=iOS,name=Ben Iphone' -allowProvisioningUpdates` + `xcrun devicectl device install app`. Main has **not been pushed since 27 Oct**, so the bundled catalogue stays stale until the push and the CI rebuild. Next: WHE-75 (side-offshore, a safety rule, Product building it, Ben approves the angles), then push on Ben's word, then the TestFlight upload (WHE-70).

**Lead, 2 Nov late.** Main pushed on Ben's word (128 commits); the catalogue CI rebuilt `Data/spots.json` (630 spots) and was pulled back. Ben approved the WHE-75 limits (0 from 100° unless the rider accepts side-offshore, advanced-only warning to 130°, 0 for all beyond); merged, 105/105 tests. The project now lives in `claude_projects/wheretokite`: if `swift test` complains about a module cache path from `atlas-dev`, delete `.build/arm64-apple-macosx/debug/ModuleCache`. The TestFlight archive is at `/tmp/wtk-whe70/WhereToKite.xcarchive`; the upload waits for Ben's OK (WHE-70). The WHE-75 merge is not pushed yet.

**Lead, 3 Nov: France and Spain validation before launch.** Ben wants every French and Spanish spot checked by hand and compared with Windy before launch, slowly. Split into 30 zones of at most about 9 spots (`tools/spots/validation/zones.json`), one card each for Spot improvement. Method in `tools/spots/validation/README.md`; status per zone in `status.csv`; map from `python3 tools/validation_map.py` → `docs/validation_map.html`. Only Catalonia counted as validated (WHE-65/66/83/59/2). The old France audit of 8 Oct predates the sourced method, so it doesn't count. A zone becomes `validated` only when the Lead merges it; regenerate the map after each merge. WHE-68/69/92 were replaced; WHE-91 (Italy, Greece, Germany) is on hold.

**Lead, where I stopped (3 Nov 17:30).** Main is ahead of GitHub by the WHE-75 merge and the docs/validation commits; push only on Ben's word. WHE-70: Ben uploads the TestFlight build himself from the Organizer archive "WhereToKite 03-11-2026 WHE-70" with `docs/TESTFLIGHT_UPLOAD.md`; close the card when he says it's live. Validation queue: WHE-67 (Roussillon) and Valencia and the Balearics zone cards are `ready` for Spot improvement; after merging each zone, set its `status.csv` line to `validated`, run `python3 tools/validation_map.py`, commit, and move the next 1–2 zone cards to `ready` (order: the rest of Spain and the Mediterranean, then the Atlantic going north, lakes last). Each ticket worktree starts from main at creation, so older ones need `git merge main` first.

## France and Spain validation merged (5 Nov, Lead)
- 22 zone cards merged into main locally (not pushed): Spain 164 spots, France 191 (Atlantic 133,
  Med 58). Combined spot check clean. Held for Ben: WHE-79, WHE-92, WHE-108; still running:
  WHE-101, WHE-117, WHE-124.
- Rules settled this week: Windy-only markers go in as Pro unless a listed reason applies
  (unrated ones need a local source, else archived); duplicates only under 1 km on the same
  water and facing; the build falls back to curl when the system Python can't reach Overpass.
- Merge gotcha: ticket branches overlap heavily (each starts from atlas/spot-improvement). On a
  row conflict, keep the version from the zone that owns the row; union TO_CONFIRM sections.

## Where the Lead stopped (6 Nov, 00:25)
- Main has 137 commits not on GitHub (validation merge). My `git push` is blocked by the
  permission guard: Ben runs it in Terminal (WHE-134). After the push, watch
  `catalog-build.yml`, `git pull` its `Data/spots.json` commit, then propose the osm-cache refresh.
- Ben's call (6 Nov): no TestFlight round. Ship v1.0 straight to the App Store; the Barcelona
  riders test it informally. Order: WHE-77 (weekday bans, safety rule, Ben reviews) → fresh
  archive → WHE-70 submit steps.
- Still to merge: WHE-79 ticket branch (docs only, decision "ship nothing"), WHE-101 Huelva
  (now on atlas/spot-improvement), WHE-117 Normandy east (review), WHE-124 when done.
  Spot improvement was told to merge main into its branch first.
- France Med spots is fully merged with no cards: Ben can archive it. France Atlantic spots
  only holds WHE-108 (Tarnos question). Ben wants role classes instanced per ticket, not more
  workstreams: new zone cards go to `spot-improvement`.
- Check before marking a ticket merged: a ticket's commit can miss its CSV edits (WHE-115's
  only had a stray file; Atlas later committed "remaining changes"). Compare the report and
  the CSV, not just the branch.

## Lead, 6 Nov: v1.0 archive ready, backlog tidied

The validated France and Spain catalogue is on GitHub and live (751 spots). On 6 Nov, GitHub refused every git push for about half an hour ("fatal error in commit_refs", even for an empty branch) while its API worked. It cleared by itself, so if it happens again, just wait and retry. Bans can now name days of the week (WHE-77, `06-01..09-30 sat,sun`, the field must be quoted in the CSV): Castelldefels is closed on summer weekends and on 24 Jun, 15 Aug and 11 Sep. Its local holidays aren't known yet. Letty was fixed with an OSM pin on the UCPA (north shore) rather than a manual facing, which keeps the "positions from OSM only" rule intact. The catalogue build now cancels an older run when a newer push arrives, and it rebases before pushing. The osm-cache snapshot was refreshed the same day. The 1.0 archive (main 30498ab) is in Xcode's Organizer; Ben uploads and submits it (WHE-70), since Xcode can't use his Apple account from an agent session. The old docs/TODO.md is retired: its ideas are parked cards.
