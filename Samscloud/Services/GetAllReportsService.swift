//
//  GetAllReportsService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/22/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetAllReportsService {
    let path = "reports/get-user-reports/"
    
    func getAllReports(success: @escaping ([ReportResponse]) -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().get(
            self.path,
            params: nil,
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                do {
                    guard let response = response as? [String: Any], let reports = response["data"] else {
                        failure(nil)
                        return
                    }
                    let json = try JSONSerialization.data(withJSONObject: reports)
                    print(json)
                    let decoder = JSONDecoder()
                    do {
                        let reportResponse = try decoder.decode([ReportResponse].self, from: json)
                        success(reportResponse)
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
