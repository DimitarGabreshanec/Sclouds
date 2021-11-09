//
//  ReportOrganizationResponse.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/30/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

struct ReportOrganizationResponse: Codable {
    var id: Int?
    var name: String?
    var logo:String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "organization_name"
        case logo = "logo"
    }
}
