import XCTest

/// Me → Language: the pick sticks and the app opens in that language next time.
final class LanguageTests: XCTestCase {
    /// A saved profile and accepted terms: straight to the tabs, no onboarding.
    private static let profile = "<" + Data(#"{"weightKg":75,"kites":[9,12],"level":"intermediate"}"#.utf8)
        .map { String(format: "%02x", $0) }.joined() + ">"
    private static let base = ["-riderProfile", profile, "-disclaimerAccepted", "YES", "-searchOrigin", "41.3874,2.1686"]

    @MainActor
    func testPickSpanishThenBack() throws {
        let app = XCUIApplication()
        app.launchArguments = Self.base + ["-AppleLanguages", "(en)"]
        app.launch()

        app.tabBars.buttons["Me"].tap()
        let picker = app.buttons["languagePicker"]
        var tries = 0
        while !picker.isHittable && tries < 4 { app.swipeUp(); tries += 1 }
        picker.tap()
        app.buttons["Español"].tap()
        XCTAssertTrue(app.alerts["Reopen WhereToKite"].waitForExistence(timeout: 3))
        app.alerts.buttons["OK"].tap()

        // Next launch, without forcing a language: the app's own choice applies.
        app.terminate()
        app.launchArguments = Self.base
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Yo"].waitForExistence(timeout: 5), "not in Spanish after relaunch")

        // Back to the phone's language, so other tests run in English.
        app.tabBars.buttons["Yo"].tap()
        tries = 0
        while !picker.isHittable && tries < 4 { app.swipeUp(); tries += 1 }
        picker.tap()
        app.buttons["Como el iPhone"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Me"].waitForExistence(timeout: 5), "still in Spanish after going back")
    }
}
