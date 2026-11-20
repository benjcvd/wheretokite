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

/// WHE-242: the map's fan covers every model of every hour in the window.
final class MapModelFanTests: XCTestCase {
    private func hour(_ dirs: [Double]) -> HourScore {
        var w = HourlyWind(localTime: "2026-11-20T14:00", speedKn: 15, gustKn: 20, directionDeg: dirs[0])
        w.modelDirectionsDeg = dirs
        return HourScore(wind: w, score: 1, kite: nil, relativeAngle: nil, flags: [])
    }

    func testFanSpansAllHoursAcrossNorth() throws {
        let arc = try XCTUnwrap(MapWind.modelArc([hour([330, 355]), hour([10, 20])]))
        XCTAssertEqual(arc.from, 330)
        XCTAssertEqual(arc.to, 20)
        let pts = MapWind.fan(at: Coordinate(latitude: 41, longitude: 2), arc: arc, lengthM: 1000)
        XCTAssertEqual(pts.first?.latitude, 41)
        XCTAssertGreaterThan(pts.count, 3)
    }

    func testNoFanWhenModelsAgree() {
        XCTAssertNil(MapWind.modelArc([hour([90, 100]), hour([95, 110])]))
    }
}
