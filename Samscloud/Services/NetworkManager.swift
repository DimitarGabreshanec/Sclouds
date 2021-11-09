//
//  NetworkManager.swift
//  FuelCred
//
//  Created by Shahzeb Khan on 4/15/19.
//  Copyright © 2019 Shahzeb Khan. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    func post(
        _ path: String,
        params: [String: Any]?,
        headers: [String: String],
        successCallback: @escaping (_ response: [String: AnyObject]?) -> Void,
        failureCallback: @escaping (_ statusCode: Int?, _ errors: [String]?) -> Void) {
        
        NetworkSession.shared.manager.request(
            self.currentEnvironmentBaseURL + path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
               let json = data as? [String: AnyObject]
               successCallback(json)
            case .failure(_):
                let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject]
                failureCallback(response.response?.statusCode ?? 500, json??["errors"] as? [String])
            }
        }
    }
    
    @discardableResult
    func get(
        _ path: String,
        params: [String: Any]?,
        headers: [String: String],
        successCallback: @escaping (_ response: Any?) -> Void,
        failureCallback: @escaping (_ statusCode: Int?, _ errors: [String]?) -> Void) -> Request {
        
        return NetworkSession.shared.manager.request(
            self.currentEnvironmentBaseURL + path,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                successCallback(data)
            case .failure(_):
                let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject]
                failureCallback(response.response?.statusCode ?? 500, json??["errors"] as? [String])
            }
        }
    }
    
    func put(
        _ path: String,
        params: [String: Any]?,
        headers: [String: String],
        successCallback: @escaping (_ response: [String: AnyObject]?) -> Void,
        failureCallback: @escaping (_ statusCode: Int?, _ errors: [String]?) -> Void) {
        
        NetworkSession.shared.manager.request(
            self.currentEnvironmentBaseURL + path,
            method: .put,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = data as? [String: AnyObject]
                successCallback(json)
            case .failure(_):
                let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject]
                failureCallback(response.response?.statusCode ?? 500, json??["errors"] as? [String])
            }
        }
    }
    
    func delete(
        _ path: String,
        params: [String: Any]?,
        headers: [String: String],
        successCallback: @escaping (_ response: [String: AnyObject]?) -> Void,
        failureCallback: @escaping (_ statusCode: Int?, _ errors: [String]?) -> Void) {
        
        NetworkSession.shared.manager.request(
            self.currentEnvironmentBaseURL + path,
            method: .delete,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = data as? [String: AnyObject]
                successCallback(json)
            case .failure(_):
                let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: AnyObject]
                failureCallback(response.response?.statusCode ?? 500, json??["errors"] as? [String])
            }
        }
    }
    
    func download(_ fullPath: String, progressCallback: @escaping (Int64, Int64) -> Void, completionCallback: @escaping (URL?) -> Void) {
        var localURL: URL?
        Alamofire.download(
            fullPath,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: { temporaryURL, response in
                let directoryURL = FileManager.cachesURL
                let pathComponent = response.suggestedFilename
                localURL = directoryURL.appendingPathComponent(pathComponent!)
                return (localURL!, [])
            }
        ).downloadProgress(closure: { progress in
            print("Download Progress: \(100*progress.completedUnitCount/progress.totalUnitCount)")
            progressCallback(progress.completedUnitCount, progress.totalUnitCount)
        }).validate().responseJSON { response in
            if let url = localURL, FileManager.default.fileExists(atPath: url.path) {
                print("Successfully downloaded file to \(url)")
                completionCallback(url)
            } else {
                print("Failed to download file.")
                completionCallback(nil)
            }
        }
    }
    
    func upload(
        path: String,
        reportID: Int,
        photos: [URL],
        videos: [URL],
        headers: [String: String],
        success: @escaping () -> (),
        failure: @escaping (Error?) -> ()) {
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // Append photos
                for (index, url) in photos.enumerated() {
                    multipartFormData.append(url, withName: "image\(index+1)")
                }
                // Append videos
                for (index, url) in videos.enumerated() {
                    multipartFormData.append(url, withName: "video\(index+1)")
                }
                // Append report ID
                multipartFormData.append("\(reportID)".data(using: .utf8)!, withName: "file_report", mimeType: "text/plain")
            },
            to: URL(string: self.currentEnvironmentBaseURL + path)!,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let uploadRequest, _, _):
                    uploadRequest.uploadProgress { (progress) in
                        print("Upload progress: \(100*progress.completedUnitCount/progress.totalUnitCount)")
                    }
                    uploadRequest.validate().responseJSON { (response) in
                        switch response.result {
                        case .success(_):
                            print("Upload finished")
                            success()
                        case.failure(_):
                            print("Upload failed")
                            failure(nil)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    private var currentEnvironmentBaseURL: String {
        return baseURLLatest
    }
}
