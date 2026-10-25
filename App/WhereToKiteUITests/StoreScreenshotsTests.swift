import XCTest

/// App Store screenshots, free plan, from Barcelona on a real forecast (today, or a later day
/// of the free plan's four with TEST_RUNNER_SHOTS_DAY=1…3), so the day shown matches the results:
/// results → spot detail → "How is this scored?" → search options → rider profile → own spot.
/// Run on the 6.9" and 6.3" simulators; see .claude/skills/store-screenshots.
final class StoreScreenshotsTests: XCTestCase {
    @MainActor
    func testStoreScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile", "-searchOrigin", "41.3874,2.1686"]   // no -unlockPro
        app.launch()
        SmokeTests().acceptTerms(app)
        app.buttons["Start"].tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }

        if let day = ProcessInfo.processInfo.environment["SHOTS_DAY"], day != "0" {
            XCTAssertTrue(app.buttons["day\(day)"].waitForExistence(timeout: 5))
            app.buttons["day\(day)"].tap()
        }

        // Windy spots are often ~2 h away: the free plan's 3 h covers them.
        app.buttons["optionsChip"].tap()
        let slider = app.sliders["driveSlider"]
        XCTAssertTrue(slider.waitForExistence(timeout: 3))
        slider.adjust(toNormalizedSliderPosition: 1)
        sleep(1)
        let options = app.screenshot()
        app.buttons["Done"].tap()

        let topSpot = app.buttons["topSpot"], row = app.buttons["spotRow"].firstMatch
        let deadline = Date().addingTimeInterval(60)
        while !topSpot.exists && !row.exists && Date() < deadline { _ = row.waitForExistence(timeout: 1) }
        XCTAssertTrue(topSpot.exists || row.exists, "results never loaded")
        sleep(2)
        snapshot(app.screenshot(), "01-results")

        (topSpot.exists ? topSpot : row).tap()
        XCTAssertTrue(app.buttons["Directions"].waitForExistence(timeout: 5))
        sleep(3)  // let the map tiles load
        snapshot(app.screenshot(), "02-spot")
        app.swipeUp()
        sleep(1)
        snapshot(app.screenshot(), "03-spot-hourly")
        app.swipeDown()

        app.buttons["scoreInfo"].tap()
        XCTAssertTrue(app.navigationBars["How is this scored?"].waitForExistence(timeout: 3))
        sleep(1)
        snapshot(app.screenshot(), "04-score")
        app.buttons["Done"].tap()
        sleep(1)
        app.navigationBars.buttons.firstMatch.tap()

        snapshot(options, "05-search")

        app.buttons["riderChip"].tap()
        XCTAssertTrue(app.navigationBars["Rider profile"].waitForExistence(timeout: 3))
        sleep(1)
        snapshot(app.screenshot(), "06-profile")
        app.buttons["Done"].tap()

        // Your own spot: the free plan allows one. Same flow as MySpotsTests.
        app.tabBars.buttons["My spots"].tap()
        let accept = app.buttons["acceptDisclaimer"]
        if accept.waitForExistence(timeout: 2) { accept.tap() }
        let add = app.buttons["Add a spot"]
        XCTAssertTrue(add.waitForExistence(timeout: 5))
        add.tap()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("Platja de Castelldefels")
        let result = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'Castelldefels'")).firstMatch
        if result.waitForExistence(timeout: 5) { result.tap() } else { search.typeText("\n") }
        sleep(4)  // let the map tiles load
        snapshot(app.screenshot(), "07-add-spot-map")
        app.buttons["Next"].tap()
        XCTAssertTrue(app.textFields["spotName"].waitForExistence(timeout: 5))
        app.textFields["spotName"].tap()
        app.textFields["spotName"].typeText("Castelldefels beach\n")
        sleep(4)
        snapshot(app.screenshot(), "08-add-spot-details")
    }

    @MainActor
    private func snapshot(_ shot: XCUIScreenshot, _ name: String) {
        let a = XCTAttachment(screenshot: shot)
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}
