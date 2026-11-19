import XCTest
import KiteCore
@testable import WhereToKite

/// The spot page's note when the models held the grade back (WHE-238). Tests run in English.
final class ModelDoubtTextTests: XCTestCase {
    func testFewModelsSeeWind() {
        XCTAssertEqual(Vocab.modelDoubt(.fewSeeWind(seeing: 1, total: 4)), "Only 1 of 4 models sees enough wind")
        XCTAssertEqual(Vocab.modelDoubt(.fewSeeWind(seeing: 2, total: 4)), "Only 2 of 4 models see enough wind")
        XCTAssertEqual(Vocab.modelDoubt(.fewSeeWind(seeing: 0, total: 4)), "None of the 4 models we check sees enough wind")
    }

    func testDisagreeAndJustEnough() {
        XCTAssertEqual(Vocab.modelDoubt(.disagree(lowKn: 14, highKn: 24)), "Models disagree: 14–24 kn")
        XCTAssertEqual(Vocab.modelDoubt(.justEnough(lowKn: 14, highKn: 16)), "Models agree on 14–16 kn, just over your minimum")
        XCTAssertEqual(Vocab.modelDoubt(.justEnough(lowKn: 14, highKn: 14)), "Models agree on about 14 kn, just over your minimum")
    }

    func testDetailNamesEachCheckedModel() {
        let c = KiteChance(chance: 0.3, outlook: .unlikely, leadDays: 1, minWindKn: 12.6,
                           modelBestKn: ["best_match": 9.4, "meteofrance_seamless": 18.2, "icon_seamless": 10, "ecmwf_ifs025": 11])
        XCTAssertEqual(Vocab.modelDoubtDetail(c, sessionHours: 2),
                       "Best 2 h per model: Météo-France 18 · ECMWF 11 · ICON 10 · Open-Meteo 9 kn. You need 13 kn.")
    }
}
