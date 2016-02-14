//
//  Calendar.swift
//  Crypto
//
//  Created by Rafael Moris on 29/10/15.
//  Copyright © 2015 Fanatee. All rights reserved.
//

import Foundation

class Calendar {
    class func expireTimeInDays(startDate:NSDate, endDate:NSDate)->Int {
        var fromDate:NSDate?
        var toDate:NSDate?
        
        let calendar = NSCalendar.currentCalendar()
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &fromDate, interval: nil, forDate: startDate)
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &toDate, interval: nil, forDate: endDate)
        
        let dateComponents = calendar.components(NSCalendarUnit.Day, fromDate: fromDate!, toDate: toDate!, options: NSCalendarOptions(rawValue: 0))
        
        return dateComponents.day
    }
    
    class func weekdaysNameFromDate(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    class func timeToExpire()->String {
        let calendar = NSCalendar.currentCalendar()
        var  tomorrow = NSDate().dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * 1))
        tomorrow = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: tomorrow, options: NSCalendarOptions(rawValue: 0))!
        
        let time = tomorrow.timeIntervalSinceNow
        let hours = Int(time / 60 / 60)
        let minutes = Int(time / 60) - (hours * 60)
        let seconds = Int(time) - (minutes * 60) - (hours * 60 * 60)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let date = calendar.dateBySettingHour(hours, minute: minutes, second: seconds, ofDate: tomorrow, options: NSCalendarOptions(rawValue: 0))!
        return dateFormatter.stringFromDate(date)
    }
}