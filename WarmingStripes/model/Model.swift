//
//  Model.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/22/22.
//

import Foundation
import SwiftUI




class Model: ObservableObject{
    @Published var preferences = Preferences() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(preferences) {
                UserDefaults.standard.set(encoded, forKey: "Preferences")
            }
        }
    }
    init () {
        if let preferences = UserDefaults.standard.data(forKey: "Preferences") {
            let decoder = JSONDecoder()
            if let preferences = try? decoder.decode(Preferences.self, from: preferences) {
                self.preferences = preferences
            }
        }
        anomalies = loadData()
    }
    
    var anomalies: [TemperatureAnomaly] = []
    //    HadCRUT.5.0.1.0.analysis.summary_series.global.annual
    private let fileName = "HadCRUT.5.0.1.0.analysis.summary_series.global.annual"
    //"HadCRUT.5.0.1.0.summary_series.global.annual_non_infilled"
    
    private func loadData () ->  [TemperatureAnomaly] {
        var anomalies: [TemperatureAnomaly] = []
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), let tempDiff = Double(values[1]) {
                        let date = Date(year: year, month: 1, day: 1)
                        anomalies.append(TemperatureAnomaly(date: date, anomaly: tempDiff))
                        TemperatureAnomaly.minAnomaly = min(TemperatureAnomaly.minAnomaly, tempDiff)
                        TemperatureAnomaly.maxAnomaly = max(TemperatureAnomaly.maxAnomaly, tempDiff)
                    }
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // file not found!
        }
        return anomalies
    }
    
    
}

struct TemperatureAnomaly: Identifiable {
    static var maxAnomaly: Double = 0
    static var minAnomaly: Double = 0
    
    var color: Color {
        if anomaly > 0 {
            let val = 1 - anomaly/TemperatureAnomaly.maxAnomaly
            return Color(red: 1, green: val, blue: val)
        }
        let val = 1 - anomaly/TemperatureAnomaly.minAnomaly
        return Color(red:val, green: val, blue: 1)
    }
    let date: Date
    let anomaly: Double
    var id = UUID()
}
