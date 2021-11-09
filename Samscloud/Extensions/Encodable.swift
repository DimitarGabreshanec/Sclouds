//
//  Encodable.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/24/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
