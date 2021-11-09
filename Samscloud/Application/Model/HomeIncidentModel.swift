//
//  HomeIncidentModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 04/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON


class HomeIncidentModel:JSONDecodable {
    
    var longitude:Double?
    var status:String?
    var latitude:Double?
    var organization:OrganizationModel?
    
    required init(json: JSON) {
        longitude = json["longitude"].doubleValue
        status = json["status"].stringValue
        latitude = json["latitude"].doubleValue
        organization = OrganizationModel(json: json["organization"])
    }
    
    
}

/*
{
    "id": 575,
    "created_at": "2019-09-05T07:21:41.708769Z",
    "updated_at": "2019-09-05T07:21:41.708794Z",
    "latitude": "string",
    "longitude": "string",
    "altitude": "string",
    "emergency_message": "string",
    "address": "string",
    "ending_message": "string",
    "is_ended": true,
    "organization": 1
}
*/



class IncidentModel:JSONDecodable,Codable {
    
    var id:String?
    var latitude:Double?
    var longitude:Double?
    var altitude:Double?
    var emergency_message:String?
    var address:String?
    var ending_message:String?
    var is_ended:Bool?
    var room_id:String?
    
    required init(json: JSON) {
        id = json["id"].stringValue
        room_id = json["room_id"].stringValue
        latitude = json["latitude"].doubleValue
        longitude = json["longitude"].doubleValue
        emergency_message = json["emergency_message"].stringValue
        address = json["address"].stringValue
    }
    
    
}




class Responders:JSONDecodable {
    
    var organization_contacts:[ContactModel]?
    var emergency_contacts:[ContactModel]?
    
    required init(json: JSON) {
        organization_contacts = json["organization_contacts"].array?.decode()
        emergency_contacts = json["emergency_contacts"].array?.decode()
    }
    
    required init() {
        
    }
    
}





/*
"source_connection_information": {
    "primary_server": "74837a.entrypoint.cloud.wowza.com",
    "host_port": 1935,
    "application": "app-28ee",
    "stream_name": "8d15bd99",
    "disable_authentication": false,
    "username": "client33736",
    "password": "6a3d60fb"
}*/



class WowzaStreamModel:JSONDecodable,Codable {
    
    var id:String?
    var source_connection_information:SourceConnectionInformation?
    
    required init(json: JSON) {
        id = json["id"].stringValue
        source_connection_information = SourceConnectionInformation(json: json["source_connection_information"])
    }
    
    required init() {
        source_connection_information = SourceConnectionInformation()
    }
}


class SourceConnectionInformation:JSONDecodable,Codable {

    var primary_server:String?
    var host_port:UInt?
    var application:String?
    var disable_authentication:String?
    var username:String?
    var password:String?
    var stream_name:String?
    
    required init(json: JSON) {
        primary_server = json["primary_server"].stringValue
        host_port = json["host_port"].uInt
        application = json["application"].stringValue
        disable_authentication = json["disable_authentication"].stringValue
        username = json["username"].stringValue
        password = json["password"].stringValue
        stream_name = json["stream_name"].stringValue
    }
    
    required init() {
        
    }
}





class RespondersConferenceRoom:JSONDecodable,Codable {
    
    var uuid:String?
    var stream_id:String?
    var incident_id:String?
    var responder_image:String?
    var responder_name:String?
    var type:String?
    
    required init(json: JSON) {
        uuid = json["uuid"].stringValue
        stream_id = json["stream_id"].stringValue
        incident_id = json["incident_id"].stringValue
        responder_image = json["responder_image"].stringValue
        responder_name = json["responder_name"].stringValue
        type = json["type"].stringValue
    }
    
    
    required init(dict: [String:Any]) {
        uuid = dict["uuid"] as? String
        stream_id = dict["stream_id"] as? String
        incident_id = dict["incident_id"] as? String
        responder_image = dict["responder_image"] as? String
        responder_name = dict["responder_name"] as? String
        type = dict["type"] as? String
    }
}
