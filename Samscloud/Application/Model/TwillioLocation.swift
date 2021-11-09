//
//  TwilioLocation.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import SwiftyJSON

struct TwillioLocation {
    
    var carrier: String?
    var message: String?
    var uuid: String?
    var success: Bool?
    
    init(dictTwilioData: [String: JSON]) {
        carrier = dictTwilioData["carrier"]?.stringValue ?? "0"
        message = dictTwilioData["message"]?.stringValue ?? ""
        uuid = dictTwilioData["uuid"]?.stringValue ?? ""
        success = dictTwilioData["success"]?.boolValue ?? false
    }
    
}
