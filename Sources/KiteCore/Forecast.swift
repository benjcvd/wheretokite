import Foundation

public protocol ForecastProvider: Sendable {
    /// Hourly wind for each spot on a local day. Spots the provider can't serve are omitted.
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast]

    /// Several consecutive days at once: day -> spot id -> forecast. Providers that can fetch a
    /// date range in one request (Open-Meteo counts a location once whatever the number of
    /// days) override this; the default asks day by day.
    func forecasts(for spots: [Spot], days: [String]) async throws -> [String: [String: DayForecast]]
}

extension ForecastProvider {
    public func forecasts(for spots: [Spot], days: [String]) async throws -> [String: [String: DayForecast]] {
        var out: [String: [String: DayForecast]] = [:]
        for day in days { out[day] = try await forecasts(for: spots, day: day) }
        return out
    }
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

// MARK: - Endpoints

/// Where forecasts come from: Open-Meteo directly, or the WhereToKite server (server/), which
/// answers the same API with a shared cache in front of Open-Meteo (and holds the commercial
/// key). Same request and response format either way.
public struct ForecastServer: Sendable, Equatable {
    public var forecast: URL
    public var archive: URL
    public var marine: URL

    public static let openMeteo = ForecastServer(
        forecast: URL(string: "https://api.open-meteo.com/v1/forecast")!,
        archive: URL(string: "https://historical-forecast-api.open-meteo.com/v1/forecast")!,
        marine: URL(string: "https://marine-api.open-meteo.com/v1/marine")!)

    /// The WhereToKite server at `base` (e.g. https://wheretokite-api.example.workers.dev).
    public static func wheretokite(_ base: URL) -> ForecastServer {
        ForecastServer(forecast: base.appendingPathComponent("v1/forecast"),
                       archive: base.appendingPathComponent("v1/archive"),
                       marine: base.appendingPathComponent("v1/marine"))
    }

    /// Past days come from the archive of what the model forecast back then, which lets us
    /// check the scoring against sessions the user remembers.
    public func endpoint(for day: String) -> URL {
        day < DayString.from(Date()) ? archive : forecast
    }
}

// MARK: - Open-Meteo

/// Open-Meteo forecast client.
///
/// Many locations go in one request (comma-separated coordinates), sent as a form-encoded
/// POST (supported by both the forecast and historical-forecast endpoints) so request size
/// is never an issue. Batches run a few at a time. A request covers a range of days: a
/// location costs one call whatever the number of days (up to two weeks), so a search
/// fetches the whole coming week and switching days afterwards is free.
///
/// Quota (free tier, per client IP): 600 calls/min, 5,000/hour, 10,000/day, 300,000/month,
/// and EACH location in a request counts as one call. See `Recommender.maxForecastSpots`,
/// `CachedForecastProvider`, and the server (server/) that shares one fetch per spot among
/// all users.
public struct OpenMeteoProvider: ForecastProvider {
    public var model: String
    public var server: ForecastServer
    /// "sea" picks the nearest water grid cell: that's where you ride, and coastal land cells
    /// under-read the wind.
    public var cellSelection = "sea"
    /// Locations per request. Measured: 100 → ~0.4 s, 200 → ~0.5 s per request.
    public var batchSize = 100
    /// Requests in flight at once (400 spots = 4 requests = one round trip).
    public var maxConcurrent = 4
    public var session: URLSession = .shared

    public init(model: String = "best_match", server: ForecastServer = .openMeteo) {
        self.model = model
        self.server = server
    }

    static let hourlyVariables = "wind_speed_10m,wind_gusts_10m,wind_direction_10m,weather_code,cape,precipitation"

    private struct Response: Decodable {
        struct Hourly: Decodable {
            var time: [String]
            var wind_speed_10m: [Double?]
            var wind_gusts_10m: [Double?]
            var wind_direction_10m: [Double?]
            var weather_code: [Int?]?
            var cape: [Double?]?
            var precipitation: [Double?]?
        }
        struct Daily: Decodable {
            var time: [String]
            var sunrise: [String?]?
            var sunset: [String?]?
        }
        var hourly: Hourly
        var daily: Daily?
        var utc_offset_seconds: Int?
    }

    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        try await forecasts(for: spots, days: [day])[day] ?? [:]
    }

