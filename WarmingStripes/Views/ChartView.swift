//
//  ChartView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import Charts
import SwiftUI

struct ChartView: View, Haptics {
    @ObservedObject var viewModel: ChartViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Chart state:", selection: $viewModel.chartState) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            // Title for Labeled Stripes
            if viewModel.chartState == .labelledStripes {
                Text(viewModel.titleText)
                    .font(.title2)
            }
            HStack {
                // if bars state draw the year to the left of the chart
                if viewModel.chartState == .bars {
                    Text(viewModel.startYear)
                }
                GeometryReader { geo in
                    Chart(viewModel.anomalies) { anomaly in
                        BarMark(
                            x: .value("Date", anomaly.date, unit: .year),
                            y: .value("Anomaly", viewModel.getYValue(anomaly)),
                            width: viewModel.getBarWidth(geo.size.width)
                        )
                        .foregroundStyle(viewModel.getBarColor(anomaly))
                        // without corner radius == 0, looks like a picket fence
                        .cornerRadius(0)
                        // you can't style the chart axes to replicate the warming stripes axes, so there's a lot of custom drawing.
                        if viewModel.drawChartFrame {
                            // Draw the lines that frame the chart
                            // x-axis line
                            RuleMark(
                                xStart: .value("start date", viewModel.startDate),
                                xEnd: .value("end date", viewModel.endDate),
                                y: .value("x axis", viewModel.yAxisMinimum)
                            )
                            .foregroundStyle(.white)
                            .lineStyle(StrokeStyle(lineWidth: viewModel.axisLineWidth))
                            .offset(y: viewModel.xAxisOffset)
                            // y-axis line
                            RuleMark(
                                x: .value("y axis", viewModel.startDate),
                                yStart: .value("lowest temperature anomaly", viewModel.yAxisLabelRange * -1),
                                yEnd: .value("highest temperature anomaly", viewModel.yAxisLabelRange)
                            )
                            .foregroundStyle(.white)
                            .lineStyle(StrokeStyle(lineWidth: viewModel.axisLineWidth))
                        }
                    }
                    // Draws the chart title for bars-with-scale and bars states
                    .chartOverlay { chartProxy in
                        if viewModel.drawTitleOnTopOfChart {
                            GeometryReader { geoProxy in
                                VStack(alignment: .leading) {
                                    Text(viewModel.titleText)
                                        .font(.title2)
                                    Text(viewModel.subTitleText)
                                        .font(.subheadline)
                                }
                                // aligns the title with the yAxis
                                .offset(x: geoProxy[chartProxy.plotAreaFrame].origin.x)
                                .padding(5)
                            }
                        }
                    }
                    // x-axis 
                    .chartOverlay { chartProxy in
                        if viewModel.drawXAxis {
                            GeometryReader { geoProxy in
                                let axisYLoc = geoProxy.size.height - 20
                                if viewModel.chartState == .labelledStripes {
                                    // draw a black rectangle on top of the bottom on the chart to draw the x-axis on. 
                                    Rectangle()
                                        .fill(.black)
                                        .frame(width: geo.size.width + 2, height: 50)
                                        .offset(x: -1, y: axisYLoc - 5)
                                }
                                // the years
                                ForEach(viewModel.xAxisYears, id: \.self) { year in
                                    let textFrameWidth: CGFloat = 300
                                    let axisXloc = viewModel.getYearXLoc(year: year, proxy: chartProxy, geo: geoProxy)
                                    Text(String(year))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(width: textFrameWidth)
                                        .offset(x: axisXloc - textFrameWidth/2, y: axisYLoc)
                                    if viewModel.drawTickMarks {
                                        // draw the tic marks above the years
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: viewModel.axisLineWidth, height: viewModel.tickMarkHeight)
                                            .offset(x: axisXloc, y: viewModel.xAxisOffset)
                                    }
                                }
                            }
                        }
                    }
                    .chartYScale(domain: viewModel.yAxisMinimum...viewModel.yAxisMaximum)
                    // xAxis is drawn above, so it's always hidden
                    .chartXAxis(.hidden)
                    // hide/show the Y axes
                    .chartYAxis(viewModel.yAxisVisible)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: viewModel.yAxisValues) { value in
                            if let doubleValue = value.as(Double.self) {
                                AxisValueLabel {
                                    Text(doubleValue.decimalFormat)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                AxisTick(stroke: StrokeStyle(lineWidth: 1.5))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                // year at the right side of the chart for bars state
                if viewModel.chartState == .bars {
                    Text(viewModel.endYear)
                }
            }
        }
    }
}
