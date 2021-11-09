//
//  ConnectionManager.swift
//  Samscloud
//
//  Created by Akhilesh Singh on 05/08/19.
//  Copyright © 2019 Subcodevs All rights reserved.
//

import Foundation
import SwiftyJSON

class ConnectionManager: NSObject{
    
    static let sharedInstance = ConnectionManager()
    
    func postAuth(params : NSMutableArray, url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject?) -> ()) {
        //create the url with NSURL
        let url = NSURL(string: url)
        //create the session object
        let session = URLSession.shared
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
         let auth =  DefaultManager().getToken() ?? ""
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + auth, forHTTPHeaderField: "authorization")
        
        print("Request \(request)")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                postCompleted(false, nil)
                return
            }
            guard let data = data else {
                postCompleted(false, nil)
                return
            }
            
            guard let repsosneJSON = try? JSON.init(data: data) else {
                postCompleted(false, nil)
                return
            }
            
            postCompleted(true, repsosneJSON as AnyObject)
        })
        
        task.resume()
    }
    
    
    
    func POSTApi(params:NSMutableArray, _ url:String , postCompleted : @escaping (_ jsonData:JSON? , _ error:Error?, _ statuscode : Int?) -> ()) {
        
        let session = URLSession.shared
        guard var request = self.buildRequest(str: url) else {return}
        request.httpMethod = "POST"
        
        if let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            request.httpBody = data
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            let code = (response as? HTTPURLResponse)?.statusCode
            guard error == nil else {
                DispatchQueue.main.async {
                   postCompleted(nil, error,code)
                }
                
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    postCompleted(nil, error,code)
                }
                
                return
            }
            
            guard let repsosneJSON = try? JSON.init(data: data) else {
                DispatchQueue.main.async {
                    if code == 401 {
                        refreshToken { (msg) in
                            if msg == "success" {
                                self.POSTApi(params: params, url, postCompleted: postCompleted)
                            }
                        }
                        return
                    }
                    postCompleted(false, nil,code)
                }
                
                return
            }
            DispatchQueue.main.async {
                postCompleted(repsosneJSON, nil,code)
            }
            
        })
        
        task.resume()
    }
    
    func GET(url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject) -> ()) {
        
        //create the url with NSURL
        let url = NSURL(string: url)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET" //set http method as POST
        
        //  print(" UUID : \(String(describing: uuid ))")
        
        //HTTP Headers
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print(json)
                    // handle json...
                    postCompleted(true, json as AnyObject)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    
    func post(params : Dictionary<String, Dictionary<String, AnyObject>>, url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject) -> ()) {
        
        //create the url with NSURL
        let url = NSURL(string: url)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //   print(" UUID : \(String(describing: uuid ))")
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            print("Entered the completionHandler")
            print("Response JSON:\n\(String(data: data!, encoding: String.Encoding.utf8)!)")
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print(json)
                    // handle json...
                    postCompleted(true, json as AnyObject)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    

    func getApiHit(url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject) -> ()) {
        
        //create the url with NSURL
        let url = NSURL(string: url)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET" //set http method as POST
        
        //  print(" UUID : \(String(describing: uuid ))")
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        //create dataTask using the session object to send data to the server
           let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                print("Response JSON:\n\(String(data: data!, encoding: String.Encoding.utf8)!)")
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                
                guard let repsosneJSON = try? JSON.init(data: data) else {
                    return
                }
                
                postCompleted(true, repsosneJSON as AnyObject)
            
        })
        
        task.resume()
    }
    
    
    func getApiHitAuth(url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject) -> ()) {
        //create the url with NSURL
        let url = NSURL(string: url)
        //create the session object
        let session = URLSession.shared
    
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET" //set http method as POST

        //HTTP Headers
        let auth = DefaultManager().getToken() ?? ""
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + auth, forHTTPHeaderField: "authorization")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print(json)
                    postCompleted(true, json as AnyObject)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    
    func PUT(params : Dictionary<String, Dictionary<String, AnyObject>>,url : String , postCompleted : @escaping (_ succeeded: Bool, _ result: AnyObject) -> ()) {
        
        //create the url with NSURL
        let url = NSURL(string: url)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "PUT" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //  print(" UUID : \(String(describing: uuid ))")
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    print(json)
                    // handle json...
                    postCompleted(true, json as AnyObject)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    
    
    
    
    func buildRequest(str:String) ->URLRequest? {
        guard let url = URL.init(string: str) else {return nil}
        let request = NSMutableURLRequest(url: url as URL)
        let auth = DefaultManager().getToken() ?? ""
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + auth, forHTTPHeaderField: "authorization")
        return request as URLRequest
    }
}

