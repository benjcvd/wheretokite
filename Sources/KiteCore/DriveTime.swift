import Foundation
#if canImport(MapKit)
import MapKit
#endif

public protocol DriveTimeProvider: Sendable {
    /// Driving minutes from origin to each spot. Spots without a route (or whose request
    /// failed) are omitted; the caller keeps its own estimate for those.
    func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double]

    /// True when the minutes are cheap estimates rather than real routes. The recommender
    /// then skips the "verify the top candidates" round.
    var providesEstimates: Bool { get }
}

extension DriveTimeProvider {
    public var providesEstimates: Bool { false }
}

/// Offline estimate: straight-line distance × road detour factor, at an average speed that
/// grows with trip length (town streets for short hops, motorway for long trips).
///
/// Calibration (road ETAs without traffic, coastal destinations):
///   Barcelona→Castelldefels 18 km crow, ~25 min   → estimate 26 min
///   Paris→Wissant          240 km crow, ~3h00     → estimate 3h05
///   Paris→Quiberon         410 km crow, ~5h00     → estimate 5h12
///   Paris→Marseille        660 km crow, ~7h20     → estimate 8h15
///   Barcelona→Tarifa       830 km crow, ~10h30    → estimate 10h22
/// i.e. within about −5 % … +15 % (slightly pessimistic on long motorway runs, which the
/// recommender corrects with real ETAs for the top candidates). The minutes are strictly
/// increasing with distance (speed never grows faster than distance).
public struct StraightLineDriveTime: DriveTimeProvider {
    /// Road km per straight-line km. Measured 1.17 (Paris→Marseille) … 1.33 (Barcelona→Tarifa).
    public var detourFactor = 1.25
    /// (road km, average km/h), linearly interpolated, flat beyond the ends.
    public var speedCurve: [(roadKm: Double, kmh: Double)] = [
        (0, 45), (25, 52), (75, 70), (150, 85), (300, 95), (600, 100),
    ]

    public init() {}

    public var providesEstimates: Bool { true }

    public func averageKmh(roadKm: Double) -> Double {
        interpolate(speedCurve.map { ($0.roadKm, $0.kmh) }, roadKm)
    }

    public func minutes(straightLineKm km: Double) -> Double {
        let road = max(0, km) * detourFactor
        return road / averageKmh(roadKm: road) * 60
    }

    /// Like `minutes(straightLineKm:)`, but a trip to or from an island (Great Britain,
    /// Corsica, Morocco…) goes through its usual ferry or tunnel: drive to the port, cross
    /// (`SeaCrossing.minutes`, boarding included), drive on from the port on the other side.
    public func minutes(from origin: Coordinate, to destination: Coordinate) -> Double {
        let from = SeaCrossing.landmass(of: origin), to = SeaCrossing.landmass(of: destination)
        guard from?.name != to?.name else {
            return minutes(straightLineKm: Geo.distanceKm(origin, destination))
        }
        var total = 0.0
        var here = origin
        if let from {   // leave the origin's island
            total += minutes(straightLineKm: Geo.distanceKm(here, from.islandPort)) + from.minutes
            here = from.mainlandPort
        }
        if let to {     // reach the destination's island
            total += minutes(straightLineKm: Geo.distanceKm(here, to.mainlandPort)) + to.minutes
            here = to.islandPort
        }
        return total + minutes(straightLineKm: Geo.distanceKm(here, destination))
    }

    public func minutes(from origin: Coordinate, to spot: Spot) -> Double {
        minutes(from: origin, to: spot.coordinate)
    }

    public func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        Dictionary(spots.map { ($0.id, minutes(from: origin, to: $0)) }, uniquingKeysWith: { a, _ in a })
    }
}

/// A landmass reached from mainland Europe by ferry or tunnel, for drive estimates. Apple
/// Maps routes through these crossings itself; the table only keeps the offline estimate
/// (which decides which spots get a real ETA) from treating the sea as road.
///
/// Areas are coarse boxes / polygons, good enough to tell which side of the water a point
/// is on. Anything outside every area counts as mainland Europe.
public struct SeaCrossing: Sendable {
    public var name: String
    /// (latitude, longitude) vertices; a closed polygon, or a box when two corners are given.
    public var area: [(Double, Double)]
    public var mainlandPort: Coordinate
    public var islandPort: Coordinate
    /// Crossing plus check-in / boarding.
    public var minutes: Double

