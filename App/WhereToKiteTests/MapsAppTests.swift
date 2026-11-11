import XCTest
@testable import WhereToKite

/// The Google Maps directions link: public URL, driving, to the spot's pin, no origin.
final class MapsAppTests: XCTestCase {
    func testGoogleDirectionsURL() throws {
        let url = MapsApp.googleDirectionsURL(latitude: 41.2795, longitude: 1.9782)
        XCTAssertEqual(url.absoluteString,
                       "https://www.google.com/maps/dir/?api=1&destination=41.279500,1.978200&travelmode=driving")
    }

    func testGoogleDirectionsURLNegativeLongitude() throws {
        let url = MapsApp.googleDirectionsURL(latitude: 36.0139, longitude: -5.6044)
        let items = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems)
        XCTAssertEqual(items.first { $0.name == "destination" }?.value, "36.013900,-5.604400")
        XCTAssertNil(items.first { $0.name == "origin" })
    }

    func testStoredChoiceRoundTrips() {
        for app in MapsApp.allCases { XCTAssertEqual(MapsApp(rawValue: app.rawValue), app) }
        XCTAssertNil(MapsApp(rawValue: ""))  // nothing chosen yet → ask
    }
}
