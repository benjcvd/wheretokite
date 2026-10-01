import SwiftUI
import KiteCore

struct SearchView: View {
    @Environment(ProfileStore.self) private var profiles
    @State private var options = SearchOptions.load()
    @State private var showProfile = false
    @State private var showResults = false

    private let days = DayOption.next()

    var body: some View {
        NavigationStack {
            Form {
                if let profile = profiles.profile {
                    Section {
                        Button { showProfile = true } label: { ProfileSummary(profile: profile) }
                            .foregroundStyle(.primary)
                    }
                }

                Section("Where") {
                    NavigationLink {
                        StartPointPicker(selection: $options.start)
                    } label: {
                        LabeledContent("Start from") {
                            Label(options.start.name, systemImage: options.start.isCurrentLocation ? "location.fill" : "mappin")
                                .lineLimit(1)
                        }
                    }
                    VStack(alignment: .leading) {
                        LabeledContent("Max drive", value: driveLabel)
                        Slider(value: $options.maxDriveMinutes, in: 15...180, step: 15)
                    }
                    Toggle("Distance matters", isOn: $options.distanceMatters)
                }

                Section("When") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(days) { day in
                                DayChip(day: day, selected: options.day == day.id) { options.day = day.id }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    Picker("Session", selection: $options.slot) {
                        ForEach(SessionSlot.allCases, id: \.self) { Text($0.label) }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Toggle("Any style", isOn: anyStyle)
                    if let intensity = options.intensity {
                        VStack {
                            Slider(value: Binding(get: { intensity }, set: { options.intensity = $0 }), in: 0...1)
                            HStack {
                                Text("Chill").font(.caption)
                                Spacer()
                                Text("Intense").font(.caption)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Session style")
                } footer: {
                    Text(styleFooter)
                }

            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    options.save()
                    showResults = true
                } label: {
                    Label("Find spots", systemImage: "wind")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .disabled(profiles.profile == nil)
            }
            .navigationTitle("Where to kite?")
            .toolbar {
                Button { showProfile = true } label: { Image(systemName: "person.crop.circle") }
                    .accessibilityLabel("Rider profile")
            }
            .navigationDestination(isPresented: $showResults) {
                if let profile = profiles.profile {
                    ResultsView(options: options, profile: profile)
                }
            }
            .sheet(isPresented: $showProfile) {
                NavigationStack { ProfileView() }
            }
            .fullScreenCover(isPresented: .constant(profiles.profile == nil)) {
                NavigationStack { ProfileView(isOnboarding: true) }
            }
        }
    }

    private var driveLabel: String {
        let m = Int(options.maxDriveMinutes)
        return m < 60 ? "\(m) min" : m % 60 == 0 ? "\(m / 60) h" : "\(m / 60) h \(m % 60)"
    }

    private var anyStyle: Binding<Bool> {
        Binding(get: { options.intensity == nil },
                set: { options.intensity = $0 ? nil : 0.5 })
    }

    private var styleFooter: String {
        guard let i = options.intensity else { return "Any wind that's comfortable for your kites." }
        return i < 0.35 ? "Steady wind in the middle of your kite's range."
            : i > 0.65 ? "Powered up, near the top of your kite's range. Gusts are OK."
            : "A bit of everything."
    }
}

private struct DayChip: View {
    let day: DayOption
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(day.shortLabel).font(.subheadline.weight(.semibold))
                Text(day.date.formatted(.dateTime.day().month(.abbreviated))).font(.caption2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(selected ? Color.white : Color.primary)
            .background(selected ? Color.accentColor : Color(.tertiarySystemFill), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct ProfileSummary: View {
    let profile: RiderProfile

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "figure.surfing")
                .font(.title2)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(Int(profile.weightKg)) kg · \(profile.level.label)")
                    .font(.subheadline.weight(.semibold))
                Text("Kites: " + profile.kites.sorted().map { "\($0.formatted()) m" }.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("Edit").font(.caption).foregroundStyle(.tint)
        }
    }
}

struct StartPointPicker: View {
    @Binding var selection: StartPoint
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [StartPoint] = []

    var body: some View {
        List {
            Button {
                selection = .currentLocation
                dismiss()
            } label: {
                Label("Current location", systemImage: "location.fill")
            }
            ForEach(results, id: \.name) { place in
                Button {
                    selection = place
                    dismiss()
                } label: {
                    Label(place.name, systemImage: "mappin")
                }
            }
        }
        .navigationTitle("Start from")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Town, address…")
        .task(id: query) {
            guard query.count >= 3 else { results = []; return }
            try? await Task.sleep(for: .milliseconds(300))   // debounce typing
            guard !Task.isCancelled else { return }
            results = await LocationService.searchPlaces(query)
        }
    }
}

extension Level {
    var label: String { rawValue.capitalized }
}
