import KiteCore
import SwiftUI

/// The safety terms shown at onboarding, once to existing riders, and in About.
enum Disclaimer {
    static var short: String { String(localized: "WhereToKite gives estimates from weather forecasts, not safety advice. Conditions on the water can differ: check the wind, the weather and the local rules on site. You decide whether to ride, at your own risk.") }

    static var full: [String] { [
        String(localized: "Scores are computed from weather forecasts, which can be wrong, especially for gusts, local effects, storms and squalls."),
        String(localized: "Beach directions, spot positions and rules come from map data and research that can be incomplete or out of date. Kite zones, bans and access rules change: follow the signs and the local authorities."),
        String(localized: "Always check conditions on site before riding, never ride alone in strong or offshore wind, and stay within your level."),
        String(localized: "You decide whether to ride and you do so at your own risk. WhereToKite and its authors accept no liability for accidents, injuries, damage or fines."),
    ] }
}

/// Shown once to riders who set up the app before the terms existed.
struct DisclaimerSheet: View {
    let accept: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)
                        .accessibilityHidden(true)
                    Text("Before you go").font(.largeTitle.bold())
                    ForEach(Disclaimer.full, id: \.self) { Text($0) }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: accept) {
                    Text("I understand").font(.headline).frame(maxWidth: .infinity).padding(.vertical, 6)
                }
                .prominentButton()
                .controlSize(.large)
                .padding()
                .accessibilityIdentifier("acceptDisclaimer")
            }
        }
        .interactiveDismissDisabled()
    }
}

/// Me tab → About: safety terms, data sources and licences, privacy, contact, version.
struct AboutView: View {
    @State private var catalog: (count: Int, date: String)?
    @State private var showReport = false

    var body: some View {
        List {
            Section("Safety") {
                ForEach(Disclaimer.full, id: \.self) { Text($0).font(.subheadline) }
            }

            Section {
                link(String(localized: "Weather forecasts: Open-Meteo.com (CC BY 4.0)"), "https://open-meteo.com/")
                link(String(localized: "Spots and shorelines: © OpenStreetMap contributors (ODbL)"), "https://www.openstreetmap.org/copyright")
                link(String(localized: "The spot catalogue (open data, ODbL)"), "https://github.com/benjcvd/wheretokite/blob/main/Data/spots.json")
                Text("Maps and drive times: Apple Maps").font(.subheadline)
                if let catalog {
                    Text("Catalogue: \(catalog.count) spots, updated \(catalog.date)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Data")
            }

            Section {
                Text("No account and no tracking. Your profile and your own spots stay on this phone. To get forecasts, the app sends spot positions and the rough area of your start point (about 10 km) to the forecast service, and your start point to Apple Maps for drive times. If you answer \u{201C}How was it?\u{201D}, the answer is sent without anything that identifies you. Crash reports from iOS are sent anonymously to help fix bugs. Reports you send are published on GitHub, without your name or position.")
                    .font(.subheadline)
            } header: {
                Text("Privacy")
            }

            Section {
                Button { showReport = true } label: {
                    Label("Report an issue or a missing spot", systemImage: "flag")
                }
                .accessibilityIdentifier("reportIssue")
                LabeledContent("Version", value: AppConfig.appVersion)
            }
        }
        .navigationTitle("About")
        .sheet(isPresented: $showReport) { ReportIssueSheet() }
        .task {
            if catalog == nil, let c = CatalogStore.current() {
                catalog = (c.spots.count, String((c.generatedAt ?? "").prefix(10)))
            }
        }
    }

    private func link(_ title: String, _ url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Text(title).font(.subheadline).foregroundStyle(.primary)
                Spacer(minLength: 8)
                Image(systemName: "arrow.up.right.square").foregroundStyle(.secondary)
            }
        }
    }
}

/// "Report an issue": from a spot (prefilled) or from Me / About. Sent to the server, which
/// files it as a GitHub issue; without a server, opens a prefilled GitHub issue.
struct ReportIssueSheet: View {
    /// The spot the report is about, when opened from a spot.
    var spot: Spot? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var kind: Kind
    @State private var message = ""
    @State private var missingName = ""
    @State private var sent = false
    @State private var sending = false

