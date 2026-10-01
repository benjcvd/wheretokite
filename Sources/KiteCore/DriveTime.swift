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

    public func minutes(from origin: Coordinate, to spot: Spot) -> Double {
        minutes(straightLineKm: Geo.distanceKm(origin, spot.coordinate))
    }

    public func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        Dictionary(spots.map { ($0.id, minutes(from: origin, to: $0)) }, uniquingKeysWith: { a, _ in a })
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
