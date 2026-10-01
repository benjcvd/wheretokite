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
        let gusty = hour(16, gust: 26, from: 210)
        let chill = Scorer(profile: rider, intensity: 0).score(gusty, seaFacingDeg: facing)
        let intense = Scorer(profile: rider, intensity: 1).score(gusty, seaFacingDeg: facing)
        XCTAssertTrue(chill.flags.contains("gusty"))
        XCTAssertLessThan(chill.score, intense.score)
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
