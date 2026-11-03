import Foundation

// All tunable numbers live here so they can be calibrated against real sessions.
public struct ScoringRules: Sendable {
    /// Kite size rule of thumb: optimal wind (kn) ≈ factor × weight (kg) / size (m²).
    public var optimalWindFactor = 2.2
    /// Usable range of a kite as a fraction of its optimal wind.
    public var rangeLow = 0.8
    public var rangeHigh = 1.45
    /// Length of the session the spot score is based on (best consecutive hours).
    public var sessionHours = 2
    /// When distance matters, a spot at the max drive time loses this fraction of its score.
    public var maxDistancePenalty = 0.3
    /// A storm starting up to this many hours after the best window ends (or later in the
    /// searched hours) is announced on the spot: "Storm from 4 pm".
    public var stormAlertHoursAfter = 2
    /// The hour just before a storm hour keeps this share of its score: outflow gusts and
    /// cells arriving early. Light on purpose (Ben, 31 Oct): the alert does the warning.
    public var preStormFactor = 0.8

    public init() {}

    // MARK: Chance to kite (WHE-81 method, WHE-84 tuning: docs/MODEL_BACKTEST.md)

    /// chance = Φ((models' mean best 2 h − rider's min wind + bias) / √(spread² + error²)).
    /// Fitted per day ahead on France, southern Spain and the buoys (Catalan masts left out),
    /// Go cut-off tuned so a Go came true ≥ 85 % on the tuning weeks. Each lead had two fits
    /// (even / odd weeks): bias and error are their mean, the cut-off the stricter of the two.
    /// Days 5+ were never tested: day 4's numbers with a stricter cut-off.
    public func chanceTuning(leadDays: Int) -> ChanceTuning {
        switch max(0, leadDays) {
        case 0: ChanceTuning(biasKn: -0.25, errorKn: 2.0, goFrom: 0.68)
        case 1: ChanceTuning(biasKn: -0.25, errorKn: 2.25, goFrom: 0.73)
        case 2: ChanceTuning(biasKn: 0, errorKn: 2.5, goFrom: 0.70)
        case 3: ChanceTuning(biasKn: 0, errorKn: 2.75, goFrom: 0.79)
        case 4: ChanceTuning(biasKn: -1, errorKn: 4.5, goFrom: 0.71)
        default: ChanceTuning(biasKn: -1, errorKn: 5, goFrom: 0.80)
        }
    }

    /// Below the Go cut-off, wind is "uncertain" from this chance, "unlikely" under it
    /// (WHE-84: no promise attached to the middle band; a 70 % band didn't hold up).
    public var uncertainWindFrom = 0.40

    /// Highest grade a spot keeps when the wind is uncertain / unlikely: so uncertain wind is at
    /// best "Worth a try" and unlikely wind at best a "Long shot".
    public var uncertainWindMaxScore = 69
    public var unlikelyWindMaxScore = 39

    /// Lowest final grade of each verdict (Ben, 2 Nov); "No go" below `longShot`.
    public var verdictFromGrade = (go: 70, worthATry: 50, longShot: 20)

    /// Tides smaller than this (m, low to high water over the day) are ignored.
    public var minTidalRange = 0.5

    /// Score factor for a spot's tide rule at a tide state `f` (0 = the day's low water,
    /// 1 = high water). Edges ramp over 0.15 so a window doesn't flip on one hour.
    public func tideFactor(rule: String, f: Double) -> Double {
        func atLeast(_ x: Double) -> Double { min(1, max(0, (f - (x - 0.15)) / 0.15)) }
        func atMost(_ x: Double) -> Double { min(1, max(0, ((x + 0.15) - f) / 0.15)) }
        switch rule {
        case "high": return atLeast(0.6)
        case "low": return atMost(0.4)
        case "not-low": return atLeast(0.3)
        case "not-high": return atMost(0.7)
        case "mid": return min(atLeast(0.25), atMost(0.75))
        default: return 1
        }
    }

