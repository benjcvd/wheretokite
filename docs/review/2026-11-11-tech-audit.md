# Technical audit: where the app could break, mislead or leak (WHE-159)

Reviewed: `main` at `becdded`, 11 Nov 2026. Code read: `Sources/KiteCore`, `App/WhereToKite/Models`,
the report sheet, `server/src`, `server/wrangler.toml`, `.github/workflows/report-triage.yml`,
`PrivacyInfo.xcprivacy`, the live `/privacy` page. Evidence in
[2026-11-11-tech-audit/](2026-11-11-tech-audit/). Nothing was sent to the live Worker except one
read of `/privacy`; the server probe ran locally with a fake Open-Meteo.

## Verdict

- The engine is careful where it matters (bad payloads, storms across models, bans, partial
  failures are all handled), but **for today it ignores the clock**: it recommends windows that are
  already over or that you can only reach after dark.
- The server is **an open Open-Meteo relay**: anyone can spend its quota (or a future paid key)
  with any parameters, and **report spam** costs you Claude runs and blocks real reports for the day.
- Privacy is honest overall; two lines on `/privacy` and the store text are wrong by omission
  (your own spots do leave the phone; Anthropic reads every report).

## Findings, worst first

### 1. Today's results offer windows that are over, or that end before you can get there · `safety` `bug`

**What a rider sees.** At 17:52 on 11 Nov, a search for *today, afternoon, 2 h drive* from
Barcelona returns Malgrat de Mar, **best window 16:00–18:00, 1 h 02 drive**. You'd arrive at about
18:55: after the window, and about an hour and a half after sunset (about 17:30).

**Evidence.** [cli-today-afternoon.txt](2026-11-11-tech-audit/cli-today-afternoon.txt) (same
engine as the app). In code, nothing in the search knows the time of day:
`Recommender.search(_:profile:today:)` gets only the date (`Sources/KiteCore/Recommender.swift:221`);
the slots are fixed hours (`Sources/KiteCore/Models.swift:258-260`); `grep "Date()"` finds no use in
`Recommender.swift` or `Scoring.swift`. The app passes `DayOption.today.id` only
(`App/WhereToKite/Models/SearchModel.swift:220`). The "stale results" banner
(`SearchView.swift:54`) only fires one hour after a search, not when the window passes.

**Why it matters.** The default day is *today* and riders open the app late in the day. The dark
rule exists so the app never says "go" into darkness, but a "go" you can only reach after sunset
gets around it. In summer with the *Evening* slot (17–21 h), a 19–21 h window at 20:00 with a 1 h
drive puts you on the beach at sunset with the app still saying go. It's also the most common
"the app was wrong" moment a rider will remember.

**Smallest fix.** For today only, score just the hours from *now + drive time* (rounded up to the
hour); if no hour is left, say "This session is over for today" and offer tomorrow. Cost: the
engine needs "now" passed in (also the CLI); ranking changes on late-day searches, which is the
point. Risk: drive time is an estimate for most spots (`~`), so arrival time is rough; round in
the rider's favour (later). **Effort M.**

Confidence: high from code and CLI; not screenshotted in the simulator. I filed a `todo` card for
the Lead (see the end).

### 2. The forecast proxy relays anything, for anyone, with no limit · `fragile` (abuse)

**What breaks.** Three anonymous requests to `/v1/forecast` made the server send **1,200 locations**
to Open-Meteo, with parameters the app never uses (`temperature_2m`, `soil_moisture…`,
`forecast_days=16`, another model).

**Evidence.** [proxy-probe.mts](2026-11-11-tech-audit/proxy-probe.mts) and its
[output](2026-11-11-tech-audit/proxy-probe-output.txt) (local run of `handle()` with a fake
upstream). In code: every parameter except `apikey`/coordinates is forwarded
(`server/src/forecast.ts:48`, `:131-134`), up to 400 locations per request (`:40`), and the rate
limiter is only wired for the POST intake routes (`server/src/index.ts:58-63`). On `workers.dev`
the shared cache is in-memory per isolate only (known: `docs/HANDOFF.md:45`, `:65`), so
cache-busting needs nothing more than a 4th-decimal shift in coordinates.

