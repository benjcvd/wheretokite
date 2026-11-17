import XCTest
@testable import KiteCore

/// WHE-151: a start point far from every spot (App Review tests from the US) is flagged as
/// outside the coverage, so the app explains instead of showing a bare empty list.
final class CoverageTests: XCTestCase {
    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    let tarifa = Spot(id: "tarifa", name: "Tarifa", latitude: 36.01, longitude: -5.60, seaFacingDeg: 180)

    func search(from origin: Coordinate, drive: Double = 60, spots: [Spot]? = nil) async throws -> SearchResult {
        let r = Recommender(spots: spots ?? [tarifa], forecast: FakeForecast { _ in 16 },
                            driveTime: StraightLineDriveTime(), confidence: nil)
        let req = SearchRequest(origin: origin, maxDriveMinutes: drive, day: "2026-10-02", slot: .fullDay,
                                intensity: nil, distanceMatters: false)
        return try await r.search(req, profile: rider, today: "2026-10-01")
    }

    func testStartInAmericaIsOutsideCoverage() async throws {
        let result = try await search(from: Coordinate(latitude: 37.33, longitude: -122.03))   // Cupertino
        XCTAssertTrue(result.recommendations.isEmpty)
        XCTAssertTrue(result.outsideCoverage)
        XCTAssertGreaterThan(result.nearestSpotKm ?? 0, 9000)
    }

    func testEmptyListInsideCoverageIsNotFlagged() async throws {
        // Seville, ~180 km from Tarifa: nothing within 30 min, but that's a drive-time problem.
        let result = try await search(from: Coordinate(latitude: 37.39, longitude: -5.98), drive: 30)
        XCTAssertTrue(result.recommendations.isEmpty)
        XCTAssertFalse(result.outsideCoverage)
    }

    func testResultsAreNeverFlagged() async throws {
        let result = try await search(from: Coordinate(latitude: 36.05, longitude: -5.65))
        XCTAssertFalse(result.recommendations.isEmpty)
        XCTAssertFalse(result.outsideCoverage)
    }

    func testEmptyCatalogueIsOutsideCoverage() async throws {
        let result = try await search(from: Coordinate(latitude: 36.05, longitude: -5.65), spots: [])
        XCTAssertNil(result.nearestSpotKm)
        XCTAssertTrue(result.outsideCoverage)
    }
}
