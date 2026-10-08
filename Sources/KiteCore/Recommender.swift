import Foundation

public struct SpotRecommendation: Sendable, Identifiable {
    public var id: String { spot.id }
    public var spot: Spot
    public var driveMinutes: Double
    /// True when `driveMinutes` is the straight-line estimate rather than a real route ETA
    /// (show it as "~").
    public var driveIsEstimate: Bool
    /// Wind quality of the best session window, 0...100.
    public var windScore: Int
    /// Wind score adjusted for distance (if the user cares), used for ranking.
    public var finalScore: Int
    /// Best window, local hours [start, end).
    public var window: (start: Int, end: Int)?
    public var hours: [HourScore]
    public var reason: String
    /// "High 14:20 · Low 08:05, 20:35" for spots with a tide rule (when the forecast has tides).
    public var tideSummary: String? = nil
    /// Share of the wind score kept after the drive penalty (1 = none), for the explanation.
    public var distanceFactor: Double = 1

    /// Kite suggested for the best window.
    public var suggestedKite: KiteRange? {
        guard let window else { return nil }
        return hours.first { $0.wind.hour >= window.start && $0.kite != nil }?.kite
    }
}

/// What a search cost, for diagnostics and quota monitoring.
public struct SearchStats: Sendable {
    /// Spots within straight-line reach (estimate ≤ max drive × `reachSlack`).
    public var inReach = 0
    /// Spots whose forecast was requested (after the `maxForecastSpots` cap).
    public var forecastSpots = 0
    /// Spots sent to the drive-time provider for a real ETA.
    public var etaRequested = 0
    /// Real ETAs received.
    public var etaReceived = 0
}

public struct SearchResult: Sendable {
    public var request: SearchRequest
    public var confidence: ForecastConfidence?
    public var recommendations: [SpotRecommendation]
    /// Spots within straight-line reach that were dropped, with why.
    public var excluded: [(Spot, String)]
    public var stats = SearchStats()
}

/// Ranks spots for a day.
///
/// Flow, designed for hundreds of spots and drives up to 10 h:
/// 1. Straight-line reach: keep spots whose estimated drive (`estimator`) is within
///    `reachSlack` × max drive — permissive, since the estimate may overshoot a real route.
/// 2. Cap: only the `maxForecastSpots` nearest are forecast (Open-Meteo quota).
/// 3. Forecast + score everything, with the estimate as provisional drive time.
/// 4. Verify: real ETAs (Apple Maps) only for the top `verifyTop` + `verifyMargin` scoring
///    spots; re-filter by max drive and re-rank. Repeat while unverified spots remain in the
///    top `verifyTop`, within `maxETARequests` per search (MapKit throttles ~50/min).
/// 5. Spots never verified keep the estimate (`driveIsEstimate`) and are dropped if it
///    exceeds the max drive.
public struct Recommender: Sendable {
    public var spots: [Spot]
    public var forecast: ForecastProvider
    public var driveTime: DriveTimeProvider
    public var confidence: ConfidenceEstimator?
    public var rules = ScoringRules()
    /// Islands only reachable by boat (`SpotCatalog.islands`). Their spots are searched only
    /// from the same island, and mainland spots only from the mainland.
    public var islands: [Island] = []

    /// Provisional drive times, and the reach pre-filter.
    public var estimator = StraightLineDriveTime()
    /// Spots whose estimate is up to 20 % over the max are still fetched and may be verified:
    /// the estimator overshoots real long motorway trips by up to ~15 %.
    public var reachSlack = 1.2
    /// Max spots forecast per search, nearest first. Each costs one Open-Meteo call
    /// (free tier: 600/min, 5,000/h, 10,000/day per IP): 400 keeps one uncached search
    /// under the per-minute limit and allows ~12 uncached searches an hour; the 2 h disk
    /// cache makes repeats free.
    public var maxForecastSpots = 400
    /// How many top-ranked spots must carry a real ETA.
    public var verifyTop = 25
    /// Extra spots verified in the first round, so spots promoted when a top spot turns out
    /// to be too far usually already have their ETA.
    public var verifyMargin = 10
    /// Hard cap on real ETA requests per search (MapKit throttles at ~50/min per app).
    public var maxETARequests = 45

    public init(spots: [Spot], forecast: ForecastProvider, driveTime: DriveTimeProvider,
                confidence: ConfidenceEstimator? = ConfidenceEstimator()) {
        self.spots = spots
        self.forecast = forecast
        self.driveTime = driveTime
        self.confidence = confidence
    }

