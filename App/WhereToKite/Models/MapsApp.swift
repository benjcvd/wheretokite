import Foundation
import MapKit
import UIKit

/// The navigation app the Directions button opens. The rider's last choice is remembered
/// (`MapsApp.storageKey`); nothing is sent anywhere until they tap.
enum MapsApp: String, CaseIterable, Identifiable {
    case apple
    case google

    static let storageKey = "directionsApp"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .apple: String(localized: "Apple Maps")
        case .google: String(localized: "Google Maps")
        }
    }

    /// Google's public directions link, driving, to the spot's pin. iOS hands it to the
    /// Google Maps app when it's installed (universal link), Safari otherwise. No origin:
    /// Google starts from the rider's current position.
    static func googleDirectionsURL(latitude: Double, longitude: Double) -> URL {
        var c = URLComponents(string: "https://www.google.com/maps/dir/")!
        c.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "destination", value: String(format: "%.6f,%.6f", latitude, longitude)),
            URLQueryItem(name: "travelmode", value: "driving"),
        ]
        return c.url!
    }

    /// Opens driving directions to the spot in this app.
    @MainActor func open(name: String, latitude: Double, longitude: Double) {
        switch self {
        case .apple:
            let item: MKMapItem
            if #available(iOS 26, *) {
                item = MKMapItem(location: CLLocation(latitude: latitude, longitude: longitude), address: nil)
            } else {
                item = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
            }
            item.name = name
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        case .google:
            UIApplication.shared.open(Self.googleDirectionsURL(latitude: latitude, longitude: longitude))
        }
    }
}
