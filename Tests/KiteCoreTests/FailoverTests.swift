import XCTest
@testable import KiteCore

/// The server is tried first; when it fails or hangs, Open-Meteo answers instead and the
/// server is skipped for a while.
final class FailoverTests: XCTestCase {
    private let server = ForecastServer.wheretokite(URL(string: "https://server.test")!)

    private func failover(timeout: Duration = .seconds(5), cooldown: TimeInterval = 600) -> ServerFailover {
        ServerFailover(primary: server, fallback: .openMeteo, timeout: timeout, cooldown: cooldown)
    }

    func testServerAnswersFirst() async throws {
        let f = failover()
        let used = try await f.run { $0 }
        XCTAssertEqual(used, server)
        let skipping = await f.usingFallback
        XCTAssertFalse(skipping)
    }

    func testFailingServerFallsBackThenIsSkipped() async throws {
        let f = failover()
        let calls = Calls()
        let first = try await f.run { s in
            await calls.add(s)
            if s == self.server { throw URLError(.cannotConnectToHost) }
            return s
        }
        XCTAssertEqual(first, .openMeteo)
        // Next search: straight to Open-Meteo, no wait on the server.
        let second = try await f.run { s in await calls.add(s); return s }
        XCTAssertEqual(second, .openMeteo)
        let seen = await calls.list
        XCTAssertEqual(seen, [server, .openMeteo, .openMeteo])
    }

    func testHangingServerTimesOut() async throws {
        let f = failover(timeout: .milliseconds(200))
        let start = Date()
        let used = try await f.run { s in
            if s == self.server { try await Task.sleep(for: .seconds(30)) }
            return s
        }
        XCTAssertEqual(used, .openMeteo)
        XCTAssertLessThan(Date().timeIntervalSince(start), 5)
    }

    func testServerTriedAgainAfterCooldown() async throws {
        let f = failover(cooldown: 0)
        _ = try await f.run { s in
            if s == self.server { throw URLError(.timedOut) }
            return s
        }
        let used = try await f.run { $0 }
        XCTAssertEqual(used, server)
    }

    func testFallbackErrorIsThrown() async {
        let f = failover()
        do {
            _ = try await f.run { _ -> Int in throw URLError(.notConnectedToInternet) }
            XCTFail("expected an error")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
}

private actor Calls {
    var list: [ForecastServer] = []
    func add(_ s: ForecastServer) { list.append(s) }
}
