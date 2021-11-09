//
//  Report.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/24/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

struct Report: Codable {
    var description: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var reportTypeID: Int?
    var organizations: [String]
    var zoneID: Int?
    var zoneFloorID: Int?
    var isAnonymous: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case description = "details"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case reportTypeID = "report_type"
        case organizations = "reporting_organizations"
        case zoneID = "report_zone"
        case zoneFloorID = "report_zone_floor"
        case isAnonymous = "send_anonymously"
    }
    
    var isValid: Bool {
        return (
            !(
                [reportTypeID] as [Any?]).contains(where: { $0 == nil}
            )
            &&
            !(
                [description, address, latitude, longitude] as [String?]).contains(where: { $0 == "" || $0 == nil }
            )
            &&
            !(
                organizations.count <= 0
            )
        )
    }
}
