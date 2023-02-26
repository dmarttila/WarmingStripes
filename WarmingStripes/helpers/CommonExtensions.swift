//
//  CommonExtensions.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 8/30/22.
//

import Foundation
import SwiftUI

public extension Double {
    // 4.99999 -> 5
    var decimalFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    // 4.99999 -> 4.9
    var floorDecimalFormat: String {
       (floor(self * 10) / 10).decimalFormat
    }
}

public extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

public extension Date {
    init(year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        components.month = month
        components.day = day
        components.year = year
        self = Calendar.current.date(from: components)!
    }
    
    func getCopyright(startYear: Int) -> String {
        let str = "© "
        let year = Calendar.current.component(.year, from: Date())
        if startYear >= year {
            return str + String(year)
        } else {
            return str + String(startYear) + " - " + String(year)
        }
    }
}

