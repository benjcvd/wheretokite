import XCTest
@testable import KiteCore

/// Today's search only scores the hours the rider can still reach: now + drive (WHE-161).
final class ArrivalTests: XCTestCase {
    /// Same good onshore wind all day, 9–20 h, at UTC+1 (Barcelona in November).
    final class AllDayWind: ForecastProvider, @unchecked Sendable {
        func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
            Dictionary(uniqueKeysWithValues: spots.map { spot in
                let hours = (9...20).map {
                    HourlyWind(localTime: String(format: "\(day)T%02d:00", $0), speedKn: 18, gustKn: 21, directionDeg: 180)
                }
                return (spot.id, DayForecast(day: day, hours: hours, utcOffsetSeconds: 3600))
            })
        }
    }

    let rider = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    let origin = Coordinate(latitude: 45, longitude: 0)

    /// `count` spots due east, facing south (onshore for the fake wind).
    func spots(_ count: Int) -> [Spot] {
        (0..<count).map { i in
            Spot(id: String(format: "s%03d", i), name: "Spot \(i)", latitude: 45,
                 longitude: Double(i + 1) * 0.005, seaFacingDeg: 180)
        }
    }

    /// 11 Nov 2026 at `hh:mm` local time (UTC+1).
    func local(_ hh: Int, _ mm: Int = 0) -> Date {
        Date(timeIntervalSince1970: 1_794_355_200 + Double((hh - 1) * 3600 + mm * 60))   // 2026-11-11T00:00Z
    }

    func request(slot: SessionSlot = .afternoon, now: Date?) -> SearchRequest {
        var r = SearchRequest(origin: origin, maxDriveMinutes: 120, day: "2026-11-11", slot: slot,
                              intensity: nil, distanceMatters: false)
        r.now = now
        return r
    }

    func testFirstReachableHour() {
        XCTAssertEqual(DayString.from(local(0), timeZone: TimeZone(identifier: "GMT")!), "2026-11-10")   // 23:00Z the day before
        // The audit's case: 17:52 + 1 h 02 drive = 18:54, so 19 h at the earliest.
        XCTAssertEqual(Recommender.firstReachableHour(now: local(17, 52), utcOffset: 3600, day: "2026-11-11", driveMinutes: 62), 19)
        // Rounded up, in the rider's favour; a full hour stays.
        XCTAssertEqual(Recommender.firstReachableHour(now: local(13, 20), utcOffset: 3600, day: "2026-11-11", driveMinutes: 50), 15)
        XCTAssertEqual(Recommender.firstReachableHour(now: local(13), utcOffset: 3600, day: "2026-11-11", driveMinutes: 60), 14)
        // The spot's own clock: at 17:52 in Barcelona it's 16:52 in Lisbon.
        XCTAssertEqual(Recommender.firstReachableHour(now: local(17, 52), utcOffset: 0, day: "2026-11-11", driveMinutes: 0), 17)
        // Late drives can go past midnight: nothing left.
        XCTAssertEqual(Recommender.firstReachableHour(now: local(22), utcOffset: 3600, day: "2026-11-11", driveMinutes: 180), 25)
        // No clock, or a later day: no cut. A day already over: nothing left.
        XCTAssertNil(Recommender.firstReachableHour(now: nil, utcOffset: 3600, day: "2026-11-11", driveMinutes: 62))
        XCTAssertNil(Recommender.firstReachableHour(now: local(17, 52), utcOffset: 3600, day: "2026-11-12", driveMinutes: 62))
        XCTAssertEqual(Recommender.firstReachableHour(now: local(17, 52), utcOffset: 3600, day: "2026-11-10", driveMinutes: 62), 24)
    }

    func testHoursBeforeArrivalScoreZeroFlaggedTooLate() {
        let hours = (13...17).map {
            HourScore(wind: HourlyWind(localTime: String(format: "2026-11-11T%02d:00", $0), speedKn: 18, gustKn: 21, directionDeg: 180),
                      score: 0.9, kite: nil, relativeAngle: 0, flags: $0 == 13 ? ["dark"] : [])
        }
        let out = Recommender.applyArrival(hours, from: 15)
        XCTAssertEqual(out.map(\.score), [0, 0, 0.9, 0.9, 0.9])
        XCTAssertEqual(out.map { $0.flags.first }, ["too late", "too late", nil, nil, nil])
        XCTAssertEqual(out[0].flags, ["too late", "dark"])
        XCTAssertEqual(Recommender.applyArrival(hours, from: nil).map(\.score), hours.map(\.score))
    }

    func testMainProblemIsTooLateOnlyWhenNoHourIsLeft() {
        func h(_ hour: Int, _ flags: [String]) -> HourScore {
            HourScore(wind: HourlyWind(localTime: String(format: "2026-11-11T%02d:00", hour), speedKn: 8, gustKn: 9, directionDeg: 180),
                      score: 0, kite: nil, relativeAngle: 0, flags: flags)
        }
        XCTAssertEqual(Recommender.mainProblem([h(16, ["too late"]), h(17, ["too late", "dark"])]), "too late")
        XCTAssertEqual(Recommender.mainProblem([h(16, ["too late"]), h(17, ["too light"])]), "too light")
        XCTAssertEqual(Recommender.mainProblem([h(16, ["too late", "thunderstorm risk"]), h(17, ["too light"])]), "too light")
    }

    /// The audit's case at real size: 17:52, afternoon slot, every spot an hour away.
    func testLateAfternoonSearchSaysTheSessionIsOver() async throws {
        let r = Recommender(spots: spots(100), forecast: AllDayWind(), driveTime: FakeRoutes { _ in 62 }, confidence: nil)
        let before = try await r.search(request(now: nil), profile: rider, today: "2026-11-11")
        XCTAssertNotNil(before.recommendations.first?.window)   // the bug: a window that's over
        XCTAssertFalse(before.sessionOver)

        let after = try await r.search(request(now: local(17, 52)), profile: rider, today: "2026-11-11")
        XCTAssertEqual(after.recommendations.count, 100)
        XCTAssertTrue(after.recommendations.allSatisfy { $0.finalScore == 0 && $0.window == nil })
        XCTAssertTrue(after.sessionOver)
        XCTAssertEqual(after.recommendations[0].safetyReason, "too late")
        XCTAssertTrue(after.recommendations[0].reason.hasPrefix("too late"))
    }

    func testEarlySearchKeepsTheReachableHours() async throws {
        let r = Recommender(spots: spots(3), forecast: AllDayWind(), driveTime: FakeRoutes { _ in 50 }, confidence: nil)
        let res = try await r.search(request(now: local(13, 20)), profile: rider, today: "2026-11-11")
        let top = try XCTUnwrap(res.recommendations.first)
        XCTAssertFalse(res.sessionOver)
        XCTAssertEqual(top.window?.start, 15)   // 13:20 + 50 min = 14:10 → 15 h
        XCTAssertEqual(top.window?.end, 18)
        XCTAssertEqual(top.hours.filter { $0.flags.first == "too late" }.map(\.wind.hour), [13, 14])
    }

    /// The cut follows the real drive once Apple Maps answers, not the straight-line estimate.
    func testCutUsesTheRealDriveTime() async throws {
        let r = Recommender(spots: spots(1), forecast: AllDayWind(), driveTime: FakeRoutes { _ in 100 }, confidence: nil)
        let res = try await r.search(request(now: local(12)), profile: rider, today: "2026-11-11")
        let top = try XCTUnwrap(res.recommendations.first)
        XCTAssertFalse(top.driveIsEstimate)
        XCTAssertEqual(top.hours.filter { $0.flags.first == "too late" }.map(\.wind.hour), [13])   // 12:00 + 1h40 → 14 h
        XCTAssertEqual(top.window?.start, 14)
    }

    /// Later days aren't cut, so the next good window can be tomorrow.
    func testSessionOverStillFindsTomorrow() async throws {
        let r = Recommender(spots: spots(3), forecast: AllDayWind(), driveTime: FakeRoutes { _ in 62 }, confidence: nil)
        let req = request(now: local(17, 52))
        let next = await r.nextGoodWindow(for: req, days: ["2026-11-12"], profile: rider, minimum: 50, today: "2026-11-11")
        XCTAssertEqual(next?.day, "2026-11-12")
        XCTAssertEqual(next?.recommendation.window?.start, 13)
    }
}
