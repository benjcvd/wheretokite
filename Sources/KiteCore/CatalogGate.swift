import Foundation

/// Decides whether a new spot catalogue may replace a known-good one. Used by the app (a
/// download against the bundled copy) and by CI (`kite --check-catalog`, a fresh build against
/// the committed `Data/spots.json`), so a broken build that drops a country or the bans never
/// reaches riders.
public enum CatalogGate {
    /// The new catalogue keeps at least this share of the reference's spots.
    public static let minSpotShare = 0.9
    /// Below this many spots a catalogue is never usable, whatever the reference.
    public static let minSpots = 50

    /// What's wrong with `candidate` compared with `reference`; empty = usable.
    public static func problems(_ candidate: SpotCatalog, reference: SpotCatalog?) -> [String] {
        var out: [String] = []
        let n = candidate.spots.count
        if n < minSpots { out.append("only \(n) spots (minimum \(minSpots))") }
        guard let reference else { return out }

        let ref = reference.spots.count
        if Double(n) < Double(ref) * minSpotShare {
            out.append("\(n) spots, under \(Int(minSpotShare * 100))% of the \(ref) in the reference")
        }
        let bans = bannedSpots(candidate), refBans = bannedSpots(reference)
        if bans < refBans {
            out.append("\(bans) spots with a kiting ban, fewer than the \(refBans) in the reference")
        }
        let missing = countries(reference).subtracting(countries(candidate)).sorted()
        if !missing.isEmpty {
            out.append("countries missing: \(missing.joined(separator: ", "))")
        }
        return out
    }

    public static func accepts(_ candidate: SpotCatalog, reference: SpotCatalog?) -> Bool {
        problems(candidate, reference: reference).isEmpty
    }

    /// Spots with at least one ban rule. Counted per spot, not per rule, so merging two
    /// periods of the same spot into one rule isn't mistaken for a lost ban.
    static func bannedSpots(_ c: SpotCatalog) -> Int {
        c.spots.filter { !($0.bans ?? []).isEmpty }.count
    }

    static func countries(_ c: SpotCatalog) -> Set<String> {
        Set(c.spots.compactMap(\.country))
    }
}
