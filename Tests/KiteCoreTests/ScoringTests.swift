import XCTest
@testable import KiteCore

final class ScoringTests: XCTestCase {
    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    // Castelldefels-like beach facing SSE.
    let facing = 165.0

    func hour(_ kn: Double, gust: Double? = nil, from dir: Double) -> HourlyWind {
        HourlyWind(localTime: "2026-09-20T15:00", speedKn: kn, gustKn: gust ?? kn * 1.2, directionDeg: dir)
    }

    func testKiteRangesScaleWithWeight() {
        let light = KiteRange.make(size: 12, weightKg: 60)
        let heavy = KiteRange.make(size: 12, weightKg: 90)
        XCTAssertLessThan(light.optimalKn, heavy.optimalKn)
        XCTAssertEqual(KiteRange.make(size: 12, weightKg: 75).optimalKn, 13.75, accuracy: 0.01)
    }

    func testSideOnshoreBeatsOnshoreBeatsOffshore() {
        let s = Scorer(profile: rider, intensity: nil)
        let sideOn = s.score(hour(16, from: 210), seaFacingDeg: facing).score   // SSW, 45° off the beach normal
        let onshore = s.score(hour(16, from: 165), seaFacingDeg: facing).score
        let offshore = s.score(hour(16, from: 345), seaFacingDeg: facing).score
        XCTAssertGreaterThan(sideOn, onshore)
        XCTAssertGreaterThan(onshore, offshore)
        XCTAssertEqual(offshore, 0)
    }

    func testTooLightAndTooStrong() {
        let s = Scorer(profile: rider, intensity: nil)
        XCTAssertEqual(s.score(hour(7, from: 210), seaFacingDeg: facing).flags, ["too light"])
        XCTAssertEqual(s.score(hour(32, from: 210), seaFacingDeg: facing).score, 0)
    }

    func testBeginnerCappedWhereAdvancedIsFine() {
        var beginner = rider; beginner.level = .beginner
        var advanced = rider; advanced.level = .advanced
        let w = hour(22, gust: 27, from: 210)
        XCTAssertEqual(Scorer(profile: beginner, intensity: nil).score(w, seaFacingDeg: facing).score, 0)
        XCTAssertGreaterThan(Scorer(profile: advanced, intensity: nil).score(w, seaFacingDeg: facing).score, 0.5)
    }

    func testIntensityShiftsPreferredWind() {
        let chill = Scorer(profile: rider, intensity: 0)
        let intense = Scorer(profile: rider, intensity: 1)
        let light = hour(14, gust: 16, from: 210), strong = hour(25, gust: 28, from: 210)
        XCTAssertGreaterThan(chill.score(light, seaFacingDeg: facing).score, chill.score(strong, seaFacingDeg: facing).score)
        XCTAssertGreaterThan(intense.score(strong, seaFacingDeg: facing).score, intense.score(light, seaFacingDeg: facing).score)
    }

    func testGustinessPenalisedMoreForChill() {
        let gusty = hour(16, gust: 31, from: 210)   // gusts 1.94× the mean
        let chill = Scorer(profile: rider, intensity: 0).score(gusty, seaFacingDeg: facing)
        let intense = Scorer(profile: rider, intensity: 1).score(gusty, seaFacingDeg: facing)
        XCTAssertTrue(chill.flags.contains("gusty"))
        XCTAssertLessThan(chill.score, intense.score)
    }

    // WHE-73: forecast gusts are normally ~1.75× the mean; that alone isn't "gusty".
    func testTypicalForecastGustsAreNotGustyForIntermediates() {
        let garbi = hour(13, gust: 23, from: 210)   // 28 Jul Castelldefels, 1.77×
        let h = Scorer(profile: rider, intensity: nil).score(garbi, seaFacingDeg: facing)
        XCTAssertFalse(h.flags.contains("gusty"))
        XCTAssertEqual(h.steadinessFactor, 1)
        XCTAssertGreaterThan(h.score, 0.8)
    }

