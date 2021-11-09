//
//  Constants.swift
//  Samscloud
//
//  Created by Akhilesh Singh on 05/08/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    // Production
    static var PROD_URL = "https://api.samscloud.io/api/"
    static var PROD_IMAGE_URL = "https://api.samscloud.io/api/"
    
    // Staging
    static var STAGING_URL = "https://api.samscloud.io/api/"
    static let GET_ORG = "organization/"
    static let ADD_ORG_CONTACS = "organization/add-organization-contacts/"
    static let CHECK_PROCODE = "organization/check-pro-code/"
    static let ADD_EMG_CONTACTS = "users/emergency-contact/"
    static let DELETE_CONTACT = "users/user-contact-delete/"
    static let GET_ORG_CONTACTS = "organization/get-organization-contacts/"
    static let GET_USER_CONTACTS = "users/get-user-contacts/"
    static let SEARCH_ORG = "organization/search-organization/"
    static let ADD_ORG = "organization/create-user-organization/"
    static let ORGANIZATION_LIST = "organization/"
    static let SEARCH_ORG_BY_PROMO = "organization/get-organization-by-pro-code/"
    static let ACCEPT_CONATCT_REQUEST = "users/emergency-contact-activate/"
    static let ACCEPT_REQUEST_CHECKIN = "users/contact-location-update/"
    
    static let incidentLocation = "incidents/incident-location/"
    static let INCIDENT_CREATE = "incidents/list-create/"
    static let SAMSCLOUD_USERS = "users/list-users/"
    static let UPDATE_PROFILE = "users/update-profile/"
    static let USER_DETAILS = "users/user-details/"
    static let USER_NOTIFICATION_SETTINGS = "users/user-notifications/"
    static let UPDATE_USER_NOTIFICATION_SETTINGS = "users/update-notification-settings/"
    static let SHARE_MY_LOCATION = "users/share-my-location-update/"
    static let CURRENT_LOCATION_UPDATE = "users/current-location-update/"
    
    static let USER_SETTINGS = "users/user-settings/"
    static let UPDATE_USER_SETTINGS = "users/update-user-settings/"
    static let NOTIFICATIONS = "users/list-notifications/"
    static let DELETE_NOTIFICATION = "users/list-notifications/"
    static let isFrom = ""
    //users/{notification_id}/delete-notification/ (DELETE
    //static let INCIDENT_CREATE = "incidents/list-create/"
    
}



struct Users {
    
    static let UPLOAD_PHOTO = "users/update-profile-picture/"
    static let FORGOT_PASS = "users/mobile-forgot-password/"
    static let ADD_FCM_TOKEN = "users/add-fcm-token/"
    
    static let FORGOT_PASS_VERIFY_OTP = "users/mobile-forgot-password-verify-otp/"
    static let FORGOT_PASS_UPDATE = "users/mobile-forgot-password-update/"
    static let CHANGE_PASSWORD = "users/user-profile-reset-password/"
    static let RESPONDER_LIST = "incidents/responders-list/"
    static let EMERGENCY_QUICK_CONTACT = "incidents/emergency-quick-contact/"
    static let SEND_INCIDENT_ALERT_NOTIFICATION = "incidents/send-incident-alert-notifications/"
    
    //"/api/incidents/joined-responders-list/"
    
    
}


struct Incident {
    static let JOINED_RESPONDER_LIST = "incidents/joined-responders-list/"
    static let END = "incidents/end-of-incident/"
    static let STOP = "incidents/end-of-incident/"
    static let RESPONDER_LOCATION_UPDATE = "incidents/responder-location-update/"
    static let CHECKOUT = "api/incidents/incident-checkout/"
}




var BASE_URL = String ()
//var appDelegate = UIApplication.shared.delegate as! AppDelegate
var authToken : String!







func updateIncidentUrl(id:String)->String {
    let url = BASE_URL + "incidents/\(id)/incident/"
    return url
}


func organizationListUrl()->String {
    let url = BASE_URL + "incidents/organizers-list/?Latitude=\(appDelegate.curaltitude)&Longitude=\(appDelegate.curLongitude)"
    print("organizationListUrl",url)
    return url
}



func incidentDetailUrl(id:String)->String {
    let url = BASE_URL + "incidents/\(id)/incident/"
    print("incidentDetailUrl",url)
    return url
}


func ongoingIncidentUrl()->String {
    let url = BASE_URL + "incidents/ongoing-incident/"
    print("ongoingIncidentUrl",url)
    return url
}


func incidentHistoryUrl()->String {
    let url = BASE_URL + "incidents/incident-history/"
    print("incidentHistoryUrl",url)
    return url
}

func shareIncidentWithContactsURL()->String {
    let url = BASE_URL + "incidents/incident-contacts-sharing/"
    print("shareIncidentWithContactsURL",url)
    return url
}


func shareIncidentWithOrganizationURL()->String {
    let url = BASE_URL + "incidents/incident-organization-sharing/"
    print("shareIncidentWithOrganizationURL",url)
    return url
}

func refreshTokenUrl()->String {
    let url = BASE_URL + "token/refresh/"
    print("refreshTokenUrl",url)
    return url
}

extension Date {
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}




func deleteNotificationURL(id:String)->String {
    let url = BASE_URL + "users/" + "\(id)/" + "delete-notification/"
    return url
}
