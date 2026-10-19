import Foundation
import KiteCore

/// The rider profile is entered once and reused for every search.
@MainActor @Observable
final class ProfileStore {
    private static let key = "riderProfile"
    private static let disclaimerKey = "disclaimerAccepted"

    /// The rider accepted that scores are estimates and they ride at their own risk.
    var disclaimerAccepted: Bool {
        didSet { UserDefaults.standard.set(disclaimerAccepted, forKey: Self.disclaimerKey) }
    }

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
            UserDefaults.standard.removeObject(forKey: "searchOptions")
            UserDefaults.standard.removeObject(forKey: Self.disclaimerKey)
        }
        #endif
        disclaimerAccepted = UserDefaults.standard.bool(forKey: Self.disclaimerKey)
        if let data = UserDefaults.standard.data(forKey: Self.key) {
            profile = try? JSONDecoder().decode(RiderProfile.self, from: data)
        }
    }
}
