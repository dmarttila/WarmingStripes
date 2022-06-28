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

struct ContentView: View {
//    @State private var dateMinimum: Double = 1850

    @State private var dateFilterMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    @State private var dateFilterMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate

    let dateMin = Date(year: 1850, month: 1, day: 1).timeIntervalSinceReferenceDate
    let dateMax = Date(year: 2023, month: 1, day: 1).timeIntervalSinceReferenceDate

    @State var showOtherMarks = false
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
            .chartXAxis(.hidden )
            .chartYAxis(.visible)
//            .chartForegroundStyleScale(type: )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


