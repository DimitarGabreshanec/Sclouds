//
//  UserDefaults+Helpers.swift
//  Samscloud
//
//  Created by Chetu Mac on 16/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON

extension UserDefaults {
    
    fileprivate enum Key: String {
        case authenticationToken = "authenticationToken"
        case reportAttachments = "reportAttachments"
        case contactsCache = "contactsCacheJSON"
        case organizationsCache = "organizationsCacheJSON"
        case incidentsCache = "incidentsCacheJSON"
        case incidentsHistoryCache = "incidentsHistoryCacheJSON"
        case notificationsCache = "notificationsCacheJSON"
        case settingsCache = "settingsCacheJSON"
    }
    
    func getAuthenticationToken() -> String? {
        return object(forKey: Key.authenticationToken.rawValue) as? String
    }
    
    func setAuthenticationToken(_ token: String) {
        set(token, forKey: Key.authenticationToken.rawValue)
        synchronize()
    }
    
    func removeAuthenticationToken() {
        removeObject(forKey: Key.authenticationToken.rawValue)
        synchronize()
    }
    
    func setReportAttachments(_ attachments: [ReportAttachment]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: attachments)
        set(encodedData, forKey: Key.reportAttachments.rawValue)
    }
    
    func getReportAttachments() -> [ReportAttachment] {
        if let data = object(forKey: Key.reportAttachments.rawValue) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [ReportAttachment] ?? []
        } else {
            return []
        }
    }
    
    func clearCaches() {
        removeObject(forKey: Key.contactsCache.rawValue)
        removeObject(forKey: Key.organizationsCache.rawValue)
        removeObject(forKey: Key.incidentsCache.rawValue)
        removeObject(forKey: Key.incidentsHistoryCache.rawValue)
        removeObject(forKey: Key.notificationsCache.rawValue)
        removeObject(forKey: Key.settingsCache.rawValue)
    }
    
    func getContactsCache() -> JSON? {
        return getCache(Key.contactsCache.rawValue)
    }
        
    func setContactsCache(_ json: JSON) {
        setCache(json, key: Key.contactsCache.rawValue)
    }
    
    func getOrganizationsCache() -> JSON? {
        return getCache(Key.organizationsCache.rawValue)
    }
        
    func setOrganizationsCache(_ json: JSON) {
        setCache(json, key: Key.organizationsCache.rawValue)
    }
    
    func getIncidentsCache() -> JSON? {
        return getCache(Key.incidentsCache.rawValue)
    }
        
    func setIncidentsCache(_ json: JSON) {
        setCache(json, key: Key.incidentsCache.rawValue)
    }
    
    func getIncidentsHistoryCache() -> JSON? {
        return getCache(Key.incidentsHistoryCache.rawValue)
    }
        
    func setIncidentsHistoryCache(_ json: JSON) {
        setCache(json, key: Key.incidentsHistoryCache.rawValue)
    }
    
    func getNotificationsCache() -> JSON? {
        return getCache(Key.notificationsCache.rawValue)
    }
        
    func setNotificationsCache(_ json: JSON) {
        setCache(json, key: Key.notificationsCache.rawValue)
    }
    
    func getSettingsCache() -> JSON? {
        return getCache(Key.settingsCache.rawValue)
    }
        
    func setSettingsCache(_ json: JSON) {
        setCache(json, key: Key.settingsCache.rawValue)
    }
    
    func getCache(_ key: String) -> JSON? {
        if let jsonString = object(forKey: key) as? String {
            let json = JSON.init(parseJSON: jsonString)
            return json
        }
        return nil
    }
    
    func setCache(_ json: JSON, key: String) {
        set(json.rawString() , forKey: key)
        synchronize()
    }
    
}
