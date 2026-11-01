import Foundation

/// The plain answer next to a spot's grade: will there be enough wind to ride?
public enum KiteVerdict: String, Sendable, CaseIterable {
    case go = "Go"
    case notSure = "Not sure"
    case no = "No"
}

/// How likely a spot is kiteable for this rider in the searched hours, from how far the weather
/// models sit above the rider's minimum wind and how much they disagree (WHE-81's agreement rule,
/// cut-offs tuned in WHE-84: a Go came true about 85 % of the time on unseen weeks).
public struct KiteChance: Sendable {
    /// 0…1.
    public var chance: Double
    public var verdict: KiteVerdict
    public var leadDays: Int
    /// The rider's lowest usable wind (smallest kite's bottom), kn.
    public var minWindKn: Double
    /// Each model's best `sessionHours` of wind the rider can use (offshore hours count 0), kn.
    public var modelBestKn: [String: Double]

    public var meanKn: Double { modelBestKn.isEmpty ? 0 : modelBestKn.values.reduce(0, +) / Double(modelBestKn.count) }
    /// Spread between the models (population standard deviation), kn.
    public var spreadKn: Double {
        let m = meanKn
        let n = Double(max(1, modelBestKn.count))
        return sqrt(modelBestKn.values.map { ($0 - m) * ($0 - m) }.reduce(0, +) / n)
    }

    public var percent: Int { Int((chance * 100).rounded()) }

    public var summary: String {
        String(format: "%@ (%d %%) · models' best %.0f kn ±%.0f vs %.0f kn needed", verdict.rawValue, percent,
               meanKn, spreadKn, minWindKn)
    }
}

/// The tuned numbers for one lead time.
public struct ChanceTuning: Sendable, Equatable {
    /// Added to the models' mean before comparing to the minimum wind, kn.
    public var biasKn: Double
    /// Error the models share even when they agree, kn.
    public var errorKn: Double
    /// Lowest chance shown as Go.
    public var goFrom: Double
}

extension Scorer {
    /// Chance from each model's hourly wind. `hours`: the local hours that may count (searched
    /// hours that safety didn't close). nil when fewer than two models have the hours.
    public func kiteChance(models: [String: [ModelWind]], sides: [SpotSide], hours: Set<Int>,
                           leadDays: Int) -> KiteChance? {
        guard let minWind = kiteRanges.map(\.minKn).min(), let probe = kiteRanges.first?.optimalKn else { return nil }
        let n = max(1, rules.sessionHours)
        var best: [String: Double] = [:]
        for (model, winds) in models {
            let byHour = Dictionary(winds.map { ($0.hour, $0) }, uniquingKeysWith: { a, _ in a })
            var top: Double?
            for start in hours.sorted() {
                let run = (start..<(start + n)).compactMap { byHour[$0] }
                guard run.count == n, run.allSatisfy({ hours.contains($0.hour) }) else { continue }
                let usable = run.map { w -> Double in
                    // Direction only: is this wind one the rider can ride here (not offshore)?
                    let h = score(HourlyWind(localTime: "", speedKn: probe, gustKn: probe, directionDeg: w.directionDeg),
                                  sides: sides)
                    return (h.directionFactor ?? 0) > 0 ? w.speedKn : 0
                }
                let mean = usable.reduce(0, +) / Double(n)
                top = max(top ?? mean, mean)
            }
            if let top { best[model] = top }
        }
        guard best.count >= 2 else { return nil }
        let t = rules.chanceTuning(leadDays: leadDays)
        var c = KiteChance(chance: 0, verdict: .no, leadDays: leadDays, minWindKn: minWind, modelBestKn: best)
        let z = (c.meanKn - minWind + t.biasKn) / sqrt(c.spreadKn * c.spreadKn + t.errorKn * t.errorKn)
        c.chance = Self.phi(z)
        c.verdict = c.chance >= t.goFrom ? .go : c.chance >= rules.notSureFrom ? .notSure : .no
        return c
    }

    /// Standard normal cumulative distribution.
    static func phi(_ z: Double) -> Double { 0.5 * erfc(-z / 2.squareRoot()) }
}
