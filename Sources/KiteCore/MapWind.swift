import Foundation

/// What the spot map draws: one wind arrow per hour against the beach line (WHE-156).
/// No animated flow: there is one forecast point per spot, so a plain arrow is what the
/// data supports.
public enum MapWind {
    /// The wind to draw for a group of hours: mean speed and gusts, vector-mean direction,
    /// and the angle to the beach of the side most of them were scored on.
    public struct Summary: Sendable, Equatable {
        public var speedKn: Double
        public var gustKn: Double
        /// Where the wind comes FROM, compass degrees.
        public var directionDeg: Double
        /// 0 onshore … 180 offshore; nil when the beach direction is unknown.
        public var relativeAngle: Double?
        /// The side of a multi-sided spot (nil = the only side).
        public var side: String?
    }

    /// nil for no hours.
    public static func summary(_ hours: [HourScore]) -> Summary? {
        guard !hours.isEmpty else { return nil }
        let n = Double(hours.count)
        let angles = hours.compactMap(\.relativeAngle)
        let sides = Dictionary(grouping: hours.compactMap(\.side), by: { $0 })
        return Summary(
            speedKn: hours.map(\.wind.speedKn).reduce(0, +) / n,
            gustKn: hours.map(\.wind.gustKn).reduce(0, +) / n,
            directionDeg: Geo.circularStats(hours.map(\.shownDirectionDeg)).mean,
            relativeAngle: angles.isEmpty ? nil : angles.reduce(0, +) / Double(angles.count),
            side: sides.max { $0.value.count < $1.value.count }?.key)
    }

    /// The hours the spot page's map shows: the best window, else the hours the score comes
    /// from, else the whole session.
    public static func highlightedHours(_ rec: SpotRecommendation) -> [HourScore] {
        guard let w = rec.window ?? rec.scoredHours else { return rec.hours }
        let slice = rec.hours.filter { $0.wind.hour >= w.start && $0.wind.hour < w.end }
        return slice.isEmpty ? rec.hours : slice
    }

    /// Which way the beach faces for this side (compass bearing out to the water), nil when
    /// unknown or when the spot has water all around (a small lake: no beach line to draw).
    public static func seaFacing(_ spot: Spot, side: String?) -> Double? {
        let sides = spot.allSides
        let chosen = sides.first { $0.name != nil && $0.name == side } ?? sides.first
        guard let chosen, (chosen.waterSectorDeg ?? 180) < 360 else { return nil }
        return chosen.seaFacingDeg
    }

    /// An arrow whose tip is on the spot and whose tail is `lengthM` upwind, plus the two
    /// strokes of its head.
    public static func arrow(at spot: Coordinate, fromDeg: Double, lengthM: Double)
        -> (shaft: [Coordinate], head: [Coordinate]) {
        let tail = Geo.destination(spot, bearingDeg: fromDeg, distanceM: lengthM)
        let headLen = lengthM * 0.3
        let left = Geo.destination(spot, bearingDeg: fromDeg - 28, distanceM: headLen)
        let right = Geo.destination(spot, bearingDeg: fromDeg + 28, distanceM: headLen)
        return ([tail, spot], [left, spot, right])
    }

    /// The models' direction range over these hours (every model, every hour), for a fan on
    /// the map (WHE-242). nil when they stay within `HourlyWind.directionRangeShownDeg`.
    public static func modelArc(_ hours: [HourScore]) -> (from: Double, to: Double)? {
        HourlyWind.directionArc(hours.flatMap { $0.wind.modelDirectionsDeg ?? [] })
    }

    /// One weather model's wind over a group of hours, for its own arrow on the map (WHE-243).
    public struct ModelArrow: Sendable, Equatable {
        public var model: String
        public var speedKn: Double
        /// Where it comes FROM, compass degrees (vector mean over the hours it has a direction).
        public var directionDeg: Double
        /// 0 onshore … 180 offshore on the side drawn; nil when the beach direction is unknown.
        public var relativeAngle: Double?
    }

    /// One arrow per model when they are 45°+ apart over these hours (`modelArc`), nil when they
    /// agree (one arrow says it all). A model too light to give a direction in every hour is left out.
    public static func modelArrows(_ hours: [HourScore], spot: Spot, side: String?) -> [ModelArrow]? {
        guard modelArc(hours) != nil else { return nil }
        let winds = hours.compactMap(\.wind.modelWinds)
        guard let ids = winds.first?.map(\.model) else { return nil }
        let sides = spot.allSides
        let chosen = sides.first { $0.name != nil && $0.name == side } ?? sides.first
        let arrows: [ModelArrow] = ids.compactMap { id in
            let mine = winds.flatMap { $0.filter { $0.model == id } }
            let dirs = mine.compactMap(\.directionDeg)
            guard !dirs.isEmpty else { return nil }
            let dir = Geo.circularStats(dirs).mean
            return ModelArrow(model: id, speedKn: mine.map(\.speedKn).reduce(0, +) / Double(mine.count),
                              directionDeg: dir,
                              relativeAngle: chosen.map { Scorer.relativeAngle(directionDeg: dir, side: $0) })
        }
        return arrows.count > 1 ? arrows : nil
    }

    /// The beach line through the spot: perpendicular to the way it faces, `halfLengthM` each side.
    public static func shoreLine(at spot: Coordinate, seaFacingDeg: Double, halfLengthM: Double) -> [Coordinate] {
        [Geo.destination(spot, bearingDeg: seaFacingDeg - 90, distanceM: halfLengthM),
         Geo.destination(spot, bearingDeg: seaFacingDeg + 90, distanceM: halfLengthM)]
    }
}

extension Geo {
    /// The point `distanceM` from `from` along a compass bearing (great circle).
    public static func destination(_ from: Coordinate, bearingDeg: Double, distanceM: Double) -> Coordinate {
        let r = 6_371_000.0, d = distanceM / r
        let b = bearingDeg * .pi / 180
        let lat1 = from.latitude * .pi / 180, lon1 = from.longitude * .pi / 180
        let lat2 = asin(sin(lat1) * cos(d) + cos(lat1) * sin(d) * cos(b))
        let lon2 = lon1 + atan2(sin(b) * sin(d) * cos(lat1), cos(d) - sin(lat1) * sin(lat2))
        return Coordinate(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
}
