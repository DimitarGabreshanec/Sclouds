//
//  URL.swift
//  Samscloud
//
//  Created by Chetu Mac on 15/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation

extension URL {
    
    func URLByAppendingEndpoint(_ endpoint: Endpoint) -> URL {
        return appendingPathComponent(endpoint.path)
    }
    
    var isImage: Bool {
        (
            self.pathExtension == "jpg" ||
            self.pathExtension == "jpeg" ||
            self.pathExtension == "png"
        )
    }
}
