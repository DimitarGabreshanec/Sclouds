//
//  Collection+Extension.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation


extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at specified index if it's within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    
}
