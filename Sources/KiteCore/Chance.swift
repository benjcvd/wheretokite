import Foundation

/// The overall decision next to a spot's grade, read straight off the final grade (Ben, 2 Nov):
/// 70–100 Go, 50–69 Worth a try, 20–49 Long shot, 0–19 No go. The wind chance
/// only caps the grade (`WindOutlook`), so a Go needs both likely wind and good conditions.
public enum KiteVerdict: String, Sendable, CaseIterable {
    /// Everything lines up: expect a good session.
    case go = "Go"
    /// Looks promising, but the forecast can still shift.
    case worthATry = "Worth a try"
    /// Probably not enough, but there's an outside chance.
    case longShot = "Long shot"
    /// Not worth the trip (or unsafe: `SpotRecommendation.safetyReason`).
    case noGo = "No go"

    public init(grade: Int, rules: ScoringRules = .init()) {
        let b = rules.verdictFromGrade
        self = grade >= b.go ? .go : grade >= b.worthATry ? .worthATry : grade >= b.longShot ? .longShot : .noGo
    }
}

/// What the weather models say about getting enough wind.
public enum WindOutlook: String, Sendable, CaseIterable {
    /// Above the tuned cut-off for that day ahead (a Go came true ~85 % in WHE-84's tests).
    case likely
    /// From `ScoringRules.uncertainWindFrom` up to the cut-off: grade capped at 69 (Worth a try at best).
    case uncertain
    /// Below that: grade capped at 39 (Long shot at best).
    case unlikely
}

/// How likely a spot is kiteable for this rider in the searched hours, from how far the weather
/// models sit above the rider's minimum wind and how much they disagree (WHE-81's agreement rule,
/// cut-offs tuned in WHE-84: a Go came true about 85 % of the time on unseen weeks).
public struct KiteChance: Sendable {
    /// 0…1.
    public var chance: Double
    public var outlook: WindOutlook
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

    /// Set when the chance cleared the Go cut-off but Go isn't promised here (the wind is then
    /// `uncertain`: Worth a try at best). The app says why.
    public var goHeldBack: GoHeldBack? = nil

    public var percent: Int { Int((chance * 100).rounded()) }

    public var summary: String {
        var s = String(format: "wind %@ (%d %%) · models' best %.0f kn ±%.0f vs %.0f kn needed", outlook.rawValue, percent,
                       meanKn, spreadKn, minWindKn)
        if let goHeldBack { s += " · no Go: \(goHeldBack.rawValue)" }
        return s
    }
}

/// Why a Go is held back even though the models agree on enough wind.
public enum GoHeldBack: String, Sendable, CaseIterable {
    /// More than `GoPolicy.lastGoLead` days ahead: in WHE-81 a Go at +4/+5 came true only
    /// 62–67 % in the Mediterranean and on open coast (Ben, 2 Nov: no Go beyond +3).
    case tooFarAhead = "too far ahead to promise"
    /// A region where no Go has been checked against wind on the water or real sessions yet.
    case notCheckedHere = "not checked on the water here yet"
}

/// Where and how far ahead the chance may say Go (Ben's pick on WHE-81, 2 Nov: labels today to
/// +3 days, softer beyond, Catalonia only after a water or session check).
public struct GoPolicy: Sendable, Equatable {
    /// Last day ahead (0 = today) a Go can be shown.
    public var lastGoLead = 3
    /// `Spot.region` values where Go waits for a check. Catalonia: its weather-service masts
    /// read about half the forecast, so WHE-81/84 couldn't verify a Go there; Barcelona's open
    /// port masts (WHE-86) are the only partial check so far.
    public var uncheckedRegions: Set<String> = ["Catalunya"]

    public init() {}

    public func heldBack(leadDays: Int, region: String?) -> GoHeldBack? {
        if leadDays > lastGoLead { return .tooFarAhead }
        if let region, uncheckedRegions.contains(region) { return .notCheckedHere }
        return nil
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
                           leadDays: Int, region: String? = nil, policy: GoPolicy = .init()) -> KiteChance? {
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
        var c = KiteChance(chance: 0, outlook: .unlikely, leadDays: leadDays, minWindKn: minWind, modelBestKn: best)
        let z = (c.meanKn - minWind + t.biasKn) / sqrt(c.spreadKn * c.spreadKn + t.errorKn * t.errorKn)
        c.chance = Self.phi(z)
        c.outlook = c.chance >= t.goFrom ? .likely : c.chance >= rules.uncertainWindFrom ? .uncertain : .unlikely
        if c.outlook == .likely, let why = policy.heldBack(leadDays: leadDays, region: region) {
            c.outlook = .uncertain
            c.goHeldBack = why
        }
        return c
    }

    /// Standard normal cumulative distribution.
    static func phi(_ z: Double) -> Double { 0.5 * erfc(-z / 2.squareRoot()) }
}
