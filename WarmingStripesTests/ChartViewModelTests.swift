//
//  ChartViewModelTests.swift
//  WarmingStripesTests
//
//  Created by Doug Marttila on 4/30/23.
//

import XCTest
@testable import WarmingStripes
import Charts
import SwiftUI

final class ChartViewModelTests: XCTestCase {
    var sut: ChartViewModel!
    var model: Model!

    override func setUpWithError() throws {
        model = Model()
        sut = ChartViewModel(model: model)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTitleText() {
        sut.chartState = .stripes
        XCTAssertEqual(sut.titleText, "")

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.titleText, "Global temperature change (1850 - 2022)")

        sut.chartState = .bars
        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.titleText, "Global temperatures have increased by over 2.2°F")

        model.temperatureScale = .celsius
        XCTAssertEqual(sut.titleText, "Global temperatures have increased by over 1.2°C")

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.titleText, "Global temperature change")
    }

    func testDrawTitleAboveChart() {
        sut.chartState = .labelledStripes
        XCTAssertTrue(sut.drawTitleAboveChart)

        sut.chartState = .bars
        XCTAssertFalse(sut.drawTitleAboveChart)
    }

    func testTemperatureAbbreviation() {
        model.temperatureScale = .celsius
        XCTAssertEqual(sut.temperatureAbbreviation, "°C")

        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.temperatureAbbreviation, "°F")
    }

    func testDrawLeadingAndTrailingYears() {
        sut.chartState = .bars
        XCTAssertTrue(sut.drawLeadingAndTrailingYears)

        sut.chartState = .stripes
        XCTAssertFalse(sut.drawLeadingAndTrailingYears)
    }

    func testStartYear() {
        let expectedYear = "1850"
        XCTAssertEqual(sut.startYear, expectedYear)
    }

    func testEndYear() {
        let expectedYear = "2022"
        XCTAssertEqual(sut.endYear, expectedYear)
    }

    func makeTemperatureAnomaly (year: Int, anomaly: Double) -> TemperatureAnomaly {
        TemperatureAnomaly(date: Date(year: year, month: 1, day: 1), anomaly: anomaly)
    }

    func testGetYValue() {
        sut.chartState = .stripes
        let anomaly = 0.5
        let expectedValue = sut.model.maxAnomaly
        let temperatureAnomaly = makeTemperatureAnomaly(year: 2022, anomaly: anomaly)
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), expectedValue)

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), expectedValue)

        sut.chartState = .bars
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), anomaly)

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), anomaly)
    }
    func testDrawAxisLines() {
        sut.chartState = .barsWithScale
        XCTAssertTrue(sut.drawAxisLines)

        sut.chartState = .bars
        XCTAssertFalse(sut.drawAxisLines)
    }

    func testYAxisMinimum() {
        sut.chartState = .stripes
        XCTAssertEqual(sut.yAxisMinimum, 0)

        sut.chartState =  .labelledStripes
        XCTAssertEqual(sut.yAxisMinimum, 0)

        sut.chartState =  .bars
        XCTAssertEqual(sut.yAxisMinimum, -model.maxAnomaly)

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.yAxisMinimum, -model.maxAnomaly)
    }

    func testGetYAxisMaximum() {
        XCTAssertEqual(sut.yAxisMaximum, model.maxAnomaly)
    }

    func testGetYAxisVisible() {
        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.yAxisVisible, .visible)
    }

    func testGetYAxisValues() {
        model.temperatureScale = .celsius
        XCTAssertEqual(sut.yAxisValues, [-0.6, -0.3, -0.0, 0.3, 0.6])
        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.yAxisValues, [-1, -0.5, 0.0, 0.5, 1.0])
    }

    func testGetDrawXAxis() {
        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.drawXAxis, true)
        sut.chartState = .bars
        XCTAssertEqual(sut.drawXAxis, false)
        sut.chartState = .stripes
        XCTAssertEqual(sut.drawXAxis, false)
        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.drawXAxis, true)
    }

}
