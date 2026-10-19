import KiteCore
import SwiftUI

/// The safety terms shown at onboarding, once to existing riders, and in About.
enum Disclaimer {
    static let short = "WhereToKite gives estimates from weather forecasts, not safety advice. Conditions on the water can differ: check the wind, the weather and the local rules on site. You decide whether to ride, at your own risk."

    static let full: [String] = [
        "Scores are computed from weather forecasts, which can be wrong, especially for gusts, local effects, storms and squalls.",
        "Beach directions, spot positions and rules come from map data and research that can be incomplete or out of date. Kite zones, bans and access rules change: follow the signs and the local authorities.",
        "Always check conditions on site before riding, never ride alone in strong or offshore wind, and stay within your level.",
        "You decide whether to ride and you do so at your own risk. WhereToKite and its authors accept no liability for accidents, injuries, damage or fines.",
    ]
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

    var body: some View {
        List {
            Section("Safety") {
                ForEach(Disclaimer.full, id: \.self) { Text($0).font(.subheadline) }
            }

            Section {
                link("Weather forecasts: Open-Meteo.com (CC BY 4.0)", "https://open-meteo.com/")
                link("Spots and shorelines: © OpenStreetMap contributors (ODbL)", "https://www.openstreetmap.org/copyright")
                link("The spot catalogue (open data, ODbL)", "https://github.com/benjcvd/wheretokite/blob/main/Data/spots.json")
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
                Text("No account and no tracking. Your profile and your own spots stay on this phone. To get forecasts, the app sends spot positions and the rough area of your start point (about 10 km) to the forecast service, and your start point to Apple Maps for drive times. If you answer \u{201C}How was it?\u{201D}, the answer is sent without anything that identifies you. Crash reports from iOS are sent anonymously to help fix bugs.")
                    .font(.subheadline)
            } header: {
                Text("Privacy")
            }

            Section {
                link("Report a problem or suggest a spot", AppConfig.issuesURL.absoluteString)
                LabeledContent("Version", value: AppConfig.appVersion)
            }
        }
        .navigationTitle("About")
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

/// Spot detail → "Report a problem with this spot": to the server, or a prefilled GitHub issue.
struct ReportSpotSheet: View {
    let spot: Spot
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var message = ""
    @State private var sent = false
    @State private var sending = false

    private let problems = ["Wrong position", "Wrong beach direction", "Kiting banned / restricted here",
                            "Wrong ban or dates", "Not a known kite spot", "Other"]
    @State private var problem = "Wrong position"

    var body: some View {
        NavigationStack {
            Form {
                if sent {
                    Label("Thanks! We'll look into it.", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Section {
                        Picker("Problem", selection: $problem) {
                            ForEach(problems, id: \.self) { Text($0) }
                        }
                        TextField("Details (optional): where kiters really launch, the rules…",
                                  text: $message, axis: .vertical)
                            .lineLimit(3...8)
                    } header: {
                        Text(spot.name)
                    } footer: {
                        Text("Sent without your name or position.")
                    }
                }
            }
            .navigationTitle("Report a problem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button(sent ? "Done" : "Cancel") { dismiss() } }
                if !sent {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Send") { Task { await send() } }.disabled(sending)
                    }
                }
            }
        }
    }

    private func send() async {
        sending = true
        defer { sending = false }
        let body: [String: Any] = ["spotId": spot.id, "spotName": spot.name, "problem": problem,
                                   "message": String(message.prefix(2000)), "appVersion": AppConfig.appVersion]
        if await ServerClient.post("v1/report", body) {
            withAnimation { sent = true }
            return
        }
        // No server: a prefilled GitHub issue (the catalogue is open data on GitHub).
        var c = URLComponents(url: AppConfig.issuesURL, resolvingAgainstBaseURL: false)!
        c.queryItems = [
            .init(name: "title", value: "Spot \(spot.id): \(problem)"),
            .init(name: "body", value: "Spot: \(spot.name) (\(spot.id))\nProblem: \(problem)\n\n\(message)\n\nApp \(AppConfig.appVersion)"),
        ]
        if let url = c.url { openURL(url) }
        dismiss()
    }
}
