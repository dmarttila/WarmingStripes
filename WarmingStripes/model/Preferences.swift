//
//  Preferences.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 11/9/21.
//

import Foundation

struct Preferences: Codable {
    var units: TemperatureUnit = .celsius
    public static var appTitle = "Warming Stripes"
    public static var version = "1.0.0"
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
    public static func cToF (_ c: Double) -> Double {
        c * 9/5 + 32
    }
}

