//
//  Location.swift
//  Samscloud
//
//  Created by Chetu on 26/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON


class Location: NSObject {
    
    var userId = 0
    var longitude = 0.0
    var latitude = 0.0
    var altitude = 0.0
    var Speed = ""
    var time = ""
    
    private override init () {
        super.init()
       //  NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    init(dictUserData: [String: JSON]) {
        userId = dictUserData["userId"]?.intValue ?? 0
        longitude = (dictUserData["longitude"]?.doubleValue)!
        latitude = (dictUserData["latitude"]?.doubleValue)!
        altitude = (dictUserData["altitude"]?.doubleValue)!
        Speed = dictUserData["Speed"]?.stringValue ?? ""
        time = dictUserData["time"]?.stringValue ?? ""

        let arryValueInfo = dictUserData["data"]?.arrayValue
        for values in arryValueInfo! {
            let contatctTemp: Contact = Contact.init(inventoryData: values.dictionaryValue)
            //contacts.append(contatctTemp)
        }
    }
    
    
    
}


