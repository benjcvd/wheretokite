import Foundation
import KiteCore

/// Spots the user added themselves (low-key local spots). Persisted on device.
/// CONTRACT (shared by agents): `spots`, `add(_:)`, `remove(id:)`, `update(_:)`.
/// User spots use `source == "user"` and ids like `user-<uuid>`.
///
/// Storage: `Application Support/user_spots.json`, `{"version": 1, "spots": [Spot…]}`
/// (same Spot encoding as the bundled catalogue).
@MainActor @Observable
final class UserSpotStore {
    nonisolated static let source = "user"

    private(set) var spots: [Spot] = []

    private let fileURL: URL

    init(fileURL: URL = UserSpotStore.defaultFileURL) {
        self.fileURL = fileURL
        #if DEBUG
        // UI tests start from a fresh install state.
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-resetProfile") || args.contains("-resetUserSpots") {
            try? FileManager.default.removeItem(at: fileURL)
        }
        #endif
        spots = Self.load(from: fileURL)
    }

    func add(_ spot: Spot) {
        spots.append(Self.normalized(spot))
        save()
    }

    func remove(id: String) {
        spots.removeAll { $0.id == id }
        save()
    }

    func update(_ spot: Spot) {
        guard let i = spots.firstIndex(where: { $0.id == spot.id }) else { return }
        spots[i] = Self.normalized(spot)
        save()
    }

    /// Catalogue + user spots, for the recommender. A user spot whose id collides with a
    /// catalogue id replaces it; spots that are merely close to a catalogue spot are kept
    /// (the user may know a better launch a few hundred metres away).
    nonisolated static func merged(catalog: [Spot], user: [Spot]) -> [Spot] {
        let userIDs = Set(user.map(\.id))
        return catalog.filter { !userIDs.contains($0.id) } + user
    }

    // MARK: - Persistence

    nonisolated static var defaultFileURL: URL {
        let dir = (try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                                 appropriateFor: nil, create: true))
            ?? FileManager.default.temporaryDirectory
        return dir.appendingPathComponent("user_spots.json")
    }

    private struct File: Codable {
        var version = 1
        var spots: [Spot]
    }

    private static func load(from url: URL) -> [Spot] {
        guard let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(File.self, from: data) else { return [] }
        return file.spots
    }

    private func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try encoder.encode(File(spots: spots)).write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Couldn't save user spots: \(error)")
        }
    }

    private static func normalized(_ spot: Spot) -> Spot {
        var s = spot
        s.source = source
        if !s.id.hasPrefix("user-") { s.id = "user-" + UUID().uuidString.lowercased() }
        s.name = s.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let n = s.notes?.trimmingCharacters(in: .whitespacesAndNewlines) { s.notes = n.isEmpty ? nil : n }
        return s
    }
}

extension Spot {
    /// Added by the user on this device (show a "My spot" badge).
    var isUserSpot: Bool { source == UserSpotStore.source }

    /// KiteCore's Spot has no public memberwise init; build one through its Codable conformance.
    static func userSpot(id: String = "user-" + UUID().uuidString.lowercased(), name: String,
                         latitude: Double, longitude: Double, seaFacingDeg: Double?,
                         orientationSource: String? = "user", notes: String? = nil) -> Spot {
        let blank = #"{"id":"","name":"","latitude":0,"longitude":0}"#
        var spot = try! JSONDecoder().decode(Spot.self, from: Data(blank.utf8))
        spot.id = id
        spot.name = name
        spot.latitude = latitude
        spot.longitude = longitude
        spot.seaFacingDeg = seaFacingDeg
        spot.orientationSource = orientationSource
        spot.source = UserSpotStore.source
        spot.notes = notes
        return spot
    }
}

/// What the add/edit form collects. Valid when it has a name, a location and an orientation.
struct SpotDraft: Equatable {
    var id: String?
    var name = ""
    var coordinate: Coordinate?
    /// Compass bearing from the beach out to the water.
    var seaFacingDeg: Double?
    /// Width of open water seen from the launch, 0–360° (180 = straight beach, 360 = small
    /// lake kitable from any side).
    var waterSectorDeg: Double = 180
    /// When the spot works with the tide ("high", "low", "mid", "not-low", "not-high"; "" = any).
    var tide = ""
    /// Second kitable shore (sandbar, isthmus, lagoon behind the beach). nil = one side.
    var otherSideDeg: Double?
    /// "user" when set by hand, "user-suggested" when the coastline guess was kept as is.
    var orientationSource = "user"
    var notes = ""

    init() {}

    init(_ spot: Spot) {
        id = spot.id
        name = spot.name
        coordinate = spot.coordinate
        seaFacingDeg = spot.seaFacingDeg
        if let sides = spot.sides, sides.count > 1 { otherSideDeg = sides[1].seaFacingDeg }
        waterSectorDeg = spot.waterSectorDeg ?? spot.sides?.first?.waterSectorDeg ?? 180
        tide = spot.tide ?? ""
        orientationSource = spot.orientationSource ?? "user"
        notes = spot.notes ?? ""
    }

    var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var missing: [String] {
        var m = [String]()
        if coordinate == nil { m.append("location") }
        if trimmedName.isEmpty { m.append("name") }
        if seaFacingDeg == nil { m.append("beach direction") }
        return m
    }

    var isValid: Bool { missing.isEmpty }

    func makeSpot() -> Spot? {
        guard isValid, let coordinate, let seaFacingDeg else { return nil }
        let n = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        func normalized(_ deg: Double) -> Double {
            let d = deg.truncatingRemainder(dividingBy: 360)
            return d < 0 ? d + 360 : d
        }
        let bearing = normalized(seaFacingDeg)
        var spot = Spot.userSpot(id: id ?? "user-" + UUID().uuidString.lowercased(), name: trimmedName,
                                 latitude: coordinate.latitude, longitude: coordinate.longitude,
                                 seaFacingDeg: bearing, orientationSource: orientationSource,
                                 notes: n.isEmpty ? nil : n)
        spot.tide = tide.isEmpty ? nil : tide
        let sector = waterSectorDeg == 180 ? nil : min(360, max(0, waterSectorDeg))
        spot.waterSectorDeg = sector
        if let otherSideDeg, (sector ?? 180) < 360 {
            let other = normalized(otherSideDeg)
            spot.sides = [SpotSide(name: "\(Geo.compassName(bearing)) side", seaFacingDeg: bearing, waterSectorDeg: sector),
                          SpotSide(name: "\(Geo.compassName(other)) side", seaFacingDeg: other, waterSectorDeg: sector)]
        }
        return spot
    }
}
