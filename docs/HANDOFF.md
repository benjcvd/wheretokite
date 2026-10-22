# Session handoff

Read this first in a new session, then `docs/TODO.md` (what's pending) and
`tools/spots/TO_CONFIRM.md` (spot questions). Last updated 2026-10-22.

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
  Free plan: 1 own spot, 3 h drive, top 5, 2 days ahead; water sector, second side and tide
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
- Team: agents `backend-engineer`, `spot-researcher`, `spot-improvement` and skills `preflight`,
  `spot-check` in `.claude/` (not committed yet). Workstream **Spot improvement** runs in small
  batches on Sonnet (one region per card, no subagents, commit then stop); notes in
  `.atlas/streams/spot-improvement.md`. Full role in `.atlas/team/agents/spot-improvement.md`.

## Where we stopped (2026-10-23)
- Spot improvement merged into main (c261e03): Portugal and Morocco web-verified, 4 PT spots
  added, Moroccan spots routed from Moroccan cities (they were all `access: ferry`, so hidden).
- App fix (6994a96): searches keep spots on the origin's continent (`Continent` in
  `DriveTime.swift`), otherwise Tarifa would get Tangier as a 40 min drive.
- **Not pushed**: Ben says "push", then CI rebuilds `Data/spots.json`.
- v1 / App Store: the list of what's missing is on the board (`v1-*`, `tf-*` cards): privacy
  contact, App Store Connect app, EU trader status, App Privacy answers, store text and
  screenshots (Claude), archive and upload.
