import XCTest
@testable import KiteCore

final class WeightsTests: XCTestCase {
    func rider(_ w: ScoreWeights?) -> RiderProfile {
        var p = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
        p.weights = w
        return p
    }

    func hour(_ kn: Double, gust: Double, from dir: Double) -> HourlyWind {
        HourlyWind(localTime: "2026-09-20T15:00", speedKn: kn, gustKn: gust, directionDeg: dir)
    }

    func testDefaultsMatchTheStandardScore() {
        let h = hour(16, gust: 24, from: 120)
        let a = Scorer(profile: rider(nil), intensity: 0.5).score(h, seaFacingDeg: 165)
        let b = Scorer(profile: rider(ScoreWeights()), intensity: 0.5).score(h, seaFacingDeg: 165)
        XCTAssertEqual(a.score, b.score)
        XCTAssertEqual(a.score, (a.strengthFactor ?? 0) * (a.steadinessFactor ?? 0) * (a.directionFactor ?? 0), accuracy: 1e-9)
    }

    func testWeightsChangeWhatCounts() {
        let gusty = hour(16, gust: 26, from: 165 + 50)
        let base = Scorer(profile: rider(nil), intensity: 0).score(gusty, seaFacingDeg: 165).score
        let ignoreGusts = Scorer(profile: rider(ScoreWeights(steadiness: 0)), intensity: 0).score(gusty, seaFacingDeg: 165).score
        let hateGusts = Scorer(profile: rider(ScoreWeights(steadiness: 2)), intensity: 0).score(gusty, seaFacingDeg: 165).score
        XCTAssertGreaterThan(ignoreGusts, base)
        XCTAssertLessThan(hateGusts, base)
    }

    func testOffshoreStaysZeroEvenWhenDirectionIsIgnored() {
        let offshore = hour(16, gust: 19, from: 345)   // beach faces 165
        XCTAssertEqual(Scorer(profile: rider(ScoreWeights(direction: 0)), intensity: nil).score(offshore, seaFacingDeg: 165).score, 0)
    }

    func testDistanceWeightScalesThePenalty() {
        let spot = Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: 165)
        let s = Scorer(profile: rider(nil), intensity: nil)
        let hours = (13...17).map { s.score(HourlyWind(localTime: "2026-09-20T\($0):00", speedKn: 16, gustKn: 19, directionDeg: 210), seaFacingDeg: 165) }
        let r = Recommender(spots: [], forecast: NoForecast(), driveTime: StraightLineDriveTime(), confidence: nil)
        let req = SearchRequest(origin: Coordinate(latitude: 41, longitude: 2), maxDriveMinutes: 60, day: "2026-09-20",
                                slot: .afternoon, intensity: nil, distanceMatters: true)
        let normal = r.recommend(spot, hours: hours, drive: 60, request: req, weights: ScoreWeights())
        let strong = r.recommend(spot, hours: hours, drive: 60, request: req, weights: ScoreWeights(distance: 2))
        let none = r.recommend(spot, hours: hours, drive: 60, request: req, weights: ScoreWeights(distance: 0))
        XCTAssertEqual(normal.distanceFactor, 0.7, accuracy: 1e-9)
        XCTAssertEqual(strong.distanceFactor, 0.4, accuracy: 1e-9)
        XCTAssertEqual(none.finalScore, none.windScore)
    }

    func testOldProfilesStillLoad() throws {
        let json = #"{"weightKg":70,"kites":[9],"level":"advanced"}"#
        let p = try JSONDecoder().decode(RiderProfile.self, from: Data(json.utf8))
        XCTAssertEqual(p.scoreWeights, ScoreWeights())
    }
}

private struct NoForecast: ForecastProvider {
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] { [:] }
}
