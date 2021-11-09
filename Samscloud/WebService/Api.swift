//
//  Api.swift


import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView


// MARK: - ENUM

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

// MARK: - ENUM

enum ChatErrorCode: Int {
    
    case contactUserIsNotFound = 10
    case contactUnableToAddYourself = 21
    case chatAssingOtherMemberBeManager = 34
}


// MARK: - ENUM

enum Endpoint {
    
    // These cases use for testing purpose only
    
    // Samscloud
    case authLogin
    case createUser
    // We will add future
    case photo
    case address
    case phone
    case addContact
    case changePassword
    case locationUser
    case addOrganization
    case organizationList
    case organizationFilter(strName: String)
    case emailAlready(strName: String)
    case isEmailExist
    case emergencyContact
    //http://3.17.138.157:8000/api/get_emergency_contact/
    // case phoneVerification(id:String)
    case phoneVerification(id: Int)
    case phoneVerification1
    case phoneResend(id: Int)
    case locationGet(id: Int)
    case contactListAdd
    case contactGetList(id: Int)
    case organizationListApi
    case organizationListUrl
    case organizationUpdate
    case forgot
    case procode(strValue: String)
    case localApi
    case updateUser(id: Int)
    case refreshToken
    
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case  .address, .createUser, .locationGet, .contactListAdd, .contactGetList, .organizationListApi, .organizationListUrl, .organizationUpdate, .localApi:
            return .post
        case .authLogin, .isEmailExist, .phone, .photo, .phoneResend, .phoneVerification, .phoneVerification1, .forgot, .changePassword, .addContact, .locationUser, .refreshToken, .addOrganization:
            return .post
       
        case .organizationList, .procode, .organizationFilter, .emergencyContact, .emailAlready:
            return .get
        case  .updateUser:
             return .patch
        }
    }
    
    
    var path: String {
        switch self {
        // Samscloud
        case .authLogin: return "users/login/"
        case .isEmailExist : return "users/is-email-exists/"
        case .createUser: return "users/register/"
        case .forgot: return "users/forgot-password/"
        case .photo: return "users/update-profile-picture/"
        case .phone: return "users/sent-otp/"
        case .phoneVerification1: return "users/verify-otp/"
        case .phoneVerification(let id): return "users/verify-otp/"
        case .address : return "address"
        case .updateUser(let id): return "users/\(id)/update/"
        case .refreshToken : return "token/refresh/"
       
        case .changePassword: return "change-password/"
        case .addContact: return "add_contacts/"
      //  case .addOrganization: return "user-organization/"
        case .addOrganization: return "organization/emergency-contact/"
        case .organizationList: return "org/"
        case .emergencyContact: return "get_emergency_contact/"
        case .emailAlready(let strValue): return "is_email_exist/\(strValue)"
        case .organizationFilter(let strValue): return "org/\(strValue)"
       
        case .locationUser: return "location-details/"
       
        case .phoneResend(let id): return "phone/\(id)/resend"
        case .locationGet(let id): return "phone/\(id)"
        case .contactListAdd: return "contact"
        case .contactGetList(let id): return "contact/\(id)"
        case .procode(let strValue): return "get_organization_by_code/\(strValue)"
        case .organizationListUrl: return "Procode/"
        case .organizationUpdate: return "organizatinosUpdates/"
        case .organizationListApi: return "organizationListApi/"
        case .localApi: return "organizationListApi/"
        }
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .authLogin, .isEmailExist, .createUser, .address, .updateUser, .photo, .phone, .phoneVerification, .phoneResend, .locationGet, .contactListAdd, .contactGetList, .organizationList, .procode, .organizationListApi, .organizationListUrl, .organizationUpdate, .forgot,.localApi, .phoneVerification1, .addContact, .changePassword, .locationUser, .addOrganization, .organizationFilter, .emergencyContact, .refreshToken, .emailAlready:
            return JSONEncoding.default
            //                case .getUser:
            //                        return URLEncoding.default
            
        }
    }
}


