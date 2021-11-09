//
//  DataRequest.swift
//  Samscloud
//
//  Created by Chetu Mac on 16/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//
import Alamofire
import SwiftyJSON
import Foundation

extension DataRequest {
    
    static func apiResponseSerializer() -> DataResponseSerializer<JSON> {
        return DataResponseSerializer { _, response, data, error in
            if let err = error {
                return .failure(err)
            }
            guard let responseData = data else {
                let reason = "Data could not be serialized. Input data was nil."
                return .failure(NSError(domain: "com.ztc.chatroom", code: 1001, userInfo: [NSLocalizedDescriptionKey: reason]))
            }
            do { let result = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                return sanitizeError(JSON(result))
            } catch let error as NSError {
                return .failure(error)
            }
        }
    }
    
    static func sanitizeError(_ json: JSON) -> Result<JSON> {
        if json["ReturnCodeKey"].intValue == 0 {
            return .success(json)
        }
        let error = NSError(domain: "com.samsclud", code: json["ReturnCodeKey"].intValue, userInfo: [NSLocalizedDescriptionKey: json["ReturnCodeKey"].stringValue])
        return .failure(error)
    }
    
    @discardableResult func apiResponseJSON(completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.apiResponseSerializer(), completionHandler: completionHandler)
    }
    
    
}
