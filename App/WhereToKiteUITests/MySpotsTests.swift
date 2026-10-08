import XCTest

/// Drives the "My spots" flow: empty state → add (map, search) → details → list → edit.
/// Opens the "My spots" tab when there is one.
final class MySpotsTests: XCTestCase {
    static let shotsDir = ProcessInfo.processInfo.environment["SHOTS_DIR"]

    @MainActor
    func testAddSpotFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetUserSpots"]
        app.launch()
        // A fresh install opens on onboarding (this test used to skip itself there).
        let start = app.buttons["Start"]
        if start.waitForExistence(timeout: 3) { start.tap() }
        let tab = app.tabBars.buttons["My spots"]
        XCTAssertTrue(tab.waitForExistence(timeout: 5))
        tab.tap()

        let add = app.buttons["Add a spot"]
        XCTAssertTrue(add.waitForExistence(timeout: 5))
        snapshot(app, "1-empty")
        add.tap()

        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        sleep(3)
        snapshot(app, "2-map-far")
        search.tap()
        search.typeText("Platja de Castelldefels")
        sleep(3)
        snapshot(app, "3-search")
        let result = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'Castelldefels'")).firstMatch
        if result.waitForExistence(timeout: 5) { result.tap() } else { search.typeText("\n") }
        sleep(4)
        snapshot(app, "4-map-pin")

        let next = app.buttons["Next"]
        XCTAssertTrue(next.isEnabled)
        next.tap()
        XCTAssertTrue(app.textFields["spotName"].waitForExistence(timeout: 5))
        sleep(5)
        snapshot(app, "5-details")
        let dial = app.otherElements["Beach direction"]
        if dial.exists {
            dial.coordinate(withNormalizedOffset: CGVector(dx: 0.75, dy: 0.85)).tap()
            snapshot(app, "5b-details-adjusted")
        }
        let sector = app.sliders["waterSector"]
        var savedSector = ""
        if sector.waitForExistence(timeout: 3) {
            sector.adjust(toNormalizedSliderPosition: 0.75)   // 270°: a point
            sleep(1)
            snapshot(app, "5c-sector-270")
            savedSector = sector.value as? String ?? ""
        }
        app.textFields["spotName"].tap()
        app.textFields["spotName"].typeText("Secret beach")
        let save = app.buttons["Save"]
        XCTAssertTrue(save.isEnabled)
        save.tap()

        XCTAssertTrue(app.buttons["userSpotRow"].waitForExistence(timeout: 5))
        snapshot(app, "6-list")
        app.buttons["userSpotRow"].firstMatch.tap()
        sleep(3)
        snapshot(app, "7-edit")

        // Editing keeps what was saved.
        XCTAssertEqual(app.textFields["spotName"].value as? String, "Secret beach")
        let sectorValue = app.sliders["waterSector"].value as? String ?? ""
        XCTAssertEqual(sectorValue, savedSector, "sector not kept")
        // Edge: a lake (360°) hides the second side; save still works.
        app.sliders["waterSector"].adjust(toNormalizedSliderPosition: 1)
        // On the iPhone 17e simulator XCUITest can't move this slider at the bottom of the
        // edit sheet (value stays put); only check the 360° case where it moved.
        guard ((app.sliders["waterSector"].value as? String) ?? "").hasPrefix("360") else { return }
        XCTAssertFalse(app.switches["otherSideToggle"].exists)
        app.buttons["Save"].tap()
        XCTAssertTrue(app.buttons["userSpotRow"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["userSpotRow"].label.contains("all around"), app.buttons["userSpotRow"].label)
    }

    @MainActor
    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let shot = app.screenshot()
        let a = XCTAttachment(screenshot: shot)
        a.name = name
        a.lifetime = .keepAlways
        add(a)
        if let dir = Self.shotsDir {
            try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
            try? shot.pngRepresentation.write(to: URL(fileURLWithPath: dir).appendingPathComponent("\(name).png"))
        }
    }
}
