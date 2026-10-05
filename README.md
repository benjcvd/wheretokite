# WhereToKite

Tells a kiter where to go on a given day: give a location, max drive time, day and session slot, get a ranked list of spots.

## iPhone app (v1)

```
cd App && xcodegen          # regenerate WhereToKite.xcodeproj after adding/removing files
open WhereToKite.xcodeproj  # run on a simulator or your iPhone (set your Team under Signing)
```
SwiftUI, iOS 17+. Saved rider profile → search (start point, max drive, day, morning/afternoon/full day,
style, distance matters) → forecast confidence + ranked spots → spot detail (map, hourly wind chart, Directions).
`WhereToKiteUITests` walks the whole flow against the live API and attaches screenshots.

## CLI (v0, for checking the scoring model)

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
- `App/` — iPhone app (`project.yml` is the XcodeGen spec; `WhereToKite/Models`, `WhereToKite/Views`).
- `tools/build_spots.py` → `Data/spots.json` — catalogue of **well-known** kite spots across Europe (27 countries) plus Morocco. The selection lives in `tools/curated_spots.csv` (name, country, how to find it in OpenStreetMap — never raw coordinates; spots kitable from several shores list one `DIR:label` per side). Positions come from Nominatim / OSM elements (beach features preferred over streets or bus stops of the same name) and `seaFacingDeg` from the OSM coastline (lakes/lagoons: the water polygon). Automatic checks, so the catalogue can grow without checking each spot by hand:
  - **Direction vs Apple Maps** (`tools/check_directions.swift`, macOS): Apple's map is rendered around each beach and its water must be on the side OSM says → `directionCheck`. When OSM disagrees but Apple Maps and the CSV hint agree, Apple's direction is used (`corrected`). Everything else that doesn't agree is listed in `tools/review.md` with map links.
  - **Access**: a car route from the nearest mainland city with ferries avoided (Valhalla). If it still needs a ferry the spot gets `access: "ferry"` and its island (`islands` holds simplified outlines; road-connected islands are merged). The app shows ferry spots only to someone on the same island, and mainland spots only on the mainland; the Channel Tunnel counts as road.
  - Reference orientations (Castelldefels, Leucate, Wissant, Tarifa…) must be within 30°.
  To fix a spot, edit its CSV row (better locator, `osm:<id>`, or `hint`) and re-run `python3 tools/build_spots.py`. OSM / Nominatim / Valhalla / Apple responses are cached in `tools/.osm_cache/`.

## Scoring (v0)
Per hour, score = strength × gustiness × direction (each 0…1):
- **Strength** — each kite's range = 2.2 × weight / size × [0.8, 1.45]; best kite in the quiver is chosen. Chill prefers the lower-middle of the range, intense the top, "all types" anything inside.
- **Gustiness** — (gust − mean) / mean above a tolerance (higher for intense / advanced) is penalised; gusts far above the kite's max too.
- **Direction** — angle between wind and the direction the beach faces: side-onshore best, onshore OK, cross-shore OK, side-offshore poor, offshore 0. Stricter for beginners.
- **Level limits** — hard caps on mean wind / gusts per level.

Spot score = best 2 consecutive hours in the slot. With "distance matters", up to −30 % at the max drive time.

## Roadmap
- **v0** scoring model validated against real days
- **v1** SwiftUI app: inputs + saved profile, confidence banner, ranked list, spot detail with hourly wind (built)
- **v2** tides, foil, model choice, user spot corrections
- **v3** backend, notifications, worldwide spots

Data: © OpenStreetMap contributors (ODbL) · Weather data by Open-Meteo.com (free tier = non-commercial; commercial plan needed for a paid app).