    /// Batches that fail (e.g. HTTP 429 when over quota) are skipped — their spots are just
    /// missing from the result — as long as one batch succeeds; if all fail, the first error
    /// is thrown. `days` must be consecutive (one date range per request).
    public func forecasts(for spots: [Spot], days: [String]) async throws -> [String: [String: DayForecast]] {
        let days = days.sorted()
        guard let first = days.first, let last = days.last else { return [:] }
        for day in days { guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) } }
        let size = max(1, batchSize)
        let batches = stride(from: 0, to: spots.count, by: size).map {
            Array(spots[$0..<min($0 + size, spots.count)])
        }
        var result: [String: [String: DayForecast]] = [:]
        var firstError: Error?
        var succeeded = 0
        await withTaskGroup(of: Result<[(String, [DayForecast])], Error>.self) { group in
            var next = 0
            while next < min(max(1, maxConcurrent), batches.count) {
                let batch = batches[next]; next += 1
                group.addTask { await capture { try await fetchBatch(batch, from: first, to: last) } }
            }
            while let r = await group.next() {
                switch r {
                case .success(let pairs):
                    succeeded += 1
                    for (id, perDay) in pairs {
                        for f in perDay where days.contains(f.day) { result[f.day, default: [:]][id] = f }
                    }
                case .failure(let e):
                    if firstError == nil { firstError = e }
                }
                if next < batches.count {
                    let batch = batches[next]; next += 1
                    group.addTask { await capture { try await fetchBatch(batch, from: first, to: last) } }
                }
            }
        }
        if succeeded == 0, let firstError { throw firstError }
        return result
    }

    private func fetchBatch(_ batch: [Spot], from: String, to: String) async throws -> [(String, [DayForecast])] {
        let responses = try await fetch(batch, from: from, to: to)
        // Tides only where a spot depends on them; a failed tide request just leaves them out.
        let tideSpots = batch.filter { $0.tide != nil }
        let tides = tideSpots.isEmpty ? [:]
            : ((try? await fetchSeaLevels(tideSpots, from: from, to: to)) ?? [:])
        return zip(batch, responses).map { spot, response in
            let h = response.hourly
            let levels = tides[spot.id] ?? [:]
            let offset = response.utc_offset_seconds.flatMap { abs($0) <= 14 * 3600 ? $0 : nil }
            // Sunrise / sunset per day ("yyyy-MM-ddTHH:mm" local) -> minutes of the day.
            var light: [String: (Int, Int)] = [:]
            if let d = response.daily, let rise = d.sunrise, let set = d.sunset {
                for i in d.time.indices {
                    if let r = rise[safe: i] ?? nil, let s = set[safe: i] ?? nil,
                       let rm = Self.minuteOfDay(r), let sm = Self.minuteOfDay(s) {
                        light[d.time[i]] = (rm, sm)
                    }
                }
            }
            var byDay: [String: [HourlyWind]] = [:]
            for i in h.time.indices {
                guard let s = h.wind_speed_10m[safe: i] ?? nil, let g = h.wind_gusts_10m[safe: i] ?? nil,
                      let d = h.wind_direction_10m[safe: i] ?? nil,
                      HourlyWind.isPlausible(speedKn: s, gustKn: g, directionDeg: d) else { continue }
                let time = h.time[i]
                var w = HourlyWind(localTime: time, speedKn: s, gustKn: g, directionDeg: d)
                w.seaLevelM = levels[time]
                w.weatherCode = h.weather_code?[safe: i] ?? nil
                w.capeJkg = (h.cape?[safe: i] ?? nil).flatMap { (0...10000).contains($0) ? $0 : nil }
                w.precipitationMm = (h.precipitation?[safe: i] ?? nil).flatMap { (0...500).contains($0) ? $0 : nil }
                let date = String(time.prefix(10))
                if let (rise, set) = light[date] {
                    // Rideable light: the middle of the hour between sunrise and sunset.
                    let mid = w.hour * 60 + 30
                    w.isDaylight = mid >= rise && mid <= set
                }
                byDay[date, default: []].append(w)
            }
            return (spot.id, byDay.map { DayForecast(day: $0.key, hours: $0.value, utcOffsetSeconds: offset) })
        }
    }

    static func minuteOfDay(_ localTime: String) -> Int? {
        let t = localTime.dropFirst(11)
        guard t.count >= 5, let h = Int(t.prefix(2)), let m = Int(t.dropFirst(3).prefix(2)) else { return nil }
        return h * 60 + m
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
    func fetchSeaLevels(_ spots: [Spot], from: String, to: String) async throws -> [String: [String: Double]] {
        var c = URLComponents(url: server.marine, resolvingAgainstBaseURL: false)!
        c.queryItems = [
            .init(name: "latitude", value: spots.map { String(format: "%.4f", $0.latitude) }.joined(separator: ",")),
            .init(name: "longitude", value: spots.map { String(format: "%.4f", $0.longitude) }.joined(separator: ",")),
            .init(name: "hourly", value: "sea_level_height_msl"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: from),
            .init(name: "end_date", value: to),
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
    func formBody(_ spots: [Spot], from: String, to: String) -> String {
        var c = URLComponents()
        c.queryItems = [
            .init(name: "latitude", value: spots.map { String(format: "%.4f", $0.latitude) }.joined(separator: ",")),
            .init(name: "longitude", value: spots.map { String(format: "%.4f", $0.longitude) }.joined(separator: ",")),
            .init(name: "hourly", value: Self.hourlyVariables),
            .init(name: "daily", value: "sunrise,sunset"),
            .init(name: "wind_speed_unit", value: "kn"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: from),
            .init(name: "end_date", value: to),
            .init(name: "models", value: model),
            .init(name: "cell_selection", value: cellSelection),
        ]
        return c.percentEncodedQuery ?? ""
    }

    private func fetch(_ spots: [Spot], from: String, to: String) async throws -> [Response] {
        var request = URLRequest(url: server.endpoint(for: from))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(formBody(spots, from: from, to: to).utf8)
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

// MARK: - Cache

/// Per-spot, per-day disk cache in front of any provider. Entries expire after `ttl` (models
/// only update every few hours, so 2 h loses nothing). A miss for today or a later day fetches
/// the whole coming week (`prefetchDays`) in the same request, so changing day afterwards
/// costs nothing.
public struct CachedForecastProvider: ForecastProvider {
    public var upstream: ForecastProvider
    public var directory: URL
    public var ttl: TimeInterval
    /// Days fetched together on a miss for today or a later day (the day itself included).
    public var prefetchDays = 7

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
        // spot that just got a rule (user spot edited) would reuse a tideless entry. "v2":
        // entries with weather codes and daylight.
        let key = String(format: "v2_%.4f_%.4f_%@", spot.latitude, spot.longitude, day)
            + (spot.tide == nil ? "" : "_tide")
        return directory.appendingPathComponent(key + ".json")
    }

    private func cached(_ spot: Spot, day: String) -> DayForecast? {
        guard let data = try? Data(contentsOf: file(for: spot, day: day)),
              let entry = try? JSONDecoder().decode(Entry.self, from: data),
              (0..<ttl).contains(Date().timeIntervalSince(entry.fetchedAt)),   // no future-dated entries
              entry.forecast.hours.allSatisfy(\.isPlausible) else { return nil }
        return entry.forecast
    }

    /// The days to fetch together with `day`: the coming week for today or later, the day
    /// alone for the past (the archive is only used to look back at one day).
    func window(for day: String) -> [String] {
        guard day >= DayString.from(Date()), let start = DayString.date(day) else { return [day] }
        let calendar = Calendar(identifier: .gregorian)
        return (0..<max(1, prefetchDays)).compactMap {
            calendar.date(byAdding: .day, value: $0, to: start).map { DayString.from($0) }
        }
    }

    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        try await forecasts(for: spots, days: [day])[day] ?? [:]
    }

    public func forecasts(for spots: [Spot], days: [String]) async throws -> [String: [String: DayForecast]] {
        // The day is part of the cache file name: never let "../" or the like through.
        for day in days { guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) } }
        guard let firstDay = days.min() else { return [:] }
        var result: [String: [String: DayForecast]] = [:]
        var missing: [Spot] = []
        for spot in spots {
            var complete = true
            for day in days {
                if let f = cached(spot, day: day) { result[day, default: [:]][spot.id] = f } else { complete = false }
            }
            if !complete { missing.append(spot) }
        }
        guard !missing.isEmpty else { return result }

        let fetchDays = Array(Set(window(for: firstDay)).union(days)).sorted()
        let fresh = try await upstream.forecasts(for: missing, days: fetchDays)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let encoder = JSONEncoder()
        let now = Date()
        for (day, perSpot) in fresh {
            for spot in missing {
                guard let forecast = perSpot[spot.id] else { continue }
                if days.contains(day) { result[day, default: [:]][spot.id] = forecast }
                if let data = try? encoder.encode(Entry(fetchedAt: now, forecast: forecast)) {
                    try? data.write(to: file(for: spot, day: day))
                }
            }
        }
        return result
    }
}
