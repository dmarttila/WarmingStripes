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
    
    init (model: Model) {
        viewModel = ChartViewModel(model: model)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Chart state:", selection: $viewModel.chartState) {
                ForEach(ChartState.allCases) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.chartState, perform: viewModel.handleChartStateChange)
            
            if viewModel.chartState == .labelledStripes {
                Text(viewModel.titleText)
                    .font(.title2)
            }
            HStack {
                if viewModel.chartState == .bars {
                    Text(viewModel.getYear(from: viewModel.startDate))
                }
                GeometryReader { geo in
                    Chart(viewModel.anomalies) { year in
                        BarMark(
                            x: .value("Date", year.date, unit: .year),
                            y: .value("Anomaly", viewModel.chartState == .stripes || viewModel.chartState == .labelledStripes ? 
                                      TemperatureAnomaly.maxAnomaly : year.anomaly),
                            width: viewModel.getBarWidth(geo.size.width)
                        )
                        .foregroundStyle(year.color)
                        // without corner radius == 0, looks like a picket fence
                        .cornerRadius(0)
                        
                        // you can't style the chart axes to replicate the warming stripes axes, so draw them
                        if viewModel.isBarsWithScale {
                            // Draw the lines that frame the chart
                            //x-axis line
                            RuleMark(
                                xStart: .value("start date", viewModel.startDate),
                                xEnd: .value("end date", viewModel.endDate),
                                y: .value("x axis", viewModel.axisMinimum)
                            )
                            .foregroundStyle(.white)
                            .lineStyle(StrokeStyle(lineWidth: 1))
                            .offset(y: -25)
                            //y-axis line
                            RuleMark(
                                x: .value("y axis", viewModel.startDate),
                                yStart: .value("lowest temperature", viewModel.yAxisMinMax * -1),
                                yEnd: .value("highest temperature", viewModel.yAxisMinMax)
                            )
                            .foregroundStyle(.white)
                            .lineStyle(StrokeStyle(lineWidth: 1))
                        }
                    }
                    // x-axis 
                    .chartOverlay { proxy in
                        GeometryReader { proxyGeo in
                            if viewModel.isBarsWithScale || viewModel.chartState == .bars {
                                VStack(alignment: .leading) {
                                    Text(viewModel.titleText)
                                        .font(.title2)
                                    if viewModel.isBarsWithScale {
                                        Text("Relative to average of 1971-2000 [°\(viewModel.displayInCelcius ? "C" : "F")]")
                                            .font(.subheadline)
                                    }
                                }
                                // aligns the title with the yAxis
                                .offset(x: proxyGeo[proxy.plotAreaFrame].origin.x)
                                .padding(5)
                            }
                            if viewModel.isBarsWithScale || viewModel.chartState == .labelledStripes {
                                // create an area under the chart to draw the x-axis
                                let axisYLoc = proxyGeo.size.height - 20
                                if viewModel.chartState == .labelledStripes {
                                    Rectangle()
                                        .fill(.black)
                                        .frame(width: geo.size.width + 2, height: 50)
                                        .offset(x: -1, y: axisYLoc - 5)
                                }
                                ForEach(viewModel.xAxisYears, id: \.self) { year in
                                    let textFrameWidth: CGFloat = 300
                                    let axisXloc = viewModel.getYearXLoc(year: year, proxy: proxy, geo: proxyGeo)
                                    Text(String(year))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(width: textFrameWidth)
                                        .offset(x: axisXloc - textFrameWidth/2, y: axisYLoc)
                                    if viewModel.isBarsWithScale {
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: 1, height: 5)
                                            .offset(x: axisXloc, y: axisYLoc - 5)
                                    }
                                }
                            }
                        }
                    }
                    .chartYScale(domain: viewModel.axisMinimum...TemperatureAnomaly.maxAnomaly)
                    // xAxis is drawn above, so it's always hidden
                    .chartXAxis(.hidden)
                    // hide/show the Y axes
                    .chartYAxis(viewModel.isBarsWithScale ? .visible : .hidden)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: viewModel.yAxisValues) {value in
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
                if viewModel.chartState == .bars {
                    Text(viewModel.getYear(from: viewModel.endDate))
                }
            }
        }
    }
}
