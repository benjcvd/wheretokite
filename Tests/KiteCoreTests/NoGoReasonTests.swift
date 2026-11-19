import XCTest
@testable import KiteCore

/// The one word on each not-kiteable row (WHE-219).
final class NoGoReasonTests: XCTestCase {
    func h(_ hour: Int, _ flags: [String]) -> HourScore {
        HourScore(wind: HourlyWind(localTime: String(format: "2026-11-11T%02d:00", hour), speedKn: 8, gustKn: 9, directionDeg: 180),
                  score: 0, kite: nil, relativeAngle: 0, flags: flags)
    }

    func reason(_ hours: [[String]]) -> NoGoReason {
        NoGoReason(problem: Recommender.mainProblem(hours.enumerated().map { h(12 + $0.offset, $0.element) }))
    }

    func testSafetyBeatsWind() {
        XCTAssertEqual(reason([["too light"], ["thunderstorm risk"]]), .storm)
        XCTAssertEqual(reason([["too light"], ["kiting banned"]]), .banned)
        XCTAssertEqual(reason([["too light"], ["offshore component"]]), .offshore)
        XCTAssertEqual(reason([["dark"], ["too late"]]), .dark)
        XCTAssertEqual(reason([["too late"], ["too late"]]), .tooLate)
    }

    func testWindAndTide() {
        XCTAssertEqual(reason([["too light"], ["dark"]]), .tooLight)
        XCTAssertEqual(reason([["gusty", "too strong for level"]]), .tooStrong)
        XCTAssertEqual(reason([["too strong for quiver"], ["gusty"]]), .tooStrong)
        XCTAssertEqual(reason([["tide too low"]]), .tide)
        XCTAssertEqual(reason([[]]), .poor)
    }

    /// Same hours, same word: the fallback no longer depends on Set order.
    func testFallbackIsStable() {
        let first = reason([["gusty", "rain"]])
        for _ in 0..<20 { XCTAssertEqual(reason([["gusty", "rain"]]), first) }
    }

    func testSafetyFlag() {
        XCTAssertEqual(NoGoReason.allCases.filter(\.isSafety), [.storm, .banned, .offshore, .directionUnclear, .dark])
    }

    func testRecommendationWithoutHours() {
        let spot = Spot(id: "s", name: "S", latitude: 41, longitude: 2, seaFacingDeg: 180)
        let rec = SpotRecommendation(spot: spot, driveMinutes: 30, driveIsEstimate: true, windScore: 0, finalScore: 0,
                                     window: nil, hours: [], reason: "")
        XCTAssertEqual(rec.noGoReason, .noForecast)
    }
}
