import MapKit
import SwiftUI
import KiteCore

/// The answer: a verdict for the best spot, then the runners-up as a list or a map.
struct ResultsSection: View {
    let model: SearchModel
    let options: SearchOptions
    let profile: RiderProfile
    let zoom: Namespace.ID
    let open: (String) -> Void
    let retry: () -> Void

    @State private var mode = Mode.list
    @State private var showNoGo = false

    enum Mode: String, CaseIterable { case list = "List", map = "Map" }

    var body: some View {
        Group {
            if let result = model.result {
                content(result)
                    .opacity(model.progress == nil ? 1 : 0.55)
                    .animation(.snappy, value: model.generation)
            } else if let error = model.error {
                errorCard(error)
            } else {
                LoadingCard(message: model.progress ?? "Checking the wind…")
            }
        }
        .sensoryFeedback(trigger: model.generation) { _, _ in
            (model.result?.recommendations.first?.finalScore ?? 0) > 0 ? .success : .warning
        }
    }

    /// Score from which the top spot gets the "go" card.
    static let verdictMinimum = 40

    // MARK: Result

    @ViewBuilder
    private func content(_ result: SearchResult) -> some View {
        let good = result.recommendations.filter { $0.finalScore > 0 }
        let noGo = result.recommendations.filter { $0.finalScore == 0 }
        // Only a real session earns the big "go" card; below that the options are marginal.
        let hasVerdict = (good.first?.finalScore ?? 0) >= Self.verdictMinimum
        let listed = hasVerdict ? Array(good.dropFirst()) : good

        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Text(summary(result))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Spacer(minLength: 0)
                if model.progress != nil {
                    ProgressView().controlSize(.small)
                        .accessibilityLabel("Updating")
                        .accessibilityIdentifier("searching")
                }
            }

            if let error = model.error {
                Label(error, systemImage: "wifi.exclamationmark")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }

            if hasVerdict, let top = good.first {
                Button { open(top.id) } label: { VerdictCard(rec: top) }
                    .buttonStyle(PressableStyle())
                    .zoomSource(top.id, in: zoom)
                    .accessibilityIdentifier("topSpot")
                    .accessibilityHint("Shows the hourly forecast and directions")
            } else if result.recommendations.isEmpty {
                NoSpotCard(title: "No spot in reach",
                           message: "No known spot within \(DriveSteps.label(result.request.maxDriveMinutes)) of \(options.start.isCurrentLocation ? "you" : options.start.name). Allow a longer drive or pick another start point.")
            } else if !good.isEmpty {
                NoSpotCard(title: "Nothing great",
                           message: "Only marginal conditions, listed below. Try another day or session, or allow a longer drive.")
            } else {
                NoSpotCard(title: "No kiteable spot",
                           message: "Not enough good wind. Try another day or session, or allow a longer drive.")
            }

            if let confidence = result.confidence {
                ConfidenceBanner(confidence: confidence)
            }

