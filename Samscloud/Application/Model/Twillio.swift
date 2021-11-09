//
//  Twillio.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Twillio {
    
    var carrier: String?
    var is_cellphone: Bool?
    var message: String?
    var seconds_to_expire: Int?
    var uuid: String?
    var success: Bool?
    
    init(dictTwilioData: [String: JSON]) {
        carrier = dictTwilioData["carrier"]?.stringValue ?? "0"
        is_cellphone = dictTwilioData["is_cellphone"]?.boolValue ?? false
        message = dictTwilioData["message"]?.stringValue ?? ""
        seconds_to_expire = dictTwilioData["seconds_to_expire"]?.intValue ?? 0
        uuid = dictTwilioData["uuid"]?.stringValue ?? ""
        success = dictTwilioData["success"]?.boolValue ?? false
    }
    
    
}

