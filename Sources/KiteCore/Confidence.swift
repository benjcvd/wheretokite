import Foundation

public struct ForecastConfidence: Sendable {
    public enum Rating: String, Sendable { case high = "High", medium = "Medium", low = "Low" }

    public var score: Int
    public var rating: Rating
    public var leadDays: Int
    /// Mean disagreement between models on wind speed during the slot, in knots.
    public var speedSpreadKn: Double
    /// Mean disagreement on direction, in degrees (only counted when there is real wind).
    public var directionSpreadDeg: Double?
    public var modelsCompared: [String]
    /// Each model's plausible hourly wind over the whole day (spot-local hours), for the
    /// chance to kite (`Scorer.kiteChance`).
    public var modelHours: [String: [ModelWind]] = [:]

    public init(score: Int, rating: Rating, leadDays: Int, speedSpreadKn: Double, directionSpreadDeg: Double?,
                modelsCompared: [String], modelHours: [String: [ModelWind]] = [:]) {
        self.score = score
        self.rating = rating
        self.leadDays = leadDays
        self.speedSpreadKn = speedSpreadKn
        self.directionSpreadDeg = directionSpreadDeg
        self.modelsCompared = modelsCompared
        self.modelHours = modelHours
    }

    public var summary: String {
        var parts = ["\(rating.rawValue) confidence (\(score)/100)",
                     leadDays < 0 ? "past day (archived forecast)" : leadDays == 0 ? "today" : "\(leadDays) day\(leadDays > 1 ? "s" : "") ahead",
                     String(format: "models agree within ±%.0f kn", speedSpreadKn)]
        if let d = directionSpreadDeg { parts.append(String(format: "±%.0f° direction", d)) }
        return parts.joined(separator: " · ")
    }
}

/// One model's wind for one local hour.
public struct ModelWind: Sendable, Equatable {
    public var hour: Int
    public var speedKn: Double
    public var directionDeg: Double

    public init(hour: Int, speedKn: Double, directionDeg: Double) {
        self.hour = hour
        self.speedKn = speedKn
        self.directionDeg = directionDeg
    }
}

/// Where to compare the models, and over which local hours.
public struct ConfidenceQuery: Sendable, Equatable {
    public var coordinate: Coordinate
    public var hours: ClosedRange<Int>

    public init(coordinate: Coordinate, hours: ClosedRange<Int>) {
        self.coordinate = coordinate
        self.hours = hours
    }
}

/// Compares the weather models at several places in one request (the Recommender asks for
/// the top-ranked spots). One answer per query, in order.
public protocol ConfidenceProvider: Sendable {
    func estimates(for queries: [ConfidenceQuery], day: String, today: String) async throws -> [ForecastConfidence]
}

/// How much to trust the forecast: forecast accuracy drops with lead time, and when
/// independent models disagree the forecast is uncertain. Checked per spot (the models can
/// agree at home and disagree two hours up the coast), all spots in one multi-location request.
public struct ConfidenceEstimator: ConfidenceProvider {
    /// The four models the chance to kite was tuned on (WHE-81/84): best match, Météo-France
    /// (AROME 1.3 km for the first two days, then ARPEGE), ICON and ECMWF.
    public var models = ["best_match", "meteofrance_seamless", "icon_seamless", "ecmwf_ifs025"]
    /// Grid cell read for every model not in `cellByModel` (the beach cell, as the forecasts).
    public var cellSelection = "land"
    /// ECMWF's beach cell falls ~15 km inland (median, up to 29 km) and reads ~2.6 kn light, so it
    /// is read on its sea cell, as when the chance was tuned (WHE-71). Open-Meteo takes one
    /// `cell_selection` per request: one request per cell, merged per spot.
    public var cellByModel: [String: String] = ["ecmwf_ifs025": "sea"]
    public var session: URLSession = .shared
    public var server: ForecastServer
    /// When set, `server` is ignored: the failover picks the server for each request.
    public var failover: ServerFailover?

    public init(server: ForecastServer = .openMeteo) {
        self.server = server
    }

    public init(failover: ServerFailover) {
        self.server = failover.primary
        self.failover = failover
    }

    /// Open-Meteo's shape: one location -> the object; several -> an array.
    private struct Many: Decodable {
        var items: [Response]
        init(from decoder: Decoder) throws {
            if let array = try? [Response](from: decoder) { items = array } else { items = [try Response(from: decoder)] }
        }
    }

    private struct Response: Decodable {
        var hourly: [String: [Double?]]

