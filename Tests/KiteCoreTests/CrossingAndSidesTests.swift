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

    func testStraitOfGibraltarSplitsEuropeAndAfrica() {
        func c(_ lat: Double, _ lon: Double) -> Continent { Continent.of(Coordinate(latitude: lat, longitude: lon)) }
        XCTAssertEqual(c(36.013, -5.606), .europe)   // Tarifa
        XCTAssertEqual(c(36.140, -5.353), .europe)   // Gibraltar
        XCTAssertEqual(c(36.530, -6.290), .europe)   // Cádiz
        XCTAssertEqual(c(36.720, -4.420), .europe)   // Málaga
        XCTAssertEqual(c(39.570, 2.650), .europe)    // Palma
        XCTAssertEqual(c(38.900, 8.900), .europe)    // southern Sardinia
        XCTAssertEqual(c(36.600, 14.800), .europe)   // southern Sicily
        XCTAssertEqual(c(35.770, -5.800), .africa)   // Tangier
        XCTAssertEqual(c(35.890, -5.310), .africa)   // Ceuta
        XCTAssertEqual(c(35.290, -2.940), .africa)   // Melilla
        XCTAssertEqual(c(35.460, -6.030), .africa)   // Asilah
        XCTAssertEqual(c(31.510, -9.770), .africa)   // Essaouira
        XCTAssertEqual(c(30.420, -9.600), .africa)   // Agadir
        XCTAssertEqual(c(23.700, -15.950), .africa)  // Dakhla
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

    func testNoMoroccanSpotsFromTarifaAndBack() throws {
        let tarifa = Coordinate(latitude: 36.013, longitude: -5.606)
        let tangier = Coordinate(latitude: 35.770, longitude: -5.800)
        let spots = [try spot("es", Coordinate(latitude: 36.08, longitude: -5.70)), try spot("ma", tangier)]
        let r = Recommender(spots: spots, forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: nil)
        func ids(from o: Coordinate) -> [String] {
            r.reachable(from: o, maxDriveMinutes: 180, estimator: r.estimator, slack: 1).kept.map(\.spot.id)
        }
        XCTAssertEqual(ids(from: tarifa), ["es"])
        XCTAssertEqual(ids(from: tangier), ["ma"])
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

final class WaterSectorTests: XCTestCase {
    let s = Scorer(profile: RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate), intensity: nil)

    func wind(from dir: Double) -> HourlyWind {
        HourlyWind(localTime: "2026-09-20T15:00", speedKn: 18, gustKn: 21, directionDeg: dir)
    }

    func testStraightBeachIsUnchanged() {
        for dir in stride(from: 0.0, to: 360, by: 15) {
            XCTAssertEqual(s.score(wind(from: dir), side: SpotSide(name: nil, seaFacingDeg: 180)).score,
                           s.score(wind(from: dir), seaFacingDeg: 180).score, accuracy: 1e-9)
        }
    }

    func testSmallLakeWorksInAnyWind() {
        let lake = SpotSide(name: nil, seaFacingDeg: 0, waterSectorDeg: 360)
        let best = s.score(wind(from: 225), seaFacingDeg: 225 + 50).score   // ideal side-onshore
        for dir in stride(from: 0.0, to: 360, by: 15) {
            XCTAssertEqual(s.score(wind(from: dir), side: lake).score, best, accuracy: 0.02, "wind from \(dir)")
        }
    }

    func testCoveTurnsSideWindsOffshore() {
        let beach = SpotSide(name: nil, seaFacingDeg: 180)
        let cove = SpotSide(name: nil, seaFacingDeg: 180, waterSectorDeg: 60)
        // Wind from the SW (45° off the axis): side-onshore on a straight beach, but in a 60° cove
        // (open water ±30°) it comes over the land beside the opening: side-offshore.
        XCTAssertGreaterThan(s.score(wind(from: 225), side: beach).score, 0.8)
        XCTAssertEqual(s.score(wind(from: 225), side: cove).relativeAngle ?? 0, 105, accuracy: 0.01)
        XCTAssertEqual(s.score(wind(from: 195), side: cove).relativeAngle ?? 0, 75, accuracy: 0.01)
        XCTAssertEqual(s.score(wind(from: 270), side: cove).score, 0)   // cross-shore on a beach, offshore here
    }

    func testPointGivesMoreWindDirections() {
        let beach = SpotSide(name: nil, seaFacingDeg: 180)
        let point = SpotSide(name: nil, seaFacingDeg: 180, waterSectorDeg: 270)
        // Wind from the W: cross-shore (90°) on the beach, side-onshore on part of the point.
        XCTAssertGreaterThan(s.score(wind(from: 270), side: point).score, s.score(wind(from: 270), side: beach).score)
        // A N wind is cross-shore on the flanks of a 270° point, mostly offshore on a 240° one.
        XCTAssertGreaterThan(s.score(wind(from: 0), side: point).score, 0.5)
        let narrower = SpotSide(name: nil, seaFacingDeg: 180, waterSectorDeg: 240)
        XCTAssertLessThan(s.score(wind(from: 0), side: narrower).score, 0.2)
    }
}