            if !good.isEmpty {
                HStack {
                    Text(!hasVerdict ? "Marginal" : good.count > 1 ? "Also good" : "On the map")
                        .font(.title3.bold())
                    Spacer()
                    // With a single good spot the list would be empty (the spot is the card
                    // above): show the map only.
                    if !listed.isEmpty {
                        Picker("View", selection: $mode.animation(.snappy)) {
                            ForEach(Mode.allCases, id: \.self) { Text($0.rawValue) }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                }
                .padding(.top, 4)

                switch !listed.isEmpty ? mode : .map {
                case .list:
                    VStack(spacing: 10) {
                        ForEach(listed) { rec in
                            Button { open(rec.id) } label: { SpotCard(rec: rec) }
                                .buttonStyle(PressableStyle())
                                .zoomSource(rec.id, in: zoom)
                                .accessibilityIdentifier("spotRow")
                        }
                    }
                    .transition(.opacity)
                case .map:
                    SpotsMap(recs: good, origin: result.request.origin, open: open)
                        .id(model.generation)
                        .transition(.opacity)
                }
            }

            if !noGo.isEmpty {
                DisclosureGroup(isExpanded: $showNoGo.animation(.snappy)) {
                    VStack(spacing: 0) {
                        ForEach(noGo) { rec in
                            Button { open(rec.id) } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(rec.spot.name).font(.subheadline.weight(.medium))
                                        Text(rec.verdict).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                    .padding(.top, 6)
                } label: {
                    Label("Not kiteable (\(noGo.count))", systemImage: "wind.snow")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .padding(14)
                .card()
            }

            Text("Weather data by Open-Meteo.com · Spots © OpenStreetMap contributors")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }

    private func summary(_ result: SearchResult) -> String {
        let day = DayOption.with(id: result.request.day)
        let from = options.start.isCurrentLocation ? "you" : options.start.name
        return "\(day.longLabel) · \(result.request.slot.label) \(result.request.slot.hoursLabel) · within \(DriveSteps.label(result.request.maxDriveMinutes)) of \(from)"
    }

    private func errorCard(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark").font(.largeTitle).foregroundStyle(.orange)
            Text("Search failed").font(.headline)
            Text(message).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button("Try again", action: retry).prominentButton()
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .card()
    }
}

// MARK: - Verdict hero

struct VerdictCard: View {
    let rec: SpotRecommendation

    private var eyebrow: String {
        switch rec.finalScore {
        case 75...: "Go kite"
        case 50..<75: "Worth the trip"
        default: "Kiteable, just"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(eyebrow.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.2)
                        .opacity(0.85)
                    Text(rec.spot.name)
                        .font(.title.bold())
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 8)
                ScoreRing(score: rec.finalScore)
                    .frame(width: 60, height: 60)
            }

            if let w = rec.windowLabel {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(w)
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .monospacedDigit()
                    if let speed = rec.windRange {
                        Text(speed).font(.title3.weight(.semibold)).opacity(0.9)
                    }
                }
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            }

            FlowLayout(spacing: 8) { facts }

            if !rec.warnings.isEmpty {
                Label(rec.warnings.joined(separator: ", "), systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote.weight(.semibold))
            }
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ScoreStyle.gradient(rec.finalScore))
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "wind")
                        .font(.system(size: 140, weight: .bold))
                        .foregroundStyle(.white.opacity(0.08))
                        .offset(x: 30, y: 40)
                        .accessibilityHidden(true)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: ScoreStyle.color(rec.finalScore).opacity(0.35), radius: 18, y: 10)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder private var facts: some View {
        if let dir = rec.windDirectionLabel { glassFact(dir, "location.north.line.fill") }
        if let k = rec.suggestedKite { glassFact("\(k.size.formatted()) m kite", "wind") }
        glassFact(rec.driveLabel, "car.fill")
    }

    private func glassFact(_ text: String, _ icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.subheadline.weight(.semibold))
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.18), in: Capsule())
    }
}

private struct NoSpotCard: View {
    let title: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "wind.snow").font(.largeTitle).accessibilityHidden(true)
            Text(title).font(.title2.bold())
            Text(message)
                .font(.subheadline)
                .opacity(0.9)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ScoreStyle.gradient(0), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("noSpot")
    }
}

private struct LoadingCard: View {
    let message: String
    @State private var pulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ProgressView().tint(.white)
                Text(message).font(.subheadline.weight(.semibold))
            }
            RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.25)).frame(width: 200, height: 26)
            RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)).frame(width: 140, height: 34)
            HStack {
                ForEach(0..<3, id: \.self) { _ in Capsule().fill(.white.opacity(0.18)).frame(width: 80, height: 28) }
            }
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .opacity(pulse ? 0.75 : 1)
        .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
        .onAppear { pulse = true }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Runner-up card

struct SpotCard: View {
    let rec: SpotRecommendation

