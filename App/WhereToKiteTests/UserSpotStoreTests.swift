import XCTest
import KiteCore
@testable import WhereToKite

@MainActor
final class UserSpotStoreTests: XCTestCase {
    private let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("user_spots_\(UUID().uuidString).json")

    override func tearDown() {
        try? FileManager.default.removeItem(at: url)
    }

    private func spot(_ name: String, lat: Double = 41.3, lon: Double = 2.1) -> Spot {
        .userSpot(name: name, latitude: lat, longitude: lon, seaFacingDeg: 135, notes: "  shallow  ")
    }

    func testPersistenceRoundTrip() throws {
        let store = UserSpotStore(fileURL: url)
        XCTAssertTrue(store.spots.isEmpty)
        store.add(spot("Cove"))
        store.add(spot("Lagoon"))

        var edited = store.spots[0]
        edited.name = "Secret cove"
        store.update(edited)
        store.remove(id: store.spots[1].id)

        let reloaded = UserSpotStore(fileURL: url)
        XCTAssertEqual(reloaded.spots, store.spots)
        XCTAssertEqual(reloaded.spots.map(\.name), ["Secret cove"])
        XCTAssertEqual(reloaded.spots[0].seaFacingDeg, 135)
        XCTAssertEqual(reloaded.spots[0].notes, "shallow")
        XCTAssertTrue(reloaded.spots[0].isUserSpot)

        let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any]
        XCTAssertEqual(json?["version"] as? Int, 1)
    }

    func testUnreadableFileIsKeptAside() throws {
        try Data("not json".utf8).write(to: url)
        let store = UserSpotStore(fileURL: url)
        XCTAssertTrue(store.spots.isEmpty)
        let dir = url.deletingLastPathComponent()
        let stem = url.deletingPathExtension().lastPathComponent
        let backups = try FileManager.default.contentsOfDirectory(atPath: dir.path)
            .filter { $0.hasPrefix(stem + ".unreadable-") }
        XCTAssertEqual(backups.count, 1)
        for b in backups { try? FileManager.default.removeItem(at: dir.appendingPathComponent(b)) }
    }

    func testOffGlobeSpotsAreDropped() {
        let store = UserSpotStore(fileURL: url)
        store.add(spot("Ok"))
        store.add(spot("Off", lat: 123))
        XCTAssertEqual(UserSpotStore(fileURL: url).spots.map(\.name), ["Ok"])
    }

    func testAddNormalizesSourceAndID() {
        let store = UserSpotStore(fileURL: url)
        var s = spot("Beach")
        s.id = "whatever"
        s.source = "curated"
        store.add(s)
        XCTAssertTrue(store.spots[0].id.hasPrefix("user-"))
        XCTAssertEqual(store.spots[0].source, "user")
    }

    func testMergedAddsUserSpotsAndKeepsNearbyCatalogSpots() {
        var catalog = spot("Catalogue")
        catalog.id = "curated-x"
        catalog.source = "curated"
        let nearby = spot("My launch", lat: 41.3005)      // ~55 m away: kept
        var override = spot("Same id")
        override.id = "curated-x"
        XCTAssertFalse(catalog.isUserSpot)

        let merged = UserSpotStore.merged(catalog: [catalog], user: [nearby])
        XCTAssertEqual(merged.map(\.name), ["Catalogue", "My launch"])

        let replaced = UserSpotStore.merged(catalog: [catalog], user: [override])
        XCTAssertEqual(replaced.map(\.name), ["Same id"])
    }

    func testDraftValidation() {
        var d = SpotDraft()
        XCTAssertEqual(d.missing, ["location", "name", "beach direction"])
        XCTAssertNil(d.makeSpot())
        d.name = "   "
        d.coordinate = Coordinate(latitude: 41, longitude: 2)
        d.seaFacingDeg = -90
        XCTAssertEqual(d.missing, ["name"])
        d.name = " Cove "
        XCTAssertTrue(d.isValid)
        let s = d.makeSpot()
        XCTAssertEqual(s?.name, "Cove")
        XCTAssertEqual(s?.seaFacingDeg, 270)
        XCTAssertNil(s?.notes)
        XCTAssertEqual(s?.source, "user")
        XCTAssertTrue(s?.id.hasPrefix("user-") ?? false)

        // Editing keeps the id.
        let again = SpotDraft(s!).makeSpot()
        XCTAssertEqual(again?.id, s?.id)
        XCTAssertNil(again?.sides)
    }

    func testWaterSector() throws {
        var d = SpotDraft()
        d.name = "Pond"
        d.coordinate = Coordinate(latitude: 41, longitude: 2)
        d.seaFacingDeg = 90
        XCTAssertNil(d.makeSpot()?.waterSectorDeg)          // 180 is the default, not stored
        d.waterSectorDeg = 360
        d.otherSideDeg = 270                               // pointless when water is all around
        let s = try XCTUnwrap(d.makeSpot())
        XCTAssertEqual(s.waterSectorDeg, 360)
        XCTAssertNil(s.sides)
        XCTAssertEqual(s.facingSummary, "all around")
        XCTAssertEqual(SpotDraft(s).waterSectorDeg, 360)

        d.waterSectorDeg = 90
        d.otherSideDeg = nil
        XCTAssertEqual(SpotDraft(try XCTUnwrap(d.makeSpot())).waterSectorDeg, 90)
    }

    func testTwoSidedSpot() throws {
        var d = SpotDraft()
        d.name = "Sandbar"
        d.coordinate = Coordinate(latitude: 41, longitude: 2)
        d.seaFacingDeg = 270
        d.otherSideDeg = 450
        let s = try XCTUnwrap(d.makeSpot())
        XCTAssertEqual(s.sides?.map(\.seaFacingDeg), [270, 90])
        XCTAssertEqual(s.sides?.map(\.name), ["W side", "E side"])
        XCTAssertEqual(s.facingSummary, "W & E")

        // Survives a save / load and an edit.
        let data = try JSONEncoder().encode(s)
        let loaded = try JSONDecoder().decode(Spot.self, from: data)
        XCTAssertEqual(SpotDraft(loaded).otherSideDeg, 90)
        var back = SpotDraft(loaded)
        back.otherSideDeg = nil
        XCTAssertNil(back.makeSpot()?.sides)
    }

    func testSeaBearingFromSamples() {
        // Water to the south-east half-plane of a straight coast.
        var samples = [(bearing: Double, isWater: Bool)]()
        for b in stride(from: 0.0, to: 360, by: 5) {
            samples.append((b, Geo.angleDiff(b, 135) < 90))
        }
        let guess = CoastlineGuess.seaBearing(samples: samples)
        XCTAssertNotNil(guess)
        XCTAssertLessThan(Geo.angleDiff(guess!, 135), 3)

        XCTAssertNil(CoastlineGuess.seaBearing(samples: samples.map { ($0.bearing, false) }))
        XCTAssertNil(CoastlineGuess.seaBearing(samples: samples.map { ($0.bearing, true) }))
    }

    func testWaterColor() {
        XCTAssertTrue(CoastlineGuess.isWaterColor(r: 140, g: 200, b: 245))
        XCTAssertFalse(CoastlineGuess.isWaterColor(r: 245, g: 243, b: 238))   // land
        XCTAssertFalse(CoastlineGuess.isWaterColor(r: 200, g: 230, b: 190))   // park
        XCTAssertFalse(CoastlineGuess.isWaterColor(r: 250, g: 235, b: 200))   // sand
    }
}
