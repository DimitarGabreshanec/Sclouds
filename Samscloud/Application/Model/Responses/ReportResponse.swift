//
//  ReportResponse.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/30/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

struct ReportResponse: Codable {
    var id: Int?
    var maintenanceID: String?
    var description: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var reportTypeID: Int?
    var reportType: String?
    var organizationID: String?
    var isAnonymous: Bool?
    var organizations: [ReportOrganizationResponse]?
    var createdAt: String?
    var attachmentPaths: [String]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case maintenanceID = "maintenance_id"
        case description = "details"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case reportTypeID = "report_type_id"
        case reportType = "report_type"
        case isAnonymous = "send_anonymously"
        case organizations = "reporting_organizations"
        case createdAt = "created_at"
        case attachmentPaths = "files"
    }
}