    struct Candidate {
        var spot: Spot
        var km: Double
        var estimate: Double
        var hours: [HourScore] = []
        var rec: SpotRecommendation?
        var tideSummary: String?
    }

    /// Step 1–2: spots in straight-line reach, nearest first, capped. Returns the kept spots
    /// and the in-reach spots dropped by the cap.
    func reachable(from origin: Coordinate, maxDriveMinutes: Double, estimator: StraightLineDriveTime,
                   slack: Double) -> (kept: [Candidate], capped: [Candidate]) {
        var inReach: [Candidate] = []
        let originIsland = islands.first { $0.contains(origin) }?.id
        for spot in spots where Self.sameSideOfTheWater(spot, originIsland: originIsland, islands: islands) {
            let km = Geo.distanceKm(origin, spot.coordinate)
            let est = estimator.minutes(from: origin, to: spot)
            if est <= maxDriveMinutes * slack { inReach.append(Candidate(spot: spot, km: km, estimate: est)) }
        }
        inReach.sort { ($0.estimate, $0.spot.id) < ($1.estimate, $1.spot.id) }
        let n = max(0, maxForecastSpots)
        return (Array(inReach.prefix(n)), Array(inReach.dropFirst(n)))
    }

    /// Reachable without a boat: the spot is on the origin's island, or both are on the
    /// mainland. A ferry spot outside every known island outline is never reachable.
    static func sameSideOfTheWater(_ spot: Spot, originIsland: String?, islands: [Island]) -> Bool {
        let spotIsland = spot.island
            ?? islands.first { $0.contains(spot.coordinate) }?.id   // user spots
            ?? (spot.access == "ferry" ? "unknown island" : nil)
        return spotIsland == originIsland
    }

    static func ranks(_ a: SpotRecommendation, before b: SpotRecommendation) -> Bool {
        (a.finalScore, a.windScore, -a.driveMinutes) != (b.finalScore, b.windScore, -b.driveMinutes)
            ? (a.finalScore, a.windScore, -a.driveMinutes) > (b.finalScore, b.windScore, -b.driveMinutes)
            : a.spot.id < b.spot.id
    }

    /// Step 4: which spots to ask a real ETA for, given the current ranking (best first).
    /// Only when an unverified spot sits in the top `verifyTop` (scoring > 0); then all
    /// unverified spots of the top `verifyTop + margin`, at most `budget`.
    static func etaSelection(ranked: [SpotRecommendation], asked: Set<String>, verifyTop: Int,
                             margin: Int, budget: Int) -> [String] {
        let positive = ranked.filter { $0.finalScore > 0 }
        guard budget > 0, positive.prefix(verifyTop).contains(where: { !asked.contains($0.id) }) else { return [] }
        return Array(positive.prefix(verifyTop + margin).map(\.id).filter { !asked.contains($0) }.prefix(budget))
    }

