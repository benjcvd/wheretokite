import Foundation

public enum Geo {
    /// Great-circle distance in km.
    public static func distanceKm(_ a: Coordinate, _ b: Coordinate) -> Double {
        let r = 6371.0
        let dLat = (b.latitude - a.latitude) * .pi / 180
        let dLon = (b.longitude - a.longitude) * .pi / 180
        let h = sin(dLat / 2) * sin(dLat / 2)
            + cos(a.latitude * .pi / 180) * cos(b.latitude * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
        return 2 * r * asin(min(1, sqrt(h)))
    }

    /// Smallest absolute difference between two bearings, 0...180.
    public static func angleDiff(_ a: Double, _ b: Double) -> Double {
        let d = abs((a - b).truncatingRemainder(dividingBy: 360))
        return d > 180 ? 360 - d : d
    }

    /// Circular mean and spread (0 = identical, ~1 = scattered) of bearings.
    public static func circularStats(_ bearings: [Double]) -> (mean: Double, spread: Double) {
        guard !bearings.isEmpty else { return (0, 1) }
        let s = bearings.reduce(0) { $0 + sin($1 * .pi / 180) } / Double(bearings.count)
        let c = bearings.reduce(0) { $0 + cos($1 * .pi / 180) } / Double(bearings.count)
        var mean = atan2(s, c) * 180 / .pi
        if mean < 0 { mean += 360 }
        return (mean, 1 - sqrt(s * s + c * c))
    }

    public static func compassName(_ deg: Double) -> String {
        let names = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                     "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i = Int((deg.truncatingRemainder(dividingBy: 360) + 360 + 11.25) / 22.5) % 16
        return names[i]
    }
}
