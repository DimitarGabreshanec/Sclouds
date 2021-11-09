//
//  ProfileDetailModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 03/06/20.
//  Copyright © 2020 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileDetailModel:JSONDecodable {
    
    var state:String?
    var id:String?
    var phone_number:String?
    
    var profile_logo:String?
    var email:String?
    var address:String?
    
    var history_incident_count:String?
    var emergency_contact_count:String?
    var family_contact_count:String?
    var ongoing_incident_count:String?
    
    var zip:String?
    var last_name:String?
    var first_name:String?
    var city:String?
    
    
    required init(json: JSON) {
        
        state = json["state"].stringValue
        id = json["id"].stringValue
        phone_number = json["phone_number"].stringValue
        
        profile_logo = json["profile_logo"].stringValue
        email = json["email"].stringValue
        address = json["address"].stringValue
        
        history_incident_count = json["history-incident-count"].stringValue
        emergency_contact_count = json["Emergency-contact-count"].stringValue
        family_contact_count = json["Family-contact-count"].stringValue
        ongoing_incident_count = json["ongoing-incident-count"].stringValue
        
        zip = json["zip"].stringValue
        last_name = json["last_name"].stringValue
        first_name = json["first_name"].stringValue
        city = json["city"].stringValue
    }
}







class NotificationPrefrenceModel:JSONDecodable {
    
    var contact_has_incident:Bool?
    var crisis_emergency_alert:Bool?
    var new_updates:Bool?
    
    var contact_request:Bool?
    var app_tips:Bool?
    var send_incident_text:Bool?
    
    var contact_disable_location:Bool?
    var new_message:Bool?
    var send_incident_email:Bool?
    
    
    required init(json: JSON) {
        
        contact_has_incident = json["contact_has_incident"].boolValue
        crisis_emergency_alert = json["crisis_emergency_alert"].boolValue
        new_updates = json["new_updates"].boolValue
        
        contact_request = json["contact_request"].boolValue
        app_tips = json["app_tips"].boolValue
        send_incident_text = json["send_incident_text"].boolValue
        
        contact_disable_location = json["contact_disable_location"].boolValue
        new_message = json["new_message"].boolValue
        send_incident_email = json["send_incident_email"].boolValue
        
    }
    
}



class SettingPrefrenceModel:JSONDecodable {
    
    var auto_route_contacts:Bool?
    var siri_incident_start:Bool?
    var nfc:Bool?
    
    var auto_route_incident_organization:Bool?
    var bluetooth:Bool?
    var shake_activate_incident:Bool?
    
    required init(json: JSON) {
        
        auto_route_contacts = json["auto_route_contacts"].boolValue
        siri_incident_start = json["siri_incident_start"].boolValue
        nfc = json["nfc"].boolValue
        
        auto_route_incident_organization = json["auto_route_incident_organization"].boolValue
        bluetooth = json["bluetooth"].boolValue
        shake_activate_incident = json["shake_activate_incident"].boolValue
    }
    
}
