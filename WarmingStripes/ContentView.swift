//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/21/22.
//

import SwiftUI
import Charts

struct ContentView: View {
// environment object doesn't work in previews
//    @EnvironmentObject var model: Model
let model = Model()

    init() {
        //        let model = Model()
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Chart (model.anomalies) { year in
                BarMark(
                    x: .value("Shape Type", year.year),
                    y: .value("Total Count", year.anomaly)
                )
                .foregroundStyle(year.color)
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


