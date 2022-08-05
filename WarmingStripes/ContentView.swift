//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 Better color range
 
 Set the axis scale
 leading for yAxis
 
 */

import SwiftUI
import Charts

enum ChartState: String,  CaseIterable, Identifiable{
    case stripes = "Warming Stripes"
    case labelledStripes = "Labelled Stripes"
    case bars = "Bars"
    case barsWithScale = "Bars with Scale"
    public var id: ChartState { self }
}

struct ContentView: View {
    @State private var chartState = ChartState.stripes
    
    let anomalies: [TemperatureAnomaly]
    
    var showXAxis: Visibility {
        chartState == .barsWithScale || chartState == .labelledStripes ? .visible : .hidden
    }
    
    var showYAxis: Visibility {
        chartState == .barsWithScale ? .visible : .hidden
    }
    var axisMinimum: Double {
        chartState == .stripes || chartState == .labelledStripes ? 0 : TemperatureAnomaly.minAnomaly
    }
    
    init() {
        anomalies = Model().anomalies
    }
    
    func getBarWidth (_ w: CGFloat) -> MarkDimension{
        let ratio = w / Double(anomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }
    
    @State private var yAxisHidden = true
    
    var body: some View {
        VStack {
            Picker("Units:", selection: $chartState) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            GeometryReader { geo in
                VStack (alignment: .leading){
                    Text("Global temperature change")
                        .font(.title2)
                    if chartState == .barsWithScale {
                        Text("Relative to average of 1971-2000 [°C]")
                            .font(.subheadline)
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
                    AxisMarks(position: .leading)
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


