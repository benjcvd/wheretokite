import SwiftUI
import KiteCore

// MARK: - Score colours (traffic-light, like Surfline's ratings: green = go)

enum ScoreStyle {
    static func color(_ score: Int) -> Color {
        switch score {
        case 75...: Color(red: 0.13, green: 0.78, blue: 0.45)
        case 50..<75: Color(red: 0.98, green: 0.76, blue: 0.10)
        case 1..<50: Color(red: 1.00, green: 0.55, blue: 0.20)
        default: Color(.systemGray)
        }
    }

    /// Rich two-stop gradient for large surfaces (hero card, badges).
    static func gradient(_ score: Int) -> LinearGradient {
        let colors: [Color] = switch score {
        case 75...: [Color(red: 0.05, green: 0.70, blue: 0.48), Color(red: 0.00, green: 0.47, blue: 0.75)]
        case 50..<75: [Color(red: 0.96, green: 0.62, blue: 0.05), Color(red: 0.93, green: 0.38, blue: 0.16)]
        case 1..<50: [Color(red: 0.95, green: 0.42, blue: 0.22), Color(red: 0.82, green: 0.22, blue: 0.36)]
        default: [Color(red: 0.42, green: 0.46, blue: 0.54), Color(red: 0.28, green: 0.31, blue: 0.40)]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static func label(_ score: Int) -> String {
        switch score {
        case 75...: "Great"
        case 50..<75: "Good"
        case 1..<50: "Marginal"
        default: "No go"
        }
    }
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
            .accessibilityLabel("Wind from \(Geo.compassName(directionDeg))")
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

struct ConfidenceBanner: View {
    let confidence: ForecastConfidence

    private var color: Color {
        switch confidence.rating {
        case .high: ScoreStyle.color(80)
        case .medium: ScoreStyle.color(60)
        case .low: ScoreStyle.color(30)
        }
    }

    private var detail: String {
        var parts = [String]()
        if confidence.leadDays > 0 {
            parts.append("\(confidence.leadDays) day\(confidence.leadDays > 1 ? "s" : "") ahead")
        }
        parts.append(String(format: "models agree within ±%.0f kn", confidence.speedSpreadKn))
        if let d = confidence.directionSpreadDeg { parts.append(String(format: "±%.0f°", d)) }
        return parts.joined(separator: " · ")
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: confidence.rating == .high ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(confidence.rating.rawValue) forecast confidence")
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
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
        window.map { "\($0.start)–\($0.end)h" }
    }

    var driveLabel: String { DriveSteps.label(driveMinutes) }
}

extension Level {
    var label: String { rawValue.capitalized }

    var symbol: String {
        switch self {
        case .beginner: "figure.walk"
        case .intermediate: "figure.surfing"
        case .advanced: "bolt.fill"
        }
    }
}
