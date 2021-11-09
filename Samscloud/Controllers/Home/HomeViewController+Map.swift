//
//  HomeViewController+Map.swift
//  Samscloud
//
//  Created by SubcoDevs  on 10/14/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import AVFoundation
//import WowzaGoCoderSDK
import CoreLocation
import GoogleMaps
import SwiftyJSON


extension HomeViewController {
    
    
    func createPolygon() {
        // Create a rectangular path
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
        rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
        rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))

        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
    
    
    

    func checkNearByOrganization() {
        
        organizationList.forEach({$0.updateDistance()})
        var isOrganizationFound = false
        
        if let org =  organizationList.sorted(by: {$0.distance < $1.distance}).first {
            let loc = appDelegate.currentLocation.coordinate
            if let path = org.polygon?.path, GMSGeometryContainsLocation(loc, path , true) {
                
                //print("YES: you are in this polygon.")
                
                isOrganizationFound = true
                lblAddressName.text = org.organization_name
                appDelegate.addressNameStr = org.organization_name
                
                if let image = org.logo {
                    let url = image
                    let img = UIImage.init(named: "logoLanding-small")
                    if samsOrgImgUrl != image {
                        samsOrgImgUrl = image

                        loadImage(url, self.imgAddress, activity: nil, defaultImage: img) {
                            if self.mapView.isHidden == false {
                               self.reShowSmallCameraView()
                            }
                        }
                    }
                }
                
                if incidentModel != nil && incidentModel?.organization?.id != org.id {
                    // aouto chekout
                    self.autoCheckoutFromOrg()
                    incidentModel = nil
                }else if incidentModel?.organization?.id == org.id {
                    lblAddress.text = org.address
                }
            }else{
                //print("NO: you aren't in this polygon.")
                isOrganizationFound = false
                if incidentModel != nil && incidentModel?.organization?.id == org.id {
                    self.autoCheckoutFromOrg()
                    incidentModel = nil
                }
            }
        }
        
        appDelegate.nearbyPlaces.forEach({
            $0.updateDistance()
        })
        
        if !isOrganizationFound {
            if let place = appDelegate.nearbyPlaces.sorted(by: {$0.distance < $1.distance}).first {
                print("Place Name ------",place.name!)
                print("Place Distance ------",place.distance)
                print("Place Logo ------",place.icon!)
                if place.distance < 80 {
                    lblAddressName.text = place.name
                    appDelegate.addressNameStr = place.name
                    if let image = place.icon {
                        let img = UIImage.init(named: "logoLanding-small")
                        if googleOrgImgUrl != image {
                            googleOrgImgUrl = image
                            loadImage(image, self.imgAddress, activity: nil, defaultImage: img) {
                                if self.mapView.isHidden == false {
                                   //self.reShowSmallCameraView()
                                }
                            }
                        }else{
                            //checkCameraViewPosition()
                        }
                    }
                }else {
                    lblAddressName.text = appDelegate.area
                    appDelegate.addressNameStr = appDelegate.area
                    self.imgAddress.image = UIImage.init(named: "logoLanding-small")
                }
            }else{
                lblAddressName.text = appDelegate.area
                appDelegate.addressNameStr = appDelegate.area
                self.imgAddress.image = UIImage.init(named: "logoLanding-small")
            }
        }
        
    }
    
    
    
    @objc func checkCameraViewPosition()  {
        
    }
    
    
    func autoCheckoutFromOrg() {
        
        if appDelegate.currentLocation == nil {return}
        
        guard let id = incidentModel?.organization?.id else {return}
        
        let url =  BASE_URL + Incident.CHECKOUT
            
        let param:[String:Any] = [
            "latitude":appDelegate.currentLocation.coordinate.latitude,
            "longitude":appDelegate.currentLocation.coordinate.longitude,
            "organization_id":id
        ]
        
        print(JSON.init(param))
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response , let code = statusCode {
                print(json,code)
                
                let msg = "User has been checkout from the organization"
                
                if code == 200 && json["status"].stringValue == msg {
                    self.setChekinButtonUnSelected()
                }else{
                    
                }
            }
        }
    }
    
    
}

