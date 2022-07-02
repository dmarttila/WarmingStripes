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

//public enum WeightUnit: String, CaseIterable, Identifiable, Codable {
//    case pounds = "Pounds"
//    case kilograms = "Kilograms"
//    public var id: WeightUnit { self }
//    public var abbreviation: String {
//        if self == .pounds {
//            return "lb"
//        } else {
//            return "kg"
//        }
//    }
//}

enum ChartState: String,  CaseIterable, Identifiable{
    case stripes = "Warming Stripes"
    case labelledStripes = "Labelled Stripes"
    case bars = "Bars"
    case barsWithScale = "Bars with Scale"
    public var id: ChartState { self }
}

struct ContentView: View {

//    @State private var dateMinimum: Double = 1850

    @State private var chartState = ChartState.stripes
    @State private var dateFilterMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    @State private var dateFilterMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate

    let dateMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    let dateMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate

    @State var showOtherMarks = false
    @State var showAxes = true
//    @State var showAxes = true
    let anomalies: [TemperatureAnomaly]

//    var minDisplayDate

    var filteredAnomalies: [TemperatureAnomaly] {
//        let d = Date(year: Int(dateMinimum), month: 1, day: 1)
        let min = Date(timeIntervalSinceReferenceDate: dateFilterMin)
        let max = Date(timeIntervalSinceReferenceDate: dateFilterMax)
        return anomalies.filter {
            ($0.date >= min && $0.date <= max)
        }
    }

    init() {
        anomalies = Model().anomalies
    }


    var body: some View {
        VStack {
            Picker("Units:", selection: $chartState) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
    //        .listRowBackground(Color.lightestClr)
    //        .onChange(of: units, perform: thePickerHasChanged)
            HStack {
                Text(dateFilterMin.asDate.monthDateYear)
                Text(" - ")
                Text(dateFilterMax.asDate.monthDateYear)
            }
            GeometryReader { geo in
                ZStack (alignment: .leading){
                    Slider(value: $dateFilterMin, in: dateMin...dateFilterMax)
                        .frame(width: geo.size.width * (dateFilterMax - dateMin) / (dateMax - dateMin))
                    Slider(value: $dateFilterMax, in: dateFilterMin...dateMax)
                        .offset(x: geo.size.width - geo.size.width * (dateMax - dateFilterMin) / (dateMax - dateMin) + 5, y: 0)
                        .frame(width: geo.size.width * (dateMax - dateFilterMin) / (dateMax - dateMin))
                }

            }
            .frame(height: 50)

            Toggle("Show other marks", isOn: $showOtherMarks)
            Toggle("Show axes", isOn: $showAxes)
            Chart (filteredAnomalies) { year in
                BarMark(
                    x: .value("date", year.date, unit: .year),
                    y: .value("Total Count", year.anomaly)
                )
                .foregroundStyle(year.color)

                if showOtherMarks {
                    LineMark(
                        x: .value("date", year.date, unit: .year),
                        y: .value("Total Count", year.anomaly)
                    )
                    AreaMark(
                        x: .value("date", year.date, unit: .year),
                        y: .value("Total Count", year.anomaly)
                    )
                    .foregroundStyle(year.color)
                    RectangleMark (
                        x: .value("date", year.date, unit: .year),
                        y: .value("Total Count", year.anomaly)
                    )
                    .foregroundStyle(year.color)
                }
            }
            .chartYScale(domain: TemperatureAnomaly.minAnomaly...TemperatureAnomaly.maxAnomaly)
//            .chartYAxis {
//                AxisMarks(values: .stride(by: .month))
//            }
            .chartXAxis(showAxes ? .visible : .hidden)
            .chartYAxis(showAxes ? .visible : .hidden)
//            .chartForegroundStyleScale(type: )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


