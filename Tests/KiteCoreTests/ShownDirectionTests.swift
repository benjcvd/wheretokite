import XCTest
@testable import KiteCore

/// WHE-243: the hour list draws one arrow, the direction the score used, and opens each
/// model's wind on tap.
final class ShownDirectionTests: XCTestCase {
    let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
    let berck = SpotSide(name: nil, seaFacingDeg: 292, waterSectorDeg: nil)

    /// Berck: ECMWF ESE (offshore) + GFS WNW (onshore). The hour is scored on ESE, so ESE is drawn.
    func testDisagreeingHourShowsTheScoredDirection() throws {
        let w = try XCTUnwrap(Blend.hour([
            "wind_speed_10m_a": [15], "wind_speed_10m_b": [21],
            "wind_gusts_10m_a": [19], "wind_gusts_10m_b": [25],
            "wind_direction_10m_a": [112], "wind_direction_10m_b": [292],
        ], index: 0, models: ["a", "b"], localTime: "2026-11-22T14:00"))
        let h = scorer.score(w, side: berck)
        XCTAssertEqual(h.shownDirectionDeg, 112, accuracy: 1e-6)
        XCTAssertEqual(h.wind.directionDeg, w.directionDeg)   // the blend stays in `wind`
    }

    func testAgreeingHourShowsTheBlend() {
        let w = HourlyWind(localTime: "2026-11-22T14:00", speedKn: 18, gustKn: 22, directionDeg: 292)
        let h = scorer.score(w, side: berck)
        XCTAssertNil(h.scoredDirectionDeg)
        XCTAssertEqual(h.shownDirectionDeg, 292)
    }

    /// A model under the direction threshold keeps its speed and gets no direction.
    func testModelWindsLineUpSpeedsAndDirections() throws {
        var w = HourlyWind(localTime: "2026-11-25T15:00", speedKn: 14, gustKn: 19, directionDeg: 143)
        w.models = ["ecmwf_ifs", "gfs_seamless", "meteofrance_arpege_europe"]
        w.modelSpeedsKn = [21, 5, 12]
        w.modelDirectionsDeg = [152, 30]
        let m = try XCTUnwrap(w.modelWinds)
        XCTAssertEqual(m.map(\.model), ["ecmwf_ifs", "gfs_seamless", "meteofrance_arpege_europe"])
        XCTAssertEqual(m.map(\.directionDeg), [152, nil, 30])
    }

    func testModelWindsNilWhenArraysDontLineUp() {
        var w = HourlyWind(localTime: "2026-11-25T15:00", speedKn: 14, gustKn: 19, directionDeg: 143)
        w.models = ["a", "b"]
        w.modelSpeedsKn = [21, 9]
        w.modelDirectionsDeg = [152]          // b is over the threshold but has no direction
        XCTAssertNil(w.modelWinds)
        w.modelSpeedsKn = [21]
        XCTAssertNil(w.modelWinds)
    }
}