    func testGustsWeighLessForAdvancedAndIntense() {
        let gusty = hour(15, gust: 29, from: 210)   // 1.93×
        func steady(_ level: Level, _ i: Double?) -> Double {
            var p = rider; p.level = level
            return Scorer(profile: p, intensity: i).score(gusty, seaFacingDeg: facing).steadinessFactor ?? 0
        }
        XCTAssertLessThan(steady(.beginner, 0), steady(.intermediate, 0))
        XCTAssertLessThan(steady(.intermediate, 0), steady(.intermediate, 1))
        XCTAssertLessThan(steady(.intermediate, nil), steady(.advanced, nil))
        XCTAssertLessThanOrEqual(steady(.advanced, 0), steady(.advanced, 1))
        XCTAssertEqual(steady(.advanced, 1), 1)
    }

    func testBeginnersStayStrictOnGusts() {
        var b = rider; b.level = .beginner
        let s = Scorer(profile: b, intensity: 1)
        // Gust limit doesn't move with intensity for beginners.
        XCTAssertEqual(ScoringRules().limits(.beginner, intensity: 0).gust, ScoringRules().limits(.beginner, intensity: 1).gust)
        XCTAssertTrue(s.score(hour(15, gust: 26, from: 210), seaFacingDeg: facing).flags.contains("too strong for level"))
        // Typical 1.75× gusts still cost a chill beginner something.
        let typical = Scorer(profile: b, intensity: 0).score(hour(12, gust: 21, from: 210), seaFacingDeg: facing)
        XCTAssertTrue(typical.flags.contains("gusty"))
        XCTAssertLessThan(typical.steadinessFactor ?? 1, 0.7)
    }

    func testGustLimitSoftensWithIntensityButMeanLimitDoesNot() {
        let r = ScoringRules()
        XCTAssertEqual(r.limits(.intermediate, intensity: 0).gust, 34)
        XCTAssertGreaterThan(r.limits(.intermediate, intensity: 1).gust, r.limits(.intermediate, intensity: 0).gust)
        XCTAssertGreaterThan(r.limits(.advanced, intensity: 1).gust, r.limits(.advanced, intensity: 0).gust)
        for level in [Level.beginner, .intermediate, .advanced] {
            XCTAssertEqual(r.limits(level, intensity: 0).wind, r.limits(level, intensity: 1).wind)
        }
        // 8 Oct Ebro delta: 21 kn Mestral gusting 36 rides for an intense intermediate, not a chill one.
        let mestral = hour(21, gust: 36, from: 210)
        XCTAssertTrue(Scorer(profile: rider, intensity: 0).score(mestral, seaFacingDeg: facing).flags.contains("too strong for level"))
        XCTAssertGreaterThan(Scorer(profile: rider, intensity: 1).score(mestral, seaFacingDeg: facing).score, 0)
        // Mean wind above the level's limit stays 0 whatever the intensity.
        XCTAssertEqual(Scorer(profile: rider, intensity: 1).score(hour(29, gust: 32, from: 210), seaFacingDeg: facing).score, 0)
    }

    func testAngleDiffWrapsAround() {
        XCTAssertEqual(Geo.angleDiff(350, 10), 20)
        XCTAssertEqual(Geo.angleDiff(0, 180), 180)
    }

    func testDistancePenaltyOnlyWhenRequested() {
        let spot = Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: facing)
        let hours = (13...17).map { h in
            Scorer(profile: rider, intensity: nil).score(
                HourlyWind(localTime: "2026-09-20T\(h):00", speedKn: 16, gustKn: 19, directionDeg: 210), seaFacingDeg: facing)
        }
        let r = Recommender(spots: [], forecast: OpenMeteoProvider(), driveTime: StraightLineDriveTime(), confidence: nil)
        func req(_ matters: Bool) -> SearchRequest {
            SearchRequest(origin: spot.coordinate, maxDriveMinutes: 60, day: "2026-09-20", slot: .afternoon,
                          intensity: nil, distanceMatters: matters)
        }
        let near = r.recommend(spot, hours: hours, drive: 10, request: req(true))
        let far = r.recommend(spot, hours: hours, drive: 60, request: req(true))
        let farIgnored = r.recommend(spot, hours: hours, drive: 60, request: req(false))
        XCTAssertGreaterThan(near.finalScore, far.finalScore)
        XCTAssertEqual(farIgnored.finalScore, farIgnored.windScore)
        XCTAssertEqual(near.window?.start, 13)
        XCTAssertEqual(near.window?.end, 18)
    }
}
