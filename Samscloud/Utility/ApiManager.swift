//
//  ApiManager.swift
//  
//
//  Created by Irshad Ahmad on 06/03/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import  Photos


/// common header to pass in HTTP Requets....
func header()->[String:String] {
    
    var header : [String: String] = [
        "Accept"       : "application/json",
        "Content-Type" : "application/json"
    ]
    
    if let token = DefaultManager().getToken() {
        header["Authorization"] = "Bearer \(token)"
    }
    print("Header :---: ",JSON.init(header))
    return header
}


extension JSON{
    func isKeyPresent()->Bool {
        if self == nil || self.null != nil{
            return false
        }
        return true
    }
}


let APIsHandler = ApiManager.shared

public protocol JSONDecodable{
    init(json:JSON)
}





extension Collection where Iterator.Element == JSON {
    func decode<T:JSONDecodable>() -> [T] {
        return map({T(json:$0)})
    }
    
    func arrayDict() ->[[String:Any]]{
        var items:[[String:Any]] = []
        self.forEach({
            if let obj = $0.dictionaryObject {
               items.append(obj)
            }
        })
        return items
    }
    
    func arrayString() ->[String]{
        
        var items:[String] = []
        
        self.forEach({ items.append($0.stringValue) })
        
        return items
    }

}





extension Collection where Iterator.Element == [String:Any] {
    
    
}


/**
 This is a singelton class used for managing all http request.....
 */
class ApiManager {
    static let shared = ApiManager.init()
    
    private init() {}
    
    /// POST Metod using JSON Encoding...
    func POSTApi(_ url: String, param: [String: Any]?, header : [String : String]?,  completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        
       let request = Alamofire.request(url, method: .post, parameters: param , encoding: JSONEncoding.prettyPrinted, headers: header)
       
        request.responseJSON{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POST url: ", url)
                print("POSTApi Error : ",error )
                print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")

                if dataResponse.response?.statusCode == 401 {
                    refreshToken { (msg) in
                        if msg == "success" {
                            self.POSTApi(url, param: param, header: Samscloud.header(), completion: completion)
                        }
                    }
                    return
                }
                completion(nil , error , dataResponse.response?.statusCode)
                return
            }
            if dataResponse.result.value != nil{
                if dataResponse.response?.statusCode == 401 {
                    refreshToken { (msg) in
                        if msg == "success" {
                            self.POSTApi(url, param: param, header: Samscloud.header(), completion: completion)
                        }
                    }
                    return
                }
                let json = JSON.init(dataResponse.result.value!)
                completion(json , nil, dataResponse.response?.statusCode)
            }else{
                completion(nil , nil,dataResponse.response?.statusCode)
            }
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
 }
    
    
    
