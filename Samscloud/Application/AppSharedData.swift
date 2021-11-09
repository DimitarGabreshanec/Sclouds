//
//  AppSharedData.swift
//  UHPeerAttendees
//
//  Created by SachinVani on 5/29/17.
//  Copyright © 2017 Sachin Vani. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SQLite3

class AppSharedData: NSObject, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    private var locationManager = CLLocationManager()
    //var db: OpaquePointer?
    var userLongitude: NSNumber!
    var useraltitude: NSNumber!
    var deviceToken: String!
    var totallikecount: NSNumber!
    var strEventIdComment: NSNumber!
    var isFlagComment: Bool!
    var isFlagEvent: Bool!
    var isFlagMoreSubcribe: Bool!
    var isFlagScreenreload: Bool!
    let eventListDataAttendees: NSDictionary = [:]
    var isFlagPastEvent: Bool!
    var timeZoneCurrent: NSString!
    var commentCount: NSString!
    static var sharedData = SharedData()
    var isCheckIn1: Bool!
    var isCheckIn: Bool!
    
    // MARK: - STRUCT
    
    struct SharedData{
        let imageCache = NSCache<AnyObject, AnyObject>()
    }
    
    static let sharedInstance: AppSharedData! = {
        let instance = AppSharedData()
        return instance
    }()
    
    
    // MARK: - METHODS
    
    func timeZoneData() {
        let currentLocale = TimeZone.current.identifier
        if currentLocale == "Asia/Kolkata" {
            timeZoneCurrent = "Asia/Calcutta"
        } else {
            timeZoneCurrent = currentLocale as NSString
        }
    }
    
    func getViewController(controllerIdentifier: String) -> Any {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: controllerIdentifier)
        return controller
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidAphaNumeric(testStr: String) -> Bool {
        let emailRegEx = "^[a-zA-Z]+$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidAphaNumeric1(testStr: String) -> Bool {
        let emailRegEx = "^[^0-9]"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isCheckIn1 = emailTest.evaluate(with: testStr)
        return emailTest.evaluate(with: testStr)
    }
    
    func dateFormatorOnlyDate(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormator(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "d MMM yyyy', 'HH:mm"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorSome(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "MMM d,yyyy"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorDash(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "dd-MM-yyyy HH:ss"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorMealOffer(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorReview(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorReviewTime1(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "HH:mm"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    func dateFormatorReviewTime(testStr: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: testStr)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.amSymbol = "AM"
        //dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = tempLocale // reset the locale "EEEE, MMMM dd, yyyy' at 'h:mm a."
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    //locationManager
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        userLongitude = userLocation.coordinate.longitude as NSNumber
        useraltitude  = userLocation.coordinate.latitude as NSNumber
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        manager.stopUpdatingLocation()
    }
    
    func formatMinuteSeconds(totalSeconds: Int, withBg bool: Bool) -> String {
        let Dur: NSString
        if bool {
            Dur = ""
        } else {
            Dur = "Dur "
        }
        let hours = Double(totalSeconds) / 60
        let myInt = Int(hours)
        let minute = totalSeconds % 60
        let minutfinal = Int(minute)
        let strdata: NSString
        if myInt == 0 {
            strdata = Dur.appendingFormat("%ld mins", totalSeconds % 60)
        } else {
            if minutfinal >= 0 {
                strdata = Dur.appendingFormat("%ld hrs", Int(totalSeconds) / 60)
            } else {
                strdata = Dur.appendingFormat("%ld hrs ,%ld mins", Int(totalSeconds) / 60 , minutfinal)
            } 
        }
        return strdata as String
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func checkNullValue(strKey:String, dict:[String:Any]) -> Any {
        if (dict[strKey] as? NSNull) != nil {
            print("Null key value:",strKey)
            return ""
        }
        let tempValue : Any? = dict[strKey]
        if tempValue == nil {
            return ""
        }
        return dict[strKey] as Any
    }
    
    func pointCheckGoll(price:String,strLang:String,priceSymbol:String)-> String {
        var valueretur : String = ""
        if strLang == "eng" {
            let containsSwift = price.contains(".")
            if containsSwift == true {
                let arrprice = price.split{$0 == "."}.map(String.init)
                if arrprice[1].count != 0 {
                    let strCount = arrprice[1]
                    if strCount.count == 1 {
                        valueretur =  price + "0 €"
                    } else if strCount.count == 2 {
                        valueretur = price + " €"
                    } else if strCount.count >= 3 {
                        let firstPrice = arrprice[0]
                        let frist2 = strCount.prefix(2)
                        valueretur = firstPrice + "." + frist2 + " €"
                    }
                }
            } else {
                valueretur = price + ".00 €"
            }
        } else {///Language Other
            let containsSwift = price.contains(".")
            if containsSwift == true {
                let arrprice = price.split{$0 == "."}.map(String.init)
                if arrprice[1].count != 0 {
                    let strCount = arrprice[1]
                    if strCount.count == 1 {
                        valueretur = price + "0 €"
                    } else if strCount.count == 2 {
                        valueretur = price + " €"
                    } else if strCount.count >= 3 {
                        let firstPrice = arrprice[0]
                        let frist2 = strCount.prefix(2)
                        valueretur = firstPrice + "." + frist2 + " €"
                    }
                }
            } else {
                valueretur = price + ".00 €"
            }
            valueretur = valueretur.replacingOccurrences(of: ".", with:",")
        }
        return valueretur
    }
    
    func pointCheckGoll(price:String,strLang:String,priceSymbol:String, offerType:String)-> String {
        var valueretur : String = ""
        if strLang == "eng" {
            let containsSwift = price.contains(".")
            if containsSwift == true {
                let arrprice = price.split{$0 == "."}.map(String.init)
                if arrprice[1].count != 0 {
                    let strCount = arrprice[1]
                    if strCount.count == 1 {
                        valueretur =  price + "0 €"
                    } else if strCount.count == 2 {
                        valueretur = price + " €"
                        
                    } else if strCount.count >= 3 {
                    }
                }
            } else {
                valueretur = price + ".00 €"
            }
        } else {///Language Other
            let containsSwift = price.contains(",")
            if containsSwift == true {
                let arrprice = price.split{$0 == ","}.map(String.init)
                if arrprice[1].count != 0 {
                    let strCount = arrprice[1]
                    if strCount.count == 1 {
                        valueretur = price + "0 €"
                    } else if strCount.count == 2 {
                        valueretur = price + " €"
                    } else if strCount.count >= 3 {
                    }
                }
            } else {
                valueretur = price + ",00 €"
            }
        }
        if offerType == "flat" {
            valueretur = valueretur + " OFF"
        } else if offerType == "percent" {
            valueretur = valueretur + " % OFF"
        } else if offerType == "" {
        }
        return valueretur
    }
    
    
    
    
    
}
