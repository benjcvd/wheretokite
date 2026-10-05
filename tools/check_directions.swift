// Independent check of beach directions against Apple Maps (macOS).
//
//   swift tools/check_directions.swift <points.json> <results.json>
//
// points.json: [{"key": "...", "lat": 43.3, "lon": 5.0, "facing": 227}, ...]
// results.json: {"<key>": {"front": 0.9, "back": 0.1, "mean": 231.0}, ...}
//
// The catalogue's directions come from OpenStreetMap's coastline. This renders Apple's map
// (a separate data source) around each point and samples which pixels are water:
//   front: share of water within ±40° of the claimed direction, 100–600 m out
//   back:  share of water within ±40° of the opposite direction, 100–300 m out
//   mean:  mean direction of all water within 600 m (null when water is all around / absent)
// build_spots.py turns these into a verdict. Same water test as the app's CoastlineGuess.

import AppKit
import Foundation
import MapKit

struct Point: Decodable { let key: String; let lat: Double; let lon: Double; let facing: Double }
struct Result: Encodable { let front: Double?; let back: Double?; let mean: Double? }

func offset(_ lat: Double, _ lon: Double, bearing: Double, meters: Double) -> CLLocationCoordinate2D {
    let b = bearing * .pi / 180
    return CLLocationCoordinate2D(latitude: lat + meters * cos(b) / 111_320,
                                  longitude: lon + meters * sin(b) / (111_320 * cos(lat * .pi / 180)))
}

func angleDiff(_ a: Double, _ b: Double) -> Double {
    let d = abs((a - b).truncatingRemainder(dividingBy: 360))
    return d > 180 ? 360 - d : d
}

@MainActor
func check(_ p: Point) async -> Result {
    let options = MKMapSnapshotter.Options()
    options.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: p.lat, longitude: p.lon),
                                        latitudinalMeters: 1400, longitudinalMeters: 1400)
    options.size = CGSize(width: 256, height: 256)
    options.appearance = NSAppearance(named: .aqua)
    let config = MKStandardMapConfiguration(emphasisStyle: .muted)
    config.pointOfInterestFilter = .excludingAll
    options.preferredConfiguration = config

    guard let snap = try? await MKMapSnapshotter(options: options).start(),
          let cg = snap.image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return Result(front: nil, back: nil, mean: nil)
    }
    let w = cg.width, h = cg.height
    var px = [UInt8](repeating: 0, count: w * h * 4)
    px.withUnsafeMutableBytes { raw in
        let ctx = CGContext(data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                            space: CGColorSpace(name: CGColorSpace.sRGB)!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: w, height: h))
    }
    let scale = Double(w) / snap.image.size.width
    func isWater(_ c: CLLocationCoordinate2D) -> Bool? {
        let pt = snap.point(for: c)
        // AppKit image coordinates start bottom-left; the bitmap's first row is the top.
        let x = Int(pt.x * scale), y = h - 1 - Int(pt.y * scale)
        guard (0..<w).contains(x), (0..<h).contains(y) else { return nil }
        let i = (y * w + x) * 4
        let r = Int(px[i]), g = Int(px[i + 1]), b = Int(px[i + 2])
        return b > 150 && b - r > 35 && b >= g
    }

    var front = [Bool](), back = [Bool](), all = [(Double, Bool)]()
    for step in 0..<72 {
        let bearing = Double(step) * 5
        for radius in [100.0, 200, 300, 420, 600] {
            guard let water = isWater(offset(p.lat, p.lon, bearing: bearing, meters: radius)) else { continue }
            all.append((bearing, water))
            if angleDiff(bearing, p.facing) <= 40 { front.append(water) }
            if angleDiff(bearing, p.facing + 180) <= 40, radius <= 300 { back.append(water) }
        }
    }
    func share(_ xs: [Bool]) -> Double? { xs.isEmpty ? nil : Double(xs.filter { $0 }.count) / Double(xs.count) }

    var mean: Double?
    let water = all.filter(\.1)
    let fraction = all.isEmpty ? 0 : Double(water.count) / Double(all.count)
    if fraction > 0.05, fraction < 0.95 {
        let s = water.reduce(0) { $0 + sin($1.0 * .pi / 180) }, c = water.reduce(0) { $0 + cos($1.0 * .pi / 180) }
        if sqrt(s * s + c * c) / Double(water.count) > 0.2 {
            let d = atan2(s, c) * 180 / .pi
            mean = d < 0 ? d + 360 : d
        }
    }
    return Result(front: share(front), back: share(back), mean: mean)
}

let args = CommandLine.arguments
guard args.count == 3 else {
    FileHandle.standardError.write("usage: check_directions.swift <points.json> <results.json>\n".data(using: .utf8)!)
    exit(2)
}
let points = try JSONDecoder().decode([Point].self, from: Data(contentsOf: URL(fileURLWithPath: args[1])))
var results: [String: Result] = [:]
for (i, p) in points.enumerated() {
    results[p.key] = await check(p)
    if (i + 1) % 25 == 0 { FileHandle.standardError.write("  apple check \(i + 1)/\(points.count)\n".data(using: .utf8)!) }
}
let enc = JSONEncoder()
enc.outputFormatting = [.sortedKeys]
try enc.encode(results).write(to: URL(fileURLWithPath: args[2]))
