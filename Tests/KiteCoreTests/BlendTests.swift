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

    func testDefaultsAreTheBlendOnTheBeachCell() {
        let p = OpenMeteoProvider()
        XCTAssertEqual(p.model, "meteofrance_arome_france_hd,icon_seamless,ecmwf_ifs025")
        XCTAssertEqual(p.cellSelection, "land")
        XCTAssertTrue(p.formBody([], from: "2026-10-28", to: "2026-10-28").contains("cell_selection=land"))
    }
}
