//
//  DateExtensions.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/25/22.
//

import Foundation

extension Date {
    init (year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.hour = 12
        components.minute = 0
        components.month = month
        components.day = day
        components.year = year
        self = Calendar.current.date(from: components)!
    }
    init (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        self = Calendar.current.date(from: components)!
    }
}
