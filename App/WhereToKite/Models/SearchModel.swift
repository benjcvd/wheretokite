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

    var hoursLabel: String { "\(hours.lowerBound):00–\(hours.upperBound + 1):00" }
}

@MainActor @Observable
final class SearchModel {
    enum State {
        case idle
        case loading(String)
        case done(SearchResult)
        case failed(String)
    }

    var state = State.idle

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
            driveTime: MapKitDriveTime())
    }

    func run(_ options: SearchOptions, profile: RiderProfile) async {
        do {
            let origin: Coordinate
            if let c = options.start.coordinate {
                origin = c
            } else {
                state = .loading("Finding your location…")
                origin = try await location.currentCoordinate()
            }
            state = .loading("Checking the wind at nearby spots…")
            let request = SearchRequest(
                origin: origin, maxDriveMinutes: options.maxDriveMinutes, day: options.day,
                slot: options.slot, intensity: options.intensity, distanceMatters: options.distanceMatters)
            let result = try await recommender.search(request, profile: profile, today: DayOption.today.id)
            state = .done(result)
        } catch is CancellationError {
            // View went away; nothing to show.
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
