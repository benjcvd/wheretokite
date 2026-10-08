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

    public var summary: String {
        var parts = ["\(rating.rawValue) confidence (\(score)/100)",
                     leadDays < 0 ? "past day (archived forecast)" : leadDays == 0 ? "today" : "\(leadDays) day\(leadDays > 1 ? "s" : "") ahead",
                     String(format: "models agree within ±%.0f kn", speedSpreadKn)]
        if let d = directionSpreadDeg { parts.append(String(format: "±%.0f° direction", d)) }
        return parts.joined(separator: " · ")
    }
}

/// How much to trust the forecast: forecast accuracy drops with lead time, and when
/// independent models disagree the forecast is uncertain. One extra API call per search,
/// made at the search origin (the region, not each spot).
public struct ConfidenceEstimator: Sendable {
    public var models = ["ecmwf_ifs025", "gfs_seamless", "icon_seamless", "meteofrance_seamless"]
    public var session: URLSession = .shared

    public init() {}

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
        guard DayForecast.isValidDay(day) else { throw ForecastError.invalidDay(day) }
        var c = URLComponents(string: OpenMeteoProvider.endpoint(for: day))!
        c.queryItems = [
            .init(name: "latitude", value: String(format: "%.4f", origin.latitude)),
            .init(name: "longitude", value: String(format: "%.4f", origin.longitude)),
            .init(name: "hourly", value: "wind_speed_10m,wind_direction_10m"),
            .init(name: "wind_speed_unit", value: "kn"),
            .init(name: "timezone", value: "auto"),
            .init(name: "start_date", value: day),
            .init(name: "end_date", value: day),
            .init(name: "models", value: models.joined(separator: ",")),
            .init(name: "cell_selection", value: "sea"),
        ]
        let (data, _) = try await session.data(from: c.url!)
        let hourly = try JSONDecoder().decode(Response.self, from: data).hourly

        var speedSpreads: [Double] = []
        var dirSpreads: [Double] = []
        var used = Set<String>()
        for hour in slot.hours {
            var speeds: [Double] = [], dirs: [Double] = []
            for m in models {
                if let s = hourly["wind_speed_10m_\(m)"]?[safe: hour] ?? nil,
                   let d = hourly["wind_direction_10m_\(m)"]?[safe: hour] ?? nil,
                   HourlyWind.isPlausible(speedKn: s, gustKn: s, directionDeg: d) {
                    speeds.append(s); dirs.append(d); used.insert(m)
                }
            }
            guard speeds.count >= 2 else { continue }
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

        let leadDays = Self.daysBetween(today, day)
        let speedSpread = speedSpreads.isEmpty ? 5 : speedSpreads.reduce(0, +) / Double(speedSpreads.count)
        let dirSpread = dirSpreads.isEmpty ? nil : dirSpreads.reduce(0, +) / Double(dirSpreads.count)

        var score = 100.0
        score -= Double(max(0, leadDays)) * 7       // accuracy drops with lead time
        score -= speedSpread * 7                     // ±3 kn disagreement ≈ -21
        if let d = dirSpread { score -= max(0, d - 15) * 0.6 }
        let s = Int(max(0, min(100, score)).rounded())
        let rating: ForecastConfidence.Rating = s >= 70 ? .high : s >= 45 ? .medium : .low

        return ForecastConfidence(score: s, rating: rating, leadDays: leadDays,
                                  speedSpreadKn: speedSpread, directionSpreadDeg: dirSpread,
                                  modelsCompared: models.filter(used.contains))
    }

    static func daysBetween(_ a: String, _ b: String) -> Int {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
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
