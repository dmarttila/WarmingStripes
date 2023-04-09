//
//  Model.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/22/22.
//

import Foundation
import SwiftUI

public struct Preferences: Codable {
    var units: TemperatureUnit = .celsius
    var chartState: ChartState = .stripes
    static var appTitle = "Warming Stripes"
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
}

public enum ChartState: String,  CaseIterable, Identifiable, Codable {
    case stripes = "Warming Stripes"
    case labelledStripes = "Labeled Stripes"
    case bars = "Bars"
    case barsWithScale = "Bars with Scale"
    public var id: ChartState { self }
}

public enum TemperatureUnit: String, CaseIterable, Identifiable, Codable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    public var id: TemperatureUnit { self }
    public var abbreviation: String {
        if self == .celsius {
            return "°C"
        } else {
            return "°F"
        }
    }
    public static func cToF(_ celcius: Double) -> Double {
        celcius * 9/5
    }
}

struct TemperatureAnomaly: Identifiable {
    static var maxAnomaly: Double = 0
    static var minAnomaly: Double = 0
    static var delta: Double {
        maxAnomaly - minAnomaly
    }
    static var changedMoreThan: String {
        delta.floorDecimalFormat
    }
    
    let date: Date
    let anomaly: Double
    
    var id = UUID()
    
    var color: Color {
        if anomaly > 0 {
            let val = 1 - anomaly/TemperatureAnomaly.maxAnomaly
            return Color(red: 1, green: val, blue: val)
        }
        let val = 1 - anomaly/TemperatureAnomaly.minAnomaly
        return Color(red:val, green: val, blue: 1)
    }
}

//TODO: Store in AppStorage
class Model: ObservableObject{
    @Published var preferences = Preferences() {
        didSet {
            loadData()
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(preferences) {
                UserDefaults.standard.set(encoded, forKey: "Preferences")
            }
        }
    }
    init() {
        if let preferences = UserDefaults.standard.data(forKey: "Preferences") {
            let decoder = JSONDecoder()
            if let preferences = try? decoder.decode(Preferences.self, from: preferences) {
                self.preferences = preferences
            }
        }
        loadData()
    }
    
    var anomalies: [TemperatureAnomaly] = []
    //    HadCRUT.5.0.1.0.analysis.summary_series.global.annual
    private let fileName = "HadCRUT.5.0.1.0.analysis.summary_series.global.annual"
    //"HadCRUT.5.0.1.0.summary_series.global.annual_non_infilled"
    
    private func loadData() {
        var anomalies: [TemperatureAnomaly] = []
        TemperatureAnomaly.minAnomaly = 0
        TemperatureAnomaly.maxAnomaly = 0
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), var tempDiff = Double(values[1]) {
                        if preferences.units == .fahrenheit {
                            tempDiff = TemperatureUnit.cToF(tempDiff)
                        }
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
        self.anomalies = anomalies
    }
}
