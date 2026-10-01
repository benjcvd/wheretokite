# WhereToKite

Tells a kiter where to go on a given day: give a location, max drive time, day and session slot, get a ranked list of spots.

## Status: v0 — validate the scoring model (CLI, no UI)

```
swift run kite --weight 75 --kites 9,12 --level intermediate      # once: saves ~/.wheretokite/profile.json
swift run kite --day tomorrow --slot afternoon --drive 90 --style chill --distance-matters
swift run kite --day 2026-08-25 --hourly 3                         # past day → archived forecast, for checking against memory
```

## Layout
- `Sources/KiteCore` — platform-independent engine, reused as-is by the iOS app.
  - `Forecast.swift` — `ForecastProvider` protocol, Open-Meteo client (`best_match`, sea grid cell), 2 h per-spot disk cache.
  - `Confidence.swift` — forecast confidence = lead time + disagreement between 4 models at the search origin.
  - `DriveTime.swift` — Apple Maps ETAs, straight-line fallback.
  - `Scoring.swift` — **all tunable rules** (`ScoringRules`): kite wind ranges, level limits, direction curve, gust tolerance.
  - `Recommender.swift` — filter by drive time → fetch → score hours → best 2 h window → distance penalty → rank.
- `Sources/kite` — v0 command-line front-end.
- `tools/build_spots.py` → `Data/spots_barcelona.json` — spots from OpenStreetMap, beach orientation computed from the OSM coastline. Hand-edit `seaFacingDeg` to correct a spot.

## Scoring (v0)
Per hour, score = strength × gustiness × direction (each 0…1):
- **Strength** — each kite's range = 2.2 × weight / size × [0.8, 1.45]; best kite in the quiver is chosen. Chill prefers the lower-middle of the range, intense the top, "all types" anything inside.
- **Gustiness** — (gust − mean) / mean above a tolerance (higher for intense / advanced) is penalised; gusts far above the kite's max too.
- **Direction** — angle between wind and the direction the beach faces: side-onshore best, onshore OK, cross-shore OK, side-offshore poor, offshore 0. Stricter for beginners.
- **Level limits** — hard caps on mean wind / gusts per level.

Spot score = best 2 consecutive hours in the slot. With "distance matters", up to −30 % at the max drive time.

## Roadmap
- **v0** scoring model validated against real days (now)
- **v1** SwiftUI app: inputs + saved profile, confidence banner, ranked list, spot detail with hourly wind
- **v2** tides, foil, model choice, user spot corrections
- **v3** backend, notifications, worldwide spots

Data: © OpenStreetMap contributors (ODbL) · Weather data by Open-Meteo.com (free tier = non-commercial; commercial plan needed for a paid app).
