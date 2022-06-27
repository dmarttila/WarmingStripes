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

    @State private var dateMinimum: Double = 0

    // environment object doesn't work in previews
    //    @EnvironmentObject var model: Model
//    let model = Model()
    @State var showOtherMarks: Bool = false
    @State var anomalies: [TemperatureAnomaly]
    init() {
        //        let model = Model()
        anomalies = Model().anomalies

    }
    /*
     let results = someArray.filter { ($0["dateEnd"] ?? "") > nowString }
     */

    var body: some View {
        VStack {
            Button("Filter stuff") {
                anomalies = anomalies.filter {
                    ($0.anomaly>0)
                }
            }
            Slider(value: $dateMinimum, in: 1850...2022)
            Text("\(Int(dateMinimum))")
            Toggle("Show other marks", isOn: $showOtherMarks)
            Chart (anomalies) { year in
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


