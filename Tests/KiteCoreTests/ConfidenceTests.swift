import XCTest
@testable import KiteCore

/// Confidence fake: the models' speed spread per spot from a closure; records each call.
final class FakeConfidence: ConfidenceProvider, @unchecked Sendable {
    let spread: @Sendable (Coordinate) -> Double
    /// Each model's wind (kn) all day at a spot, from the south (onshore for the test spots).
    var modelSpeeds: @Sendable (Coordinate) -> [Double] = { _ in [16, 16, 16, 16] }
    var fails = false
    var leadDays = 1
    private let lock = NSLock()
    private var _calls: [[ConfidenceQuery]] = []
    var calls: [[ConfidenceQuery]] { lock.withLock { _calls } }

    init(spread: @escaping @Sendable (Coordinate) -> Double) { self.spread = spread }

    func estimates(for queries: [ConfidenceQuery], day: String, today: String) async throws -> [ForecastConfidence] {
        lock.withLock { _calls.append(queries) }
        if fails { throw ForecastError.badResponse("down") }
        return queries.map { q in
            let speeds = modelSpeeds(q.coordinate)
            let hours = Dictionary(uniqueKeysWithValues: speeds.enumerated().map { i, kn in
                ("m\(i)", (0..<24).map { ModelWind(hour: $0, speedKn: kn, directionDeg: 170) })
            })
            return ForecastConfidence(score: 0, rating: .medium, leadDays: leadDays, speedSpreadKn: spread(q.coordinate),
                                      directionSpreadDeg: nil, modelsCompared: ["a", "b"], modelHours: hours)
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

    func testModelHoursKeepEachModelsDay() {
        var h = hourly(15, 16)
        h["wind_speed_10m_m2"]![3] = nil
        let c = ConfidenceEstimator.confidence(hourly: h, models: models, hours: 14...17, leadDays: 1)
        XCTAssertEqual(c.modelHours["m1"]?.count, 24)
        XCTAssertEqual(c.modelHours["m2"]?.count, 23)
        XCTAssertEqual(c.modelHours["m1"]?[10], ModelWind(hour: 10, speedKn: 15, directionDeg: 200))
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
        XCTAssertEqual(result.recommendations[0].kiteVerdict, .go)
    }

    func testNoSpotIsCappedBelowAGoAndRanksUnder() async throws {
        let all = spots(2)
        let calm = all[0].longitude
        let conf = FakeConfidence { _ in 1 }
        // The scoring blend says 16 kn at both; at s0000 the four models say 6–9 kn.
        conf.modelSpeeds = { $0.longitude == calm ? [6, 7, 8, 9] : [16, 17, 15, 16] }
        let r = Recommender(spots: all, forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: conf)
        let result = try await r.search(request, profile: rider, today: "2026-10-01")
        XCTAssertEqual(result.recommendations.map(\.spot.id), ["s0001", "s0000"])
        let go = result.recommendations[0], no = result.recommendations[1]
        XCTAssertEqual(go.kiteVerdict, .go)
        XCTAssertNil(go.scoreBeforeChance)
        XCTAssertEqual(no.chance?.outlook, .unlikely)
        XCTAssertEqual(no.kiteVerdict, .longShot)   // unlikely wind: a long shot at best (39)
        XCTAssertEqual(no.finalScore, r.rules.unlikelyWindMaxScore)
        XCTAssertEqual(no.scoreBeforeChance, go.finalScore)
    }

    /// The label reads off the final grade (Ben, 2 Nov): four bands.
    func testVerdictBandsOnTheGrade() {
        XCTAssertEqual([100, 70, 69, 50, 49, 20, 19, 0].map { KiteVerdict(grade: $0) },
                       [.go, .go, .worthATry, .worthATry, .longShot, .longShot, .noGo, .noGo])
    }

    /// A "No go" names the safety rule behind it; a plain lack of wind doesn't.
    func testNoGoNamesTheSafetyReason() {
        func rec(_ flags: [String], score: Int = 0) -> SpotRecommendation {
            let w = HourlyWind(localTime: "2026-10-02T14:00", speedKn: 16, gustKn: 18, directionDeg: 170)
            var r = SpotRecommendation(spot: Spot(id: "x", name: "x", latitude: 45, longitude: 1, seaFacingDeg: 165),
                                       driveMinutes: 30, driveIsEstimate: true, windScore: score, finalScore: score,
                                       window: nil, hours: [HourScore(wind: w, score: 0, kite: nil, relativeAngle: nil, flags: flags)],
                                       reason: "")
            r.scoredHours = (14, 15)
            return r
        }
        XCTAssertEqual(rec(["thunderstorm risk"]).safetyReason, "thunderstorm risk")
        XCTAssertEqual(rec(["kiting banned"]).safetyReason, "kiting banned")
        XCTAssertEqual(rec(["dark"]).safetyReason, "dark")
        XCTAssertEqual(rec(["offshore component"]).safetyReason, "offshore")
        XCTAssertNil(rec(["too light"]).safetyReason)
        XCTAssertNil(rec(["thunderstorm risk"], score: 30).safetyReason)   // not a No go
    }

    /// Uncertain wind holds a 100 at 69 ("Worth a try") and it ranks under a 75 with likely
    /// wind; a Go needs good conditions too: likely wind with a grade in the 60s isn't a Go.
    func testUncertainWindIsAMaybeAndRanksOnTheGrade() async throws {
        let all = spots(3)
        let shaky = all[1].longitude, light = all[2].longitude
        let conf = FakeConfidence { _ in 1 }
        conf.modelSpeeds = { $0.longitude == shaky ? [10, 11, 12, 13] : [18, 18, 18, 18] }
        // s0000 12 kn: good, s0001 16 kn: best in the blend, s0002 11.1 kn: barely powered.
        let r = Recommender(spots: all, forecast: FakeForecast { $0.longitude == shaky ? 16 : $0.longitude == light ? 11.1 : 12 },
                            driveTime: StraightLineDriveTime(), confidence: conf)
        let recs = try await r.search(request, profile: rider, today: "2026-10-01").recommendations
        let byID = Dictionary(uniqueKeysWithValues: recs.map { ($0.id, $0) })
        XCTAssertEqual(byID["s0001"]?.chance?.outlook, .uncertain)
        XCTAssertEqual(byID["s0001"]?.finalScore, r.rules.uncertainWindMaxScore)
        XCTAssertEqual(byID["s0001"]?.kiteVerdict, .worthATry)
        XCTAssertEqual(byID["s0002"]?.chance?.outlook, .likely)
        XCTAssertNotEqual(byID["s0002"]?.kiteVerdict, .go)
        XCTAssertEqual(recs.first?.id, "s0000")
        XCTAssertEqual(recs.first?.kiteVerdict, .go)
        // Ranked on the grade, so every Go comes first.
        XCTAssertEqual(recs.map(\.finalScore), recs.map(\.finalScore).sorted(by: >))
    }

    /// A spot pushed up into the top by the caps gets its own check in the next round.
    func testPromotedSpotsAreCheckedToo() async throws {
        let conf = FakeConfidence { _ in 1 }
        conf.modelSpeeds = { _ in [5, 5, 6, 6] }   // every spot: No
        let r = Recommender(spots: spots(40), forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: conf)
        let result = try await r.search(request, profile: rider, today: "2026-10-01")
        XCTAssertEqual(conf.calls.count, r.chanceRounds)
        XCTAssertEqual(result.recommendations.filter { $0.chance != nil }.count, r.confidenceTop * r.chanceRounds)
        // Unchecked spots keep their grade and sit on top: 3 rounds of 10 can't cover 40 spots.
        XCTAssertNil(result.recommendations[0].chance)
    }

    func testChanceFollowsTheMarginAboveMinWind() {
        let scorer = Scorer(profile: rider, intensity: nil)
        let side = [SpotSide(name: nil, seaFacingDeg: 165, waterSectorDeg: nil)]
        func chance(_ speeds: [Double], dir: Double = 170, lead: Int = 1) -> KiteChance? {
            let m = Dictionary(uniqueKeysWithValues: speeds.enumerated().map { i, kn in
                ("m\(i)", (10..<18).map { ModelWind(hour: $0, speedKn: kn, directionDeg: dir) })
            })
            return scorer.kiteChance(models: m, sides: side, hours: Set(10..<18), leadDays: lead)
        }
        let minWind = scorer.kiteRanges.map(\.minKn).min()!    // 11 kn for 75 kg on a 12
        XCTAssertEqual(chance([18, 18, 18, 18])?.outlook, .likely)
        XCTAssertEqual(chance([minWind, minWind, minWind, minWind])?.outlook, .uncertain)   // just under 50 %
        XCTAssertEqual(chance([8, 8, 8, 8])?.outlook, .unlikely)
        // Same mean, models far apart: less sure.
        XCTAssertLessThan(chance([8, 22, 10, 20])!.chance, chance([15, 15, 15, 15])!.chance)
        // Offshore wind is no wind for the rider.
        XCTAssertEqual(chance([20, 20, 20, 20], dir: 345)?.outlook, .unlikely)
        // One model only: nothing to go on.
        XCTAssertNil(chance([18]))
        // Further out, the same forecast is less sure.
        XCTAssertGreaterThan(chance([14, 14, 14, 14], lead: 0)!.chance, chance([14, 14, 14, 14], lead: 4)!.chance)
    }

    /// Ben's pick on WHE-81: Go today to +3 only, the same in every region.
    func testGoHeldBackBeyondDay3() {
        let scorer = Scorer(profile: rider, intensity: nil)
        let side = [SpotSide(name: nil, seaFacingDeg: 165, waterSectorDeg: nil)]
        let m = Dictionary(uniqueKeysWithValues: (0..<4).map { i in
            ("m\(i)", (10..<18).map { ModelWind(hour: $0, speedKn: 22, directionDeg: 170) })
        })
        func chance(lead: Int) -> KiteChance? {
            scorer.kiteChance(models: m, sides: side, hours: Set(10..<18), leadDays: lead)
        }
        for lead in 0...3 {
            XCTAssertEqual(chance(lead: lead)?.outlook, .likely, "day \(lead)")
            XCTAssertNil(chance(lead: lead)?.goHeldBack)
        }
        for lead in 4...6 {
            XCTAssertEqual(chance(lead: lead)?.outlook, .uncertain, "day \(lead)")
            XCTAssertEqual(chance(lead: lead)?.goHeldBack, .tooFarAhead)
            XCTAssertGreaterThan(chance(lead: lead)!.chance, 0.9)   // the number itself is kept
        }
        // Only a Go is held back: weak wind stays unlikely, with no reason attached.
        let light = m.mapValues { $0.map { ModelWind(hour: $0.hour, speedKn: 7, directionDeg: 170) } }
        let weak = scorer.kiteChance(models: light, sides: side, hours: Set(10..<18), leadDays: 5)
        XCTAssertEqual(weak?.outlook, .unlikely)
        XCTAssertNil(weak?.goHeldBack)
    }

    /// In a search: same rule in Catalonia as elsewhere; at +4 a Go is Worth a try at best.
    func testHeldBackGoIsWorthATryInTheList() async throws {
        var all = spots(2)
        all[0].region = "Catalunya"
        all[1].region = "Occitanie"
        let conf = FakeConfidence { _ in 1 }
        conf.modelSpeeds = { _ in [18, 18, 18, 18] }
        let r = Recommender(spots: all, forecast: FakeForecast { _ in 16 }, driveTime: StraightLineDriveTime(),
                            confidence: conf)
        var recs = try await r.search(request, profile: rider, today: "2026-10-01").recommendations
        XCTAssertEqual(recs.map(\.kiteVerdict), [.go, .go])
        XCTAssertEqual(recs.compactMap(\.chance?.goHeldBack), [])

        conf.leadDays = 4
        recs = try await r.search(request, profile: rider, today: "2026-10-01").recommendations
        XCTAssertEqual(recs.map(\.kiteVerdict), [.worthATry, .worthATry])
        XCTAssertEqual(recs.compactMap(\.chance?.goHeldBack), [.tooFarAhead, .tooFarAhead])
        XCTAssertEqual(recs.map(\.finalScore), [r.rules.uncertainWindMaxScore, r.rules.uncertainWindMaxScore])
    }

    func testPhi() {
        XCTAssertEqual(Scorer.phi(0), 0.5, accuracy: 1e-9)
        XCTAssertEqual(Scorer.phi(1.96), 0.975, accuracy: 1e-3)
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
