import XCTest
@testable import KiteCore

/// WHE-238: the spot page names why the models held a grade back, and the chart's band shows
/// the blended models' spread.
final class ModelDoubtTests: XCTestCase {
    func chance(_ best: [String: Double], min: Double = 13, outlook: WindOutlook = .uncertain) -> KiteChance {
        KiteChance(chance: 0.5, outlook: outlook, leadDays: 1, minWindKn: min, modelBestKn: best)
    }

    func testOneOfFourSeesEnoughWind() {
        let c = chance(["best_match": 9, "meteofrance_seamless": 18, "icon_seamless": 10, "ecmwf_ifs025": 11])
        XCTAssertEqual(c.doubt, .fewSeeWind(seeing: 1, total: 4))
    }

    func testNoModelSeesEnoughWind() {
        let c = chance(["a": 9, "b": 11, "c": 12], outlook: .unlikely)
        XCTAssertEqual(c.doubt, .fewSeeWind(seeing: 0, total: 3))
    }

    func testHalfCountsAsFew() {
        XCTAssertEqual(chance(["a": 9, "b": 11, "c": 15, "d": 20]).doubt, .fewSeeWind(seeing: 2, total: 4))
    }

    func testMostSeeWindButSpreadWide() {
        let c = chance(["a": 14.4, "b": 23.6, "c": 19, "d": 12])
        XCTAssertEqual(c.doubt, .disagree(lowKn: 12, highKn: 24))
    }

    func testAgreeJustAboveMinimum() {
        XCTAssertEqual(chance(["a": 13.6, "b": 15.2, "c": 14]).doubt, .justEnough(lowKn: 14, highKn: 15))
    }

    func testOneModelGivesNothing() {
        XCTAssertNil(chance(["a": 20]).doubt)
    }

    func testModelBestsHighestFirst() {
        let c = chance(["a": 9, "b": 18, "c": 12])
        XCTAssertEqual(c.modelBests.map(\.model), ["b", "c", "a"])
    }

    func rec(score: Int, before: Int?, chance c: KiteChance?) -> SpotRecommendation {
        var r = SpotRecommendation(spot: Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: 165),
                                   driveMinutes: 30, driveIsEstimate: false, windScore: score, finalScore: score,
                                   window: nil, hours: [], reason: "")
        r.scoreBeforeChance = before
        r.chance = c
        return r
    }

    func testShownOnlyWhenTheModelsCappedTheGrade() {
        let c = chance(["a": 9, "b": 18, "c": 10, "d": 11], outlook: .unlikely)
        XCTAssertEqual(rec(score: 39, before: 72, chance: c).modelDoubt, .fewSeeWind(seeing: 1, total: 4))
        XCTAssertNil(rec(score: 39, before: nil, chance: c).modelDoubt, "grade not capped")
        XCTAssertNil(rec(score: 80, before: nil, chance: chance(["a": 20, "b": 21], outlook: .likely)).modelDoubt)
    }

    /// A Go held back only because the day is too far ahead: the models agree, no "disagree" note.
    func testTooFarAheadIsNotADoubt() {
        var c = chance(["a": 20, "b": 21, "c": 22])
        c.goHeldBack = .tooFarAhead
        XCTAssertNil(rec(score: 69, before: 80, chance: c).modelDoubt)
    }

    func testBlendKeepsEachModelsSpeed() throws {
        let s: [String: [Double?]] = [
            "wind_speed_10m_a": [12], "wind_speed_10m_b": [22], "wind_speed_10m_c": [16],
            "wind_direction_10m_a": [90], "wind_direction_10m_b": [100], "wind_direction_10m_c": [95],
        ]
        let w = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b", "c"], localTime: "2026-11-19T14:00"))
        XCTAssertEqual(w.modelSpeedsKn, [12, 22, 16])
        XCTAssertEqual(w.modelSpeedRangeKn, 12...22)
        XCTAssertEqual(w.models, ["a", "b", "c"])
    }

    func testSingleModelHasNoBand() throws {
        let s: [String: [Double?]] = ["wind_speed_10m": [12], "wind_direction_10m": [90]]
        let w = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a"], localTime: "2026-11-19T14:00"))
        XCTAssertNil(w.modelSpeedsKn)
        XCTAssertNil(w.modelSpeedRangeKn)
    }

    func testImplausibleCachedSpeedsAreIgnored() {
        var w = HourlyWind(localTime: "2026-11-19T14:00", speedKn: 12, gustKn: 15, directionDeg: 90)
        w.modelSpeedsKn = [12, .infinity, 999]
        XCTAssertNil(w.modelSpeedRangeKn)
        w.modelSpeedsKn = [12, -3, 18]
        XCTAssertEqual(w.modelSpeedRangeKn, 12...18)
    }
}
