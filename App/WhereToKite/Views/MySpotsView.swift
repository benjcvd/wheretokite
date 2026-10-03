import SwiftUI
import KiteCore

/// Root of the "My spots" tab: the spots the user added, with add / edit / delete.
/// CONTRACT (shared by agents): `MySpotsView()` with `UserSpotStore` in the environment.
/// Includes its own NavigationStack.
struct MySpotsView: View {
    @Environment(UserSpotStore.self) private var store
    @State private var isAdding = false
    @State private var editing: Spot?

    private var sortedSpots: [Spot] {
        store.spots.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.spots.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("My spots")
            .toolbar {
                if !store.spots.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add spot", systemImage: "plus") { isAdding = true }
                    }
                }
            }
            .sheet(isPresented: $isAdding) {
                AddSpotView()
            }
            .sheet(item: $editing) { spot in
                AddSpotView(editing: spot)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Your secret spots", systemImage: "mappin.and.ellipse")
        } description: {
            Text("We list the well-known spots. Know a quieter one? Add it and it will be ranked in every search, just like the others.")
        } actions: {
            Button {
                isAdding = true
            } label: {
                Label("Add a spot", systemImage: "plus")
                    .font(.headline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }

    private var list: some View {
        List {
            Section {
                ForEach(sortedSpots) { spot in
                    Button {
                        editing = spot
                    } label: {
                        UserSpotRow(spot: spot)
                    }
                    .tint(.primary)
                    .accessibilityIdentifier("userSpotRow")
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            withAnimation { store.remove(id: spot.id) }
                        }
                        Button("Edit", systemImage: "pencil") { editing = spot }
                            .tint(.orange)
                    }
                }
            } footer: {
                Text("Your spots are included in every search. Swipe left on a spot to delete it.")
            }
        }
    }
}

private struct UserSpotRow: View {
    let spot: Spot

    var body: some View {
        HStack(spacing: 14) {
            FacingBadge(bearing: spot.seaFacingDeg)
            VStack(alignment: .leading, spacing: 3) {
                Text(spot.name)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    private var subtitle: String {
        let facing = spot.facingSummary.map { "Faces \($0)" } ?? "Direction unknown"
        if let notes = spot.notes, !notes.isEmpty { return "\(facing) · \(notes)" }
        return facing
    }
}

/// Round badge with an arrow pointing toward the water.
struct FacingBadge: View {
    let bearing: Double?
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle().fill(Color.blue.opacity(0.14))
            if let bearing {
                Image(systemName: "location.north.fill")
                    .font(.system(size: size * 0.4, weight: .semibold))
                    .foregroundStyle(.blue)
                    .rotationEffect(.degrees(bearing))
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(bearing.map { "Beach faces \(Geo.compassName($0))" } ?? "Direction unknown")
    }
}
