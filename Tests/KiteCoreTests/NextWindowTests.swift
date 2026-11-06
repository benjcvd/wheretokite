import XCTest
@testable import KiteCore

/// WHE-136: the "next good window" card must promise what that day's search then shows.
final class NextWindowTests: XCTestCase {
    /// Forecast wind per day, the same at every spot.
    struct DayWind: ForecastProvider {
        let kn: [String: Double]
        func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
            let v = kn[day] ?? 0
            return Dictionary(uniqueKeysWithValues: spots.map { spot in
                (spot.id, DayForecast(day: day, hours: (9...17).map {
                    HourlyWind(localTime: String(format: "\(day)T%02d:00", $0), speedKn: v, gustKn: v * 1.15, directionDeg: 210)
                }))
            })
        }
    }

    /// What four weather models say per day (all agree on `kn`).
    struct Models: ConfidenceProvider {
        let kn: [String: Double]
        func estimates(for queries: [ConfidenceQuery], day: String, today: String) async throws -> [ForecastConfidence] {
            let v = kn[day] ?? 0
            let hours = (0...23).map { ModelWind(hour: $0, speedKn: v, directionDeg: 210) }
            return queries.map { _ in
                ForecastConfidence(score: 80, rating: .high, leadDays: 1, speedSpreadKn: 0, directionSpreadDeg: 0,
                                   modelsCompared: ["a", "b", "c", "d"],
                                   modelHours: ["a": hours, "b": hours, "c": hours, "d": hours])
            }
        }
    }

    func testDayTheModelsDoubtIsSkipped() async throws {
        let spot = Spot(id: "s", name: "S", latitude: 45, longitude: 0.2, seaFacingDeg: 165)
        // 7th: the main forecast says 18 kn but the models see 4 kn → capped, not a good window.
        // 8th: 18 kn and the models agree → the real next window.
        let forecast = DayWind(kn: ["2026-11-06": 4, "2026-11-07": 18, "2026-11-08": 18])
        let models = Models(kn: ["2026-11-07": 4, "2026-11-08": 18])
        let r = Recommender(spots: [spot], forecast: forecast, driveTime: StraightLineDriveTime(), confidence: models)
        let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
        let req = SearchRequest(origin: Coordinate(latitude: 45, longitude: 0), maxDriveMinutes: 60, day: "2026-11-06",
                                slot: .fullDay, intensity: nil, distanceMatters: false)
        let minimum = ScoringRules().verdictFromGrade.worthATry

        let next = await r.nextGoodWindow(for: req, days: ["2026-11-07", "2026-11-08"], profile: rider,
                                          minimum: minimum, today: "2026-11-06")
        XCTAssertEqual(next?.day, "2026-11-08")
        // Same answer as that day's own search.
        var day = req; day.day = "2026-11-08"
        let full = try await r.search(day, profile: rider, today: "2026-11-06")
        XCTAssertEqual(next?.recommendation.finalScore, full.recommendations.first?.finalScore)
    }
}