    /// Hard safety limits: (max mean wind, max gust) in knots. The mean-wind limit is fixed
    /// per level. The gust limit is fixed for beginners and rises with session intensity for
    /// intermediate and advanced riders (Ben, 31 Oct 2026): forecast gusts run at 1.6–1.9×
    /// the mean, so a fixed 34 kn shut intermediates out from about 19 kn of mean wind.
    /// `intensity`: 0 chill … 1 intense, nil = all types (counts as 0.5).
    public func limits(_ level: Level, intensity: Double? = nil) -> (wind: Double, gust: Double) {
        let i = min(1, max(0, intensity ?? 0.5))
        return switch level {
        case .beginner: (20, 25)
        case .intermediate: (28, 34 + 6 * i)
        case .advanced: (40, 48 + 6 * i)
        }
    }

    /// Gust excess ((gust − mean) / mean) tolerated before the steady-wind factor drops.
    /// Calibrated on the forecast, not on station gusts: across the WHE-64 Barcelona days the
    /// blend gives gusts at 1.75× the mean on a typical hour (1.5–2.1×), so "gusty" means
    /// gustier than that. Beginners are strictest, advanced riders and intense sessions most
    /// lenient. Excess 0.8 = gusts at 1.8× the mean.
    public func gustTolerance(_ level: Level, intensity: Double?) -> Double {
        let i = min(1, max(0, intensity ?? 0.5))
        return switch level {
        case .beginner: 0.55 + 0.15 * i
        case .intermediate: 0.7 + 0.2 * i
        case .advanced: 0.8 + 0.3 * i
        }
    }

    /// Steady-wind factor lost per unit of gust excess beyond the tolerance (floor 0.3).
    public func gustPenaltySlope(_ level: Level) -> Double {
        switch level {
        case .beginner: 2
        case .intermediate: 1.5
        case .advanced: 1
        }
    }

    /// The "gusty" label shows when the steady-wind factor falls below this.
    public var gustyFlagBelow = 0.9

    /// How far (kn) gusts may exceed the kite's top wind before the hour is "overpowered in
    /// gusts". Fixed for beginners, wider for advanced riders and intense sessions.
    public func gustOverpowerMarginKn(_ level: Level, intensity: Double?) -> Double {
        let i = min(1, max(0, intensity ?? 0.5))
        return switch level {
        case .beginner: 5
        case .intermediate: 5 + 4 * i
        case .advanced: 8 + 4 * i
        }
    }

    /// Wind angle to the beach (0° onshore, 90° side-shore, 180° offshore) up to which a wind
    /// still counts as side-shore: a 10° margin for the beach orientation and forecast direction.
    public var sideShoreMaxDeg = 100.0
    /// From here on the wind is offshore and scores 0 for everyone (side-offshore = between
    /// `sideShoreMaxDeg` and this, only for riders who accept it). About 45° past side-shore;
    /// lagoons and points reach it later through their catalogue water sector.
    public var offshoreFromDeg = 130.0

    /// Score for the angle between wind and beach. 0° = straight onshore,
    /// 90° = cross-shore, 180° = straight offshore (dangerous: blows you out to sea).
    /// Riders who don't accept side-offshore drop to 0 at `sideShoreMaxDeg`; the others at
    /// `offshoreFromDeg`.
    public func directionScore(relativeAngle a: Double, level: Level,
                               offshore: OffshoreTolerance = .sideShoreOnly) -> Double {
        let upToSideShore: [(Double, Double)] = switch level {
        case .beginner: [(0, 0.55), (30, 0.9), (45, 1), (65, 1), (90, 0.6)]
        case .intermediate: [(0, 0.55), (30, 0.9), (45, 1), (65, 1), (90, 0.85)]
        case .advanced: [(0, 0.6), (30, 0.9), (45, 1), (70, 1), (90, 0.9)]
        }
        let tail: [(Double, Double)] = offshore == .sideOffshore && level != .beginner
            ? [(offshoreFromDeg - 15, 0.4), (offshoreFromDeg, 0), (180, 0)]
            : [(sideShoreMaxDeg, 0), (180, 0)]
        return interpolate(upToSideShore + tail, a)
    }
}

