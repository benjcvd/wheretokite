import XCTest
import KiteCore
@testable import WhereToKite

/// The spot page colours each hour by what its wind means, not by a grade (WHE-152).
final class WindFitTests: XCTestCase {
    private func hour(score: Double, flags: [String]) -> HourScore {
        let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
        var h = scorer.score(HourlyWind(localTime: "2026-08-24T15:00", speedKn: 15, gustKn: 20, directionDeg: 90),
                             relativeAngle: 30)
        h.score = score
        h.flags = flags
        return h
    }

    func testRideableAndWindLimits() {
        XCTAssertEqual(hour(score: 0.4, flags: ["gusty"]).windFit, .rideable)
        XCTAssertEqual(hour(score: 0, flags: ["too light"]).windFit, .tooLight)
        XCTAssertEqual(hour(score: 0, flags: ["too strong for level"]).windFit, .tooStrong)
        XCTAssertEqual(hour(score: 0, flags: ["too strong for quiver"]).windFit, .tooStrong)
        XCTAssertEqual(hour(score: 0, flags: ["tide too low"]).windFit, .noGo)
    }

    func testSafetyWinsOverWindStrength() {
        XCTAssertEqual(hour(score: 0, flags: ["thunderstorm risk", "too light"]).windFit, .noGo)
        XCTAssertEqual(hour(score: 0, flags: ["dark", "too strong for quiver"]).windFit, .noGo)
        XCTAssertEqual(hour(score: 0, flags: ["kiting banned"]).windFit, .noGo)
        XCTAssertEqual(hour(score: 0, flags: ["offshore component"]).windFit, .noGo)
    }
}
