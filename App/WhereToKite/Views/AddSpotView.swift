import CoreLocation
import MapKit
import SwiftUI
import KiteCore

/// Sheet to add a spot (location on a map → name, beach direction, notes) or edit one.
struct AddSpotView: View {
    private let original: Spot?

    @Environment(UserSpotStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var draft: SpotDraft
    @State private var path: [Step] = []

    private enum Step: Hashable { case details, moveLocation }

    init(editing spot: Spot? = nil) {
        original = spot
        _draft = State(initialValue: spot.map(SpotDraft.init) ?? SpotDraft())
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if original == nil {
                    LocationPicker(coordinate: draft.coordinate, confirmTitle: "Next") { c in
                        draft.coordinate = c
                        path.append(.details)
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { dismiss() }
                        }
                    }
                } else {
                    details
                }
            }
            .navigationDestination(for: Step.self) { step in
                switch step {
                case .details:
                    details
                case .moveLocation:
                    LocationPicker(coordinate: draft.coordinate, confirmTitle: "Done") { c in
                        draft.coordinate = c
                        path.removeLast()
                    }
                }
            }
        }
    }

    private var details: some View {
        SpotDetailsForm(draft: $draft, isNew: original == nil,
                        onMoveLocation: { path.append(.moveLocation) },
                        onSave: save,
                        onDelete: original.map { spot in { store.remove(id: spot.id); dismiss() } })
    }

    private func save() {
        guard let spot = draft.makeSpot() else { return }
        if original == nil { store.add(spot) } else { store.update(spot) }
        dismiss()
    }
}

// MARK: - Step 1: location

/// Pan the map under a fixed pin. Search and "my location" to jump around.
private struct LocationPicker: View {
    let coordinate: Coordinate?
    let confirmTitle: String
    let onConfirm: (Coordinate) -> Void

    @State private var position: MapCameraPosition
    @State private var center: CLLocationCoordinate2D?
    @State private var spanDeg = 1.0
    @State private var query = ""
    @State private var isSearching = false
    @State private var results: [MKMapItem] = []
    @State private var isLocating = false
    @State private var locationError: String?
    @State private var visibleRegion: MKCoordinateRegion?

    /// Close enough to put the pin on a precise beach.
    private var isZoomedIn: Bool { spanDeg < 0.08 }

    private static let barcelonaCoast = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.25, longitude: 1.9),
        span: MKCoordinateSpan(latitudeDelta: 1.6, longitudeDelta: 1.6))

    init(coordinate: Coordinate?, confirmTitle: String, onConfirm: @escaping (Coordinate) -> Void) {
        self.coordinate = coordinate
        self.confirmTitle = confirmTitle
        self.onConfirm = onConfirm
        if let coordinate {
            _position = State(initialValue: .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                latitudinalMeters: 1500, longitudinalMeters: 1500)))
        } else {
            let status = CLLocationManager().authorizationStatus
            let authorized = status == .authorizedWhenInUse || status == .authorizedAlways
            _position = State(initialValue: authorized
                ? .userLocation(fallback: .region(Self.barcelonaCoast))
                : .region(Self.barcelonaCoast))
        }
    }

    var body: some View {
        Map(position: $position, interactionModes: [.pan, .zoom]) {
            UserAnnotation()
        }
        .mapStyle(.hybrid(elevation: .flat))
        .mapControls { MapScaleView() }
        .onMapCameraChange(frequency: .continuous) { context in
            center = context.region.center
            spanDeg = context.region.span.latitudeDelta
            visibleRegion = context.region
        }
        .overlay { CenterPin() .allowsHitTesting(false) }
        .safeAreaInset(edge: .bottom) { bottomCard }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Where is it?")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .searchable(text: $query, isPresented: $isSearching,
                    placement: .navigationBarDrawer(displayMode: .always), prompt: "Search a beach or town")
        .searchSuggestions {
            ForEach(results, id: \.self) { item in
                Button {
                    jump(to: item)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name ?? "Place").foregroundStyle(.primary)
                        if let subtitle = Self.subtitle(item) {
                            Text(subtitle).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .onSubmit(of: .search) {
            if let first = results.first { jump(to: first) }
        }
        .task(id: query) { await search() }
        .alert("Location unavailable", isPresented: .constant(locationError != nil)) {
            Button("OK") { locationError = nil }
        } message: {
            Text(locationError ?? "")
        }
    }

    private var bottomCard: some View {
        VStack(spacing: 12) {
            Label(isZoomedIn ? "Move the map to put the pin where you launch."
                             : "Zoom in on the beach to place the pin.",
                  systemImage: isZoomedIn ? "hand.draw" : "plus.magnifyingglass")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentTransition(.opacity)

            HStack(spacing: 10) {
                Button {
                    Task { await locate() }
                } label: {
                    Group {
                        if isLocating { ProgressView() } else { Image(systemName: "location.fill") }
                    }
                    .frame(width: 24, height: 24)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .accessibilityLabel("Use my location")

                Button {
                    if let center { onConfirm(Coordinate(latitude: center.latitude, longitude: center.longitude)) }
                } label: {
                    Text(confirmTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .disabled(center == nil || !isZoomedIn)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        .safeAreaPadding(.bottom)
        .animation(.default, value: isZoomedIn)
    }

    private func jump(to item: MKMapItem) {
        let c: CLLocationCoordinate2D
        if #available(iOS 26, *) { c = item.location.coordinate } else { c = item.placemark.coordinate }
        withAnimation {
            position = .region(MKCoordinateRegion(center: c, latitudinalMeters: 2000, longitudinalMeters: 2000))
        }
        isSearching = false
        results = []
    }

    private func search() async {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard q.count >= 2 else { results = []; return }
        try? await Task.sleep(for: .milliseconds(300))
        guard !Task.isCancelled else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = q
        request.resultTypes = [.address, .pointOfInterest]
        if let visibleRegion { request.region = visibleRegion }
        let found = (try? await MKLocalSearch(request: request).start())?.mapItems ?? []
        guard !Task.isCancelled else { return }
        results = Array(found.prefix(6))
    }

    private func locate() async {
        isLocating = true
        defer { isLocating = false }
        do {
            let c = try await LocationService().currentCoordinate()
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude),
                    latitudinalMeters: 2000, longitudinalMeters: 2000))
            }
        } catch {
            locationError = error.localizedDescription
        }
    }

    private static func subtitle(_ item: MKMapItem) -> String? {
        if #available(iOS 26, *) { return item.address?.shortAddress }
        return item.placemark.locality ?? item.placemark.country
    }
}

/// Pin whose tip marks the map center.
private struct CenterPin: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle().fill(Color.accentColor)
                Image(systemName: "wind")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 34, height: 34)
            .overlay(Circle().stroke(.white, lineWidth: 2.5))
            Rectangle()
                .fill(.white)
                .frame(width: 3, height: 14)
            Circle()
                .fill(.black.opacity(0.35))
                .frame(width: 8, height: 4)
        }
        .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
        // Put the tip (bottom) on the center.
        .offset(y: -(34 + 14 + 2) / 2)
    }
}

