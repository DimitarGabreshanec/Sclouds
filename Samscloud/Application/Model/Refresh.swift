//
//  Refresh.swift
//  Samscloud
//
//  Created by Akhilesh Singh on 02/08/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON


class Refresh: NSObject {

    var authToken  = ""

    override init() { }
    
    static let sharedUser: Refresh! = {
        let instance = Refresh()
        return instance
    }()
    
    init(dictUserData: [String: JSON]) {
        authToken = dictUserData["access"]?.stringValue ?? ""
        kAppDelegate.tokenAuth = authToken
        userDefault.setValue(authToken, forKey: "token")
        userDefault.synchronize()
    }
    
}
