//
//  ChartViewModel.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import Charts
import SwiftUI

class ChartViewModel: ObservableObject, Haptics, DeviceInfo {

    @ObservedObject var model: Model
    @Binding var chartState: ChartState {
        didSet {
            hapticSelectionChange()
        }
    }
    init (model: Model) {
        self.model = model
        _chartState = model.$chartState
    }

    // Chart title
    var drawTitleAboveChart: Bool {
        chartState == .labelledStripes
    }

    var titleText: String {
        switch chartState {
        case .stripes:
            return ""
        case .labelledStripes:
            return "Global temperature change (\(startYear) - \(endYear))"
        case .bars:
            // Can't calculate global temp differences from data, so hard code
            return "Global temperatures have increased by over \(displayInCelsius ? 1.2 : 2.2)\(temperatureAbbreviation)"
        case .barsWithScale:
            return "Global temperature change"
        }
    }

    // for the Bars state, draw years to the left and right of the chart
    var drawLeadingAndTrailingYears: Bool {
        chartState == .bars
    }
    var startYear: String {
        model.startDate.yearString
    }
    var endYear: String {
        model.endDate.yearString
    }

    // chart data
    var anomalies: [TemperatureAnomaly] {
        model.anomalies
    }
    func getYValue (_ anomaly: TemperatureAnomaly) -> Double {
        chartState == .stripes || chartState == .labelledStripes ?
        model.maxAnomaly : anomaly.anomaly
    }
    // there is a small space between the bars by default. This fixes that
    func getBarWidth(_ width: CGFloat) -> MarkDimension {
        let ratio = width / Double(model.anomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }
    // color scales are tricky. This works, but will need tweaking when additional data sets are loaded
    func getBarColor (_ temperaturAnomaly: TemperatureAnomaly) -> Color {
        let anomaly = temperaturAnomaly.anomaly
        let color: UIColor
        var luminosity: Double
        if anomaly > 0 {
            color = .red
            luminosity = 1 - anomaly/model.maxAnomaly
        } else {
            color = UIColor(Color(hex: 0x0A2F5C))
            luminosity = 1 - anomaly/model.minAnomaly
        }
        luminosity = luminosity * 0.85 + 0.15
        return Color(color.withLuminosity(luminosity))
    }

    // data for drawing the frame around the chart, only used for Bars with Scale
    var drawAxisLines: Bool { isBarsWithScale }
    var startDate: Date { model.startDate }
    var endDate: Date { model.endDate }
    var yAxisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : model.maxAnomaly * -1
    }
    let axisLineWidth: Double = 1
    // TODO: remove the hardcoding - from -0.6 to 0.6
    var yAxisLabelRange: Double {
        displayInCelsius ? 0.6 : 1
    }

    // y-axis
    var yAxisMaximum: Double { model.maxAnomaly }
    var yAxisVisible: Visibility {
        isBarsWithScale ? .visible : .hidden
    }

    // returns the list of labels for the y-axis. This should be made dynamic
    var yAxisValues: [Double] {
        let strideBy = displayInCelsius ? 0.3 : 0.5
        return Array(stride(from: yAxisLabelRange * -1, through: yAxisLabelRange, by: strideBy))
    }

    // draw the x-axis. Swift Charts can't style to match Warming Stripes. So draw as a chartOverlay
    var drawXAxis: Bool {
        isBarsWithScale || chartState == .labelledStripes
    }
    func getXAxisYLoc(chartProxy: ChartProxy, geoProxy: GeometryProxy) -> CGFloat {
        let datePosition = chartProxy.position(forY: yAxisMinimum) ?? 0
        let xAxisDisplayWidth = geoProxy[chartProxy.plotAreaFrame].origin.y
        return datePosition + xAxisDisplayWidth
    }
    // TODO: make this dynamic
    var xAxisYears: [Int] {
        isBarsWithScale ? [1850, 1900, 1950, 2000, 2022] :
        Array(stride(from: 1860, through: 2010, by: 30))
    }
    let yearLabelWidth: CGFloat = 300
    func getXLoc(for year: Int, chartProxy: ChartProxy, geoProxy: GeometryProxy) -> CGFloat {
        let date = Date(year: year, month: 1, day: 1)
        let datePosition = chartProxy.position(forX: date) ?? 0
        let chartPlotAreaXLoc = geoProxy[chartProxy.plotAreaFrame].origin.x
        return datePosition + chartPlotAreaXLoc
    }

    func getYearLabelXLoc (for year: Int, chartProxy: ChartProxy, geoProxy: GeometryProxy) -> CGFloat {
        // in Landscape mode the last year gets truncated on bars with scale, draw it offscreen
        if !inLandscapeMode && year == xAxisYears.last && isBarsWithScale {
            return 5000
        }
        let xLoc = getXLoc(for: year, chartProxy: chartProxy, geoProxy: geoProxy)
        return xLoc - yearLabelWidth/2
    }
    var drawTickMarks: Bool { isBarsWithScale }
    let tickMarkHeight: Double = 5

    // additional data for drawing the title on top of the chart
    var drawTitleOnChartPlot: Bool {
        isBarsWithScale || chartState == .bars
    }
    var subTitleText: String {
        isBarsWithScale ? "Relative to average of 1961-1990 [\(temperatureAbbreviation)]" : ""
    }

    // if the xAxis is drawn, create space for it
    var spaceForXAxis: CGFloat {
        drawXAxis ? 25 : 0
    }

    //Rollover code
    @Published var chartValueIndicatorOffset = CGSize.zero
    @Published var isDragging: Bool = false
    @Published var rolloverText: String = ""
    let rolloverViewWidth: CGFloat = 130
    let rolloverBackground = Color(hex: 0x5B5B60)

    func dragging(location: CGPoint, chartProxy: ChartProxy, chartProxyGeo: GeometryProxy) {
        let currentX = location.x - chartProxyGeo[chartProxy.plotAreaFrame].origin.x
        guard let date = chartProxy.value(atX: currentX, as: Date.self) else { return }
        guard let temperatureAnomaly = model.anomalies.first(where: { $0.date > date }) else { return }
        rolloverText = getRolloverText(temperatureAnomaly)
        var locX = location.x
        let locY = location.y - 75
        locX -= rolloverViewWidth * locX/chartProxyGeo.size.width
        chartValueIndicatorOffset = CGSize(width: locX, height: locY)
        isDragging = true
    }
    func getRolloverText (_ temperatureAnomaly: TemperatureAnomaly) -> String {
        var str = "Year: \(temperatureAnomaly.date.yearString)\n"
        str +=  "Anomaly: \(temperatureAnomaly.anomaly.decimalFormat)"
        str += temperatureAbbreviation
        return str
    }
    func stoppedDragging() {
        isDragging = false
    }

    // HELPERS
    private var isBarsWithScale: Bool {
        chartState == .barsWithScale
    }
    private var displayInCelsius: Bool {
        return model.temperatureScale == .celsius
    }
    private var temperatureAbbreviation: String {
        model.temperatureScale.abbreviation
    }

}