**Why it matters.** Open-Meteo counts each location as a call (10,000 a day on the free tier, and
more for long ranges or many variables). A script can spend the Worker's day in a few dozen
requests. Today riders are partly shielded: the app falls back to Open-Meteo from the phone
(`Forecast.swift:131-160`). Once the paid key is set (`OPEN_METEO_API_KEY`), the same script spends
your money instead, and the fallback doesn't help with that.

**Smallest fix.** Accept only what the app and CLI send (the 6 hourly variables, `daily=sunrise,sunset`,
the known models, `cell_selection`, `wind_speed_unit`, `timezone`, dates within today −1 … +16),
cap locations at about 150, and add a per-IP rate limit on the forecast routes (a second
`[[ratelimits]]` binding, generous, e.g. 60/min). Cost: the server must be deployed before any app
version that asks for a new variable; old app versions keep working. **Effort S–M.**

Confidence: high (reproduced locally). Not tried against the live Worker, on purpose.

### 3. Report spam: issues filed as you, Claude runs on your subscription, real reports blocked · `fragile` (abuse)

**What breaks.** `/v1/report` allows **20 posts a minute per IP** (`server/wrangler.toml`,
`simple = { limit = 20, period = 60 }`), each one a public GitHub issue filed with your token,
each one starting a Claude Opus triage on a macOS runner with your `CLAUDE_CODE_OAUTH_TOKEN`.

**Evidence.** `.github/workflows/report-triage.yml`: the daily cap counts issues already labelled
`triaged` (`gh issue list --label triaged … updated:>24h`), and that label is only added at the
*end* of a run. A burst of 20 reports in one minute starts runs that all pass the cap check before
any finishes (bounded in practice by how many macOS runners GitHub gives you at once). After 20
triages, every real report that day gets "Daily triage limit reached".

**Why it matters.** A bored person with one phone can fill your notifications, burn your Claude
usage for the day and switch off real report triage, at no cost to them. Cloudflare's simple rate
limit is also per data centre, so spreading requests is easy.

**Smallest fix.** Lower the report limit to a few per hour per IP (a rider sends one report, not
twenty); in the workflow, add a `triaging` label at the start and count it in the cap. Optional:
a server-side daily ceiling on issues filed. **Effort S.** The rest of the triage design is good
(see "What's good").

Confidence: high on the mechanism (config and workflow), not exercised.

### 4. `/privacy` and the store text miss two flows · `fragile` (privacy)

**What a reader is told vs what happens.**
- "Your profile, **your own spots** and your location stay on your phone" (live `/privacy`,
  `server/src/pages.ts:62-63`; store listing `docs/APP_STORE_CONNECT.md:90`). In fact each own spot's
  exact position (4 decimals, about 10 m) goes to the server and Open-Meteo for its forecast
  (`Forecast.swift`, `formBody`, `%.4f`). An own spot is often the beach in front of someone's house.
- Every report is read by **Claude (Anthropic)** in the triage workflow, but Anthropic is not in the
  "Service providers" list (`pages.ts:94-102`). The text ends up public anyway, so the harm is small,
  but a GDPR policy must name its processors.

