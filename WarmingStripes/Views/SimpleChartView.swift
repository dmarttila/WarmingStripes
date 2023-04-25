//
//  SimpleChartView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/23/23.
//

import Charts
import SwiftUI

struct SimpleChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Default Swift Chart parameters. 10 lines of code.")
            Chart(viewModel.anomalies) { anomaly in
                BarMark(
                    x: .value("Date", anomaly.date, unit: .year),
                    y: .value("Anomaly", anomaly.anomaly)
                )
                .foregroundStyle(viewModel.getBarColor(anomaly))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
    }
}
