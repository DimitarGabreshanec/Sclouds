//
//  FileManager.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/28/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    static var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    
    static var cachesURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    static func cachedFileURL(remotePath: String) -> URL? {
        var localURL: URL? = nil
        let directoryURL = FileManager.cachesURL
        if let remoteURL = URL(string: remotePath) {
            localURL = directoryURL.appendingPathComponent(remoteURL.lastPathComponent)
        }
        if let url = localURL, FileManager.default.fileExists(atPath: url.path) {
            return url
        } else {
            return nil
        }
    }
}
