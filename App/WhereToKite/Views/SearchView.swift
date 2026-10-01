import SwiftUI
import KiteCore

/// The "Kite" tab: compact controls on top, the answer right below.
/// The search runs on its own with the remembered options and re-runs whenever a choice changes.
struct SearchView: View {
    @Environment(ProfileStore.self) private var profiles
    @State private var options = SearchOptions.load()
    @State private var model = SearchModel()
    @State private var path: [String] = []
    @State private var sheet: Sheet?
    @Namespace private var zoom

    enum Sheet: String, Identifiable {
        case profile, start, options
        var id: String { rawValue }
    }

    private struct SearchKey: Equatable {
        var options: SearchOptions
        var profile: RiderProfile?
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    controls
                    if let profile = profiles.profile {
                        ResultsSection(model: model, options: options, profile: profile, zoom: zoom,
                                       open: { path.append($0) },
                                       retry: { Task { await run() } })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Where to kite?")
            .refreshable { await run() }
            .task(id: SearchKey(options: options, profile: profiles.profile)) {
                // Short debounce so a burst of taps triggers one search.
                if model.result != nil {
                    try? await Task.sleep(for: .milliseconds(350))
                    guard !Task.isCancelled else { return }
                }
                options.save()
                await run()
            }
            .navigationDestination(for: String.self) { id in
                if let result = model.result, let profile = profiles.profile,
                   let rec = result.recommendations.first(where: { $0.id == id }) {
                    SpotDetailView(rec: rec, day: DayOption.with(id: result.request.day), profile: profile)
                        .zoomDestination(id, in: zoom)
                }
            }
            .sheet(item: $sheet) { sheet in
                switch sheet {
                case .profile:
                    ProfileSheet()
                case .start:
                    NavigationStack { StartPointPicker(selection: $options.start) }
                case .options:
                    SearchOptionsSheet(options: $options)
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }

    private func run() async {
        guard let profile = profiles.profile else { return }
        await model.run(options, profile: profile)
    }

    // MARK: Controls

    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let p = profiles.profile {
                        chip(p.shortSummary, systemImage: "figure.surfing", sheet: .profile)
                            .accessibilityLabel("Rider profile: \(p.shortSummary). Edit")
                            .accessibilityIdentifier("riderChip")
                    }
                    chip(options.start.isCurrentLocation ? "Near me" : options.start.name,
                         systemImage: options.start.isCurrentLocation ? "location.fill" : "mappin", sheet: .start)
                        .accessibilityLabel("Start from \(options.start.name)")
                    chip("≤ \(DriveSteps.label(options.maxDriveMinutes))", systemImage: "car.fill", sheet: .options)
                        .accessibilityLabel("Max drive \(DriveSteps.label(options.maxDriveMinutes))")
                    chip(styleLabel, systemImage: "slider.horizontal.3", sheet: .options)
                        .accessibilityLabel("Style \(styleLabel). More options")
                        .accessibilityIdentifier("optionsChip")
                }
                .padding(.vertical, 2)
            }
            .scrollClipDisabled()

            DayStrip(selection: $options.day)
            SlotPicker(selection: $options.slot)
        }
    }

    private func chip(_ text: String, systemImage: String, sheet: Sheet) -> some View {
        Button { self.sheet = sheet } label: {
            Pill(text: text, systemImage: systemImage)
        }
        .buttonStyle(.plain)
    }

    private var styleLabel: String {
        guard let i = options.intensity else { return "Any style" }
        return i < 0.35 ? "Chill" : i > 0.65 ? "Intense" : "Balanced"
    }
}

// MARK: - Day strip

