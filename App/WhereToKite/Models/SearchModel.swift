import Foundation
import KiteCore

/// The user's search choices. Remembered between launches, except the day.
struct SearchOptions: Codable, Equatable {
    var start = StartPoint.currentLocation
    var maxDriveMinutes = 60.0
    var day = DayOption.today.id
    var slot = SessionSlot.afternoon
    /// The rider's own hours for the "Custom" slot (start hour, end hour exclusive). Optional so
    /// options saved before still decode.
    var customStart: Int?
    var customEnd: Int?

    var customHours: ClosedRange<Int> {
        let s = min(23, max(0, customStart ?? 17)), e = min(24, max(s + 1, customEnd ?? 20))
        return s...(e - 1)
    }
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
        case .evening: "Evening"
        case .fullDay: "Full day"
        case .custom: "My hours"
        }
    }

    var symbol: String {
        switch self {
        case .morning: "sunrise.fill"
        case .afternoon: "sun.max.fill"
        case .evening: "sunset.fill"
        case .fullDay: "sun.horizon.fill"
        case .custom: "clock.fill"
        }
    }

    var hoursLabel: String { Self.label(hours) }

    static func label(_ hours: ClosedRange<Int>) -> String { "\(hours.lowerBound):00–\(hours.upperBound + 1):00" }
}

extension SearchOptions {
    /// The slot's hours, or the rider's own ones.
    var hours: ClosedRange<Int> { slot == .custom ? customHours : slot.hours }
    var hoursLabel: String { SessionSlot.label(hours) }
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
    /// When the catalogue in use was built (shown in About).
    let catalogDate: String?
    private var recommender: Recommender

    init() {
        let loaded = CatalogStore.current()
        catalog = loaded?.spots ?? []
        catalogDate = loaded?.generatedAt
        // MapKitDriveTime caches ETAs in memory, so changing day, session or style
        // doesn't ask Apple Maps for every route again.
        recommender = Recommender(
            spots: catalog,
            forecast: CachedForecastProvider(upstream: OpenMeteoProvider(server: AppConfig.forecastServer)),
            driveTime: MapKitDriveTime(),
            confidence: ConfidenceEstimator(server: AppConfig.forecastServer))
        recommender.islands = loaded?.islands ?? []
    }

    /// UI tests: -searchOrigin "lat,lon" replaces the device location. Debug builds only:
    /// launch arguments land in UserDefaults, and a release build must not take them.
    private static var testOrigin: Coordinate? {
        #if DEBUG
        guard let v = UserDefaults.standard.string(forKey: "searchOrigin")?.split(separator: ","), v.count == 2,
              let lat = Double(v[0]), let lon = Double(v[1]),
              (-90...90).contains(lat), (-180...180).contains(lon) else { return nil }
        return Coordinate(latitude: lat, longitude: lon)
        #else
        return nil
        #endif
    }

    /// UI tests can pin a past day with a windy forecast: -searchDay yyyy-MM-dd. Debug builds only.
    private static var testDay: String? {
        #if DEBUG
        UserDefaults.standard.string(forKey: "searchDay")
        #else
        nil
        #endif
    }

    /// When nothing is good on the searched day: the next day (within `lookaheadDays`) that is.
    private(set) var nextWindow: (day: String, recommendation: SpotRecommendation)?

    /// `lookaheadDays` 0 = no next-window search (a Pro feature).
    func run(_ options: SearchOptions, profile: RiderProfile, userSpots: [Spot], proSpots: Bool = true,
             lookaheadDays: Int = 7) async {
        // Free plan: the famous spots only (Pro adds the secondary ones).
        let available = proSpots ? catalog : catalog.filter { $0.tier != "pro" }
        recommender.spots = UserSpotStore.merged(catalog: available, user: userSpots)
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
                origin: origin, maxDriveMinutes: options.maxDriveMinutes,
                day: Self.testDay ?? options.day,
                slot: options.slot, intensity: options.intensity, distanceMatters: options.distanceMatters)
            var req = request
            req.customHours = options.customHours
            let result = try await recommender.search(req, profile: profile, today: DayOption.today.id)
            try Task.checkCancellation()
            if result.stats.forecastMissing > 0 {
                appLog.error("forecast missing for \(result.stats.forecastMissing) spots")
            }
            // Nothing worth the drive: look ahead (forecasts for the week are already cached).
            var next: (day: String, recommendation: SpotRecommendation)?
            if lookaheadDays > 0, (result.recommendations.first?.finalScore ?? 0) < ResultsSection.verdictMinimum {
                let later = DayOption.next(lookaheadDays).map(\.id).filter { $0 > req.day }
                next = await recommender.nextGoodWindow(for: req, days: later, profile: profile,
                                                        minimum: ResultsSection.verdictMinimum)
            }
            try Task.checkCancellation()
            self.result = result
            self.nextWindow = next
            finishedAt = Date()
            progress = nil
            generation += 1
        } catch is CancellationError {
            // Superseded by a newer search, or the view went away.
        } catch {
            if Task.isCancelled { return }   // e.g. URLError.cancelled from a superseded search
            appLog.error("search failed: \(String(describing: error), privacy: .public)")
            self.error = error.localizedDescription
            progress = nil
        }
    }
}
