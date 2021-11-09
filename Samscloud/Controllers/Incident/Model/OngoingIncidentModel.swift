//
//  OngoingIncidentModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 12/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class OngoingIncidentModel:JSONDecodable {
    
    var created_date:String?
    var updated_date:String?
    var address:String?
    var id:String?
    
    
    var emergency_message:String?
    var streaming_id:String?
    var current_location:String?
    var stream_url:String?
    
    var broadcast_start_time:String?
    var user:IncidentUserModel?
    var preview_thumbnail:String?
    var stream_duration:Float?
    
    var contact_uuid:String?
    var is_stopped:Bool?
    var is_ended:Bool?
    
    var start_location:StartLocation?
    var end_location:StartLocation?
    var ending_message:String?
    
    required init(json: JSON) {
        
        created_date = json["created_date"].stringValue
        updated_date = json["updated_date"].stringValue
        ending_message = json["ending_message"].stringValue
        
        address = json["address"].stringValue
        id = json["id"].stringValue
        
        
        emergency_message = json["emergency_message"].stringValue
        streaming_id = json["streaming_id"].stringValue
        current_location = json["current_location"].stringValue
        stream_url = json["stream_url"].stringValue
        
        broadcast_start_time = json["broadcast_start_time"].stringValue
        user = IncidentUserModel(json:json["user"])
        preview_thumbnail = json["preview_thumbnail"].stringValue
        stream_duration = json["stream_duration"].floatValue

        contact_uuid = json["contact_uuid"].stringValue
        
        is_stopped = json["is_stopped"].boolValue
        is_ended = json["is_ended"].boolValue
        
        start_location = StartLocation(json: json["start_location"])
        end_location = StartLocation(json: json["end_location"])
    }
    
    
}






class StartLocation:JSONDecodable {
    
    var longitude:Double?
    var latitude:Double?
    var altitude:Double?
    var address:String?
    var location:CLLocation?
    
    
    required init(json: JSON) {
        
        longitude = json["longitude"].doubleValue
        latitude = json["latitude"].doubleValue
        altitude = json["altitude"].doubleValue
        address = json["address"].stringValue
        
        if let lat = latitude, let long = longitude {
            location = CLLocation(latitude: lat, longitude: long)
        }
    }
}






