//
//  ContactEntry.swift
//  AddressBookContacts
//
//  Created by Ignacio Nieto Carvajal on 20/4/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import AddressBook
import Contacts
import Contacts
import SwiftyJSON


class ContactEntry: NSObject {
    
    var name: String!
    var lastName = ""
    var email: String?
    var phone: String?
    var image: UIImage?
    var familyRelation: String?
    
    var orgtId        = 0
    var orgName       = ""
    var orgAddress    = ""
    var orgUrl        = ""
    var orgCurStatus  = ""
    var orgOther      = 0
    var orgDetail     = ""
    var orgdistance   = ""
    var orgIsPush     = ""
    var orgIsDispatch = ""
    var orgType       = ""
    var orgsConnected = ""
    var isSamsUser = false

    
    required override init() {
        
    }
    
    required init(json:JSON) {
        self.orgtId = json["id"].intValue
        self.name = json["name"].stringValue
        self.orgtId = json["id"].intValue
    }
    
    init(name: String, email: String?, phone: String?, image: UIImage?, familyRelation: String?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.image = image
        self.familyRelation = familyRelation
    }
    
   /* func setOrganizationList(dictUserData:[String:Any]) -> ContactEntry {
        self.orgtId        = (dictUserData["organizationId"] as AnyObject).intValue ?? 0
        self.orgName       = "\(dictUserData["organizationName"] ?? "")"
        self.orgAddress    = (dictUserData["organizationAddress"] as AnyObject).stringValue ?? ""
        self.orgUrl        = (dictUserData["organizationUrl"] as AnyObject).stringValue ?? ""
        self.orgCurStatus  = (dictUserData["status"] as AnyObject).stringValue ?? ""
        self.orgDetail     = (dictUserData["detail"] as AnyObject).stringValue ?? ""
        self.orgdistance   = (dictUserData["organizationDistance"] as AnyObject).stringValue ?? ""
        self.orgIsPush     = (dictUserData["organizationIsPush"] as AnyObject).stringValue ?? ""
        self.orgIsDispatch = (dictUserData["orgIsDispatch"] as AnyObject).stringValue ?? ""
        self.orgType       = (dictUserData["organizationType"] as AnyObject).stringValue ?? "" //Public or Private
        return self
    }*/
    
    init?(addressBookEntry: ABRecord) {
        super.init()
        // Get AddressBook references (old-style)
        guard let nameRef = ABRecordCopyCompositeName(addressBookEntry)?.takeRetainedValue() else {
            return nil
        }
        // Name
        self.name = nameRef as String
        // Email
        if let emailsMultivalueRef = ABRecordCopyValue(addressBookEntry,
                                                       kABPersonEmailProperty)?.takeRetainedValue(),
                                                       let emailsRef = ABMultiValueCopyArrayOfAllValues(emailsMultivalueRef)?.takeRetainedValue() {
            let emailsArray = emailsRef as NSArray
            for possibleEmail in emailsArray {
                if let properEmail = possibleEmail as? String,
                    properEmail.isEmail() {
                    self.email = properEmail
                    break
                }
            }
        }
        // Image
        var image: UIImage?
        if ABPersonHasImageData(addressBookEntry) {
            image = UIImage(data: ABPersonCopyImageData(addressBookEntry).takeRetainedValue() as Data)
        }
        self.image = image ?? UIImage(named: "defaultUser")
        // Phone
        if let phonesMultivalueRef = ABRecordCopyValue(addressBookEntry,
                                                       kABPersonPhoneProperty)?.takeRetainedValue(),
                                                       let phonesRef = ABMultiValueCopyArrayOfAllValues(phonesMultivalueRef)?.takeRetainedValue() {
            let phonesArray = phonesRef as NSArray
            if phonesArray.count > 0 {
                self.phone = phonesArray[0] as? String
            }
        }
    }
    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        // Name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) {
            return nil
        }
        self.name = cnContact.givenName//(cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
        // Relationship
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) {
            return nil
        }
        self.familyRelation = cnContact.familyName
        // Image
        self.image = (cnContact.isKeyAvailable(CNContactImageDataKey) && cnContact.imageDataAvailable) ? UIImage(data: cnContact.imageData!) : nil
        // Email
        if cnContact.isKeyAvailable(CNContactEmailAddressesKey) {
            for possibleEmail in cnContact.emailAddresses {
                let properEmail = possibleEmail.value as String
                if properEmail.isEmail() { self.email = properEmail; break }
            }
        }
        // Phone
        let cnPhoneNumber = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        print(cnPhoneNumber)
        
        //let number = cnPhoneNumber?.value(forKey: "digits") as? String
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                var phoneStr = phone?.stringValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "") ?? ""
                let last10 = phoneStr.suffix(10)
                self.phone = phoneStr//String(last10)
                
            }
        }
    }
    
    
    
    
}



class ContactModel:JSONDecodable {

    var phone_number:String?
    var id:String?
    var user:String?
    var email:String?
    var relationship:String?
    var created_at:String?
    var updated_at:String?
    var name:String?
    var status:String?
    var uuid:String?
    var contact_role:String?
    var organization:String?
    var latitude:Double?
    var longitude:Double?
    var profile_image:String?
    var contact_type:String?
    var start_location:StartLocation?
    var end_location:StartLocation?
    var address:String?
    var location_status:LocationStatus?
    var request_checkin_data:RequestCheckinData?
    var request_sent_date:String?
    
    
    required init(json: JSON) {
        
        phone_number = json["phone_number"].stringValue
        request_sent_date = json["request_sent_date"].stringValue
        
        id = json["id"].stringValue
        email = json["email"].stringValue
        user = json["user"].stringValue
        relationship = json["relationship"].stringValue
        phone_number = json["phone_number"].stringValue
        
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        name = json["name"].stringValue
        
        status = json["status"].stringValue
        uuid = json["uuid"].stringValue
        contact_role = json["contact_role"].stringValue
        organization = json["organization"].stringValue
        
        latitude = json["latitude"].double
        longitude = json["longitude"].double
        profile_image = json["profile_image"].stringValue
        contact_type = json["contact_type"].stringValue
        
        start_location = StartLocation(json: json["start_location"])
        end_location = StartLocation(json: json["end_location"])
        location_status = LocationStatus(json: json["location_status"])
        address = json["address"].string
        
        request_checkin_data = RequestCheckinData(json: json["request_checkin_data"])
    }
    
}







class LocationStatus:JSONDecodable {
    var location_last_updated:String?
    var location_address:String?
    var location_latitude:Double?
    var location_longitude:Double?
    var location_share_location:Bool?
    
    required init(json: JSON) {
        location_last_updated = json["location_last_updated"].string
        location_address = json["location_address"].string
        
        location_latitude = json["location_latitude"].doubleValue
        location_longitude = json["location_longitude"].doubleValue
        
        location_share_location = json["location_share_location"].boolValue
        
    }
}



class RequestCheckinData:JSONDecodable {
    var request_checkin_last_updated:String?
    var request_checkin_address:String?
    var request_checkin_latitude:Double?
    var request_checkin_longitude:Double?
    
    required init(json: JSON) {
        request_checkin_last_updated = json["request_checkin_last_updated"].string
        request_checkin_address = json["request_checkin_address"].string
        
        request_checkin_latitude = json["request_checkin_latitude"].doubleValue
        request_checkin_longitude = json["request_checkin_longitude"].doubleValue
    }
}
