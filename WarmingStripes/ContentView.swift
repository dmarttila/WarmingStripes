//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 Better color range
 
 For axis show 0.6, 0.3, 0.0, -0.3, -0.6
 white for axis text
 remove axes grid lines
 remove ponted top to lines
 I'm using the wrong csv
 Title should align to the left edge of the chart not the axis
 app icon
 Save temperature prefs
 temperature units
 
 
 Low PRIORITY
 save chart state e.g., bars
 */

import SwiftUI
import Charts

enum ChartState: String,  CaseIterable, Identifiable{
    case stripes = "Warming Stripes"
    case labelledStripes = "Labeled Stripes"
    case bars = "Bars"
    case barsWithScale = "Bars with Scale"
    public var id: ChartState { self }
}

struct ContentView: View {
    @State private var chartState = ChartState.barsWithScale
    @EnvironmentObject var model: Model
    
//    let anomalies = Model().anomalies
    
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
            return "Global temperature have increased by over 1.2°C"
        case .barsWithScale:
            return "Global temperature change"
        }
    }
    
    @State private var yAxisHidden = true
    @State private var showPreferences = false
    
    //this hides the top and bottom y axis labels (otherwise 0.9 and -0.9 would show up)
    private func yAxisLabel(_ temp: Double) -> String {
        abs(temp) > 0.6 ? "" : temp.decimalFormat
    }
    
    
//    @StateObject var model = Model()

//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
            VStack (alignment: .leading){
                Picker("Units:", selection: $chartState) {
                    ForEach(ChartState.allCases) { state in
                        Text(state.rawValue.uppercased())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                if chartState == .labelledStripes {
                    Text(titleText)
                        .font(.title2)
                }
                HStack {
                    if chartState == .bars {
                        Text("1850")
                    }
                    GeometryReader { geo in
                        if chartState == .barsWithScale || chartState == .bars {
                            VStack (alignment: .leading){
                                Text(titleText)
                                    .font(.title2)
                                if chartState == .barsWithScale {
                                    Text("Relative to average of 1971-2000 [°C]")
                                        .font(.subheadline)
                                }
                            }
                        }
                        Chart (model.anomalies) { year in
                            BarMark(
                                x: .value("Date", year.date, unit: .year),
                                y: .value("Anomaly", chartState == .stripes || chartState == .labelledStripes ? TemperatureAnomaly.maxAnomaly : year.anomaly),
                                width: getBarWidth(geo.size.width)
                            )
                            .foregroundStyle(year.color)
                        }
                        .chartYScale(domain: axisMinimum ... TemperatureAnomaly.maxAnomaly)
                        .chartXAxis(showXAxis)
                        
                        .chartYAxis(showYAxis)
                        
                        .chartXAxis {
                            AxisMarks() {value in
                                AxisValueLabel(centered: false)
//                                AxisValueLabel(format: <#T##FormatStyle#>, centered: <#T##Bool?#>, anchor: <#T##UnitPoint?#>, multiLabelAlignment: <#T##Alignment?#>, collisionResolution: <#T##AxisValueLabelCollisionResolution#>, offsetsMarks: <#T##Bool?#>, orientation: <#T##AxisValueLabelOrientation#>, horizontalSpacing: <#T##CGFloat?#>, verticalSpacing: <#T##CGFloat?#>)
                                    
//                                print(value)
//                                if let doubleValue = value.as(Double.self) {
//                                    Text(yAxisLabel(doubleValue))
//                                        .font(.caption)
//                                        .foregroundColor(.white)
//                                }
//                                    .foregroundStyle(.white)
                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2, 4]))
                                    .foregroundStyle(Color.indigo)
                                AxisTick(centered: true, length: 20, stroke: StrokeStyle(lineWidth: 1))
//                                AxisTick(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        //                        AxisMarks(values: .stride(by: xAxisStride, count: xAxisStrideCount)) { date in
                        //                                AxisValueLabel(format: xAxisLabelFormatStyle(for: date.as(Date.self) ?? Date()))
                        //                            }
                        
                        //                        chartYAxis {
                        //                            AxisMarks(position: .leading, values: .stride(by: yAxisStride)) { value in
                        //                                AxisGridLine()
                        //                                AxisValueLabel(yAxisLabel(for: value.as(Double.self) ?? 0))
                        //                            }
                        //                        }
                        
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .stride(by: 0.3)) {value in
                                //                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2, 4]))
                                //                                    .foregroundStyle(Color.white)
                                
                                //                                AxisValueLabel(yAxisLabel(value.as(Double.self) ?? 0))
                                //                                    .foregroundColor(.white)
                                AxisValueLabel() {
                                    if let doubleValue = value.as(Double.self) {
                                        Text(yAxisLabel(doubleValue))
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                AxisTick(stroke: StrokeStyle(lineWidth: 1))
                                      .foregroundStyle(.white)
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


