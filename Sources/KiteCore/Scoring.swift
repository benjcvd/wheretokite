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

    public init() {}

    /// Hard safety limits per level: (max mean wind, max gust) in knots.
    public func limits(_ level: Level) -> (wind: Double, gust: Double) {
        switch level {
        case .beginner: (20, 25)
        case .intermediate: (28, 34)
        case .advanced: (40, 48)
        }
    }

    /// Score for the angle between wind and beach. 0° = straight onshore,
    /// 90° = cross-shore, 180° = straight offshore (dangerous: blows you out to sea).
    public func directionScore(relativeAngle a: Double, level: Level) -> Double {
        let curve: [(Double, Double)] = switch level {
        case .beginner:
            [(0, 0.55), (30, 0.9), (45, 1), (65, 1), (90, 0.6), (100, 0), (180, 0)]
        case .intermediate:
            [(0, 0.55), (30, 0.9), (45, 1), (65, 1), (90, 0.85), (110, 0.3), (125, 0), (180, 0)]
        case .advanced:
            [(0, 0.6), (30, 0.9), (45, 1), (70, 1), (90, 0.9), (115, 0.4), (130, 0), (180, 0)]
        }
        return interpolate(curve, a)
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

    public func score(_ w: HourlyWind, seaFacingDeg: Double?) -> HourScore {
        var flags: [String] = []
        let angle = seaFacingDeg.map { Geo.angleDiff(w.directionDeg, $0) }
        let limits = rules.limits(profile.level)
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

        // 2. Gustiness: chill sessions want steady wind, intense ones tolerate more.
        let gustFactor = (w.gustKn - w.speedKn) / max(w.speedKn, 1)
        var tolerance = 0.3 + 0.2 * (intensity ?? 0.5)
        if profile.level == .beginner { tolerance -= 0.05 }
        if profile.level == .advanced { tolerance += 0.1 }
        var gust = gustFactor <= tolerance ? 1 : max(0.3, 1 - (gustFactor - tolerance) * 1.5)
        if gustFactor > tolerance { flags.append("gusty") }
        if w.gustKn > kite.maxKn + 5 {
            gust *= profile.level == .beginner ? 0.4 : 0.75
            flags.append("overpowered in gusts")
        }

        // 3. Direction relative to the beach.
        var direction = 0.6   // unknown orientation: neutral-ish, flagged
        if let angle {
            direction = rules.directionScore(relativeAngle: angle, level: profile.level)
            if angle >= 100 { flags.append("offshore component") }
        } else {
            flags.append("beach orientation unknown")
        }

        return HourScore(wind: w, score: strength * gust * direction, kite: kite, relativeAngle: angle, flags: flags)
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
