import Foundation

/// Which weather models a forecast comes from, named the way Windguru or Windy name them, so
/// a rider can line a spot up with another app in one glance (WHE-57).
///
/// Météo-France "seamless" is AROME 1.3 km for about the next 40 h where AROME covers the
/// spot, ARPEGE 11 km elsewhere and after that (measured on Open-Meteo, 16 Nov 2026: AROME HD
/// to now + 43 h at Sant Pere and Quiberon, ARPEGE Europe all the way at Tarifa and Essaouira).
/// AROME's footprint is irregular, so coverage is a per-spot list (`AromeCoverage`).
public enum ForecastSource {
    /// Hours ahead Météo-France seamless still reads AROME: runs every 3 h, 48 h long, out a
    /// few hours late, so at worst it reaches now + ~40 h. A few hours past that may still be
    /// AROME but get labelled ARPEGE.
    static let aromeHorizon: TimeInterval = 40 * 3600

    static let seamless = "meteofrance_seamless"
    static let arome = "meteofrance_arome_france_hd"
    static let arpege = "meteofrance_arpege_europe"

    /// `ids` with Météo-France seamless replaced by the model behind it for this hour.
    /// Unknown coverage (spot added after `AromeCoverage` was generated) stays "seamless"
    /// within the AROME horizon.
    static func resolve(_ ids: [String], spotId: String, localTime: String, utcOffsetSeconds: Int,
                        now: Date) -> [String] {
        guard ids.contains(seamless) else { return ids }
        let resolved: String
        if AromeCoverage.outside.contains(spotId) {
            resolved = arpege
        } else if let start = utcStart(localTime, offsetSeconds: utcOffsetSeconds),
                  start.timeIntervalSince(now) > aromeHorizon {
            resolved = arpege
        } else {
            resolved = AromeCoverage.inside.contains(spotId) ? arome : seamless
        }
        return ids.map { $0 == seamless ? resolved : $0 }
    }

    /// Display name of an Open-Meteo model id.
    public static func name(_ id: String) -> String {
        switch id {
        case arome: "AROME 1.3 km"
        case "meteofrance_arome_france": "AROME 2.5 km"
        case arpege: "ARPEGE 11 km"
        case "meteofrance_arpege_world": "ARPEGE 25 km"
        case seamless: "Météo-France"
        case "ecmwf_ifs": "ECMWF 9 km"
        case "ecmwf_ifs025": "ECMWF 25 km"
        case "gfs_seamless", "gfs_global": "GFS"
        case "icon_seamless": "ICON"
        case "icon_eu": "ICON-EU 7 km"
        case "icon_d2": "ICON-D2 2 km"
        case "best_match": "Open-Meteo best match"
        default: id
        }
    }

    /// The provider alone ("ECMWF", "Météo-France"), for lines that list each model's value.
    public static func shortName(_ id: String) -> String {
        switch family(id) {
        case "meteofrance": "Météo-France"
        case "ecmwf": "ECMWF"
        case "gfs": "GFS"
        case "icon": "ICON"
        case "best_match": "Open-Meteo"
        default: id
        }
    }

    /// The models behind these hours, e.g. "AROME 1.3 km · ECMWF 9 km · GFS", or
    /// "AROME 1.3 km → ARPEGE 11 km · ECMWF 9 km · GFS" when Météo-France switches model
    /// within the hours. nil when no hour says (old cache).
    public static func summary(_ hours: [HourlyWind]) -> String? {
        var families: [(key: String, names: [String])] = []
        for id in hours.compactMap(\.models).joined() {
            let key = family(id), n = name(id)
            if let i = families.firstIndex(where: { $0.key == key }) {
                if !families[i].names.contains(n) { families[i].names.append(n) }
            } else {
                families.append((key, [n]))
            }
        }
        guard !families.isEmpty else { return nil }
        return families.map { $0.names.joined(separator: " → ") }.joined(separator: " · ")
    }

    /// Models in the same family are one provider switching model with lead time.
    static func family(_ id: String) -> String {
        for prefix in ["meteofrance", "ecmwf", "gfs", "icon"] where id.hasPrefix(prefix) { return prefix }
        return id
    }

    /// UTC start of a local hour "yyyy-MM-ddTHH:mm" (plain arithmetic: runs for every hour of
    /// every spot, a DateFormatter there costs real time).
    static func utcStart(_ localTime: String, offsetSeconds: Int) -> Date? {
        let p = localTime.split(whereSeparator: { "-T:".contains($0) }).compactMap { Int($0) }
        guard p.count >= 4, (1...12).contains(p[1]), (1...31).contains(p[2]) else { return nil }
        // Days from 1970-01-01 to a Gregorian date (H. Hinnant's days_from_civil).
        let y = p[1] <= 2 ? p[0] - 1 : p[0]
        let era = (y >= 0 ? y : y - 399) / 400
        let yoe = y - era * 400
        let doy = (153 * (p[1] + (p[1] > 2 ? -3 : 9)) + 2) / 5 + p[2] - 1
        let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
        let days = era * 146097 + doe - 719468
        let minutes = p.count > 4 ? p[4] : 0
        return Date(timeIntervalSince1970: Double(days * 86400 + p[3] * 3600 + minutes * 60 - offsetSeconds))
    }
}

extension SpotRecommendation {
    /// The models behind the hours this spot's score comes from (best window, else all its
    /// hours), for the spot detail screen. nil for old caches.
    public var forecastSource: String? {
        let window = (window ?? scoredHours).map { s in hours.filter { $0.wind.hour >= s.start && $0.wind.hour < s.end } } ?? []
        return ForecastSource.summary((window.isEmpty ? hours : window).map(\.wind))
            ?? ForecastSource.summary(hours.map(\.wind))
    }
}
