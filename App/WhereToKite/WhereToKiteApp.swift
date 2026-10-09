import SwiftUI

@main
struct WhereToKiteApp: App {
    @State private var profiles = ProfileStore()
    @State private var userSpots = UserSpotStore()
    @State private var plan = PlanStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(profiles)
                .environment(userSpots)
                .environment(plan)
        }
    }
}

/// Onboarding until a rider profile exists, then three tabs: Kite · My spots · Me.
struct RootView: View {
    @Environment(ProfileStore.self) private var profiles
    @State private var tab = Tab.kite

    enum Tab: Hashable { case kite, spots, me }

    var body: some View {
        if profiles.profile == nil {
            OnboardingView()
                .transition(.opacity)
        } else {
            TabView(selection: $tab) {
                SearchView()
                    .tabItem { Label("Kite", systemImage: "wind") }
                    .tag(Tab.kite)
                MySpotsView()
                    .tabItem { Label("My spots", systemImage: "mappin.and.ellipse") }
                    .tag(Tab.spots)
                MeView()
                    .tabItem { Label("Me", systemImage: "person.crop.circle") }
                    .tag(Tab.me)
            }
            .transition(.opacity)
        }
    }
}
