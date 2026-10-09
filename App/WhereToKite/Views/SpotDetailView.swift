import Charts
import MapKit
import SwiftUI
import KiteCore

struct SpotDetailView: View {
    let rec: SpotRecommendation
    let day: DayOption
    let profile: RiderProfile
    @State private var showScoreInfo = false

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                facts
                chart
                hourly

                if let notes = rec.spot.notes {
                    Text(notes).font(.footnote).foregroundStyle(.secondary)
                }
                if rec.spot.directionCheck == "uncertain" || rec.spot.directionCheck == "disagrees" {
                    Label("The beach direction isn't confirmed by a second map yet, so on- and offshore may be off.",
                          systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(rec.spot.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { directionsButton }
        .sheet(isPresented: $showScoreInfo) { ScoreInfoSheet(rec: rec) }
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: Hero: map with the verdict on top

    private var hero: some View {
        VStack(spacing: 0) {
            Map(initialPosition: .region(MKCoordinateRegion(
                center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000))) {
                Marker(rec.spot.name, systemImage: "wind", coordinate: coordinate)
                    .tint(ScoreStyle.color(rec.finalScore))
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .frame(height: 210)

            HStack(spacing: 14) {
                HStack(spacing: 14) {
                    ScoreRing(score: rec.finalScore, lineWidth: 6)
                        .frame(width: 58, height: 58)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(ScoreStyle.label(rec.finalScore)) · \(day.longLabel)")
                            .font(.title3.bold())
                        Text(rec.windSummary ?? rec.verdict)
                            .font(.subheadline)
                            .opacity(0.9)
                    }
                    Spacer(minLength: 0)
                }
                .accessibilityElement(children: .combine)
                Button { showScoreInfo = true } label: {
                    Image(systemName: "info.circle")
                        .font(.title3.weight(.semibold))
                        .padding(6)
                }
                .accessibilityLabel("How the score works")
                .accessibilityIdentifier("scoreInfo")
            }
            .foregroundStyle(.white)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ScoreStyle.gradient(rec.finalScore))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var facts: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                Fact(title: rec.windowInMyTime == nil ? "Best window" : "Best window · spot time",
                     value: rec.window.map { w in
                         "\(w.start)–\(w.end)h" + (rec.windowInMyTime.map { " · \($0) yours" } ?? "")
                     } ?? "–",
                     icon: "clock.fill", tint: .blue)
                Fact(title: "Kite", value: rec.suggestedKite.map { "\($0.size.formatted()) m" } ?? "–",
                     icon: "wind", tint: .teal)
            }
            if let tide = rec.tideSummary {
                GridRow {
                    Fact(title: "Tide · rides " + Self.tideRuleLabel(rec.spot.tide), value: tide,
                         icon: "water.waves.and.arrow.up", tint: .blue)
                        .gridCellColumns(2)
                }
            }
            GridRow {
                Fact(title: "Drive", value: rec.driveLabel, icon: "car.fill", tint: .indigo)
                Fact(title: rec.spot.allSides.count > 1 ? "Sides face" : "Beach faces",
                     value: (rec.spot.facingSummary ?? "Unknown")
                        + (rec.spot.waterSectorDeg.map { $0 < 360 ? " · \(Int($0))°" : "" } ?? ""),
                     icon: "water.waves", tint: .cyan)
            }
        }
    }

    static func tideRuleLabel(_ rule: String?) -> String {
        switch rule {
        case "high": "around high tide"
        case "low": "around low tide"
        case "mid": "at mid tide"
        case "not-low": "except at low tide"
        case "not-high": "except at high tide"
        default: "at any tide"
        }
    }

    // MARK: Chart

    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wind vs your kite").font(.headline)
            Chart {
                if let k = rec.suggestedKite {
                    RectangleMark(yStart: .value("Min", k.minKn), yEnd: .value("Max", k.maxKn))
                        .foregroundStyle(ScoreStyle.color(80).opacity(0.14))
                        .annotation(position: .overlay, alignment: .topLeading) {
                            Text("\(k.size.formatted()) m range").font(.caption2.weight(.semibold))
                                .foregroundStyle(ScoreStyle.color(80))
                        }
                }
                ForEach(rec.hours, id: \.wind.localTime) { h in
                    BarMark(x: .value("Hour", h.wind.hour), y: .value("Wind", h.wind.speedKn), width: 18)
                        .foregroundStyle(ScoreStyle.gradient(Int((h.score * 100).rounded())))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    PointMark(x: .value("Hour", h.wind.hour), y: .value("Gust", h.wind.gustKn))
                        .symbol(.circle)
                        .symbolSize(30)
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: (rec.hours.first?.wind.hour ?? 9) - 1 ... (rec.hours.last?.wind.hour ?? 17) + 1)
            .chartYScale(domain: 0...yMax)
            .chartXAxis {
                AxisMarks(values: rec.hours.map(\.wind.hour)) { value in
                    AxisValueLabel { if let h = value.as(Int.self) { Text("\(h)h") } }
                }
            }
            .frame(height: 190)
            Text("Bars: average wind (kn), coloured by score · Dots: gusts")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .card()
    }

    private var yMax: Double {
        let peak = max(rec.hours.map(\.wind.gustKn).max() ?? 0, rec.suggestedKite?.maxKn ?? 0)
        return (peak / 5).rounded(.up) * 5 + 5
    }

    // MARK: Hourly

    private var hourly: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hour by hour").font(.headline)
            VStack(spacing: 0) {
                ForEach(Array(rec.hours.enumerated()), id: \.element.wind.localTime) { i, h in
                    HStack(spacing: 10) {
                        Text(String(format: "%02d:00", h.wind.hour))
                            .font(.subheadline.weight(.semibold))
                            .monospacedDigit()
                            .frame(width: 52, alignment: .leading)
                        WindArrow(directionDeg: h.wind.directionDeg)
                            .foregroundStyle(WindStyle.color(h.wind.speedKn))
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(Int(h.wind.speedKn.rounded())) kn · gusts \(Int(h.wind.gustKn.rounded()))")
                                .font(.subheadline)
                                .monospacedDigit()
                            Text(hourDetail(h))
                                .font(.caption)
                                .foregroundStyle(h.flags.isEmpty ? Color.secondary : Color.orange)
                        }
                        Spacer()
                        ScoreBadge(score: Int((h.score * 100).rounded()), size: 32)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .accessibilityElement(children: .combine)
                    if i < rec.hours.count - 1 { Divider().padding(.leading, 14) }
                }
            }
            .card()
        }
    }

    private func hourDetail(_ h: HourScore) -> String {
        var parts = [Geo.compassName(h.wind.directionDeg)]
        if let a = h.relativeAngle { parts[0] += " " + Recommender.angleName(a) }
        if let side = h.side, h.score > 0 { parts.append(side) }
        if let k = h.kite { parts.append("\(k.size.formatted()) m") }
        parts += h.flags
        return parts.joined(separator: " · ")
    }

    private var directionsButton: some View {
        Button {
            let item: MKMapItem
            if #available(iOS 26, *) {
                item = MKMapItem(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), address: nil)
            } else {
                item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            }
            item.name = rec.spot.name
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } label: {
            Label("Directions", systemImage: "car.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .prominentButton()
        .controlSize(.large)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

private struct Fact: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Score explanation

/// "How is this scored?": the spot's factors for its best window, how the score is built,
/// and the rider's weights.
struct ScoreInfoSheet: View {
    let rec: SpotRecommendation
    @Environment(ProfileStore.self) private var profiles
    @Environment(PlanStore.self) private var plan
    @Environment(\.dismiss) private var dismiss

    /// The best window, or for a marginal spot (no window) the hours its score comes from.
    private var explained: (start: Int, end: Int)? { rec.window ?? rec.scoredHours }

    private var windowHours: [HourScore] {
        guard let w = explained else { return [] }
        return rec.hours.filter { $0.wind.hour >= w.start && $0.wind.hour < w.end }
    }

    private func mean(_ key: KeyPath<HourScore, Double?>) -> Double? {
        let v = windowHours.compactMap { $0[keyPath: key] }
        return v.isEmpty ? nil : v.reduce(0, +) / Double(v.count)
    }

    private var weights: ScoreWeights {
        plan.entitlements.scoreWeights ? (profiles.profile ?? .starter).scoreWeights : ScoreWeights()
    }

    /// 30 % by default, scaled by the "Short drive" weight (as in `Recommender.recommend`).
    private var maxDistanceLoss: Int {
        Int((min(1, ScoringRules().maxDistancePenalty * weights.distance) * 100).rounded())
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        ScoreBadge(score: rec.finalScore, size: 48)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(rec.finalScore) / 100 · \(ScoreStyle.label(rec.finalScore))")
                                .font(.title3.bold())
                            Text(rec.windowLabel.map { "Best window \($0)" } ?? rec.reason)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityElement(children: .combine)
                }

                if !windowHours.isEmpty {
                    Section {
                        FactorRow(title: "Wind strength", value: mean(\.strengthFactor), weight: weights.strength,
                                  detail: rec.suggestedKite.map { "Fit for your \($0.size.formatted()) m" })
                        FactorRow(title: "Steady wind", value: mean(\.steadinessFactor), weight: weights.steadiness,
                                  detail: gustDetail)
                        FactorRow(title: "Direction", value: mean(\.directionFactor), weight: weights.direction,
                                  detail: directionDetail)
                        if let tide = mean(\.tideFactor) {
                            FactorRow(title: "Tide", value: tide, weight: nil,
                                      detail: "Rides " + SpotDetailView.tideRuleLabel(rec.spot.tide))
                        }
                        if rec.distanceFactor < 1 {
                            FactorRow(title: "Drive", value: rec.distanceFactor, weight: weights.distance,
                                      detail: "\(rec.driveLabel) · distance matters is on")
                        }
                    } header: {
                        Text(rec.window != nil ? "This spot, best window"
                             : explained.map { "This spot, \($0.start)–\($0.end)h" } ?? "This spot")
                    } footer: {
                        Text("Averages over the window's hours. The score multiplies them, raised to your weights.")
                    }
                }

                Section("How the score works") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Every hour of your session gets three marks from 0 to 100 %:")
                        Text("**Wind strength**: how well the wind fits the best kite in your quiver, and your style (chill or intense).")
                        Text("**Steady wind**: gusts compared with the mean wind.")
                        Text("**Direction**: side-onshore is best, straight onshore is fine, cross-shore is harder, offshore is 0.")
                        Text("They are multiplied, using your weights. A spot's score is its best two hours in a row. Spots that need a certain tide lose the hours outside it, and with **Distance matters** far spots lose up to \(maxDistanceLoss) %.")
                        Text("Some limits never bend: wind or gusts over your level's limit, and offshore wind, always score 0.")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    .padding(.vertical, 4)
                }

                Section {
                    if !plan.entitlements.scoreWeights {
                        ProLockRow(title: "What matters to you", detail: "Your own weights with Pro")
                    } else {
                    NavigationLink {
                        ScrollView {
                            WeightsEditor(weights: profiles.weightsBinding)
                                .padding()
                        }
                        .background(Color(.systemGroupedBackground))
                        .navigationTitle("What matters to you")
                    } label: {
                        Label("What matters to you", systemImage: "slider.horizontal.3")
                    }
                    }
                } footer: {
                    Text("Changing your weights updates every score on your next search.")
                }
            }
            .navigationTitle("How is this scored?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }

    private var gustDetail: String? {
        let speeds = windowHours.map(\.wind.speedKn)
        guard let maxGust = windowHours.map(\.wind.gustKn).max(), let lo = speeds.min(), let hi = speeds.max() else { return nil }
        let wind = Int(lo.rounded()) == Int(hi.rounded()) ? "\(Int(hi.rounded()))" : "\(Int(lo.rounded()))–\(Int(hi.rounded()))"
        return "Wind \(wind) kn, gusts up to \(Int(maxGust.rounded())) kn"
    }

    private var directionDetail: String? {
        let a = windowHours.compactMap(\.relativeAngle)
        guard !a.isEmpty else { return "Beach direction unknown" }
        let name = Recommender.angleName(a.reduce(0, +) / Double(a.count))
        return name.prefix(1).uppercased() + name.dropFirst() + (Recommender.mainSide(windowHours).map { ", \($0)" } ?? "")
    }
}

private struct FactorRow: View {
    let title: String
    let value: Double?
    /// nil = not weighted (tide).
    let weight: Double?
    let detail: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.subheadline.weight(.semibold))
                if let weight, weight != 1 {
                    Text(WeightsEditor.label(weight))
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.tint.opacity(0.15), in: Capsule())
                }
                Spacer()
                Text(value.map { "\(Int(($0 * 100).rounded())) %" } ?? "–")
                    .font(.subheadline.monospacedDigit())
            }
            ProgressView(value: value ?? 0)
                .tint(ScoreStyle.color(Int(((value ?? 0) * 100).rounded())))
            if let detail {
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

