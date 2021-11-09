//
//  GetOrganizationZoneService.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/24/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import CoreLocation

class GetOrganizationZoneService {
    let path = "incidents/get-organization-zone-floor/"
    
    func getOrganizationZone(location: CLLocation, success: @escaping (OrganizationZone) -> (), failure: @escaping (String?) -> ()) {
        let _ = NetworkManager().post(
            self.path,
            params: self.buildParams(location: location),
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            successCallback: { response in
                do {
                    guard let response = response else {
                        failure(nil)
                        return
                    }
                    let json = try JSONSerialization.data(withJSONObject: response)
                    let decoder = JSONDecoder()
                    do {
                        let organizationZone = try decoder.decode(OrganizationZone.self, from: json)
                        success(organizationZone)
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
    
    private func buildParams(location: CLLocation) -> [String: String] {
        return [
            "latitude": String(format: "%.6f", location.coordinate.latitude),
            "longitude": String(format: "%.6f", location.coordinate.longitude),
            "altitude": String(format: "%.2f", location.altitude)
        ]
    }
}
