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
 white for axis text
 remove axes grid lines
 
 I'm using the wrong csv
 how did 1.2 become the raise in temps?
 
 remove intermittent fasting everywhere
 */

import SwiftUI
import Charts

struct ContentView: View, Haptics {
    private var chartState: ChartState {
        model.preferences.chartState
    }
    
    @EnvironmentObject var model: Model
    
    var showXAxis: Visibility {
        chartState == .barsWithScale || chartState == .labelledStripes ? .visible : .hidden
    }
    var showYAxis: Visibility {
        chartState == .barsWithScale ? .visible : .hidden
    }
    var axisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : TemperatureAnomaly.maxAnomaly * -1
    }
    //there is a small space between the bars by default. This fixes that
    func getBarWidth (_ w: CGFloat) -> MarkDimension {
        let ratio = w / Double($model.anomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }
    
    var titleText: String {
        switch chartState {
        case .stripes:
            return ""
        case .labelledStripes:
            return "Global temperature change (1850-2021)"
        case .bars:
            return "Global temperature have increased by over \(TemperatureAnomaly.changedMoreThan)\(model.preferences.units.abbreviation)"
        case .barsWithScale:
            return "Global temperature change"
        }
    }
    
//    let textOffsetX = (proxy.position(forX: Date(year: 1950, month: 1, day: 1)) ?? 0) + proxyGeo[proxy.plotAreaFrame].origin.x
    func getYearXLoc (year: Int, proxy: ChartProxy, geo: GeometryProxy) -> CGFloat {
        let date = Date(year: year, month: 1, day: 1)
        let datePosition = proxy.position(forX: date) ?? 0
        let xAxisDisplayWidth = geo[proxy.plotAreaFrame].origin.x
        return datePosition + xAxisDisplayWidth
    }
    
    @State private var yAxisHidden = true
    @State private var showPreferences = false
    
    private var isC: Bool {
        return model.preferences.units == .celsius
    }
    
    func thePickerHasChanged (value: ChartState) {
        hapticSelectionChange()
        model.preferences.chartState = value
    }
    
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            VStack (alignment: .leading){
                Picker("Chart state:", selection: $model.preferences.chartState) {
                    ForEach(ChartState.allCases) { state in
                        Text(state.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: model.preferences.chartState, perform: thePickerHasChanged)
                
                if chartState == .labelledStripes {
                    Text(titleText)
                        .font(.title2)
                }
                HStack {
                    if chartState == .bars {
                        Text("1850")
                    }
                    GeometryReader { geo in
                        Chart (model.anomalies) { year in
                            BarMark(
                                x: .value("Date", year.date, unit: .year),
                                y: .value("Anomaly", chartState == .stripes || chartState == .labelledStripes ? TemperatureAnomaly.maxAnomaly : year.anomaly),
                                width: getBarWidth(geo.size.width)
                            )
                            .foregroundStyle(year.color)
                            //without corner radius == 0, looks a bit like a picket fence
                            .cornerRadius(0)
                            //xAxis
                            if showXAxis == .visible {
                                RuleMark(
                                    xStart: .value("start date", Date(year: 1850, month: 1, day: 1)),
                                    xEnd: .value("end date", Date(year: 2022, month: 1, day: 1)),
                                    y: .value("x axis", axisMinimum)
                                )
                                .foregroundStyle(.white)
                            }
                            //yAxis
                            if showYAxis == .visible {
                                RuleMark(
                                    x: .value("y axis", Date(year: 1850, month: 1, day: 1)),
                                    yStart: .value("lowest temperature", -0.6),
                                    yEnd: .value("highest temperature", 0.6)
                                )
                                .foregroundStyle(.white)
                            }
                        }
                        .chartOverlay { proxy in
                            GeometryReader { proxyGeo in
                                if chartState == .barsWithScale || chartState == .bars {
                                    VStack (alignment: .leading){
                                        Text(titleText)
                                            .font(.title2)
                                        if chartState == .barsWithScale {
                                            Text("Relative to average of 1971-2000 [°\(isC ? "C" : "F")]")
                                                .font(.subheadline)
                                        }
                                    }
                                    //aligns the title with the yAxis
                                    .offset(x: proxyGeo[proxy.plotAreaFrame].origin.x)
                                    .padding(5)
                                }
                                let axisYLoc = proxyGeo.size.height - 20
//                                for year in stride(from: 1850, to: 2000, by: 50) {
//                                    Text(year)
//                                        .offset(x: getYearXLoc(year: year, proxy: proxy, geo: proxyGeo), y: axisYLoc)
//                                }
                                ForEach( Array(stride(from: 1850, to: 2001, by: 50)), id: \.self) { year in
                                    Text(String(year))
                                        .offset(x: getYearXLoc(year: year, proxy: proxy, geo: proxyGeo), y: axisYLoc)
                                        .alignmentGuide(.trailing) { d in d[.trailing] }
                                }
                                let year = 2021
                                Text(String(year))
                                    .offset(x: getYearXLoc(year: year, proxy: proxy, geo: proxyGeo), y: axisYLoc)
                                    
                            }
                        }
                        
                        .chartYScale(domain: axisMinimum ... TemperatureAnomaly.maxAnomaly)
                        
                        //hide/show the axes
                        .chartXAxis(showXAxis)
                        .chartYAxis(showYAxis)
                        .chartXAxis {
                            AxisMarks() {value in
                                AxisValueLabel(centered: false)
                              
                                AxisTick(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(.white)
                            }
                        }

                        
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .stride(by: isC ? 0.3 : 0.5)) {value in

                                if let doubleValue = value.as(Double.self), abs(doubleValue) < 0.8 {
                                    AxisValueLabel() {
                                        //                                    if let doubleValue = value.as(Double.self) {
                                        Text(doubleValue.decimalFormat)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        //                                    }
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
            Button {
                showPreferences.toggle()
            } label: {
                Image(systemName: "gear")
            }
            .buttonStyle(GrowingButtonNoBackground())
            
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


