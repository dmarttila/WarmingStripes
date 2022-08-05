//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 Better color range
 Zoom in and out
 Dupe all the other views
 Set the axis scale
 Get the bars touching and no stroke
 
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
    @State private var dateFilterMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    @State private var dateFilterMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate
    
    let dateMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    let dateMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate
    
    let anomalies: [TemperatureAnomaly]
    
    var showXAxis: Visibility {
        chartState == .barsWithScale || chartState == .labelledStripes ? .visible : .hidden
    }
    
    var showYAxis: Visibility {
        //        return showXAxis
        chartState == .barsWithScale ? .visible : .hidden
        //        chartState == .barsWithScale || chartState == .labelledStripes ? .visible : .hidden
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
            Picker("Units:", selection: $chartState.animation(.easeInOut)) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Text(dateFilterMin.asDate.monthDateYear)
                Text(" - ")
                Text(dateFilterMax.asDate.monthDateYear)
            }
            GeometryReader { geo in
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


