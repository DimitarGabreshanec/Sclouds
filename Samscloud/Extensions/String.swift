//
//  String.swift
//  Samscloud
//
//  Created by An Phan on 2/11/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation

extension String {
    
    var isAlphabetical: Bool {
        return range(of: "^[a-zA-Z]", options: .regularExpression) != nil
    }
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$",
                                                options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self,
                                    options: [],
                                    range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false 
        }
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }

    func convertHtml() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        return nil
    }
}
