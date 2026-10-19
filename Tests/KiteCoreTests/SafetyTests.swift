import XCTest
@testable import KiteCore

final class SafetyTests: XCTestCase {
    func spot(bans: [SpotBan]? = nil) throws -> Spot {
        var s = try JSONDecoder().decode(Spot.self, from: Data(#"{"id":"x","name":"X","latitude":43,"longitude":3,"seaFacingDeg":180}"#.utf8))
        s.bans = bans
        return s
    }

    func hour(_ h: Int, code: Int? = nil, cape: Double? = nil, rain: Double? = nil, light: Bool? = true) -> HourScore {
        var w = HourlyWind(localTime: String(format: "2026-07-14T%02d:00", h), speedKn: 18, gustKn: 21, directionDeg: 225)
        w.weatherCode = code; w.capeJkg = cape; w.precipitationMm = rain; w.isDaylight = light
        return HourScore(wind: w, score: 0.9, kite: nil, relativeAngle: 45, flags: [])
    }

    func testBans() {
        let summer = SpotBan(from: "06-15", to: "09-15", startHour: 11, endHour: 19)
        XCTAssertTrue(summer.covers(monthDay: "07-14", hour: 11))
        XCTAssertTrue(summer.covers(monthDay: "09-15", hour: 18))
        XCTAssertFalse(summer.covers(monthDay: "07-14", hour: 19))    // end exclusive
        XCTAssertFalse(summer.covers(monthDay: "09-16", hour: 12))
        let winter = SpotBan(from: "11-01", to: "02-28")               // wraps over the new year
        XCTAssertTrue(winter.covers(monthDay: "12-25", hour: 3))
        XCTAssertTrue(winter.covers(monthDay: "01-10", hour: 15))
        XCTAssertFalse(winter.covers(monthDay: "07-01", hour: 15))
    }

    func testHardLimits() throws {
        let s = try spot(bans: [SpotBan(from: "07-01", to: "08-31", startHour: 12, endHour: 14)])
        let hours = [hour(10, code: 95), hour(11, cape: 2000), hour(12), hour(16, light: false), hour(17, rain: 2), hour(18)]
        let out = Recommender.applySafety(s, to: hours, day: "2026-07-14")
        XCTAssertEqual(out.map(\.score), [0, 0, 0, 0, 0.9, 0.9])
        XCTAssertEqual(out[0].flags.first, "thunderstorm risk")
        XCTAssertEqual(out[1].flags.first, "thunderstorm risk")
        XCTAssertEqual(out[2].flags.first, "kiting banned")
        XCTAssertEqual(out[3].flags.first, "dark")
        XCTAssertEqual(out[4].flags, ["rain"])
        // Outside the ban season the same hour is fine.
        XCTAssertEqual(Recommender.applySafety(s, to: [hour(12)], day: "2026-10-01")[0].score, 0.9)
    }

    func testCustomHours() {
        var r = SearchRequest(origin: Coordinate(latitude: 41, longitude: 2), maxDriveMinutes: 60, day: "2026-07-14",
                              slot: .custom, intensity: nil, distanceMatters: false)
        XCTAssertEqual(r.hours, SessionSlot.custom.hours)
        r.customHours = 18...20
        XCTAssertEqual(r.hours, 18...20)
        r.slot = .evening
        XCTAssertEqual(r.hours, 17...20)
    }

    func testSunTimesAndWindow() {
        XCTAssertEqual(OpenMeteoProvider.minuteOfDay("2026-07-14T06:42"), 6 * 60 + 42)
        XCTAssertNil(OpenMeteoProvider.minuteOfDay("garbage"))
        let cache = CachedForecastProvider(upstream: OpenMeteoProvider(), directory: FileManager.default.temporaryDirectory)
        let today = DayString.from(Date())
        XCTAssertEqual(cache.window(for: today).count, 7)
        XCTAssertEqual(cache.window(for: today).first, today)
        XCTAssertEqual(cache.window(for: "2020-01-01"), ["2020-01-01"])   // past: the day alone
    }
}
