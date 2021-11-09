//
//  NSMutableAttributedString.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
        }
    }
    
    
}
