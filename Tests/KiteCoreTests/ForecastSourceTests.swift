import XCTest
@testable import KiteCore

final class ForecastSourceTests: XCTestCase {
    let mix = ["meteofrance_seamless", "ecmwf_ifs", "gfs_seamless"]
    // 16 Nov 2026 08:00 UTC.
    let now = Date(timeIntervalSince1970: 1_794_816_000)

    func hour(_ models: [String]?) -> HourlyWind {
        var w = HourlyWind(localTime: "2026-11-17T14:00", speedKn: 15, gustKn: 18, directionDeg: 90)
        w.models = models
        return w
    }

    func testBlendRecordsModelsThatGaveWind() throws {
        let s: [String: [Double?]] = [
            "wind_speed_10m_a": [10], "wind_direction_10m_a": [90],
            "wind_speed_10m_b": [nil], "wind_direction_10m_b": [nil],
            "wind_speed_10m_c": [12], "wind_direction_10m_c": [80],
        ]
        let w = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b", "c"], localTime: "2026-11-17T14:00"))
        XCTAssertEqual(w.models, ["a", "c"])
        let skipped = try XCTUnwrap(Blend.hour(s, index: 0, models: ["a", "b", "c"], localTime: "2026-11-17T14:00", skip: ["a"]))
        XCTAssertEqual(skipped.models, ["c"])
        let one = try XCTUnwrap(Blend.hour(["wind_speed_10m": [10], "wind_direction_10m": [90]],
                                           index: 0, models: ["ecmwf_ifs"], localTime: "2026-11-17T14:00"))
        XCTAssertEqual(one.models, ["ecmwf_ifs"])
    }

    func testUTCStart() {
        XCTAssertEqual(ForecastSource.utcStart("2026-11-16T09:00", offsetSeconds: 3600), now)
        XCTAssertEqual(ForecastSource.utcStart("1970-01-01T00:00", offsetSeconds: 0), Date(timeIntervalSince1970: 0))
        XCTAssertEqual(ForecastSource.utcStart("2024-03-01T00:00", offsetSeconds: 0), Date(timeIntervalSince1970: 1_709_251_200))
        XCTAssertNil(ForecastSource.utcStart("garbage", offsetSeconds: 0))
    }

    func testMeteoFranceIsAromeNearInCoverageThenArpege() {
        let pals = "es-sant-pere-pescador"
        XCTAssertTrue(AromeCoverage.inside.contains(pals))
        // Tomorrow afternoon: 30 h ahead.
        XCTAssertEqual(ForecastSource.resolve(mix, spotId: pals, localTime: "2026-11-17T15:00", utcOffsetSeconds: 3600, now: now),
                       ["meteofrance_arome_france_hd", "ecmwf_ifs", "gfs_seamless"])
        // Day 3: past the AROME run.
        XCTAssertEqual(ForecastSource.resolve(mix, spotId: pals, localTime: "2026-11-19T15:00", utcOffsetSeconds: 3600, now: now).first,
                       "meteofrance_arpege_europe")
    }

    func testOutsideAromeIsArpegeAndUnknownStaysGeneric() {
        let tarifa = "es-tarifa-balneario"
        XCTAssertTrue(AromeCoverage.outside.contains(tarifa))
        XCTAssertEqual(ForecastSource.resolve(mix, spotId: tarifa, localTime: "2026-11-16T15:00", utcOffsetSeconds: 3600, now: now).first,
                       "meteofrance_arpege_europe")
        XCTAssertEqual(ForecastSource.resolve(mix, spotId: "new-spot", localTime: "2026-11-16T15:00", utcOffsetSeconds: 3600, now: now).first,
                       "meteofrance_seamless")
        XCTAssertEqual(ForecastSource.resolve(mix, spotId: "new-spot", localTime: "2026-11-19T15:00", utcOffsetSeconds: 3600, now: now).first,
                       "meteofrance_arpege_europe")
        XCTAssertEqual(ForecastSource.resolve(["ecmwf_ifs"], spotId: tarifa, localTime: "2026-11-16T15:00", utcOffsetSeconds: 3600, now: now),
                       ["ecmwf_ifs"])
    }

    func testSummary() {
        XCTAssertEqual(ForecastSource.summary([hour(["meteofrance_arome_france_hd", "ecmwf_ifs", "gfs_seamless"])]),
                       "AROME 1.3 km · ECMWF 9 km · GFS")
        // Météo-France switches model inside the window.
        XCTAssertEqual(ForecastSource.summary([
            hour(["meteofrance_arome_france_hd", "ecmwf_ifs", "gfs_seamless"]),
            hour(["meteofrance_arpege_europe", "ecmwf_ifs", "gfs_seamless"]),
        ]), "AROME 1.3 km → ARPEGE 11 km · ECMWF 9 km · GFS")
        // Day 4+: Météo-France left out.
        XCTAssertEqual(ForecastSource.summary([hour(["ecmwf_ifs", "gfs_seamless"])]), "ECMWF 9 km · GFS")
        XCTAssertEqual(ForecastSource.summary([hour(["meteofrance_seamless", "ecmwf_ifs"])]), "Météo-France · ECMWF 9 km")
        XCTAssertNil(ForecastSource.summary([hour(nil)]))
    }
}
