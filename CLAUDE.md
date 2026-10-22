# wheretokite

<!-- ATLAS:BEGIN (managed by Atlas: edits inside this block are overwritten) -->
## Working conventions (Atlas)

This project is run from Atlas, Ben's cockpit, but these rules apply to every Claude session, inside Atlas or not.

| File | What it is | Who updates it |
|---|---|---|
| `CLAUDE.md` | Project context: goal, stack, commands, conventions | Ben, or you when something durable changes |
| `docs/HANDOFF.md` | Resume point: where things stand, open topics, next steps | You, at the end of every working session |
| `.atlas/board.json` | The task board | You, as you work |
| `.atlas/streams/<id>.md` | Each workstream's notes: done / in progress / blocked / ready to merge | That workstream |
| `.claude/agents/<id>.md` | Role of each agent (Lead and workstreams) | Ben or the Lead |
| `.claude/skills/<name>/SKILL.md` | Reusable know-how (release checklist, data refresh…) | Anyone, when a procedure repeats |

**Board** (`.atlas/board.json`): `{"cards":[{"id","title","status","assignee","priority","blocks","note","updated"}]}`
- status: `todo` backlog · `ready` Atlas auto-starts it with its assignee · `doing` · `review` done, Ben should check (say what in note) · `waiting` needs an action from Ben · `done`.
- priority: `blocker` (set `blocks`) · `high` · `normal` · `low`. Never change a priority whose `priorityBy` is `ben`.
- Update the card you're working on as you go, before you end your turn. Notes speak to Ben in the second person.
- Edit only the cards you touch and keep the JSON valid.

**Wrapping up**: before stopping, update `docs/HANDOFF.md` and the board so a fresh session can resume from them alone.

**Skills**: when you notice you're repeating a procedure, propose a skill for it in `.claude/skills/`.
<!-- ATLAS:END -->

## The project

WhereToKite is an iPhone app that tells a kitesurfer where to ride on a given day. The rider
gives a start point, a maximum drive time, a day and a session slot (morning, afternoon,
evening, custom hours). The app gets the forecast for every spot in reach and returns a
ranked list: score, best 2 h window, forecast confidence, wind chart, directions. Coverage is
Europe plus Morocco. Freemium: v1 ships free only (`PaywallMode.freeOnly` in
`App/WhereToKite/Models/Plan.swift`), and Pro is sold later through StoreKit 2.

Ben is the kite domain expert (he rides around Barcelona), the product owner and the only
reviewer. Claude writes the code and explains its decisions. Ben decides on spots, scoring
rules and product. He writes in English or French: answer in the language of his message.
He wants processes automated, with his review as the only manual step.

Current state, open topics and next steps: `docs/HANDOFF.md`. Pending work: `docs/TODO.md`.
Product review: `docs/BLIND_SPOTS.md`. Spot questions for Ben: `tools/spots/TO_CONFIRM.md`.

## Layout

| Path | What | Stack |
|---|---|---|
| `Sources/KiteCore` | The engine, platform-independent, shared by app and CLI: `Scoring.swift` (all tunable rules, `ScoringRules`), `Recommender.swift` (drive-time filter → fetch → hourly score → best 2 h window → distance penalty → rank), `Forecast.swift` (Open-Meteo client), `Confidence.swift`, `DriveTime.swift` (Apple Maps ETAs), `Geo.swift` | Swift 6 package |
| `Sources/kite` | CLI for checking the scoring against real days | Swift |
| `App/` | iPhone app. `project.yml` is the XcodeGen spec; `WhereToKite/Models`, `WhereToKite/Views` | SwiftUI, iOS 17+ |
| `server/` | Cloudflare Worker, live and used by the app (`AppConfig.serverURL`): shared Open-Meteo cache (forecast / archive / marine), `/v1/catalog`, `/v1/report` → GitHub issue, feedback, diagnostics, `/privacy`, `/support`. Details in `server/README.md` | TypeScript, Wrangler, Vitest |
| `tools/spots/*.csv` | **Source of truth for the spot catalogue**, one file per country. Format and curation rules in `tools/spots/README.md` | CSV |
| `tools/build_spots.py` | CSV → `Data/spots.json`: locates each spot from OpenStreetMap, computes which way the beach faces, checks it against Apple Maps (`check_directions.swift`), checks road access (Valhalla). Network cache in `tools/.osm_cache/` | Python 3 |
| `Data/spots.json` | Generated catalogue, bundled in the app and served by `/v1/catalog` | JSON |
| `.github/` | Automation: `report-triage.yml` (app report → Claude checks it with sources → PR on `tools/spots/` or a comment), `claude-followup.yml` (`@claude` from Ben), `catalog-build.yml` (CSV push on main → rebuild `Data/spots.json`) | GitHub Actions |

How it fits together: the app scores spots on the phone with KiteCore and gets forecasts
through the Worker. The catalogue goes CSV → build → `Data/spots.json` on `main`, and the Worker
serves it to apps within about an hour, with no app release. User reports become GitHub
issues, Claude triages them into PRs, Ben merges, and CI rebuilds the catalogue.

## Commands

```sh
swift test                                    # KiteCore tests
swift run kite --day tomorrow --slot afternoon --drive 90   # CLI (profile: --weight --kites --level)
cd App && xcodegen                            # after adding / removing / renaming app files
cd server && npm test && npm run typecheck    # Worker
cd server && npx wrangler deploy              # deploy the Worker (live: ask Ben first)
python3 tools/build_spots.py --curated tools/spots/XX.csv --out /tmp/xx.json --review /tmp/xx.md
                                              # check one country's edits; exit 1 = PROBLEMS
python3 tools/osm_lookup.py near <lat> <lon>  # find an OSM element for a spot
```

## Rules

- **Spots**: famous spots only. Every position comes from OpenStreetMap through the
  pipeline, never typed coordinates. Edit the CSV, never `Data/spots.json` (CI rebuilds it).
  Don't delete rows: set `tier` to `archived`. Encode a `banned` rule only from an official
  source. Renaming a spot changes its id.
- **Competitors** (Windy, Windguru…): browse them as a visitor, as a benchmark only. Never
  scrape them, never read their APIs, never copy their positions or lists.
- **Safety first**: scoring sends people onto the water. Thunderstorms, darkness and seasonal
  bans score 0. Check any change to `Scoring.swift` or to the safety rules with Ben.
- **Server**: test at real size (a request with about 100 spots). The free Workers plan allows
  50 subrequests per request, and a 2-spot test once hid that limit.
- **Ask Ben first** before anything public or outward-facing: deploys, GitHub releases (such
  as the `osm-cache` snapshot), pages, account actions, consent banners. Never send his email
  anywhere.
- **Signing**: `DEVELOPMENT_TEAM` is in the committed `project.pbxproj` but not in
  `App/project.yml`, so `xcodegen` drops it. After a regeneration, check that it's still there.
- **Agents**: run at most about 2 subagents at a time (usage limits).
- The shell is zsh: an unquoted `$var` doesn't word-split (use `${=var}`).
