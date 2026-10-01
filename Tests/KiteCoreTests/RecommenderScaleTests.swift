import XCTest
@testable import KiteCore

/// Forecast fake: wind per spot from a closure; records what was asked. No network.
final class FakeForecast: ForecastProvider, @unchecked Sendable {
    let wind: @Sendable (Spot) -> Double
    private let lock = NSLock()
    private var _requested: [String] = []
    var requested: [String] { lock.withLock { _requested } }

    init(wind: @escaping @Sendable (Spot) -> Double) { self.wind = wind }

    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        lock.withLock { _requested += spots.map(\.id) }
        return Dictionary(uniqueKeysWithValues: spots.map { spot in
            let kn = wind(spot)
            let hours = (9...17).map {
                HourlyWind(localTime: String(format: "\(day)T%02d:00", $0), speedKn: kn, gustKn: kn * 1.15, directionDeg: 210)
            }
            return (spot.id, DayForecast(day: day, hours: hours))
        })
    }
}

/// Drive-time fake standing in for Apple Maps: real minutes from a closure (nil = no route).
final class FakeRoutes: DriveTimeProvider, @unchecked Sendable {
    let minutes: @Sendable (Spot) -> Double?
    private let lock = NSLock()
    private var _calls: [[String]] = []
    var calls: [[String]] { lock.withLock { _calls } }
    var requested: [String] { calls.flatMap { $0 } }

    init(minutes: @escaping @Sendable (Spot) -> Double?) { self.minutes = minutes }

    func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        lock.withLock { _calls.append(spots.map(\.id)) }
        var out: [String: Double] = [:]
        for s in spots { if let m = minutes(s) { out[s.id] = m } }
        return out
    }
}

final class RecommenderScaleTests: XCTestCase {
    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    let origin = Coordinate(latitude: 45, longitude: 0)
    let estimator = StraightLineDriveTime()

    /// `count` spots due east of the origin, `stepKm` apart, beach facing SSE (210° wind = side-on).
    func line(_ count: Int, stepKm: Double, startKm: Double = 5) -> [Spot] {
        (0..<count).map { i in
            let km = startKm + Double(i) * stepKm
            let lon = km / (111.195 * cos(45 * Double.pi / 180))
            return Spot(id: String(format: "s%04d", i), name: "Spot \(i)", latitude: 45, longitude: lon, seaFacingDeg: 165)
        }
    }

    func request(_ maxDrive: Double, distanceMatters: Bool = false) -> SearchRequest {
        SearchRequest(origin: origin, maxDriveMinutes: maxDrive, day: "2026-10-02", slot: .fullDay,
                      intensity: nil, distanceMatters: distanceMatters)
    }

    /// Wind 10…19 kn varying by spot index, so scores differ.
    static func varied(_ s: Spot) -> Double { 10 + Double(Int(s.id.dropFirst())! * 7 % 10) }

    // MARK: Estimator

    func testEstimatorIsMonotonicAndSpeedsUpWithDistance() {
        var last = -1.0
        for km in stride(from: 0.0, through: 1500, by: 0.5) {
            let m = estimator.minutes(straightLineKm: km)
            XCTAssertGreaterThan(m, last, "not increasing at \(km) km")
            last = m
        }
        XCTAssertLessThan(estimator.averageKmh(roadKm: 10), estimator.averageKmh(roadKm: 100))
        XCTAssertLessThan(estimator.averageKmh(roadKm: 100), estimator.averageKmh(roadKm: 800))
        XCTAssertEqual(estimator.averageKmh(roadKm: 2000), 100)
    }

    func testEstimatorCalibration() {
        // Straight-line km → real road ETA (minutes) on known trips; estimate within −10 % … +15 %.
        let trips: [(km: Double, real: Double)] = [(18, 25), (240, 180), (410, 300), (660, 440), (830, 630)]
        for t in trips {
            let est = estimator.minutes(straightLineKm: t.km)
            XCTAssertGreaterThan(est, t.real * 0.9, "\(t.km) km")
            XCTAssertLessThan(est, t.real * 1.15, "\(t.km) km")
        }
    }

