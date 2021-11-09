//
//  Api.swift


import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView


// MARK: - Api Results
enum ApiResult<Value> {
    case success(value: Value)
    case failure(error: NSError)
    
    init(_ f: () throws -> Value) {
        do {
            let value = try f()
            self = .success(value: value)
        } catch let error as NSError {
            self = .failure(error: error)
        }
    }
    
    @discardableResult
    func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

enum ChatErrorCode: Int {
    case contactUserIsNotFound = 10
    case contactUnableToAddYourself = 21
    case chatAssingOtherMemberBeManager = 34
}

// MARK: - Endpoints
enum Endpoint {
    
    // These cases use for testing purpose only
    
    //        case  pendingMessages(time: String)
    //        case signupdiscard
    //        case changemobilenumber
    //        case downloadFile(chatId: String, fileId: String)
    //
    //        case getTest
    //        case deleteTest
    //        case putTest
    
    
    // Samscloud
    //        case tokenAuth
    //        case createUser
    //        case getUser
    //        case updateUser(id:Int)
    
    
    // Samscloud
    
    case authLogin
    case createUser
    // We will add future
    case photo
    case address
    case phone
       // case phoneVerification(id:String)
        case phoneVerification(id:Int)
        case phoneResend(id:Int)

    case locationGet(id:Int)
    case contactListAdd
    case contactGetList(id:Int)
    case organizationList
    case organizationListApi
    case procode

    
    var method: Alamofire.HTTPMethod {
        switch self {
        case  .address, .authLogin, .createUser, .photo,.phone, .phoneResend, .phoneVerification, .locationGet,.contactListAdd,.contactGetList,.organizationList,.procode,.organizationListApi:
            return .post
            //                case .getUser:
            //                        return .get
            //                case  .updateUser:
            //                        return .patch
        }
    }


    var path: String {
        switch self {
        // Samscloud
        case  .authLogin: return "auth/login" // post
        case .createUser: return "user" //post
        case .address : return "address"
        case .photo: return "photo"
        case .phone: return "phone"
        case .phoneVerification(let id): return "phone/\(id)/verify"
        case .phoneResend(let id): return "phone/\(id)/resend"
        case .locationGet(let id): return "phone/\(id)"
        case .contactListAdd: return "contact"
        case .contactGetList(let id): return "contact/\(id)"
        case .organizationList: return "/organizationList/"
        case .procode: return "procode/"
        case .organizationListApi: return "organizationListApi/"



        }
    }
    
    
    
