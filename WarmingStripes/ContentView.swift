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

    var filteredAnomalies: [TemperatureAnomaly] {
        let min = Date(timeIntervalSinceReferenceDate: dateFilterMin)
        let max = Date(timeIntervalSinceReferenceDate: dateFilterMax)
        return anomalies.filter {
            ($0.date >= min && $0.date <= max)
        }
    }

    init() {
        anomalies = Model().anomalies
    }

    func getBarWidth (_ w: CGFloat) -> MarkDimension{
        let ratio = w / Double(filteredAnomalies.count)
        return MarkDimension(floatLiteral: ratio + 0.5)
    }

    @State private var yAxisHidden = true

    var body: some View {
        VStack {
            HStack {
                Button ("change opacity") {
                    withAnimation(.easeInOut(duration: 2)) {
                        self.yAxisHidden.toggle()
                    }
                }
                Text("Opacity test")
                    .opacity(yAxisHidden ? 0 : 1)
                Text("Opacity val \(String(yAxisHidden))")
            }
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
                VStack {
                    ZStack (alignment: .leading){
                        Slider(value: $dateFilterMin, in: dateMin...dateFilterMax)
                            .frame(width: geo.size.width * (dateFilterMax - dateMin) / (dateMax - dateMin))
                        Slider(value: $dateFilterMax, in: dateFilterMin...dateMax)
                            .offset(x: geo.size.width - geo.size.width * (dateMax - dateFilterMin) / (dateMax - dateMin) + 5, y: 0)
                            .frame(width: geo.size.width * (dateMax - dateFilterMin) / (dateMax - dateMin))
                    }
                    //                    .frame(height: 250)
                    Chart (filteredAnomalies) { year in
                        BarMark(
                            x: .value("Date", year.date, unit: .year),
                            y: .value("Anomaly", chartState == .stripes || chartState == .labelledStripes ? TemperatureAnomaly.maxAnomaly : year.anomaly),
                            width: getBarWidth(geo.size.width),
                            stacking: .standard
                        )
                        .foregroundStyle(year.color)
                        .annotation(position: .overlay, alignment: .center) {
                            //                            Text("Hi")
                        }
                    }
                    .chartYScale(domain: axisMinimum...TemperatureAnomaly.maxAnomaly)
//                    .chartXAxis(showXAxis)
                    //                    .chartYAxis(showYAxis)
                    .chartYAxis {
                        AxisMarks() { value in
                            AxisValueLabel() {
                                if let dblVal = value.as(Double.self) {
                                    Text(String(dblVal))
                                        .opacity(yAxisHidden ? 0 : 1)
//                                        .opacity(showYAxis == .hidden ? 0 : 1)
//                                        .foregroundColor(.green)
//                                        .opacity(showYAxis ? 0 : 1)

                                }
                            }
                        }
                    }
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


