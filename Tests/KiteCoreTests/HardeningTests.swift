import XCTest
@testable import KiteCore

/// Inputs that come from outside the code (launch arguments, cache files, network) are checked
/// before they reach file names, URLs or the scoring.
final class HardeningTests: XCTestCase {
    func testValidDay() {
        XCTAssertTrue(DayForecast.isValidDay("2026-10-08"))
        for bad in ["", "2026-1-08", "2026/10/08", "../../../x", "2026-10-08/../../a", "2026-10-0８", "today"] {
            XCTAssertFalse(DayForecast.isValidDay(bad), bad)
        }
    }

    func testPlausibleWind() {
        XCTAssertTrue(HourlyWind.isPlausible(speedKn: 18, gustKn: 24, directionDeg: 225))
        XCTAssertFalse(HourlyWind.isPlausible(speedKn: .nan, gustKn: 24, directionDeg: 225))
        XCTAssertFalse(HourlyWind.isPlausible(speedKn: 1e300, gustKn: 24, directionDeg: 225))
        XCTAssertFalse(HourlyWind.isPlausible(speedKn: -1, gustKn: 24, directionDeg: 225))
        XCTAssertFalse(HourlyWind.isPlausible(speedKn: 18, gustKn: 24, directionDeg: .infinity))
    }

    func testCacheRejectsBadDayAndIgnoresCorruptEntries() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: dir) }
        let upstream = FixedForecast()
        let cache = CachedForecastProvider(upstream: upstream, directory: dir)
        let spot = Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: 165)

        do {
            _ = try await cache.forecasts(for: [spot], day: "../../escape")
            XCTFail("expected invalidDay")
        } catch ForecastError.invalidDay {}

        // A cache entry with absurd values (tampered or corrupt) is refetched, not used.
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let json = #"{"fetchedAt": \#(Date().timeIntervalSinceReferenceDate), "forecast": {"day": "2026-10-08", "hours": [{"localTime": "2026-10-08T14:00", "speedKn": 1e300, "gustKn": 1, "directionDeg": 0}]}}"#
        try Data(json.utf8).write(to: dir.appendingPathComponent("41.0000_2.0000_2026-10-08.json"))
        let result = try await cache.forecasts(for: [spot], day: "2026-10-08")
        XCTAssertEqual(result["x"]?.hours.first?.speedKn, 18)
    }
}

private struct FixedForecast: ForecastProvider {
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        Dictionary(uniqueKeysWithValues: spots.map {
            ($0.id, DayForecast(day: day, hours: [HourlyWind(localTime: day + "T14:00", speedKn: 18, gustKn: 22,
                                                             directionDeg: 200)]))
        })
    }
}
