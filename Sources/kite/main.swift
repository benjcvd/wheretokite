import Foundation
import KiteCore

// v0 prototype: rank kite spots for a day from the command line.
//
//   swift run kite --weight 75 --kites 9,12 --level intermediate   (saves profile once)
//   swift run kite --day tomorrow --slot afternoon --drive 90 --style chill
//
// Options:
//   --from LAT,LON        search origin (default: Barcelona centre)
//   --drive MIN           max drive time in minutes (default 60)
//   --day D               today | tomorrow | +N | yyyy-MM-dd (default today)
//   --slot S              morning | afternoon | full (default full)
//   --style X             chill | intense | all | 0…1 (default all)
//   --distance-matters    penalise far spots (default off)
//   --weight KG --kites 9,12 --level L   update the saved rider profile
//   --spots FILE          spot catalogue (default Data/spots_barcelona.json)
//   --straight-line       skip Apple Maps, estimate drive times
//   --hourly N            print the hourly breakdown for the top N spots
//   --all                 also list spots scoring 0

func fail(_ msg: String) -> Never {
    FileHandle.standardError.write(Data("error: \(msg)\n".utf8))
    exit(1)
}
func fail<T>(_ msg: String) -> T { fail(msg) as Never }

var args: [String: String] = [:]
var flags = Set<String>()
var it = CommandLine.arguments.dropFirst().makeIterator()
while let a = it.next() {
    guard a.hasPrefix("--") else { fail("unexpected argument \(a)") }
    let key = String(a.dropFirst(2))
    if ["distance-matters", "straight-line", "all"].contains(key) { flags.insert(key); continue }
    guard let v = it.next() else { fail("missing value for \(a)") }
    args[key] = v
}

// MARK: Profile (persisted like the app's saved user info)

let profileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".wheretokite/profile.json")
var profile = (try? JSONDecoder().decode(RiderProfile.self, from: Data(contentsOf: profileURL)))
if args["weight"] != nil || args["kites"] != nil || args["level"] != nil {
    var p = profile ?? RiderProfile(weightKg: 75, kites: [9, 12], level: .intermediate)
    if let w = args["weight"] { p.weightKg = Double(w) ?? fail("bad --weight") }
    if let k = args["kites"] { p.kites = k.split(separator: ",").map { Double($0) ?? fail("bad --kites") } }
    if let l = args["level"] { p.level = Level(rawValue: l) ?? fail("level: beginner|intermediate|advanced") }
    try? FileManager.default.createDirectory(at: profileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
    try JSONEncoder().encode(p).write(to: profileURL)
    profile = p
}
guard let profile else { fail("no saved profile yet: pass --weight KG --kites 9,12 --level intermediate") }

// MARK: Request

let dayFormatter = DateFormatter()
dayFormatter.dateFormat = "yyyy-MM-dd"
let today = dayFormatter.string(from: Date())
func resolveDay(_ s: String) -> String {
    let offset: Int? = switch s {
    case "today": 0
    case "tomorrow": 1
    default: s.hasPrefix("+") ? Int(s.dropFirst()) : nil
    }
    if let offset { return dayFormatter.string(from: Date().addingTimeInterval(Double(offset) * 86400)) }
    guard dayFormatter.date(from: s) != nil else { fail("bad --day \(s)") }
    return s
}

let origin: Coordinate = {
    guard let f = args["from"] else { return Coordinate(latitude: 41.3874, longitude: 2.1686) }
    let p = f.split(separator: ",").compactMap { Double($0) }
    guard p.count == 2 else { fail("--from LAT,LON") }
    return Coordinate(latitude: p[0], longitude: p[1])
}()

let slot: SessionSlot = switch args["slot"] ?? "full" {
case "morning": .morning
case "afternoon": .afternoon
case "full", "fullday": .fullDay
default: fail("slot: morning|afternoon|full")
}

let intensity: Double? = switch args["style"] ?? "all" {
case "all": nil
case "chill": 0
case "intense": 1
case let s: Double(s).map { min(1, max(0, $0)) } ?? fail("style: chill|intense|all|0…1")
}

let request = SearchRequest(
    origin: origin,
    maxDriveMinutes: Double(args["drive"] ?? "60") ?? fail("bad --drive"),
    day: resolveDay(args["day"] ?? "today"),
    slot: slot,
    intensity: intensity,
    distanceMatters: flags.contains("distance-matters"))

let spotsURL = URL(fileURLWithPath: args["spots"] ?? "Data/spots_barcelona.json")
let catalog: SpotCatalog
do { catalog = try SpotCatalog.load(from: spotsURL) } catch { fail("can't load spots from \(spotsURL.path): \(error)") }

let driveTime: DriveTimeProvider = flags.contains("straight-line") ? StraightLineDriveTime() : MapKitDriveTime()
let recommender = Recommender(
    spots: catalog.spots,
    forecast: CachedForecastProvider(upstream: OpenMeteoProvider()),
    driveTime: driveTime)

// MARK: Run

let started = Date()
let result = try await recommender.search(request, profile: profile, today: today)
let elapsed = Date().timeIntervalSince(started)

let styleText = intensity.map { $0 == 0 ? "chill" : $0 == 1 ? "intense" : String(format: "%.1f", $0) } ?? "all types"
let kitesText = profile.kites.map { String(format: "%g", $0) }.joined(separator: "/")
print("""

WhereToKite · \(request.day) \(slot.rawValue) · ≤\(Int(request.maxDriveMinutes)) min drive\(request.distanceMatters ? " (distance matters)" : "")
Rider: \(Int(profile.weightKg)) kg · kites \(kitesText) m · \(profile.level.rawValue) · \(styleText)
Kite ranges: \(Scorer(profile: profile, intensity: intensity).kiteRanges.map { String(format: "%g m %.0f–%.0f kn", $0.size, $0.minKn, $0.maxKn) }.joined(separator: " · "))
""")
if let c = result.confidence { print("Forecast: \(c.summary)") }
print(String(format: "(%d spots searched in %.1fs)\n", result.recommendations.count, elapsed))

let shown = result.recommendations.filter { flags.contains("all") || $0.finalScore > 0 }
if shown.isEmpty { print("No kiteable spot found. Use --all to see why each spot fails.") }
for (i, r) in shown.enumerated() {
    let name = r.spot.name.count > 32 ? String(r.spot.name.prefix(31)) + "…" : r.spot.name
    print(String(format: "%2d. %3d  %@  %@", i + 1, r.finalScore,
                 name.padding(toLength: 32, withPad: " ", startingAt: 0), r.reason))
}

let hourlyCount = Int(args["hourly"] ?? "0") ?? 0
for r in shown.prefix(hourlyCount) {
    let facing = r.spot.seaFacingDeg.map { String(format: "beach faces %.0f° %@", $0, Geo.compassName($0)) } ?? "orientation unknown"
    print("\n\(r.spot.name) — \(facing)")
    for h in r.hours {
        let angle = h.relativeAngle.map { String(format: "%3.0f°", $0) } ?? "  ?"
        let kite = h.kite.map { String(format: "%4g m", $0.size) } ?? "    -"
        print(String(format: "  %02d:00  %4.1f kn  g%4.1f  from %3.0f° %-3@  rel %@  %@  %3.0f  %@",
                     h.wind.hour, h.wind.speedKn, h.wind.gustKn, h.wind.directionDeg,
                     Geo.compassName(h.wind.directionDeg), angle, kite, h.score * 100,
                     h.flags.joined(separator: ", ")))
    }
}

if !result.excluded.isEmpty {
    print("\nExcluded: " + result.excluded.map { "\($0.0.name) (\($0.1))" }.joined(separator: ", "))
}
print("\nSpot data \(catalog.attribution ?? "") · Weather data by Open-Meteo.com")
