---
name: store-screenshots
description: Produce the App Store screenshots of WhereToKite from the real app in the iOS simulator (6.9" iPhone, free plan, reproducible data). Use for each release, or when the UI changes visibly.
---

# Store screenshots

Apple needs iPhone 6.9" screenshots (1320 × 2868 px portrait), 3 to 10 of them, and scales
them down for smaller iPhones. The app is iPhone-only: no iPad set.

## Principles

- The real app, the **free plan** (never `-unlockPro`: v1 ships without Pro, and App Review
  rejects screenshots of features that can't be used).
- A real windy day, not an archived one (Ben's call: the day chip must match the results).
  The free plan shows four days (today + 3), so check the Open-Meteo forecast for the coasts
  within 3 h of Barcelona (Leucate, Tarifa is too far) and run within the four days before, or on the day
  itself, or up to 3 days before; `TEST_RUNNER_SHOTS_DAY=N` (1–3) makes the test pick day N. Start point stays
  Barcelona (`-searchOrigin 41.3874,2.1686`). Sizes: 6.9" (1320 × 2868) and 6.3" (1206 × 2622),
  into `docs/store/6.9/` and `docs/store/6.3/`.
- Suggested set: also "add your own spot" (map pin, then beach direction). (see `docs/APP_STORE_CONNECT.md`, section 4): results list, spot detail with
  the wind chart, "How is this scored?", search, rider profile.

## Steps

1. A UI test `App/WhereToKiteUITests/StoreScreenshotsTests.swift` walks the set and attaches
   one `XCTAttachment(screenshot:)` per screen, named `01-results`, `02-spot`…, with
   `lifetime = .keepAlways`. Create it once, reusing the SmokeTests steps (safety terms,
   profile: 75 kg, intermediate, 9 m + 12 m). Then `cd App && xcodegen`, and check that
   `DEVELOPMENT_TEAM` is still in `project.pbxproj`.
2. Pick the 6.9" simulator and give it a clean status bar:
   ```sh
   xcrun simctl list devices available | grep "Pro Max"
   xcrun simctl boot "<device>"
   xcrun simctl status_bar "<device>" override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
   ```
3. Run only that test:
   ```sh
   xcodebuild test -project App/WhereToKite.xcodeproj -scheme WhereToKite \
     -destination 'platform=iOS Simulator,name=<device>' \
     -only-testing:WhereToKiteUITests/StoreScreenshotsTests -resultBundlePath /tmp/shots.xcresult
   xcrun xcresulttool export attachments --path /tmp/shots.xcresult --output-path /tmp/shots
   sips -g pixelWidth -g pixelHeight /tmp/shots/*.png
   ```
4. Check every image: 1320 × 2868, no Pro lock or badge, no personal data, real spot names,
   readable scores. Copy the chosen ones to `docs/store/` (committed) with their order.
5. Card in `review`. `You:` tells Ben to look at `docs/store/` and drag them into App Store
   Connect in that order.