// MARK: - Step 2: details

private struct SpotDetailsForm: View {
    @Binding var draft: SpotDraft
    let isNew: Bool
    let onMoveLocation: () -> Void
    let onSave: () -> Void
    let onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var isGuessing = false
    @State private var confirmDelete = false

    var body: some View {
        Form {
            Section {
                TextField("Spot name", text: $draft.name)
                    .font(.title3.weight(.semibold))
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .accessibilityIdentifier("spotName")
            } header: {
                Text("Name")
            }

            Section {
                if let coordinate = draft.coordinate {
                    orientationMap(coordinate)
                        .listRowInsets(EdgeInsets())
                }
                orientationStatus
            } header: {
                Text("Which way does the beach face?")
            } footer: {
                Text("Point the arrow from the beach toward the open water. It tells onshore, side-shore and offshore wind apart.")
            }

            Section {
                TextField("Access, parking, hazards, best wind…", text: $draft.notes, axis: .vertical)
                    .lineLimit(2...5)
            } header: {
                Text("Notes")
            }

            if !isNew {
                Section {
                    Button("Move the pin", systemImage: "mappin.and.ellipse", action: onMoveLocation)
                    if onDelete != nil {
                        Button("Delete spot", systemImage: "trash", role: .destructive) { confirmDelete = true }
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle(isNew ? "New spot" : "Edit spot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isNew {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: onSave)
                    .fontWeight(.semibold)
                    .disabled(!draft.isValid)
            }
        }
        .confirmationDialog("Delete \(draft.trimmedName)?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { onDelete?() }
        }
        .task(id: draft.coordinate) { await suggestOrientation() }
    }

    private func orientationMap(_ c: Coordinate) -> some View {
        let center = CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude)
        return Map(initialPosition: .region(MKCoordinateRegion(center: center, latitudinalMeters: 900,
                                                                longitudinalMeters: 900)),
                   interactionModes: []) {}
            .mapStyle(.hybrid(elevation: .flat, pointsOfInterest: .excludingAll))
            .id(c)
            .frame(height: 280)
            .overlay {
                OrientationDial(bearing: Binding(
                    get: { draft.seaFacingDeg },
                    set: { draft.seaFacingDeg = $0; draft.orientationSource = "user" }))
            }
            .overlay(alignment: .topTrailing) {
                if isGuessing {
                    ProgressView()
                        .padding(8)
                        .background(.regularMaterial, in: Circle())
                        .padding(10)
                }
            }
    }

    private var orientationStatus: some View {
        HStack(spacing: 12) {
            FacingBadge(bearing: draft.seaFacingDeg, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                if let deg = draft.seaFacingDeg {
                    Text("Faces \(Self.longName(deg))")
                        .font(.headline)
                    Text(draft.orientationSource == "user-suggested"
                         ? "\(Int(deg.rounded()))° · guessed from the coastline, drag to adjust"
                         : "\(Int(deg.rounded()))° · drag the arrow to adjust")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(isGuessing ? "Reading the coastline…" : "Not set yet")
                        .font(.headline)
                    Text("Tap the map on the water side")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("orientationStatus")
    }

    /// Pre-fill the direction from the map unless the user already set it by hand.
    private func suggestOrientation() async {
        guard let c = draft.coordinate,
              draft.seaFacingDeg == nil || draft.orientationSource == "user-suggested" else { return }
        isGuessing = true
        defer { isGuessing = false }
        guard let guess = await CoastlineGuess.seaBearing(at: c), !Task.isCancelled,
              draft.seaFacingDeg == nil || draft.orientationSource == "user-suggested" else { return }
        withAnimation(.snappy) {
            draft.seaFacingDeg = (guess / 5).rounded() * 5
            draft.orientationSource = "user-suggested"
        }
    }

    static func longName(_ deg: Double) -> String {
        let names = ["north", "north-northeast", "northeast", "east-northeast", "east", "east-southeast",
                     "southeast", "south-southeast", "south", "south-southwest", "southwest",
                     "west-southwest", "west", "west-northwest", "northwest", "north-northwest"]
        let i = Int((deg.truncatingRemainder(dividingBy: 360) + 360 + 11.25) / 22.5) % 16
        return names[i]
    }
}

// MARK: - Orientation dial

/// Compass ring drawn over a north-up map. Drag or tap to point the arrow at the water;
/// the water half is tinted blue.
struct OrientationDial: View {
    @Binding var bearing: Double?

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 40

            ZStack {
                if let bearing {
                    WaterSide(bearing: bearing, radius: radius)
                        .fill(Color.blue.opacity(0.32))
                        .overlay(WaterSide(bearing: bearing, radius: radius).stroke(.white.opacity(0.5), lineWidth: 1))
                }

                Circle()
                    .stroke(.white.opacity(0.85), lineWidth: 1.5)
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)

                ForEach(0..<16, id: \.self) { i in
                    let deg = Double(i) * 22.5
                    let major = i % 4 == 0
                    Capsule()
                        .fill(.white)
                        .frame(width: major ? 2.5 : 1.5, height: major ? 10 : 6)
                        .offset(y: -radius)
                        .rotationEffect(.degrees(deg))
                        .position(center)
                }

                ForEach(Array(["N", "E", "S", "W"].enumerated()), id: \.offset) { i, letter in
                    let deg = Double(i) * 90
                    Text(letter)
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.white)
                        .position(point(center, deg, radius + 16))
                }

                if let bearing {
                    Arrow(bearing: bearing, radius: radius)
                        .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    Image(systemName: "water.waves")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(Color.blue))
                        .overlay(Circle().stroke(.white, lineWidth: 2.5))
                        .position(point(center, bearing, radius))
                }

                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(.white, lineWidth: 3))
                    .position(center)
            }
            .shadow(color: .black.opacity(0.35), radius: 2)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                let dx = value.location.x - center.x
                let dy = value.location.y - center.y
                guard dx * dx + dy * dy > 18 * 18 else { return }
                var deg = atan2(dx, -dy) * 180 / .pi
                if deg < 0 { deg += 360 }
                let snapped = ((deg / 5).rounded() * 5).truncatingRemainder(dividingBy: 360)
                if snapped != bearing { bearing = snapped }
            })
            .sensoryFeedback(.selection, trigger: bearing.map(Geo.compassName))
            .animation(.snappy(duration: 0.15), value: bearing)
        }
        .accessibilityElement()
        .accessibilityLabel("Beach direction")
        .accessibilityValue(bearing.map { "\(Geo.compassName($0)), \(Int($0)) degrees" } ?? "Not set")
        .accessibilityAdjustableAction { direction in
            let current = bearing ?? 0
            switch direction {
            case .increment: bearing = (current + 22.5).truncatingRemainder(dividingBy: 360)
            case .decrement: bearing = (current + 360 - 22.5).truncatingRemainder(dividingBy: 360)
            @unknown default: break
            }
        }
    }

    private func point(_ c: CGPoint, _ bearing: Double, _ r: CGFloat) -> CGPoint {
        let b = bearing * .pi / 180
        return CGPoint(x: c.x + r * sin(b), y: c.y - r * cos(b))
    }
}

/// Half disc on the water side of the beach.
private struct WaterSide: Shape {
    var bearing: Double
    var radius: CGFloat

    var animatableData: Double {
        get { bearing }
        set { bearing = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        var p = Path()
        p.move(to: c)
        // Screen angle 0 = east; compass 0 = north.
        p.addArc(center: c, radius: radius, startAngle: .degrees(bearing - 180), endAngle: .degrees(bearing),
                 clockwise: false)
        p.closeSubpath()
        return p
    }
}

private struct Arrow: Shape {
    var bearing: Double
    var radius: CGFloat

    var animatableData: Double {
        get { bearing }
        set { bearing = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        var p = Path()
        p.move(to: c)
        p.addLine(to: CGPoint(x: c.x, y: c.y - radius + 17))
        return p.applying(CGAffineTransform(translationX: -c.x, y: -c.y)
            .concatenating(CGAffineTransform(rotationAngle: bearing * .pi / 180))
            .concatenating(CGAffineTransform(translationX: c.x, y: c.y)))
    }
}
