import CoreGraphics
import Foundation
import MapKit
import KiteCore

/// Best guess of which way a beach faces, read from Apple's map: render a small, label-free
/// map around the pin and look at where the water (blue pixels) is.
enum CoastlineGuess {
    /// Compass bearing from `coordinate` toward the open water, or nil when the map can't tell
    /// (no water nearby, pin far out at sea, or no map data).
    @MainActor
    static func seaBearing(at coordinate: Coordinate) async -> Double? {
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: center, latitudinalMeters: 1400, longitudinalMeters: 1400)
        options.size = CGSize(width: 256, height: 256)
        options.scale = 1
        options.traitCollection = UITraitCollection(userInterfaceStyle: .light)
        let config = MKStandardMapConfiguration(emphasisStyle: .muted)
        config.pointOfInterestFilter = .excludingAll
        options.preferredConfiguration = config

        guard let snapshot = try? await MKMapSnapshotter(options: options).start(),
              let pixels = PixelGrid(snapshot.image) else { return nil }

        var samples = [(bearing: Double, isWater: Bool)]()
        for step in 0..<72 {
            let bearing = Double(step) * 5
            for radius in [120.0, 200, 300, 420, 560] {
                let c = offset(coordinate, bearing: bearing, meters: radius)
                let p = snapshot.point(for: CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude))
                guard p.x.isFinite, p.y.isFinite else { continue }   // Int(_:) traps on NaN / inf (near the poles)
                if let water = pixels.isWater(x: Int(p.x * snapshot.image.scale), y: Int(p.y * snapshot.image.scale)) {
                    samples.append((bearing, water))
                }
            }
        }
        return seaBearing(samples: samples)
    }

    /// Mean direction of the water samples. nil when there is (almost) no water or (almost)
    /// only water, or when water surrounds the point evenly.
    static func seaBearing(samples: [(bearing: Double, isWater: Bool)]) -> Double? {
        guard !samples.isEmpty else { return nil }
        let water = samples.filter(\.isWater)
        let fraction = Double(water.count) / Double(samples.count)
        guard fraction > 0.05, fraction < 0.95 else { return nil }
        let s = water.reduce(0) { $0 + sin($1.bearing * .pi / 180) }
        let c = water.reduce(0) { $0 + cos($1.bearing * .pi / 180) }
        guard sqrt(s * s + c * c) / Double(water.count) > 0.2 else { return nil }
        var deg = atan2(s, c) * 180 / .pi
        if deg < 0 { deg += 360 }
        return deg
    }

    /// Point `meters` away along a compass bearing (flat-earth approximation, fine below a few km).
    static func offset(_ c: Coordinate, bearing: Double, meters: Double) -> Coordinate {
        let b = bearing * .pi / 180
        let dLat = meters * cos(b) / 111_320
        let dLon = meters * sin(b) / (111_320 * cos(c.latitude * .pi / 180))
        return Coordinate(latitude: c.latitude + dLat, longitude: c.longitude + dLon)
    }

    /// Apple Maps draws water in light blue; land, sand, parks and roads are never bluish.
    static func isWaterColor(r: Int, g: Int, b: Int) -> Bool {
        b > 150 && b - r > 35 && b >= g
    }
}

/// RGBA pixels of an image, for color sampling.
private struct PixelGrid {
    let width: Int
    let height: Int
    let data: [UInt8]

    init?(_ image: UIImage) {
        guard let cg = image.cgImage else { return nil }
        let width = cg.width, height = cg.height
        self.width = width
        self.height = height
        var buffer = [UInt8](repeating: 0, count: width * height * 4)
        let ok = buffer.withUnsafeMutableBytes { raw -> Bool in
            guard let ctx = CGContext(data: raw.baseAddress, width: width, height: height, bitsPerComponent: 8,
                                      bytesPerRow: width * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return false }
            ctx.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        guard ok else { return nil }
        data = buffer
    }

    func isWater(x: Int, y: Int) -> Bool? {
        guard (0..<width).contains(x), (0..<height).contains(y) else { return nil }
        let i = (y * width + x) * 4
        return CoastlineGuess.isWaterColor(r: Int(data[i]), g: Int(data[i + 1]), b: Int(data[i + 2]))
    }
}
