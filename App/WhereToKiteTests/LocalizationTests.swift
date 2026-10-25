import XCTest
@testable import WhereToKite

/// The string catalogs: every phrase translated, with the same placeholders as the English.
final class LocalizationTests: XCTestCase {
    /// Languages the app ships besides English.
    static let languages = ["es"]

    private static let appFolder = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("WhereToKite")

    private func catalog(_ name: String) throws -> [String: [String: Any]] {
        let data = try Data(contentsOf: Self.appFolder.appendingPathComponent(name))
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        return try XCTUnwrap(json["strings"] as? [String: [String: Any]])
    }

    /// "%@", "%lld", "%1$@" → their types in order of position ("@", "lld").
    private func placeholders(_ s: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "%(?:(\\d)\\$)?(@|lld|d)")
        let matches = regex.matches(in: s, range: NSRange(s.startIndex..., in: s))
        let found = matches.enumerated().map { i, m -> (Int, String) in
            let pos = Range(m.range(at: 1), in: s).flatMap { Int(s[$0]) } ?? i + 1
            return (pos, String(s[Range(m.range(at: 2), in: s)!]))
        }
        return found.sorted { $0.0 < $1.0 }.map(\.1)
    }

    /// The values of one language: a single string, or each plural form.
    private func values(_ entry: [String: Any], _ language: String) -> [String]? {
        guard let loc = (entry["localizations"] as? [String: Any])?[language] as? [String: Any] else { return nil }
        if let unit = loc["stringUnit"] as? [String: Any], let v = unit["value"] as? String { return [v] }
        let forms = (loc["variations"] as? [String: Any])?["plural"] as? [String: [String: Any]] ?? [:]
        let v = forms.values.compactMap { ($0["stringUnit"] as? [String: Any])?["value"] as? String }
        return v.isEmpty ? nil : v
    }

    func testEveryPhraseIsTranslated() throws {
        for file in ["Localizable.xcstrings", "InfoPlist.xcstrings"] {
            for (key, entry) in try catalog(file) {
                for language in Self.languages {
                    let translated = try XCTUnwrap(values(entry, language), "\(file): no \(language) for \"\(key)\"")
                    if key == "Tomorrow" { continue }   // may be empty on purpose (weekday instead)
                    for v in translated {
                        XCTAssertFalse(v.isEmpty, "\(file): empty \(language) for \"\(key)\"")
                        XCTAssertEqual(placeholders(v), placeholders(key),
                                       "\(file): \(language) placeholders differ for \"\(key)\": \(v)")
                    }
                }
            }
        }
    }

    /// The compass list is split on spaces: it must keep 16 points.
    func testCompassPointsStaySixteen() throws {
        let entry = try XCTUnwrap(try catalog("Localizable.xcstrings")["N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW"])
        for language in Self.languages {
            let points = try XCTUnwrap(values(entry, language)?.first).split(separator: " ")
            XCTAssertEqual(points.count, 16, language)
        }
        XCTAssertEqual(Vocab.compass(270), "W")   // tests run in English
    }

    func testEngineTermsAreMapped() {
        // Every flag KiteCore can raise has its own entry (otherwise the English shows through).
        for flag in ["too light", "too strong for level", "too strong for quiver", "gusty", "overpowered in gusts",
                     "offshore component", "beach orientation unknown", "thunderstorm risk", "kiting banned", "dark",
                     "heavy rain", "rain", "unstable air", "tide too low", "tide too high", "no forecast",
                     "poor conditions", "offshore"] {
            XCTAssertFalse(Vocab.term(flag).isEmpty, flag)
        }
        XCTAssertEqual(Vocab.term("too strong for level"), "too strong for your level")
        XCTAssertEqual(Vocab.tide("High 14:20 · Low 08:05, 20:35"), "High 14:20 · Low 08:05, 20:35")
    }
}
