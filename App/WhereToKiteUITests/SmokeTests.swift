import XCTest

/// Walks the main flow end to end against the live forecast API:
/// onboarding → Kite tab (search runs on its own) → spot detail → map → options → My spots → Me.
final class SmokeTests: XCTestCase {
    @MainActor
    func testMainFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile", "-searchOrigin", "41.3874,2.1686"]   // Barcelona: the simulator may have no location
        app.launch()

        // Onboarding (first launch only).
        let start = app.buttons["Start"]
        XCTAssertTrue(start.waitForExistence(timeout: 5), "onboarding not shown on first launch")
        snapshot(app, "1-onboarding")
        start.tap()

        // The Kite tab searches straight away; no extra tap needed.
        XCTAssertTrue(app.buttons["riderChip"].waitForExistence(timeout: 5))
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }

        let topSpot = app.buttons["topSpot"]
        let noSpot = app.descendants(matching: .any)["noSpot"]
        func waitForResult(_ seconds: TimeInterval) -> Bool {
            let deadline = Date().addingTimeInterval(seconds)
            while !topSpot.exists && !noSpot.exists && Date() < deadline { _ = topSpot.waitForExistence(timeout: 1) }
            return topSpot.exists || noSpot.exists
        }
        XCTAssertTrue(waitForResult(45), "results never loaded")
        sleep(1)
        snapshot(app, "2-kite")

        // No wind today? Flip through the week until there's a verdict to open.
        var day = 1
        while !topSpot.exists && day < 7 {
            app.buttons["day\(day)"].tap()
            let searching = app.activityIndicators["searching"]
            _ = searching.waitForExistence(timeout: 3)
            let done = NSPredicate(format: "exists == false")
            _ = XCTWaiter.wait(for: [expectation(for: done, evaluatedWith: searching)], timeout: 40)
            XCTAssertTrue(waitForResult(30), "results never loaded for day \(day)")
            day += 1
        }
        if day > 1 && topSpot.exists {
            sleep(1)
            snapshot(app, "2b-kite-verdict")
        }

        if topSpot.exists {
            topSpot.tap()
            XCTAssertTrue(app.buttons["Directions"].waitForExistence(timeout: 5))
            sleep(2)  // let the map tiles load
            snapshot(app, "3-detail")
            // How the score works, and the rider's weights.
            let info = app.buttons["scoreInfo"]
            if info.waitForExistence(timeout: 3) {
                info.tap()
                XCTAssertTrue(app.navigationBars["How is this scored?"].waitForExistence(timeout: 3))
                sleep(1)
                snapshot(app, "3b-score-info")
                let weights = app.buttons["What matters to you"]
                app.swipeUp()
                if weights.waitForExistence(timeout: 3) {
                    weights.tap()
                    sleep(1)
                    snapshot(app, "3c-weights")
                    app.navigationBars.buttons.firstMatch.tap()
                }
                app.buttons["Done"].tap()
                sleep(1)
            }
            app.swipeUp()
            snapshot(app, "4-detail-hourly")
            app.navigationBars.buttons.firstMatch.tap()

            // Runners-up on the map.
            app.swipeUp()
            let mapSegment = app.buttons["Map"]
            if mapSegment.waitForExistence(timeout: 3) {
                mapSegment.tap()
                sleep(3)
                snapshot(app, "5-map")
            }
            app.swipeDown()
            app.swipeDown()
        }

        // Search options: max drive goes up to 10 h.
        app.buttons["optionsChip"].tap()
        let slider = app.sliders["driveSlider"]
        XCTAssertTrue(slider.waitForExistence(timeout: 3))
        slider.adjust(toNormalizedSliderPosition: 1)
        XCTAssertEqual(slider.value as? String, "10 h")
        snapshot(app, "6-options")
        app.buttons["Done"].tap()

        // Profile is editable from the search screen…
        app.buttons["riderChip"].tap()
        XCTAssertTrue(app.navigationBars["Rider profile"].waitForExistence(timeout: 3))
        app.buttons["Done"].tap()

        // …and lives in its own tab.
        app.tabBars.buttons["My spots"].tap()
        sleep(1)
        snapshot(app, "7-my-spots")
        app.tabBars.buttons["Me"].tap()
        XCTAssertTrue(app.navigationBars["Me"].waitForExistence(timeout: 3))
        snapshot(app, "8-me")
        app.swipeUp()
        sleep(1)
        snapshot(app, "8b-me-weights")
    }

    /// The "How is this scored?" sheet, opened from any spot (calm days have no top spot).
    @MainActor
    func testScoreInfo() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile", "-searchDay", "2026-10-03",   // a windy day near Barcelona
                                "-searchOrigin", "41.3874,2.1686"]
        app.launch()
        app.buttons["Start"].tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }

        // The windy spots that day are ~2 h away.
        app.buttons["optionsChip"].tap()
        let slider = app.sliders["driveSlider"]
        XCTAssertTrue(slider.waitForExistence(timeout: 3))
        slider.adjust(toNormalizedSliderPosition: 1)
        app.buttons["Done"].tap()

        let topSpot = app.buttons["topSpot"], row = app.buttons["spotRow"].firstMatch
        let deadline = Date().addingTimeInterval(60)
        while !topSpot.exists && !row.exists && Date() < deadline { _ = row.waitForExistence(timeout: 1) }
        if !topSpot.exists && !row.exists { app.swipeUp(); _ = row.waitForExistence(timeout: 5) }
        (topSpot.exists ? topSpot : row).tap()
        XCTAssertTrue(app.buttons["Directions"].waitForExistence(timeout: 5))
        app.buttons["scoreInfo"].tap()
        XCTAssertTrue(app.navigationBars["How is this scored?"].waitForExistence(timeout: 3))
        sleep(1)
        snapshot(app, "score-info")
        app.swipeUp()
        snapshot(app, "score-info-2")
    }

    /// An archived day is labelled with its own date (it used to say "Today"), and the Kite
    /// screen and spot detail hold up at an accessibility text size.
    @MainActor
    func testSearchedDayLabelAndLargeText() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile", "-searchDay", "2026-10-03", "-searchOrigin", "41.3874,2.1686",
                               "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityL"]
        app.launch()
        let start = app.buttons["Start"]
        XCTAssertTrue(start.waitForExistence(timeout: 5))
        snapshot(app, "xl-onboarding")
        start.tap()
        let summary = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Afternoon 13:00'")).firstMatch
        XCTAssertTrue(summary.waitForExistence(timeout: 60))
        XCTAssertFalse(summary.label.hasPrefix("Today"), summary.label)
        XCTAssertTrue(summary.label.contains("3"), summary.label)
        sleep(1)
        snapshot(app, "xl-kite")
        let row = app.buttons["topSpot"].exists ? app.buttons["topSpot"] : app.buttons["spotRow"].firstMatch
        if row.waitForExistence(timeout: 5) {
            row.tap()
            XCTAssertTrue(app.buttons["Directions"].waitForExistence(timeout: 5))
            sleep(2)
            snapshot(app, "xl-detail")
        }
    }

    @MainActor
    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let a = XCTAttachment(screenshot: app.screenshot())
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}
