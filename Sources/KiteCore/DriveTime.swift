import Foundation
#if canImport(MapKit)
import MapKit
#endif

public protocol DriveTimeProvider: Sendable {
    /// Driving minutes from origin to each spot. Spots without a route are omitted.
    func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double]
}

/// Offline fallback: straight-line distance × road detour factor at an average speed.
public struct StraightLineDriveTime: DriveTimeProvider {
    public var detourFactor = 1.3
    public var averageKmh = 70.0

    public init() {}

    public func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        Dictionary(uniqueKeysWithValues: spots.map {
            ($0.id, Geo.distanceKm(origin, $0.coordinate) * detourFactor / averageKmh * 60)
        })
    }
}

#if canImport(MapKit)
/// Real road ETAs from Apple Maps. Apple throttles bursts, so requests run a few at a time
/// and fall back to the straight-line estimate for any spot that fails.
public struct MapKitDriveTime: DriveTimeProvider {
    public var maxConcurrent = 4

    public init() {}

    public func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        var result: [String: Double] = [:]
        var failed: [Spot] = []
        for start in stride(from: 0, to: spots.count, by: maxConcurrent) {
            let chunk = spots[start..<min(start + maxConcurrent, spots.count)]
            await withTaskGroup(of: (Spot, Double?).self) { group in
                for spot in chunk {
                    group.addTask { (spot, await Self.eta(from: origin, to: spot.coordinate)) }
                }
                for await (spot, minutes) in group {
                    if let minutes { result[spot.id] = minutes } else { failed.append(spot) }
                }
            }
        }
        if !failed.isEmpty {
            result.merge(await StraightLineDriveTime().driveMinutes(from: origin, to: failed)) { a, _ in a }
        }
        return result
    }

    private static func eta(from a: Coordinate, to b: Coordinate) async -> Double? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: b.latitude, longitude: b.longitude)))
        request.transportType = .automobile
        do {
            let response = try await MKDirections(request: request).calculateETA()
            return response.expectedTravelTime / 60
        } catch {
            return nil
        }
    }
}
#endif
