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

    @State private var dateMinimum: Double = 1850

    @State private var maxAnomaly: Double = -2

    @State var showOtherMarks: Bool = false
    var anomalies: [TemperatureAnomaly]

    var filteredAnomalies: [TemperatureAnomaly] {
        let d = Date(year: Int(dateMinimum), month: 1, day: 1)
        return anomalies.filter {
            ($0.date > d)
        }
    }

    init() {
        anomalies = Model().anomalies
    }


    var body: some View {
        VStack {
            Slider(value: $dateMinimum, in: 1850...2022, step: 1)
            Text("\(Int(dateMinimum))")
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
            .chartYScale(domain: TemperatureAnomaly.minAnomaly ... TemperatureAnomaly.maxAnomaly)
//            .chartYScale(domain: -1 ... 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


