import Foundation
import KiteCore

/// The rider's language for the words KiteCore produces. The engine stays in English (CLI,
/// tests, flags used as keys); the app translates at display time.
enum Vocab {
    /// "N", "NNE"… in the rider's language (Spanish: O for west).
    static func compass(_ deg: Double) -> String {
        let names = String(localized: "N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW",
                           comment: "The 16 compass points from north clockwise, separated by single spaces")
            .split(separator: " ").map(String.init)
        guard names.count == 16 else { return Geo.compassName(deg) }
        let i = Int((deg.truncatingRemainder(dividingBy: 360) + 360 + 11.25) / 22.5) % 16
        return names[i]
    }

    /// Wind angle to the beach, as `Recommender.angleName`.
    static func angle(_ a: Double) -> String {
        switch Recommender.angleName(a) {
        case "onshore": String(localized: "onshore", comment: "Wind angle to the beach")
        case "side-onshore": String(localized: "side-onshore", comment: "Wind angle to the beach")
        case "cross-shore": String(localized: "cross-shore", comment: "Wind angle to the beach")
        case "side-offshore": String(localized: "side-offshore", comment: "Wind angle to the beach")
        default: String(localized: "offshore", comment: "Wind angle to the beach")
        }
    }

    /// An hour's flag or a spot's main problem, as KiteCore names them.
    static func term(_ flag: String) -> String {
        switch flag {
        case "too light": String(localized: "too light", comment: "Not enough wind")
        case "too strong for level": String(localized: "too strong for your level")
        case "too strong for quiver": String(localized: "too strong for your kites")
        case "gusty": String(localized: "gusty")
        case "overpowered in gusts": String(localized: "overpowered in gusts")
        case "offshore component", "offshore": String(localized: "offshore", comment: "Wind angle to the beach")
        case "beach orientation unknown": String(localized: "beach direction unknown")
        case "thunderstorm risk": String(localized: "thunderstorm risk")
        case "kiting banned": String(localized: "kiting banned")
        case "dark": String(localized: "dark", comment: "Before sunrise or after sunset")
        case "heavy rain": String(localized: "heavy rain")
        case "rain": String(localized: "rain")
        case "unstable air": String(localized: "unstable air", comment: "Risk of squalls")
        case "tide too low": String(localized: "tide too low")
        case "tide too high": String(localized: "tide too high")
        case "no forecast": String(localized: "no forecast")
        case "poor conditions": String(localized: "poor conditions")
        default: flag
        }
    }

    /// "W", "W & E", "all around", as `Spot.facingSummary`.
    static func facing(_ spot: Spot) -> String? {
        let sides = spot.allSides
        if sides.contains(where: { ($0.waterSectorDeg ?? 180) >= 360 }) {
            return String(localized: "all around", comment: "A spot open to water on every side")
        }
        return sides.isEmpty ? nil : sides.map { compass($0.seaFacingDeg) }.joined(separator: " & ")
    }

    /// "High 14:20 · Low 08:05, 20:35" from `Recommender.tideSummary`.
    static func tide(_ summary: String) -> String {
        summary.components(separatedBy: " · ").map { part in
            if part.hasPrefix("High ") { return String(localized: "High \(String(part.dropFirst(5)))", comment: "High tide times") }
            if part.hasPrefix("Low ") { return String(localized: "Low \(String(part.dropFirst(4)))", comment: "Low tide times") }
            return part
        }.joined(separator: " · ")
    }

    static func confidence(_ rating: ForecastConfidence.Rating) -> String {
        switch rating {
        case .high: String(localized: "High forecast confidence")
        case .medium: String(localized: "Medium forecast confidence")
        case .low: String(localized: "Low forecast confidence")
        }
    }

    /// Search errors in the rider's language; KiteCore's own messages are English.
    static func error(_ error: Error) -> String {
        switch error {
        case ForecastError.badResponse: String(localized: "The forecast service didn't answer properly. Try again in a minute.")
        case ForecastError.invalidDay: String(localized: "That day can't be forecast.")
        default: error.localizedDescription
        }
    }
}
