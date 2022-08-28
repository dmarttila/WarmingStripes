//
//  DoubleExtensions.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 10/19/21.
//

import Foundation

extension Double {
    //4.99999 -> 5
    var decimalFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    //4.99999 -> 4.9
    var floorDecimalFormat: String {
        (floor(self * 10) / 10).decimalFormat
    }
}
