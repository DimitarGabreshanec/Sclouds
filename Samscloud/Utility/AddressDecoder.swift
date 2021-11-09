//
//  AddressDecoder.swift
//  FloweretProvider
//
//  Created by Irshad Ahmed on 09/03/19.
//  Copyright © 2019 Irshad Ahmed. All rights reserved.
//

import Foundation
import CoreLocation

typealias cl_completion = ((_ address:String?)->Void)?

func getAddressFromLocation(loc:CLLocation , _ completion:cl_completion) {
    
    var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
   
    let ceo: CLGeocoder = CLGeocoder()

    center.latitude = loc.coordinate.latitude
    center.longitude = loc.coordinate.longitude
    
    ceo.reverseGeocodeLocation(loc, completionHandler:
        {(placemarks, error) in
            if (error != nil){
                print("REVERSE GEOCODE ERROR: \(error!.localizedDescription)")
                completion?(nil)
            }
            if placemarks != nil {
                let pm = placemarks! as [CLPlacemark]
             
                if pm.count > 0 {
                    let pm = placemarks![0]
                
                    print(pm.addressDictionary)
                    
                    let lines = pm.addressDictionary?["FormattedAddressLines"] as? [String] ?? []
                    var addressString : String = ""

                    var addressOnlyString : String = ""
                    
                    if lines.count == 4 {
                        for (index , str) in lines.enumerated() {
                            if index != 0 {
                                addressString.append("\(str)")
                                if index != lines.count - 1 {
                                   addressString.append(", ")
                                }
                            }
                        }
                        addressOnlyString.append("\(lines[0]), \(lines[1])")
                    }else if lines.count < 4 {
                        for (index , str) in lines.enumerated() {
                            addressString.append("\(str)")
                            if index != lines.count - 1 {
                               addressString.append(", ")
                            }
                        }
                        if lines.count >= 2 {
                            addressOnlyString.append("\(lines[0]), \(lines[1])")
                        }
                    }else{
                        for (index , str) in lines.enumerated() {
                            addressString.append("\(str)")
                            if index != lines.count - 1 {
                               addressString.append(", ")
                            }
                        }
                        if lines.count >= 2 {
                            addressOnlyString.append("\(lines[0]), \(lines[1])")
                        }
                    }
                    if pm.subLocality != nil {
                        appDelegate.area = pm.subLocality
                        appDelegate.addressNameStr = pm.subLocality
                    }else if pm.locality != nil {
                        appDelegate.area = pm.locality
                        appDelegate.addressNameStr = pm.locality
                    }
                    
                    //print("Area Name ------ >>>>>",appDelegate.area)
                    appDelegate.addressOnly = addressOnlyString
                    appDelegate.addressStr = addressOnlyString
                    appDelegate.currentAddressForShare = addressOnlyString
                    completion?(addressString)
                    return
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
//                        kAppDelegate.addressNameStr = addressString
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                            completion?(addressString)
                        }
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                }
            }
    })
}



