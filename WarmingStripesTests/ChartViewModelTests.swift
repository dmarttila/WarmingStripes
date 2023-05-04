//
//  ChartViewModelTests.swift
//  WarmingStripesTests
//
//  Created by Doug Marttila on 4/30/23.
// TODO: modify the mock and make different mocks to test different data sets

import SwiftUI
@testable import WarmingStripes
import XCTest

final class ChartViewModelTests: XCTestCase {
    var sut: ChartViewModel!
    var model: Model!

    override func setUpWithError() throws {
        let testBundle = Bundle(for: type(of: self))
        model = Model(csvFileName: "mockData", bundle: testBundle)
        sut = ChartViewModel(model: model)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDrawTitleAboveChart() {
        sut.chartState = .stripes
        XCTAssertFalse(sut.drawTitleAboveChart)

        sut.chartState = .labelledStripes
        XCTAssertTrue(sut.drawTitleAboveChart)

        sut.chartState = .bars
        XCTAssertFalse(sut.drawTitleAboveChart)

        sut.chartState = .barsWithScale
        XCTAssertFalse(sut.drawTitleAboveChart)
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

    func testDrawLeadingAndTrailingYears() {
        sut.chartState = .stripes
        XCTAssertFalse(sut.drawLeadingAndTrailingYears)

        sut.chartState = .labelledStripes
        XCTAssertFalse(sut.drawLeadingAndTrailingYears)

        sut.chartState = .bars
        XCTAssertTrue(sut.drawLeadingAndTrailingYears)

        sut.chartState = .barsWithScale
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

    func testAnomalies() {
        XCTAssertEqual(sut.anomalies, model.anomalies)
    }

    private func makeTemperatureAnomaly (year: Int, anomaly: Double) -> TemperatureAnomaly {
        TemperatureAnomaly(date: Date(year: year, month: 1, day: 1), anomaly: anomaly)
    }

    func testGetYValue() {
        let anomaly = 0.5
        let expectedValue = sut.model.maxAnomaly
        let temperatureAnomaly = makeTemperatureAnomaly(year: 2022, anomaly: anomaly)

        sut.chartState = .stripes
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), expectedValue)

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), expectedValue)

        sut.chartState = .bars
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), anomaly)

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.getYValue(temperatureAnomaly), anomaly)
    }

    // getBarWidth doesn't seem to be testable because MarkDimension isn't Equatable and doesn't have public properties

    func testGetBarColor() {
        let temperatureAnomaly = makeTemperatureAnomaly(year: 2022, anomaly: model.maxAnomaly)
        let expected = Color(UIColor.red.withLuminosity(0.15))
        XCTAssertEqual(sut.getBarColor(temperatureAnomaly), expected)
    }

    func testDrawAxisLines() {
        sut.chartState = .stripes
        XCTAssertFalse(sut.drawAxisLines)

        sut.chartState = .labelledStripes
        XCTAssertFalse(sut.drawAxisLines)

        sut.chartState = .bars
        XCTAssertFalse(sut.drawAxisLines)

        sut.chartState = .barsWithScale
        XCTAssertTrue(sut.drawAxisLines)
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

    func testYAxisLabelRange() {
        model.temperatureScale = .celsius
        XCTAssertEqual(sut.yAxisLabelRange, 0.6)

        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.yAxisLabelRange, 1)
    }

    func testYAxisMaximum() {
        XCTAssertEqual(sut.yAxisMaximum, model.maxAnomaly)
    }

    func testYAxisVisible() {
        sut.chartState = .stripes
        XCTAssertEqual(sut.yAxisVisible, .hidden)

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.yAxisVisible, .hidden)

        sut.chartState = .bars
        XCTAssertEqual(sut.yAxisVisible, .hidden)

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.yAxisVisible, .visible)
    }

    func testYAxisValues() {
        model.temperatureScale = .celsius
        XCTAssertEqual(sut.yAxisValues, [-0.6, -0.3, -0.0, 0.3, 0.6])

        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.yAxisValues, [-1, -0.5, 0.0, 0.5, 1.0])
    }

    func testDrawXAxis() {
        sut.chartState = .stripes
        XCTAssertFalse(sut.drawXAxis)

        sut.chartState = .labelledStripes
        XCTAssertTrue(sut.drawXAxis)

        sut.chartState = .bars
        XCTAssertFalse(sut.drawXAxis)

        sut.chartState = .barsWithScale
        XCTAssertTrue(sut.drawXAxis)
    }

    // getXAxisYLoc doesn't seem testable because it uses ChartProxy and GeometryProxy and they don't appear mockable

    func testXAxisYears() {
        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.xAxisYears, [1860, 1890, 1920, 1950, 1980, 2010])

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.xAxisYears, [1850, 1900, 1950, 2000, 2022])
    }

    // getXLoc and getYearLabelXLoc don't seem testable because they uses ChartProxy and GeometryProxy and they don't appear mockable

    func testDrawTickMarks() {
        sut.chartState = .labelledStripes
        XCTAssertFalse(sut.drawTickMarks)

        sut.chartState = .barsWithScale
        XCTAssertTrue(sut.drawTickMarks)
    }

    func testDrawTitleOnChartPlot() {
        sut.chartState = .stripes
        XCTAssertFalse(sut.drawTitleOnChartPlot)

        sut.chartState = .labelledStripes
        XCTAssertFalse(sut.drawTitleOnChartPlot)

        sut.chartState = .bars
        XCTAssertTrue(sut.drawTitleOnChartPlot)

        sut.chartState = .barsWithScale
        XCTAssertTrue(sut.drawTitleOnChartPlot)
    }

    func testSubTitleText() {
        sut.chartState = .stripes
        XCTAssertEqual(sut.subTitleText, "")

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.subTitleText, "")

        sut.chartState = .bars
        XCTAssertEqual(sut.subTitleText, "")

        sut.chartState = .barsWithScale
        model.temperatureScale = .fahrenheit
        XCTAssertEqual(sut.subTitleText, "Relative to average of 1961-1990 [°F]")
        model.temperatureScale = .celsius
        XCTAssertEqual(sut.subTitleText, "Relative to average of 1961-1990 [°C]")
    }

    func testSpaceForXAxis() {
        sut.chartState = .stripes
        XCTAssertEqual(sut.spaceForXAxis, 0)

        sut.chartState = .labelledStripes
        XCTAssertEqual(sut.spaceForXAxis, 25)

        sut.chartState = .bars
        XCTAssertEqual(sut.spaceForXAxis, 0)

        sut.chartState = .barsWithScale
        XCTAssertEqual(sut.spaceForXAxis, 25)
    }

    func testGetRolloverText() {
        let anomaly = 0.5
        let temperatureAnomaly = makeTemperatureAnomaly(year: 2022, anomaly: anomaly)

        model.temperatureScale = .celsius
        var expected = sut.getRolloverText(temperatureAnomaly)
        XCTAssertEqual(expected, "Year: 2022\nAnomaly: 0.5°C")

        model.temperatureScale = .fahrenheit
        expected = sut.getRolloverText(temperatureAnomaly)
        XCTAssertEqual(expected, "Year: 2022\nAnomaly: 0.5°F")
    }
}
