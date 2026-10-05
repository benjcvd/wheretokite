import XCTest
@testable import KiteCore

final class SeaCrossingTests: XCTestCase {
    let est = StraightLineDriveTime()
    let paris = Coordinate(latitude: 48.8566, longitude: 2.3522)

    func testGreatBritainOutline() {
        XCTAssertEqual(SeaCrossing.landmass(of: Coordinate(latitude: 52.95, longitude: 0.49))?.name, "Great Britain")  // Hunstanton
        XCTAssertEqual(SeaCrossing.landmass(of: Coordinate(latitude: 50.13, longitude: -5.48))?.name, "Great Britain") // Marazion
        XCTAssertNil(SeaCrossing.landmass(of: Coordinate(latitude: 50.95, longitude: 1.86)))   // Calais
        XCTAssertNil(SeaCrossing.landmass(of: Coordinate(latitude: 49.64, longitude: -1.62)))  // Cherbourg
        XCTAssertNil(SeaCrossing.landmass(of: Coordinate(latitude: 54.6, longitude: -5.93)))   // Belfast
        XCTAssertNil(SeaCrossing.landmass(of: Coordinate(latitude: 53.35, longitude: -6.26)))  // Dublin
    }

    func testChannelCrossingIsCounted() {
        // Apple Maps (2026-10): Paris → Hunstanton 7h49 via Dover–Calais; Paris → Camber 5h30.
        let hunstanton = est.minutes(from: paris, to: Coordinate(latitude: 52.95, longitude: 0.49))
        XCTAssertEqual(hunstanton, 469, accuracy: 469 * 0.15)
        let camber = est.minutes(from: paris, to: Coordinate(latitude: 50.93, longitude: 0.78))
        XCTAssertEqual(camber, 330, accuracy: 330 * 0.15)
        // Same landmass: unchanged straight-line estimate.
        let wissant = Coordinate(latitude: 50.885, longitude: 1.66)
        XCTAssertEqual(est.minutes(from: paris, to: wissant),
                       est.minutes(straightLineKm: Geo.distanceKm(paris, wissant)))
    }

    func testFromAnIslandBackToTheMainland() {
        let london = Coordinate(latitude: 51.507, longitude: -0.128)
        let wissant = Coordinate(latitude: 50.885, longitude: 1.66)
        XCTAssertGreaterThan(est.minutes(from: london, to: wissant), 180)
    }
}

final class IslandTests: XCTestCase {
    // A square "island" around (40, 3).
    let island = Island(id: "r1", name: "Square", outline: [[39.5, 2.5], [39.5, 3.5], [40.5, 3.5], [40.5, 2.5]])
    let onIsland = Coordinate(latitude: 40, longitude: 3)
    let mainland = Coordinate(latitude: 41.39, longitude: 2.17)

    func spot(_ id: String, _ c: Coordinate, access: String? = nil, island: String? = nil) throws -> Spot {
        var s = try JSONDecoder().decode(Spot.self, from: Data(#"{"id":"x","name":"X","latitude":0,"longitude":0}"#.utf8))
        s.id = id; s.latitude = c.latitude; s.longitude = c.longitude; s.access = access; s.island = island
        return s
    }

    func testFerrySpotsOnlyFromTheSameIsland() throws {
        let islandSpot = try spot("i", onIsland, access: "ferry", island: "r1")
        let mainSpot = try spot("m", mainland)
        let userIslandSpot = try spot("u", Coordinate(latitude: 40.2, longitude: 3.1))   // no access info
        let farAway = try spot("f", Coordinate(latitude: 23.7, longitude: -15.9), access: "ferry")  // no outline
        func ok(_ s: Spot, from o: Coordinate) -> Bool {
            Recommender.sameSideOfTheWater(s, originIsland: [island].first { $0.contains(o) }?.id, islands: [island])
        }
        XCTAssertFalse(ok(islandSpot, from: mainland))
        XCTAssertTrue(ok(islandSpot, from: onIsland))
        XCTAssertTrue(ok(mainSpot, from: mainland))
        XCTAssertFalse(ok(mainSpot, from: onIsland))
        XCTAssertTrue(ok(userIslandSpot, from: onIsland))
        XCTAssertFalse(ok(userIslandSpot, from: mainland))
        XCTAssertFalse(ok(farAway, from: mainland))
        XCTAssertFalse(ok(farAway, from: onIsland))
    }

    func testOutlineTolerance() {
        // 1 km outside the square's southern edge (39.5°N) still counts; 5 km doesn't.
        XCTAssertTrue(island.contains(Coordinate(latitude: 39.491, longitude: 3)))
        XCTAssertFalse(island.contains(Coordinate(latitude: 39.455, longitude: 3)))
    }
}

final class MultiSideTests: XCTestCase {
    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    // Isthmus like Prasonisi: one beach faces W, the other E.
    let sides = [SpotSide(name: "west side", seaFacingDeg: 270), SpotSide(name: "east side", seaFacingDeg: 90)]

    func wind(from dir: Double) -> HourlyWind {
        HourlyWind(localTime: "2026-09-20T15:00", speedKn: 18, gustKn: 21, directionDeg: dir)
    }

    func testEachWindUsesTheSideWhereItWorks() {
        let s = Scorer(profile: rider, intensity: nil)
        let westerly = s.score(wind(from: 240), sides: sides)
        XCTAssertEqual(westerly.side, "west side")
        XCTAssertGreaterThan(westerly.score, 0.8)
        let easterly = s.score(wind(from: 120), sides: sides)
        XCTAssertEqual(easterly.side, "east side")
        XCTAssertEqual(easterly.score, westerly.score, accuracy: 0.001)
        // A single west-facing beach would be offshore in that easterly.
        XCTAssertEqual(s.score(wind(from: 120), seaFacingDeg: 270).score, 0)
    }

    func testSingleSidedSpotsAreUnchanged() {
        let s = Scorer(profile: rider, intensity: nil)
        let one = s.score(wind(from: 200), sides: [SpotSide(name: nil, seaFacingDeg: 165)])
        XCTAssertNil(one.side)
        XCTAssertEqual(one.score, s.score(wind(from: 200), seaFacingDeg: 165).score)
    }

    func testAllSidesFallsBackToSeaFacing() throws {
        let json = #"{"id":"x","name":"X","latitude":0,"longitude":0,"seaFacingDeg":180}"#
        var spot = try JSONDecoder().decode(Spot.self, from: Data(json.utf8))
        XCTAssertEqual(spot.allSides.map(\.seaFacingDeg), [180])
        spot.sides = sides
        XCTAssertEqual(spot.allSides.count, 2)
    }
}
