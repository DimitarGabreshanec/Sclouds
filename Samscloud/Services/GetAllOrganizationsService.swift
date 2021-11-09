//
//  GetAllOrganizationsService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/22/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetAllOrganizationsService {
    let path = "organization/search-organization/?search_query"
    
    func getAllOrganizations(success: @escaping ([OrganizationModel]) -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().get(
            self.path,
            params: nil,
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                do {
                    guard let response = response else {
                        failure(nil)
                        return
                    }
                    let data = try JSONSerialization.data(withJSONObject: response)
                    let json = try JSON(data: data)
                    if let array = json.array {
                        success(array.decode())
                    } else {
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