// MARK: -  CLASS

class PSApi {
    
    
    static func apiRequestWithEndPoint(_ endpoint: Endpoint,
                                       params: [String: AnyObject]? = nil,
                                       isShowAlert: Bool,
                                       controller: UIViewController,
                                       isNeedToken: Bool = true,
                                       failure: ((Error) -> Void)? = nil,
                                       response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        header = ["Content-Type":"application/json"]
        if isNeedToken {
            guard let token = DefaultManager().getToken() else {
                print("Token not set")
                return
            }
            let auth = DefaultManager().getToken() ?? ""
            header = ["authorization": "Bearer " + auth]
        }
        // These log added by Ravi
        print("API Requrest URL========> \(String(describing: url?.absoluteString))")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted)
            print ("method = \(String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Test")")
        } catch {
            print("ERROR IN API METHOD")
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
                //NVActivityIndicatorView.
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                SwiftLoader.hide()
            }
            switch responseData.result {
            case .success:
                if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert {
                        SwiftLoader.hide()
                       
                    }
                }
            
            case .failure(let error):
                print("PRINTING ERROR FROM API METHOD: \(error.localizedDescription)")
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                failure?(error)
                break
            }
        }
    }
    static func apiRequestWithEndPointSome(_ endpoint: Endpoint,
                                           params: [String: AnyObject]? = nil,
                                           isShowAlert: Bool,
                                           controller: UIViewController,
                                           isNeedToken: Bool = true,
                                           response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
       // let auth = userDefault.object(forKey:"token") as! String
        //header = ["Content-Type":"application/json","authorization": "Bearer " + auth]
        header = ["Content-Type":"application/json","Accept": "application/json"]
        
        // header = ["authorization": "Bearer " + auth]
       /* if isNeedToken {
            guard let token = UserDefaults.standard.getAuthenticationToken() else {
                debugPrint("Token not set")
                return
            }
        }
 
 */
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
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            // print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print("Response Code -> \(responseData.response?.statusCode)")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                if  (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        //response (responseData)
                    }
                } else if  (responseData.response?.statusCode == 201){
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                }
                
               else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        
                        var string =  ""
                        
                        if (responseData.value?["email"]) != nil {
                            string = "\(responseData.value!["email"])"
                        }
                        if (responseData.value?["msg"]) != nil {
                            string = "\(responseData.value!["msg"])"
                        }
                        if (responseData.value?["non_field_errors"]) != nil {
                            string = "\(responseData.value!["non_field_errors"])"
                        }
                        
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
                
                
                else if (responseData.value!["Status"] == "200") {
                    if isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "04") {
                    if  isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller: controller)
                } else {
                    SwiftLoader.hide()
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil{
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR WITH API REQUEST: \(error.localizedDescription)")
                if  isShowAlert {
                    SwiftLoader.hide()
                    // Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    // Used for logging in
    static func apiRequestWithEndPointSign(_ endpoint: Endpoint,
                                           params: [String: AnyObject]? = nil,
                                           isShowAlert: Bool,
                                           controller: UIViewController,
                                           isNeedToken: Bool = true,
                                           response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header = HTTPHeaders()
        header = ["Content-Type" : "application/json"]
        if isNeedToken {
            guard let _ = DefaultManager().getToken() else {
                print("Token not set")
                return
            }
        }
        
        print("API Requrest URL========> \(String(describing: url?.absoluteString))")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        do {
            let jsonData = (try? JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted))
            print ("method = \(String(bytes: jsonData!, encoding: .utf8) ?? "Test")")
        } catch {
            print("Error")
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            
            print("statusCode - \(responseData.response?.statusCode)")
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                if (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 201) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                          response(responseData)
                        
                        /*
                        let non_field_errors = "\(responseData.value!["non_field_errors"])"
                    
                        let cleanedString = non_field_errors.replacingOccurrences(of: "\\", with: "")
                       
                    //    let string = "\(responseData.value!["email"])"
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = cleanedString.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                         
                         */
                    }
                } else if (responseData.value!["Status"] == "200") {
                    if  isShowAlert{
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "04") {
                    if isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller: controller)
                } else {
                    SwiftLoader.hide()
                    response(responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR AT API REQUET WITH ENDPOINT SIGN: \(error.localizedDescription)")
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    
    
    
    // // MARK: - Register User
    static func apiRequestWithEndPointRegister(_ endpoint: Endpoint,
                                           params: [String: AnyObject]? = nil,
                                           isShowAlert: Bool,
                                           controller: UIViewController,
                                           isNeedToken: Bool = true,
                                           response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header = HTTPHeaders()
        header = ["Content-Type" : "application/json"]

        
        print("API Requrest URL========> \(String(describing: url?.absoluteString))")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        do {
            let jsonData = (try? JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted))
            print ("method = \(String(bytes: jsonData!, encoding: .utf8) ?? "Test")")
        } catch {
            print("Error")
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            
            print("statusCode - \(responseData.response?.statusCode)")
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                if (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 201) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        
                        var string =  ""
                        
                        if (responseData.value?["email"]) != nil {
                            string = "\(responseData.value!["email"])"
                        }else if (responseData.value?["password"]) != nil  {
                            string = "\(responseData.value!["password"])"
                        }else if (responseData.value?["address"]) != nil  {
                            string = "\(responseData.value!["address"])"
                        }else if (responseData.value?["state"]) != nil  {
                            string = "\(responseData.value!["state"])"
                        }else if (responseData.value?["country"]) != nil  {
                            string = "\(responseData.value!["country"])"
                        }else if (responseData.value?["confirm_password"]) != nil  {
                            string = "\(responseData.value!["confirm_password"])"
                        }
                        
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["Status"] == "200") {
                    if  isShowAlert{
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "04") {
                    if isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller: controller)
                } else {
                    SwiftLoader.hide()
                    response(responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR AT API REQUET WITH ENDPOINT SIGN: \(error.localizedDescription)")
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    
    // MARK: - Public Methods
    static func apiRequestWithEndPointMockUp1(_ endpoint: Endpoint,
                                              params: [String: AnyObject]? = nil,
                                              isShowAlert : Bool,
                                              controller:UIViewController,
                                              isNeedToken: Bool = true,
                                              response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        header = ["Content-Type":"application/json"]
        if isNeedToken {
            guard let token = DefaultManager().getToken() else {
                debugPrint("Token not set")
                return
            }
            header = ["authorization": "Bearer"]
            debugPrint("Token: \(token)")
        }
        // These log added by Ravi
        print("API Requrest URL========> \(String(describing: url?.absoluteString))")
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
        manager.request(url!,
                        method: endpoint.method,
                        parameters: finalParams,
                        encoding: endpoint.encoding,
                        headers: header).apiResponseJSON { responseData in
                            print ("\n")
                            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
                            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
                            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
                            print("Request===> \(responseData.request!)")
                            print("Response data:===> \(JSON(responseData.data!) )")
                            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
                            print ("\n")
                            DispatchQueue.main.async {
                                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            }
                            switch responseData.result {
                            case .success:
                                SwiftLoader.hide()
                           
                                if (responseData.value!["status"] == 200) {
                                    response (responseData)
                                    SwiftLoader.hide()
                                    if responseData.value!["ResponseData"].dictionary != nil {
                                        // response (responseData)
                                    }
                                } else if (responseData.response?.statusCode == 201){
                                    response (responseData)
                                    SwiftLoader.hide()
                                    if responseData.value!["ResponseData"].dictionary != nil {
                                        // response (responseData)
                                    }
                                } else if  (responseData.response?.statusCode == 400) {
                                    SwiftLoader.hide()
                                    if  isShowAlert{
                                        SwiftLoader.hide()
                                        let string = "\(responseData.value!["email"])"
                                        let badchar = CharacterSet(charactersIn: "\"[]")
                                        let cleanedstring = string.components(separatedBy: badchar).joined()
                                        Utility.alertContoller(stayle: .alert, title: "", message: cleanedstring, actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                    }
                                } else if (responseData.value!["Status"] == "200") {
                                    if  isShowAlert {
                                        SwiftLoader.hide()
                                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                    }
                                } else if (responseData.value!["StatusCode"] == "04") {
                                    if  isShowAlert {
                                        SwiftLoader.hide()
                                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                    }
                                    Utility.logoutAction(controller:controller)
                                } else {
                                    SwiftLoader.hide()
                                    response (responseData)
                                    SwiftLoader.hide()
                                    if responseData.value!["ResponseData"].dictionary != nil {
                                        // response (responseData)
                                    }
                                }
                            case .failure(let error):
                                print("ERROR AT API REQUET WITH ENDPOINT MOCKUP 1: \(error.localizedDescription)")
                                if  isShowAlert{
                                    SwiftLoader.hide()
                                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                                }
                                break
                            }
        }
    }
    
    // MARK: - Public Methods
    static func apiRequestWithEndPointMockUp(_ endpoint: Endpoint,
                                             params: [String: AnyObject]? = nil,
                                             isShowAlert: Bool,
                                             controller: UIViewController,
                                             isNeedToken: Bool = true,
                                             response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatestMockUp)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        header = ["Content-Type":"application/json"]
        if isNeedToken {
            guard let token = DefaultManager().getToken() else {
                debugPrint("Token not set")
                return
            }
            header = ["authorization": "Bearer"]
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
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                
                if  (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if  (responseData.response?.statusCode == 201) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if  (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        let string = "\(responseData.value!["email"])"
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message: cleanedstring, actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "03") {
                    if  isShowAlert{
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    
                } else if (responseData.value!["StatusCode"] == "04") {
                    if  isShowAlert{
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller:controller)
                } else {
                    SwiftLoader.hide()
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil{
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR AT API REQUET WITH ENDPOINT MOCKUP: \(error.localizedDescription)")
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    
    static func upload(_ endpoint: Endpoint, params: [String: AnyObject]? = nil,isShowAlert: Bool, controller: UIViewController, isNeedToken: Bool = true,fileName: String?, binary: Data,respon: @escaping (_ status: Bool) -> Void) {
        var header: HTTPHeaders = HTTPHeaders()
      //  let auth = userDefault.object(forKey:"token") as! String
        header = ["Content-Type":"multipart/form-data",]
    
        if isNeedToken {
            guard let token = DefaultManager().getToken() else {
                debugPrint("TOKEN NOT SET")
                return
            }
            debugPrint("Token111: \(token)")
        }
        var url: URL?
        url = URL(string:baseURLLatest)?.URLByAppendingEndpoint(endpoint)

        print("API Requrest URL========> \(String(describing: url?.absoluteString ) )")
        print ("parameter = \(String(describing: params))")
        print ("header = \(header)")
        print ("fileName = \(String(describing: fileName))")
        print ("method = \(endpoint.method.rawValue)")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let mimeType = "*/*"
            if let meta = params {
                for (key , datainfo) in meta{
                    multipartFormData.append((datainfo as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
            }
            multipartFormData.append(_: binary, withName: "profile_logo", fileName: fileName ?? "profile_logo", mimeType: mimeType)
        }, usingThreshold: UInt64.init(), to: url ?? "", method: endpoint.method, headers: header, encodingCompletion: { (result) in
            debugPrint("UPLOAD FILE RESULT FROM API UPLOAD METHOD: \(result)")
            switch result {
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        SwiftLoader.hide()
                        response.response?.statusCode
                        let json = JSON.init(value)
                        respon(true)
                        print("PRINTING JSON FROM API UPLOAD METHOD: \(json)")
                        break
                    case .failure(let error):
                        SwiftLoader.hide()
                        respon(false)
                        break
                    }
                })
                break
            case .failure(let error):
                SwiftLoader.hide()
                respon(false)
                break
            }
        })
    }
    
    
    
    
    // // MARK: - Register User
    static func apiRequestWithEndPointUploadProfile(_ endpoint: Endpoint,
                                               params: [String: AnyObject]? = nil,
                                               isShowAlert: Bool,
                                               controller: UIViewController,
                                               isNeedToken: Bool = true,
                                               response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header = HTTPHeaders()
        header = ["Content-Type" : "application/json"]
        if isNeedToken {
            guard let token = DefaultManager().getToken() else {
                print("Token not set")
                return
            }
        }
        
        print("API Requrest URL========> \(String(describing: url?.absoluteString))")
        print ("parameter = \(finalParams)")
        print ("header = \(header)")
        print ("method = \(endpoint.method.rawValue)")
        do {
            let jsonData = (try? JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted))
            print ("method = \(String(bytes: jsonData!, encoding: .utf8) ?? "Test")")
        } catch {
            print("Error")
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            
            print("statusCode - \(responseData.response?.statusCode)")
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                
                if (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 201) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                } else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        
                        var string =  ""
                        
                        if (responseData.value?["email"]) != nil {
                            string = "\(responseData.value!["email"])"
                        }
                        
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
            case .failure(let error):
                print("ERROR AT API REQUET WITH ENDPOINT SIGN: \(error.localizedDescription)")
                if  isShowAlert{
                    SwiftLoader.hide()
                    Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    
    
    static func apiRequestWithEndPointUpdateProfile(_ endpoint: Endpoint,
                                           params: [String: AnyObject]? = nil,
                                           isShowAlert: Bool,
                                           controller: UIViewController,
                                           isNeedToken: Bool = true,
                                           response: @escaping (DataResponse<JSON>) -> Void) {
    
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        let auth = DefaultManager().getToken() ?? ""
        header = ["Content-Type":"application/json","authorization": "Bearer " + auth]
        header = ["Content-Type":"application/json","Accept": "application/json"]
        
         header = ["authorization": "Bearer " + auth]
        if isNeedToken {
             guard let token = DefaultManager().getToken() else {
                debugPrint("Token not set")
                return
             }
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
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            // print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print("Response Code -> \(responseData.response?.statusCode)")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                if  (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        //response (responseData)
                    }
                } else if  (responseData.response?.statusCode == 201){
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                }
                    
                else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        
                        var string =  ""
                        
                        if (responseData.value?["email"]) != nil {
                            string = "\(responseData.value!["email"])"
                        }
                        if (responseData.value?["msg"]) != nil {
                            string = "\(responseData.value!["msg"])"
                        }
                        if (responseData.value?["non_field_errors"]) != nil {
                            string = "\(responseData.value!["non_field_errors"])"
                        }
                        
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
                    
                    
                else if (responseData.value!["Status"] == "200") {
                    if isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "04") {
                    if  isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller: controller)
                } else {
                    SwiftLoader.hide()
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil{
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR WITH API REQUEST: \(error.localizedDescription)")
                if  isShowAlert {
                    SwiftLoader.hide()
                    // Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    // API Call with authentcation
    
    static func apiRequestWithEndPointSomeAuth(_ endpoint: Endpoint,
                                           params: [String: AnyObject]? = nil,
                                           isShowAlert: Bool,
                                           controller: UIViewController,
                                           isNeedToken: Bool = true,
                                           response: @escaping (DataResponse<JSON>) -> Void) {
        // start loading indicator
        DispatchQueue.main.async {
            //let activityData = ActivityData()
            //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        }
        var url: URL?
        url = URL(string: baseURLLatest)?.URLByAppendingEndpoint(endpoint)
        let finalParams = (params == nil) ? [String: AnyObject]() : params!
        var header: HTTPHeaders = HTTPHeaders()
        let auth =  DefaultManager().getToken() ?? ""
       // header = ["Content-Type":"application/json","authorization": "Bearer " + auth]
        header = ["Content-Type":"application/json","Accept": "application/json","authorization": "Bearer " + auth]
        
        
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
        manager.request(url!, method: endpoint.method, parameters: finalParams, encoding: endpoint.encoding, headers: header).apiResponseJSON { responseData in
            print ("\n")
            print("Headers===> \(String(describing: responseData.request!.allHTTPHeaderFields))")
            print("HTTP Method===> \(String(describing: responseData.request!.httpMethod))")
            print("HTTP Body===> \(String(describing: responseData.request!.httpBody))")
            print("Request===> \(responseData.request!)")
            print("Response data:===> \(JSON(responseData.data!) )")
            // print ("method = \(String(bytes: responseData.data!, encoding: String.Encoding.utf8) ?? "Test")")
            print("Response Code -> \(responseData.response?.statusCode)")
            print ("\n")
            DispatchQueue.main.async {
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            switch responseData.result {
            case .success:
                SwiftLoader.hide()
                if  (responseData.value!["status"] == 200) {
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        //response (responseData)
                    }
                } else if  (responseData.response?.statusCode == 201){
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil {
                        // response (responseData)
                    }
                }
                    
                else if (responseData.response?.statusCode == 400) {
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()
                        
                        var string =  ""
 
                        if (responseData.value?["email"]) != nil {
                            string = "\(responseData.value!["email"])"
                        }
                        if (responseData.value?["msg"]) != nil {
                            string = "\(responseData.value!["msg"])"
                        }
                        if (responseData.value?["non_field_errors"]) != nil {
                            string = "\(responseData.value!["non_field_errors"])"
                        }
                        
                        let badchar = CharacterSet(charactersIn: "\"[]")
                        let cleanedstring = string.components(separatedBy: badchar).joined()
                        Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
 
                         
                    }
                }
                else if(responseData.response?.statusCode == 401 ){
                    
                    SwiftLoader.hide()
                    if  isShowAlert{
                        SwiftLoader.hide()

                         var string =  ""
                        
                         if (responseData.value?["detail"]) != nil {
                         string = "\(responseData.value!["detail"])"
                         }
                         if (responseData.value?["msg"]) != nil {
                         string = "\(responseData.value!["msg"])"
                         }
                         if (responseData.value?["non_field_errors"]) != nil {
                         string = "\(responseData.value!["non_field_errors"])"
                         }
                        
                         let badchar = CharacterSet(charactersIn: "\"[]")
                         let cleanedstring = string.components(separatedBy: badchar).joined()
                         Utility.alertContoller(stayle: .alert, title: "", message:cleanedstring , actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                }
                    
                    
                else if (responseData.value!["Status"] == "200") {
                    if isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: "\(responseData.value!["Message"])", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                } else if (responseData.value!["StatusCode"] == "04") {
                    if  isShowAlert {
                        SwiftLoader.hide()
                        Utility.alertContoller(stayle: .alert, title: "", message: NSLocalizedString("k_session_expired_message", comment: ""), actionTitle1: NSLocalizedString("kOk", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                    }
                    Utility.logoutAction(controller: controller)
                } else {
                    SwiftLoader.hide()
                    response (responseData)
                    SwiftLoader.hide()
                    if responseData.value!["ResponseData"].dictionary != nil{
                        // response (responseData)
                    }
                }
            case .failure(let error):
                print("ERROR WITH API REQUEST: \(error.localizedDescription)")
                if  isShowAlert {
                    SwiftLoader.hide()
                    // Utility.alertContoller(stayle: .alert, title: "", message: "\(error.localizedDescription)", actionTitle1: NSLocalizedString("Ok", comment: ""), actionTitle2: "", firstAction:nil, secondAction:nil  , controller: controller)
                }
                break
            }
        }
    }
    
    
    
    
}

