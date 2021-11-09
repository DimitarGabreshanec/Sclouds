//
//  TimeZoneConstant.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 11/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

extension Date{
    
    func getElapsedInterval() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //formatter.timeZone = TimeZone(identifier:"GMT")
        let stringDate = formatter.string(from: Date())
        print(stringDate)
        guard let date =  formatter.date(from: stringDate) else {return ""}
        print(date)
        let calender = Calendar.current
       
        
        var interval1 = calender.dateComponents([.year], from: self, to: date)
        var interval = interval1.year ?? 0
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year ago" :
                "\(interval) " + " " + "years ago"
        }
        
        interval1 = calender.dateComponents([.month], from: self, to: date)
        interval = interval1.month ?? 0
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + "" + "month ago" :
                "\(interval)" + "" + "months ago"
        }
        interval1 = calender.dateComponents([.day], from: self, to: date)
        interval = interval1.day ?? 0
        
        if interval > 0 {
            if interval == 1 {
                return "Yesterday"
            }
            return interval == 1 ? "\(interval)" + " " + "day ago" :"\(interval)" + " " + "days ago"
        }
        
        interval1 = calender.dateComponents([.hour], from: self, to: date)
        interval = interval1.hour ?? 0
        
        if interval > 0 {
            return interval == 1 ? "\(interval) " + " " + "hour ago" :
                "\(interval)" + " " + "hours ago"
        }
        
        interval1 = calender.dateComponents([.minute], from: self, to: date)
        interval = interval1.minute ?? 0
        
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "" + "min ago" :
                "\(interval) " + "" + "mins ago"
        }
        return "Just now"
    }

    
    func getElapsedIntervalTimeOnly1() -> Int16 {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       
        let stringDate = formatter.string(from: Date())
        
        guard let date =  formatter.date(from: stringDate) else {return 0}
        
        let calender = Calendar.current
       
        var interval1 = calender.dateComponents([.year], from: self, to: date)
        var interval = interval1.year ?? 0
        
        if interval > 0 {
            return Int16(interval)
        }
        
        interval1 = calender.dateComponents([.month], from: self, to: date)
        interval = interval1.month ?? 0
        
        if interval > 0 {
            return Int16(interval)
        }
        interval1 = calender.dateComponents([.day], from: self, to: date)
        interval = interval1.day ?? 0
        
        if interval > 0 {
            return Int16(interval)
        }
        
        interval1 = calender.dateComponents([.hour], from: self, to: date)
        interval = interval1.hour ?? 0
        
        if interval > 0 {
           return Int16(interval*60)
        }
        
        interval1 = calender.dateComponents([.minute], from: self, to: date)
        interval = interval1.minute ?? 0
        
        if interval > 0 {
            return Int16(interval*60)
        }
        return 0
    }
    
    
    func getElapsedIntervalTimeOnly() -> Double {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       
        let stringDate = formatter.string(from: Date())
        
        guard let date =  formatter.date(from: stringDate) else {return 0}
        
        let calender = Calendar.current
       
        var interval1 = calender.dateComponents([.year], from: self, to: date)
        var interval = interval1.year ?? 0
        
        if interval > 0 {
            return Double(interval*365*24*60)
        }
        
        interval1 = calender.dateComponents([.month], from: self, to: date)
        interval = interval1.month ?? 0
        
        if interval > 0 {
            return Double(interval*30*24*60)
        }
        interval1 = calender.dateComponents([.day], from: self, to: date)
        interval = interval1.day ?? 0
        
        if interval > 0 {
            return Double(interval*24*60)
        }
        
        interval1 = calender.dateComponents([.hour], from: self, to: date)
        interval = interval1.hour ?? 0
        
        if interval > 0 {
           return Double(interval*60)
        }
        
        interval1 = calender.dateComponents([.minute], from: self, to: date)
        interval = interval1.minute ?? 0
        
        if interval > 0 {
            return Double(interval)
        }
        return 0
    }
}




extension String {
    
    func toIncidentDate()->Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    
}



extension Date {
    
    func toIncidentStr()->String? {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    
    func toIncidentHistorStr()->String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy hh:mm a"
        return formatter.string(from: self)
    }
    
    func toRequestContactStr()->String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: self)
    }
    
    
    func toIncidentTimeStr()->String? {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
}
