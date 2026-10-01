import SwiftUI

@main
struct WhereToKiteApp: App {
    @State private var profiles = ProfileStore()

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environment(profiles)
        }
    }
}
