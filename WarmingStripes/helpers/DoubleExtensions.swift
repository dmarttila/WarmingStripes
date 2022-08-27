//
//  DoubleExtensions.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 10/19/21.
//

import Foundation

extension Double {
    var decimalFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
