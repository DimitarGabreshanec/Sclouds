//
//  DeleteReportService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 12/3/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class DeleteReportService {
    let path = "reports/:id/report-delete/"
    
    func deleteReport(reportID: Int, success: @escaping () -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().delete(
            self.path.replacingOccurrences(of: ":id", with: "\(reportID)"),
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
