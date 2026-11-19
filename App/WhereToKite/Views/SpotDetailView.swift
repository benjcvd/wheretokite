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
                if let doubt = rec.modelDoubt, let chance = rec.chance {
                    modelDoubtNote(doubt, chance: chance)
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
                Fact(title: String(localized: "Drive"), value: rec.driveLabel, icon: "car.fill", tint: .indigo)
            }
            if let tide = rec.tideSummary {
                GridRow {
                    Fact(title: String(localized: "Tide · rides \(Self.tideRuleLabel(rec.spot.tide))"), value: Vocab.tide(tide),
                         icon: "water.waves.and.arrow.up", tint: .blue)
                        .gridCellColumns(2)
                }
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

    // MARK: Models disagree (WHE-238)

    /// Why the grade is held back although the chart shows one clean forecast. Its numbers are
    /// the checked models' best hours (the chance check), named, so they can differ from the bars.
    private func modelDoubtNote(_ doubt: ModelDoubt, chance: KiteChance) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(Vocab.modelDoubt(doubt)).font(.subheadline.weight(.bold))
                Text(Vocab.modelDoubtDetail(chance))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: "arrow.up.and.down.circle.fill").font(.title3)
                .foregroundStyle(rec.kiteVerdict.color)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(rec.kiteVerdict.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("modelDoubtNote")
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
                // The blended models' low–high wind, behind the bars: wider than a bar, light, so it
                // shows as a halo where the models spread and the bars and gust dots stay readable.
                ForEach(rec.hours.filter { $0.wind.modelSpeedRangeKn != nil }, id: \.wind.localTime) { h in
                    if let r = h.wind.modelSpeedRangeKn {
                        RectangleMark(x: .value("Hour", h.wind.hour),
                                      yStart: .value("Lowest model", min(r.lowerBound, yMax)),
                                      yEnd: .value("Highest model", min(r.upperBound, yMax)), width: 28)
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .accessibilityLabel(Text(verbatim: "\(h.wind.hour)h"))
                            .accessibilityValue(Text("Models \(Int(r.lowerBound.rounded())) to \(Int(r.upperBound.rounded())) knots",
                                                     comment: "VoiceOver, wind chart: lowest to highest weather model this hour"))
                    }
                }
                ForEach(rec.hours, id: \.wind.localTime) { h in
                    let fit = h.windFit(for: chartKite)
                    // Gusts alone over the rider's limit: the dot takes the red, the bar shows the
                    // mean wind against the kite, faded because the hour still can't be ridden.
                    let gustRuled = fit == .tooStrong && h.gustOverLimit
                    BarMark(x: .value("Hour", h.wind.hour), y: .value("Wind", h.wind.speedKn), width: 18)
                        .foregroundStyle(gustRuled ? h.meanFit(for: chartKite).color.opacity(0.35) : fit.color)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    PointMark(x: .value("Hour", h.wind.hour), y: .value("Gust", h.wind.gustKn))
                        .symbol(.circle)
                        .symbolSize(gustRuled ? 60 : 30)
                        .foregroundStyle(gustRuled ? AnyShapeStyle(WindFit.tooStrong.color) : AnyShapeStyle(.secondary))
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
            WindFitLegend(fits: Set(rec.hours.map { $0.windFit(for: chartKite) }), noGoLabel: noGoLegend)
            if modelBandCount > 1 {
                // WHE-242: the band says what it is where it's drawn.
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 12, height: 8)
                    Text("Grey band: lowest to highest of the \(modelBandCount) models",
                         comment: "Wind chart legend: the grey band behind each bar spans the weather models' winds")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("modelBandLegend")
            }
            Group {
                Text("Bars: average wind (kn) · Dots: gusts")
                if let source = ForecastSource.summary(rec.hours.map(\.wind)) {
                    Group {
                        if rec.hours.contains(where: { ($0.wind.models?.count ?? 0) > 1 }) {
                            Text("Forecast: average of \(source)",
                                 comment: "Under the wind chart: the weather models the bars average, e.g. AROME 1.3 km · ECMWF 9 km · GFS")
                        } else {
                            Text("Forecast: \(source)", comment: "Under the wind chart: the one weather model behind the bars")
                        }
                    }
                    .accessibilityIdentifier("chartModels")
                }
            }
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

    /// How many models the grey band spans (0 when there's no band).
    private var modelBandCount: Int {
        rec.hours.filter { $0.wind.modelSpeedRangeKn != nil }.map { $0.wind.modelSpeedsKn?.count ?? 0 }.max() ?? 0
    }

    /// "No go: storm, dark": the chart legend names why its grey hours can't be ridden.
    private var noGoLegend: String {
        let words = WindFit.noGoWords(rec.hours.filter { $0.windFit(for: chartKite) == .noGo })
        return words.isEmpty ? WindFit.noGo.label
            : String(localized: "No go: \(words.joined(separator: ", "))",
                     comment: "Wind chart legend: grey hours and why, e.g. 'No go: storm, dark'")
    }

    /// Covers the gusts and the suggested kite's range; grows only when the picked kite's range
    /// starts above that, so its band stays visible (the top of a tall band is clipped).
    private var yMax: Double {
        let peak = max(rec.hours.map(\.wind.gustKn).max() ?? 0, rec.suggestedKite?.maxKn ?? 0,
                       rec.hours.compactMap { $0.wind.modelSpeedRangeKn?.upperBound }.max() ?? 0,
                       (chartKite?.minKn ?? 0) + 4)
        return (peak / 5).rounded(.up) * 5 + 5
    }

    // MARK: Hourly

    /// Column widths grow with the text size, so numbers stay aligned at every Dynamic Type size.
    @ScaledMetric(relativeTo: .subheadline) private var timeColumn: CGFloat = 50
    @ScaledMetric(relativeTo: .headline) private var windColumn: CGFloat = 46
    @ScaledMetric(relativeTo: .subheadline) private var gustColumn: CGFloat = 46
    @ScaledMetric(relativeTo: .footnote) private var kiteColumn: CGFloat = 44

    /// WHE-225: one aligned line per hour (time, wind, gusts, direction, kite), the wind tinted by
    /// what it means for your kites; a second line only when something needs saying.
    private var hourly: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("Wind hour by hour").font(.headline)
                Spacer()
                Text("in knots", comment: "Unit note beside the 'Wind hour by hour' title")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 0) {
                hourHeader
                Divider()
                ForEach(Array(rec.hours.enumerated()), id: \.element.wind.localTime) { i, h in
                    hourRow(h)
                    if i < rec.hours.count - 1 { Divider().padding(.leading, 14) }
                }
            }
            .card()
        }
    }

    private var hourHeader: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: timeColumn, height: 1)
            Text("Wind").frame(width: windColumn)
            Text("Gusts", comment: "Column title: gusts, in the wind hour by hour")
                .frame(width: gustColumn)
            Text("Direction").frame(maxWidth: .infinity, alignment: .leading)
            Text("Kite").frame(width: kiteColumn, alignment: .trailing)
        }
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .accessibilityHidden(true)
    }

    /// Wind first, no per-hour grade: the speed in a pill coloured by fit (rideable, too light,
    /// too strong, ruled out), gusts beside it, the arrow and how it meets the beach, then the
    /// kite for the hour or a clear "can't ride" mark.
    private func hourRow(_ h: HourScore) -> some View {
        let fit = h.windFit
        let speed = Int(h.wind.speedKn.rounded()), gust = Int(h.wind.gustKn.rounded())
        // Gusts alone over the rider's limit: the gust number takes the red, the wind stays plain.
        let gustRuled = fit == .tooStrong && h.gustOverLimit
        let windColor = gustRuled ? Color.primary : fit.color
        return VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 8) {
                Text(String(format: "%02d:00", h.wind.hour))
                    .font(.subheadline.weight(.semibold))
                    .frame(width: timeColumn, alignment: .leading)
                Text(verbatim: "\(speed)")
                    .font(.headline)
                    .foregroundStyle(windColor)
                    .frame(width: windColumn)
                    .padding(.vertical, 3)
                    .background(gustRuled ? Color.secondary.opacity(0.12) : fit.color.opacity(0.14), in: Capsule())
                Text(verbatim: "\(gust)")
                    .font(gustRuled ? .subheadline.weight(.bold) : .subheadline)
                    .foregroundStyle(gustRuled ? fit.color : .secondary)
                    .frame(width: gustColumn)
                HStack(spacing: 6) {
                    WindArrow(directionDeg: h.wind.directionDeg, modelArc: h.wind.modelDirectionArcDeg)
                        .font(.footnote)
                    Text(hourDirection(h))
                        .font(.footnote)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Group {
                    if fit == .rideable, let k = h.kite {
                        Text(verbatim: "\(k.size.formatted()) m")
                            .font(.footnote.weight(.semibold))
                    } else if fit != .rideable {
                        Image(systemName: "nosign")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: kiteColumn, alignment: .trailing)
            }
            .monospacedDigit()
            if let note = hourNote(h) {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(h.flags.isEmpty ? Color.secondary : fit == .noGo ? Color.red : Color.orange)
                    .padding(.leading, timeColumn + 8)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(hourAccessibility(h, speed: speed, gust: gust))
        .accessibilityIdentifier("hourRow")
    }

    /// "SE side-onshore": where the wind comes from and how it meets the beach. When the
    /// models differ by two compass points or more, their range instead: "ENE–SE side-onshore".
    private func hourDirection(_ h: HourScore) -> String {
        var text = h.wind.modelDirectionArcDeg.map { arc in
            let from = Vocab.compass(arc.from), to = Vocab.compass(arc.to)
            return from == to ? from : "\(from)–\(to)"
        } ?? Vocab.compass(h.wind.directionDeg)
        if let a = h.relativeAngle { text += " " + Vocab.angle(a) }
        return text
    }

    /// Warnings (safety first, as applySafety orders them) and the side of a multi-side spot.
    private func hourNote(_ h: HourScore) -> String? {
        var parts = h.flags.map { flag in
            flag == "too strong for level" && h.gustOverLimit
                ? String(localized: "gusts too strong for your level", comment: "Hour ruled out: the gusts, not the mean wind, are over the rider's limit")
                : flag == Scorer.directionDisagreementFlag
                ? String(localized: "models disagree on direction: the worse one counts",
                         comment: "Hour note: the weather models' directions are far apart, so the hour is judged on the worse one")
                : Vocab.term(flag)
        }
        if let side = h.side, h.score > 0 { parts.append(side) }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    private func hourAccessibility(_ h: HourScore, speed: Int, gust: Int) -> String {
        var parts = [String(format: "%02d:00", h.wind.hour),
                     String(localized: "wind \(speed) knots, gusts \(gust)",
                            comment: "VoiceOver, one hour of wind: average then gusts in knots"),
                     hourDirection(h)]
        if h.windFit == .rideable, let k = h.kite {
            parts.append(String(localized: "\(k.size.formatted()) m kite"))
        } else if h.windFit != .rideable {
            parts.append(String(localized: "Can't ride", comment: "Hour with no rideable wind or unsafe"))
        }
        if let note = hourNote(h) { parts.append(note) }
        return parts.joined(separator: ", ")
    }

    /// Directions asks which maps app to use on every tap (Ben's call: no remembered choice).
    /// Google's link opens the Google Maps app when installed, the website otherwise.
    private var directionsButton: some View {
        Menu {
            Section("Get directions with") {
                ForEach(MapsApp.allCases) { app in
                    Button(app.title) {
                        app.open(name: rec.spot.name, latitude: rec.spot.latitude, longitude: rec.spot.longitude)
                    }
                }
            }
        } label: {
            Label("Directions", systemImage: "car.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .prominentButton()
        .controlSize(.large)
        .accessibilityIdentifier("directions")
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
                        if let water = mean(\.waterFactor) {
                            FactorRow(title: String(localized: "Water"), value: water, weight: nil, detail: waterDetail)
                        }
                        if let weather = mean(\.weatherFactor) {
                            FactorRow(title: String(localized: "Weather"), value: weather, weight: nil,
                                      detail: String(localized: "You asked for good weather only"))
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
                        Text("**Wind strength**: how well the wind fits the best kite in your quiver.")
                        Text("**Steady wind**: gusts compared with the mean wind.")
                        Text("**Direction**: side-onshore is best, straight onshore is fine, cross-shore is harder, offshore is 0.")
                        Text("They are multiplied, using your weights. A spot's score is its best two hours in a row. Spots that need a certain tide lose the hours outside it, and with **Distance matters** far spots lose up to \(maxDistanceLoss) %.")
                        Text("If you choose flat or wavy water, or good weather only, the hours that don't match score lower.")
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

    /// "Lagoon", "Waves up to 1.2 m", or "Wave forecast not available".
    private var waterDetail: String {
        if rec.spot.waterType == "lagoon" { return String(localized: "Lagoon: flat water") }
        if rec.spot.waterType == "lake" { return String(localized: "Lake: flat water") }
        guard let h = windowHours.compactMap(\.wind.waveHeightM).max() else {
            return String(localized: "Wave forecast not available")
        }
        return String(localized: "Waves up to \(h.formatted(.number.precision(.fractionLength(1)))) m")
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


// MARK: - Wind fit (wind hour by hour, chart colours)

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
        case .noGo: String(localized: "No go", comment: "Verdict: grade under 20")
        }
    }

    /// Why these no-go hours can't be ridden, short and safety first ("storm", "dark"…), each
    /// word once. Empty when none of them has a named reason.
    static func noGoWords(_ hours: [HourScore]) -> [String] {
        let flags = Set(hours.flatMap(\.flags))
        var words: [String] = []
        if flags.contains("thunderstorm risk") { words.append(String(localized: "storm", comment: "Chart legend reason: thunderstorm risk")) }
        if flags.contains("kiting banned") { words.append(String(localized: "ban", comment: "Chart legend reason: kiting is banned then")) }
        if flags.contains("too late") { words.append(String(localized: "too late", comment: "This hour is over, or over before you can get there")) }
        if flags.contains("dark") { words.append(String(localized: "dark", comment: "Before sunrise or after sunset")) }
        // An offshore hour that only one model sees offshore (WHE-231) says so.
        let offshore = hours.filter { $0.flags.contains("offshore component") }
        if offshore.contains(where: { $0.flags.contains(Scorer.directionDisagreementFlag) }) {
            words.append(String(localized: "unsure direction", comment: "Chart legend reason: the weather models disagree on the direction, one says offshore"))
        }
        if offshore.contains(where: { !$0.flags.contains(Scorer.directionDisagreementFlag) }) {
            words.append(String(localized: "offshore", comment: "Wind angle to the beach"))
        }
        if flags.contains("tide too low") || flags.contains("tide too high") {
            words.append(String(localized: "tide", comment: "Chart legend reason: wrong tide for this spot"))
        }
        return words
    }
}

extension HourScore {
    var windFit: WindFit {
        let safety: Set<String> = ["too late", "thunderstorm risk", "kiting banned", "dark", "offshore component"]
        if flags.contains(where: safety.contains) { return .noGo }
        if score > 0 { return .rideable }
        if flags.contains("too light") { return .tooLight }
        if flags.contains("too strong for level") || flags.contains("too strong for quiver") { return .tooStrong }
        return .noGo
    }

    /// The fit against one kite of the quiver (the chart's kite picker): safety and the level's
    /// hard limits stay as the engine decided; otherwise the mean wind against that kite's range.
    func windFit(for kite: KiteRange?) -> WindFit {
        let engine = windFit
        guard let kite, engine != .noGo, !flags.contains("too strong for level") else { return engine }
        return meanFit(for: kite)
    }

    /// The mean wind alone against the kite's range, ignoring gusts and level limits.
    func meanFit(for kite: KiteRange?) -> WindFit {
        guard let kite else { return windFit }
        return wind.speedKn < kite.minKn ? .tooLight : wind.speedKn > kite.maxKn ? .tooStrong : .rideable
    }
}

private struct WindFitLegend: View {
    let fits: Set<WindFit>
    /// The no-go item's text, with its reasons ("No go: storm, dark").
    let noGoLabel: String

    var body: some View {
        // A long no-go reason moves to its own line rather than squeezing the others.
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { items(WindFit.allCases) }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) { items(WindFit.allCases.filter { $0 != .noGo }) }
                items([.noGo])
            }
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .accessibilityElement(children: .combine)
    }

    private func items(_ list: [WindFit]) -> some View {
        ForEach(list.filter(fits.contains), id: \.self) { f in
            HStack(spacing: 4) {
                Circle().fill(f.color).frame(width: 8, height: 8)
                Text(f == .noGo ? noGoLabel : f.label)
            }
        }
    }
}
