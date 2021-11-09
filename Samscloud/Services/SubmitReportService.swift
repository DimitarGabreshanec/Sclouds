//
//  SubmitReportService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/24/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class SubmitReportService {
    let path = "reports/report-create/"
    
    func submitReport(report: Report, success: @escaping (ReportResponse) -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().post(
            self.path,
            params: report.dictionary,
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                print(response)
                do {
                    guard let response = response else {
                        failure(nil)
                        return
                    }
                    let json = try JSONSerialization.data(withJSONObject: response)
                    let decoder = JSONDecoder()
                    do {
                        let report = try decoder.decode(ReportResponse.self, from: json)
                        success(report)
                    } catch {
                        print("Error: \(error)")
                        failure(nil)
                    }
                } catch let err{
                    print(err.localizedDescription)
                    failure(nil)
                }
            },
            failureCallback: { (statusCode, errors) in
                failure(errors?.first)
            }
        )
    }
}