public struct KiteRange: Sendable, Equatable {
    public var size: Double
    public var minKn: Double
    public var optimalKn: Double
    public var maxKn: Double

    public static func make(size: Double, weightKg: Double, rules: ScoringRules = .init()) -> KiteRange {
        let opt = rules.optimalWindFactor * weightKg / size
        return KiteRange(size: size, minKn: opt * rules.rangeLow, optimalKn: opt, maxKn: opt * rules.rangeHigh)
    }
}

public struct HourScore: Sendable {
    public var wind: HourlyWind
    public var score: Double           // 0...1
    public var kite: KiteRange?
    public var relativeAngle: Double?  // 0 onshore … 180 offshore
    public var flags: [String]
    /// Side of a multi-sided spot this hour was scored on (nil for single-sided spots).
    public var side: String?
    /// The factors behind `score` (0…1, before the rider's weights), for the explanation.
    /// nil when a hard limit decided (too light / too strong).
    public var strengthFactor: Double?
    public var steadinessFactor: Double?
    public var directionFactor: Double?
    /// Tide window factor (nil = no tide rule / no tide data).
    public var tideFactor: Double?
}

public struct Scorer: Sendable {
    public var rules: ScoringRules
    public var profile: RiderProfile
    /// 0 chill … 1 intense, nil = all types.
    public var intensity: Double?

    public init(profile: RiderProfile, intensity: Double?, rules: ScoringRules = .init()) {
        self.profile = profile
        self.intensity = intensity
        self.rules = rules
    }

    public var kiteRanges: [KiteRange] {
        profile.kites.map { KiteRange.make(size: $0, weightKg: profile.weightKg, rules: rules) }
    }

    /// Scores the hour on each side and keeps the best one. Ties (e.g. too light everywhere)
    /// go to the side where the wind is most onshore, the safest one.
    public func score(_ w: HourlyWind, sides: [SpotSide]) -> HourScore {
        guard sides.count > 1 else {
            return sides.first.map { score(w, side: $0) } ?? score(w, relativeAngle: nil)
        }
        return Self.best(sides.map { side -> HourScore in
            var h = score(w, side: side)
            h.side = side.name
            return h
        })
    }

    /// One shore with its water sector (see `Spot.waterSectorDeg`):
    /// - 180: the angle between the wind and the beach normal.
    /// - < 180 (cove): open water only within ±sector/2, so the sector's edges count as
    ///   cross-shore and winds beyond them as increasingly offshore.
    /// - > 180 (point, headland, small lake): the shore curves, so its normals span
    ///   2 × (sector − 180) (360° at 360); the best-placed part of the shore is used.
    public func score(_ w: HourlyWind, side: SpotSide) -> HourScore {
        let sector = min(360, max(0, side.waterSectorDeg ?? 180))
        let off = Geo.angleDiff(w.directionDeg, side.seaFacingDeg)
        if sector <= 180 {
            return score(w, relativeAngle: min(180, max(0, off - sector / 2 + 90)))
        }
        let span = min(360, 2 * (sector - 180))
        let steps = max(1, Int((span / 5).rounded(.up)))
        let normals = (0...steps).map { side.seaFacingDeg - span / 2 + span * Double($0) / Double(steps) }
        return Self.best(normals.map { score(w, relativeAngle: Geo.angleDiff(w.directionDeg, $0)) })
    }

    /// Highest score; ties (e.g. too light everywhere) go to the most onshore, safest angle.
    static func best(_ hours: [HourScore]) -> HourScore {
        hours.min { a, b in
            a.score != b.score ? a.score > b.score : (a.relativeAngle ?? 180) < (b.relativeAngle ?? 180)
        }!
    }

    public func score(_ w: HourlyWind, seaFacingDeg: Double?) -> HourScore {
        score(w, relativeAngle: seaFacingDeg.map { Geo.angleDiff(w.directionDeg, $0) })
    }

