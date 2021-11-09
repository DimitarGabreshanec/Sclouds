//
//  Data.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/28/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

extension Data {
    func save(path: String, fileName: String) -> Bool {
        let writeURL = URL(fileURLWithPath: path).appendingPathComponent("\(fileName)")
        
        do {
            try self.write(to: URL(fileURLWithPath: writeURL.path), options: .atomic)
        } catch {
            print("Failed to saved file: \(fileName)")
            return false
        }
        return true
    }
}
