import SwiftUI

/// Entry screen for the user's own spots: list + add/edit.
/// CONTRACT (shared by agents): `MySpotsView()` with `UserSpotStore` in the environment.
/// Placeholder — the user-spots work replaces this file.
struct MySpotsView: View {
    var body: some View {
        ContentUnavailableView("My spots", systemImage: "mappin.and.ellipse",
                               description: Text("Add the spots you know."))
    }
}
