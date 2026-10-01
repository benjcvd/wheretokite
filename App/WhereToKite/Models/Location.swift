import CoreLocation
import MapKit
import KiteCore

/// Where the search starts from: the phone's location, or a place the user picked.
struct StartPoint: Codable, Equatable {
    var name: String
    var coordinate: Coordinate?   // nil = current location

    static let currentLocation = StartPoint(name: "Current location", coordinate: nil)
    var isCurrentLocation: Bool { coordinate == nil }
}

enum LocationError: LocalizedError {
    case denied, unavailable

    var errorDescription: String? {
        switch self {
        case .denied: "Location access is off. Allow it in Settings, or pick a starting point."
        case .unavailable: "Couldn't get your location. Pick a starting point instead."
        }
    }
}

@MainActor
final class LocationService {
    private let manager = CLLocationManager()

    func currentCoordinate() async throws -> Coordinate {
        switch manager.authorizationStatus {
        case .denied, .restricted: throw LocationError.denied
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: break
        }
        return try await withThrowingTaskGroup(of: Coordinate.self) { group in
            group.addTask {
                for try await update in CLLocationUpdate.liveUpdates() {
                    if let c = update.location?.coordinate {
                        return Coordinate(latitude: c.latitude, longitude: c.longitude)
                    }
                }
                throw LocationError.unavailable
            }
            group.addTask {
                try await Task.sleep(for: .seconds(15))
                throw LocationError.unavailable
            }
            let first = try await group.next()!
            group.cancelAll()
            return first
        }
    }

    static func searchPlaces(_ query: String) async -> [StartPoint] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = [.address, .pointOfInterest]
        guard let response = try? await MKLocalSearch(request: request).start() else { return [] }
        return response.mapItems.map { item in
            let c: CLLocationCoordinate2D
            if #available(iOS 26, *) { c = item.location.coordinate } else { c = item.placemark.coordinate }
            return StartPoint(name: item.name ?? query, coordinate: Coordinate(latitude: c.latitude, longitude: c.longitude))
        }
    }
}
