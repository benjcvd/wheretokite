import Foundation
import KiteCore
import MetricKit
import os

/// App-wide settings and the small server client.
enum AppConfig {
    /// The WhereToKite server (see server/README.md), e.g. URL(string: "https://wheretokite-api.<account>.workers.dev").
    /// nil = forecasts straight from Open-Meteo, no catalogue updates, reports open GitHub instead,
    /// and feedback / diagnostics stay on the phone.
    static let serverURL: URL? = URL(string: "https://wheretokite-api.wheretokite-api.workers.dev")

    static var forecastServer: ForecastServer { serverURL.map(ForecastServer.wheretokite) ?? .openMeteo }

    /// Where spot problems are reported when there is no server.
    static let issuesURL = URL(string: "https://github.com/benjcvd/wheretokite/issues/new")!

    static var appVersion: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        return "\(v) (\(b))"
    }
}

let appLog = Logger(subsystem: "com.benjcvd.wheretokite", category: "app")

/// Fire-and-forget JSON posts to the server (anonymous payloads only).
enum ServerClient {
    /// Returns false when there is no server or the post failed.
    @discardableResult
    static func post(_ path: String, _ body: [String: Any]) async -> Bool {
        guard let base = AppConfig.serverURL,
              let data = try? JSONSerialization.data(withJSONObject: body) else { return false }
        var request = URLRequest(url: base.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.timeoutInterval = 15
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300
        } catch {
            appLog.error("post \(path, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
}

// MARK: - Catalogue

/// The spot catalogue: the copy bundled with the app, replaced by a newer one downloaded from
/// the server (so fixing a spot doesn't need an app release). A download is only used when it
/// decodes and looks sane; otherwise the bundled copy stays.
enum CatalogStore {
    private static var cacheFile: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("catalog.json")
    }
    private static let etagKey = "catalogETag"

    static func bundled() -> SpotCatalog? {
        guard let url = Bundle.main.url(forResource: "spots", withExtension: "json") else { return nil }
        do {
            return try SpotCatalog.load(from: url)
        } catch {
            appLog.fault("bundled catalogue unreadable: \(error.localizedDescription, privacy: .public)")
            assertionFailure("Data/spots.json doesn't decode: \(error)")
            return nil
        }
    }

    /// The newest usable catalogue: downloaded if newer than the bundled one.
    static func current() -> SpotCatalog? {
        let bundled = bundled()
        if let data = try? Data(contentsOf: cacheFile),
           let downloaded = try? JSONDecoder().decode(SpotCatalog.self, from: data),
           isSane(downloaded),
           (downloaded.generatedAt ?? "") > (bundled?.generatedAt ?? "") {
            return downloaded
        }
        return bundled
    }

    static func isSane(_ c: SpotCatalog) -> Bool { c.spots.count >= 50 }

    /// Downloads a newer catalogue in the background (used from the next search on).
    static func refresh() async {
        guard let base = AppConfig.serverURL else { return }
        var request = URLRequest(url: base.appendingPathComponent("v1/catalog"))
        request.timeoutInterval = 20
        if let etag = UserDefaults.standard.string(forKey: etagKey) {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        guard let (data, response) = try? await URLSession.shared.data(for: request),
              let http = response as? HTTPURLResponse, http.statusCode == 200,
              let catalog = try? JSONDecoder().decode(SpotCatalog.self, from: data),
              isSane(catalog) else { return }
        try? FileManager.default.createDirectory(at: cacheFile.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: cacheFile, options: .atomic)
        if let etag = http.value(forHTTPHeaderField: "ETag") { UserDefaults.standard.set(etag, forKey: etagKey) }
        appLog.info("catalogue updated: \(catalog.spots.count) spots, \(catalog.generatedAt ?? "?", privacy: .public)")
    }
}

// MARK: - "How was it?"

/// Remembers the spot the rider looked at for a day, then asks afterwards how it was. Answers
/// stay on the phone and, with a server, go anonymously into the scoring calibration.
@MainActor @Observable
final class FeedbackStore {
    struct Visit: Codable, Equatable {
        var spotId: String
        var spotName: String
        var day: String
        var score: Int
    }

    private static let key = "pendingFeedback"
    private static let answeredKey = "answeredFeedback"
    private(set) var pending: Visit?

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.key) {
            pending = try? JSONDecoder().decode(Visit.self, from: data)
        }
    }

    /// The rider opened a spot with a good window for `day`.
    func viewed(_ rec: SpotRecommendation, day: String) {
        guard rec.finalScore >= 40, day >= DayOption.today.id else { return }
        let visit = Visit(spotId: rec.spot.id, spotName: rec.spot.name, day: day, score: rec.finalScore)
        // Keep the earliest unasked day; a later look at another spot doesn't replace it.
        if let p = pending, p.day < visit.day { return }
        pending = visit
        save()
    }

    /// A visit whose day is over, to ask about now.
    var due: Visit? {
        guard let p = pending, p.day < DayOption.today.id else { return nil }
        // Only ask about the last week.
        return p.day >= DayString.from(Date().addingTimeInterval(-7 * 86400)) ? p : nil
    }

    func answer(_ rating: String) {
        guard let p = pending else { return }
        var answered = UserDefaults.standard.array(forKey: Self.answeredKey) as? [[String: String]] ?? []
        answered.append(["spot": p.spotId, "day": p.day, "score": "\(p.score)", "rating": rating])
        UserDefaults.standard.set(Array(answered.suffix(200)), forKey: Self.answeredKey)
        Task { await ServerClient.post("v1/feedback", ["spotId": p.spotId, "day": p.day, "score": p.score,
                                                       "rating": rating, "appVersion": AppConfig.appVersion]) }
        pending = nil
        save()
    }

    private func save() {
        if let pending, let data = try? JSONEncoder().encode(pending) {
            UserDefaults.standard.set(data, forKey: Self.key)
        } else {
            UserDefaults.standard.removeObject(forKey: Self.key)
        }
    }
}

// MARK: - Diagnostics

/// Crash, hang and launch diagnostics from MetricKit (delivered by iOS, at most daily), sent to
/// the server when there is one. Anonymous: no user data, just stack traces and metrics.
final class Diagnostics: NSObject, MXMetricManagerSubscriber, @unchecked Sendable {   // no mutable state
    static let shared = Diagnostics()

    func start() {
        MXMetricManager.shared.add(self)
    }

    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            let json = (try? JSONSerialization.jsonObject(with: payload.jsonRepresentation())) ?? [:]
            appLog.error("diagnostic payload received")
            Task { await ServerClient.post("v1/diagnostics", ["appVersion": AppConfig.appVersion, "payload": json]) }
        }
    }
}