    static func c(_ lat: Double, _ lon: Double) -> Coordinate { Coordinate(latitude: lat, longitude: lon) }

    /// Order matters: the first area containing a point wins (Canaries before Africa).
    public static let all: [SeaCrossing] = [
        // Le Shuttle Calais–Folkestone, 35 min + ~45 min check-in. Ireland is outside the polygon.
        SeaCrossing(name: "Great Britain",
                    area: [(49.8, -6.5), (50.6, 1.0), (51.0, 1.6), (51.6, 2.0), (53.0, 2.0), (61.0, 0.0),
                           (58.6, -8.0), (56.0, -6.5), (55.3, -5.9), (54.6, -5.3), (53.2, -4.9), (51.6, -5.5)],
                    mainlandPort: c(50.94, 1.84), islandPort: c(51.09, 1.13), minutes: 80),
        SeaCrossing(name: "Corsica", area: [(41.3, 8.5), (43.1, 9.6)],
                    mainlandPort: c(43.70, 7.28), islandPort: c(42.70, 9.45), minutes: 390),       // Nice–Bastia
        SeaCrossing(name: "Sardinia", area: [(38.8, 8.1), (41.3, 9.9)],
                    mainlandPort: c(43.55, 10.30), islandPort: c(40.92, 9.52), minutes: 600),      // Livorno–Olbia
        SeaCrossing(name: "Sicily", area: [(36.6, 12.3), (38.35, 15.6)],
                    mainlandPort: c(38.22, 15.64), islandPort: c(38.19, 15.55), minutes: 60),      // Villa S. G.–Messina
        SeaCrossing(name: "Balearic Islands", area: [(38.6, 1.1), (40.1, 4.4)],
                    mainlandPort: c(41.35, 2.17), islandPort: c(39.56, 2.63), minutes: 540),       // Barcelona–Palma
        SeaCrossing(name: "Canary Islands", area: [(27.5, -18.3), (29.5, -13.3)],
                    mainlandPort: c(37.25, -6.95), islandPort: c(28.14, -15.43), minutes: 2200),   // Huelva–Las Palmas
        SeaCrossing(name: "Africa", area: [(15.0, -18.0), (35.95, 11.0)],
                    mainlandPort: c(36.01, -5.60), islandPort: c(35.78, -5.81), minutes: 150),     // Tarifa–Tanger
        SeaCrossing(name: "Rhodes", area: [(35.85, 27.6), (36.5, 28.3)],
                    mainlandPort: c(37.94, 23.64), islandPort: c(36.45, 28.23), minutes: 1000),    // Piraeus
        SeaCrossing(name: "Kos", area: [(36.6, 26.9), (36.95, 27.4)],
                    mainlandPort: c(37.94, 23.64), islandPort: c(36.90, 27.29), minutes: 720),
        SeaCrossing(name: "Naxos", area: [(36.9, 25.3), (37.2, 25.6)],
                    mainlandPort: c(37.94, 23.64), islandPort: c(37.10, 25.37), minutes: 420),
        SeaCrossing(name: "Paros", area: [(36.95, 25.0), (37.15, 25.3)],
                    mainlandPort: c(37.94, 23.64), islandPort: c(37.09, 25.15), minutes: 360),
        SeaCrossing(name: "Lemnos", area: [(39.75, 25.0), (40.05, 25.5)],
                    mainlandPort: c(40.93, 24.41), islandPort: c(39.87, 25.06), minutes: 330),     // Kavala–Myrina
    ]

