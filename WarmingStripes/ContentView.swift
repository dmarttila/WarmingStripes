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
 preferences
 add credit on chart itselft too
 I'm using the wrong csv
 show fehrenheit too
 Title should align to the left edge of the chart not the axis
 icon
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
    @State private var chartState = ChartState.stripes
    
    let anomalies = Model().anomalies
    
    var showXAxis: Visibility {
        chartState == .barsWithScale || chartState == .labelledStripes ? .visible : .hidden
    }
    
    var showYAxis: Visibility {
        chartState == .barsWithScale ? .visible : .hidden
    }
    var axisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : TemperatureAnomaly.maxAnomaly * -1
    }
    
    func getBarWidth (_ w: CGFloat) -> MarkDimension{
        let ratio = w / Double(anomalies.count)
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
    
    var body: some View {
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
                    Chart (anomalies) { year in
                        BarMark(
                            x: .value("Date", year.date, unit: .year),
                            y: .value("Anomaly", chartState == .stripes || chartState == .labelledStripes ? TemperatureAnomaly.maxAnomaly : year.anomaly),
                            width: getBarWidth(geo.size.width),
                            stacking: .standard
                        )
                        .foregroundStyle(year.color)
                    }
                    .chartYScale(domain: axisMinimum ... TemperatureAnomaly.maxAnomaly)
                    .chartXAxis(showXAxis)
                    .chartYAxis(showYAxis)
                    .chartYAxis {
                        AxisMarks(position: .leading) {value in
//                            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2, 4]))
//                                .foregroundStyle(Color.white)
                            AxisValueLabel() { // construct Text here
//                                Text("Hi")
                                
//                                print(value)
                                if let intValue = value.as(Double.self) {
                                    Text("\(intValue)")
//                                        .font(.foo) // style it
                                        .foregroundColor(.white)
                                }
                            }
//                            AxisValueLabel()
//                                .foregroundStyle(.white)
                        }
                        
                        
                    }
                }
                if chartState == .bars {
                    Text("2021")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


