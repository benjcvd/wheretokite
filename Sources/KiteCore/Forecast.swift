import Foundation

public protocol ForecastProvider: Sendable {
    /// Hourly wind for each spot on a local day. Spots the provider can't serve are omitted.
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast]
}

public enum ForecastError: Error, CustomStringConvertible {
    case badResponse(String)
    /// The day is not "yyyy-MM-dd".
    case invalidDay(String)

    public var description: String {
        switch self {
        case .badResponse(let msg): "Forecast error: \(msg)"
        case .invalidDay(let day): "Forecast error: invalid day \(day.debugDescription)"
        }
    }
}

// MARK: - Open-Meteo

/// Open-Meteo forecast client.
///
/// Many locations go in one request (comma-separated coordinates), sent as a form-encoded
/// POST (supported by both the forecast and historical-forecast endpoints) so request size
/// is never an issue. A GET with 100 locations would be ~1.8 kB of query string — fine — but
/// URLs past ~8 kB get rejected by proxies, which a GET with a few hundred would hit.
/// Batches run a few at a time.
///
/// Quota (free tier, per client IP): 600 calls/min, 5,000/hour, 10,000/day, 300,000/month,
/// and EACH location in a request counts as one call (our 3 hourly variables over 1 day add
/// nothing extra). A 400-spot search therefore costs 400 calls — see
/// `Recommender.maxForecastSpots` for the per-search cap, and `CachedForecastProvider`
/// (2 h TTL) for why re-running a search is nearly free.
public struct OpenMeteoProvider: ForecastProvider {
    public var model: String
    /// "sea" picks the nearest water grid cell: that's where you ride, and coastal land cells
    /// under-read the wind.
    public var cellSelection = "sea"
    /// Locations per request. Measured: 100 → ~0.4 s, 200 → ~0.5 s per request.
    public var batchSize = 100
    /// Requests in flight at once (400 spots = 4 requests = one round trip).
    public var maxConcurrent = 4
    public var session: URLSession = .shared

    public init(model: String = "best_match") {
        self.model = model
    }

    private struct Response: Decodable {
        struct Hourly: Decodable {
            var time: [String]
            var wind_speed_10m: [Double?]
            var wind_gusts_10m: [Double?]
            var wind_direction_10m: [Double?]
        }
        var hourly: Hourly
    }

    /// Batches that fail (e.g. HTTP 429 when over quota) are skipped — their spots are just
    /// missing from the result — as long as one batch succeeds; if all fail, the first error
    /// is thrown.
    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) }
        let size = max(1, batchSize)
        let batches = stride(from: 0, to: spots.count, by: size).map {
            Array(spots[$0..<min($0 + size, spots.count)])
        }
        var result: [String: DayForecast] = [:]
        var firstError: Error?
        var succeeded = 0
        await withTaskGroup(of: Result<[(String, DayForecast)], Error>.self) { group in
            var next = 0
            while next < min(max(1, maxConcurrent), batches.count) {
                let batch = batches[next]; next += 1
                group.addTask { await capture { try await fetchBatch(batch, day: day) } }
            }
            while let r = await group.next() {
                switch r {
                case .success(let pairs):
                    succeeded += 1
                    for (id, f) in pairs { result[id] = f }
                case .failure(let e):
                    if firstError == nil { firstError = e }
                }
                if next < batches.count {
                    let batch = batches[next]; next += 1
                    group.addTask { await capture { try await fetchBatch(batch, day: day) } }
                }
            }
        }
        if succeeded == 0, let firstError { throw firstError }
        return result
    }

    private func fetchBatch(_ batch: [Spot], day: String) async throws -> [(String, DayForecast)] {
        let responses = try await fetch(batch, day: day)
        // Tides only where a spot depends on them; a failed tide request just leaves them out.
        let tideSpots = batch.filter { $0.tide != nil }
        let tides = tideSpots.isEmpty ? [:] : ((try? await fetchSeaLevels(tideSpots, day: day)) ?? [:])
        return zip(batch, responses).map { spot, response in
            let h = response.hourly
            let levels = tides[spot.id] ?? [:]
            var hours: [HourlyWind] = []
            for i in h.time.indices {
                guard let s = h.wind_speed_10m[safe: i] ?? nil, let g = h.wind_gusts_10m[safe: i] ?? nil,
                      let d = h.wind_direction_10m[safe: i] ?? nil,
                      HourlyWind.isPlausible(speedKn: s, gustKn: g, directionDeg: d) else { continue }
                var w = HourlyWind(localTime: h.time[i], speedKn: s, gustKn: g, directionDeg: d)
                w.seaLevelM = levels[h.time[i]]
                hours.append(w)
            }
            return (spot.id, DayForecast(day: day, hours: hours))
        }
    }

    private struct MarineResponse: Decodable {
        struct Hourly: Decodable {
            var time: [String]
            var sea_level_height_msl: [Double?]
        }
        var hourly: Hourly
    }

    /// Hourly sea level incl. tide (Open-Meteo Marine, ~8 km grid: good for the timing of high
    /// and low water, approximate for heights) -> spot id -> local time -> metres.
    func fetchSeaLevels(_ spots: [Spot], day: String) async throws -> [String: [String: Double]] {
        var c = URLComponents(string: "https://marine-api.open-meteo.com/v1/marine")!
        c.queryItems = [
            .init(name: "latitude", value: spots.map { String(format: "%.4f", $0.latitude) }.joined(separator: ",")),
            .init(name: "longitude", value: spots.map { String(format: "%.4f", $0.longitude) }.joined(separator: ",")),
            .init(name: "hourly", value: "sea_level_height_msl"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: day),
            .init(name: "end_date", value: day),
        ]
        let (data, response) = try await session.data(from: c.url!)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ForecastError.badResponse(String(data: data, encoding: .utf8) ?? "HTTP error")
        }
        let decoded = spots.count == 1
            ? [try JSONDecoder().decode(MarineResponse.self, from: data)]
            : try JSONDecoder().decode([MarineResponse].self, from: data)
        var out: [String: [String: Double]] = [:]
        for (spot, r) in zip(spots, decoded) {
            var levels: [String: Double] = [:]
            for (t, v) in zip(r.hourly.time, r.hourly.sea_level_height_msl) {
                if let v, (-30...30).contains(v) { levels[t] = v }
            }
            out[spot.id] = levels
        }
        return out
    }

    /// Form-encoded request body (same parameters as the GET query string).
    func formBody(_ spots: [Spot], day: String) -> String {
        var c = URLComponents()
        c.queryItems = [
            .init(name: "latitude", value: spots.map { String(format: "%.4f", $0.latitude) }.joined(separator: ",")),
            .init(name: "longitude", value: spots.map { String(format: "%.4f", $0.longitude) }.joined(separator: ",")),
            .init(name: "hourly", value: "wind_speed_10m,wind_gusts_10m,wind_direction_10m"),
            .init(name: "wind_speed_unit", value: "kn"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: day),
            .init(name: "end_date", value: day),
            .init(name: "models", value: model),
            .init(name: "cell_selection", value: cellSelection),
        ]
        return c.percentEncodedQuery ?? ""
    }

    private func fetch(_ spots: [Spot], day: String) async throws -> [Response] {
        // Past days come from the archive of what the model actually forecast back then,
        // which lets us check the scoring against sessions the user remembers.
        var request = URLRequest(url: URL(string: Self.endpoint(for: day))!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(formBody(spots, day: day).utf8)
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ForecastError.badResponse(String(data: data, encoding: .utf8) ?? "HTTP error")
        }
        // A single location returns an object, several return an array.
        if spots.count == 1 {
            return [try JSONDecoder().decode(Response.self, from: data)]
        }
        let decoded = try JSONDecoder().decode([Response].self, from: data)
        guard decoded.count == spots.count else {
            throw ForecastError.badResponse("expected \(spots.count) locations, got \(decoded.count)")
        }
        return decoded
    }
}

