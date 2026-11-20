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
    }

    func testNoFanWhenModelsAgree() {
        XCTAssertNil(MapWind.modelArc([hour([90, 100]), hour([95, 110])]))
    }
}

/// WHE-243: the map draws one arrow per model when they disagree, each with its own angle.
final class MapModelArrowsTests: XCTestCase {
    /// Leucate faces ESE (102°).
    let leucate = Spot(id: "leucate", name: "Leucate", latitude: 42.9, longitude: 3.05, seaFacingDeg: 102)

    private func hour(_ t: Int, ecmwf: (Double, Double), gfs: (Double, Double)) -> HourScore {
        var w = HourlyWind(localTime: String(format: "2026-11-25T%02d:00", t), speedKn: 16, gustKn: 20, directionDeg: 157)
        w.models = ["ecmwf_ifs", "gfs_seamless"]
        w.modelSpeedsKn = [ecmwf.0, gfs.0]
        w.modelDirectionsDeg = [ecmwf.1, gfs.1]
        return HourScore(wind: w, score: 0, kite: nil, relativeAngle: 142, flags: [])
    }

    /// Leucate, 25 Nov 16–17 h: ECMWF SSE (side-onshore), GFS NW (offshore).
    func testOneArrowPerModelWithItsOwnAngle() throws {
        let arrows = try XCTUnwrap(MapWind.modelArrows([hour(16, ecmwf: (22, 149), gfs: (10, 320)),
                                                         hour(17, ecmwf: (21, 152), gfs: (15, 313))],
                                                        spot: leucate, side: nil))
        XCTAssertEqual(arrows.map(\.model), ["ecmwf_ifs", "gfs_seamless"])
        XCTAssertEqual(arrows[0].directionDeg, 150.5, accuracy: 0.5)
        XCTAssertEqual(arrows[1].speedKn, 12.5, accuracy: 1e-9)
        XCTAssertLessThan(arrows[0].relativeAngle ?? 180, 90)      // onshore side
        XCTAssertGreaterThan(arrows[1].relativeAngle ?? 0, 130)    // offshore
    }

    func testNilWhenModelsAgree() {
        XCTAssertNil(MapWind.modelArrows([hour(16, ecmwf: (22, 149), gfs: (18, 160))], spot: leucate, side: nil))
    }

    /// A model too light for a direction all window long gets no arrow; one arrow left → nil.
    func testTooLightModelIsLeftOut() {
        var h = hour(16, ecmwf: (22, 149), gfs: (5, 0))
        h.wind.modelDirectionsDeg = [149]
        XCTAssertNil(MapWind.modelArrows([h], spot: leucate, side: nil))
    }
}
