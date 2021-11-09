//
//  Date+Extension.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation


extension Date {
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        //Return Result
        return isGreater
    }
    
    func isGreaterThanOrEqualToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending || self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isGreater = true
        }
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        //Return Result
        return isLess
    }
    
    func isLessThanOrEqualToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending || self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isLess = true
        }
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        //Return Result
        return isEqualTo
    }
    
    func endOfMonth() -> Date? {
        let calendar = NSCalendar.current
        if let plusOneMonthDate = calendar.date(byAdding: .month, value: 1, to: self) {
            let plusOneMonthDateComponents = calendar.dateComponents([.month,
                                                                      .year], from: plusOneMonthDate)
            let endOfMonth = (calendar.date(from: plusOneMonthDateComponents))?.addingTimeInterval(-1)
            return endOfMonth
        }
        return nil
    }
    
    func getDateWith(Seconds second: Int) -> Date {
        var dateComponent = Calendar.current.dateComponents([Calendar.Component.day,
                                                             Calendar.Component.month,
                                                             Calendar.Component.year,
                                                             Calendar.Component.hour,
                                                             Calendar.Component.minute,
                                                             Calendar.Component.second], from: self)
        dateComponent.second = 0
        return Calendar.current.date(from: dateComponent)!
    }
    
    func dateWithTimeFromDate(_ secondDate:Date) -> Date {
        let secondDateComponent: DateComponents = NSCalendar.current.dateComponents([.hour, .minute], from: secondDate)
        var selfDateComponent: DateComponents = NSCalendar.current.dateComponents([.day,
                                                                                   .month,
                                                                                   .year,
                                                                                   .hour,
                                                                                   .minute], from: self)
        selfDateComponent.hour = secondDateComponent.hour
        selfDateComponent.minute  = secondDateComponent.minute
        return NSCalendar.current.date(from: selfDateComponent)!
    }
    
    func dateWith(Hour hour: Int, AndMinutes minutes: Int) -> Date{
        var selfDateComponent: DateComponents = NSCalendar.current.dateComponents([.day,.month,.year], from: self)
        selfDateComponent.hour = hour
        selfDateComponent.minute = minutes
        return NSCalendar.current.date(from: selfDateComponent)!
    }
    
    func isToday() -> Bool {
        let dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: self)
        let currentDateComponents = self.getCurrentDateComponents()
        if dateComponents.day == currentDateComponents.day && dateComponents.month == currentDateComponents.month && currentDateComponents.year == dateComponents.year{
            return true
        } else {
            return false
        }
    }
    
    func getDateInString(withFormat format:String) -> String {
        var strConvertedDate: String = ""
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = format
        strConvertedDate = dateFormat.string(from: self)
        return strConvertedDate
    }
    
    func convertDateInString(withDateFormat format:String, withConvertedDateFormat convertDate:String) -> String {
        var strConvertedDate: String = ""
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = format
        strConvertedDate = dateFormat.string(from: self)
        let convertedDate: Date = dateFormat.date(from: strConvertedDate)!;
        dateFormat.dateFormat = convertDate
        strConvertedDate = dateFormat.string(from: convertedDate);
        return strConvertedDate
    }
    
    var presentableDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.dateFormat = "EEE, MMM dd, h:mm a"
        return dateFormatter.string(from: self)
    }
    
    func isTimeGretherThanCurrentTime() -> Bool {
        let dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: self)
        let currentDateComponents = self.getCurrentDateComponents()
        if currentDateComponents.hour! > dateComponents.hour!{
            return true
        } else if currentDateComponents.hour == dateComponents.hour {
            if currentDateComponents.minute! >= dateComponents.minute!{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getCurrentDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: Date())
    }
    
    func findNext(DayDate day: String) -> Date {
        var calendar = NSCalendar.current
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        calendar.locale = Locale.current
        guard let indexOfDay = calendar.weekdaySymbols.index(of: day) else {
            assertionFailure("Failed to identify day")
            return self
        }
        let weekDay = indexOfDay + 1
        let components = calendar.component(.weekday, from: self)
        if components == weekDay {
            return self
        }
        var matchingComponents = DateComponents()
        matchingComponents.weekday = weekDay // Monday
        let comingMonday = calendar.nextDate(after: self, matching: matchingComponents, matchingPolicy: Calendar.MatchingPolicy.nextTime)  //calendar.nextDate(After
        if let nextDate = comingMonday{
            return nextDate.dateWithTimeFromDate(self)
        } else {
            assertionFailure("Failed to find next day")
            return self
        }
    }
    
}
