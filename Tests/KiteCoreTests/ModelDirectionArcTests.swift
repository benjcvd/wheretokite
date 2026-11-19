import XCTest
@testable import KiteCore

/// WHE-242: the spot page shows the models' direction range ("NE–E") only when they differ
/// meaningfully, the right way round north.
final class ModelDirectionArcTests: XCTestCase {
    private func arc(_ dirs: [Double]?) -> (from: Double, to: Double)? {
        var w = HourlyWind(localTime: "2026-11-20T14:00", speedKn: 15, gustKn: 20, directionDeg: 0)
        w.modelDirectionsDeg = dirs
        return w.modelDirectionArcDeg
    }

    func testQuietWhenModelsAgreeOrOnlyOneCounts() {
        XCTAssertNil(arc(nil))
        XCTAssertNil(arc([60]))
        XCTAssertNil(arc([40, 60, 75]))        // 35° apart
        XCTAssertNil(arc([350, 10, 20]))       // 30° across north
    }

    func testRangeGoesClockwiseFromFirstToLast() throws {
        let a = try XCTUnwrap(arc([90, 45, 70]))   // order of the models doesn't matter
        XCTAssertEqual(a.from, 45)
        XCTAssertEqual(a.to, 90)
    }

    func testRangeAcrossNorth() throws {
        let a = try XCTUnwrap(arc([330, 30, 10]))
        XCTAssertEqual(a.from, 330)
        XCTAssertEqual(a.to, 30)
        let b = try XCTUnwrap(arc([-20, 400]))     // out-of-range degrees normalised
        XCTAssertEqual(b.from, 340)
        XCTAssertEqual(b.to, 40)
    }

    func testOppositeModelsAndWideThreeWaySplit() throws {
        let a = try XCTUnwrap(arc([112, 292]))     // the WHE-231 Berck hour
        XCTAssertEqual(Geo.angleDiff(a.from, a.to), 180, accuracy: 1e-9)
        let b = try XCTUnwrap(arc([0, 120, 240]))  // arc wider than 180°
        XCTAssertEqual((b.to - b.from + 360).truncatingRemainder(dividingBy: 360), 240)
    }
}
