//
//  ChartRolloverView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/30/23.
//

import SwiftUI

struct ChartRolloverView: View {
    let temperatureAnomaly: TemperatureAnomaly?
    let temperatureAbbreviation: String
    let rolloverViewWidth: CGFloat
    private let rolloverBackground = Color(hex: 0x5B5B60)
    var rolloverText: String {
        guard let temperatureAnomaly else { return "" }
        var str = "Year: \(temperatureAnomaly.date.yearString)\n"
        str +=  "Anomaly: \(temperatureAnomaly.anomaly.decimalFormat)"
        str += temperatureAbbreviation
        return str
    }

    var body: some View {
        Text(rolloverText)
            .frame(minWidth: rolloverViewWidth, alignment: .leading)
            .padding(3)
            .background(rolloverBackground)
            .cornerRadius(5)
    }
}
