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

            if viewModel.drawTitleAboveChart {
                Text(viewModel.titleText)
                    .font(.title2)
            }
            HStack {
                if viewModel.drawLeadingAndTrailingYears {
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
                                yStart: .value("y-axis minimum", viewModel.yAxisLabelRange * -1),
                                yEnd: .value("y-axis maximum", viewModel.yAxisLabelRange)
                            )
                            .foregroundStyle(.white)
                            .lineStyle(StrokeStyle(lineWidth: viewModel.axisLineWidth))
                        }
                    }
                    .chartYScale(domain: viewModel.yAxisMinimum...viewModel.yAxisMaximum)
                    // xAxis is drawn below, so it's always hidden
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
                                AxisTick(stroke: StrokeStyle(lineWidth: viewModel.axisLineWidth))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    // x-axis
                    .chartOverlay { chartProxy in
                        if viewModel.drawXAxis {
                            GeometryReader { geoProxy in
                                //let axisYLoc = viewModel.getYLoc(chartProxy: chartProxy, geo: geoProxy)
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
                                    let axisXloc = viewModel.getYearXLoc(year: year, chartProxy: chartProxy, geo: geoProxy)
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
                                            .offset(x: axisXloc, y: axisYLoc - 5)
                                    }
                                }
                            }
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
                }
                // year at the right side of the chart for bars state
                if viewModel.drawLeadingAndTrailingYears {
                    Text(viewModel.endYear)
                }
            }
        }
    }
}
