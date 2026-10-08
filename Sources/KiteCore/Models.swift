import Foundation

public struct Coordinate: Codable, Hashable, Sendable {
    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Spots

public struct Spot: Codable, Hashable, Sendable, Identifiable {
    public var id: String
    public var name: String
    public var latitude: Double
    public var longitude: Double
    /// Compass bearing pointing from the beach out to open water, of the main side.
    /// nil = unknown.
    public var seaFacingDeg: Double?
    /// Width in degrees of open water seen from the launch, centred on `seaFacingDeg`.
    /// nil = 180 (straight beach). < 180: cove; > 180: point / headland; 360: small lake.
    public var waterSectorDeg: Double?
    /// Every side the spot can be kited from, when there is more than one (isthmus, sandbar,
    /// sea + lagoon). nil = a single side, `seaFacingDeg`.
    public var sides: [SpotSide]?
    public var orientationSource: String?
    public var distanceToShoreM: Double?
    public var source: String?
    public var notes: String?
    /// ISO 3166-1 alpha-2 country code, e.g. "FR".
    public var country: String?
    /// Human-readable area, e.g. "Côte d'Opale".
    public var region: String?
    /// "sea" | "lagoon" | "lake".
    public var waterType: String?
    /// When the spot works with the tide: "high" | "low" | "mid" | "not-low" | "not-high".
    /// nil = any tide (or no tide).
    public var tide: String?
    /// "ferry" when a boat is needed to get there by car from the mainland; nil = by road.
    public var access: String?
    /// For ferry spots on an island: `SpotCatalog.islands` id. Shown only to someone there.
    public var island: String?
    /// Beach direction cross-checked against Apple Maps: "agrees" | "uncertain" |
    /// "disagrees" | "unchecked". nil for user spots.
    public var directionCheck: String?

    public var coordinate: Coordinate { Coordinate(latitude: latitude, longitude: longitude) }

    /// "W", "W & E" (one compass point per side), "all around" for a 360° sector, nil if unknown.
    public var facingSummary: String? {
        let sides = allSides
        if sides.contains(where: { ($0.waterSectorDeg ?? 180) >= 360 }) { return "all around" }
        return sides.isEmpty ? nil : sides.map { Geo.compassName($0.seaFacingDeg) }.joined(separator: " & ")
    }

    /// The sides to score: `sides` if set, else the single `seaFacingDeg` (if known).
    public var allSides: [SpotSide] {
        if let sides, !sides.isEmpty { return sides }
        return seaFacingDeg.map { [SpotSide(name: nil, seaFacingDeg: $0, waterSectorDeg: waterSectorDeg)] } ?? []
    }
}

/// One shore of a spot. Each hour is scored on the side where the wind works best.
public struct SpotSide: Codable, Hashable, Sendable {
    /// Short label, e.g. "west side", "lagoon". nil for a spot's only side.
    public var name: String?
    /// Compass bearing from this shore out to the water.
    public var seaFacingDeg: Double
    /// Width of open water, see `Spot.waterSectorDeg`. nil = 180.
    public var waterSectorDeg: Double?

    public init(name: String?, seaFacingDeg: Double, waterSectorDeg: Double? = nil) {
        self.name = name
        self.seaFacingDeg = seaFacingDeg
        self.waterSectorDeg = waterSectorDeg
    }
}

public struct SpotCatalog: Codable, Sendable {
    public var generatedAt: String?
    public var region: String?
    public var attribution: String?
    public var spots: [Spot]
    /// Islands only reachable by boat that have catalogue spots.
    public var islands: [Island]?

    public static func load(from url: URL) throws -> SpotCatalog {
        try JSONDecoder().decode(SpotCatalog.self, from: Data(contentsOf: url))
    }
}

/// An island only reachable by boat, with a coarse (~500 m) outline.
public struct Island: Codable, Hashable, Sendable {
    public var id: String
    public var name: String
    /// [latitude, longitude] pairs of the outer ring.
    public var outline: [[Double]]

    public init(id: String, name: String, outline: [[Double]]) {
        self.id = id
        self.name = name
        self.outline = outline
    }

    /// Inside the outline, or within `toleranceM` of it: the outline is simplified (~500 m)
    /// and would otherwise cut off beaches and harbours.
    public func contains(_ p: Coordinate, toleranceM: Double = 1500) -> Bool {
        let ring = outline.map { ($0[0], $0[1]) }
        if Geo.polygonContains(ring, p) { return true }
        // Distance to each edge in a local flat projection (metres).
        let ky = 111_320.0, kx = 111_320.0 * cos(p.latitude * .pi / 180)
        let pts = ring.map { (x: ($0.1 - p.longitude) * kx, y: ($0.0 - p.latitude) * ky) }
        for (a, b) in zip(pts, pts.dropFirst() + pts.prefix(1)) {
            let dx = b.x - a.x, dy = b.y - a.y, l2 = dx * dx + dy * dy
            let t = l2 == 0 ? 0 : max(0, min(1, -(a.x * dx + a.y * dy) / l2))
            if hypot(a.x + t * dx, a.y + t * dy) <= toleranceM { return true }
        }
        return false
    }
}

// MARK: - Rider

public enum Level: String, Codable, CaseIterable, Sendable {
    case beginner, intermediate, advanced
}

/// Persisted once, reused for every search.
/// How much each part of the score matters to the rider: 0 = ignore, 1 = default, 2 = a lot.
/// Applied as exponents on the 0…1 factors (and as a multiplier on the drive penalty), so 1
/// everywhere is the standard score. Safety limits are not weighted.
public struct ScoreWeights: Codable, Equatable, Sendable {
    public var strength: Double = 1
    public var steadiness: Double = 1
    public var direction: Double = 1
    public var distance: Double = 1

