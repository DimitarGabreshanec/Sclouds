//
//  IncidentDetailModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 11/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON



class IncidentDetailModel:JSONDecodable {
    
    var organization:String?
    var emergency_message:String?
    var updated_at:String?
    var id:String?
    
    
    var latitude:Double?
    var streaming_id:String?
    var longitude:Double?
    var user:IncidentUserModel?
    
    var is_stopped:Bool?
    var created_at:String?
    var altitude:Double?
    var address:String?
    
    var is_ended:Bool?
    var ending_message:String?
    var room_id:String?
    
    var broadcast_start_time:String?
    var updated_date:String?
    var stream_duration:Float?
    var current_location:String?
    var contact_uuid:String?
    
    required init(json: JSON) {
        organization = json["organization"].stringValue
        emergency_message = json["emergency_message"].stringValue
        updated_at = json["updated_at"].stringValue
        id = json["id"].stringValue
        
        
        latitude = json["latitude"].doubleValue
        streaming_id = json["streaming_id"].stringValue
        longitude = json["longitude"].doubleValue
        user = IncidentUserModel(json: json["user"])
        
        
        is_stopped = json["is_stopped"].boolValue
        created_at = json["created_at"].stringValue
        altitude = json["altitude"].doubleValue
        address = json["address"].stringValue
        
        
        is_ended = json["is_ended"].boolValue
        ending_message = json["ending_message"].stringValue
        room_id = json["room_id"].stringValue
        
        broadcast_start_time = json["broadcast_start_time"].stringValue
        updated_date = json["updated_date"].stringValue
        stream_duration = json["stream_duration"].floatValue
        current_location = json["current_location"].stringValue
        
        contact_uuid = json["contact_uuid"].stringValue
    }
    
    
}






class IncidentUserModel:JSONDecodable {
    
    
    var phone_number:String?
    var city:String?
    var lat:Double?
    var device_id:String?
    
    var address:String?
    var last_name:String?
    var id:String?
    var state:String?
    
    var location_time:String?
    var profile_logo:String?
    var pending_status:Bool?
    var first_name:String?
    
    var date_joined:String?
    var battery_power:String?
    var photo_location:String?
    var altitude:Double?
    
    var user_type:String?
    var speed:Float?
    var zip:String?
    var is_verified:Bool?
    
    var email:String?
    var long:Double?
    
    required init(json: JSON) {
        
        phone_number = json["phone_number"].stringValue
        city = json["city"].stringValue
        lat = json["lat"].doubleValue
        device_id = json["device_id"].stringValue
        
        address = json["address"].stringValue
        last_name = json["last_name"].stringValue
        id = json["id"].stringValue
        state = json["state"].stringValue
        
        
        location_time = json["location_time"].stringValue
        profile_logo = json["profile_logo"].stringValue
        pending_status = json["pending_status"].boolValue
        first_name = json["first_name"].stringValue
        
        date_joined = json["date_joined"].stringValue
        battery_power = json["battery_power"].stringValue
        photo_location = json["photo_location"].stringValue
        altitude = json["altitude"].doubleValue
        
        
        user_type = json["user_type"].stringValue
        speed = json["speed"].floatValue
        zip = json["zip"].stringValue
        is_verified = json["is_verified"].boolValue
        
        email = json["email"].stringValue
        long = json["long"].doubleValue
    }
    
}





extension IncidentUserModel {
    func fullName()-> String {
        return (self.first_name ?? "") + " " + (self.last_name ?? "")
    }
}