    var encoding: Alamofire.ParameterEncoding {
        
        switch self {
        case .authLogin, .createUser, .address, .photo,.phone, .phoneVerification, .phoneResend,.locationGet,.contactListAdd,.contactGetList, .organizationList,.procode,.organizationListApi:
            return JSONEncoding.default
            //                case .getUser:
            //                        return URLEncoding.default
            
        }
    }
}


// MARK: -  Api
class PSApi {
    // MARK: - Public Methods
    static func apiRequestWithEndPoint(_ endpoint: Endpoint, params: [String: AnyObject]? = nil, isShowAlert : Bool, controller:UIViewController, isNeedToken: Bool = true,failure:((Error)->Void)? = nil, response: @escaping (DataResponse<JSON>) -> Void) {
        
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url : URL?
        url = URL(string:baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        header = ["Content-Type":"application/json"]
        if isNeedToken {
            guard let token = UserDefaults.standard.getAuthenticationToken() else {
                debugPrint("Token not set")
                return
            }
            header = ["authorization": "Bearer " + token]
            debugPrint("Token: \(token)")
        }
        // These log added by Ravi
        print("API Requrest URL========> \(String(describing: url?.absoluteString ) )")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted)
            print ("method = \(String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Test")")
        } catch {
            print("Error")
        }
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).responseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                SwiftLoader.hide()

            }
            switch responseData.result {
            case .success:
                
                //                                switch responseData.value!["StatusCode"].rawString{
                //                                case ResponseStatusCode.success.rawValue:
                //                                                response (responseData)
                //                                case ResponseStatusCode.error.rawValue:
                //                                                if  isShowAlert{
                //                                                        PSUtility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                //                                        }
                //                                case ResponseStatusCode.sessionExpired.rawValue:
                //                                                if  isShowAlert{
                //                                                        PSUtility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                //                                                }
                //                                                PSUtility.logoutAction(controller:controller)
                //                                }
                
//                if  (responseData.value?["status"] == 200){
//                    response (responseData)
//                    SwiftLoader.hide()
//                    if responseData.value!["ResponseData"].dictionary != nil{
//                        // response (responseData)
//                    }
//                }
                
//                else if  (responseData.response?.statusCode == 201){
//                    response (responseData)
//                    SwiftLoader.hide()
//                    if responseData.value!["ResponseData"].dictionary != nil{
//                        // response (responseData)
//                    }
//                }
                
                 if  (responseData.response?.statusCode == 400){
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
//                        let string = "\(responseData.value!["email"])"
//                        let badchar = CharacterSet(charactersIn: "\"[]")
//                        let cleanedstring = string.components(separatedBy: badchar).joined()
//                        Utility.alertContoller(stayle: .alert, title: "", message: cleanedstring, actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
                    
//
//                else if (responseData.value["StatusCode"] == "03"){
//                    if  isShowAlert{
//                        SwiftLoader.hide()
//                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
//                    }
//
//                }else if (responseData.value["StatusCode"] == "04"){
//                    if  isShowAlert{
//                        SwiftLoader.hide()
//                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
//                    }
//                    Utility.logoutAction(controller:controller)
//                }else{
//                    SwiftLoader.hide()
//                    Utility.alertContoller(stayle: .alert, title: "", message: "Unable to log in with provided credentials.", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
//
//                }
            case .failure(let error):
                print (error)
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                failure?(error)
                break
            }
        }
    }
    
    // MARK: - Public Methods
    static func apiRequestWithEndPointMockup(_ endpoint: Endpoint, params: [String: AnyObject]? = nil, isShowAlert : Bool, controller:UIViewController, isNeedToken: Bool = true,failure:((Error)->Void)? = nil, response: @escaping (DataResponse<JSON>) -> Void) {
        
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url : URL?
        url = URL(string:baseURLLatestMockUp)?.URLByAppendingEndpoint(endpoint)
        
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        header = ["Content-Type":"application/json"]
       
        // These log added by Ravi
        print("API Requrest URL========> \(String(describing: url?.absoluteString ) )")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted)
            print ("method = \(String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Test")")
        } catch {
            print("Error")
        }
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).responseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                SwiftLoader.hide()
                
            }
            switch responseData.result {
            case .success:
                
//                                switch responseData.value!["StatusCode"].rawString{
//                                case ResponseStatusCode.success.rawValue:
//                                        response (responseData)
//                                case ResponseStatusCode.error.rawValue:
//                                      if  isShowAlert{
//                                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
//                                                        }
//                                case ResponseStatusCode.sessionExpired.rawValue:
//                                        if  isShowAlert{
//                                            Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
//                                                                }
//                                        Utility.logoutAction(controller:controller)
//                                                }
                
                                if  (responseData.response?.statusCode == 200) {
                                    //response (responseData)
                                    SwiftLoader.hide()
                                    //response(responseData)
                                    //if value["ResponseData"].dictionary != nil{
                                        // response (responseData)
                                    
                                } else if  (responseData.response?.statusCode == 201){
                                    //response (responseData)
                                    SwiftLoader.hide()
                                    let value = responseData.result.value

                                  // if responseData.result["ResponseData"].dictionary != nil{
                                    //response (responseData.result as! DataResponse<JSON>)
                                   // }
                                }
                
                if  (responseData.response?.statusCode == 400){
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        //                        let string = "\(responseData.value!["email"])"
                        //                        let badchar = CharacterSet(charactersIn: "\"[]")
                        //                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        //                        Utility.alertContoller(stayle: .alert, title: "", message: cleanedstring, actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
                
                //
                //                else if (responseData.value["StatusCode"] == "03"){
                //                    if  isShowAlert{
                //                        SwiftLoader.hide()
                //                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                //                    }
                //
                //                }else if (responseData.value["StatusCode"] == "04"){
                //                    if  isShowAlert{
                //                        SwiftLoader.hide()
                //                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                //                    }
                //                    Utility.logoutAction(controller:controller)
                //                }else{
                //                    SwiftLoader.hide()
                //                    Utility.alertContoller(stayle: .alert, title: "", message: "Unable to log in with provided credentials.", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                //
            //                }
            case .failure(let error):
                print (error)
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                failure?(error)
                break
            }
        }
    }
    static func upload(_ endpoint: Endpoint, params: [String: AnyObject]? = nil, isShowAlert : Bool, controller:UIViewController, isNeedToken: Bool = true,fileName:String?, binary: Data, response: @escaping (DataResponse<JSON>) -> Void) {
        
        var header: HTTPHeaders = HTTPHeaders()
        if isNeedToken {
            guard let token = UserDefaults.standard.getAuthenticationToken() else {
                debugPrint("Token not set")
                return
            }
            header = ["Content-Type":"multipart/form-data",
                      "authorization": "Token " + token
            ]
            debugPrint("Token: \(token)")
        }
        
        
        var url : URL?
        url = URL(string:baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var mimeType = ""
            if fileName == "audio.m4a" {
                mimeType = "audio/m4a"
            } else if fileName == "video.mp4" {
                mimeType = "video/mp4"
            } else {
                mimeType = "image/jpeg"
            }
            
            if let meta = params {
                for (key , datainfo) in meta{
                    multipartFormData.append((datainfo as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
            }
            multipartFormData.append(_: binary, withName: "upload", fileName: fileName ?? "", mimeType: mimeType)
        }, usingThreshold: UInt64.init(), to: url ?? "", method: endpoint.method, headers: header, encodingCompletion: { (result) in
            
            debugPrint("upload file result: \(result)")
            
            switch result {
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        SwiftLoader.hide()
                        response.response?.statusCode
                        let json = JSON.init(value)
                        print(json)
                        break
                    case .failure(let error):
                        SwiftLoader.hide()
                        break
                    }
                })
                break
            case .failure(let error):
                SwiftLoader.hide()
                break
            }
        })
    }
}

