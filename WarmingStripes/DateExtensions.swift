//
//  DateExtensions.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 9/3/21.
//

import Foundation

public enum CommonTimeInterval: String, CaseIterable, Identifiable, Codable {
    case day, threeDays, week, month, quarter, year
    
    public var id: CommonTimeInterval { self }
}

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
    func secondsAgo (_ seconds: Int) -> Date {
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.second = components.second! - (seconds)
        return cal.date(from: components)!
    }
    func minutesAgo (_ minutes: Int) -> Date {
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.minute = components.minute! - (minutes)
        return cal.date(from: components)!
    }
    func daysAgo (_ days: Int) -> Date{
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.day = components.day! - days
        return cal.date(from: components)!
    }
    func weeksAgo (_ weeks: Int) -> Date{
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.day = components.day! - (7 * weeks)
        return cal.date(from: components)!
    }
    func monthsAgo (_ months: Int) -> Date{
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.month = components.month! - months
        return cal.date(from: components)!
    }
    func yearsAgo (_ years: Int) -> Date{
        let compSet: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(compSet, from: self)
        components.year = components.year! - years
        return cal.date(from: components)!
    }
    
    
    static let dayInSeconds: Double = 86_400
    
    static func getCommonTimeInterval (_ timeInt : CommonTimeInterval) -> Double {
        let today = Date()
        switch timeInt {
        case .day:
            return dayInSeconds
        case .threeDays:
            return dayInSeconds * 3
        case .week:
            return today - today.weeksAgo(1)
        case .month:
            return today - today.monthsAgo(1)
        case .quarter:
            return today - today.monthsAgo(3)
        case .year:
            return today - today.yearsAgo(1)
        }
    }
    
    static func getClosestCommonTimeInterval (timeInt: TimeInterval) -> CommonTimeInterval {
        switch (true) {
        case timeInt <= getCommonTimeInterval(.day):
            return .day
        case timeInt <= getCommonTimeInterval(.threeDays):
            return .threeDays
        case timeInt <= getCommonTimeInterval(.week):
            return .week
        case timeInt <= getCommonTimeInterval(.month):
            return .month
        case timeInt <= getCommonTimeInterval(.quarter):
            return .quarter
        default:
            return .year
        }
    }
    

    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
    }
    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self)
    }
    
    //determines whether the date sent is the day before the date
    func isPreviousDay (_ date: Date) -> Bool {
        let d1 = self.setTime(hour: 12, minute: 0, second: 0)
        var d2 = date.setTime(hour: 12, minute: 0, second: 0)
        d2 += Date.dayInSeconds
        return d2.monthDateYear == d1.monthDateYear
    }
    
    var dayOfWeek: Int {
        let compSet: Set<Calendar.Component> = [.weekday]
        let cal = Calendar.current
        let components = cal.dateComponents(compSet, from: self)
        return components.weekday!
    }
    
    func isSunday () -> Bool {
        let compSet: Set<Calendar.Component> = [.weekday]
        let cal = Calendar.current
        let components = cal.dateComponents(compSet, from: self)
        return components.weekday == 1
    }
   func isFirstOfMonth () -> Bool {
        let compSet: Set<Calendar.Component> = [.day]
        let cal = Calendar.current
        let components = cal.dateComponents(compSet, from: self)
        return components.day == 1
    }
    func isFirstOfQuarter () -> Bool {
        let compSet: Set<Calendar.Component> = [.day, .month]
        let cal = Calendar.current
        let components = cal.dateComponents(compSet, from: self)
        return components.day == 1 && components.month! % 3 == 1
    }
    func isFirstOfYear () -> Bool {
        let compSet: Set<Calendar.Component> = [.day, .month]
        let cal = Calendar.current
        let components = cal.dateComponents(compSet, from: self)
        return components.day == 1 && components.month == 1
    }
    
    // ------- STRING FORMATTERS BELOW -----------
    /*
    Takes 3600.00 and returns 1:00:00
    Use ceil because Int floors the Double which looks weird when there's less than a second (the timer shows 0 when there's less than 1 second left).
    Include hours like the iOS timer. None if less then an hour. One hour digit if less than 10.
    */
    static let oneHour = 3600
    static func formatSecondsAsCountdown (_ seconds: Double) -> String {
        let hours   = Int(ceil(seconds)) / oneHour
        let minutes = Int(ceil(seconds)) / 60 % 60
        let seconds = Int(ceil(seconds)) % 60
        var str = ""
        if hours > 0 {
            str = "\(hours):"
        }
        str += String(format:"%02i:%02i", minutes, seconds)
        return str
    }
    
    //MARK: TODO should the formatters be static constants? e.g., static let formatter = DateFormmater()? Less would be created
    // but these formatters will be thrown away each time rather than keeping one in memory
    
    //6:58 PM
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    //06:58:01 - Twelve hour clock without AM/PM
    var hourMinuteSeconds: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter.string(from: self)
    }

    //29 Nov
    var dateMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: self)
    }
    
    //Nov 29, 2021
    var monthDateYear: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    //Nov 29
    var monthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    
    //Monday, Nov 29, 2021
    var dayDateMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, Y"
        return formatter.string(from: self)
    }
    
    //Mon, Nov 29
    var shortDayDateMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: self)
    }
        
    //Mon, Nov 29, 2021
    var dayShortDateMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, Y"
        return formatter.string(from: self)
    }

    //Options: Today; Yesterday; or Nov 29
    var todayOrDateMonthShort: String {
        if self.isToday {
            return "Today"
        } else if self.isYesterday {
            return "Yesterday"
            
        }
        return self.dateMonth
    }
    
    //6:40 PM 29 Nov
    var timeDateMonth: String {
        return "\(self.time) \(self.dateMonth)"
    }
  
    //Today, Nov 29
    var todayDateMonth: String {
        if self.isToday {
            return "Today, \(self.dateMonth)"
        } else if self.isYesterday {
            return "Yesterday, \(self.dateMonth)"
            
        }
        return self.dateMonth
    }
    //Today, Monday, Nov 29, 2021
    var todayDayDateMonthYear: String {
        if self.isToday {
            return "Today, \(self.dayDateMonthYear)"
        } else if self.isYesterday {
            return "Yesterday, \(self.dayDateMonthYear)"
            
        }
        return self.dayDateMonthYear
    }
    
    func getCopyright (startYear: Int) -> String {
        let str = "© "
        let year = Calendar.current.component(.year, from: Date())
        if startYear == year {
            return str + String(year)
        } else {
            return str + String(startYear) + " - " + String(year)
        }
    }
    
    //CSV methods...
    
    //yyyy-mm-dd hh:mm:ss
    var csvFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    //yyyy-mm-dd hh:mm:ss
    //lots of checks to make sure the format is correct
    //this will work with months, days, hours, minutes, seconds greater than there regular bounds (e.g., month 13). But, that is how date creation seems to work.
    init? (csvFormat: String) {
        //format is fixed length
        if csvFormat.count != 19 { return nil }
        
        //split into date and time arrays and make sure those split into 3
        let array = csvFormat.components(separatedBy: " ")
        if array.count != 2 { return nil }
        let dateArr = array[0].components(separatedBy: "/")
        if dateArr.count != 3 { return nil }
        let timeArr = array[1].components(separatedBy: ":")
        if timeArr.count != 3 { return nil }
        
        //finally make sure all the values can be cast as Ints
        guard let y = Int(dateArr[0]) else { return nil }
        guard let month = Int(dateArr[1]) else { return nil }
        guard let d = Int(dateArr[2]) else { return nil }
        guard let h = Int(timeArr[0]) else { return nil }
        guard let min = Int(timeArr[1]) else { return nil }
        guard let s = Int(timeArr[2]) else { return nil }
        
        //values check out, create the date
        self.init(year: y, month: month, day: d, hour: h, minute: min, second: s)
    }

}


