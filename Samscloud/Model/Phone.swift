//
//  Phone.swift
//  Samscloud
//
//  Created by Chetu on 20/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

 
class Phone: NSObject {
    
    var id = 0
    var base_entity: Int?
    var phone_number: String?
    var verified: Bool?
    var twillioData: Twillio?
    
    init(dictUserData: [String: JSON]) {
        id = dictUserData["id"]?.intValue ?? 0
        base_entity = dictUserData["base_entity"]?.intValue ?? 0
        phone_number = dictUserData["phone_number"]?.stringValue ?? ""
        verified = dictUserData["verified"]?.boolValue ?? false
        if let data = dictUserData["twilio"]?.dictionary{
            twillioData = Twillio.init(dictTwilioData: data)
        }
    }

}

