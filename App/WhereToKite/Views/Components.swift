import SwiftUI
import KiteCore

// MARK: - Score colours (traffic-light, like Surfline's ratings: green = go)

enum ScoreStyle {
    /// One colour per verdict band, green (Go) to grey (No go).
    static func color(_ score: Int) -> Color { KiteVerdict(grade: score).color }

    /// Rich two-stop gradient for large surfaces (hero card, badges), per verdict band.
    static func gradient(_ score: Int) -> LinearGradient {
        let colors: [Color] = switch KiteVerdict(grade: score) {
        case .go: [Color(red: 0.05, green: 0.70, blue: 0.48), Color(red: 0.00, green: 0.47, blue: 0.75)]
        case .worthATry: [Color(red: 0.70, green: 0.76, blue: 0.12), Color(red: 0.30, green: 0.62, blue: 0.30)]
        case .longShot: [Color(red: 0.95, green: 0.48, blue: 0.20), Color(red: 0.82, green: 0.26, blue: 0.30)]
        case .noGo: [Color(red: 0.42, green: 0.46, blue: 0.54), Color(red: 0.28, green: 0.31, blue: 0.40)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    /// The verdict for a grade, the same bands as the pill (`KiteVerdict(grade:)`).
    static func label(_ score: Int) -> String { Vocab.verdict(KiteVerdict(grade: score)) }
}

/// Windy-style colour scale for wind speed in knots.
enum WindStyle {
    static func color(_ kn: Double) -> Color {
        switch kn {
        case ..<8: Color(red: 0.45, green: 0.62, blue: 0.85)
        case ..<12: Color(red: 0.20, green: 0.72, blue: 0.80)
        case ..<17: Color(red: 0.20, green: 0.78, blue: 0.45)
        case ..<22: Color(red: 0.95, green: 0.75, blue: 0.15)
        case ..<28: Color(red: 0.98, green: 0.50, blue: 0.20)
        default: Color(red: 0.85, green: 0.25, blue: 0.45)
        }
    }
}

struct ScoreBadge: View {
    let score: Int
    var size: CGFloat = 44

    var body: some View {
        Text("\(score)")
            .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(ScoreStyle.gradient(score), in: RoundedRectangle(cornerRadius: size * 0.3, style: .continuous))
            .accessibilityElement()
            .accessibilityLabel("Score \(score) out of 100, \(ScoreStyle.label(score))")
    }
}

/// Circular score gauge for hero surfaces.
struct ScoreRing: View {
    let score: Int
    var lineWidth: CGFloat = 7

    var body: some View {
        ZStack {
            Circle().stroke(.white.opacity(0.25), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(score)")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(score)))
        }
        .foregroundStyle(.white)
        .accessibilityElement()
        .accessibilityLabel("Score \(score) out of 100, \(ScoreStyle.label(score))")
    }
}

/// Arrow pointing where the wind blows TO (direction is where it comes FROM).
struct WindArrow: View {
    let directionDeg: Double

    var body: some View {
        Image(systemName: "location.north.fill")
            .rotationEffect(.degrees(directionDeg + 180))
            .accessibilityLabel("Wind from \(Vocab.compass(directionDeg))")
    }
}

/// Small rounded "pill" used for facts and filters.
struct Pill: View {
    let text: String
    let systemImage: String
    var tint: Color = .accentColor

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.subheadline.weight(.medium))
            .lineLimit(1)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(tint)
            .background(tint.opacity(0.13), in: Capsule())
    }
}

extension KiteVerdict {
    /// Green (Go) to grey (No go).
    var color: Color {
        switch self {
        case .go: Color(red: 0.13, green: 0.72, blue: 0.42)
        case .worthATry: Color(red: 0.62, green: 0.70, blue: 0.05)
        case .longShot: Color(red: 0.95, green: 0.48, blue: 0.18)
        case .noGo: Color(.systemGray)
        }
    }
}

/// The verdict next to a grade. `onColor`: white text for the coloured hero card. Short and
/// shrinkable so the longest label ("Ça vaut le coup") fits under a score on a small iPhone.
struct VerdictPill: View {
    let verdict: KiteVerdict
    var onColor = false
    var maxWidth: CGFloat? = nil

    var body: some View {
        Text(Vocab.verdict(verdict))
            .font(.caption2.weight(.bold))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .frame(maxWidth: maxWidth)
            .fixedSize(horizontal: maxWidth == nil, vertical: true)
            .foregroundStyle(onColor ? Color.white : verdict.color)
            .background(onColor ? Color.black.opacity(0.22) : verdict.color.opacity(0.14), in: Capsule())
            .accessibilityIdentifier("verdict")
    }
}

/// Why a forecast verdict is only an estimate (the "i" button next to it).
struct ChanceInfoButton: View {
    @State private var shown = false

    var body: some View {
        Button { shown = true } label: {
            Image(systemName: "info.circle")
        }
        .accessibilityLabel(Text("What the labels mean"))
        .accessibilityIdentifier("verdictInfo")
        .popover(isPresented: $shown) {
            VStack(alignment: .leading, spacing: 10) {
                Text("What the labels mean").font(.headline)
                ForEach(KiteVerdict.allCases, id: \.self) { v in
                    Text("**\(Vocab.verdict(v))** (\(Vocab.verdictBand(v))): \(Vocab.verdictMeaning(v))")
                }
                Text("A No go caused by a safety rule (storm, kiting ban, darkness, offshore wind) says which one.")
                Text("The grade weighs the wind, gusts and direction for you, and how likely the wind is. We compare four weather models: when they aren't sure, a spot is Worth a try at best; when they see too little wind, a Long shot at best.")
                Text("Forecasts are never perfect: this is our best estimate. In our tests on past days, wind the models called likely came true about 85 % of the time. The further ahead the day, the less sure any forecast is.")
            }
            .font(.subheadline)
            .padding()
            .frame(idealWidth: 320)
            .fixedSize(horizontal: false, vertical: true)
            .presentationCompactAdaptation(.popover)
        }
    }
}

/// The verdict on a spot's page: "Go" + why + the info button.
struct VerdictBanner: View {
    let rec: SpotRecommendation

    private var verdict: KiteVerdict { rec.kiteVerdict }

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(verdict.color)
                .frame(width: 14, height: 14)
            VStack(alignment: .leading, spacing: 1) {
                Text(Vocab.verdict(verdict))
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            ChanceInfoButton()
        }
        .padding(12)
        .background(verdict.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("verdictBanner")
    }

    private var detail: String {
        rec.safetyReason.map(Vocab.safetyReason) ?? Vocab.verdictMeaning(verdict)
    }
}

/// Card surface used throughout.
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func card() -> some View { modifier(CardBackground()) }

    /// Zoom navigation transition source (iOS 18+; plain push before).
    @ViewBuilder func zoomSource(_ id: String, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18, *) {
            matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder func zoomDestination(_ id: String, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18, *) {
            navigationTransition(.zoom(sourceID: id, in: namespace))
        } else {
            self
        }
    }

    /// Liquid Glass prominent button on iOS 26, bordered prominent before.
    @ViewBuilder func prominentButton() -> some View {
        if #available(iOS 26, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
        }
    }
}

