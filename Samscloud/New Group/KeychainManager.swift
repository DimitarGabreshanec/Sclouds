//
//  KeychainManager.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 12/19/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import KeychainSwift

enum KeychainKey: String {
    case accessToken
    case refreshToken
    case passcode
    case address
    case state
    case city
    case zipcode
    case share_location
    
    case auto_route_organization
    case auto_route_contact
    
}

struct KeychainManager {
    
    static func set(key: KeychainKey, value: String) {
        let keychain = KeychainSwift()
        keychain.set(value, forKey: key.rawValue)
    }
    
    static func setBool(key: KeychainKey, value: Bool?) {
        let keychain = KeychainSwift()
        keychain.set(value ?? false, forKey: key.rawValue)
    }
    
    static func getBool(key: KeychainKey) -> Bool? {
        let keychain = KeychainSwift()
        return keychain.getBool(key.rawValue)
    }
    
    static func get(key: KeychainKey) -> String? {
        let keychain = KeychainSwift()
        return keychain.get(key.rawValue)
    }
    
    static func clear() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
    
    static func clearOnFirstLaunch() {
        if !DefaultManager().getHasAppEverRunBefore() {
            DefaultManager().setHasAppEverRunBefore(value: true)
            KeychainManager.clear()
        }
    }
}