    public func contains(_ p: Coordinate) -> Bool {
        if area.count == 2 {
            return (area[0].0...area[1].0).contains(p.latitude) && (area[0].1...area[1].1).contains(p.longitude)
        }
        var inside = false
        var j = area.count - 1
        for i in area.indices {
            let (yi, xi) = area[i], (yj, xj) = area[j]
            if (yi > p.latitude) != (yj > p.latitude),
               p.longitude < (xj - xi) * (p.latitude - yi) / (yj - yi) + xi {
                inside.toggle()
            }
            j = i
        }
        return inside
    }

    /// nil = mainland Europe.
    public static func landmass(of p: Coordinate) -> SeaCrossing? {
        all.first { $0.contains(p) }
    }
}

#if canImport(MapKit)
/// Real road ETAs from Apple Maps.
///
/// MapKit throttles directions/ETA requests per app (roughly 50 per minute; beyond that
/// requests fail with `MKError.loadingThrottled`). So: the recommender only asks for a few
/// dozen top candidates per search, results are cached in memory for 30 min (re-running a
/// search with another day/slot costs nothing), and once throttled we stop sending requests
/// for a minute. Failed spots are omitted so the caller keeps its estimate.
public struct MapKitDriveTime: DriveTimeProvider {
    public var maxConcurrent = 6

    public init() {}

    public func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        let cache = ETACache.shared
        var result: [String: Double] = [:]
        var todo: [Spot] = []
        for spot in spots {
            if let m = await cache.get(origin, spot.id) { result[spot.id] = m } else { todo.append(spot) }
        }
        guard !todo.isEmpty, await !cache.isThrottled else { return result }

        await withTaskGroup(of: (Spot, ETAResult).self) { group in
            var next = 0
            var throttled = false
            while next < min(maxConcurrent, todo.count) {
                let spot = todo[next]; next += 1
                group.addTask { (spot, await Self.eta(from: origin, to: spot.coordinate)) }
            }
            while let (spot, eta) = await group.next() {
                switch eta {
                case .minutes(let m):
                    result[spot.id] = m
                    await cache.set(origin, spot.id, m)
                case .throttled:
                    throttled = true
                    await cache.markThrottled()
                case .failed:
                    break
                }
                if !throttled, next < todo.count {
                    let spot = todo[next]; next += 1
                    group.addTask { (spot, await Self.eta(from: origin, to: spot.coordinate)) }
                }
            }
        }
        return result
    }

    private enum ETAResult: Sendable { case minutes(Double), throttled, failed }

    private static func mapItem(_ c: Coordinate) -> MKMapItem {
        let location = CLLocation(latitude: c.latitude, longitude: c.longitude)
        if #available(iOS 26, macOS 26, *) {
            return MKMapItem(location: location, address: nil)
        }
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
    }

    private static func eta(from a: Coordinate, to b: Coordinate) async -> ETAResult {
        let request = MKDirections.Request()
        request.source = mapItem(a)
        request.destination = mapItem(b)
        request.transportType = .automobile
        do {
            let response = try await MKDirections(request: request).calculateETA()
            return .minutes(response.expectedTravelTime / 60)
        } catch let error as MKError where error.code == .loadingThrottled {
            return .throttled
        } catch {
            return .failed
        }
    }
}

/// In-memory ETA cache shared by all searches of the process.
actor ETACache {
    static let shared = ETACache()

    var ttl: TimeInterval = 30 * 60
    var throttlePause: TimeInterval = 60
    private var entries: [String: (minutes: Double, at: Date)] = [:]
    private var throttledAt: Date?

    /// Origins within ~100 m share entries.
    private func key(_ origin: Coordinate, _ spotID: String) -> String {
        String(format: "%.3f,%.3f|", origin.latitude, origin.longitude) + spotID
    }

    func get(_ origin: Coordinate, _ spotID: String) -> Double? {
        guard let e = entries[key(origin, spotID)], Date().timeIntervalSince(e.at) < ttl else { return nil }
        return e.minutes
    }

    func set(_ origin: Coordinate, _ spotID: String, _ minutes: Double) {
        entries[key(origin, spotID)] = (minutes, Date())
    }

    var isThrottled: Bool {
        throttledAt.map { Date().timeIntervalSince($0) < throttlePause } ?? false
    }

    func markThrottled() { throttledAt = Date() }
}
#endif
