import SwiftUI
import KiteCore

enum ScoreStyle {
    static func color(_ score: Int) -> Color {
        switch score {
        case 75...: .green
        case 50..<75: .yellow
        case 1..<50: .orange
        default: .gray
        }
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

struct ScoreBadge: View {
    let score: Int
    var size: CGFloat = 44

    var body: some View {
        Text("\(score)")
            .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(score > 0 ? .black : .white)
            .frame(width: size, height: size)
            .background(ScoreStyle.color(score).gradient, in: RoundedRectangle(cornerRadius: size * 0.28))
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

struct ConfidenceBanner: View {
    let confidence: ForecastConfidence

    private var color: Color {
        switch confidence.rating {
        case .high: .green
        case .medium: .yellow
        case .low: .orange
        }
    }

    private var detail: String {
        var parts = [String]()
        if confidence.leadDays > 0 {
            parts.append("\(confidence.leadDays) day\(confidence.leadDays > 1 ? "s" : "") ahead")
        }
        parts.append(String(format: "weather models agree within ±%.0f kn", confidence.speedSpreadKn))
        if let d = confidence.directionSpreadDeg { parts.append(String(format: "±%.0f° direction", d)) }
        return parts.joined(separator: " · ")
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: confidence.rating == .high ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(confidence.rating.rawValue) forecast confidence")
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

extension SpotRecommendation {
    var windowLabel: String? {
        window.map { "\($0.start)–\($0.end)h" }
    }

    var driveLabel: String {
        let m = Int(driveMinutes.rounded())
        return m < 60 ? "\(m) min" : "\(m / 60) h \(String(format: "%02d", m % 60))"
    }
}
