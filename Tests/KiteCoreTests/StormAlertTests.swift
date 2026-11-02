import XCTest
@testable import KiteCore

/// WHE-74: a storm later in the day is announced ("Storm from 4 pm"); only the hour just
/// before it loses a little score. Storm hours themselves stay at 0.
final class StormAlertTests: XCTestCase {
    func wind(_ h: Int, storm: Bool = false) -> HourlyWind {
        var w = HourlyWind(localTime: String(format: "2026-08-24T%02d:00", h), speedKn: 18, gustKn: 22, directionDeg: 135)
        w.isDaylight = true
        if storm { w.weatherCode = 95 }
        return w
    }

    func spot() -> Spot {
        try! JSONDecoder().decode(Spot.self, from: Data(#"{"id":"a","name":"A","latitude":42.6,"longitude":3.0,"seaFacingDeg":120}"#.utf8))
    }

    func request(_ slot: SessionSlot = .afternoon) -> SearchRequest {
        SearchRequest(origin: Coordinate(latitude: 42.6, longitude: 3.0), maxDriveMinutes: 60, day: "2026-08-24",
                      slot: slot, intensity: nil, distanceMatters: false)
    }

    /// The Saint-Cyprien case: good 13–15 h, storm from 16 h.
    func day(stormFrom: Int?) -> [HourlyWind] {
        (0...23).map { h in wind(h, storm: stormFrom.map { h >= $0 } ?? false) }
    }

    func scored(_ day: [HourlyWind], slot: ClosedRange<Int>) -> [HourScore] {
        let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
        var hours = day.filter { slot.contains($0.hour) }.map { scorer.score($0, sides: spot().allSides) }
        hours = Recommender.applySafety(spot(), to: hours, day: "2026-08-24")
        return Recommender.applyStormBuffer(hours, day: day, rules: ScoringRules())
    }

    func testHourBeforeTheStormLosesALittle() {
        let plain = scored(day(stormFrom: nil), slot: 13...17)
        let out = scored(day(stormFrom: 16), slot: 13...17)
        XCTAssertEqual(out[0].score, plain[0].score)                       // 13 h untouched
        XCTAssertEqual(out[1].score, plain[1].score)                       // 14 h untouched
        XCTAssertEqual(out[2].score, plain[2].score * 0.8, accuracy: 1e-9)  // 15 h: last hour before
        XCTAssertTrue(out[2].flags.contains("storm nearby"))
        XCTAssertEqual(out[3].score, 0)                                    // storm hours stay 0
        XCTAssertEqual(out[4].score, 0)
        XCTAssertFalse(out[3].flags.contains("storm nearby"))
    }

    /// A storm right after the searched hours still costs the last searched hour.
    func testStormJustAfterTheSlotCounts() {
        let out = scored(day(stormFrom: 18), slot: 13...17)
        XCTAssertTrue(out.last!.flags.contains("storm nearby"))
        XCTAssertTrue(out.dropLast().allSatisfy { !$0.flags.contains("storm nearby") })
    }

    func testAlertHour() {
        let r = Recommender(spots: [], forecast: StormDay(hours: []), driveTime: StraightLineDriveTime(), confidence: nil)
        let rules = ScoringRules()
        for (storm, expected) in [(16, 16), (17, 17), (nil, nil)] as [(Int?, Int?)] {
            let d = day(stormFrom: storm)
            let rec = r.recommend(spot(), hours: scored(d, slot: 13...17), drive: 10, request: request())
            XCTAssertEqual(Recommender.stormStart(rec, day: d, searched: 13...17, rules: rules), expected, "storm \(String(describing: storm))")
        }
        // Morning session (9–12 h, window ends 13 h): a storm at 14 h is within 2 h, at 16 h it isn't.
        for (storm, expected) in [(14, 14), (16, nil)] as [(Int, Int?)] {
            let d = day(stormFrom: storm)
            let rec = r.recommend(spot(), hours: scored(d, slot: 9...12), drive: 10, request: request(.morning))
            XCTAssertEqual(rec.window?.end, 13)
            XCTAssertEqual(Recommender.stormStart(rec, day: d, searched: 9...12, rules: rules), expected, "storm \(storm)")
        }
    }

    /// Through a whole search: the spot keeps its window and score and carries the alert.
    func testSearchCarriesTheAlert() async throws {
        let r = Recommender(spots: [spot()], forecast: StormDay(hours: day(stormFrom: 16)),
                            driveTime: StraightLineDriveTime(), confidence: nil)
        let rec = try await r.search(request(), profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate),
                                     today: "2026-08-24").recommendations[0]
        XCTAssertEqual(rec.stormFrom, 16)
        XCTAssertEqual(rec.window?.start, 13)
        XCTAssertGreaterThan(rec.finalScore, 0)
        XCTAssertTrue(rec.hours.filter { $0.wind.hour >= 16 }.allSatisfy { $0.score == 0 })
    }

    func testNextHour() {
        XCTAssertEqual(Recommender.nextHour("2026-08-24T15:00"), "2026-08-24T16:00")
        XCTAssertEqual(Recommender.nextHour("2026-08-24T09:00"), "2026-08-24T10:00")
        XCTAssertNil(Recommender.nextHour("2026-08-24T23:00"))
    }
}

private struct StormDay: ForecastProvider {
    var hours: [HourlyWind]
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        Dictionary(uniqueKeysWithValues: spots.map { ($0.id, DayForecast(day: day, hours: hours)) })
    }
}
