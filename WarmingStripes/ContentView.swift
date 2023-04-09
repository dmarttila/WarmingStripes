//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 maybe bar width should be based on chart geo proxy?
 
 Better color range
 
 For axis show 0.6, 0.3, 0.0, -0.3, -0.6
 
 make all the ranges work for Fehrenheit too
 
 I'm using the wrong csv
 how did 1.2 become the raise in temps?
 
 cahnge copyright to MIT and whatever warming stripes is
 
 make prefs button move based on type of chart chosen
 
 get the url of the data from the site
 */

import Charts
import SwiftUI

struct ContentView: View, Haptics {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false
    
    private var chartState: ChartState {
        model.preferences.chartState
    }
    private var isBarsWithScale: Bool {
        chartState == .barsWithScale
    }
    private var axisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : TemperatureAnomaly.maxAnomaly * -1
    }
    private var isC: Bool {
        return model.preferences.units == .celsius
    }
    
    // there is a small space between the bars by default. This fixes that
    private func getBarWidth(_ width: CGFloat) -> MarkDimension {
        let ratio = width / Double($model.anomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }
    
    
    private var titleText: String {
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
    
    //this calculation works, but it feels like there's a better way to do this. However, ChartProxy documention is a bit light so far
    private func getYearXLoc(year: Int, proxy: ChartProxy, geo: GeometryProxy) -> CGFloat {
        let date = Date(year: year, month: 1, day: 1)
        let datePosition = proxy.position(forX: date) ?? 0
        let xAxisDisplayWidth = geo[proxy.plotAreaFrame].origin.x
        return datePosition + xAxisDisplayWidth
    }
    
    func handleChartStateChange(value: ChartState) {
        hapticSelectionChange()
        model.preferences.chartState = value
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Picker("Chart state:", selection: $model.preferences.chartState) {
                    ForEach(ChartState.allCases) { state in
                        Text(state.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: model.preferences.chartState, perform: handleChartStateChange)
                
                if chartState == .labelledStripes {
                    Text(titleText)
                        .font(.title2)
                }
                HStack {
                    if chartState == .bars {
                        Text("1850")
                    }
                    GeometryReader { geo in
                        Chart(model.anomalies) { year in
                            BarMark(
                                x: .value("Date", year.date, unit: .year),
                                y: .value("Anomaly", chartState == .stripes || chartState == .labelledStripes ? 
                                          TemperatureAnomaly.maxAnomaly : year.anomaly),
                                width: getBarWidth(geo.size.width)
                            )
                            .foregroundStyle(year.color)
                            // without corner radius == 0, looks like a picket fence
                            .cornerRadius(0)
                            
                            // you can't style the chart axes to replicate the warming stripes axes, so draw them
                            // Draw the lines that frame the chart 
                            if isBarsWithScale {
                                //x-axis line
                                RuleMark(
                                    xStart: .value("start date", Date(year: 1850, month: 1, day: 1)),
                                    xEnd: .value("end date", Date(year: 2021, month: 1, day: 1)),
                                    y: .value("x axis", axisMinimum)
                                )
                                .foregroundStyle(.white)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                                .offset(y: -25)
                      
                                //y-axis line
                                RuleMark(
                                    x: .value("y axis", Date(year: 1850, month: 1, day: 1)),
                                    yStart: .value("lowest temperature", -0.6),
                                    yEnd: .value("highest temperature", 0.6)
                                )
                                .foregroundStyle(.white)
                                .lineStyle(StrokeStyle(lineWidth: 1))
                            }
                        }
                        // x-axis afaict 
                        .chartOverlay { proxy in
                            GeometryReader { proxyGeo in
                                if isBarsWithScale || chartState == .bars {
                                    VStack(alignment: .leading) {
                                        Text(titleText)
                                            .font(.title2)
                                        if isBarsWithScale {
                                            Text("Relative to average of 1971-2000 [°\(isC ? "C" : "F")]")
                                                .font(.subheadline)
                                        }
                                    }
                                    // aligns the title with the yAxis
                                    .offset(x: proxyGeo[proxy.plotAreaFrame].origin.x)
                                    .padding(5)
                                }
                                if isBarsWithScale || chartState == .labelledStripes {
                                    // TODO: the 20 should be based on the chart proxy
                                    let axisYLoc = proxyGeo.size.height - 20
                                    if chartState == .labelledStripes {
                                        Rectangle()
                                            .fill(.black)
                                            .frame(width: geo.size.width + 2, height: 50)
                                            .offset(x: -1, y: axisYLoc - 5)
                                    }
                                    let years = isBarsWithScale ? [1850, 1900, 1950, 2000, 2021] : Array(stride(from: 1860, through: 2010, by: 30))
                                    ForEach(years, id: \.self) { year in
                                        let textFrameWidth: CGFloat = 300
                                        let axisXloc = getYearXLoc(year: year, proxy: proxy, geo: proxyGeo)
                                        Text(String(year))
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .frame(width: textFrameWidth)
                                            .offset(x: axisXloc - textFrameWidth/2, y: axisYLoc)
                                        if isBarsWithScale {
                                            Rectangle()
                                                .fill(.white)
                                                .frame(width: 1, height: 5)
                                                .offset(x: axisXloc, y: axisYLoc - 5)
                                        }
                                    }
                                }
                            }
                        }
                        .chartYScale(domain: axisMinimum...TemperatureAnomaly.maxAnomaly)
                        // xAxis is drawn above, so it's always hidden
                        .chartXAxis(.hidden)
                        // hide/show the Y axes
                        .chartYAxis(isBarsWithScale ? .visible : .hidden)
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .stride(by: isC ? 0.3 : 0.5)) {value in
                                if let doubleValue = value.as(Double.self), abs(doubleValue) < 0.8 {
                                    AxisValueLabel {
                                        Text(doubleValue.decimalFormat)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    AxisTick(stroke: StrokeStyle(lineWidth: 1.5))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    if chartState == .bars {
                        Text("2021")
                    }
                }
            }
            PreferencesButton(showPreferences: $showPreferences)
                .offset(y: -30)
                .sheet(isPresented: $showPreferences) {
                    PreferencesView().environmentObject(model)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
