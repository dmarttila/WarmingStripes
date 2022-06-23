//
//  Model.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/22/22.
//

import Foundation

final class Model: ObservableObject{
    @Published var anomalies: [TemperatureAnomaly] = []

    private let fileName = "HadCRUT.5.0.1.0.summary_series.global.annual"

    func loadData () ->  [TemperatureAnomaly] {
        var anomalies: [TemperatureAnomaly] = []
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), let tempDiff = Double(values[1]) {
                        anomalies.append(TemperatureAnomaly(year: year, anomaly: tempDiff))
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

struct TemperatureAnomaly {
    //TODO: Change to dates rather than int
    let year: Int
    let anomaly: Double
}