extension SpotRecommendation {
    var windowLabel: String? {
        window.map { w in
            timeZoneShiftHours == nil ? "\(w.start)–\(w.end)h" : String(localized: "\(w.start)–\(w.end)h local", comment: "Hours in the spot's time zone")
        }
    }

    /// Spot local time minus the phone's time, in hours; nil when they're the same (or unknown).
    var timeZoneShiftHours: Int? {
        guard let spot = utcOffsetSeconds else { return nil }
        let diff = (spot - TimeZone.current.secondsFromGMT()) / 3600
        return diff == 0 ? nil : diff
    }

    /// The window in the phone's time, when the spot is in another time zone: "15–19h".
    var windowInMyTime: String? {
        guard let window, let d = timeZoneShiftHours else { return nil }
        func h(_ x: Int) -> Int { ((x - d) % 24 + 24) % 24 }
        return "\(h(window.start))–\(h(window.end))h"
    }

    /// "~" marks a straight-line estimate (only top candidates get a real Apple Maps ETA).
    var driveLabel: String { (driveIsEstimate ? "~" : "") + DriveSteps.label(driveMinutes) }
}

extension Level {
    var label: String {
        switch self {
        case .beginner: String(localized: "Beginner")
        case .intermediate: String(localized: "Intermediate")
        case .advanced: String(localized: "Advanced")
        }
    }

    var symbol: String {
        switch self {
        case .beginner: "figure.walk"
        case .intermediate: "figure.surfing"
        case .advanced: "bolt.fill"
        }
    }
}
