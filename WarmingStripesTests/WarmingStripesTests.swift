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
        sut = Model()
        sut.temperatureScale = .celsius
    }

    override func tearDownWithError() throws {
        sut = nil
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

}
