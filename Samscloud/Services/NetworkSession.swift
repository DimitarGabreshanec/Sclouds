//
//  NetworkSession.swift
//  FuelCred
//
//  Created by Shahzeb Khan on 5/2/19.
//  Copyright © 2019 Shahzeb Khan. All rights reserved.
//

import Foundation
import Alamofire

class NetworkSession {
    static let shared = NetworkSession()
    var manager: SessionManager!
    
    init() {
        let manager = SessionManager.default
        self.manager = manager
    }
}
