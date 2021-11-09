//
//  NotificationListModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 29/06/20.
//  Copyright © 2020 Subcodevs. All rights reserved.
//

import SwiftyJSON


class NotificationListModel:JSONDecodable {
    
    var id:String?
    var notification_type:String?
    var is_read:Bool?
    
    
    var contact_uuid:String?
    var title:String?
    var message:String?
    
    var date_created:String?
    
    var contact_requested_user:IncidentUserModel?
    var user_ended_incident:IncidentUserModel?
    var ended_incident_details:OngoingIncidentModel?
    var start_incident_details:OngoingIncidentModel?
    var user_request_checkin:IncidentUserModel?
    var ending_message:String?
    var emergency_contact_details:EmergencyContactDetails?
    var contact_requested_user1:ContactModel?
    var location_updated_user:IncidentUserModel?
    
    
    required init(json: JSON) {
        
        id = json["id"].stringValue
        notification_type = json["notification_type"].stringValue
        is_read = json["is_read"].bool
        
        contact_uuid = json["contact-uuid"].stringValue
        title = json["title"].stringValue
        message = json["message"].stringValue
        
        date_created = json["date_created"].stringValue
        ending_message = json["ending_message"].stringValue
        
        contact_requested_user = IncidentUserModel(json:json["contact-requested-user"])
        user_request_checkin = IncidentUserModel(json:json["user-request-checkin"])
        user_ended_incident = IncidentUserModel(json:json["user-ended-incident"])
        ended_incident_details = OngoingIncidentModel(json:json["ended-incident-details"])
        
        let start_incident_json = json["start-incident-details"]
        start_incident_details = OngoingIncidentModel(json:start_incident_json)
        emergency_contact_details = EmergencyContactDetails(json:json["emergency-contact-details"])
        
        contact_requested_user1 = ContactModel(json: json["contact-requested-user"])
        location_updated_user = IncidentUserModel(json: json["location-updated-user"])
    }
    
}





class EndedIncidentDetails:JSONDecodable {
    var incident_id:String?
    required init(json: JSON) {
        incident_id = json["incident_id"].string
    }
    
}



class EmergencyContactDetails:JSONDecodable {
    
    var user:IncidentUserModel?
    var uuid:String?
    var id:String?
    required init(json: JSON) {
        user = IncidentUserModel.init(json: json["user"])
        uuid = json["uuid"].string
        id = json["id"].stringValue
    }
    
}
