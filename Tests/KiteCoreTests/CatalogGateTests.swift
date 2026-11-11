import XCTest
@testable import KiteCore

final class CatalogGateTests: XCTestCase {
    /// `count` spots spread over `countries`; the first `banned` carry a summer ban.
    func catalog(_ count: Int, banned: Int = 0, countries: [String] = ["FR", "ES"]) -> SpotCatalog {
        let spots = (0..<count).map { i in
            var s = Spot(id: "s\(i)", name: "S\(i)", latitude: 41, longitude: 2, seaFacingDeg: 180)
            s.country = countries[i % countries.count]
            if i < banned { s.bans = [SpotBan(from: "07-01", to: "08-31")] }
            return s
        }
        return SpotCatalog(generatedAt: "2026-11-11", region: nil, attribution: nil, spots: spots, islands: nil)
    }

    func testSameOrBiggerCatalogueIsAccepted() {
        let ref = catalog(100, banned: 10)
        XCTAssertTrue(CatalogGate.accepts(catalog(100, banned: 10), reference: ref))
        XCTAssertTrue(CatalogGate.accepts(catalog(120, banned: 12, countries: ["FR", "ES", "IT"]), reference: ref))
    }

    func testSmallDropIsAcceptedBigDropRefused() {
        let ref = catalog(100, banned: 5)
        XCTAssertTrue(CatalogGate.accepts(catalog(90, banned: 5), reference: ref))   // spots archived
        let p = CatalogGate.problems(catalog(89, banned: 5), reference: ref)
        XCTAssertEqual(p.count, 1)
        XCTAssertTrue(p[0].contains("89 spots"), p[0])
    }

    func testLosingABannedSpotIsRefused() {
        let p = CatalogGate.problems(catalog(100, banned: 9), reference: catalog(100, banned: 10))
        XCTAssertEqual(p, ["9 spots with a kiting ban, fewer than the 10 in the reference"])
    }

    func testMergingBanRulesOfOneSpotIsFine() {
        var ref = catalog(100, banned: 1)
        ref.spots[0].bans = [SpotBan(from: "07-01", to: "07-31"), SpotBan(from: "08-01", to: "08-31")]
        XCTAssertTrue(CatalogGate.accepts(catalog(100, banned: 1), reference: ref))
    }

    func testDroppingASmallCountryIsRefused() {
        // One Czech spot out of 100: the count barely moves, the country is gone.
        let ref = catalog(100, countries: ["FR", "ES", "FR", "ES"] + Array(repeating: "FR", count: 95) + ["CZ"])
        let p = CatalogGate.problems(catalog(99), reference: ref)
        XCTAssertEqual(p, ["countries missing: CZ"])
    }

    func testTinyCatalogueRefusedEvenWithoutReference() {
        XCTAssertFalse(CatalogGate.accepts(catalog(49), reference: nil))
        XCTAssertTrue(CatalogGate.accepts(catalog(50), reference: nil))
    }

    /// The real catalogue passes against itself and fails once a country or the bans are stripped.
    func testRealCatalogue() throws {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("Data/spots.json")
        let real = try SpotCatalog.load(from: url)
        XCTAssertTrue(CatalogGate.accepts(real, reference: real))

        var noBans = real
        for i in noBans.spots.indices { noBans.spots[i].bans = nil }
        XCTAssertFalse(CatalogGate.accepts(noBans, reference: real))

        var noMorocco = real
        noMorocco.spots.removeAll { $0.country == "MA" }
        XCTAssertEqual(CatalogGate.problems(noMorocco, reference: real), ["countries missing: MA"])
    }
}
