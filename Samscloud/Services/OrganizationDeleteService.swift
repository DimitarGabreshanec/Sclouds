//
//  DeleteReportService.swift
//  Samscloud
//
//  Created by Dharmendra Valiya on 21/9/20.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class OrganizationDeleteService {
    let path = "organization/unsubscribe-organization/"
    
    func deleteOrganization(organizationID: Int, success: @escaping () -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().delete(
            path + "\(organizationID)",
            params: nil,
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                success()
            },
            failureCallback: { (statusCode, errors) in
                failure(errors?.first)
            }
        )
    }
}
