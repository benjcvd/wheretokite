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
- Reproducible data: a fixed start point and a past windy day, through the app's launch
  arguments `-resetProfile`, `-searchOrigin <lat,lon>`, `-searchDay <YYYY-MM-DD>` (see
  `App/WhereToKiteUITests/SmokeTests.swift`). 2026-10-03 near Barcelona is windy. If the free
  plan refuses a past day, use tomorrow with a windy forecast and say so.
- Suggested set (see `docs/APP_STORE_CONNECT.md`, section 4): results list, spot detail with
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
