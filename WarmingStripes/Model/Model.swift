//
//  Model.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/22/22.
//

import SwiftUI

public enum ChartState: String, CaseIterable, Identifiable, Codable {
    case stripes = "Warming Stripes"
    case labelledStripes = "Labeled Stripes"
    case bars = "Bars"
    case barsWithScale = "Bars with Scale"
    public var id: ChartState { self }
}

public enum TemperatureScale: String, CaseIterable, Identifiable, Codable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    public var id: TemperatureScale { self }
    public var abbreviation: String {
        self == .celsius ? "°C" : "°F"
    }
    public static func cToF(_ celcius: Double) -> Double {
        celcius * 9/5
    }
}

struct TemperatureAnomaly: Identifiable, Equatable {
    let date: Date
    let anomaly: Double 
    var id = UUID()
}

class Model: ObservableObject {
    @AppStorage("chartState") var chartState: ChartState = .stripes
    @AppStorage("temperatureScale") var temperatureScale: TemperatureScale = .celsius {
        didSet {
            loadData()
        }
    }

    init(csvFileName: String, bundle: Bundle? = nil) {
        self.csvFileName = csvFileName
        self.bundle = bundle ?? Bundle(for: type(of: self))
        loadData()
    }

    private let bundle: Bundle
    private let csvFileName: String
    static let globalTemperatureAnomalies = "HadCRUT.5.0.1.0.analysis.summary_series.global.annual"

    var anomalies: [TemperatureAnomaly] = []

    var minAnomaly: Double {
        anomalies.min(by: { $0.anomaly < $1.anomaly })?.anomaly ?? 0
    }
    var maxAnomaly: Double {
        anomalies.max(by: { $0.anomaly < $1.anomaly })?.anomaly ?? 0
    }

    var startDate: Date {
        anomalies.min(by: { $0.date < $1.date })?.date ?? .now
    }
    var endDate: Date {
        anomalies.max(by: { $0.date < $1.date })?.date ?? .now
    }

    //if data sets are loaded from the internet, you'd want to convert the values to Fahrenheit rather than reload, but since it's in the bundle, this is the simplest
    private func loadData() {
        var anomalies: [TemperatureAnomaly] = []
        if let filepath = bundle.path(forResource: csvFileName, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), var tempDiff = Double(values[1]) {
                        if temperatureScale == .fahrenheit {
                            tempDiff = TemperatureScale.cToF(tempDiff)
                        }
                        let date = Date(year: year, month: 1, day: 1)
                        anomalies.append(TemperatureAnomaly(date: date, anomaly: tempDiff))
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
