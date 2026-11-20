import XCTest
@testable import KiteCore

/// WHE-231 (Ben's option 1 on WHE-218): when the models blow more than 90° apart, the hour is
/// scored on the worse direction.
final class DirectionDisagreementTests: XCTestCase {
    let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
    /// Berck faces west-north-west: a WNW wind is onshore, an ESE wind straight offshore.
    let berck = SpotSide(name: nil, seaFacingDeg: 292, waterSectorDeg: nil)

    /// Berck, 22 Nov: ECMWF 15 kn ESE (112°) + GFS 21 kn WNW (292°). The blend reads as an
    /// onshore westerly; one model says offshore, so the hour is ruled out.
    func testBerckOppositeModelsScoreTheOffshoreOne() throws {
        let w = try XCTUnwrap(Blend.hour([
            "wind_speed_10m_a": [15], "wind_speed_10m_b": [21],
            "wind_gusts_10m_a": [19], "wind_gusts_10m_b": [25],
            "wind_direction_10m_a": [112], "wind_direction_10m_b": [292],
        ], index: 0, models: ["a", "b"], localTime: "2026-11-22T14:00"))
        XCTAssertTrue(w.modelsDisagreeOnDirection)

        // Without the rule the blended westerly would score.
        var blendOnly = w
        blendOnly.modelDirectionsDeg = nil
        XCTAssertGreaterThan(scorer.score(blendOnly, side: berck).score, 0)

        let h = scorer.score(w, side: berck)
        XCTAssertEqual(h.score, 0)
        XCTAssertTrue(h.flags.contains("offshore component"))
        XCTAssertTrue(h.flags.contains("models disagree on direction"))
        XCTAssertEqual(h.relativeAngle ?? 0, 180, accuracy: 1e-6)
        // The hour still shows the blended wind.
        XCTAssertEqual(h.wind.directionDeg, w.directionDeg)
        XCTAssertEqual(NoGoReason(problem: Recommender.mainProblem([h])), .directionUnclear)
    }

    /// Both directions kiteable: the lower score is kept, still flagged.
    func testKeepsTheLowerOfTwoKiteableDirections() {
        var w = HourlyWind(localTime: "2026-11-22T14:00", speedKn: 18, gustKn: 22, directionDeg: 292)
        w.modelDirectionsDeg = [192, 292]   // 100° apart: cross-shore and onshore
        w.models = ["a", "b"]
        XCTAssertTrue(w.modelsDisagreeOnDirection)
        var onshore = w
        onshore.modelDirectionsDeg = nil
        var cross = onshore
        cross.directionDeg = 192
        let expected = min(scorer.score(onshore, side: berck).score, scorer.score(cross, side: berck).score)
        let h = scorer.score(w, side: berck)
        XCTAssertEqual(h.score, expected, accuracy: 1e-9)
        XCTAssertTrue(h.flags.contains("models disagree on direction"))
    }

    /// Models within 90°: nothing changes.
    func testAgreeingModelsAreUntouched() {
        var w = HourlyWind(localTime: "2026-11-22T14:00", speedKn: 18, gustKn: 22, directionDeg: 292)
        w.modelDirectionsDeg = [262, 322]
        var plain = w
        plain.modelDirectionsDeg = nil
        let h = scorer.score(w, side: berck)
        XCTAssertEqual(h.score, scorer.score(plain, side: berck).score)
        XCTAssertFalse(h.flags.contains("models disagree on direction"))
    }

    /// A real offshore hour without disagreement keeps the plain "Offshore" word.
    func testNoGoWordPrefersRealOffshore() {
        let wind = HourlyWind(localTime: "2026-11-22T14:00", speedKn: 15, gustKn: 18, directionDeg: 112)
        let real = HourScore(wind: wind, score: 0, kite: nil, relativeAngle: 180, flags: ["offshore component"])
        let doubt = HourScore(wind: wind, score: 0, kite: nil, relativeAngle: 180,
                              flags: ["offshore component", "models disagree on direction"])
        XCTAssertEqual(NoGoReason(problem: Recommender.mainProblem([doubt, real])), .offshore)
        XCTAssertEqual(NoGoReason(problem: Recommender.mainProblem([doubt])), .directionUnclear)
    }
}

/// WHE-242: the spot page's per-model arrows go red by the scorer's own offshore rule.
final class ModelArrowOffshoreTests: XCTestCase {
    let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
    let berck = SpotSide(name: nil, seaFacingDeg: 292, waterSectorDeg: nil)

    func testMatchesTheScorersOffshoreFlag() {
        let cove = SpotSide(name: nil, seaFacingDeg: 180, waterSectorDeg: 120)
        let point = SpotSide(name: nil, seaFacingDeg: 90, waterSectorDeg: 270)
        for side in [berck, cove, point] {
            for dir in stride(from: 0.0, to: 360, by: 15) {
                let w = HourlyWind(localTime: "2026-11-22T14:00", speedKn: 15, gustKn: 18, directionDeg: dir)
                let flagged = scorer.score(w, side: side).flags.contains("offshore component")
                XCTAssertEqual(scorer.isOffshore(directionDeg: dir, side: side), flagged,
                               "\(dir)° on a side facing \(side.seaFacingDeg)°")
            }
        }
    }

    func testBerckModels() {
        XCTAssertTrue(scorer.isOffshore(directionDeg: 112, side: berck))    // ESE: from the land
        XCTAssertFalse(scorer.isOffshore(directionDeg: 292, side: berck))   // WNW: onshore
    }
}