    public func search(_ request: SearchRequest, profile: RiderProfile, today: String) async throws -> SearchResult {
        let maxDrive = request.maxDriveMinutes
        // A straight-line provider IS the estimate: use its calibration, no verify round.
        let estimatesOnly = driveTime.providesEstimates
        let estimator = (driveTime as? StraightLineDriveTime) ?? self.estimator
        var stats = SearchStats()
        var excluded: [(Spot, String)] = []

        let (reach, capped) = reachable(from: request.origin, maxDriveMinutes: maxDrive, estimator: estimator,
                                        slack: estimatesOnly ? 1 : reachSlack)
        stats.inReach = reach.count + capped.count
        stats.forecastSpots = reach.count
        excluded += capped.map { ($0.spot, "beyond the \(maxForecastSpots) nearest spots") }

        async let conf: ForecastConfidence? = try? confidence?.estimate(
            at: request.origin, day: request.day, slot: request.slot, today: today)

        var estimates = Dictionary(reach.map { ($0.spot.id, $0.estimate) }, uniquingKeysWith: { a, _ in a })
        if estimatesOnly, !(driveTime is StraightLineDriveTime) {
            estimates.merge(await driveTime.driveMinutes(from: request.origin, to: reach.map(\.spot))) { _, b in b }
        }

        let forecasts = try await forecast.forecasts(for: reach.map(\.spot), day: request.day)
        let scorer = Scorer(profile: profile, intensity: request.intensity, rules: rules)

        // Step 3: score everything with provisional drive times.
        var cands: [String: Candidate] = [:]
        for var c in reach {
            guard let day = forecasts[c.spot.id] else { excluded.append((c.spot, "no forecast")); continue }
            c.hours = day.hours
                .filter { request.slot.hours.contains($0.hour) }
                .map { scorer.score($0, sides: c.spot.allSides) }
            c.hours = Self.applyTide(c.spot.tide, to: c.hours, day: day.hours, rules: rules)
            c.estimate = estimates[c.spot.id] ?? c.estimate
            c.rec = recommend(c.spot, hours: c.hours, drive: c.estimate, request: request, driveIsEstimate: true,
                              weights: profile.scoreWeights)
            if c.spot.tide != nil { c.rec?.tideSummary = Self.tideSummary(day.hours, rules: rules) }
            c.tideSummary = c.rec?.tideSummary
            cands[c.spot.id] = c
        }

        // Step 4: verify the top candidates with real ETAs.
        if !estimatesOnly {
            var asked = Set<String>()
            var round = 0
            while true {
                let ranked = cands.values.compactMap(\.rec).sorted(by: Self.ranks)
                let ids = Self.etaSelection(ranked: ranked, asked: asked, verifyTop: verifyTop,
                                            margin: round == 0 ? verifyMargin : 0,
                                            budget: maxETARequests - stats.etaRequested)
                if ids.isEmpty { break }
                round += 1
                asked.formUnion(ids)
                stats.etaRequested += ids.count
                let real = await driveTime.driveMinutes(from: request.origin, to: ids.compactMap { cands[$0]?.spot })
                stats.etaReceived += real.count
                for (id, minutes) in real {
                    guard let c = cands[id] else { continue }
                    if minutes > maxDrive {
                        excluded.append((c.spot, Self.driveText(minutes) + " drive"))
                        cands[id] = nil
                    } else {
                        cands[id]?.rec = recommend(c.spot, hours: c.hours, drive: minutes, request: request,
                                                   driveIsEstimate: false, weights: profile.scoreWeights)
                        cands[id]?.rec?.tideSummary = c.tideSummary
                    }
                }
            }
        }

        // Step 5: unverified spots stand or fall on their estimate.
        var recs: [SpotRecommendation] = []
        for c in cands.values {
            guard let rec = c.rec else { continue }
            if rec.driveIsEstimate, rec.driveMinutes > maxDrive {
                excluded.append((c.spot, Self.driveText(rec.driveMinutes, estimate: true) + " drive (estimated)"))
            } else {
                recs.append(rec)
            }
        }
        recs.sort(by: Self.ranks)

        return SearchResult(request: request, confidence: await conf, recommendations: recs,
                            excluded: excluded, stats: stats)
    }

    func recommend(_ spot: Spot, hours: [HourScore], drive: Double, request: SearchRequest,
                   driveIsEstimate: Bool = false, weights: ScoreWeights = ScoreWeights()) -> SpotRecommendation {
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
        var distanceFactor = 1.0
        if request.distanceMatters, request.maxDriveMinutes > 0 {
            let penalty = rules.maxDistancePenalty * weights.distance
            distanceFactor = max(0, 1 - penalty * min(1, drive / request.maxDriveMinutes))
            final *= distanceFactor
        }

        var rec = SpotRecommendation(
            spot: spot, driveMinutes: drive, driveIsEstimate: driveIsEstimate, windScore: windScore,
            finalScore: Int((final * 100).rounded()), window: window, hours: hours,
            reason: reason(hours: hours, bestStart: bestStart, n: n, window: window,
                           driveText: Self.driveText(drive, estimate: driveIsEstimate)))
        rec.distanceFactor = distanceFactor
        return rec
    }

    /// "45 min", "7h05", "~3h20" (estimate).
    public static func driveText(_ minutes: Double, estimate: Bool = false) -> String {
        let m = Int(minutes.rounded())
        let text = m < 60 ? "\(m) min" : String(format: "%dh%02d", m / 60, m % 60)
        return (estimate ? "~" : "") + text
    }

