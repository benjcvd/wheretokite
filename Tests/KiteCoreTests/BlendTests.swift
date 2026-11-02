import XCTest
@testable import KiteCore

final class BlendTests: XCTestCase {
    let models = ["a", "b"]

    func series(_ values: [String: Double?]) -> [String: [Double?]] {
        values.mapValues { [$0] }
    }

    func testMeanSpeedAndGusts() throws {
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m_a": 10, "wind_speed_10m_b": 20,
            "wind_gusts_10m_a": 14, "wind_gusts_10m_b": 26,
            "wind_direction_10m_a": 90, "wind_direction_10m_b": 90,
        ]), index: 0, models: models, localTime: "2026-10-28T14:00"))
        XCTAssertEqual(w.speedKn, 15, accuracy: 1e-9)
        XCTAssertEqual(w.gustKn, 20, accuracy: 1e-9)
        XCTAssertEqual(w.directionDeg, 90, accuracy: 1e-9)
    }

    func testDirectionAcrossNorth() throws {
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m_a": 15, "wind_speed_10m_b": 15,
            "wind_direction_10m_a": 350, "wind_direction_10m_b": 10,
        ]), index: 0, models: models, localTime: "2026-10-28T14:00"))
        XCTAssertEqual(min(w.directionDeg, 360 - w.directionDeg), 0, accuracy: 1e-6)
    }

    func testStormFromAnyModelCounts() throws {
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m_a": 15, "wind_speed_10m_b": 15,
            "wind_direction_10m_a": 90, "wind_direction_10m_b": 90,
            "weather_code_a": 3, "weather_code_b": 95,
            "cape_a": 200, "cape_b": 1800,
            "precipitation_a": 0, "precipitation_b": 2,
        ]), index: 0, models: models, localTime: "2026-10-28T14:00"))
        XCTAssertEqual(w.weatherCode, 95)
        XCTAssertEqual(w.capeJkg, 1800)
        XCTAssertEqual(w.precipitationMm, 1)
        XCTAssertTrue(w.stormRisk)
    }

    func testModelMissingHereIsLeftOut() throws {
        // Outside AROME's area its series is null: the blend is the other models.
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m_a": nil, "wind_speed_10m_b": 18,
            "wind_direction_10m_a": nil, "wind_direction_10m_b": 200,
            "wind_gusts_10m_b": 22,
        ]), index: 0, models: models, localTime: "2026-10-28T14:00"))
        XCTAssertEqual(w.speedKn, 18)
        XCTAssertEqual(w.gustKn, 22)
    }

    func testNoGustsMeansGustIsTheMeanWind() throws {
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m_a": 12, "wind_direction_10m_a": 200,
        ]), index: 0, models: ["a", "b"], localTime: "2026-10-28T14:00"))
        XCTAssertEqual(w.gustKn, 12)
    }

    func testSingleModelReadsUnsuffixedSeries() throws {
        let w = try XCTUnwrap(Blend.hour(series([
            "wind_speed_10m": 16, "wind_gusts_10m": 20, "wind_direction_10m": 45, "weather_code": 61,
        ]), index: 0, models: ["best_match"], localTime: "2026-10-28T14:00"))
        XCTAssertEqual(w.speedKn, 16)
        XCTAssertEqual(w.weatherCode, 61)
    }

    func testNoWindAtAllIsNoHour() {
        XCTAssertNil(Blend.hour([:], index: 0, models: models, localTime: "2026-10-28T14:00"))
    }

    func testDefaultsAreTheWhe87Mix() {
        let p = OpenMeteoProvider()
        XCTAssertEqual(p.model, "meteofrance_seamless,ecmwf_ifs,gfs_seamless")
        XCTAssertEqual(p.cellSelection, "land")
        let groups = p.requestGroups()
        XCTAssertEqual(groups.map(\.cell), ["land", "sea"])
        XCTAssertEqual(groups.map(\.models), [["meteofrance_seamless"], ["ecmwf_ifs", "gfs_seamless"]])
        let body = p.formBody([], from: "2026-10-28", to: "2026-10-28", models: "ecmwf_ifs,gfs_seamless", cell: "sea")
        XCTAssertTrue(body.contains("cell_selection=sea"))
        XCTAssertTrue(body.contains("models=ecmwf_ifs,gfs_seamless"))
    }

    func testSkippedModelLeavesTheBlend() throws {
        let s = series([
            "wind_speed_10m_a": 20, "wind_direction_10m_a": 90,
            "wind_speed_10m_b": 10, "wind_direction_10m_b": 90,
        ])
        let all = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b"], localTime: "2026-10-28T14:00"))
        XCTAssertEqual(all.speedKn, 15, accuracy: 0.01)
        let noA = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b"], localTime: "2026-10-28T14:00", skip: ["a"]))
        XCTAssertEqual(noA.speedKn, 10, accuracy: 0.01)
        // Skipping every model would leave nothing: keep them all instead.
        let none = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b"], localTime: "2026-10-28T14:00", skip: ["a", "b"]))
        XCTAssertEqual(none.speedKn, 15, accuracy: 0.01)
    }

    func testDaysAhead() {
        XCTAssertEqual(OpenMeteoProvider.daysBetween("2026-11-02", "2026-11-06"), 4)
        XCTAssertEqual(OpenMeteoProvider.daysBetween("2026-12-30", "2027-01-02"), 3)
        // 23:30 UTC on 2 Nov is already 3 Nov in Barcelona (UTC+1).
        let d = Date(timeIntervalSince1970: 1_793_662_200)   // 2026-11-02T23:30:00Z
        XCTAssertEqual(OpenMeteoProvider.localDate(d, offsetSeconds: 0), "2026-11-02")
        XCTAssertEqual(OpenMeteoProvider.localDate(d, offsetSeconds: 3600), "2026-11-03")
    }

    func testOneCellIsOneRequest() {
        var p = OpenMeteoProvider(model: "best_match")
        XCTAssertEqual(p.requestGroups().count, 1)
        p.model = "icon_seamless,meteofrance_arome_france_hd"
        XCTAssertEqual(p.requestGroups().map(\.models), [["icon_seamless", "meteofrance_arome_france_hd"]])
    }

    func decode(_ json: String) throws -> OpenMeteoProvider.Response {
        try JSONDecoder().decode(OpenMeteoProvider.Response.self, from: Data(json.utf8))
    }

    func testMergeSuffixesTheSingleModelGroupAndAlignsTimes() throws {
        let land = try decode("""
        {"hourly":{"time":["2026-10-28T13:00","2026-10-28T14:00"],
          "wind_speed_10m_a":[10,12],"wind_direction_10m_a":[90,90],
          "wind_speed_10m_b":[14,16],"wind_direction_10m_b":[90,90]},
         "utc_offset_seconds":3600}
        """)
        // ECMWF answers hour 14 only, and unsuffixed (one model in its request).
        let sea = try decode("""
        {"hourly":{"time":["2026-10-28T14:00"],"wind_speed_10m":[20],"wind_direction_10m":[90]}}
        """)
        let merged = OpenMeteoProvider.merge([[land], [sea]], groups: [["a", "b"], ["c"]])
        XCTAssertEqual(merged.count, 1)
        let series = merged[0].hourly.series
        XCTAssertEqual(series["wind_speed_10m_c"], [nil, 20])
        XCTAssertNil(series["wind_speed_10m"])
        XCTAssertEqual(merged[0].utc_offset_seconds, 3600)
        let h13 = try XCTUnwrap(Blend.hour(series, index: 0, models: ["a", "b", "c"], localTime: "2026-10-28T13:00"))
        XCTAssertEqual(h13.speedKn, 12, accuracy: 1e-9)     // c missing: mean of a and b
        let h14 = try XCTUnwrap(Blend.hour(series, index: 1, models: ["a", "b", "c"], localTime: "2026-10-28T14:00"))
        XCTAssertEqual(h14.speedKn, 16, accuracy: 1e-9)     // (12 + 16 + 20) / 3
    }

    func testMergeSuffixesBothSingleModelGroups() throws {
        let a = try decode(#"{"hourly":{"time":["t"],"wind_speed_10m":[10],"wind_direction_10m":[0]}}"#)
        let b = try decode(#"{"hourly":{"time":["t"],"wind_speed_10m":[20],"wind_direction_10m":[0]}}"#)
        let s = OpenMeteoProvider.merge([[a], [b]], groups: [["a"], ["b"]])[0].hourly.series
        XCTAssertEqual(s["wind_speed_10m_a"], [10])
        XCTAssertEqual(s["wind_speed_10m_b"], [20])
    }
}
