//
//  ChartRolloverView.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 4/30/23.
//

import SwiftUI

struct ChartRolloverView: View {
    let temperatureAnomaly: TemperatureAnomaly?
    let rolloverBackground = Color(hex: 0x5B5B60)
    var rolloverText: String {
        if let temperatureAnomaly {
            return temperatureAnomaly.date.yearString + " : " + String(temperatureAnomaly.anomaly.decimalFormat)
        }
        return ""
    }

    var body: some View {
        Text(rolloverText)
            .frame(minWidth: 50, alignment: .center)
            .padding(3)
            .background(rolloverBackground)
            .cornerRadius(5)
    }
}
