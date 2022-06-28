//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/21/22.
//

/*TODO:
 Keep or remove @envirnment
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

    // environment object doesn't work in previews
    //    @EnvironmentObject var model: Model
//    let model = Model()
    @State var showOtherMarks: Bool = false
    @State var anomalies: [TemperatureAnomaly]

    var filteredAnomalies: [TemperatureAnomaly] {
        let d = Date(year: Int(dateMinimum), month: 1, day: 1)
        return anomalies.filter {
//            ($0.anomaly>maxAnomaly)
            ($0.date > d)
        }
    }

    init() {
        //        let model = Model()
        anomalies = Model().anomalies

    }
    /*
     let results = someArray.filter { ($0["dateEnd"] ?? "") > nowString }
     */

    var body: some View {
        VStack {
            Slider(value: $dateMinimum, in: 1850...2022, step: 1)
            Slider(value: $maxAnomaly, in: -2...2)
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

            //                    .foregroundStyle(<#T##style: ShapeStyle##ShapeStyle#>)
            //                    .foregroundStyle(by: .value("Shape Color", shape.color))
        }
        //            .chartForegroundStyleScale([
        //                "Green": .green, "Purple": .purple, "Pink": .pink, "Yellow": .yellow
        //            ])
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


