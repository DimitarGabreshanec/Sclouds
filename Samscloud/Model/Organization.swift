
//
//  Location.swift
//  Samscloud
//
//  Created by Chetu on 04/05/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import GoogleMaps

class Organization: NSObject {
    
    var orgtId        = 0
    var orgName       = ""
    var orgAddress    = ""
    var orgUrl        = ""
    var orgCurStatus  = ""
    var orgOther      = 0
    var orgDetail     = ""
    var orgdistance   = ""
    var orgIsPush     = ""
    var orgIsDispatch = ""
    var orgType       = ""
    var orgIsPrivate  = ""
    var orgParentOrg  = ""
    var orgLogo       = ""
    var orgPhoneNo    = ""
    var orgServiceType = ""
    var orgEmail      = ""
    var orgsConnected = ""

    private override init () {
        super.init()
    }
    
    init(with name: String) {
        super.init()
        self.orgName = name
        self.orgtId = 0
    }
    
    init(dictUserData: [String: JSON]) {
        let dic = dictUserData["organziation"]
        orgtId        = (dictUserData["id"] as AnyObject).intValue ?? 0
        orgName       = "\(dictUserData["organization_name"] ?? "")"
        orgParentOrg  = (dictUserData["parent_organization"] as AnyObject).stringValue ?? ""
        orgLogo       = (dictUserData["logo"] as AnyObject).stringValue ?? ""
        orgPhoneNo    = (dictUserData["phone_number"] as AnyObject).stringValue ?? ""
        orgType       = (dictUserData["organization_type"] as AnyObject).stringValue ?? ""
        orgDetail     = (dictUserData["description"] as AnyObject).stringValue ?? ""
        orgServiceType = (dictUserData["service_type"] as AnyObject).stringValue ?? ""
        orgIsPrivate  = (dictUserData["membership_type"] as AnyObject).stringValue ?? "" //Public or Private
        orgType       = (dictUserData["membership_type"] as AnyObject).stringValue ?? ""
        orgEmail      = (dictUserData["organization_email"] as AnyObject).stringValue ?? ""
        orgUrl        = (dictUserData["URL"] as AnyObject).stringValue ?? ""
        
        orgAddress    = (dictUserData["organizationAddress"] as AnyObject).stringValue ?? ""
        orgUrl        = (dictUserData["orgUrl"] as AnyObject).stringValue ?? ""
        orgCurStatus  = (dictUserData["status"] as AnyObject).stringValue ?? ""
        orgdistance   = "\(dictUserData["organizationDistance"] ?? "")"
        orgIsPush     = (dictUserData["organizationIsPush"] as AnyObject).stringValue ?? ""
        orgIsDispatch = (dictUserData["organizationIsDispatch"] as AnyObject).stringValue ?? ""
        orgType       = "\(dictUserData["organizationType"] ?? "")"
        orgIsPrivate  = "\(dictUserData["organisationisPrivate"] ?? "")" //Public or Private
      //  let arryValueInfo = dictUserData["organization"]?.arrayValue
       // for values in arryValueInfo! {
           // let contatctTemp : Contact = Contact.init(inventoryData: values.dictionaryValue)
            //contacts.append(contatctTemp)
       // }
    }
    
