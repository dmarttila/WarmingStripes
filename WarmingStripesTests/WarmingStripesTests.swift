//
//  WarmingStripesTests.swift
//  WarmingStripesTests
//
//  Created by Doug Marttila on 4/30/23.
//

import XCTest
@testable import WarmingStripes

final class WarmingStripesTests: XCTestCase {
    var sut: Model!
    override func setUpWithError() throws {
        let testBundle = Bundle(for: type(of: self))
        sut = Model(csvFileName: "mockData", bundle: testBundle)
        sut.temperatureScale = .celsius
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCSVLoading() {
        let testBundle = Bundle(for: type(of: self))
        guard let csvURL = testBundle.url(forResource: "mockData", withExtension: "csv") else {
            XCTFail("CSV file not found in test bundle")
            return
        }
        do {
            let csvData = try Data(contentsOf: csvURL)
            // Use the CSV data in your test
        } catch {
            XCTFail("Error loading CSV file: \(error)")
        }
    }

    func testBundleDataLoad() throws {
        let anomalyCount = 173
        let minAnomaly = -0.5975614
        let maxAnomaly = 0.93292713
        var tempAbbreviation = "°C"
        XCTAssertEqual(sut.anomalies.count, anomalyCount)
        XCTAssertEqual(sut.minAnomaly, minAnomaly)
        XCTAssertEqual(sut.maxAnomaly, maxAnomaly)
        XCTAssertEqual(sut.temperatureScale.abbreviation, tempAbbreviation)

        sut.temperatureScale = .fahrenheit
        // the Fahrenheit calculation results in a lot of decimal places, so just check the display
        let minAnomalyFahrenheit = "-1.1"
        let maxAnomalyFahrenheit = "1.7"
        tempAbbreviation = "°F"
        XCTAssertEqual(sut.anomalies.count, anomalyCount)
        XCTAssertEqual(sut.minAnomaly.decimalFormat, minAnomalyFahrenheit)
        XCTAssertEqual(sut.maxAnomaly.decimalFormat, maxAnomalyFahrenheit)
        XCTAssertEqual(sut.temperatureScale.abbreviation, tempAbbreviation)
    }

    func testMaxMinDate () {
        let startDate = Date(year: 1850, month: 1, day: 1)
        XCTAssertEqual(startDate, sut.startDate)

        let endDate = Date(year: 2022, month: 1, day: 1)
        XCTAssertEqual(endDate, sut.endDate)
    }

}
