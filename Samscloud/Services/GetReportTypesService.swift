//
//  GetReportTypesService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/20/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class GetReportTypesService {
    let path = "reports/report-types/"
    
    func getReportTypes(success: @escaping ([ReportType]) -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().get(
            self.path,
            params: nil,
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                do {
                    guard let response = response as? [String: Any], let reportTypes = response["report_types"] else {
                        failure(nil)
                        return
                    }
                    let json = try JSONSerialization.data(withJSONObject: reportTypes)
                    let decoder = JSONDecoder()
                    do {
                        let reportTypes = try decoder.decode([ReportType].self, from: json)
                        success(reportTypes)
                    } catch {
                        print("Error: \(error)")
                        failure(nil)
                    }
                } catch {
                    failure(nil)
                }
            },
            failureCallback: { (statusCode, errors) in
                failure(errors?.first)
            }
        )
    }
}
