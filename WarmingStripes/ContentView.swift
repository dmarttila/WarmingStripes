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
    // environment object doesn't work in previews
    //    @EnvironmentObject var model: Model
    let model = Model()
    @State var showOtherMarks: Bool = false
    init() {
        //        let model = Model()
    }

    var body: some View {
        VStack {
           Toggle("Show other marts", isOn: $showOtherMarks)
            Chart (model.anomalies) { year in
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


