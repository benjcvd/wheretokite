import XCTest
@testable import KiteCore

/// WHE-75: side-shore at most for beginners and intermediates, a little side-offshore (up to
/// 120°) for advanced riders, pure offshore 0 for everyone.
final class OffshoreToleranceTests: XCTestCase {
    let facing = 180.0   // beach facing south: a wind from 180 is onshore, from 90/270 side-shore

    func rider(_ level: Level) -> RiderProfile {
        RiderProfile(weightKg: 75, kites: [9, 12], level: level)
    }

    /// Wind whose angle to the beach normal is `angle` (0 onshore … 180 offshore).
    func hour(angle: Double, kn: Double = 16) -> HourlyWind {
        HourlyWind(localTime: "2026-07-02T15:00", speedKn: kn, gustKn: kn * 1.2, directionDeg: facing + angle)
    }

    func score(_ p: RiderProfile, _ angle: Double) -> HourScore {
        Scorer(profile: p, intensity: nil).score(hour(angle: angle), seaFacingDeg: facing)
    }

    func testToleranceFollowsLevel() {
        XCTAssertEqual(rider(.beginner).offshoreTolerance, .sideShoreOnly)
        XCTAssertEqual(rider(.intermediate).offshoreTolerance, .sideShoreOnly)
        XCTAssertEqual(rider(.advanced).offshoreTolerance, .sideOffshore)
    }

    func testProfilesSavedWithTheOldChoiceStillLoadAndIgnoreIt() throws {
        let json = #"{"weightKg":75,"kites":[9,12],"level":"intermediate","offshore":"sideOffshore"}"#
        let p = try JSONDecoder().decode(RiderProfile.self, from: Data(json.utf8))
        XCTAssertEqual(p.offshoreTolerance, .sideShoreOnly)
    }

    func testSideShoreOnlyStopsAt100Degrees() {
        for level in [Level.beginner, .intermediate] {
            let p = rider(level)
            XCTAssertGreaterThan(score(p, 90).score, 0, "\(level) side-shore")
            XCTAssertGreaterThan(score(p, 95).score, 0, "\(level) 95°")
            XCTAssertEqual(score(p, 100).score, 0, "\(level) 100°")
            XCTAssertEqual(score(p, 110).score, 0, "\(level) 110°")
            XCTAssertTrue(score(p, 110).flags.contains("offshore component"))
            XCTAssertFalse(score(p, 95).flags.contains("side-offshore"))
        }
    }

    func testAdvancedSideOffshoreScoresUntil120AndIsFlagged() {
        let p = rider(.advanced)
        let h = score(p, 110)
        XCTAssertGreaterThan(h.score, 0, "110°")
        XCTAssertTrue(h.flags.contains("side-offshore"))
        XCTAssertFalse(h.flags.contains("offshore component"))
        XCTAssertLessThan(h.score, score(p, 90).score, "side-offshore never beats side-shore")
        XCTAssertEqual(score(p, 120).score, 0, "120°")
        XCTAssertEqual(score(p, 125).score, 0, "125°")
        XCTAssertTrue(score(p, 120).flags.contains("offshore component"))
    }

    func testPureOffshoreIsZeroForEveryone() {
        for level in Level.allCases {
            for angle in stride(from: 120.0, through: 180, by: 10) {
                XCTAssertEqual(score(rider(level), angle).score, 0, "\(level) \(angle)°")
            }
        }
    }

    func testLagoonSectorStillAllowsWindsOffTheLand() {
        // A lagoon open almost all around (Leucate's étang): a wind that is offshore on the
        // seaward beach is fine here, whatever the setting.
        let lagoon = SpotSide(name: nil, seaFacingDeg: facing, waterSectorDeg: 330)
        let p = rider(.intermediate)
        let h = Scorer(profile: p, intensity: nil).score(hour(angle: 180), side: lagoon)
        XCTAssertGreaterThan(h.score, 0)
        XCTAssertFalse(h.flags.contains("side-offshore"))
    }

    func testRecommendationShowsSideOffshoreOnlyForScoringHours() {
        let spot = try! JSONDecoder().decode(Spot.self, from: Data(
            #"{"id":"x","name":"X","latitude":41,"longitude":2,"seaFacingDeg":180}"#.utf8))
        let scorer = Scorer(profile: rider(.advanced), intensity: nil)
        func rec(_ angles: [Double]) -> SpotRecommendation {
            let hours = angles.enumerated().map { i, a in
                scorer.score(HourlyWind(localTime: String(format: "2026-07-02T%02d:00", 14 + i), speedKn: 16,
                                        gustKn: 19, directionDeg: facing + a), seaFacingDeg: facing)
            }
            return SpotRecommendation(spot: spot, driveMinutes: 30, driveIsEstimate: false, windScore: 50,
                                      finalScore: 50, window: (14, 14 + angles.count), hours: hours, reason: "")
        }
        XCTAssertTrue(rec([60, 110]).hasSideOffshore)
        XCTAssertFalse(rec([60, 80]).hasSideOffshore)
        XCTAssertFalse(rec([60, 150]).hasSideOffshore)   // offshore hour scores 0: no side-offshore claim
    }
}
