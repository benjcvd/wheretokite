import Foundation

public struct SpotRecommendation: Sendable, Identifiable {
    public var id: String { spot.id }
    public var spot: Spot
    public var driveMinutes: Double
    /// Wind quality of the best session window, 0...100.
    public var windScore: Int
    /// Wind score adjusted for distance (if the user cares), used for ranking.
    public var finalScore: Int
    /// Best window, local hours [start, end).
    public var window: (start: Int, end: Int)?
    public var hours: [HourScore]
    public var reason: String

    /// Kite suggested for the best window.
    public var suggestedKite: KiteRange? {
        guard let window else { return nil }
        return hours.first { $0.wind.hour >= window.start && $0.kite != nil }?.kite
    }
}

public struct SearchResult: Sendable {
    public var request: SearchRequest
    public var confidence: ForecastConfidence?
    public var recommendations: [SpotRecommendation]
    /// Spots within straight-line reach that were dropped, with why.
    public var excluded: [(Spot, String)]
}

public struct Recommender: Sendable {
    public var spots: [Spot]
    public var forecast: ForecastProvider
    public var driveTime: DriveTimeProvider
    public var confidence: ConfidenceEstimator?
    public var rules = ScoringRules()

    public init(spots: [Spot], forecast: ForecastProvider, driveTime: DriveTimeProvider,
                confidence: ConfidenceEstimator? = ConfidenceEstimator()) {
        self.spots = spots
        self.forecast = forecast
        self.driveTime = driveTime
        self.confidence = confidence
    }

    public func search(_ request: SearchRequest, profile: RiderProfile, today: String) async throws -> SearchResult {
        // Cheap pre-filter: no road gets you there faster than ~110 km/h as the crow flies.
        let reachable = spots.filter {
            Geo.distanceKm(request.origin, $0.coordinate) / 110 * 60 <= request.maxDriveMinutes
        }

        async let drives = driveTime.driveMinutes(from: request.origin, to: reachable)
        async let conf: ForecastConfidence? = try? confidence?.estimate(
            at: request.origin, day: request.day, slot: request.slot, today: today)
        let driveMinutes = await drives

        var excluded: [(Spot, String)] = []
        let candidates = reachable.filter { spot in
            guard let m = driveMinutes[spot.id] else { excluded.append((spot, "no route")); return false }
            if m > request.maxDriveMinutes {
                excluded.append((spot, String(format: "%.0f min drive", m)))
                return false
            }
            return true
        }

        let forecasts = try await forecast.forecasts(for: candidates, day: request.day)
        let scorer = Scorer(profile: profile, intensity: request.intensity, rules: rules)

        var recs: [SpotRecommendation] = []
        for spot in candidates {
            guard let day = forecasts[spot.id] else { excluded.append((spot, "no forecast")); continue }
            let hours = day.hours
                .filter { request.slot.hours.contains($0.hour) }
                .map { scorer.score($0, seaFacingDeg: spot.seaFacingDeg) }
            let drive = driveMinutes[spot.id] ?? 0
            recs.append(recommend(spot, hours: hours, drive: drive, request: request))
        }
        recs.sort { ($0.finalScore, $0.windScore, -$0.driveMinutes) > ($1.finalScore, $1.windScore, -$1.driveMinutes) }

        return SearchResult(request: request, confidence: await conf, recommendations: recs, excluded: excluded)
    }

    func recommend(_ spot: Spot, hours: [HourScore], drive: Double, request: SearchRequest) -> SpotRecommendation {
        // Best run of `sessionHours` consecutive hours.
        let n = min(rules.sessionHours, hours.count)
        var bestStart = 0, bestMean = 0.0
        if n > 0 {
            for i in 0...(hours.count - n) {
                let mean = hours[i..<i + n].map(\.score).reduce(0, +) / Double(n)
                if mean > bestMean { bestMean = mean; bestStart = i }
            }
        }
        let windScore = Int((bestMean * 100).rounded())

        // Extend the window to all adjacent hours that are still good.
        var window: (Int, Int)?
        if bestMean >= 0.4 {
            let threshold = max(0.4, bestMean * 0.7)
            var lo = bestStart, hi = bestStart + n - 1
            while lo > 0, hours[lo - 1].score >= threshold { lo -= 1 }
            while hi < hours.count - 1, hours[hi + 1].score >= threshold { hi += 1 }
            window = (hours[lo].wind.hour, hours[hi].wind.hour + 1)
        }

        var final = bestMean
        if request.distanceMatters, request.maxDriveMinutes > 0 {
            final *= 1 - rules.maxDistancePenalty * min(1, drive / request.maxDriveMinutes)
        }

        return SpotRecommendation(
            spot: spot, driveMinutes: drive, windScore: windScore,
            finalScore: Int((final * 100).rounded()), window: window, hours: hours,
            reason: reason(hours: hours, bestStart: bestStart, n: n, window: window, drive: drive))
    }

    func reason(hours: [HourScore], bestStart: Int, n: Int, window: (Int, Int)?, drive: Double) -> String {
        let driveText = String(format: "%.0f min", drive)
        guard n > 0 else { return "no forecast · \(driveText)" }
        let slice = hours[bestStart..<bestStart + n]
        let speeds = slice.map(\.wind.speedKn), gusts = slice.map(\.wind.gustKn)
        let wind = String(format: "%.0f–%.0f kn (gusts %.0f)", speeds.min()!, speeds.max()!, gusts.max()!)
        let dir = Geo.compassName(Geo.circularStats(slice.map(\.wind.directionDeg)).mean)

        guard let window else {
            // Explain why it's not a go.
            let flags = Set(hours.flatMap(\.flags))
            let why = flags.contains("too light") ? "too light"
                : flags.contains("offshore component") ? "offshore"
                : flags.first ?? "poor conditions"
            return "\(why) · \(wind) \(dir) · \(driveText)"
        }

        let angles = slice.compactMap(\.relativeAngle)
        let side = angles.isEmpty ? "" : " " + Self.angleName(angles.reduce(0, +) / Double(angles.count))
        let kite = slice.compactMap(\.kite).first.map { String(format: " · %g m", $0.size) } ?? ""
        let extra = Set(slice.flatMap(\.flags)).sorted().map { " · ⚠︎ \($0)" }.joined()
        return String(format: "%02d:00–%02d:00 · ", window.0, window.1) + wind + " \(dir)\(side)\(kite) · \(driveText)\(extra)"
    }

    public static func angleName(_ a: Double) -> String {
        switch a {
        case ..<25: "onshore"
        case ..<70: "side-onshore"
        case ..<100: "cross-shore"
        case ..<130: "side-offshore"
        default: "offshore"
        }
    }
}