    var body: some View {
        HStack(spacing: 12) {
            ScoreBadge(score: rec.finalScore)
            VStack(alignment: .leading, spacing: 4) {
                Text(rec.spot.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(rec.windSummary ?? rec.verdict)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    if let w = rec.windowLabel { Label(w, systemImage: "clock") }
                    Label(rec.driveLabel, systemImage: "car")
                    if let k = rec.suggestedKite { Label("\(k.size.formatted()) m", systemImage: "wind") }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                if !rec.warnings.isEmpty {
                    Label(rec.warnings.joined(separator: ", "), systemImage: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .foregroundStyle(.primary)
        .padding(14)
        .card()
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Map

private struct SpotsMap: View {
    let recs: [SpotRecommendation]
    let origin: Coordinate
    let open: (String) -> Void

    var body: some View {
        Map(initialPosition: .automatic) {
            Annotation("Start", coordinate: CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude)) {
                Image(systemName: "figure.stand")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.accentColor, in: Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 2))
            }
            ForEach(recs) { rec in
                Annotation(rec.spot.name,
                           coordinate: CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude)) {
                    Button { open(rec.id) } label: {
                        ScoreBadge(score: rec.finalScore, size: 34)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.white, lineWidth: 2))
                            .shadow(radius: 3, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
        .frame(height: 380)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

/// Lays children out left to right, wrapping onto new lines as needed.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews: subviews)
        let width = rows.map { $0.width }.max() ?? 0
        let height = rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(0, rows.count - 1))
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(width: bounds.width, subviews: subviews) {
            var x = bounds.minX
            for i in row.indices {
                let size = subviews[i].sizeThatFits(.unspecified)
                subviews[i].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row { var indices: [Int] = []; var width: CGFloat = 0; var height: CGFloat = 0 }

    private func arrange(width: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = [Row()]
        for i in subviews.indices {
            let size = subviews[i].sizeThatFits(.unspecified)
            let needed = rows[rows.count - 1].indices.isEmpty ? size.width : rows[rows.count - 1].width + spacing + size.width
            if needed > width, !rows[rows.count - 1].indices.isEmpty {
                rows.append(Row(indices: [i], width: size.width, height: size.height))
            } else {
                rows[rows.count - 1].indices.append(i)
                rows[rows.count - 1].width = needed
                rows[rows.count - 1].height = max(rows[rows.count - 1].height, size.height)
            }
        }
        return rows
    }
}

/// Subtle press-down scale for tappable cards.
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Labels

extension SpotRecommendation {
    var windowHours: [HourScore] {
        guard let window else { return [] }
        return hours.filter { $0.wind.hour >= window.start && $0.wind.hour < window.end }
    }

    /// "15–18 kn"
    var windRange: String? {
        let hs = windowHours
        guard let lo = hs.map(\.wind.speedKn).min(), let hi = hs.map(\.wind.speedKn).max() else { return nil }
        let l = Int(lo.rounded()), h = Int(hi.rounded())
        return l == h ? "\(h) kn" : "\(l)–\(h) kn"
    }

    /// "SSW side-onshore"
    var windDirectionLabel: String? {
        let hs = windowHours
        guard !hs.isEmpty else { return nil }
        let dir = Geo.compassName(Geo.circularStats(hs.map(\.wind.directionDeg)).mean)
        let angles = hs.compactMap(\.relativeAngle)
        let side = angles.isEmpty ? "" : " " + Recommender.angleName(angles.reduce(0, +) / Double(angles.count))
        return dir + side
    }

    /// "15–18 kn · gusts 22 · SSW side-onshore"
    var windSummary: String? {
        guard let speed = windRange, let gust = windowHours.map(\.wind.gustKn).max(),
              let dir = windDirectionLabel else { return nil }
        return "\(speed) · gusts \(Int(gust.rounded())) · \(dir)"
    }

    /// Why a spot isn't recommended, without the drive time (shown separately).
    var verdict: String {
        reason.components(separatedBy: " · ").dropLast().joined(separator: " · ")
    }

    var warnings: [String] {
        Array(Set(windowHours.flatMap(\.flags))).sorted()
    }
}
