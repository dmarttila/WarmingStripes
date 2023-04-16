//
//  ChartViewModel.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import Charts
import SwiftUI

class ChartViewModel: ObservableObject {
    private let model: Model
    
    @Binding var chartTry: ChartState
    
    /*
     init(isOn: Binding<Bool>) {
             _isOn = isOn
         }

     */
    
    init (model: Model, chartState: Binding<ChartState>) {
        self.model = model
//        chartState = model.chartState
        yearFormatter.dateFormat = "yyyy"
        _chartTry = chartState
    }
    
    func getYValue (_ year: TemperatureAnomaly) -> Double {
        chartState == .stripes || chartState == .labelledStripes ? 
        TemperatureAnomaly.maxAnomaly : year.anomaly
    }
    
    var anomalies: [TemperatureAnomaly] {
        model.anomalies
        
    }
    
//    @Published var chartState: ChartState = .bars
    
    var chartState: ChartState {
        model.chartState
    }
    var isBarsWithScale: Bool {
        chartState == .barsWithScale
    }
    var axisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : TemperatureAnomaly.maxAnomaly * -1
    }
    var displayInCelcius: Bool {
        return model.preferences.units == .celsius
    }
    
    let yearFormatter = DateFormatter()
    
    func getYear (from date: Date) -> String {
        yearFormatter.string(from: date)
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
            return "Global temperature have increased by over \(TemperatureAnomaly.changedMoreThan)\(model.preferences.units.abbreviation)"
        case .barsWithScale:
            return "Global temperature change"
        }
    }
    
    var subTitleText: String {
        isBarsWithScale ? "Relative to average of 1971-2000 [°\(displayInCelcius ? "C" : "F")]" : ""
    }
    
    let startDate = Date(year: 1850, month: 1, day: 1)
    let endDate = Date(year: 2021, month: 1, day: 1)
    
    var yAxisMinMax: Double {
        displayInCelcius ? 0.6 : 1
    }
    
    func symetricalAxisValues (minMax: Double, by strideBy: Double) -> [Double] {
        Array(stride(from: minMax * -1, through: minMax, by: strideBy))
    }
    
    var yAxisValues: [Double] {
        symetricalAxisValues(minMax: yAxisMinMax, by: displayInCelcius ? 0.3 : 0.5)
    }
    
    //this calculation works, but it feels like there's a better way to do this. However, ChartProxy documention is a bit light so far
    func getYearXLoc(year: Int, proxy: ChartProxy, geo: GeometryProxy) -> CGFloat {
        let date = Date(year: year, month: 1, day: 1)
        let datePosition = proxy.position(forX: date) ?? 0
        let xAxisDisplayWidth = geo[proxy.plotAreaFrame].origin.x
        return datePosition + xAxisDisplayWidth
    }
    
    func handleChartStateChange(value: ChartState) {
//        hapticSelectionChange()
//        chartState = value
//        model.chartState = value
    }
    
}
