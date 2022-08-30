//
//  DateExtensions.swift
//  WarmingStripes
//
//  Created by Doug Marttila on /3/21.
//

import Foundation

public extension Date {
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

    func setTime (hour: Int, minute: Int, second: Int = 0) -> Date{
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)

        components.hour = hour
        components.minute = minute
        components.second = second

        return cal.date(from: components)!
    }

    
    static let dayInSeconds: Double = 86_400
    
    func getCopyright (startYear: Int) -> String {
        let str = "© "
        let year = Calendar.current.component(.year, from: Date())
        if startYear == year {
            return str + String(year)
        } else {
            return str + String(startYear) + " - " + String(year)
        }
    }
}