    func testDriveText() {
        XCTAssertEqual(Recommender.driveText(44.6), "45 min")
        XCTAssertEqual(Recommender.driveText(425), "7h05")
        XCTAssertEqual(Recommender.driveText(200, estimate: true), "~3h20")
    }

    // MARK: Reach & cap

    func testForecastCapKeepsNearestSpots() async throws {
        let spots = line(600, stepKm: 1)     // all within 10 h
        let fc = FakeForecast(wind: Self.varied)
        var r = Recommender(spots: spots, forecast: fc, driveTime: StraightLineDriveTime(), confidence: nil)
        r.maxForecastSpots = 400
        let result = try await r.search(request(600), profile: rider, today: "2026-10-01")
        XCTAssertEqual(fc.requested.count, 400)
        XCTAssertEqual(Set(fc.requested), Set(spots.prefix(400).map(\.id)))
        XCTAssertEqual(result.stats.inReach, 600)
        XCTAssertEqual(result.stats.forecastSpots, 400)
        XCTAssertEqual(result.recommendations.count, 400)
        XCTAssertEqual(result.excluded.filter { $0.1.contains("nearest") }.count, 200)
    }

    func testPreFilterIsPermissiveForSpotsARealRouteReaches() async throws {
        // Spot whose estimate is ~10 % over the max, but the real route is faster.
        let maxDrive = 300.0
        var km = 100.0
        while estimator.minutes(straightLineKm: km) < maxDrive * 1.1 { km += 1 }
        let spots = line(1, stepKm: 0, startKm: km)
        let routes = FakeRoutes { _ in maxDrive - 20 }
        let r = Recommender(spots: spots, forecast: FakeForecast { _ in 16 }, driveTime: routes, confidence: nil)
        let result = try await r.search(request(maxDrive), profile: rider, today: "2026-10-01")
        XCTAssertEqual(result.recommendations.count, 1)
        XCTAssertEqual(result.recommendations.first?.driveMinutes, maxDrive - 20)
        XCTAssertEqual(result.recommendations.first?.driveIsEstimate, false)

        // Without a real ETA (route lookup failed) it stays excluded on its estimate.
        let noRoute = Recommender(spots: spots, forecast: FakeForecast { _ in 16 }, driveTime: FakeRoutes { _ in nil },
                                  confidence: nil)
        let r2 = try await noRoute.search(request(maxDrive), profile: rider, today: "2026-10-01")
        XCTAssertTrue(r2.recommendations.isEmpty)
        XCTAssertTrue(r2.excluded.first?.1.contains("estimated") ?? false)
    }

    // MARK: Top-N ETA verification

    func testOnlyTopCandidatesGetRealETAs() async throws {
        let spots = line(400, stepKm: 2)
        let routes = FakeRoutes { [estimator] s in estimator.minutes(straightLineKm: Double(Int(s.id.dropFirst())!) * 2 + 5) * 0.95 }
        let r = Recommender(spots: spots, forecast: FakeForecast(wind: Self.varied), driveTime: routes, confidence: nil)
        let result = try await r.search(request(600), profile: rider, today: "2026-10-01")

        XCTAssertEqual(routes.calls.count, 1, "one round suffices when nothing is dropped")
        XCTAssertEqual(routes.requested.count, r.verifyTop + r.verifyMargin)
        XCTAssertLessThanOrEqual(result.stats.etaRequested, r.maxETARequests)
        XCTAssertTrue(result.recommendations.prefix(r.verifyTop).allSatisfy { !$0.driveIsEstimate })
        XCTAssertTrue(result.recommendations.dropFirst(r.verifyTop + r.verifyMargin).allSatisfy(\.driveIsEstimate))
        XCTAssertGreaterThan(result.recommendations.count, 300)
        XCTAssertTrue(result.recommendations.first!.reason.contains("·"))
        XCTAssertTrue(result.recommendations.last!.reason.contains("~"))
    }

