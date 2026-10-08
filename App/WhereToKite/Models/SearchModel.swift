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

    /// Gregorian whatever the device calendar: the id goes to the forecast API.
    static let formatter = DayString.formatter()

    static var today: DayOption { next(1)[0] }

    /// Forecasts are reliable for about a week.
    static func next(_ count: Int = 7) -> [DayOption] {
        let start = Calendar.current.startOfDay(for: Date())
        return (0..<count).map {
            let d = Calendar.current.date(byAdding: .day, value: $0, to: start)!
            return DayOption(id: formatter.string(from: d), date: d)
        }
    }

    /// The day an id stands for, also outside the coming week (a search made before midnight,
    /// an archived day): labels must name the day that was searched, not today.
    static func with(id: String) -> DayOption {
        if let d = formatter.date(from: id) { return DayOption(id: id, date: d) }
        return .today
    }

    /// True when `id` is before today (e.g. the app stayed open past midnight).
    static func isPast(_ id: String) -> Bool { id < today.id }

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

@MainActor @Observable
final class SearchModel {
    /// Last successful result; stays on screen while a newer search runs.
    private(set) var result: SearchResult?
    /// Non-nil while a search is running.
    private(set) var progress: String?
    private(set) var error: String?
    /// Bumped on every finished search (drives haptics).
    private(set) var generation = 0
    /// When `result` arrived.
    private(set) var finishedAt: Date?

    private let location = LocationService()
    private let catalog: [Spot]
    private var recommender: Recommender

    init() {
        let url = Bundle.main.url(forResource: "spots", withExtension: "json")!
        let loaded = try? SpotCatalog.load(from: url)
        catalog = loaded?.spots ?? []
        // MapKitDriveTime caches ETAs in memory, so changing day, session or style
        // doesn't ask Apple Maps for every route again.
        recommender = Recommender(
            spots: catalog,
            forecast: CachedForecastProvider(upstream: OpenMeteoProvider()),
            driveTime: MapKitDriveTime())
        recommender.islands = loaded?.islands ?? []
    }

    /// UI tests: -searchOrigin "lat,lon" replaces the device location.
    private static var testOrigin: Coordinate? {
        guard let v = UserDefaults.standard.string(forKey: "searchOrigin")?.split(separator: ","), v.count == 2,
              let lat = Double(v[0]), let lon = Double(v[1]) else { return nil }
        return Coordinate(latitude: lat, longitude: lon)
    }

    func run(_ options: SearchOptions, profile: RiderProfile, userSpots: [Spot]) async {
        recommender.spots = UserSpotStore.merged(catalog: catalog, user: userSpots)
        error = nil
        do {
            let origin: Coordinate
            if let c = options.start.coordinate {
                origin = c
            } else if let pinned = Self.testOrigin {
                origin = pinned
            } else {
                progress = "Finding your location…"
                origin = try await location.currentCoordinate()
            }
            progress = "Checking the wind at nearby spots…"
            let request = SearchRequest(
                // UI tests can pin a past day with a windy forecast: -searchDay yyyy-MM-dd.
                origin: origin, maxDriveMinutes: options.maxDriveMinutes,
                day: UserDefaults.standard.string(forKey: "searchDay") ?? options.day,
                slot: options.slot, intensity: options.intensity, distanceMatters: options.distanceMatters)
            let result = try await recommender.search(request, profile: profile, today: DayOption.today.id)
            try Task.checkCancellation()
            self.result = result
            finishedAt = Date()
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