**Smallest fix.** Change "your own spots stay on your phone" to "your own spots' positions are sent
only to get their forecast"; add Anthropic to providers. Check the App Store privacy answers still
match ([App Privacy](../APP_STORE_CONNECT.md#5-app-privacy)). **Effort S.**

Confidence: high.

### 5. Crash reports can be dropped silently · `fragile`

**What breaks.** MetricKit hands the app its crash payloads once; the app posts each once, with no
retry and nothing kept (`App/WhereToKite/Models/AppConfig.swift:193-199`). The server refuses bodies
over 64 KB with a 413 (`server/src/ingest.ts:6`), and a crash payload with full call-stack trees for
every thread can be larger. Offline at delivery time = lost too.

**Why it matters.** Crash reports are your only window on crashes on riders' phones (no Crashlytics).

**Smallest fix.** Raise the diagnostics limit (e.g. 512 KB) and, in the app, save the payload to a
file and delete it after a 2xx. **Effort S.**

Confidence: plausible, not reproduced (no real crash payload at hand).

### 6. Missing storm or daylight data fails open · `fragile` (safety)

**What breaks.** If every model returns null for `weather_code` and `cape` for an hour, `stormRisk`
is false (`Sources/KiteCore/Models.swift:318-322`). If sunrise/sunset is missing, `isDaylight` stays
nil and the hour is not "dark" (`Forecast.swift:328-333`, `Recommender.swift:486-488`). Wind present,
safety data absent → scored as safe.

**Why it matters.** It needs Open-Meteo to drop those fields, which I didn't see happen; but
`docs/HANDOFF.md:155` notes Open-Meteo silently dropping out-of-range models, and it's the one place
where a partial answer turns into "safe" rather than "unknown".

**Smallest fix.** No rule change: when an hour has wind but no storm data at all, add a "storm data
missing" warning flag (shown like "unstable air"), and log it. Changing the score would be your
call. **Effort S.**

Confidence: certain on code path, unknown on frequency.

### 7. A bad catalogue reaches every phone within an hour if it still has 50 spots · `fragile`

`CatalogStore.isSane` only checks `spots.count >= 50` (`AppConfig.swift:96`). A build that drops a
country or loses the `bans` field (a parser change in `tools/build_spots.py`) would pass, be served
by `/v1/catalog`, and replace the bundled copy on every phone. CI is the only gate. **Fix:** also
refuse a download with under ~90 % of the bundled spot count or fewer banned spots than bundled.
**Effort S.** Confidence: high on code, no incident seen.

### 8. When the server fails after the 3 s hedge, the Open-Meteo request is thrown away and redone · `polish`

`ServerFailover.run` returns `.serverFailed` when the server errors and Open-Meteo hasn't answered
yet, even if that request is already in flight; the group is cancelled and `request(fallback)` runs
again (`Forecast.swift:131-148`). Cost: one extra Open-Meteo call per batch and up to a second of
waiting on a bad day. **Fix:** keep waiting for the in-flight fallback. **Effort S.** Confidence:
high on code, not timed.

### 9. "Local time" shift uses today's clocks, not the searched day's · `polish`

`timeZoneShiftHours` compares the spot's offset from the forecast with the phone's offset *now*
(`App/WhereToKite/Views/Components.swift:250-255`). Around the October/March clock change, between
Spain and Morocco (Morocco has no summer time), a search a few days ahead can show "15–17h local"
with the wrong shift. Rare. **Effort S.** Confidence: plausible, not reproduced.

## Tests that are missing

- No test for a search of *today* after the slot has started (finding 1).
- No server test that unknown forecast parameters are refused or that forecast routes are rate
  limited (finding 2): the forecast tests check caching and splitting, which work.
- No test for an hour with wind but no weather code (finding 6), nor for a forecast spanning a
  clock change.

## What to cut or merge

Not a UI review, but one server simplification follows from finding 2: the server doesn't need to
be a general Open-Meteo proxy. Making it serve the app's exact request shape is less code to trust
and closes the abuse in one move.

## What is good and should not be touched

- **Hostile payloads can't reach scoring:** every hour is checked for plausible values
  (`Models.swift:332-339`), on the network and in the disk cache; the cache file name refuses
  anything but `yyyy-MM-dd` (`Forecast.swift:617`).
- **Storms are blended cautiously:** worst weather code and highest CAPE of any model
  (`Forecast.swift:534-535`).
- **Partial failures are honest:** spots whose forecast failed are counted and the results say
  "N spots couldn't be checked" (`ResultsView.swift:84`); a blend never runs with a model missing
  (`Forecast.swift:436-458`).
- **Server failover** (3 s hedge, 10 min cool-down) keeps the app working when Cloudflare is blocked.
- **The triage workflow is well sandboxed:** owner-only trigger, no Git credentials during the
  Claude step, edits limited to `tools/spots/`, anything else discarded, nothing merged without you.
- **Report text is defused:** @mentions and links neutralised, own spots can't be reported, length
  limits on both sides.
- **No precise position leaves the phone in the confidence check** (rounded to 0.1°,
  `Confidence.swift:130-133`); test launch arguments only work in debug builds.
- **Catalogue push safety:** the Worker keeps the last good copy if GitHub fails or a push is
  broken JSON (`server/src/catalog.ts:37-42, 67-69`); the 50-subrequest budget is handled explicitly.