        init(from decoder: Decoder) throws {
            // "time" is a [String]; skip it and keep the numeric series.
            let c = try decoder.container(keyedBy: AnyKey.self)
            let h = try c.nestedContainer(keyedBy: AnyKey.self, forKey: AnyKey("hourly"))
            var out: [String: [Double?]] = [:]
            for key in h.allKeys where key.stringValue != "time" {
                out[key.stringValue] = try h.decode([Double?].self, forKey: key)
            }
            hourly = out
        }
    }

    public func estimate(at origin: Coordinate, day: String, slot: SessionSlot,
                         today: String) async throws -> ForecastConfidence {
        try await estimate(at: origin, day: day, hours: slot.hours, today: today)
    }

    public func estimate(at origin: Coordinate, day: String, hours: ClosedRange<Int>,
                         today: String) async throws -> ForecastConfidence {
        if let failover {
            return try await failover.run { server in
                var e = self
                e.failover = nil
                e.server = server
                return try await e.estimate(at: origin, day: day, hours: hours, today: today)
            }
        }
        guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) }
        // The origin is usually the rider's own position: send only the area (0.1° ≈ 11 km,
        // finer than the compared models' grids), not where they are.
        let area = Coordinate(latitude: (origin.latitude * 10).rounded() / 10, longitude: (origin.longitude * 10).rounded() / 10)
        let hourly = try await series(at: [area], day: day)[0]
        return Self.confidence(hourly: hourly, models: models, hours: hours, leadDays: Self.daysBetween(today, day))
    }

    public func estimates(for queries: [ConfidenceQuery], day: String, today: String) async throws -> [ForecastConfidence] {
        guard !queries.isEmpty else { return [] }
        if let failover {
            return try await failover.run { server in
                var e = self
                e.failover = nil
                e.server = server
                return try await e.estimates(for: queries, day: day, today: today)
            }
        }
        guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) }
        // Spot positions are public: sent as they are (the server caches per position).
        let hourly = try await series(at: queries.map(\.coordinate), day: day)
        let lead = Self.daysBetween(today, day)
        return zip(hourly, queries).map { Self.confidence(hourly: $0, models: models, hours: $1.hours, leadDays: lead) }
    }

    /// The models grouped by the cell they're read on, in the order of `models`: one request per group.
    func requestGroups() -> [(cell: String, models: [String])] {
        var groups: [(cell: String, models: [String])] = []
        for m in models {
            let cell = cellByModel[m] ?? cellSelection
            if let i = groups.firstIndex(where: { $0.cell == cell }) { groups[i].models.append(m) }
            else { groups.append((cell, [m])) }
        }
        return groups
    }

    /// Hourly series per place, every model's series suffixed with its name, all groups merged.
    /// Every group must answer: a chance missing a model would silently change its level.
    private func series(at coords: [Coordinate], day: String) async throws -> [[String: [Double?]]] {
        let groups = requestGroups()
        let parts = try await withThrowingTaskGroup(of: (Int, [[String: [Double?]]]).self) { group in
            for (i, g) in groups.enumerated() {
                group.addTask { (i, try await self.request(coords, day: day, models: g.models, cell: g.cell)) }
            }
            var out = [[[String: [Double?]]]](repeating: [], count: groups.count)
            for try await (i, r) in group { out[i] = r }
            return out
        }
        return Self.merge(parts, groups: groups.map(\.models))
    }

    private func request(_ coords: [Coordinate], day: String, models: [String], cell: String) async throws -> [[String: [Double?]]] {
        var form = URLComponents()
        form.queryItems = [
            .init(name: "latitude", value: coords.map { String(format: "%.4f", $0.latitude) }.joined(separator: ",")),
            .init(name: "longitude", value: coords.map { String(format: "%.4f", $0.longitude) }.joined(separator: ",")),
            .init(name: "hourly", value: "wind_speed_10m,wind_direction_10m"),
            .init(name: "wind_speed_unit", value: "kn"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: day),
            .init(name: "end_date", value: day),
            .init(name: "models", value: models.joined(separator: ",")),
            .init(name: "cell_selection", value: cell),
        ]
        var req = URLRequest(url: server.endpoint(for: day))
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.httpBody = Data((form.percentEncodedQuery ?? "").utf8)
        let (data, response) = try await session.data(for: req)
        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw ForecastError.badResponse("HTTP \(http.statusCode) " + String(decoding: data.prefix(300), as: UTF8.self))
        }
        let items = try JSONDecoder().decode(Many.self, from: data).items
        guard items.count == coords.count else {
            throw ForecastError.badResponse("\(items.count) locations for \(coords.count)")
        }
        return items.map(\.hourly)
    }

    /// Merges per-group answers into one dictionary per place. A one-model request comes back
    /// without the model suffix (Open-Meteo's naming): it gets it here.
    static func merge(_ parts: [[[String: [Double?]]]], groups: [[String]]) -> [[String: [Double?]]] {
        guard let first = parts.first else { return [] }
        return first.indices.map { place in
            var out: [String: [Double?]] = [:]
            for (part, models) in zip(parts, groups) {
                guard let series = part[safe: place] else { continue }
                for (k, v) in series {
                    out[models.count == 1 && !k.hasSuffix("_" + models[0]) ? k + "_" + models[0] : k] = v
                }
            }
            return out
        }
    }

    /// Spread between the models over `hours`, turned into a 0–100 score. `modelsCompared` is
    /// empty when fewer than two models had plausible wind (nothing to compare).
    static func confidence(hourly: [String: [Double?]], models: [String], hours: ClosedRange<Int>,
                           leadDays: Int) -> ForecastConfidence {
        var speedSpreads: [Double] = []
        var dirSpreads: [Double] = []
        var used = Set<String>()
        for hour in hours {
            var speeds: [Double] = [], dirs: [Double] = []
            var hourModels: [String] = []
            for m in models {
                if let s = hourly["wind_speed_10m_\(m)"]?[safe: hour] ?? nil,
                   let d = hourly["wind_direction_10m_\(m)"]?[safe: hour] ?? nil,
                   HourlyWind.isPlausible(speedKn: s, gustKn: s, directionDeg: d) {
                    speeds.append(s); dirs.append(d); hourModels.append(m)
                }
            }
            guard speeds.count >= 2 else { continue }
            used.formUnion(hourModels)
            let mean = speeds.reduce(0, +) / Double(speeds.count)
            let sd = sqrt(speeds.map { ($0 - mean) * ($0 - mean) }.reduce(0, +) / Double(speeds.count))
            speedSpreads.append(sd)
            // Direction is meaningless in near-calm conditions.
            if mean >= 8 {
                // Convert circular spread (0...1) to an approximate angular deviation.
                let spread = Geo.circularStats(dirs).spread
                dirSpreads.append(sqrt(-2 * log(max(1e-6, 1 - spread))) * 180 / .pi)
            }
        }

        let speedSpread = speedSpreads.isEmpty ? 5 : speedSpreads.reduce(0, +) / Double(speedSpreads.count)
        let dirSpread = dirSpreads.isEmpty ? nil : dirSpreads.reduce(0, +) / Double(dirSpreads.count)

        var score = 100.0
        score -= Double(max(0, leadDays)) * 7       // accuracy drops with lead time
        score -= speedSpread * 7                     // ±3 kn disagreement ≈ -21
        if let d = dirSpread { score -= max(0, d - 15) * 0.6 }
        let s = Int(max(0, min(100, score)).rounded())
        let rating: ForecastConfidence.Rating = s >= 70 ? .high : s >= 45 ? .medium : .low

        var perModel: [String: [ModelWind]] = [:]
        for m in models {
            guard let speeds = hourly["wind_speed_10m_\(m)"], let dirs = hourly["wind_direction_10m_\(m)"] else { continue }
            let winds = speeds.indices.compactMap { h -> ModelWind? in
                guard let s = speeds[h], let d = dirs[safe: h] ?? nil,
                      HourlyWind.isPlausible(speedKn: s, gustKn: s, directionDeg: d) else { return nil }
                return ModelWind(hour: h, speedKn: s, directionDeg: d)
            }
            if !winds.isEmpty { perModel[m] = winds }
        }

        return ForecastConfidence(score: s, rating: rating, leadDays: leadDays,
                                  speedSpreadKn: speedSpread, directionSpreadDeg: dirSpread,
                                  modelsCompared: models.filter(used.contains), modelHours: perModel)
    }

    static func daysBetween(_ a: String, _ b: String) -> Int {
        let f = DayString.formatter(timeZone: TimeZone(identifier: "UTC")!)
        guard let da = f.date(from: a), let db = f.date(from: b) else { return 0 }
        return Int((db.timeIntervalSince(da) / 86400).rounded())
    }
}

private struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int? { nil }
    init(_ s: String) { stringValue = s }
    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { nil }
}

extension Array {
    subscript(safe i: Int) -> Element? { indices.contains(i) ? self[i] : nil }
}
