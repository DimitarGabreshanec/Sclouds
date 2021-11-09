//
//  AppDelegate+Location.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 11/06/20.
//  Copyright © 2020 Subcodevs. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import Firebase
import FirebaseMessaging
import GoogleMaps
import Starscream
import SwiftyJSON
import CoreLocation



extension AppDelegate:CLLocationManagerDelegate {
    
    func startLocationUpdate() {
        
        self.getCurrentAddress()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { (timer) in
            self.getCurrentAddress()
        })
    }
    
    func stopSharingLocationUpdate() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.stopUpdatingLocation()
    }
    
    func checkLocationPermission () -> Bool{
        if !CLLocationManager.locationServicesEnabled() {
            showEnableLocationServicesMessage()
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .restricted {
            let title = "Location Access Denied"
            let message = "we need your location access to detect your location, please go in settings and allow SamsCloud to access your location."
            showDeniedLocationlAlert(title: title, message: message)
            return false
        }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager == locationManager {
            if let location = locations.first {currentLocationForShare = location}
            return
        }
        
        SwiftLoader.hide()
        if let location = locations.first {
            //locManager.stopUpdatingLocation()
            self.currentLocation = location
            // Getting coordinate
            self.curLongitude = location.coordinate.longitude
            self.curaltitude = location.coordinate.latitude
            // Getting Speed
            self.curSpeed = location.speed
            let timeStamp = location.timestamp
            self.curTime = "\(timeStamp)"
            self.curAltitude = location.altitude
            
            if !isFirstTimeLocationUpdateDone {
                isFirstTimeLocationUpdateDone = true
                self.homeVC?.animateZoomLevel(zoom: 14)
                getAddressFromLocation(loc: location) { (addressStr) in
                    self.addressStr = addressStr
                    self.homeVC?.updateAddressLabel(str: addressStr)
                }
                self.startLaltitude = location.coordinate.latitude
                self.startLongitude = location.coordinate.longitude
                getNearByPlaces(lat: self.curaltitude, lng: self.curLongitude)
                startUpdatingEverySecond()
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager == locationManager { return }
        print("LOCATION MANAGER DID FAIL - ERROR: \(error.localizedDescription)")
        SwiftLoader.hide()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if manager == locationManager {
            
        }
        print("didChangeAuthorization",status)
    }
    
    
    func getCurrentAddress() {
        
        guard let location = self.currentLocationForShare else { return }
        getAddressFromLocation(loc: location) { (addressStr) in
            self.currentAddressForShare = addressStr
            self.hitUpdateLocationApi()
        }
    }
    
    
    func hitUpdateLocationApi() {
        
        guard let location = self.currentLocationForShare else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let url = BASE_URL + Constants.CURRENT_LOCATION_UPDATE
        
        let param:[String:Any] = [
            "address": currentAddressForShare ?? "",
            "latitude": "\(latitude)",
            "longitude": "\(longitude)"
        ]
        
        print(JSON.init(param))
        print(url)
        ApiManager.shared.PATCHApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                //showAlert(msg: err.localizedDescription, title: "Error", sender: self.window.)
            }else if let json = response {
                print(json)
                print("**********************")
                print("Location Updated Successfully")
                print("**********************")
                if statusCode == 200 {
                    
                }
            }
        }
    }
    
    
    func stopLocationUpdateTimer() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    
    func showDeniedLocationlAlert(title:String , message :String){
        
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settings = UIAlertAction(title: "Open-Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alrt.addAction(settings)
        alrt.addAction(cancel)
        UIApplication.topViewController()?.present(alrt, animated: true, completion: nil)
    }
    
    
    func showEnableLocationServicesMessage(){
        
        let message = "Device's location services are off, please turn it on to share your location with contacts"
        
        let alrt = UIAlertController(title: "Location Srevices are Disable", message: message, preferredStyle: .alert)
        
        let settings = UIAlertAction(title: "Open-Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alrt.addAction(settings)
        alrt.addAction(cancel)
        UIApplication.topViewController()?.present(alrt, animated: true, completion: nil)
    }
    
}



