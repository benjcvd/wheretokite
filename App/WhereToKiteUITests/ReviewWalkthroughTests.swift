import XCTest

/// Throwaway reviewer walkthrough (WHE-158). Free plan, first launch → results → spot page.
/// Env (TEST_RUNNER_ prefix): REVIEW_DAY (yyyy-mm-dd, optional), REVIEW_LANG (en/es/fr),
/// REVIEW_TEXT (content size category, optional), REVIEW_ORIGIN (lat,lon).
final class ReviewWalkthroughTests: XCTestCase {
    var env: [String: String] { ProcessInfo.processInfo.environment }

    @MainActor
    func testWalkthrough() throws {
        let app = XCUIApplication()
        let lang = env["REVIEW_LANG"] ?? "en"
        var args = ["-resetProfile", "-searchOrigin", env["REVIEW_ORIGIN"] ?? "41.3874,2.1686",
                    "-AppleLanguages", "(\(lang))", "-AppleLocale", lang == "en" ? "en_GB" : (lang == "es" ? "es_ES" : "fr_FR")]
        if let d = env["REVIEW_DAY"], !d.isEmpty { args += ["-searchDay", d] }
        if let t = env["REVIEW_TEXT"], !t.isEmpty { args += ["-UIPreferredContentSizeCategoryName", t] }
        app.launchArguments = args
        app.launch()
        sleep(2)
        shot(app, "00-onboarding-1")
        let box = app.descendants(matching: .any)["acceptTerms"].firstMatch
        XCTAssertTrue(box.waitForExistence(timeout: 8))
        var tries = 0
        while !box.isHittable && tries < 6 { app.swipeUp(); tries += 1; shot(app, "00-onboarding-scroll\(tries)") }
        box.tap()
        // Start button label is localised: tap the last button on screen.
        let start = app.buttons["Start"]
        if start.exists { start.tap() } else { app.buttons.matching(NSPredicate(format: "label IN %@", ["Empezar", "C'est parti"])).firstMatch.tap() }
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let allow = springboard.buttons["Allow While Using App"]
        if allow.waitForExistence(timeout: 4) { allow.tap() }
        sleep(1)
        shot(app, "01-home-loading")

        let topSpot = app.buttons["topSpot"], row = app.buttons["spotRow"].firstMatch
        let noSpot = app.descendants(matching: .any)["noSpot"]
        let deadline = Date().addingTimeInterval(70)
        while !topSpot.exists && !row.exists && !noSpot.exists && Date() < deadline { _ = row.waitForExistence(timeout: 1) }
        sleep(3)
        shot(app, "02-results-top")
        if env["REVIEW_INFO"] == "1" && topSpot.exists { topSpot.tap(); sleep(4) }
        if env["REVIEW_INFO"] != "1" {
        for i in 1...4 { app.swipeUp(); sleep(1); shot(app, "03-results-scroll\(i)") }
        for _ in 0..<6 { app.swipeDown() }
        }
        sleep(1)

        if env["REVIEW_DRIVE_MAX"] == "1" {
            app.scrollViews.firstMatch.swipeLeft()
            app.buttons["optionsChip"].tap()
            let slider = app.sliders["driveSlider"]
            if slider.waitForExistence(timeout: 3) { slider.adjust(toNormalizedSliderPosition: 1) }
            sleep(1); shot(app, "02b-options-max")
            if app.buttons["Done"].exists { app.buttons["Done"].tap() } else { app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.15)).tap() }
            sleep(2)
            let d2 = Date().addingTimeInterval(70)
            while !topSpot.exists && !row.exists && !noSpot.exists && Date() < d2 { _ = row.waitForExistence(timeout: 1) }
            sleep(3)
            shot(app, "02c-results-top-maxdrive")
            for i in 1...4 { app.swipeUp(); sleep(1); shot(app, "03c-results-maxdrive-scroll\(i)") }
            for _ in 0..<6 { app.swipeDown() }
        }
        let notK = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'kite' AND label CONTAINS '('")).firstMatch
        if !(topSpot.exists || row.exists) && env["REVIEW_INFO"] != "1" {
            if notK.exists { notK.tap(); sleep(2); shot(app, "02d-not-kiteable"); app.swipeUp(); sleep(1); shot(app, "02d-not-kiteable-2")
                app.buttons.containing(NSPredicate(format: "label CONTAINS 'kn'")).firstMatch.tap(); sleep(3); shot(app, "02e-not-kiteable-spot")
                for i in 1...4 { app.swipeUp(); sleep(1); shot(app, "02e-not-kiteable-spot-scroll\(i)") } }
            return
        }
        if env["REVIEW_INFO"] != "1" { (topSpot.exists ? topSpot : row).tap(); sleep(4) }
        shot(app, "04-spot-top")
        if env["REVIEW_INFO"] == "1" {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.873, dy: 0.443)).tap(); sleep(2); shot(app, "06-score-info")
            app.swipeUp(); sleep(1); shot(app, "06-score-info-2")
            app.swipeUp(); sleep(1); shot(app, "06-score-info-3")
            if app.buttons["Done"].exists { app.buttons["Done"].tap() }
            sleep(1)
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.735)).tap(); sleep(2); shot(app, "06-verdict-info")
            if app.buttons["Done"].exists { app.buttons["Done"].tap() } else { app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1)).tap() }
            sleep(1)
            return
        }
        for i in 1...3 { app.swipeUp(); sleep(1); shot(app, "05-spot-scroll\(i)") }
        for _ in 0..<8 { app.swipeDown() }
        let info = app.buttons["scoreInfo"]
        if info.waitForExistence(timeout: 2) {
            info.tap(); sleep(1); shot(app, "06-score-info")
            app.swipeUp(); sleep(1); shot(app, "06-score-info-2")
            if app.buttons["Done"].exists { app.buttons["Done"].tap() } else { app.swipeDown(velocity: .fast) }
            sleep(1)
        }
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.09, dy: 0.095)).tap()
        sleep(1)
        shot(app, "06z-back-home")
        app.buttons["optionsChip"].tap(); sleep(1); shot(app, "07-options")
        app.swipeUp(); sleep(1); shot(app, "07-options-2")
        app.swipeDown(velocity: .fast); app.swipeDown(velocity: .fast); sleep(1)
        if app.buttons["riderChip"].exists { app.buttons["riderChip"].tap(); sleep(1); shot(app, "08-rider") }
    }

    @MainActor
    private func shot(_ app: XCUIApplication, _ name: String) {
        let a = XCTAttachment(screenshot: app.screenshot())
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }
}

private extension XCUIElementQuery {
    func allElementsBoundBy_last() -> XCUIElement? { allElementsBoundByIndex.last }
}
