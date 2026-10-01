import Foundation
import KiteCore

/// The user's search choices. Remembered between launches, except the day.
struct SearchOptions: Codable, Equatable {
    var start = StartPoint.currentLocation
    var maxDriveMinutes = 60.0
    var day = DayOption.today.id
    var slot = SessionSlot.afternoon
    /// nil = all types.
    var intensity: Double? = nil
    var distanceMatters = true

    private static let key = "searchOptions"

    static func load() -> SearchOptions {
        guard let data = UserDefaults.standard.data(forKey: key),
              var options = try? JSONDecoder().decode(SearchOptions.self, from: data) else { return SearchOptions() }
        options.day = DayOption.today.id
        return options
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) { UserDefaults.standard.set(data, forKey: Self.key) }
    }
}

struct DayOption: Identifiable, Hashable {
    /// "yyyy-MM-dd"
    let id: String
    let date: Date

    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static var today: DayOption { next(1)[0] }

    /// Forecasts are reliable for about a week.
    static func next(_ count: Int = 7) -> [DayOption] {
        let start = Calendar.current.startOfDay(for: Date())
        return (0..<count).map {
            let d = Calendar.current.date(byAdding: .day, value: $0, to: start)!
            return DayOption(id: formatter.string(from: d), date: d)
        }
    }

    static func with(id: String) -> DayOption {
        next().first { $0.id == id } ?? .today
    }

    var shortLabel: String {
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInTomorrow(date) { return "Tomorrow" }
        return date.formatted(.dateTime.weekday(.abbreviated))
    }

    var longLabel: String {
        "\(shortLabel), \(date.formatted(.dateTime.day().month(.abbreviated)))"
    }
}

extension SessionSlot {
    var label: String {
        switch self {
        case .morning: "Morning"
        case .afternoon: "Afternoon"
        case .fullDay: "Full day"
        }
    }

    var symbol: String {
        switch self {
        case .morning: "sunrise.fill"
        case .afternoon: "sun.max.fill"
        case .fullDay: "sun.horizon.fill"
        }
    }

    var hoursLabel: String { "\(hours.lowerBound):00–\(hours.upperBound + 1):00" }
}

/// Max-drive choices: fine steps for short trips, coarser ones for road trips (up to 10 h).
enum DriveSteps {
    static let minutes: [Double] = [15, 30, 45, 60, 75, 90, 105, 120, 150, 180, 210, 240, 300, 360, 420, 480, 540, 600]

    /// Index of the step closest to `minutes`.
    static func index(of value: Double) -> Int {
        minutes.indices.min { abs(minutes[$0] - value) < abs(minutes[$1] - value) } ?? 3
    }

    /// "45 min", "1 h", "1 h 15", "10 h".
    static func label(_ value: Double) -> String {
        let m = Int(value.rounded())
        if m < 60 { return "\(m) min" }
        return m % 60 == 0 ? "\(m / 60) h" : "\(m / 60) h \(String(format: "%02d", m % 60))"
    }
}

/// Remembers drive times per start point, so changing day, session or style
/// doesn't ask MapKit for every route again.
actor CachedDriveTime: DriveTimeProvider {
    private let upstream: DriveTimeProvider
    private var cache: [String: Double] = [:]

    init(upstream: DriveTimeProvider) { self.upstream = upstream }

    func driveMinutes(from origin: Coordinate, to spots: [Spot]) async -> [String: Double] {
        // ~100 m grid, so GPS jitter still hits the cache.
        let prefix = String(format: "%.3f,%.3f|", origin.latitude, origin.longitude)
        var result: [String: Double] = [:]
        var missing: [Spot] = []
        for spot in spots {
            if let m = cache[prefix + spot.id] { result[spot.id] = m } else { missing.append(spot) }
        }
        if !missing.isEmpty {
            let fresh = await upstream.driveMinutes(from: origin, to: missing)
            for (id, m) in fresh {
                cache[prefix + id] = m
                result[id] = m
            }
        }
        return result
    }
}

@MainActor @Observable
final class SearchModel {
    /// Last successful result; stays on screen while a newer search runs.
    private(set) var result: SearchResult?
    /// Non-nil while a search is running.
    private(set) var progress: String?
    private(set) var error: String?
    /// Bumped on every finished search (drives haptics).
    private(set) var generation = 0

    private let location = LocationService()
    private let recommender: Recommender
    let spotCount: Int

    init() {
        let url = Bundle.main.url(forResource: "spots_barcelona", withExtension: "json")!
        let spots = (try? SpotCatalog.load(from: url).spots) ?? []
        spotCount = spots.count
        recommender = Recommender(
            spots: spots,
            forecast: CachedForecastProvider(upstream: OpenMeteoProvider()),
            driveTime: CachedDriveTime(upstream: MapKitDriveTime()))
    }

    func run(_ options: SearchOptions, profile: RiderProfile) async {
        error = nil
        do {
            let origin: Coordinate
            if let c = options.start.coordinate {
                origin = c
            } else {
                progress = "Finding your location…"
                origin = try await location.currentCoordinate()
            }
            progress = "Checking the wind at nearby spots…"
            let request = SearchRequest(
                origin: origin, maxDriveMinutes: options.maxDriveMinutes, day: options.day,
                slot: options.slot, intensity: options.intensity, distanceMatters: options.distanceMatters)
            let result = try await recommender.search(request, profile: profile, today: DayOption.today.id)
            try Task.checkCancellation()
            self.result = result
            progress = nil
            generation += 1
        } catch is CancellationError {
            // Superseded by a newer search, or the view went away.
        } catch {
            if Task.isCancelled { return }   // e.g. URLError.cancelled from a superseded search
            self.error = error.localizedDescription
            progress = nil
        }
    }
}
