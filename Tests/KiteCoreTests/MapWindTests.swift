import XCTest
@testable import KiteCore

/// WHE-156: the wind arrow and beach line on the spot map.
final class MapWindTests: XCTestCase {
    private func hour(_ h: Int, kn: Double, from: Double, angle: Double?, side: String? = nil) -> HourScore {
        HourScore(wind: HourlyWind(localTime: String(format: "2026-07-01T%02d:00", h), speedKn: kn,
                                   gustKn: kn + 6, directionDeg: from),
                  score: 0.8, kite: nil, relativeAngle: angle, flags: [], side: side)
    }

    func testDestinationGoesTheRightWay() {
        let bcn = Coordinate(latitude: 41.38, longitude: 2.17)
        let north = Geo.destination(bcn, bearingDeg: 0, distanceM: 1000)
        XCTAssertEqual(north.latitude - bcn.latitude, 1000 / 111_195, accuracy: 1e-5)
        XCTAssertEqual(north.longitude, bcn.longitude, accuracy: 1e-9)
        let east = Geo.destination(bcn, bearingDeg: 90, distanceM: 1000)
        XCTAssertGreaterThan(east.longitude, bcn.longitude)
        XCTAssertEqual(Geo.distanceKm(bcn, east), 1, accuracy: 0.001)
    }

    func testArrowTailIsUpwindAndTipOnTheSpot() {
        let spot = Coordinate(latitude: 41, longitude: 2)
        // Wind from the south: the tail sits south of the spot, the tip on it.
        let a = MapWind.arrow(at: spot, fromDeg: 180, lengthM: 1000)
        XCTAssertLessThan(a.shaft[0].latitude, spot.latitude)
        XCTAssertEqual(a.shaft[1], spot)
        XCTAssertEqual(a.head[1], spot)
        XCTAssertLessThan(a.head[0].latitude, spot.latitude)
        XCTAssertLessThan(a.head[2].latitude, spot.latitude)
    }

    func testShoreLineIsAcrossTheWayTheBeachFaces() {
        let spot = Coordinate(latitude: 41, longitude: 2)
        let line = MapWind.shoreLine(at: spot, seaFacingDeg: 180, halfLengthM: 500)   // south-facing beach
        XCTAssertEqual(line[0].latitude, spot.latitude, accuracy: 1e-4)                // runs east-west
        XCTAssertEqual(line[1].latitude, spot.latitude, accuracy: 1e-4)
        XCTAssertEqual(Geo.distanceKm(line[0], line[1]), 1, accuracy: 0.01)
    }

    func testSummaryAveragesDirectionAcrossNorth() {
        let s = MapWind.summary([hour(14, kn: 16, from: 350, angle: 10), hour(15, kn: 20, from: 10, angle: 30)])!
        XCTAssertEqual(s.speedKn, 18)
        XCTAssertEqual(s.gustKn, 24)
        XCTAssertEqual(Geo.angleDiff(s.directionDeg, 0), 0, accuracy: 0.01)   // not 180
        XCTAssertEqual(s.relativeAngle, 20)
        XCTAssertNil(MapWind.summary([]))
    }

    func testHighlightedHoursAreTheBestWindow() {
        let spot = Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: 165)
        let hours = (12..<18).map { hour($0, kn: Double($0), from: 200, angle: 35) }
        var rec = SpotRecommendation(spot: spot, driveMinutes: 30, driveIsEstimate: false, windScore: 60,
                                     finalScore: 60, window: (14, 16), hours: hours, reason: "")
        XCTAssertEqual(MapWind.highlightedHours(rec).map(\.wind.hour), [14, 15])
        rec.window = nil
        rec.scoredHours = (16, 18)
        XCTAssertEqual(MapWind.highlightedHours(rec).map(\.wind.hour), [16, 17])
        rec.scoredHours = nil
        XCTAssertEqual(MapWind.highlightedHours(rec).count, 6)
    }

    func testSeaFacingPicksTheScoredSideAndSkipsLakes() {
        var spot = Spot(id: "x", name: "X", latitude: 41, longitude: 2, seaFacingDeg: 165)
        XCTAssertEqual(MapWind.seaFacing(spot, side: nil), 165)
        spot.sides = [SpotSide(name: "sea", seaFacingDeg: 150), SpotSide(name: "lagoon", seaFacingDeg: 320)]
        XCTAssertEqual(MapWind.seaFacing(spot, side: "lagoon"), 320)
        XCTAssertEqual(MapWind.seaFacing(spot, side: nil), 150)
        spot.sides = nil
        spot.waterSectorDeg = 360
        XCTAssertNil(MapWind.seaFacing(spot, side: nil))
    }
}
