import XCTest
@testable import KiteCore

/// Confidence fake: the models' speed spread per spot from a closure; records each call.
final class FakeConfidence: ConfidenceProvider, @unchecked Sendable {
    let spread: @Sendable (Coordinate) -> Double
    var fails = false
    private let lock = NSLock()
    private var _calls: [[ConfidenceQuery]] = []
    var calls: [[ConfidenceQuery]] { lock.withLock { _calls } }

    init(spread: @escaping @Sendable (Coordinate) -> Double) { self.spread = spread }

    func estimates(for queries: [ConfidenceQuery], day: String, today: String) async throws -> [ForecastConfidence] {
        lock.withLock { _calls.append(queries) }
        if fails { throw ForecastError.badResponse("down") }
        return queries.map {
            ForecastConfidence(score: 0, rating: .medium, leadDays: 1, speedSpreadKn: spread($0.coordinate),
                               directionSpreadDeg: nil, modelsCompared: ["a", "b"])
        }
    }
}

/// Answers every request with a canned body and keeps the last request.
final class StubProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var body = Data()
    nonisolated(unsafe) static var lastBody: String?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let stream = request.httpBodyStream {
            stream.open()
            var data = Data(), buf = [UInt8](repeating: 0, count: 4096)
            while stream.hasBytesAvailable { let n = stream.read(&buf, maxLength: buf.count); if n <= 0 { break }; data.append(buf, count: n) }
            Self.lastBody = String(decoding: data, as: UTF8.self)
        }
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
                            cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.body)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

final class ConfidenceTests: XCTestCase {
    let models = ["m1", "m2"]

    func hourly(_ a: Double, _ b: Double, dirA: Double = 200, dirB: Double = 200) -> [String: [Double?]] {
        ["wind_speed_10m_m1": Array(repeating: a, count: 24), "wind_speed_10m_m2": Array(repeating: b, count: 24),
         "wind_direction_10m_m1": Array(repeating: dirA, count: 24), "wind_direction_10m_m2": Array(repeating: dirB, count: 24)]
    }

    func testAgreeingModelsGiveHighConfidence() {
        let c = ConfidenceEstimator.confidence(hourly: hourly(15, 16), models: models, hours: 14...17, leadDays: 1)
        XCTAssertEqual(c.rating, .high)
        XCTAssertEqual(c.speedSpreadKn, 0.5, accuracy: 0.01)
        XCTAssertEqual(c.modelsCompared, models)
    }

    func testDisagreeingModelsGiveLowConfidence() {
        // 8 vs 20 kn: ±6 kn, and 90° apart.
        let c = ConfidenceEstimator.confidence(hourly: hourly(8, 20, dirA: 180, dirB: 270), models: models,
                                               hours: 14...17, leadDays: 1)
        XCTAssertEqual(c.rating, .low)
        XCTAssertEqual(c.speedSpreadKn, 6, accuracy: 0.01)
    }

    func testOnlyOneModelMeansNothingCompared() {
        var h = hourly(15, 15)
        h["wind_speed_10m_m2"] = Array(repeating: nil, count: 24)
        let c = ConfidenceEstimator.confidence(hourly: h, models: models, hours: 14...17, leadDays: 1)
        XCTAssertTrue(c.modelsCompared.isEmpty)
    }

    func testAgreementFactor() {
        let r = ScoringRules()
        XCTAssertEqual(r.agreementFactor(speedSpreadKn: 1.5, directionSpreadDeg: 20), 1)
        XCTAssertEqual(r.agreementFactor(speedSpreadKn: 4, directionSpreadDeg: nil), 0.925, accuracy: 1e-9)
        XCTAssertEqual(r.agreementFactor(speedSpreadKn: 9, directionSpreadDeg: nil), 0.85, accuracy: 1e-9)
        XCTAssertEqual(r.agreementFactor(speedSpreadKn: 1, directionSpreadDeg: 90), 0.85, accuracy: 1e-9)
    }

