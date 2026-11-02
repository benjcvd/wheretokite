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
        case "storm nearby": String(localized: "storm next hour", comment: "A thunderstorm is forecast the following hour")
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

    /// The overall verdict next to a grade.
    static func verdict(_ v: KiteVerdict) -> String {
        switch v {
        case .go: String(localized: "Go", comment: "Verdict: grade 70 or more")
        case .worthATry: String(localized: "Worth a try", comment: "Verdict: grade 55 to 69")
        case .coinFlip: String(localized: "Coin flip", comment: "Verdict: grade 40 to 54")
        case .longShot: String(localized: "Long shot", comment: "Verdict: grade 20 to 39")
        case .noGo: String(localized: "No go", comment: "Verdict: grade under 20")
        }
    }

    /// "70–100": the grades of a verdict.
    static func verdictBand(_ v: KiteVerdict) -> String {
        let b = ScoringRules().verdictFromGrade
        return switch v {
        case .go: "\(b.go)–100"
        case .worthATry: "\(b.worthATry)–\(b.go - 1)"
        case .coinFlip: "\(b.coinFlip)–\(b.worthATry - 1)"
        case .longShot: "\(b.longShot)–\(b.coinFlip - 1)"
        case .noGo: "0–\(b.longShot - 1)"
        }
    }

    /// What a verdict means, in one line.
    static func verdictMeaning(_ v: KiteVerdict) -> String {
        switch v {
        case .go: String(localized: "Good session expected.")
        case .worthATry: String(localized: "Most likely good, but we can't be sure.")
        case .coinFlip: String(localized: "Could go either way.")
        case .longShot: String(localized: "Probably not. Only if you don't want to miss any chance.")
        case .noGo: String(localized: "Not worth it, or unsafe.")
        }
    }

    /// Why the weather models held the grade down, when they did.
    static func windReason(_ outlook: WindOutlook?, capped: Bool) -> String? {
        switch outlook {
        case .likely: String(localized: "The weather models agree on the wind.")
        case .uncertain where capped: String(localized: "The weather models aren't sure there will be enough wind for you.")
        case .unlikely where capped: String(localized: "The weather models see too little wind for you.")
        default: nil
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
