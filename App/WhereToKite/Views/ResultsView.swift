import SwiftUI
import KiteCore

struct ResultsView: View {
    let options: SearchOptions
    let profile: RiderProfile

    @State private var model = SearchModel()
    @State private var showNoGo = false

    private var day: DayOption {
        DayOption.next().first { $0.id == options.day } ?? .today
    }

    var body: some View {
        Group {
            switch model.state {
            case .idle, .loading:
                ProgressView {
                    if case .loading(let message) = model.state { Text(message) }
                }
            case .failed(let message):
                ContentUnavailableView {
                    Label("Search failed", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try again") { Task { await model.run(options, profile: profile) } }
                }
            case .done(let result):
                list(result)
            }
        }
        .navigationTitle(day.longLabel)
        .navigationBarTitleDisplayMode(.inline)
        .task { await model.run(options, profile: profile) }
    }

    private func list(_ result: SearchResult) -> some View {
        let good = result.recommendations.filter { $0.finalScore > 0 }
        let noGo = result.recommendations.filter { $0.finalScore == 0 }

        return List {
            Section {
                if let confidence = result.confidence {
                    ConfidenceBanner(confidence: confidence)
                }
            } footer: {
                Text("\(options.slot.label) (\(options.slot.hoursLabel)) · within \(Int(options.maxDriveMinutes)) min of \(options.start.name.lowercased() == "current location" ? "you" : options.start.name)")
            }

            if good.isEmpty {
                Section {
                    ContentUnavailableView("No kiteable spot",
                                           systemImage: "wind.snow",
                                           description: Text("Try another day, session or a longer drive."))
                }
            } else {
                Section("Best spots") {
                    ForEach(good) { rec in
                        NavigationLink {
                            SpotDetailView(rec: rec, day: day, profile: profile)
                        } label: {
                            SpotRow(rec: rec)
                        }
                        .accessibilityIdentifier("spotRow")
                    }
                }
            }

            if !noGo.isEmpty {
                Section {
                    DisclosureGroup("Not kiteable (\(noGo.count))", isExpanded: $showNoGo) {
                        ForEach(noGo) { rec in
                            NavigationLink {
                                SpotDetailView(rec: rec, day: day, profile: profile)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(rec.spot.name).font(.subheadline)
                                    Text(rec.verdict).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } footer: {
                    Text("Weather data by Open-Meteo.com · Spots © OpenStreetMap contributors")
                        .padding(.top, 8)
                }
            }
        }
        .refreshable { await model.run(options, profile: profile) }
    }
}

struct SpotRow: View {
    let rec: SpotRecommendation

    var body: some View {
        HStack(spacing: 12) {
            ScoreBadge(score: rec.finalScore)
            VStack(alignment: .leading, spacing: 3) {
                Text(rec.spot.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(rec.windSummary ?? rec.verdict)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
        }
        .padding(.vertical, 2)
    }
}

extension SpotRecommendation {
    var windowHours: [HourScore] {
        guard let window else { return [] }
        return hours.filter { $0.wind.hour >= window.start && $0.wind.hour < window.end }
    }

    /// "15–18 kn · gusts 22 · SSW side-onshore"
    var windSummary: String? {
        let hs = windowHours
        guard let lo = hs.map(\.wind.speedKn).min(), let hi = hs.map(\.wind.speedKn).max(),
              let gust = hs.map(\.wind.gustKn).max() else { return nil }
        let dir = Geo.compassName(Geo.circularStats(hs.map(\.wind.directionDeg)).mean)
        let angles = hs.compactMap(\.relativeAngle)
        let side = angles.isEmpty ? "" : " " + Recommender.angleName(angles.reduce(0, +) / Double(angles.count))
        let speed = Int(lo.rounded()) == Int(hi.rounded()) ? "\(Int(hi.rounded()))" : "\(Int(lo.rounded()))–\(Int(hi.rounded()))"
        return "\(speed) kn · gusts \(Int(gust.rounded())) · \(dir)\(side)"
    }

    /// Why a spot isn't recommended, without the drive time (shown separately).
    var verdict: String {
        reason.components(separatedBy: " · ").dropLast().joined(separator: " · ")
    }

    var warnings: [String] {
        Array(Set(windowHours.flatMap(\.flags))).sorted()
    }
}
