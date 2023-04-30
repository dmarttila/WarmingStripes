//
//  ChartView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import Charts
import SwiftUI

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Chart state:", selection: $viewModel.chartState) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if viewModel.drawTitleAboveChart {
                Text(viewModel.titleText)
                    .font(.title2)
            }
            HStack {
                if viewModel.drawLeadingAndTrailingYears {
                    Text(viewModel.startYear)
                }
                ChartPlotView(viewModel: viewModel)
                // year at the right side of the chart for bars state
                if viewModel.drawLeadingAndTrailingYears {
                    Text(viewModel.endYear)
                }
            }
            // if the xAxis is drawn, create space for it
            Spacer()
                .frame(height: viewModel.spaceForXAxis)
        }
    }
}
