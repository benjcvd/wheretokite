import XCTest
@testable import KiteCore

/// The spot page names every kite that works for the best window (display only).
final class WorkingKitesTests: XCTestCase {
    // 75 kg: 12 m ≈ 11–20 kn, 9 m ≈ 14.7–26.6 kn, 7 m ≈ 18.9–34 kn.
    let rider = RiderProfile(weightKg: 75, kites: [7, 9, 12], level: .advanced)

    func rec(_ winds: [Double], window: (Int, Int)?) -> SpotRecommendation {
        let scorer = Scorer(profile: rider, intensity: nil)
        let hours = winds.enumerated().map { i, kn in
            scorer.score(HourlyWind(localTime: String(format: "2026-09-20T%02d:00", 14 + i), speedKn: kn,
                                    gustKn: kn * 1.2, directionDeg: 210), relativeAngle: 45)
        }
        return SpotRecommendation(spot: Spot(id: "x", name: "x", latitude: 41, longitude: 2, seaFacingDeg: 165),
                                  driveMinutes: 30, driveIsEstimate: false, windScore: 80, finalScore: 80,
                                  window: window, hours: hours, reason: "")
    }

    var quiver: [KiteRange] { Scorer(profile: rider, intensity: nil).kiteRanges }

    func testBothKitesThatCoverTheWindowAreListedBestFirst() {
        let r = rec([16, 17, 25], window: (14, 16))
        let sizes = r.workingKites(in: quiver).map(\.size)
        XCTAssertEqual(sizes.first, r.suggestedKite?.size)
        XCTAssertEqual(Set(sizes), [9, 12])   // 7 m is underpowered at 16–17 kn
    }

    func testAKiteMustCoverEveryHourOfTheWindow() {
        // 12 then 19 kn: only the 12 m spans both; the 9 m misses 12 kn.
        let r = rec([12, 19], window: (14, 16))
        XCTAssertEqual(r.workingKites(in: quiver).map(\.size), [12])
    }

    func testNoWindowNoKites() {
        XCTAssertTrue(rec([5, 6], window: nil).workingKites(in: quiver).isEmpty)
    }

    func testScoringStillUsesTheBestKitePerHour() {
        let r = rec([16, 17], window: (14, 16))
        XCTAssertEqual(r.suggestedKite?.size, r.hours[0].kite?.size)
    }
}
