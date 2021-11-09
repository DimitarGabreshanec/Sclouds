//
//  File.swift
//  Samscloud
//
//  Created by Chetu Mac on 19/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

 
class User: NSObject {
    
    var id = 0
    var email  = ""
    var firstVame = ""
    var lastName  = ""
    var authToken  = ""
    var refreshToken = ""
    var contacts = [Contact]()
    
    override init() { }
    
    static let sharedUser: User! = {
        let instance = User()
        return instance
    }()
    
    init(dictUserData: [String: JSON]) {
        id = dictUserData["id"]?.intValue ?? 0
        email = dictUserData["email"]?.stringValue ?? ""
        firstVame = dictUserData["first_name"]?.stringValue ?? ""
        lastName = dictUserData["last_name"]?.stringValue ?? ""
        authToken = dictUserData["token"]?.stringValue ?? ""
        refreshToken = dictUserData["refresh_token"]?.stringValue ?? ""
        kAppDelegate.tokenAuth = authToken
        DefaultManager().setToken(value: authToken)
        DefaultManager().setRefreshToken(value: refreshToken)
        DefaultManager().setEmail(value: email)
        DefaultManager().setUserId(value: id)
        userDefault.setValue(authToken, forKey: "token")
        userDefault.setValue(refreshToken, forKey: "refreshToken")
        userDefault.synchronize()
    }
    
}










func refreshToken(completion:@escaping((_ message:String?)-> Void)) {
    guard let token = DefaultManager().getRefreshToken() else {
        completion("Token not found")
        return
    }
    let url = refreshTokenUrl()
    let param:[String:Any] = ["refresh":token]
    
    print(param)
    
    print("********* Hitting Refresh Token API *********")
    
    
    let request = Alamofire.request(url, method: .post, parameters: param , encoding: JSONEncoding.prettyPrinted, headers: header())
    
     request.responseJSON{ (dataResponse) in
         guard dataResponse.result.isSuccess else {
             let error = dataResponse.result.error!
             print(error.localizedDescription)
             return
         }
         if dataResponse.result.value != nil, let code = dataResponse.response?.statusCode{
             let json = JSON.init(dataResponse.result.value!)
             if code == 200 {
                 DefaultManager().setToken(value: json["access"].stringValue)
                 print("********* Token Refreshed Successfully *********")
                 completion("success")
             }
             completion("error")
         }
     }
}
