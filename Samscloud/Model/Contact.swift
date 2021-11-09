//
//  Location.swift
//  Samscloud
//
//  Created by Chetu on 26/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: - CLASS

class Contact: NSObject {

    var contact = ""
    var relationship = ""

    init(inventoryData: [String: JSON]) {
        contact = inventoryData["contact"]?.stringValue ?? ""
        relationship = inventoryData["relationship"]?.stringValue ?? ""
    }
}


// MARK: - CLASS

class Contact1: NSObject {
    
    var contactId = 0
    var contactFirstName = ""
    var contactLastName  = ""
    var contactEmail = ""
    var contactRelationship = ""
    var contactPhone_Number = 0
    var contactDetail = ""
    var contacts = [Contact]()
    
    private override init () {
        super.init()
    }
    
    init(dictUserData: [String: JSON]) {
        contactId = dictUserData["Id"]?.intValue ?? 0
        contactFirstName = dictUserData["first_name"]?.stringValue ?? ""
        contactLastName = dictUserData["last_name"]?.stringValue ?? ""
        contactEmail = dictUserData["email"]?.stringValue ?? ""
        contactDetail = dictUserData["detail"]?.stringValue ?? ""
        contactRelationship = dictUserData["contactRelationship"]?.stringValue ?? ""
        contactPhone_Number = dictUserData["phone_number"]?.intValue ?? 0
        
        let arryValueInfo = dictUserData["Contact"]?.arrayValue
        for values in arryValueInfo! {
            let contatctTemp: Contact = Contact.init(inventoryData: values.dictionaryValue)
            //contacts.append(contatctTemp)
        }
    }
    
    
}
