---
name: preflight
description: Run every WhereToKite check that applies to the current changes (KiteCore Swift tests, Worker tests and typecheck, iOS build/tests, catalogue check) before committing or pushing. Use before any commit, when asked to "check everything", or after a refactor touching several parts.
---

# Preflight

Look at `git status` / `git diff --stat` and run only the parts that apply. Report each
result with its real output when something fails.

| Changed | Run |
|---|---|
| `Sources/`, `Tests/`, `Package.swift` | `swift test` (the CLI is `swift run kite …`) |
| `server/` | `cd server && npm test && npm run typecheck` |
| `App/` or `Sources/KiteCore` | iOS build, see below |
| `tools/spots/*.csv`, `tools/build_spots.py` | the `spot-check` skill |
| `.github/workflows/` | re-read the triage permissions: triage must only be able to edit `tools/spots/` |

## iOS build

```sh
cd App && xcodegen        # only if files were added, removed or renamed
xcodebuild -project App/WhereToKite.xcodeproj -scheme WhereToKite \
  -destination 'platform=iOS Simulator,name=<an available iPhone>' build
```

- Pick the simulator with `xcrun simctl list devices available`.
- The unit tests are `-only-testing:WhereToKiteTests`. The UI tests (`WhereToKiteUITests`)
  call the live API and take minutes, so run them only for flow changes.

## Before the commit (blocking)

- `DEVELOPMENT_TEAM` is committed in `project.pbxproj` but not in `App/project.yml`, so
  `xcodegen` drops it. After a regeneration, check that both lines are still there. Stage
  files by name, never `git add -A` / `git add .`.
- Don't commit `Data/spots.json` by hand: CI rebuilds it after the merge.
- Pending work goes on the board (`.atlas/board.json`), never in a to-do file.
