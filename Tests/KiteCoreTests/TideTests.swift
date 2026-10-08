import XCTest
@testable import KiteCore

final class TideTests: XCTestCase {
    let rules = ScoringRules()

    /// A semidiurnal tide: high water ~02:00 and ~14:25, 5 m range, like the Channel.
    func day(range: Double = 5) -> [HourlyWind] {
        (0..<24).map { h in
            var w = HourlyWind(localTime: String(format: "2026-10-06T%02d:00", h), speedKn: 18, gustKn: 21,
                               directionDeg: 225)
            w.seaLevelM = range / 2 * cos((Double(h) - 2) * 2 * .pi / 12.42)
            return w
        }
    }

    func testFactorWindows() {
        XCTAssertEqual(rules.tideFactor(rule: "high", f: 1), 1)
        XCTAssertEqual(rules.tideFactor(rule: "high", f: 0.2), 0)
        XCTAssertEqual(rules.tideFactor(rule: "low", f: 0.1), 1)
        XCTAssertEqual(rules.tideFactor(rule: "low", f: 0.9), 0)
        XCTAssertEqual(rules.tideFactor(rule: "not-low", f: 0.05), 0)
        XCTAssertEqual(rules.tideFactor(rule: "not-low", f: 0.5), 1)
        XCTAssertEqual(rules.tideFactor(rule: "mid", f: 0.5), 1)
        XCTAssertEqual(rules.tideFactor(rule: "mid", f: 0.98), 0)
        XCTAssertEqual(rules.tideFactor(rule: "high", f: 0.525), 0.5, accuracy: 0.01)   // ramp
    }

    func testHoursOutsideTheWindowScoreZero() {
        let d = day()
        let scorer = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)
        let hours = d.map { scorer.score($0, seaFacingDeg: 180) }
        let tided = Recommender.applyTide("high", to: hours, day: d, rules: rules)
        // 14:00 is high water, 08:00 low water.
        XCTAssertEqual(tided[14].score, hours[14].score)
        XCTAssertEqual(tided[8].score, 0)
        XCTAssertTrue(tided[8].flags.contains("tide too low"))
        // Mediterranean: tide too small to matter, nothing changes.
        let flat = day(range: 0.2)
        XCTAssertEqual(Recommender.applyTide("high", to: hours, day: flat, rules: rules).map(\.score), hours.map(\.score))
        // No rule: nothing changes.
        XCTAssertEqual(Recommender.applyTide(nil, to: hours, day: d, rules: rules).map(\.score), hours.map(\.score))
    }

    func testSummary() {
        let s = Recommender.tideSummary(day(), rules: rules)
        XCTAssertEqual(s, "High 02:00, 14:25 · Low 08:12, 20:38")
        XCTAssertNil(Recommender.tideSummary(day(range: 0.2), rules: rules))
    }
}