    /// The raw value goes to the server and GitHub: keep it English; `title` is what the rider reads.
    enum Kind: String, CaseIterable, Identifiable {
        case missingSpot = "A spot is missing"
        case wrongPosition = "Wrong position"
        case wrongDirection = "Wrong beach direction"
        case wrongBan = "Wrong ban or dates"
        case banned = "Kiting is banned here"
        case notKnown = "Not a known kite spot"
        case appProblem = "App problem"
        case other = "Something else"
        var id: String { rawValue }
        var isAboutASpot: Bool { ![.missingSpot, .appProblem, .other].contains(self) }

        var title: String {
            switch self {
            case .missingSpot: String(localized: "A spot is missing")
            case .wrongPosition: String(localized: "Wrong position")
            case .wrongDirection: String(localized: "Wrong beach direction")
            case .wrongBan: String(localized: "Wrong ban or dates")
            case .banned: String(localized: "Kiting is banned here")
            case .notKnown: String(localized: "Not a known kite spot")
            case .appProblem: String(localized: "App problem")
            case .other: String(localized: "Something else")
            }
        }
    }

    init(spot: Spot? = nil) {
        self.spot = spot
        _kind = State(initialValue: spot == nil ? .missingSpot : .wrongPosition)
    }

    private var kinds: [Kind] { spot == nil ? Kind.allCases.filter { !$0.isAboutASpot } : Kind.allCases }

    private var canSend: Bool {
        !sending && (kind != .missingSpot || !missingName.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    var body: some View {
        NavigationStack {
            Form {
                if sent {
                    Label("Thanks! We'll look into it.", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Section {
                        Picker("Issue", selection: $kind) {
                            ForEach(kinds) { Text($0.title).tag($0) }
                        }
                        .accessibilityIdentifier("reportKind")
                        if kind == .missingSpot {
                            TextField("Spot name and where (town, beach)", text: $missingName)
                                .accessibilityIdentifier("missingSpotName")
                        }
                        TextField(placeholder, text: $message, axis: .vertical)
                            .lineLimit(3...8)
                            .accessibilityIdentifier("reportMessage")
                    } header: {
                        Text(spot.map { $0.name } ?? String(localized: "What's wrong?"))
                    } footer: {
                        Text("Sent without your name or position, and published as a public issue on GitHub so fixes are traceable. Don't include personal details.")
                    }
                }
            }
            .navigationTitle("Report an issue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(sent ? "Done" : "Cancel") { dismiss() } }
                if !sent {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Send") { Task { await send() } }.disabled(!canSend)
                    }
                }
            }
        }
    }

    private var placeholder: String {
        switch kind {
        case .missingSpot: String(localized: "Details (optional): launch, wind directions, rules…")
        case .wrongBan, .banned: String(localized: "Details (optional): the real dates and hours, the rule or sign…")
        case .appProblem: String(localized: "What happened? What did you expect?")
        default: String(localized: "Details (optional): where kiters really launch, the rules…")
        }
    }

    private func send() async {
        sending = true
        defer { sending = false }
        var body: [String: Any] = ["kind": kind.rawValue, "message": String(message.prefix(2000)),
                                   "appVersion": AppConfig.appVersion]
        if let spot, kind.isAboutASpot || kind == .other {
            body["spotId"] = spot.id
            body["spotName"] = spot.name
        }
        if kind == .missingSpot { body["missingSpot"] = String(missingName.prefix(200)) }
        if await ServerClient.post("v1/report", body) {
            withAnimation { sent = true }
            return
        }
        // No server: a prefilled GitHub issue (the catalogue is open data on GitHub).
        let subject = (body["spotName"] as? String) ?? (body["missingSpot"] as? String) ?? "App"
        var c = URLComponents(url: AppConfig.issuesURL, resolvingAgainstBaseURL: false)!
        c.queryItems = [
            .init(name: "title", value: "\(kind.rawValue): \(subject)"),
            .init(name: "body", value: body.map { "\($0.key): \($0.value)" }.sorted().joined(separator: "\n")),
        ]
        if let url = c.url { openURL(url) }
        dismiss()
    }
}
