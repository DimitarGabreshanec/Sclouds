//
//  Relationship.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//
 
import SwiftyJSON


class Relationship: NSObject {
    
    var contact = ""
    var relationship = ""
    
    init(inventoryData: [String: JSON]) {
        contact = inventoryData["contact"]?.stringValue ?? ""
        relationship = inventoryData["relationship"]?.stringValue ?? ""
    }
    
}
