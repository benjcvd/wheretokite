import Foundation
import KiteCore

/// The rider profile is entered once and reused for every search.
@MainActor @Observable
final class ProfileStore {
    private static let key = "riderProfile"

    var profile: RiderProfile? {
        didSet {
            if let profile, let data = try? JSONEncoder().encode(profile) {
                UserDefaults.standard.set(data, forKey: Self.key)
            }
        }
    }

    init() {
        #if DEBUG
        // UI tests start from a fresh install state.
        if ProcessInfo.processInfo.arguments.contains("-resetProfile") {
            UserDefaults.standard.removeObject(forKey: Self.key)
        }
        #endif
        if let data = UserDefaults.standard.data(forKey: Self.key) {
            profile = try? JSONDecoder().decode(RiderProfile.self, from: data)
        }
    }
}