    func reason(hours: [HourScore], bestStart: Int, n: Int, window: (Int, Int)?, driveText: String) -> String {
        guard n > 0 else { return "no forecast · \(driveText)" }
        let slice = hours[bestStart..<bestStart + n]
        let speeds = slice.map(\.wind.speedKn), gusts = slice.map(\.wind.gustKn)
        let wind = String(format: "%.0f–%.0f kn (gusts %.0f)", speeds.min()!, speeds.max()!, gusts.max()!)
        let dir = Geo.compassName(Geo.circularStats(slice.map(\.wind.directionDeg)).mean)

        guard let window else {
            // Explain why it's not a go.
            let flags = Set(hours.flatMap(\.flags))
            let why = flags.contains("too light") ? "too light"
                : flags.contains("tide too low") ? "tide too low"
                : flags.contains("tide too high") ? "tide too high"
                : flags.contains("offshore component") ? "offshore"
                : flags.first ?? "poor conditions"
            return "\(why) · \(wind) \(dir) · \(driveText)"
        }

        let angles = slice.compactMap(\.relativeAngle)
        let side = angles.isEmpty ? "" : " " + Self.angleName(angles.reduce(0, +) / Double(angles.count))
        let kite = slice.compactMap(\.kite).first.map { String(format: " · %g m", $0.size) } ?? ""
        let sideName = Self.mainSide(slice).map { " · \($0)" } ?? ""
        let extra = Set(slice.flatMap(\.flags)).sorted().map { " · ⚠︎ \($0)" }.joined()
        return String(format: "%02d:00–%02d:00 · ", window.0, window.1) + wind + " \(dir)\(side)\(sideName)\(kite) · \(driveText)\(extra)"
    }

    /// Tide state per hour from the day's sea levels: 0 = low water, 1 = high water. nil when
    /// the forecast has no tide or the tide is too small to matter.
    static func tideStates(_ day: [HourlyWind], rules: ScoringRules) -> [String: Double]? {
        let levels = day.compactMap(\.seaLevelM)
        guard let lo = levels.min(), let hi = levels.max(), hi - lo >= rules.minTidalRange else { return nil }
        var out: [String: Double] = [:]
        for h in day { if let m = h.seaLevelM { out[h.localTime] = (m - lo) / (hi - lo) } }
        return out
    }

    /// Scales each hour by the spot's tide window; hours outside it score 0 with a flag.
    static func applyTide(_ rule: String?, to hours: [HourScore], day: [HourlyWind], rules: ScoringRules) -> [HourScore] {
        guard let rule, let states = tideStates(day, rules: rules) else { return hours }
        return hours.map { h in
            guard let f = states[h.wind.localTime] else { return h }
            let k = rules.tideFactor(rule: rule, f: f)
            guard k < 1 else { var h = h; h.tideFactor = 1; return h }
            var h = h
            h.tideFactor = k
            if h.score > 0 { h.flags.append(f < 0.5 ? "tide too low" : "tide too high") }
            h.score *= k
            return h
        }
    }

    /// "High 14:20 · Low 08:05, 20:35": hourly extremes, refined with a parabola through the
    /// neighbouring hours.
    static func tideSummary(_ day: [HourlyWind], rules: ScoringRules) -> String? {
        let pts = day.compactMap { h in h.seaLevelM.map { (h.hour, $0) } }
        guard pts.count >= 3, let lo = pts.map(\.1).min(), let hi = pts.map(\.1).max(),
              hi - lo >= rules.minTidalRange else { return nil }
        var highs: [String] = [], lows: [String] = []
        for i in 1..<(pts.count - 1) {
            let (a, b, c) = (pts[i - 1].1, pts[i].1, pts[i + 1].1)
            let isHigh = b >= a && b > c, isLow = b <= a && b < c
            guard isHigh || isLow else { continue }
            let denom = a - 2 * b + c
            let shift = denom == 0 ? 0 : max(-0.5, min(0.5, 0.5 * (a - c) / denom))
            let minutes = Int(((Double(pts[i].0) + shift) * 60).rounded())
            let t = String(format: "%02d:%02d", (minutes / 60 + 24) % 24, (minutes % 60 + 60) % 60)
            if isHigh { highs.append(t) } else { lows.append(t) }
        }
        var parts: [String] = []
        if !highs.isEmpty { parts.append("High " + highs.joined(separator: ", ")) }
        if !lows.isEmpty { parts.append("Low " + lows.joined(separator: ", ")) }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    /// Side of a multi-sided spot used most often in these hours.
    public static func mainSide(_ hours: some Sequence<HourScore>) -> String? {
        let counts = Dictionary(hours.compactMap(\.side).map { ($0, 1) }, uniquingKeysWith: +)
        return counts.max { ($0.value, $1.key) < ($1.value, $0.key) }?.key
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
