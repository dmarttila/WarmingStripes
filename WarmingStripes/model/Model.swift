//
//  Model.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/22/22.
//

import Foundation
import SwiftUI

public class Preferences: ObservableObject {
//    @AppStorage("units") var units: TemperatureUnit = .celsius
//    var chartState: ChartState = .stripes
//    @AppStorage("chartState") var chartState: ChartState = .stripes
//    static var appTitle = "Warming Stripes"
//    static var version: String {
//        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
//    }
}

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

func colorForValue(value: Float, color1: UIColor, color2: UIColor) -> UIColor {
    let clampedValue = max(-1, min(value, 1)) // clamp the value to the range of -1 to 1
    let red1 = CGFloat(CIColor(color: color1).red)
    let green1 = CGFloat(CIColor(color: color1).green)
    let blue1 = CGFloat(CIColor(color: color1).blue)
    let alpha1 = CGFloat(CIColor(color: color1).alpha)
    let red2 = CGFloat(CIColor(color: color2).red)
    let green2 = CGFloat(CIColor(color: color2).green)
    let blue2 = CGFloat(CIColor(color: color2).blue)
    let alpha2 = CGFloat(CIColor(color: color2).alpha)
    let red = (1 - CGFloat(clampedValue)) * red1 + CGFloat(clampedValue) * red2
    let green = (1 - CGFloat(clampedValue)) * green1 + CGFloat(clampedValue) * green2
    let blue = (1 - CGFloat(clampedValue)) * blue1 + CGFloat(clampedValue) * blue2
    let alpha = (1 - CGFloat(clampedValue)) * alpha1 + CGFloat(clampedValue) * alpha2
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
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

        return Color(red: val, green: val, blue: 1)
    }
    
    var colorAgain: Color {
        let color = UIColor.blue // the color you want to adjust the brightness of
        let brightnessOffset: CGFloat = 0 // the amount you want to adjust the brightness by

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        // Get the hue, saturation, brightness, and alpha components of the original color
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        // Adjust the brightness component by adding the offset
        brightness = max(min(brightness + brightnessOffset, 1.0), 0.0)

        // Create a new color with the adjusted brightness
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)

        return Color(newColor)
    }

    var color2: Color {
//        if anomaly > 0 {
//            let val = 1 - anomaly/TemperatureAnomaly.maxAnomaly
//            return Color(red: 1, green: val, blue: val)
//        }
//        let val = 1 - anomaly/TemperatureAnomaly.minAnomaly
//        return Color(red: val, green: val, blue: 1)
        
        var value: Double
       
        let myRed = Color(hex: 0x67090D)
        let myBlue = Color(hex: 0x0A2F6B)
        if anomaly > 0 {
//            value = anomaly/TemperatureAnomaly.maxAnomaly
            let color1 = UIColor.white
            let color2 = UIColor(myRed)
            let color = colorForValue(value: Float(anomaly), color1: color1, color2: color2)
            return Color(color)
            
        } else {
            let color1 = UIColor.white
            let color2 = UIColor(myBlue)
            let color = colorForValue(value: Float(anomaly * -1), color1: color1, color2: color2)
            return Color(color)
//            value = anomaly/TemperatureAnomaly.minAnomaly
        }
//        let diff = TemperatureAnomaly.maxAnomaly - TemperatureAnomaly.minAnomaly
//        value = anomaly/diff        
//        value = -1
//        value = 0//anoma
//        value = (value + 1) / 2
//        value = .5
//        print(anomaly)
//        let color1 = UIColor.blue
//        let color2 = UIColor.white
//        let color3 = UIColor.red
////        let value = 0.5
//        let color = colorForValue(value: Float(anomaly), color1: color1, color2: color2)
//        //let color = colorForValue(value: Float(value), color1: color1, color2: color2)
//        return Color(color)
    }
    
    
}

//TODO: Store in AppStorage
class Model: ObservableObject {
    
    @AppStorage("chartState") var chartState: ChartState = .stripes
    
    @AppStorage("units") var temperatureScale: TemperatureScale = .celsius
    
    
    
//    @AppStorage("chartState") var chartState: ChartState = .stripes
    
//    @AppStorage("preferences") var preferences: Preferences = Preferences()
//        didSet {
//            loadData()
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(preferences) {
//                UserDefaults.standard.set(encoded, forKey: "Preferences")
//            }
//        }
//    }
    @Published var preferences = Preferences() {
        didSet {
            loadData()
////            let encoder = JSONEncoder()
////            if let encoded = try? encoder.encode(preferences) {
////                UserDefaults.standard.set(encoded, forKey: "Preferences")
////            }
        }
    }
    init() {
//        if let preferences = UserDefaults.standard.data(forKey: "Preferences") {
//            let decoder = JSONDecoder()
//            if let preferences = try? decoder.decode(Preferences.self, from: preferences) {
//                self.preferences = preferences
//            }
//        }
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
                        if temperatureScale == .fahrenheit {
                            tempDiff = TemperatureScale.cToF(tempDiff)
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