    func setOrganization(dictUserData: [String: Any]) -> Organization {
        orgtId        = (dictUserData["id"] as AnyObject).intValue ?? 0
        orgName       = "\(dictUserData["organization_name"] ?? "")"
        orgParentOrg  = (dictUserData["parent_organization"] as AnyObject).stringValue ?? ""
        orgLogo       = "\(dictUserData["logo"] ?? "")"
        orgPhoneNo    = (dictUserData["phone_number"] as AnyObject).stringValue ?? ""
        orgType       = (dictUserData["organization_type"] as AnyObject).stringValue ?? ""
        orgDetail     = "\(dictUserData["description"] ?? "")"
        orgServiceType = (dictUserData["service_type"] as AnyObject).stringValue ?? ""
        orgIsPrivate  = (dictUserData["membership_type"] as AnyObject).stringValue ?? "" //Public or Private
        orgType       = (dictUserData["membership_type"] as AnyObject).stringValue ?? ""
        orgEmail      = (dictUserData["organization_email"] as AnyObject).stringValue ?? ""
        orgUrl        = (dictUserData["URL"] as AnyObject).stringValue ?? ""

        orgAddress    = (dictUserData["organizationAddress"] as AnyObject).stringValue ?? ""
        orgUrl        = (dictUserData["orgUrl"] as AnyObject).stringValue ?? ""
        orgCurStatus  = (dictUserData["status"] as AnyObject).stringValue ?? ""
        orgdistance   = "7 Miles"//"\(dictUserData["organizationDistance"] ?? "")"
        orgIsPush     = (dictUserData["organizationIsPush"] as AnyObject).stringValue ?? ""
        orgIsDispatch = (dictUserData["organizationIsDispatch"] as AnyObject).stringValue ?? ""
        orgType       = "\(dictUserData["organizationType"] ?? "")"
        orgIsPrivate  = "\(dictUserData["organisationisPrivate"] ?? "")" //Public or Private

        return self
    }
    
    static func orgnizationArray(from array: [JSON]) -> [Organization] {
        var orgnizations = [Organization]()
        for item in array {
            if let dic = item.dictionary {
            let instance = Organization.init(dictUserData: dic)
                orgnizations.append(instance)
            }
        }
        return orgnizations
    }
    
    static func getOrgnizationName(from orgnization: [Organization]) -> [String] {
        return orgnization.map{ $0.orgName }
    }
    
    
}









class OrganizationModel:JSONDecodable {

    var pro_code:String?
    var altitude:Double?
    var id:String?
    var who_can_join:String?
    
    var logo:String?
    var longitude:Double?
    var latitude:Double?
    
    var organization_name:String?
    var contact_name:String?
    var address:String?
    var distance:Float = 0
    var coordinates:[Coordinates]?
    var owner_id:String?
    var polygon:GMSPolygon?
    var dispatch:Bool?
    var alert:Bool?
    
    var email:String?
    var phone_number:String?
    
    required init(json: JSON) {
        
        pro_code = json["pro_code"].stringValue
        altitude = json["altitude"].doubleValue
        id = json["id"].stringValue
        who_can_join = json["who_can_join"].stringValue
        owner_id = json["owner_id"].stringValue
        
        logo = json["logo"].stringValue
        longitude = json["longitude"].doubleValue
        latitude = json["latitude"].doubleValue
        
        
        dispatch = json["dispatch"].bool
        alert = json["alert"].bool
        
        
        organization_name = json["organization_name"].stringValue
        contact_name = json["contact_name"].stringValue
        address = json["address"].stringValue
   
        email = json["email"].stringValue
        phone_number = json["phone_number"].stringValue
        
        if let cordArray = json["geofence"]["geometry"]["coordinates"].array?.first?.array {
            
            var list = [Coordinates]()
            
            cordArray.forEach({
                print($0)
                let object = Coordinates.init(json: $0)
                list.append(object)
            })
            
            self.coordinates = list
        }
            
        // Create a rectangular path
        if let locations = coordinates {
            let rect = GMSMutablePath()
            locations.forEach({
                if let lat = $0.lat , let lon = $0.lon {
                    rect.add(CLLocationCoordinate2D(latitude:lat, longitude: lon))
                }
            })
            polygon = GMSPolygon(path: rect)
        }
    }
    
    func updateDistance() {
        
        guard let lat1 = self.latitude, let lng2 = self.longitude else {return}
        if appDelegate.currentLocation == nil {return}
        let loc1 = CLLocation.init(latitude: lat1, longitude: lng2)
        let distance = appDelegate.currentLocation.distance(from: loc1)
        self.distance = Float(distance)
    }
}



class Coordinates:JSONDecodable {
    
    var lat:Double?
    var lon:Double?
    
    required init(json: JSON) {
        lat = json.array?.last?.doubleValue
        lon = json.array?.first?.doubleValue
    }
}