    /// `angle`: 0 onshore … 180 offshore; nil = beach orientation unknown.
    public func score(_ w: HourlyWind, relativeAngle angle: Double?) -> HourScore {
        var flags: [String] = []
        let limits = rules.limits(profile.level, intensity: intensity)
        if w.speedKn > limits.wind || w.gustKn > limits.gust {
            return HourScore(wind: w, score: 0, kite: nil, relativeAngle: angle, flags: ["too strong for level"])
        }

        // 1. Strength: pick the kite in the quiver that fits this wind best.
        var best: (KiteRange, Double)?
        for k in kiteRanges where w.speedKn >= k.minKn && w.speedKn <= k.maxKn {
            let s = strengthScore(w.speedKn, kite: k)
            if best == nil || s > best!.1 { best = (k, s) }
        }
        guard let (kite, strength) = best else {
            let tooLight = w.speedKn < (kiteRanges.map(\.minKn).min() ?? 0)
            return HourScore(wind: w, score: 0, kite: nil, relativeAngle: angle,
                             flags: [tooLight ? "too light" : "too strong for quiver"])
        }

        // 2. Gustiness: beginners and chill sessions want steady wind; advanced riders and
        // intense sessions tolerate more (tolerances in ScoringRules).
        let gustFactor = (w.gustKn - w.speedKn) / max(w.speedKn, 1)
        let tolerance = rules.gustTolerance(profile.level, intensity: intensity)
        var gust = gustFactor <= tolerance ? 1
            : max(0.3, 1 - (gustFactor - tolerance) * rules.gustPenaltySlope(profile.level))
        // Flag only when it costs something visible, so "gusty" tells a gusty day from a normal one.
        if gust < rules.gustyFlagBelow { flags.append("gusty") }
        if w.gustKn > kite.maxKn + rules.gustOverpowerMarginKn(profile.level, intensity: intensity) {
            gust *= profile.level == .beginner ? 0.4 : 0.75
            flags.append("overpowered in gusts")
        }

        // 3. Direction relative to the beach.
        var direction = 0.6   // unknown orientation: neutral-ish, flagged
        if let angle {
            direction = rules.directionScore(relativeAngle: angle, level: profile.level,
                                             offshore: profile.offshoreTolerance)
            if direction == 0 && angle >= 90 { flags.append("offshore component") }
            else if angle >= rules.sideShoreMaxDeg { flags.append("side-offshore") }
        } else {
            flags.append("beach orientation unknown")
        }

        // Rider's weights as exponents: 0 ignores a factor, 2 makes it count double. Offshore
        // (direction 0) stays 0 whatever the weight: that's safety, not taste.
        let wt = profile.scoreWeights
        let total = direction == 0 ? 0
            : pow(strength, wt.strength) * pow(gust, wt.steadiness) * pow(direction, wt.direction)
        var h = HourScore(wind: w, score: total, kite: kite, relativeAngle: angle, flags: flags)
        h.strengthFactor = strength
        h.steadinessFactor = gust
        h.directionFactor = direction
        return h
    }

    /// Where in the kite's range the rider wants to be: chill = lower-middle, intense = top.
    func strengthScore(_ kn: Double, kite: KiteRange) -> Double {
        let p = (kn - kite.minKn) / (kite.maxKn - kite.minKn)   // 0 = barely powered, 1 = max
        guard let intensity else {
            // All types: anything comfortably inside the range is fine.
            return p < 0.15 ? 0.6 + p / 0.15 * 0.4 : p > 0.9 ? 0.8 : 1
        }
        let ideal = 0.3 + 0.45 * intensity
        let d = abs(p - ideal) / 0.75
        return max(0.35, 1 - 0.65 * d * d)
    }
}

func interpolate(_ points: [(Double, Double)], _ x: Double) -> Double {
    guard let first = points.first, x > first.0 else { return points.first?.1 ?? 0 }
    for (a, b) in zip(points, points.dropFirst()) where x <= b.0 {
        return a.1 + (b.1 - a.1) * (x - a.0) / (b.0 - a.0)
    }
    return points.last!.1
}
