import XCTest
@testable import WhereToKite

/// Free vs Pro limits (Plan.swift).
final class PlanTests: XCTestCase {
    /// 16 Nov 2026 (Ben): every active catalogue spot is free, secondary ("pro" tier) ones too.
    func testFreePlanSeesEverySpot() {
        XCTAssertTrue(Entitlements.free.proSpots)
        XCTAssertTrue(Entitlements.pro.proSpots)
    }

    /// The other free limits are unchanged by that decision.
    func testFreeLimitsUnchanged() {
        XCTAssertEqual(Entitlements.free.maxResults, 5)
        XCTAssertEqual(Entitlements.free.maxDriveMinutes, 180)
        XCTAssertEqual(Entitlements.free.forecastDays, 4)
    }
}
