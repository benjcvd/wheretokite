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
