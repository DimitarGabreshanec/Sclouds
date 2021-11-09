//
//  AppDelegate+ContactAPIs.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 19/08/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension AppDelegate {
    
    
    func acceptRejectContact(_ status:String,info:[AnyHashable:Any]) {
        
        guard let uuid = info["token"] as? String else {return}
        guard let vc = UIApplication.topViewController() else {return}
        SwiftLoader.show(title: "Please Wait...", animated: true)
        
        let url = BASE_URL + Constants.ACCEPT_CONATCT_REQUEST
        var param:[String:Any] = [
            "uuid":uuid,
            "status":status
        ]
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let lon = appDelegate.currentLocation.coordinate.longitude
        
        param["latitude"] = "\(lat)"
        param["longitude"] = "\(lon)"
        
        print(JSON.init(param))
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (respnse, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: vc)
            }else if let json = respnse, let code = statusCode {
                if code == 200 || code == 201 {
                    
                }else {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? "Contact UUID is missing"
                    showAlert(msg: msg, title: "Error", sender: vc)
                }
            }
        }
    }
    
    
    func acceptRejectContact(_ status:String,info:[AnyHashable:Any],_ callback:(()->Void)?) {
           
           guard let uuid = info["token"] as? String else {return}
           guard let vc = UIApplication.topViewController() else {return}
           SwiftLoader.show(title: "Please Wait...", animated: true)
           
           let url = BASE_URL + Constants.ACCEPT_CONATCT_REQUEST
           var param:[String:Any] = [
               "uuid":uuid,
               "status":status
           ]
           
        
           let lat = appDelegate.currentLocation.coordinate.latitude
           let lon = appDelegate.currentLocation.coordinate.longitude
           
           param["latitude"] = "\(lat)"
           param["longitude"] = "\(lon)"
           
           print(JSON.init(param))
           
           APIsHandler.POSTApi(url, param: param, header: header()) { (respnse, error, statusCode) in
               SwiftLoader.hide()
               if let err = error {
                   showAlert(msg: err.localizedDescription, title: "Error", sender: vc)
               }else if let json = respnse, let code = statusCode {
                   if code == 200 || code == 201 {
                       callback?()
                   }else {
                       let msg = json["non_field_errors"].array?.first?.stringValue ?? "Contact UUID is missing"
                       showAlert(msg: msg, title: "Error", sender: vc)
                   }
               }
           }
       }
    

    /*func acceptRejectContact(_ status:String,info:[AnyHashable:Any], _ callback:(()->Void)?) {
        
        guard let uuid = info["token"] as? String else {return}
        guard let vc = UIApplication.topViewController() else {return}
        SwiftLoader.show(title: "Please Wait...", animated: true)
        
        let url = BASE_URL + Constants.ACCEPT_CONATCT_REQUEST
        var param:[String:Any] = [
            "uuid":uuid,
            "status":status
        ]
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let lon = appDelegate.currentLocation.coordinate.longitude
        
        param["latitude"] = "\(lat)"
        param["longitude"] = "\(lon)"
        param["address"] = self.addressOnly
        
        print(JSON.init(param))
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (respnse, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: vc)
            }else if let json = respnse, let code = statusCode {
                if code == 200 || code == 201 {
                    callback?()
                }else {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: vc)
                }
            }
        }
    }*/
    
    func acceptRejectRequestCheckin(_ status:String,info:[AnyHashable:Any]) {
        
        guard let id = info["contact"] as? String else {return}
        
        guard let vc = self.currentVC else {return}
        SwiftLoader.show(title: "Please Wait...", animated: true)
        
        let url = BASE_URL + Constants.ACCEPT_REQUEST_CHECKIN
        print("URL --->>>",url)
        let lat = appDelegate.currentLocation.coordinate.latitude
        let lon = appDelegate.currentLocation.coordinate.longitude
        
        let param:[String:Any] = [
            "contact_id":id,
            "checkin_status":status,
            "latitude":lat,
            "longitude":lon,
            "address":appDelegate.addressOnly ?? ""
        ]
        
        print(JSON.init(param))
        
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (respnse, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: vc)
            }else if let json = respnse, let code = statusCode {
                if code == 200 || code == 201 {
                    print(json)
                }else {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: vc)
                }
            }
        }
    }
    
    
    func acceptRejectRequestCheckin(_ status:String,info:[AnyHashable:Any], _ callback:(()->Void)?) {
        
        guard let id = info["contact"] as? String else {return}
        
        guard let vc = self.currentVC else {return}
        SwiftLoader.show(title: "Please Wait...", animated: true)
        
        let url = BASE_URL + Constants.ACCEPT_REQUEST_CHECKIN
        print("URL --->>>",url)
        let lat = appDelegate.currentLocation.coordinate.latitude
        let lon = appDelegate.currentLocation.coordinate.longitude
        
        let param:[String:Any] = [
            "contact_id":id,
            "checkin_status":status,
            "latitude":lat,
            "longitude":lon,
            "address":appDelegate.addressOnly ?? ""
        ]
        
        print(JSON.init(param))
        
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (respnse, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: vc)
            }else if let json = respnse, let code = statusCode {
                if code == 200 || code == 201 {
                    print(json)
                    callback?()
                }else {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: vc)
                }
            }
        }
    }
    
}
