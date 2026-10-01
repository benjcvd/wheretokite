import XCTest

/// Walks the main flow end to end against the live forecast API:
/// onboarding → Kite tab (search runs on its own) → spot detail → map → options → My spots → Me.
final class SmokeTests: XCTestCase {
    @MainActor
    func testMainFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile"]
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
    }

    @MainActor
    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let a = XCTAttachment(screenshot: app.screenshot())
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}
