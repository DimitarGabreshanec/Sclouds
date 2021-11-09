//
//  OrganizationZone.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/24/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

struct OrganizationZone: Codable {
    var orgName: String?
    var orgAddress: String?
    var orgID: Int?
    var zone: String?
    var zoneID: Int?
    var zoneFloor: String?
    var zoneFloorID: Int?
    var floorNumber: Int?
    var floorID: Int?
    
    var displayAddress: String? {
        guard let name = self.orgName, let zone = self.zone else {
            return nil
        }
        if let floor = self.floorNumber {
            return "\(name) - \(zone) floor #\(floor)"
        } else {
            return "\(name) - \(zone)"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case orgName = "organization_name"
        case orgAddress = "organization_address"
        case orgID = "organization_id"
        case zone = "zone"
        case zoneID = "zone_id"
        case zoneFloor = "zone_floor"
        case zoneFloorID = "zone_floor_id"
        case floorNumber = "floor_number"
        case floorID = "floor_id"
    }
}