      func PATCHApi(_ url: String, param: [String: Any]?, header : [String : String]?,  completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
           
          let request = Alamofire.request(url, method: .patch, parameters: param , encoding: JSONEncoding.prettyPrinted, headers: header)
          
           request.responseJSON{ (dataResponse) in
               guard dataResponse.result.isSuccess else {
                   let error = dataResponse.result.error!
                   print("POST url: ", url)
                   print("POSTApi Error : ",error )
                   print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")

                   if dataResponse.response?.statusCode == 401 {
                       refreshToken { (msg) in
                           if msg == "success" {
                               self.POSTApi(url, param: param, header: Samscloud.header(), completion: completion)
                           }
                       }
                       return
                   }
                   completion(nil , error , dataResponse.response?.statusCode)
                   return
               }
               if dataResponse.result.value != nil{
                   if dataResponse.response?.statusCode == 401 {
                       refreshToken { (msg) in
                           if msg == "success" {
                               self.POSTApi(url, param: param, header: Samscloud.header(), completion: completion)
                           }
                       }
                       return
                   }
                   let json = JSON.init(dataResponse.result.value!)
                   completion(json , nil, dataResponse.response?.statusCode)
               }else{
                   completion(nil , nil,dataResponse.response?.statusCode)
               }
               print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
           }
    }
    
    
    /// POST Metod using String Encoding...
    func POSTStringApi(_ url: String, param: [String: Any]?, header : [String : String]?,  completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int? )->()) {
        
        print("Header------>>>>>",header ?? "")
        _ =  Alamofire.request(url, method: .post, parameters: param , encoding: JSONEncoding.default, headers: header).responseString{ (dataResponse) in
            
            
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POST url: ", url)
                print("POSTApi Error : ",error )
                print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
                completion(nil , error , dataResponse.response?.statusCode)
                return
            }
            if dataResponse.result.value != nil{
                let json = JSON.init(dataResponse.result.value!)
                completion(json , nil, dataResponse.response?.statusCode)
            }else{
                completion(nil , nil,dataResponse.response?.statusCode)
            }
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    /// GET Metod using JSON Encoding...
    func GETApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        let request = Alamofire.request(url, method: .get, parameters: param , encoding: URLEncoding.default, headers: header)
        
        request.responseJSON { (dataResponse) in
            
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("GETApi Error : ",error )
                print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
                if dataResponse.response?.statusCode == 401 {
                    refreshToken { (msg) in
                        if msg == "success" {
                            self.GETApi(url, param: param, header: Samscloud.header(), completion: completion)
                        }
                    }
                    return
                }
                completion(nil , error, dataResponse.response?.statusCode)
                return
            }
            if dataResponse.result.value != nil{
                if dataResponse.response?.statusCode == 401 {
                    refreshToken { (msg) in
                        if msg == "success" {
                            self.GETApi(url, param: param, header: Samscloud.header(), completion: completion)
                        }
                    }
                    return
                }
                let json = JSON.init(dataResponse.result.value!)
                completion(json , nil,dataResponse.response?.statusCode)
            }else{
                completion(nil , nil,dataResponse.response?.statusCode)
            }
            print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
      
    }
   
    
    /// GET Metod using String Encoding...
    func GETStringApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        let request = Alamofire.request(url, method: .get, parameters: param , encoding: URLEncoding.default, headers: header)
        
        request.responseString { (dataResponse) in
            
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("GETApi Error : ",error )
                completion(nil , error, dataResponse.response?.statusCode)
                return
            }
            if dataResponse.result.value != nil{
                let json = JSON.init(dataResponse.result.value!)
                DispatchQueue.main.async {
                  completion(json , nil,dataResponse.response?.statusCode)
                }
            }else{
                DispatchQueue.main.async {
                  completion(nil , nil,dataResponse.response?.statusCode)
                }
            }
            print("GETApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    
    /// PUT Metod using JSON Encoding...
    func PUTApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        Alamofire.request(url, method: .put, parameters: param, encoding:JSONEncoding.default, headers: header)
            .responseJSON { (dataResponse) in
                debugPrint(dataResponse.timeline)
                guard dataResponse.result.isSuccess else {
                    let error = dataResponse.result.error!
                    print("PUTApi Error : ",error )
                    print("URL is --->>>",dataResponse.request?.url?.absoluteString)
                    if dataResponse.response?.statusCode == 401 {
                        refreshToken { (msg) in
                            if msg == "success" {
                                self.PUTApi(url, param: param, header: Samscloud.header(), completion: completion)
                            }
                        }
                        return
                    }
                    completion(nil , error, dataResponse.response?.statusCode)
                    return
                }
                if dataResponse.result.value != nil{
                    if dataResponse.response?.statusCode == 401 {
                        refreshToken { (msg) in
                            if msg == "success" {
                                self.PUTApi(url, param: param, header: Samscloud.header(), completion: completion)
                            }
                        }
                        return
                    }
                    let json = JSON.init(dataResponse.result.value!)
                    completion(json , nil,dataResponse.response?.statusCode)
                }else{
                    completion(nil , nil,dataResponse.response?.statusCode)
                }
                print("PUTApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    
    
    /// DELETE Metod using JSON Encoding...
    func DELETEApi(_ url: String , param: [String: Any]?, header : [String : String]? , completion:@escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?)->()){
        Alamofire.request(url, method: .delete, parameters: param, encoding:JSONEncoding.default, headers: header)
            .responseJSON { (dataResponse) in
                debugPrint(dataResponse.timeline)
                guard dataResponse.result.isSuccess else {
                    let error = dataResponse.result.error!
                    print("DELETE Api Erstatuscoderor : ",dataResponse.response?.statusCode ?? "")
                    if dataResponse.response?.statusCode == 401 {
                        refreshToken { (msg) in
                            if msg == "success" {
                                self.DELETEApi(url, param: param, header: Samscloud.header(), completion: completion)
                            }
                        }
                        return
                    }
                    completion(nil , error, dataResponse.response?.statusCode)
                    return
                }
                if dataResponse.result.value != nil{
                    if dataResponse.response?.statusCode == 401 {
                        refreshToken { (msg) in
                            if msg == "success" {
                                self.DELETEApi(url, param: param, header: Samscloud.header(), completion: completion)
                            }
                        }
                        return
                    }
                    let json = JSON.init(dataResponse.result.value!)
                    completion(json , nil,dataResponse.response?.statusCode)
                }else{
                    completion(nil , nil,dataResponse.response?.statusCode)
                }
                print("DELETEApi statuscode : ",dataResponse.response?.statusCode ?? "")
        }
    }
    

    func CreatePost(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
              multipartFormData.append(data!, withName: "image", fileName: fileName, mimeType: "*/*")
            }
            let content = (parames["content"] as! String).data(using:.utf8)
            multipartFormData.append(content!, withName: "content")
            let place = (parames["place"] as! String).data(using:.utf8)
            multipartFormData.append(place!, withName: "place")
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }

    
    
    func UploadPhoto(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:JSON?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
                multipartFormData.append(data!, withName: "profile_logo", fileName: fileName, mimeType: "*/*")
            }
            
            parames.forEach({
                if let value = $0.value as? String, let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: $0.key)
                }
            })
            
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    func SendMessage(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
                multipartFormData.append(data!, withName: "image", fileName: fileName, mimeType: "*/*")
            }
            let to_id = (parames["to_id"] as! String).data(using:.utf8)
            multipartFormData.append(to_id!, withName: "to_id")
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    
    func AddCompany(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
                multipartFormData.append(data!, withName: "logo", fileName: fileName, mimeType: "*/*")
            }
            let name = (parames["name"] as! String).data(using:.utf8)
            multipartFormData.append(name!, withName: "name")
            let country_id = (parames["country_id"] as! String).data(using:.utf8)
            multipartFormData.append(country_id!, withName: "country_id")
            let field_id = (parames["field_id"] as! String).data(using:.utf8)
            multipartFormData.append(field_id!, withName: "field_id")
            let phone = (parames["phone"] as! String).data(using:.utf8)
            multipartFormData.append(phone!, withName: "phone")
            let url = (parames["url"] as! String).data(using:.utf8)
            multipartFormData.append(url!, withName: "url")
            let bio = (parames["bio"] as! String).data(using:.utf8)
            multipartFormData.append(bio!, withName: "bio")
            if let id = parames["company_id"] as? String {
                let company_id = id.data(using:.utf8)
                multipartFormData.append(company_id!, withName: "company_id")
            }
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    
    func AddUser(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
                multipartFormData.append(data!, withName: "image", fileName: fileName, mimeType: "*/*")
            }
            let name = (parames["name"] as! String).data(using:.utf8)
            multipartFormData.append(name!, withName: "name")
            let country_id = (parames["country_id"] as! String).data(using:.utf8)
            multipartFormData.append(country_id!, withName: "country_id")
            let phone = (parames["phone"] as! String).data(using:.utf8)
            multipartFormData.append(phone!, withName: "phone")
            let position = (parames["position"] as! String).data(using:.utf8)
            multipartFormData.append(position!, withName: "position")
            let bio = (parames["bio"] as! String).data(using:.utf8)
            multipartFormData.append(bio!, withName: "bio")
            if let id = parames["user_id"] as? String {
                let user_id = id.data(using:.utf8)
                multipartFormData.append(user_id!, withName: "user_id")
            }
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    
    func AddEvent(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
                multipartFormData.append(data!, withName: "image", fileName: fileName, mimeType: "*/*")
            }
            let name = (parames["name"] as! String).data(using:.utf8)
            multipartFormData.append(name!, withName: "name")
            let country_id = (parames["country_id"] as! String).data(using:.utf8)
            multipartFormData.append(country_id!, withName: "country_id")
            let place = (parames["place"] as! String).data(using:.utf8)
            multipartFormData.append(place!, withName: "place")
            let time = (parames["time"] as! String).data(using:.utf8)
            multipartFormData.append(time!, withName: "time")
            let description = (parames["description"] as! String).data(using:.utf8)
            multipartFormData.append(description!, withName: "description")
            if let id = parames["event_id"] as? String {
                let event_id = id.data(using:.utf8)
                multipartFormData.append(event_id!, withName: "event_id")
            }
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    
    
    func UpdateProfile(_ url :String , _ data:Data?, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if data != nil {
              multipartFormData.append(data!, withName: "image", fileName: fileName, mimeType: "*/*")
            }
        
            let phone = (parames["phone"] as! String).data(using:.utf8)
            multipartFormData.append(phone!, withName: "phone")
            let name = (parames["name"] as! String).data(using:.utf8)
            multipartFormData.append(name!, withName: "name")
            let bio = (parames["bio"] as! String).data(using:.utf8)
            multipartFormData.append(bio!, withName: "bio")
            let country_id = (parames["country_id"] as! String).data(using:.utf8)
            multipartFormData.append(country_id!, withName: "country_id")
            let field_id = (parames["field_id"] as! String).data(using:.utf8)
            multipartFormData.append(field_id!, withName: "field_id")
            let position = (parames["position"] as! String).data(using:.utf8)
            multipartFormData.append(position!, withName: "position")

        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    func addOppurtinity(_ url :String , _ data:Data, _ fileName:String , _ parames:[String:Any] , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: fileName, mimeType: "*/*")
            let name = (parames["name"] as! String).data(using:.utf8)
            multipartFormData.append(name!, withName: "name")
            let field_id = (parames["field_id"] as! String).data(using:.utf8)
            multipartFormData.append(field_id!, withName: "field_id")
            let country_id = (parames["country_id"] as! String).data(using:.utf8)
            multipartFormData.append(country_id!, withName: "country_id")
            let requirements = (parames["requirements"] as! String).data(using:.utf8)
            multipartFormData.append(requirements!, withName: "requirements")
            let description = (parames["description"] as! String).data(using:.utf8)
            multipartFormData.append(description!, withName: "description")
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async {
                                            
                                        }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    func UPLOADTeamLogo(_ url :String , _ data:Data, _ fileName:String , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:Any?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: fileName, mimeType: "*/*")
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.put,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async { }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        let json = JSON.init(response.result.value!)
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        DispatchQueue.main.async {
                                            
                                        }
                                        
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                DispatchQueue.main.async {
                                    
                                }
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    
    
    
    func PATCHStreamThumb(_ url :String , _ data:Data, _ fileName:String , header:[String:String]? , completion:@escaping (_ error:Error? , _ responce:JSON?,_ statuscode :Int?)->())  {
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data, withName: "stream_thumbnail", fileName: fileName, mimeType: "*/*")
            multipartFormData.append("ACTIVE_SHOOTER".data(using: .utf8)!, withName: "emergency_message")
            multipartFormData.append(true.description.data(using: .utf8)!, withName: "is_started")
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:.patch,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    guard response.result.isSuccess else {
                                        let error = response.result.error
                                        DispatchQueue.main.async { }
                                        completion(error , nil,response.response?.statusCode)
                                        return
                                    }
                                    if response.result.value != nil{
                                        if response.response?.statusCode == 401 {
                                            refreshToken { (msg) in
                                                if msg == "success" {
                                                    self.PATCHStreamThumb(url, data, fileName, header: Samscloud.header(), completion: completion)
                                                }
                                            }
                                            return
                                        }
                                        let json = JSON.init(response.result.value!)
                                        completion(nil , json,response.response?.statusCode)
                                    }else{
                                        completion(nil , nil,response.response?.statusCode)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completion(encodingError , nil,nil)
                            }
        })
    }
    
    
    func loadImage(_ url:String)  ->UIImage?{
        var image:UIImage?
        print(url)
        Alamofire.download(url)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.result.value {
                    image =  UIImage(data: data)
                }
        }
        return image
    }
    
    func downloadMedia(url:String,completion:@escaping (_ error:Error? , _ fileURL:URL?)->()){
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
            
            }).response(completionHandler: { (responseData) in
                if let err = responseData.error {
                    completion(err, responseData.destinationURL)
                }else if let downloadedPath = responseData.destinationURL {
                    completion(nil, downloadedPath)
                }
            })
    }
    
}



func saveVideoInGallery(awsUrl:String) {
    
    APIsHandler.downloadMedia(url: awsUrl) { (error, path) in
        if let url = path {
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { (completed, error) in
                if completed {
                    print("Video is saved!")
                    DispatchQueue.main.async {
                       UIApplication.topViewController()?.showMessage("File Saved Successfuly")
                    }
                }else {
                    DispatchQueue.main.async {
                        let err = error?.localizedDescription ?? ""
                       UIApplication.topViewController()?.showMessage(err)
                    }
                }
            }
        }
    }
}