    func testTopSpotsTooFarAreDroppedAndReplacementsVerified() async throws {
        // 20 best-scoring spots (16 kn; the others 11.5 kn) all turn out to be 11 h away by road.
        let spots = line(300, stepKm: 2)
        let best = Set(spots.enumerated().filter { $0.offset % 15 == 0 }.map(\.element.id))
        let fc = FakeForecast { s in best.contains(s.id) ? 16 : 11.5 }
        let routes = FakeRoutes { [estimator, origin] s in
            best.contains(s.id) ? 660 : estimator.minutes(from: origin, to: s) * 0.9
        }
        let r = Recommender(spots: spots, forecast: fc, driveTime: routes, confidence: nil)
        let result = try await r.search(request(600), profile: rider, today: "2026-10-01")

        // Round 1: 25 + 10 margin = 20 best + 15 others. The 20 are dropped, leaving 10 unverified
        // in the top 25 → round 2 asks exactly those.
        XCTAssertEqual(routes.calls.map(\.count), [35, 10])
        XCTAssertEqual(result.stats.etaRequested, 45)
        XCTAssertFalse(result.recommendations.contains { best.contains($0.id) })
        XCTAssertEqual(result.excluded.filter { $0.1 == "11h00 drive" }.count, 20)
        XCTAssertTrue(result.recommendations.prefix(r.verifyTop).allSatisfy { !$0.driveIsEstimate })
    }

    func testETASelection() {
        func rec(_ id: String, _ score: Int) -> SpotRecommendation {
            SpotRecommendation(spot: Spot(id: id, name: id, latitude: 0, longitude: 0), driveMinutes: 10,
                               driveIsEstimate: true, windScore: score, finalScore: score, window: nil, hours: [], reason: "")
        }
        let ranked = (0..<50).map { rec("s\($0)", 100 - $0 * 3) }   // s34+ score ≤ 0
        let first = Recommender.etaSelection(ranked: ranked, asked: [], verifyTop: 10, margin: 5, budget: 100)
        XCTAssertEqual(first, (0..<15).map { "s\($0)" })
        // Top 10 all asked → nothing more to do.
        XCTAssertEqual(Recommender.etaSelection(ranked: ranked, asked: Set(first), verifyTop: 10, margin: 5, budget: 100), [])
        // Budget caps the request.
        XCTAssertEqual(Recommender.etaSelection(ranked: ranked, asked: [], verifyTop: 10, margin: 5, budget: 4).count, 4)
        // Zero-score spots are never verified.
        let calm = (0..<5).map { rec("c\($0)", 0) }
        XCTAssertEqual(Recommender.etaSelection(ranked: calm, asked: [], verifyTop: 10, margin: 5, budget: 100), [])
    }

    // MARK: Straight-line path

    func testStraightLinePathUsesEstimatesOnly() async throws {
        let spots = line(500, stepKm: 2.5)   // 5…1250 km
        let fc = FakeForecast(wind: Self.varied)
        let r = Recommender(spots: spots, forecast: fc, driveTime: StraightLineDriveTime(), confidence: nil)
        let result = try await r.search(request(600), profile: rider, today: "2026-10-01")

        XCTAssertEqual(result.stats.etaRequested, 0)
        XCTAssertFalse(result.recommendations.isEmpty)
        XCTAssertTrue(result.recommendations.allSatisfy { $0.driveIsEstimate && $0.driveMinutes <= 600 })
        // No slack in this mode: nothing fetched beyond the max.
        XCTAssertEqual(fc.requested.count, result.recommendations.count)
        XCTAssertTrue(zip(result.recommendations, result.recommendations.dropFirst()).allSatisfy {
            Recommender.ranks($0, before: $1)
        })
    }

    func testDistanceMattersUsesRealETAAfterVerification() async throws {
        let spots = line(3, stepKm: 50, startKm: 100)
        let routes = FakeRoutes { _ in 60 }   // much faster than estimated
        let r = Recommender(spots: spots, forecast: FakeForecast { _ in 16 }, driveTime: routes, confidence: nil)
        let result = try await r.search(request(600, distanceMatters: true), profile: rider, today: "2026-10-01")
        XCTAssertEqual(result.recommendations.count, 3)
        for rec in result.recommendations {
            XCTAssertEqual(rec.driveMinutes, 60)
            XCTAssertFalse(rec.driveIsEstimate)
            XCTAssertEqual(Double(rec.finalScore), Double(rec.windScore) * (1 - r.rules.maxDistancePenalty * 0.1), accuracy: 1)
        }
    }
}