private func capture<T>(_ body: () async throws -> T) async -> Result<T, Error> {
    do { return .success(try await body()) } catch { return .failure(error) }
}

extension OpenMeteoProvider {
    static func endpoint(for day: String) -> String {
        day < DayString.from(Date())
            ? "https://historical-forecast-api.open-meteo.com/v1/forecast"
            : "https://api.open-meteo.com/v1/forecast"
    }
}

// MARK: - Cache

/// Per-spot disk cache in front of any provider. Entries expire after `ttl`
/// (models only update every few hours, so 2h loses nothing).
public struct CachedForecastProvider: ForecastProvider {
    public var upstream: ForecastProvider
    public var directory: URL
    public var ttl: TimeInterval

    public init(upstream: ForecastProvider, directory: URL = CachedForecastProvider.defaultDirectory,
                ttl: TimeInterval = 2 * 3600) {
        self.upstream = upstream
        self.directory = directory
        self.ttl = ttl
    }

    public static var defaultDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("WhereToKite/forecasts", isDirectory: true)
    }

    private struct Entry: Codable {
        var fetchedAt: Date
        var forecast: DayForecast
    }

    private func file(for spot: Spot, day: String) -> URL {
        // Tides are only fetched for spots with a tide rule: keep those entries apart, or a
        // spot that just got a rule (user spot edited) would reuse a tideless entry.
        let key = String(format: "%.4f_%.4f_%@", spot.latitude, spot.longitude, day)
            + (spot.tide == nil ? "" : "_tide")
        return directory.appendingPathComponent(key + ".json")
    }

    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        // The day is part of the cache file name: never let "../" or the like through.
        guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) }
        var result: [String: DayForecast] = [:]
        var missing: [Spot] = []
        let decoder = JSONDecoder()
        for spot in spots {
            if let data = try? Data(contentsOf: file(for: spot, day: day)),
               let entry = try? decoder.decode(Entry.self, from: data),
               (0..<ttl).contains(Date().timeIntervalSince(entry.fetchedAt)),   // no future-dated entries
               entry.forecast.hours.allSatisfy(\.isPlausible) {
                result[spot.id] = entry.forecast
            } else {
                missing.append(spot)
            }
        }
        guard !missing.isEmpty else { return result }

        let fresh = try await upstream.forecasts(for: missing, day: day)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let encoder = JSONEncoder()
        let now = Date()
        for spot in missing {
            guard let forecast = fresh[spot.id] else { continue }
            result[spot.id] = forecast
            if let data = try? encoder.encode(Entry(fetchedAt: now, forecast: forecast)) {
                try? data.write(to: file(for: spot, day: day))
            }
        }
        return result
    }
}
