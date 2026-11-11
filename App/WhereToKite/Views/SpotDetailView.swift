import Charts
import MapKit
import SwiftUI
import KiteCore

struct SpotDetailView: View {
    let rec: SpotRecommendation
    let day: DayOption
    let profile: RiderProfile
    @State private var showScoreInfo = false
    @State private var showReport = false
    /// Kite whose range the wind chart shows (nil = the suggested kite).
    @State private var chartKiteSize: Double?
    @State private var showMap = false
    @Environment(FeedbackStore.self) private var feedback

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: rec.spot.latitude, longitude: rec.spot.longitude)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                if let storm = rec.stormLabel {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(storm).font(.subheadline.weight(.bold))
                            Text("Plan to be off the water before it. Storm cells can arrive early, with strong gusts ahead of them.")
                                .font(.footnote)
                        }
                    } icon: {
                        Image(systemName: "cloud.bolt.fill").font(.title3)
                    }
                    .foregroundStyle(.red)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("stormAlertDetail")
                }
                if let side = rec.sideOffshoreLabel {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(side).font(.subheadline.weight(.bold))
                            Text("The wind blows partly from the land: gustier, and it pushes you away from the beach. Ride only if you can always get back upwind.")
                                .font(.footnote)
                        }
                    } icon: {
                        Image(systemName: "arrow.up.backward.and.arrow.down.forward").font(.title3)
                    }
                    .foregroundStyle(.orange)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("sideOffshoreAlertDetail")
                }
                facts
                VerdictBanner(rec: rec)
                chart
                hourly

                if let bans = rec.spot.bans, !bans.isEmpty {
                    Label(String(localized: "Kiting banned \(bans.map(Self.banLabel).joined(separator: "; "))"),
                          systemImage: "nosign")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.orange)
                        .accessibilityIdentifier("spotBans")
                }
                // Curation notes are internal; only the rider's own notes on their own spots show.
                if rec.spot.isUserSpot {
                    if let notes = rec.spot.notes {
                        Text(notes).font(.footnote).foregroundStyle(.secondary)
                            .accessibilityIdentifier("spotUserNotes")
                    }
                } else {
                    Button("Report an issue with this spot", systemImage: "flag") { showReport = true }
                        .font(.footnote)
                        .accessibilityIdentifier("reportSpot")
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
        .sheet(isPresented: $showReport) { ReportIssueSheet(spot: rec.spot) }
        .fullScreenCover(isPresented: $showMap) { SpotMapScreen(rec: rec) }
        .onAppear { feedback.viewed(rec, day: day.id) }
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: Hero: map with the verdict on top

    private var hero: some View {
        VStack(spacing: 0) {
            heroMap

            HStack(spacing: 14) {
                HStack(spacing: 14) {
                    ScoreRing(score: rec.finalScore, lineWidth: 6)
                        .frame(width: 58, height: 58)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(verbatim: "\(ScoreStyle.label(rec.finalScore)) · \(day.longLabel)")
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

    /// Not draggable inside the scrolling page: a tap opens the full-screen map (WHE-156).
    private var heroMap: some View {
        let wind = MapWind.summary(MapWind.highlightedHours(rec))
        return Map(initialPosition: .region(MKCoordinateRegion(
            center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)), interactionModes: []) {
            Marker(rec.spot.name, systemImage: "wind", coordinate: coordinate)
                .tint(ScoreStyle.color(rec.finalScore))
            if let wind { SpotWindOverlay(spot: rec.spot, wind: wind) }
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .frame(height: 210)
        .overlay(alignment: .topLeading) {
            if let wind {
                Label(ShoreAngleStyle.label(wind), systemImage: "wind")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(10)
                    .accessibilityIdentifier("spotMapWind")
            }
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.footnote.weight(.bold))
                .frame(width: 30, height: 30)
                .background(.ultraThinMaterial, in: Circle())
                .padding(10)
        }
        .contentShape(Rectangle())
        .onTapGesture { showMap = true }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Open the map full screen"))
        .accessibilityIdentifier("spotMapHero")
    }

    private var facts: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                Fact(title: rec.windowInMyTime == nil ? String(localized: "Best window") : String(localized: "Best window · spot time"),
                     value: rec.window.map { w in
                         "\(w.start)–\(w.end)h" + (rec.windowInMyTime.map { String(localized: " · \($0) yours", comment: "The window in the phone's time zone") } ?? "")
                     } ?? "–",
                     icon: "clock.fill", tint: .blue)
                Fact(title: workingKites.count > 1 ? String(localized: "Kites") : String(localized: "Kite"),
                     value: workingKites.isEmpty ? "–"
                        : workingKites.map { "\($0.size.formatted()) m" }.formatted(.list(type: .or)),
                     icon: "wind", tint: .teal, lines: 2)
                    .accessibilityIdentifier("kiteFact")
            }
            if let tide = rec.tideSummary {
                GridRow {
                    Fact(title: String(localized: "Tide · rides \(Self.tideRuleLabel(rec.spot.tide))"), value: Vocab.tide(tide),
                         icon: "water.waves.and.arrow.up", tint: .blue)
                        .gridCellColumns(2)
                }
            }
            GridRow {
                Fact(title: String(localized: "Drive"), value: rec.driveLabel, icon: "car.fill", tint: .indigo)
                Fact(title: rec.spot.allSides.count > 1 ? String(localized: "Sides face") : String(localized: "Beach faces"),
                     value: (Vocab.facing(rec.spot) ?? String(localized: "Unknown"))
                        + (rec.spot.waterSectorDeg.map { $0 < 360 ? " · \(Int($0))°" : "" } ?? ""),
                     icon: "water.waves", tint: .cyan)
            }
        }
    }

    /// "15 Jun – 15 Sep, 11–19 h" or "1 Jun – 30 Sep, Sat, Sun" (month-days as in the catalogue, any year).
    static func banLabel(_ ban: SpotBan) -> String {
        func day(_ md: String) -> String {
            let p = md.split(separator: "-").compactMap { Int($0) }
            guard p.count == 2, let d = Calendar(identifier: .gregorian)
                .date(from: DateComponents(year: 2001, month: p[0], day: p[1])) else { return md }
            return d.formatted(.dateTime.day().month(.abbreviated))
        }
        var s = "\(day(ban.from)) – \(day(ban.to))"
        if let a = ban.startHour, let b = ban.endHour { s += ", \(a)–\(b) h" }
        if let days = ban.weekdays, !days.isEmpty {
            let names = Calendar.current.shortWeekdaySymbols   // index 0 = Sunday
            s += ", " + days.map { names[$0 % 7] }.joined(separator: ", ")
        }
        return s
    }

    static func tideRuleLabel(_ rule: String?) -> String {
        switch rule {
        case "high": String(localized: "around high tide")
        case "low": String(localized: "around low tide")
        case "mid": String(localized: "at mid tide")
        case "not-low": String(localized: "except at low tide")
        case "not-high": String(localized: "except at high tide")
        default: String(localized: "at any tide")
        }
    }

    // MARK: Chart

    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wind vs your kite").font(.headline)
            if quiver.count > 1 {
                Picker("Kite", selection: Binding(get: { chartKite?.size ?? 0 }, set: { chartKiteSize = $0 })) {
                    ForEach(quiver, id: \.size) { k in Text(verbatim: "\(k.size.formatted()) m").tag(k.size) }
                }
                .pickerStyle(.segmented)
                .accessibilityIdentifier("chartKitePicker")
            }
            Chart {
                if let k = chartKite {
                    RectangleMark(yStart: .value("Min", min(k.minKn, yMax)), yEnd: .value("Max", min(k.maxKn, yMax)))
                        .foregroundStyle(ScoreStyle.color(80).opacity(0.14))
                        .annotation(position: .overlay, alignment: .topLeading) {
                            Text("\(k.size.formatted()) m range").font(.caption2.weight(.semibold))
                                .foregroundStyle(ScoreStyle.color(80))
                        }
                }
                ForEach(rec.hours, id: \.wind.localTime) { h in
                    BarMark(x: .value("Hour", h.wind.hour), y: .value("Wind", h.wind.speedKn), width: 18)
                        .foregroundStyle(h.windFit.color)
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
                    AxisValueLabel { if let h = value.as(Int.self) { Text(verbatim: "\(h)h") } }
                }
            }
            .frame(height: 190)
            WindFitLegend(fits: Set(rec.hours.map(\.windFit)))
            Text("Bars: average wind (kn) · Dots: gusts")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .card()
    }

    /// The rider's kites, smallest first, as the chart's switch shows them.
    private var quiver: [KiteRange] {
        Scorer(profile: profile, intensity: nil).kiteRanges.sorted { $0.size < $1.size }
    }

    /// Kites that work for the whole best window, best first (display only).
    private var workingKites: [KiteRange] { rec.workingKites(in: quiver) }

    private var chartKite: KiteRange? {
        chartKiteSize.flatMap { s in quiver.first { $0.size == s } } ?? rec.suggestedKite ?? workingKites.first
            ?? quiver.min { abs($0.optimalKn - meanWind) < abs($1.optimalKn - meanWind) }
    }

    private var meanWind: Double {
        rec.hours.isEmpty ? 0 : rec.hours.map(\.wind.speedKn).reduce(0, +) / Double(rec.hours.count)
    }

    /// Covers the gusts and the suggested kite's range; grows only when the picked kite's range
    /// starts above that, so its band stays visible (the top of a tall band is clipped).
    private var yMax: Double {
        let peak = max(rec.hours.map(\.wind.gustKn).max() ?? 0, rec.suggestedKite?.maxKn ?? 0,
                       (chartKite?.minKn ?? 0) + 4)
        return (peak / 5).rounded(.up) * 5 + 5
    }

    // MARK: Hourly

    private var hourly: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hour by hour").font(.headline)
            VStack(spacing: 0) {
                ForEach(Array(rec.hours.enumerated()), id: \.element.wind.localTime) { i, h in
                    hourRow(h)
                    if i < rec.hours.count - 1 { Divider().padding(.leading, 14) }
                }
            }
            .card()
        }
    }

    /// Wind first: a bar you can compare at a glance (mean, then gusts lighter), the arrow, and
    /// on the right the kite for the hour, or a clear "can't ride" mark. No per-hour grade.
    private func hourRow(_ h: HourScore) -> some View {
        let fit = h.windFit
        return HStack(spacing: 10) {
            Text(String(format: "%02d:00", h.wind.hour))
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .frame(width: 48, alignment: .leading)
            WindArrow(directionDeg: h.wind.directionDeg)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .frame(width: 18)
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(verbatim: "\(Int(h.wind.speedKn.rounded()))")
                        .font(.headline)
                    Text("kn", comment: "Knots, after the hourly wind speed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("gusts \(Int(h.wind.gustKn.rounded()))", comment: "Hourly gusts in knots")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .monospacedDigit()
                WindBar(speedKn: h.wind.speedKn, gustKn: h.wind.gustKn, maxKn: yMax, color: fit.color)
                Text(hourDetail(h))
                    .font(.caption)
                    .foregroundStyle(h.flags.isEmpty ? Color.secondary : fit == .noGo ? Color.red : Color.orange)
            }
            Spacer(minLength: 4)
            if fit == .rideable, let k = h.kite {
                Text(verbatim: "\(k.size.formatted()) m")
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundStyle(fit.color)
                    .background(fit.color.opacity(0.14), in: Capsule())
            } else if fit != .rideable {
                Image(systemName: "nosign")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(Text("Can't ride", comment: "Hour with no rideable wind or unsafe"))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("hourRow")
    }

    private func hourDetail(_ h: HourScore) -> String {
        var parts = [Vocab.compass(h.wind.directionDeg)]
        if let a = h.relativeAngle { parts[0] += " " + Vocab.angle(a) }
        if let side = h.side, h.score > 0 { parts.append(side) }
        // Safety reasons come first in the flags (applySafety), so they lead the line.
        parts = h.flags.map(Vocab.term) + parts
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
    var lines = 1

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
                Text(value).font(.subheadline.weight(.semibold)).lineLimit(lines).minimumScaleFactor(0.8)
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
                            Text(verbatim: "\(rec.finalScore) / 100 · \(ScoreStyle.label(rec.finalScore))")
                                .font(.title3.bold())
                            Text(rec.windowLabel.map { String(localized: "Best window \($0)") } ?? rec.verdict)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityElement(children: .combine)
                }

                if !windowHours.isEmpty {
                    Section {
                        FactorRow(title: String(localized: "Wind strength"), value: mean(\.strengthFactor), weight: weights.strength,
                                  detail: rec.suggestedKite.map { String(localized: "Fit for your \($0.size.formatted()) m") })
                        FactorRow(title: String(localized: "Steady wind"), value: mean(\.steadinessFactor), weight: weights.steadiness,
                                  detail: gustDetail)
                        FactorRow(title: String(localized: "Direction"), value: mean(\.directionFactor), weight: weights.direction,
                                  detail: directionDetail)
                        if let tide = mean(\.tideFactor) {
                            FactorRow(title: String(localized: "Tide"), value: tide, weight: nil,
                                      detail: String(localized: "Rides \(SpotDetailView.tideRuleLabel(rec.spot.tide))"))
                        }
                        if let before = rec.scoreBeforeChance, before > 0, let outlook = rec.chance?.outlook {
                            FactorRow(title: String(localized: "Weather models"), value: Double(rec.finalScore) / Double(before),
                                      weight: nil,
                                      detail: outlook == .unlikely
                                        ? String(localized: "Too little wind likely: the grade is held at \(rec.finalScore) (was \(before))")
                                        : String(localized: "Wind uncertain: the grade is held at \(rec.finalScore) (was \(before))"))
                        }
                        if rec.distanceFactor < 1 {
                            FactorRow(title: String(localized: "Drive"), value: rec.distanceFactor, weight: weights.distance,
                                      detail: String(localized: "\(rec.driveLabel) · distance matters is on"))
                        }
                    } header: {
                        Text(rec.window != nil ? String(localized: "This spot, best window")
                             : explained.map { String(localized: "This spot, \($0.start)–\($0.end)h") } ?? String(localized: "This spot"))
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
                        Text("The grade gives the label, from **Go** (\(Vocab.verdictBand(.go))) down to **No go** (\(Vocab.verdictBand(.noGo))). Four weather models check the wind: when they aren't sure, the grade stops at \(ScoringRules().uncertainWindMaxScore); when they see too little wind, at \(ScoringRules().unlikelyWindMaxScore).")
                        Text("Some limits never bend: wind or gusts over your level's limit, and offshore wind, always score 0.")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    .padding(.vertical, 4)
                }

                if plan.entitlements.scoreWeights || plan.showsPro {
                Section {
                    if !plan.entitlements.scoreWeights {
                        ProLockRow(title: String(localized: "What matters to you"), detail: String(localized: "Your own weights with Pro"))
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
        return String(localized: "Wind \(wind) kn, gusts up to \(Int(maxGust.rounded())) kn")
    }

    private var directionDetail: String? {
        let a = windowHours.compactMap(\.relativeAngle)
        guard !a.isEmpty else { return String(localized: "Beach direction unknown") }
        let name = Vocab.angle(a.reduce(0, +) / Double(a.count))
        return name.prefix(1).localizedUppercase + name.dropFirst() + (Recommender.mainSide(windowHours).map { ", \($0)" } ?? "")
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
                Text(verbatim: value.map { "\(Int(($0 * 100).rounded())) %" } ?? "–")
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


// MARK: - Wind fit (hour by hour, chart colours)

/// What an hour's wind means for the rider, without a grade: rideable with a kite, too light,
/// too strong, or ruled out (storm, dark, offshore, ban, tide). Safety wins over wind strength.
enum WindFit: Hashable, CaseIterable {
    case rideable, tooLight, tooStrong, noGo

    var color: Color {
        switch self {
        case .rideable: Color(red: 0.10, green: 0.68, blue: 0.42)
        case .tooLight: Color(red: 0.45, green: 0.62, blue: 0.85)
        case .tooStrong: Color(red: 0.88, green: 0.30, blue: 0.30)
        case .noGo: Color(red: 0.55, green: 0.57, blue: 0.62)
        }
    }

    var label: String {
        switch self {
        case .rideable: String(localized: "Rideable", comment: "Chart legend: wind fits your kite")
        case .tooLight: String(localized: "Too light", comment: "Chart legend: not enough wind")
        case .tooStrong: String(localized: "Too strong", comment: "Chart legend: too much wind")
        case .noGo: String(localized: "Ruled out", comment: "Chart legend: storm, dark, offshore, ban or tide")
        }
    }
}

extension HourScore {
    var windFit: WindFit {
        let safety: Set<String> = ["thunderstorm risk", "kiting banned", "dark", "offshore component"]
        if flags.contains(where: safety.contains) { return .noGo }
        if score > 0 { return .rideable }
        if flags.contains("too light") { return .tooLight }
        if flags.contains("too strong for level") || flags.contains("too strong for quiver") { return .tooStrong }
        return .noGo
    }
}

/// Horizontal wind bar: mean wind solid, gusts as a lighter extension, on a shared scale.
private struct WindBar: View {
    let speedKn: Double
    let gustKn: Double
    let maxKn: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let scale = { (kn: Double) in max(4, min(w, w * kn / max(maxKn, 1))) }
            ZStack(alignment: .leading) {
                Capsule().fill(Color.secondary.opacity(0.12))
                Capsule().fill(color.opacity(0.35)).frame(width: scale(max(gustKn, speedKn)))
                Capsule().fill(color).frame(width: scale(speedKn))
            }
        }
        .frame(height: 8)
        .accessibilityHidden(true)
    }
}

private struct WindFitLegend: View {
    let fits: Set<WindFit>

    var body: some View {
        HStack(spacing: 12) {
            ForEach(WindFit.allCases.filter(fits.contains), id: \.self) { f in
                HStack(spacing: 4) {
                    Circle().fill(f.color).frame(width: 8, height: 8)
                    Text(f.label)
                }
            }
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .accessibilityElement(children: .combine)
    }
}
