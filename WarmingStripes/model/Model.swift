//
//  Model.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/22/22.
//

import Foundation
import SwiftUI

final class Model: ObservableObject{
    @Published var anomalies: [TemperatureAnomaly] = []

    private let fileName = "HadCRUT.5.0.1.0.summary_series.global.annual"

    var maxAnomaly: Double = 0
    var minAnomaly: Double = 0

    func loadData () ->  [TemperatureAnomaly] {
        var anomalies: [TemperatureAnomaly] = []
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), let tempDiff = Double(values[1]) {
                        anomalies.append(TemperatureAnomaly(year: year - 1849, anomaly: tempDiff))
                        TemperatureAnomaly.minAnomaly = min(TemperatureAnomaly.minAnomaly, tempDiff)
                        TemperatureAnomaly.maxAnomaly = max(TemperatureAnomaly.maxAnomaly, tempDiff)
                    }
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        return anomalies
    }

    init () {
        anomalies = loadData()

    }
}

struct TemperatureAnomaly: Identifiable {

    static var maxAnomaly: Double = 0
    static var minAnomaly: Double = 0

    //TODO: Change to dates rather than int
    var color: Color {
//        anomaly > 0 ? .red : .blue
        if anomaly > 0 {
            return Color(red: anomaly/TemperatureAnomaly.maxAnomaly, green: 0, blue: 0)
        }
        return Color(red:0, green: 0, blue: anomaly/TemperatureAnomaly.minAnomaly)
        //let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    }
    let year: Int
    let anomaly: Double
    var id = UUID()
}
