//
//  ChartViewModel.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import Charts
import SwiftUI

class ChartViewModel: ObservableObject, Haptics {
    @ObservedObject var model: Model
    @Binding var chartState: ChartState {
        didSet {
            hapticSelectionChange()
        }
    }

    init (model: Model) {
        self.model = model
        _chartState = model.$chartState
        yearFormatter.dateFormat = "yyyy"
    }
    
    // years that draw to the right and left of the chart for bars state
    private let yearFormatter = DateFormatter()
    private func getYear (from date: Date) -> String {
        yearFormatter.string(from: date)
    }
    var startYear: String {
        getYear(from: startDate)
    }
    var endYear: String {
        getYear(from: endDate)
    }

    var anomalies: [TemperatureAnomaly] {
        model.anomalies
    }
    func getYValue (_ anomaly: TemperatureAnomaly) -> Double {
        chartState == .stripes || chartState == .labelledStripes ? 
        model.maxAnomaly : anomaly.anomaly
    }
    var isBarsWithScale: Bool {
        chartState == .barsWithScale
    }
    var yAxisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : model.maxAnomaly * -1
    }
    
    var drawXAxis: Bool {
        isBarsWithScale || chartState == .labelledStripes
    }
    
    var yAxisVisible: Visibility {
        isBarsWithScale ? .visible : .hidden
    }
    
    var yAxisMaximum: Double  {
        model.maxAnomaly
    }
    
    func getBarColor (_ temperaturAnomaly: TemperatureAnomaly) -> Color {
        let anomaly = temperaturAnomaly.anomaly
        if anomaly > 0 {
            let val = 1 - anomaly/model.maxAnomaly
            return Color(red: 1, green: val, blue: val)
        }
        let val = 1 - anomaly/model.minAnomaly
        return Color(red: val, green: val, blue: 1)
    }
    
    var displayInCelsius: Bool {
        return model.temperatureScale == .celsius
    }

    
    // there is a small space between the bars by default. This fixes that
    func getBarWidth(_ width: CGFloat) -> MarkDimension {
        let ratio = width / Double(model.anomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }
    
    var xAxisYears: [Int] {
        isBarsWithScale ? [1850, 1900, 1950, 2000, 2021] : Array(stride(from: 1860, through: 2010, by: 30))
    }
    
    var titleText: String {
        switch chartState {
        case .stripes:
            return ""
        case .labelledStripes:
            return "Global temperature change(1850-2021)"
        case .bars:
            return "Global temperature have increased by over \(model.changedMoreThan)\(model.temperatureScale.abbreviation)"
        case .barsWithScale:
            return "Global temperature change"
        }
    }
    
    var subTitleText: String {
        isBarsWithScale ? "Relative to average of 1971-2000 [°\(displayInCelsius ? "C" : "F")]" : ""
    }
    
    let startDate = Date(year: 1850, month: 1, day: 1)
    let endDate = Date(year: 2021, month: 1, day: 1)
    
    var yAxisMinMax: Double {
        displayInCelsius ? 0.6 : 1
    }
    
    func symetricalAxisValues (minMax: Double, by strideBy: Double) -> [Double] {
        Array(stride(from: minMax * -1, through: minMax, by: strideBy))
    }
    
    var yAxisValues: [Double] {
        symetricalAxisValues(minMax: yAxisMinMax, by: displayInCelsius ? 0.3 : 0.5)
    }
    
    //this calculation works, but it feels like there's a better way to do this. However, ChartProxy documention is a bit light so far
    func getYearXLoc(year: Int, proxy: ChartProxy, geo: GeometryProxy) -> CGFloat {
        let date = Date(year: year, month: 1, day: 1)
        let datePosition = proxy.position(forX: date) ?? 0
        let xAxisDisplayWidth = geo[proxy.plotAreaFrame].origin.x
        return datePosition + xAxisDisplayWidth
    }
}
