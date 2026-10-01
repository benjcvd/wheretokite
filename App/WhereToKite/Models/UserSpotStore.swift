import Foundation
import KiteCore

/// Spots the user added themselves (low-key local spots). Persisted on device.
/// CONTRACT (shared by agents): `spots`, `add(_:)`, `remove(id:)`, `update(_:)`.
/// User spots use `source == "user"`.
@MainActor @Observable
final class UserSpotStore {
    private(set) var spots: [Spot] = []

    func add(_ spot: Spot) { spots.append(spot) }
    func remove(id: String) { spots.removeAll { $0.id == id } }
    func update(_ spot: Spot) {
        if let i = spots.firstIndex(where: { $0.id == spot.id }) { spots[i] = spot }
    }
}