    public init(strength: Double = 1, steadiness: Double = 1, direction: Double = 1, distance: Double = 1) {
        self.strength = strength
        self.steadiness = steadiness
        self.direction = direction
        self.distance = distance
    }

    public static let range: ClosedRange<Double> = 0...2
    public var isDefault: Bool { self == ScoreWeights() }
}

public struct RiderProfile: Codable, Equatable, Sendable {
    public var weightKg: Double
    /// Kite sizes in m².
    public var kites: [Double]
    public var level: Level
    /// nil = defaults (optional so profiles saved before weights existed still load).
    public var weights: ScoreWeights?

    public var scoreWeights: ScoreWeights {
        get { weights ?? ScoreWeights() }
        set { weights = newValue.isDefault ? nil : newValue }
    }

    public init(weightKg: Double, kites: [Double], level: Level) {
        self.weightKg = weightKg
        self.kites = kites
        self.level = level
    }
}

// MARK: - Search

public enum SessionSlot: String, Codable, CaseIterable, Sendable {
    case morning, afternoon, fullDay

    /// Local start hours included in the slot (an hour h covers h:00–h+1:00).
    public var hours: ClosedRange<Int> {
        switch self {
        case .morning: 9...12      // 9–13
        case .afternoon: 13...17   // 13–18
        case .fullDay: 9...17      // 9–18
        }
    }
}

public struct SearchRequest: Sendable {
    public var origin: Coordinate
    public var maxDriveMinutes: Double
    /// Local calendar day, "yyyy-MM-dd".
    public var day: String
    public var slot: SessionSlot
    /// 0 = chill, 1 = intense, nil = "all types".
    public var intensity: Double?
    public var distanceMatters: Bool

    public init(origin: Coordinate, maxDriveMinutes: Double, day: String, slot: SessionSlot,
                intensity: Double?, distanceMatters: Bool) {
        self.origin = origin
        self.maxDriveMinutes = maxDriveMinutes
        self.day = day
        self.slot = slot
        self.intensity = intensity
        self.distanceMatters = distanceMatters
    }
}

// MARK: - Forecast

public struct HourlyWind: Codable, Hashable, Sendable {
    /// Local time as returned by the provider, "yyyy-MM-ddTHH:mm".
    public var localTime: String
    public var speedKn: Double
    public var gustKn: Double
    /// Direction the wind is coming FROM, compass degrees.
    public var directionDeg: Double
    /// Sea level incl. tide (m, relative to mean sea level). Only fetched for spots with a
    /// tide rule.
    public var seaLevelM: Double?

    public var hour: Int { Int(localTime.dropFirst(11).prefix(2)) ?? 0 }

    /// False for values no real forecast produces (non-finite, negative, absurdly strong,
    /// direction outside 0…360). Network responses and cache files are checked with this, so
    /// a corrupt or hostile payload can't reach the scoring or the UI's Int conversions.
    public static func isPlausible(speedKn: Double, gustKn: Double, directionDeg: Double) -> Bool {
        (0...250).contains(speedKn) && (0...300).contains(gustKn) && (0...360).contains(directionDeg)
    }

    public var isPlausible: Bool {
        Self.isPlausible(speedKn: speedKn, gustKn: gustKn, directionDeg: directionDeg)
            && (seaLevelM.map { (-30...30).contains($0) } ?? true)
    }

    public init(localTime: String, speedKn: Double, gustKn: Double, directionDeg: Double) {
        self.localTime = localTime
        self.speedKn = speedKn
        self.gustKn = gustKn
        self.directionDeg = directionDeg
    }
}

public struct DayForecast: Codable, Sendable {
    public var day: String
    public var hours: [HourlyWind]

    /// True for a local calendar day "yyyy-MM-dd" (digits and dashes only). The day goes
    /// into request URLs and cache file names, so anything else is rejected.
    public static func isValidDay(_ day: String) -> Bool {
        let u = Array(day.utf8)
        guard u.count == 10 else { return false }
        for (i, c) in u.enumerated() {
            if i == 4 || i == 7 { if c != UInt8(ascii: "-") { return false } }
            else if !(UInt8(ascii: "0")...UInt8(ascii: "9")).contains(c) { return false }
        }
        return true
    }
}

// MARK: - Days

/// "yyyy-MM-dd" day strings as the forecast API wants them: always Gregorian digits, whatever
/// the device's calendar (a Buddhist or Japanese calendar would otherwise give "2569-…" or
/// "0008-…").
public enum DayString {
    public static func formatter(timeZone: TimeZone = .current) -> DateFormatter {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = timeZone
        f.dateFormat = "yyyy-MM-dd"
        return f
    }

    /// The local calendar day of `date`.
    public static func from(_ date: Date, timeZone: TimeZone = .current) -> String {
        formatter(timeZone: timeZone).string(from: date)
    }

    /// Local midnight of a "yyyy-MM-dd" day, nil if malformed.
    public static func date(_ day: String, timeZone: TimeZone = .current) -> Date? {
        formatter(timeZone: timeZone).date(from: day)
    }
}
