//
//  HomeViewController+APIs.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 05/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import SwiftyJSON


extension HomeViewController {
    
    func getGeofenceArea() {
        if appDelegate.currentLocation == nil {return}
        
        
        SwiftLoader.show(title: "Checking In...", animated: true)
        let url =  BASE_URL + Constants.incidentLocation
        
        var param:[String:Any] = [
            "latitude":appDelegate.currentLocation.coordinate.latitude,
            "longitude":appDelegate.currentLocation.coordinate.longitude
        ]
        
        if let id = self.createIncidentModel?.id {
            param["incident_id"] = id
        }
        print(JSON.init(param))
        
        
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response , let code = statusCode {
                print(json,code)
                
                /*if code == 401 {
                    refreshToken { (msg) in
                        if msg == "success" {
                            
                        }
                    }
                    return
                }*/
                self.incidentModel = HomeIncidentModel.init(json: json)
                if json["status"].stringValue == "not found" {
                    let text = "No organization found in your area"
                    //MessageView.view().set(text: text, vc: self).showPopup()
                    self.showMessage(text)
                    //Samscloud.showAlert(msg: "No organization found in your area", title: "Message", sender: self)
                    return
                }
                
                self.setChekinButtonSelected()
                
                if let name = self.incidentModel?.organization?.organization_name {
                    self.lblAddressName.text = name
                    appDelegate.addressNameStr = name
                    self.address = name
                }
                
                if let address = self.incidentModel?.organization?.address {
                    self.lblAddress.text = address
                }
                
                if let image = self.incidentModel?.organization?.logo {
                    
                    let url = Constants.PROD_IMAGE_URL + image
                    let img = UIImage.init(named: "logoLanding-small")
                    
                    loadImage(url, self.imgAddress, activity: nil, defaultImage: img)
                    
                    /*loadImage(url, self.imgAddress, activity: nil, defaultImage: img) {
                        if self.mapView.isHidden == false {
                           self.reShowSmallCameraView()
                        }
                    }*/
                    
                }
                
                if self.mapView.isHidden == false {
                    self.perform(#selector(self.updateFrame), with: nil, afterDelay: 0.1)
                }
                appDelegate.initNotificationSocket()
            }
        }
    }
    
    
    
    
    func getGeofenceArea(_ completion:(()->Void)?) {
        if appDelegate.currentLocation == nil {return}
        
        
        SwiftLoader.show(title: "Checking In...", animated: true)
        let url =  BASE_URL + Constants.incidentLocation
        
        var param:[String:Any] = [
            "latitude":appDelegate.currentLocation.coordinate.latitude,
            "longitude":appDelegate.currentLocation.coordinate.longitude
        ]
        
        if let id = self.createIncidentModel?.id {
            param["incident_id"] = id
        }
        print(JSON.init(param))
        
        
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response , let code = statusCode {
                print(json,code)
                self.incidentModel = HomeIncidentModel.init(json: json)
                if json["status"].stringValue == "not found" {
                    let text = "No organization found in your area"
                    self.showMessage(text)
                    //MessageView.view().set(text: text, vc: self).showPopup()
                    //Samscloud.showAlert(msg: "No organization found in your area", title: "Message", sender: self)
                    completion?()
                    return
                }
                
                self.setChekinButtonSelected()
                
                if let name = self.incidentModel?.organization?.organization_name {
                    self.lblAddressName.text = name
                    self.address = name
                    appDelegate.addressNameStr = name
                }
                
                if let address = self.incidentModel?.organization?.address {
                    self.lblAddress.text = address
                }
                
                if let image = self.incidentModel?.organization?.logo {
                    let url = Constants.PROD_IMAGE_URL + image
                    let img = UIImage.init(named: "logoLanding-small")
                    loadImage(url, self.imgAddress, activity: nil, defaultImage: img) {
                        if self.mapView.isHidden == false {
                           self.reShowSmallCameraView()
                        }
                    }
                }
                
                if self.mapView.isHidden == false {
                    self.perform(#selector(self.updateFrame), with: nil, afterDelay: 0.1)
                }
                appDelegate.initNotificationSocket()
                completion?()
            }
        }
    }
    
    func setChekinButtonSelected() {
        checkInButton.isSelected = !checkInButton.isSelected
        checkInButton.isUserInteractionEnabled = false
        checkInButton.backgroundColor = !checkInButton.isSelected ? UIColor(hexString: "0088ff") : UIColor.white
    }
    
    
    func setChekinButtonUnSelected() {
        checkInButton.isSelected = !checkInButton.isSelected
        checkInButton.isUserInteractionEnabled = true
        checkInButton.backgroundColor = !checkInButton.isSelected ? UIColor(hexString: "0088ff") : UIColor.white
    }
    
    
    @objc func getOrganizationList() {
        
        if appDelegate.curaltitude == 0 || appDelegate.curLongitude == 0 {
            self.perform(#selector(getOrganizationList), with: nil, afterDelay: 1.0)
            return
        }
        
        let url = organizationListUrl()
        
        APIsHandler.GETApi(url, param: nil, header: header()) { (response, error, statusCode) in
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.organizationList = json.array?.decode() ?? []
            }
        }
        
    }
    
    
    
    func getCheck_in_Organizations() {
        
           if appDelegate.currentLocation == nil {return}
        
           let url =  BASE_URL + Constants.incidentLocation
           
           let param:[String:Any] = [
               "latitude":appDelegate.currentLocation.coordinate.latitude,
               "longitude":appDelegate.currentLocation.coordinate.longitude
           ]
     
           print(JSON.init(param))
           
           APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            
               if let err = error {
                   print(err.localizedDescription)
               }else if let json = response , let code = statusCode {
                   print(json,code)
               }
           }
       }
    
}
