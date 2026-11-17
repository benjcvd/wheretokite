import XCTest
import KiteCore
@testable import WhereToKite

/// WHE-164: a failed search must not leave the previous answer on screen under new settings.
@MainActor
final class SearchModelTests: XCTestCase {
    /// 18 kn on `goodDay`, fails on any other day (a server hiccup).
    struct FlakyForecast: ForecastProvider {
        struct Down: Error {}
        let goodDay: String
        func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
            guard day == goodDay else { throw Down() }
            return Dictionary(uniqueKeysWithValues: spots.map { spot in
                (spot.id, DayForecast(day: day, hours: (0...23).map {
                    HourlyWind(localTime: String(format: "\(day)T%02d:00", $0), speedKn: 18, gustKn: 20, directionDeg: 210)
                }))
            })
        }
    }

    func testFailedSearchClearsThePreviousResult() async {
        let spot = Spot.userSpot(id: "s", name: "S", latitude: 45, longitude: 0.2, seaFacingDeg: 165)
        let days = DayOption.next(3).map(\.id)
        let recommender = Recommender(spots: [spot], forecast: FlakyForecast(goodDay: days[1]),
                                      driveTime: StraightLineDriveTime(), confidence: nil)
        let model = SearchModel(recommender: recommender, catalog: [spot])
        let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
        var options = SearchOptions()
        options.start = StartPoint(name: "Here", coordinate: Coordinate(latitude: 45, longitude: 0))
        options.slot = .fullDay
        options.day = days[1]

        await model.run(options, profile: rider, userSpots: [], lookaheadDays: 0)
        XCTAssertEqual(model.result?.request.day, days[1])
        XCTAssertNil(model.error)

        // The rider taps the next day and the forecast fails.
        options.day = days[2]
        await model.run(options, profile: rider, userSpots: [], lookaheadDays: 0)
        XCTAssertNotNil(model.error)
        XCTAssertNil(model.result, "the previous day's answer must not stay under the new day")
        XCTAssertNil(model.finishedAt)
        XCTAssertNil(model.progress)
    }
}
