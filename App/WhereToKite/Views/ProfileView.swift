import SwiftUI
import KiteCore

struct ProfileView: View {
    var isOnboarding = false

    @Environment(ProfileStore.self) private var profiles
    @Environment(\.dismiss) private var dismiss
    @State private var weight = 75.0
    @State private var kites: Set<Double> = [9, 12]
    @State private var level = Level.intermediate

    private static let sizes: [Double] = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 19]

    var body: some View {
        Form {
            if isOnboarding {
                Section {
                    Text("Tell us about you and your gear once. It's used to work out which wind suits each of your kites.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Weight") {
                Stepper(value: $weight, in: 35...140, step: 1) {
                    Text("\(Int(weight)) kg").monospacedDigit()
                }
            }

            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 56))], spacing: 8) {
                    ForEach(Self.sizes, id: \.self) { size in
                        let on = kites.contains(size)
                        Button {
                            if on { kites.remove(size) } else { kites.insert(size) }
                        } label: {
                            Text("\(size.formatted()) m")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, minHeight: 36)
                                .foregroundStyle(on ? Color.white : Color.primary)
                                .background(on ? Color.accentColor : Color(.tertiarySystemFill),
                                            in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(on ? .isSelected : [])
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text("Your kites")
            } footer: {
                if !kites.isEmpty {
                    Text(rangesText)
                }
            }

            Section {
                Picker("Level", selection: $level) {
                    ForEach(Level.allCases, id: \.self) { Text($0.label) }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Level")
            } footer: {
                Text(levelFooter)
            }
        }
        .navigationTitle(isOnboarding ? "Welcome" : "Rider profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isOnboarding {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(isOnboarding ? "Start" : "Save") {
                    profiles.profile = RiderProfile(weightKg: weight, kites: kites.sorted(), level: level)
                    dismiss()
                }
                .disabled(kites.isEmpty)
            }
        }
        .onAppear {
            if let p = profiles.profile {
                weight = p.weightKg
                kites = Set(p.kites)
                level = p.level
            }
        }
    }

    private var rangesText: String {
        kites.sorted().map {
            let r = KiteRange.make(size: $0, weightKg: weight)
            return "\($0.formatted()) m: \(Int(r.minKn.rounded()))–\(Int(r.maxKn.rounded())) kn"
        }.joined(separator: " · ")
    }

    private var levelFooter: String {
        let limits = ScoringRules().limits(level)
        return switch level {
        case .beginner: "Only side-on or onshore wind, up to \(Int(limits.wind)) kn."
        case .intermediate: "Up to \(Int(limits.wind)) kn, no offshore wind."
        case .advanced: "Up to \(Int(limits.wind)) kn, side-offshore is acceptable."
        }
    }
}
