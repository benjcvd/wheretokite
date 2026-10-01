import XCTest

/// Walks the main flow end to end against the live forecast API:
/// onboarding → search → results → spot detail.
final class SmokeTests: XCTestCase {
    @MainActor
    func testMainFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetProfile"]
        app.launch()

        // Onboarding (shown on first launch only).
        let start = app.buttons["Start"]
        if start.waitForExistence(timeout: 5) {
            snapshot(app, "1-onboarding")
            start.tap()
        }

        XCTAssertTrue(app.buttons["Find spots"].waitForExistence(timeout: 5))
        snapshot(app, "2-search")
        app.buttons["Find spots"].tap()

        // Allow location if asked.
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }

        let loaded = app.staticTexts["Best spots"].waitForExistence(timeout: 40)
            || app.staticTexts["No kiteable spot"].exists
        XCTAssertTrue(loaded, "results never loaded")
        snapshot(app, "3-results")

        let firstSpot = app.buttons.matching(identifier: "spotRow").firstMatch
        if app.staticTexts["Best spots"].exists, firstSpot.exists {
            firstSpot.tap()
            XCTAssertTrue(app.buttons["Directions"].waitForExistence(timeout: 5))
            sleep(2)  // let the map tiles load
            snapshot(app, "4-detail")
            app.swipeUp()
            snapshot(app, "5-detail-hourly")
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
