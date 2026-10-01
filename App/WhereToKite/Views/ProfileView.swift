import SwiftUI
import KiteCore

extension RiderProfile {
    static let starter = RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)

    /// "75 kg · 9 · 12 m"
    var shortSummary: String {
        "\(Int(weightKg)) kg · " + kites.sorted().map { $0.formatted() }.joined(separator: " · ") + " m"
    }
}

extension ProfileStore {
    /// Live binding: edits are saved as they happen.
    var editable: Binding<RiderProfile> {
        Binding(get: { self.profile ?? .starter }, set: { self.profile = $0 })
    }
}

// MARK: - Onboarding (first launch only)

struct OnboardingView: View {
    @Environment(ProfileStore.self) private var profiles
    @State private var draft = RiderProfile.starter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "wind")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(ScoreStyle.gradient(90), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .accessibilityHidden(true)
                    Text("Where to kite?")
                        .font(.largeTitle.bold())
                    Text("Tell us about you and your kites once. We match every spot's wind to your gear and give you a straight answer.")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                ProfileFields(profile: $draft)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            Button {
                withAnimation(.snappy) { profiles.profile = draft }
            } label: {
                Text("Start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .prominentButton()
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .sensoryFeedback(.success, trigger: profiles.profile != nil)
        }
    }
}

// MARK: - "Me" tab

struct MeView: View {
    @Environment(ProfileStore.self) private var profiles

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    RiderHero(profile: profiles.profile ?? .starter)
                    ProfileFields(profile: profiles.editable)
                    Text("Changes are saved automatically and used for your next search.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Me")
        }
    }
}

/// Opened from the rider chip on the search screen.
struct ProfileSheet: View {
    @Environment(ProfileStore.self) private var profiles
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileFields(profile: profiles.editable)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Rider profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }
}

private struct RiderHero: View {
    let profile: RiderProfile

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "figure.surfing")
                .font(.system(size: 30, weight: .semibold))
                .frame(width: 60, height: 60)
                .background(.white.opacity(0.2), in: Circle())
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(profile.level.label) rider")
                    .font(.title3.bold())
                Text(profile.shortSummary)
                    .font(.subheadline)
                    .opacity(0.9)
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(ScoreStyle.gradient(90), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Shared editor

struct ProfileFields: View {
    @Binding var profile: RiderProfile

    private static let sizes: [Double] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 19]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            section("Weight") {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(Int(profile.weightKg))")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .monospacedDigit()
                            .contentTransition(.numericText(value: profile.weightKg))
                        Text("kg").font(.title3.weight(.semibold)).foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    Spacer()
                    Stepper("Weight", value: $profile.weightKg.animation(.snappy), in: 35...140, step: 1)
                        .labelsHidden()
                        .accessibilityValue("\(Int(profile.weightKg)) kilograms")
                }
                .padding(16)
                .card()
            }

            section("Your kites", footer: "Tap every size you own.") {
                VStack(alignment: .leading, spacing: 14) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 58), spacing: 8)], spacing: 8) {
                        ForEach(Self.sizes, id: \.self) { size in
                            kiteChip(size)
                        }
                    }
                    KiteRangesChart(profile: profile)
                }
                .padding(16)
                .card()
            }

            section("Level", footer: levelFooter) {
                HStack(spacing: 8) {
                    ForEach(Level.allCases, id: \.self) { level in
                        let on = profile.level == level
                        Button {
                            withAnimation(.snappy) { profile.level = level }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: level.symbol).font(.title3)
                                Text(level.label).font(.footnote.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity, minHeight: 68)
                            .foregroundStyle(on ? Color.white : Color.primary)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(on ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(Color(.secondarySystemGroupedBackground)))
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(on ? .isSelected : [])
                        .sensoryFeedback(.selection, trigger: on)
                    }
                }
            }
        }
    }

    private func kiteChip(_ size: Double) -> some View {
        let on = profile.kites.contains(size)
        return Button {
            withAnimation(.snappy) {
                if on {
                    // Keep at least one kite.
                    if profile.kites.count > 1 { profile.kites.removeAll { $0 == size } }
                } else {
                    profile.kites = (profile.kites + [size]).sorted()
                }
            }
        } label: {
            Text("\(size.formatted()) m")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 40)
                .foregroundStyle(on ? Color.white : Color.primary)
                .background {
                    Capsule().fill(on ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(Color(.tertiarySystemFill)))
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(size.formatted()) square metre kite")
        .accessibilityAddTraits(on ? .isSelected : [])
        .sensoryFeedback(.selection, trigger: on)
    }

    private func section<Content: View>(_ title: String, footer: String? = nil,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content()
            if let footer {
                Text(footer).font(.footnote).foregroundStyle(.secondary)
            }
        }
    }

    private var levelFooter: String {
        let limits = ScoringRules().limits(profile.level)
        return switch profile.level {
        case .beginner: "Only side-on or onshore wind, up to \(Int(limits.wind)) kn."
        case .intermediate: "Up to \(Int(limits.wind)) kn, no offshore wind."
        case .advanced: "Up to \(Int(limits.wind)) kn, side-offshore is acceptable."
        }
    }
}

/// Each kite's usable wind range on a shared knot axis, coloured with the wind scale.
private struct KiteRangesChart: View {
    let profile: RiderProfile

    private var ranges: [KiteRange] {
        profile.kites.sorted().map { KiteRange.make(size: $0, weightKg: profile.weightKg) }
    }

    var body: some View {
        let lo = 5.0, hi = 40.0
        VStack(alignment: .leading, spacing: 6) {
            Text("Wind range per kite")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            ForEach(ranges, id: \.size) { r in
                HStack(spacing: 8) {
                    Text("\(r.size.formatted()) m")
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()
                        .frame(width: 40, alignment: .leading)
                    GeometryReader { geo in
                        let x0 = (max(lo, r.minKn) - lo) / (hi - lo) * geo.size.width
                        let x1 = (min(hi, r.maxKn) - lo) / (hi - lo) * geo.size.width
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(.tertiarySystemFill))
                            Capsule()
                                .fill(LinearGradient(colors: [WindStyle.color(r.minKn), WindStyle.color(r.maxKn)],
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(width: max(8, x1 - x0))
                                .offset(x: x0)
                        }
                    }
                    .frame(height: 10)
                    Text("\(Int(r.minKn.rounded()))–\(Int(r.maxKn.rounded())) kn")
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                        .frame(width: 64, alignment: .trailing)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(r.size.formatted()) metre kite: \(Int(r.minKn.rounded())) to \(Int(r.maxKn.rounded())) knots")
            }
        }
    }
}
