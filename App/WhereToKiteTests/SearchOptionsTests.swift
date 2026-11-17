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

    /// WHE-221: options saved with the old chill-to-intense style still load, with no water or
    /// weather choice.
    func testOldStyleOptionsStillDecode() throws {
        // Today's encoding minus the new keys, plus the retired one.
        var json = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(SearchOptions())) as? [String: Any])
        json["water"] = nil
        json["weather"] = nil
        json["intensity"] = 0.8
        json["maxDriveMinutes"] = 90
        let options = try JSONDecoder().decode(SearchOptions.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertNil(options.water)
        XCTAssertNil(options.weather)
        XCTAssertEqual(options.maxDriveMinutes, 90)
    }

    func testChoicesRoundTrip() throws {
        var options = SearchOptions()
        options.water = .flat
        options.weather = .fair
        let back = try JSONDecoder().decode(SearchOptions.self, from: JSONEncoder().encode(options))
        XCTAssertEqual(back.water, .flat)
        XCTAssertEqual(back.weather, .fair)
    }
}
