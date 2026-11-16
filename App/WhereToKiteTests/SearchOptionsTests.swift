import KiteCore
import XCTest
@testable import WhereToKite

/// The app offers four sessions; Evening stays in the engine for the CLI only (WHE-216).
final class SearchOptionsTests: XCTestCase {
    func testAppSessionsHaveNoEvening() {
        XCTAssertEqual(SessionSlot.appChoices, [.morning, .afternoon, .fullDay, .custom])
    }

    func testSavedEveningBecomesMyHours17To20() {
        var options = SearchOptions()
        options.slot = .evening
        options.migrateRetiredSlot()
        XCTAssertEqual(options.slot, .custom)
        XCTAssertEqual(options.customHours, 17...19)
        XCTAssertEqual(options.hoursLabel, "17:00–20:00")
    }

    func testOtherSessionsAreKept() {
        var options = SearchOptions()
        options.slot = .custom
        options.customStart = 7
        options.customEnd = 10
        options.migrateRetiredSlot()
        XCTAssertEqual(options.slot, .custom)
        XCTAssertEqual(options.customHours, 7...9)
    }
}
