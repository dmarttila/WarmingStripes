//
//  ChartViewModelTests.swift
//  WarmingStripesTests
//
//  Created by Doug Marttila on 4/30/23.
//

import XCTest
@testable import WarmingStripes

final class ChartViewModelTests: XCTestCase {
    var sut: ChartViewModel!

    override func setUpWithError() throws {
        sut = ChartViewModel(model: Model())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testTitleTextWhenChartStateIsStripes() {
        // Given
        sut.chartState = .stripes

        // When
        let titleText = sut.titleText

        // Then
        XCTAssertEqual(titleText, "")
    }

    func testTitleTextWhenChartStateIsLabelledStripes() {
        // Given
        sut.chartState = .labelledStripes
        sut.startYear = 1900
        sut.endYear = 2000

        // When
        let titleText = sut.titleText

        // Then
        XCTAssertEqual(titleText, "Global temperature change (1900 - 2000)")
    }

    func testTitleTextWhenChartStateIsBarsAndDisplayInCelsiusIsTrue() {
        // Given
        sut.chartState = .bars
        sut.displayInCelsius = true

        // When
        let titleText = sut.titleText

        // Then
        XCTAssertEqual(titleText, "Global temperatures have increased by over 1.2°C")
    }

    func testTitleTextWhenChartStateIsBarsAndDisplayInCelsiusIsFalse() {
        // Given
        sut.chartState = .bars
        sut.displayInCelsius = false

        // When
        let titleText = sut.titleText

        // Then
        XCTAssertEqual(titleText, "Global temperatures have increased by over 2.2°F")
    }

    func testTitleTextWhenChartStateIsBarsWithScale() {
        // Given
        sut.chartState = .barsWithScale

        // When
        let titleText = sut.titleText

        // Then
        XCTAssertEqual(titleText, "Global temperature change")
    }
}


