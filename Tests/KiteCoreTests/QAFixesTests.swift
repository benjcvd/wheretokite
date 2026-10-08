import XCTest
@testable import KiteCore

/// Regressions found in QA.
final class QAFixesTests: XCTestCase {
    /// The API wants Gregorian dates even when the phone uses a Buddhist or Japanese calendar.
    func testDayStringIsGregorian() {
        let date = DayString.date("2026-10-08")!
        XCTAssertEqual(DayString.from(date), "2026-10-08")
        let f = DayString.formatter()
        XCTAssertEqual(f.calendar.identifier, .gregorian)
        XCTAssertEqual(f.locale.identifier, "en_US_POSIX")
        XCTAssertEqual(Confidence.daysBetweenForTests("2026-10-08", "2026-10-11"), 3)
    }

    /// A spot that gains a tide rule must not reuse a cached forecast fetched without tides.
    func testCacheKeepsTideEntriesApart() async throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: dir) }
        let upstream = CountingProvider()
        let cache = CachedForecastProvider(upstream: upstream, directory: dir)
        var spot = try JSONDecoder().decode(Spot.self, from: Data(#"{"id":"a","name":"A","latitude":47,"longitude":-2}"#.utf8))
        _ = try await cache.forecasts(for: [spot], day: "2026-10-03")
        _ = try await cache.forecasts(for: [spot], day: "2026-10-03")
        let n1 = await upstream.calls; XCTAssertEqual(n1, 1)
        spot.tide = "high"
        _ = try await cache.forecasts(for: [spot], day: "2026-10-03")
        let n2 = await upstream.calls; XCTAssertEqual(n2, 2)
    }

    /// "12 kn", not "12–12 kn"; and the scored hours are known even without a good window.
    func testReasonAndScoredHours() {
        let r = Recommender(spots: [], forecast: CountingProvider(), driveTime: StraightLineDriveTime(), confidence: nil)
        let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
        let hours = (13...17).map { h in
            scorer.score(HourlyWind(localTime: String(format: "2026-10-03T%02d:00", h), speedKn: h == 15 || h == 16 ? 12.2 : 5,
                                    gustKn: 25, directionDeg: 180), seaFacingDeg: 180)
        }
        let spot = try! JSONDecoder().decode(Spot.self, from: Data(#"{"id":"a","name":"A","latitude":41,"longitude":2}"#.utf8))
        let req = SearchRequest(origin: Coordinate(latitude: 41, longitude: 2), maxDriveMinutes: 60, day: "2026-10-03",
                                slot: .afternoon, intensity: nil, distanceMatters: false)
        let rec = r.recommend(spot, hours: hours, drive: 10, request: req)
        XCTAssertFalse(rec.reason.contains("12–12"), rec.reason)
        XCTAssertEqual(rec.scoredHours?.start, 15)
        XCTAssertEqual(rec.scoredHours?.end, 17)
    }
}

private actor CountingProvider: ForecastProvider {
    var calls = 0
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        calls += 1
        return Dictionary(uniqueKeysWithValues: spots.map {
            ($0.id, DayForecast(day: day, hours: [HourlyWind(localTime: day + "T12:00", speedKn: 15, gustKn: 18, directionDeg: 270)]))
        })
    }
}

enum Confidence {
    static func daysBetweenForTests(_ a: String, _ b: String) -> Int { ConfidenceEstimator.daysBetween(a, b) }
}
