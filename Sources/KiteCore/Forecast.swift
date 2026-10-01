import Foundation

public protocol ForecastProvider: Sendable {
    /// Hourly wind for each spot on a local day. Spots the provider can't serve are omitted.
    func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast]
}

public enum ForecastError: Error, CustomStringConvertible {
    case badResponse(String)

    public var description: String {
        switch self {
        case .badResponse(let msg): "Forecast error: \(msg)"
        }
    }
}

// MARK: - Open-Meteo

public struct OpenMeteoProvider: ForecastProvider {
    public var model: String
    /// "sea" picks the nearest water grid cell: that's where you ride, and coastal land cells
    /// under-read the wind.
    public var cellSelection = "sea"
    public var batchSize = 50
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

    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        var result: [String: DayForecast] = [:]
        for start in stride(from: 0, to: spots.count, by: batchSize) {
            let batch = Array(spots[start..<min(start + batchSize, spots.count)])
            let responses = try await fetch(batch, day: day)
            for (spot, response) in zip(batch, responses) {
                let h = response.hourly
                var hours: [HourlyWind] = []
                for i in h.time.indices {
                    guard let s = h.wind_speed_10m[i], let g = h.wind_gusts_10m[i],
                          let d = h.wind_direction_10m[i] else { continue }
                    hours.append(HourlyWind(localTime: h.time[i], speedKn: s, gustKn: g, directionDeg: d))
                }
                result[spot.id] = DayForecast(day: day, hours: hours)
            }
        }
        return result
    }

    private func fetch(_ spots: [Spot], day: String) async throws -> [Response] {
        // Past days come from the archive of what the model actually forecast back then,
        // which lets us check the scoring against sessions the user remembers.
        var c = URLComponents(string: Self.endpoint(for: day))!
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
        let (data, response) = try await session.data(from: c.url!)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ForecastError.badResponse(String(data: data, encoding: .utf8) ?? "HTTP error")
        }
        // A single location returns an object, several return an array.
        if spots.count == 1 {
            return [try JSONDecoder().decode(Response.self, from: data)]
        }
        return try JSONDecoder().decode([Response].self, from: data)
    }
}

extension OpenMeteoProvider {
    static func endpoint(for day: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return day < f.string(from: Date())
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
        let key = String(format: "%.4f_%.4f_%@", spot.latitude, spot.longitude, day)
        return directory.appendingPathComponent(key + ".json")
    }

    public func forecasts(for spots: [Spot], day: String) async throws -> [String: DayForecast] {
        var result: [String: DayForecast] = [:]
        var missing: [Spot] = []
        for spot in spots {
            if let data = try? Data(contentsOf: file(for: spot, day: day)),
               let entry = try? JSONDecoder().decode(Entry.self, from: data),
               Date().timeIntervalSince(entry.fetchedAt) < ttl {
                result[spot.id] = entry.forecast
            } else {
                missing.append(spot)
            }
        }
        guard !missing.isEmpty else { return result }

        let fresh = try await upstream.forecasts(for: missing, day: day)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        for spot in missing {
            guard let forecast = fresh[spot.id] else { continue }
            result[spot.id] = forecast
            if let data = try? JSONEncoder().encode(Entry(fetchedAt: Date(), forecast: forecast)) {
                try? data.write(to: file(for: spot, day: day))
            }
        }
        return result
    }
}
