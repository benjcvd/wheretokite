import Foundation
import KiteCore
import SwiftUI

/// Free vs Pro.
///
/// `PlanStore.mode` is the single switch for what ships:
/// - `.allFree`: everyone gets Pro features (e.g. a launch promotion).
/// - `.proComingSoon` (current): the free limits apply; Pro features show a "Pro" lock that
///   opens a "coming soon" sheet. Nothing can be bought yet.
/// - `.proForSale`: same, and the sheet offers the subscription (StoreKit, to build).
enum PaywallMode {
    /// v1 on the App Store: the free plan with no visible Pro at all (no locks, no "coming
    /// soon": review rejects promoting features that can't be bought).
    case freeOnly
    case allFree, proComingSoon, proForSale
}

/// What a plan allows. nil limits mean "no limit beyond the app's own".
struct Entitlements: Equatable {
    var maxDriveMinutes: Double?
    var forecastDays: Int
    var maxUserSpots: Int?
    var maxResults: Int?
    /// "What matters to you" score weights.
    var scoreWeights: Bool
    /// Water sector, second side and tide rule on the rider's own spots.
    var advancedSpotSettings: Bool
    /// Catalogue spots with tier "pro" (secondary beaches, launches near a famous spot).
    var proSpots: Bool = false
    /// "Next good window": when the searched day is poor, the next day in the week that works.
    var nextWindow: Bool = false

    static let free = Entitlements(maxDriveMinutes: 180, forecastDays: 4, maxUserSpots: 1, maxResults: 5,
                                   scoreWeights: false, advancedSpotSettings: true)
    static let pro = Entitlements(maxDriveMinutes: nil, forecastDays: 7, maxUserSpots: nil, maxResults: nil,
                                  scoreWeights: true, advancedSpotSettings: true, proSpots: true, nextWindow: true)
}

@MainActor @Observable
final class PlanStore {
    /// The switch. Change to `.proForSale` once the subscription exists.
    static let mode: PaywallMode = .freeOnly

    /// Bought Pro. Always false until the subscription exists; development builds can
    /// unlock it from the Me tab or with -unlockPro.
    var isPro: Bool {
        didSet {
            #if DEBUG
            UserDefaults.standard.set(isPro, forKey: Self.debugKey)
            #endif
        }
    }

    /// Opens the Pro sheet from anywhere (lock buttons set it).
    var showProSheet = false

    private static let debugKey = "debugUnlockPro"

    init() {
        #if DEBUG
        isPro = ProcessInfo.processInfo.arguments.contains("-unlockPro")
            || UserDefaults.standard.bool(forKey: Self.debugKey)
        #else
        isPro = false
        #endif
    }

    var entitlements: Entitlements {
        Self.mode == .allFree || isPro ? .pro : .free
    }

    var hasPro: Bool { entitlements == .pro }

    /// Pro is visible in the UI (locks, Pro sheet, "+N more" line).
    var showsPro: Bool { Self.mode == .proComingSoon || Self.mode == .proForSale }

    /// Search options within the plan: drive capped, day kept within the plan's forecast days.
    func clamp(_ options: SearchOptions) -> SearchOptions {
        var o = options
        if let cap = entitlements.maxDriveMinutes { o.maxDriveMinutes = min(o.maxDriveMinutes, cap) }
        let days = DayOption.next(entitlements.forecastDays).map(\.id)
        if !days.contains(o.day), let first = days.first { o.day = first }
        return o
    }

    /// The profile used for scoring: without the weights feature, default weights.
    func scoringProfile(_ p: RiderProfile) -> RiderProfile {
        guard !entitlements.scoreWeights else { return p }
        var q = p
        q.weights = nil
        return q
    }
}

// MARK: - UI

/// Small "PRO" capsule shown on locked features.
struct ProBadge: View {
    var body: some View {
        Label("Pro", systemImage: "lock.fill")
            .font(.caption2.weight(.bold))
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .foregroundStyle(.white)
            .background(ScoreStyle.gradient(90), in: Capsule())
            .accessibilityLabel("Pro feature")
    }
}

/// What Pro will include. "Coming soon" for now; the purchase goes here later.
struct ProSheet: View {
    @Environment(\.dismiss) private var dismiss

    private let features: [(String, String, String)] = [
        ("bell.badge.fill", String(localized: "It's on alerts"), String(localized: "A notification when your spots light up for your kites (coming with Pro).")),
        ("calendar", String(localized: "7-day planning"), String(localized: "The whole week, not just the next four days.")),
        ("calendar.badge.clock", String(localized: "Next good window"), String(localized: "When today is flat, the next day this week that works, and where.")),
        ("car.fill", String(localized: "Drives up to 10 h"), String(localized: "Weekend trips, not just the local spots (3\u{00A0}h free).")),
        ("list.number", String(localized: "Every spot"), String(localized: "The full ranking and map (top 5 free), plus about 300 more local spots.")),
        ("mappin.and.ellipse", String(localized: "Unlimited own spots"), String(localized: "Add all your secret spots (1 free).")),
        ("slider.horizontal.3", String(localized: "What matters to you"), String(localized: "Weigh wind strength, steadiness, direction and drive your way.")),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        ProBadge()
                        Text("WhereToKite Pro").font(.largeTitle.bold())
                        Text(PlanStore.mode == .proForSale
                             ? "Plan further, ride more."
                             : "Coming soon. Everything you use today stays free.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(features, id: \.1) { icon, title, detail in
                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: icon)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.accentColor.gradient, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(title).font(.headline)
                                Text(detail).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .safeAreaInset(edge: .bottom) {
                Button { dismiss() } label: {
                    Text(PlanStore.mode == .proForSale ? "Subscribe" : "Got it")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .prominentButton()
                .controlSize(.large)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
            }
        }
        .presentationDetents([.large])
    }
}

/// A row for a locked feature: title + Pro badge; tapping opens the Pro sheet.
struct ProLockRow: View {
    let title: String
    var detail: String? = nil
    @State private var showPro = false
    @Environment(PlanStore.self) private var plan

    var body: some View {
        if plan.showsPro { row }
    }

    private var row: some View {
        Button { showPro = true } label: {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).foregroundStyle(.primary)
                    if let detail { Text(detail).font(.caption).foregroundStyle(.secondary) }
                }
                Spacer(minLength: 8)
                ProBadge()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint("Shows what Pro includes")
        .sheet(isPresented: $showPro) { ProSheet() }
    }
}
