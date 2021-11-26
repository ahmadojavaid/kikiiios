//
//  DateExtension.swift
//  Opulent
//
//  Created by abbas on 26/07/2019.
//  Copyright © 2019 Ali Bajwa. All rights reserved.
//

internal let DEFAULT_DATE_FORMAT = "MM/dd/yyyy"

import Foundation

extension Date {
    func toString(_ format:String = DEFAULT_DATE_FORMAT) -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        return formater.string(from: self)
    }
    
    func roundDown()-> Date? {
        var cmp = self.components()
        cmp.timeZone = TimeZone.autoupdatingCurrent
        cmp.minute = 0
        cmp.second = 0
        cmp.hour = 0
        return cmp.date
    }
    
    static func setDate(yyyy:Int, MM:Int, dd:Int, hh:Int = 0, mm:Int = 0, ss:Int = 0) -> Date? {
        let cmp = DateComponents(calendar: Calendar.current, timeZone: TimeZone.autoupdatingCurrent, era: nil, year: yyyy, month: MM, day: dd, hour: hh, minute: mm, second: ss, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return cmp.date
    }
    
    func subtract(date:Date) -> (Double, (Int, Int, Double),(Int, Int, Int)){
        let itr = Double(self.timeIntervalSince(date))
        
        let isLargSelf = itr >= 0
        let cmp1 = isLargSelf ? self.components() : date.components()
        let cmp2 = isLargSelf ? date.components() : self.components()
        
        var second = cmp1.second! - cmp2.second!
        var minute = cmp1.minute! - cmp2.minute!
        var hour = cmp1.hour! - cmp2.hour!
        var day = cmp1.day! - cmp2.day!
        var month = cmp1.month! - cmp2.month!
        var year = cmp1.year! - cmp2.year!
        
        if second < 0 {
            minute = minute - 1
            second = 60 + second
        }
        
        if minute < 0 {
            hour = hour - 1
            minute = 60 + minute
        }
        
        if hour < 0 {
            day = day - 1
            hour = 24 + hour
        }
        var day2 = Double(day)
        if day < 0 {
            month = month - 1
            day2 = Double(Date.monthDays(cmp1.month!) + day)/Double(Date.monthDays(cmp1.month!))
        }
        
        if (month < 0) {
            year = year - 1
            month = 12 + month
        }
        return (itr, (year, month, day2),(hour, minute, second))
    }
    
    mutating func setMin(mm:Int = 0) {
        var cmp = self.components()
        cmp.minute = mm
        self = cmp.date!
    }
    mutating func setSec(sec:Int = 0) {
        var cmp = self.components()
        cmp.second = sec
        self = cmp.date!
    }
    mutating func setHour(hh:Int = 0) {
        var cmp = self.components()
        cmp.hour = hh
        self = cmp.date!
    }
    mutating func setYear(yyyy:Int = 0) {
        var cmp = self.components()
        //print("cmp.year:\(cmp.year), \(cmp.yearForWeekOfYear), \(cmp.weekOfYear)")
        cmp.year = yyyy
        //cmp.weekOfYear = yyyy
        cmp.yearForWeekOfYear = yyyy
        self = cmp.date!
        
    }
    mutating func setMonth(MM:Int = 0) {
        var cmp = self.components()
        cmp.month = MM
        self = cmp.date!
    }
    mutating func setDay(dd:Int = 0) {
        var cmp = self.components()
        cmp.day = dd
        self = cmp.date!
    }
    
    func components() -> DateComponents {
        let calendar = Calendar.current
        let cmp = calendar.dateComponents(in: TimeZone.autoupdatingCurrent, from: self)
        return cmp
    }
    
    static func monthDays(_ month:Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 2:
            return 28
        default:
            return 30
        }
    }
    
    func dayOfTheWeek() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let weekday = calendar.component(.weekday, from: self)
        //let components: DateComponents = calendar.dateComponents(.Weekday, from: self)
        return weekdays[weekday - 1]
    }
}

extension String {
    func toDate(_ format:String = DEFAULT_DATE_FORMAT) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = format
        let date: Date? = formater.date(from: self)
        return date
    }
    
    func subString(_ from:Int, _ to:Int)->String {
        let idx1 = self.index(self.startIndex, offsetBy: from)
        let idx2 = self.index(idx1, offsetBy: to+1-from)
        return String(self[idx1..<idx2])
    }
    
    func subString(_ to:Int) ->String {
        return String(self.prefix(to+1))
    }
}