    /// Several spots in one POST; Open-Meteo answers an array, one entry per spot in order.
    func testEstimatesSendsOneRequestForAllSpots() async throws {
        func entry(_ a: Double, _ b: Double) -> String {
            let h = hourly(a, b)
            let fields = h.keys.sorted().map { k in "\"\(k)\":[" + h[k]!.map { "\($0!)" }.joined(separator: ",") + "]" }
            return "{\"hourly\":{\"time\":[\"x\"]," + fields.joined(separator: ",") + "}}"
        }
        StubProtocol.body = Data("[\(entry(15, 15)),\(entry(8, 20))]".utf8)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubProtocol.self]
        var e = ConfidenceEstimator()
        e.models = models
        e.session = URLSession(configuration: config)
        let queries = [ConfidenceQuery(coordinate: Coordinate(latitude: 42.1, longitude: 3.1), hours: 14...15),
                       ConfidenceQuery(coordinate: Coordinate(latitude: 42.9, longitude: 3.0), hours: 16...17)]
        let out = try await e.estimates(for: queries, day: "2099-01-01", today: "2098-12-31")
        XCTAssertEqual(out.map(\.rating), [.high, .medium])   // ±6 kn, same direction
        XCTAssertEqual(StubProtocol.lastBody?.contains("latitude=42.1000,42.9000"), true)
        XCTAssertEqual(StubProtocol.lastBody?.contains("models=m1,m2"), true)
    }

    // MARK: In the search

    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    let request = SearchRequest(origin: Coordinate(latitude: 45, longitude: 0), maxDriveMinutes: 600, day: "2026-10-02",
                                slot: .fullDay, intensity: nil, distanceMatters: false)

    /// 100 spots due east, same wind everywhere except index-based variety.
    func spots(_ n: Int) -> [Spot] {
        (0..<n).map { i in
            Spot(id: String(format: "s%04d", i), name: "Spot \(i)", latitude: 45,
                 longitude: Double(i + 1) * 0.02, seaFacingDeg: 165)
        }
    }

    func testTopSpotsCheckedInOneRequestAtRealSize() async throws {
        let conf = FakeConfidence { _ in 1 }
        let r = Recommender(spots: spots(100), forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: conf)
        let result = try await r.search(request, profile: rider, today: "2026-10-01")
        XCTAssertEqual(conf.calls.count, 1)
        XCTAssertEqual(conf.calls[0].count, r.confidenceTop)
        XCTAssertEqual(Set(conf.calls[0].map(\.coordinate.longitude)),
                       Set(result.recommendations.prefix(r.confidenceTop).map(\.spot.longitude)))
        XCTAssertNotNil(result.confidence)
        XCTAssertNil(result.recommendations[r.confidenceTop].confidence)
        XCTAssertEqual(result.recommendations[0].agreementFactor, 1)
    }

    func testSpotWhereModelsDisagreeDropsBelowAnEqualOne() async throws {
        let all = spots(2)
        let shaky = all[0].longitude
        let conf = FakeConfidence { $0.longitude == shaky ? 6 : 1 }
        let r = Recommender(spots: all, forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: conf)
        let result = try await r.search(request, profile: rider, today: "2026-10-01")
        XCTAssertEqual(result.recommendations.map(\.spot.id), ["s0001", "s0000"])
        let last = result.recommendations[1]
        XCTAssertEqual(last.agreementFactor, 0.85, accuracy: 1e-9)
        XCTAssertEqual(last.finalScore, Int((Double(result.recommendations[0].finalScore) * 0.85).rounded()))
    }

    func testFailedCheckChangesNothing() async throws {
        let conf = FakeConfidence { _ in 6 }
        conf.fails = true
        let withCheck = Recommender(spots: spots(20), forecast: FakeForecast { RecommenderScaleTests.varied($0) },
                                    driveTime: StraightLineDriveTime(), confidence: conf)
        let without = Recommender(spots: spots(20), forecast: FakeForecast { RecommenderScaleTests.varied($0) },
                                  driveTime: StraightLineDriveTime(), confidence: nil)
        let a = try await withCheck.search(request, profile: rider, today: "2026-10-01")
        let b = try await without.search(request, profile: rider, today: "2026-10-01")
        XCTAssertEqual(a.recommendations.map(\.id), b.recommendations.map(\.id))
        XCTAssertEqual(a.recommendations.map(\.finalScore), b.recommendations.map(\.finalScore))
        XCTAssertNil(a.confidence)
    }
}
