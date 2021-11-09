//
//  DefaultManager.swift
//  Samscloud
//
//  Created by Akhilesh Singh on 07/08/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation


struct Keys{
    
    static let hasAppEverRunBefore = "hasAppEverRunBefore"
    static let access_token = "access_token"
    static let refreshToken = "refreshToken"
    static let email = "email"
    static let userId = "user_id"
    static let fcmToken = "fcmToken"
    static let name = "name"
    static let passcode = "passcode"
    static let shake = "shake"
    static let image = "profile_logo"
    static let share_location = "share_location"
    static let phone_number = "phone_number"
    
    static let auto_route_organization = "auto_route_organization"
    static let auto_route_contacts = "auto_route_contacts"
    
}






struct DefaultManager {
    
    func setHasAppEverRunBefore(value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.hasAppEverRunBefore)
    }
    
    func getHasAppEverRunBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.hasAppEverRunBefore)
    }
    
    func setToken(value: String?) {
        KeychainManager.set(key: .accessToken, value: value ?? "")
    }
    
    func getToken() -> String? {
        return KeychainManager.get(key: .accessToken)
    }
    
    func setRefreshToken(value: String?) {
        KeychainManager.set(key: .refreshToken, value: value ?? "")
    }
    
    func getRefreshToken() -> String? {
        return KeychainManager.get(key: .refreshToken)
    }
    
    func setPasscode(value: String?) {
        KeychainManager.set(key: .passcode, value: value ?? "")
    }
    
    func getPasscode() -> String? {
        return KeychainManager.get(key: .passcode)
    }
    
    
    func setEmail(value:String?) {
        UserDefaults.standard.set(value, forKey: Keys.email)
    }
    
    func getEmail()->String? {
        return UserDefaults.standard.value(forKey: Keys.email) as? String
    }
    
    func setUserId(value:Int?) {
        UserDefaults.standard.set(value, forKey: Keys.userId)
    }
    
    func getUserId()->Int? {
        return UserDefaults.standard.value(forKey: Keys.userId) as? Int
    }
    
    func setPhoneNumber(value:String?) {
        UserDefaults.standard.set(value, forKey: Keys.phone_number)
    }
    
    func getPhoneNumber()->String? {
        return UserDefaults.standard.value(forKey: Keys.phone_number) as? String
    }
    
    
    func setFcmToken(value:String?) {
        UserDefaults.standard.set(value, forKey: Keys.fcmToken)
    }
    
    func getFcmToken()->String? {
        return UserDefaults.standard.value(forKey: Keys.fcmToken) as? String
    }
    
    
    func setName(value:String?) {
        UserDefaults.standard.set(value, forKey: Keys.name)
    }
    
    func getName()->String? {
        return UserDefaults.standard.value(forKey: Keys.name) as? String
    }
    
    func setShake(value:Bool?) {
        UserDefaults.standard.set(value, forKey: Keys.shake)
    }
    
    func getShake()->Bool? {
        return UserDefaults.standard.value(forKey: Keys.shake) as? Bool
    }
    
    func setImage(value:String?) {
        UserDefaults.standard.set(value, forKey: Keys.image)
    }
    
    func getImage()->String? {
        return UserDefaults.standard.value(forKey: Keys.image) as? String
    }
    
    func setAddress(value: String?) {
        KeychainManager.set(key: .address, value: value ?? "")
    }
    
    func getAddress() -> String? {
        return KeychainManager.get(key: .address)
    }
    
    func setState(value: String?) {
        KeychainManager.set(key: .state, value: value ?? "")
    }
    
    func getState() -> String? {
        return KeychainManager.get(key: .state)
    }
    
    func setCity(value: String?) {
        KeychainManager.set(key: .city, value: value ?? "")
    }
    
    func getCity() -> String? {
        return KeychainManager.get(key: .city)
    }
    
    func setZipCode(value: String?) {
        KeychainManager.set(key: .zipcode, value: value ?? "")
    }
    
    func getZipCode() -> String? {
        return KeychainManager.get(key: .zipcode)
    }
    
    func setShareLocationStatus(value: Bool?) {
        KeychainManager.setBool(key: .share_location, value: value)
    }
    
    func getShareLocationStatus() -> Bool? {
        return KeychainManager.getBool(key: .share_location)
    }
    
    func setAutoRouteOrganization(value: Bool?) {
        KeychainManager.setBool(key: .auto_route_organization, value: value)
    }
    
    func getAutoRouteOrganization() -> Bool? {
        return KeychainManager.getBool(key: .auto_route_organization)
    }
    
    func setAutoRouteContact(value: Bool?) {
        KeychainManager.setBool(key: .auto_route_contact, value: value)
    }
    
    func getAutoRouteContact() -> Bool? {
        return KeychainManager.getBool(key: .auto_route_contact)
    }
    
}