private struct DayStrip: View {
    @Binding var selection: String
    private let days = DayOption.next()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(days) { day in
                    let on = selection == day.id
                    Button {
                        withAnimation(.snappy) { selection = day.id }
                    } label: {
                        VStack(spacing: 2) {
                            Text(day.shortLabel).font(.subheadline.weight(.semibold))
                            Text(day.date.formatted(.dateTime.day())).font(.title3.weight(.bold)).monospacedDigit()
                        }
                        .frame(minWidth: 52)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .foregroundStyle(on ? Color.white : Color.primary)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(on ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(Color(.secondarySystemGroupedBackground)))
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(day.longLabel)
                    .accessibilityIdentifier("day\(days.firstIndex(of: day) ?? 0)")
                    .accessibilityAddTraits(on ? .isSelected : [])
                }
            }
            .padding(.vertical, 2)
        }
        .scrollClipDisabled()
        .sensoryFeedback(.selection, trigger: selection)
    }
}

// MARK: - Session slot

private struct SlotPicker: View {
    @Binding var selection: SessionSlot
    @Namespace private var highlight

    var body: some View {
        HStack(spacing: 4) {
            ForEach(SessionSlot.allCases, id: \.self) { slot in
                let on = selection == slot
                Button {
                    withAnimation(.snappy) { selection = slot }
                } label: {
                    VStack(spacing: 1) {
                        Label(slot.label, systemImage: slot.symbol)
                            .font(.subheadline.weight(.semibold))
                            .labelStyle(.titleAndIcon)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Text(slot.hoursLabel)
                            .font(.caption2)
                            .foregroundStyle(on ? Color.white.opacity(0.85) : Color.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundStyle(on ? Color.white : Color.primary)
                    .background {
                        if on {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color.accentColor.gradient)
                                .matchedGeometryEffect(id: "slot", in: highlight)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(slot.label), \(slot.hoursLabel)")
                .accessibilityAddTraits(on ? .isSelected : [])
            }
        }
        .padding(4)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 17, style: .continuous))
        .sensoryFeedback(.selection, trigger: selection)
    }
}

// MARK: - More options

struct SearchOptionsSheet: View {
    @Binding var options: SearchOptions
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Max drive")
                            Spacer()
                            Text(DriveSteps.label(options.maxDriveMinutes))
                                .font(.title3.weight(.bold))
                                .monospacedDigit()
                                .foregroundStyle(.tint)
                                .contentTransition(.numericText(value: options.maxDriveMinutes))
                        }
                        Slider(value: driveIndex, in: 0...Double(DriveSteps.minutes.count - 1), step: 1) {
                            Text("Max drive")
                        } minimumValueLabel: {
                            Text("15 min").font(.caption2)
                        } maximumValueLabel: {
                            Text("10 h").font(.caption2)
                        }
                        .accessibilityValue(DriveSteps.label(options.maxDriveMinutes))
                        .accessibilityIdentifier("driveSlider")
                    }
                    Toggle("Closer is better", isOn: $options.distanceMatters)
                } header: {
                    Text("Drive")
                } footer: {
                    Text(options.distanceMatters
                         ? "Nearer spots rank higher when the wind is similar."
                         : "Spots are ranked on wind only.")
                }

                Section {
                    Toggle("Any style", isOn: anyStyle.animation(.snappy))
                    if let intensity = options.intensity {
                        VStack {
                            Slider(value: Binding(get: { intensity }, set: { options.intensity = $0 }), in: 0...1) {
                                Text("Style")
                            }
                            HStack {
                                Label("Chill", systemImage: "leaf.fill")
                                Spacer()
                                Label("Intense", systemImage: "bolt.fill")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Session style")
                } footer: {
                    Text(styleFooter)
                }
            }
            .navigationTitle("Search options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
        .sensoryFeedback(.selection, trigger: options.maxDriveMinutes)
    }

    private var driveIndex: Binding<Double> {
        Binding(get: { Double(DriveSteps.index(of: options.maxDriveMinutes)) },
                set: { options.maxDriveMinutes = DriveSteps.minutes[Int($0.rounded())] })
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

// MARK: - Start point

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
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Town, address…")
        .task(id: query) {
            guard query.count >= 3 else { results = []; return }
            try? await Task.sleep(for: .milliseconds(300))   // debounce typing
            guard !Task.isCancelled else { return }
            results = await LocationService.searchPlaces(query)
        }
    }
}
