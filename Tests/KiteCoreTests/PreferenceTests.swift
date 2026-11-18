import XCTest
@testable import KiteCore

/// Flat / wavy water and good-weather-only choices (WHE-221).
final class PreferenceTests: XCTestCase {
    let rules = ScoringRules()

    func testGoodWeatherReadsTheMiddleModelButStormsStayOnTheGloomiest() {
        var w = hour(code: 3)          // gloomiest model: overcast
        w.skyCode = 1                  // middle model: some cloud
        XCTAssertEqual(rules.weatherFactor(.fair, hour: w), 1)
        w.weatherCode = 95; w.skyCode = 2   // one model forecasts a storm
        XCTAssertTrue(w.stormRisk)
    }
    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)

    func hour(_ h: Int = 14, waves: Double? = nil, code: Int? = nil, rain: Double? = nil) -> HourlyWind {
        var w = HourlyWind(localTime: String(format: "2026-10-06T%02d:00", h), speedKn: 18, gustKn: 21, directionDeg: 210)
        w.waveHeightM = waves
        w.weatherCode = code
        w.precipitationMm = rain
        return w
    }

    func spot(_ id: String, water: String?) -> Spot {
        var s = Spot(id: id, name: id, latitude: 45, longitude: 0.05, seaFacingDeg: 165)
        s.waterType = water
        return s
    }

    func request(water: WaterPreference = .either, weather: WeatherPreference = .any) -> SearchRequest {
        var r = SearchRequest(origin: Coordinate(latitude: 45, longitude: 0), maxDriveMinutes: 60, day: "2026-10-06",
                              slot: .fullDay, intensity: nil, distanceMatters: false)
        r.water = water
        r.weather = weather
        return r
    }

    // MARK: Factors

    func testEitherAndAnyChangeNothing() {
        XCTAssertEqual(rules.waterFactor(.either, waterType: "sea", waveHeightM: 3), 1)
        XCTAssertEqual(rules.weatherFactor(.any, hour: hour(code: 65, rain: 8)), 1)
    }

    func testFlatWater() {
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "lagoon", waveHeightM: nil), 1)
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "lake", waveHeightM: 2), 1)
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "sea", waveHeightM: 0.4), 1)
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "sea", waveHeightM: 1.0), 0.8, accuracy: 0.001)
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "sea", waveHeightM: 2.5), 0.6)
        XCTAssertEqual(rules.waterFactor(.flat, waterType: "sea", waveHeightM: nil), 0.9)
    }

    func testWavyWater() {
        XCTAssertEqual(rules.waterFactor(.wavy, waterType: "lagoon", waveHeightM: nil), 0.6)
        XCTAssertEqual(rules.waterFactor(.wavy, waterType: "sea", waveHeightM: 0.1), 0.65)
        XCTAssertEqual(rules.waterFactor(.wavy, waterType: "sea", waveHeightM: 1.4), 1)
        XCTAssertEqual(rules.waterFactor(.wavy, waterType: "sea", waveHeightM: nil), 0.85)
        // A flat sea beats a lagoon for a wave rider, both lose to real waves.
        XCTAssertGreaterThan(rules.waterFactor(.wavy, waterType: "sea", waveHeightM: 0.2),
                             rules.waterFactor(.wavy, waterType: "lake", waveHeightM: nil))
    }

    func testFairWeather() {
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 1)), 1)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 3)), 0.85)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 45)), 0.7)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 53)), 0.7)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 63)), 0.5)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 81)), 0.5)
        // Rain measured without a rain code still counts.
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: 2, rain: 1.2)), 0.5)
        XCTAssertEqual(rules.weatherFactor(.fair, hour: hour(code: nil)), 1)
    }

    // MARK: Applied to the hours

    func testPreferencesScaleHoursAndSayWhy() {
        let scorer = Scorer(profile: rider, intensity: nil)
        let wavy = [scorer.score(hour(waves: 1.5, code: 3), seaFacingDeg: 165)]
        let out = Recommender.applyPreferences(spot("sea", water: "sea"), to: wavy,
                                               request: request(water: .flat, weather: .fair), rules: rules)
        XCTAssertEqual(out[0].score, wavy[0].score * 0.6 * 0.85, accuracy: 0.0001)
        XCTAssertEqual(out[0].waterFactor, 0.6)
        XCTAssertEqual(out[0].weatherFactor, 0.85)
        XCTAssertEqual(Array(out[0].flags.suffix(2)), ["waves", "grey weather"])
        // Nothing asked: hours untouched, no factor recorded.
        let same = Recommender.applyPreferences(spot("sea", water: "sea"), to: wavy, request: request(), rules: rules)
        XCTAssertEqual(same[0].score, wavy[0].score)
        XCTAssertNil(same[0].waterFactor)
    }

    func testRainIsNotFlaggedTwice() {
        let scorer = Scorer(profile: rider, intensity: nil)
        var hours = [scorer.score(hour(code: 63, rain: 3), seaFacingDeg: 165)]
        hours = Recommender.applySafety(spot("sea", water: "sea"), to: hours, day: "2026-10-06")
        hours = Recommender.applyPreferences(spot("sea", water: "sea"), to: hours, request: request(weather: .fair), rules: rules)
        XCTAssertEqual(hours[0].flags.filter { $0 == "rain" }.count, 1)
    }

    func testStormStaysZeroWhateverTheChoice() {
        let scorer = Scorer(profile: rider, intensity: nil)
        var hours = [scorer.score(hour(code: 95), seaFacingDeg: 165)]
        hours = Recommender.applySafety(spot("lake", water: "lake"), to: hours, day: "2026-10-06")
        hours = Recommender.applyPreferences(spot("lake", water: "lake"), to: hours,
                                             request: request(water: .flat, weather: .any), rules: rules)
        XCTAssertEqual(hours[0].score, 0)
        XCTAssertEqual(hours[0].flags.first, "thunderstorm risk")
    }

    /// Same wind everywhere: the choice decides the order.
    func testRankingFollowsTheChoice() async throws {
        let lagoon = spot("lagoon", water: "lagoon")
        let sea = spot("sea", water: "sea")
        let forecast = WavesForecast(waves: ["sea": 1.6])
        let rec = Recommender(spots: [lagoon, sea], forecast: forecast, driveTime: StraightLineDriveTime(), confidence: nil)
        let flat = try await rec.search(request(water: .flat), profile: rider, today: "2026-10-06")
        XCTAssertEqual(flat.recommendations.map(\.id), ["lagoon", "sea"])
        let wavy = try await rec.search(request(water: .wavy), profile: rider, today: "2026-10-06")
        XCTAssertEqual(wavy.recommendations.map(\.id), ["sea", "lagoon"])
    }

    // MARK: Fetch

    func testWaveHeightsAreReadFromTheMarineAPI() async throws {
        WaveStub.body = Data(#"{"hourly":{"time":["2026-10-06T13:00","2026-10-06T14:00"],"wave_height":[0.8,null]}}"#.utf8)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [WaveStub.self]
        var p = OpenMeteoProvider()
        p.session = URLSession(configuration: config)
        let out = try await p.fetchWaveHeights([spot("sea", water: "sea")], from: "2026-10-06", to: "2026-10-06")
        XCTAssertEqual(out["sea"], ["2026-10-06T13:00": 0.8])
        XCTAssertEqual(WaveStub.lastURL?.contains("hourly=wave_height"), true)
        XCTAssertFalse(OpenMeteoProvider.wantsWaves(spot("l", water: "lagoon")))
        XCTAssertTrue(OpenMeteoProvider.wantsWaves(spot("u", water: nil)))
    }
}

/// Same 18 kn side-on wind at every spot, wave heights per spot id.
struct WavesForecast: ForecastProvider {
    let waves: [String: Double]
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        Dictionary(uniqueKeysWithValues: spots.map { spot in
            let hours = (9...17).map { h -> HourlyWind in
                var w = HourlyWind(localTime: String(format: "\(day)T%02d:00", h), speedKn: 18, gustKn: 21, directionDeg: 210)
                w.waveHeightM = waves[spot.id]
                w.isDaylight = true
                return w
            }
            return (spot.id, DayForecast(day: day, hours: hours))
        })
    }
}

final class WaveStub: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var body = Data()
    nonisolated(unsafe) static var lastURL: String?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        Self.lastURL = request.url?.absoluteString
        client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
                            cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.body)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
