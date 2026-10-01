import SwiftUI

@main
struct WhereToKiteApp: App {
    @State private var profiles = ProfileStore()
    @State private var userSpots = UserSpotStore()

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environment(profiles)
                .environment(userSpots)
        }
    }
}
