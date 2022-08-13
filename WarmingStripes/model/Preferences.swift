//
//  Preferences.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 11/9/21.
//

import Foundation

struct Preferences: Codable {
    var units: WeightUnit = .pounds
    public static var appTitle = "Fasty McFastface"
    public static var version = "1.0.1"
}

public enum WeightUnit: String, CaseIterable, Identifiable, Codable {
    case pounds = "Pounds"
    case kilograms = "Kilograms"
    public var id: WeightUnit { self }
    public var abbreviation: String {
        if self == .pounds {
            return "lb"
        } else {
            return "kg"
        }
    }
}
