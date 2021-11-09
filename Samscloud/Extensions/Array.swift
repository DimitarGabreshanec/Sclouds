//
//  Array.swift
//  Samscloud
//
//  Created by An Phan on 1/18/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation

extension Array {
    
    func chunk(by predicate: @escaping (Iterator.Element, Iterator.Element) -> Bool) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j = index(after: i)
        while i != endIndex {
            j = self[j..<endIndex]
                .index(where: { !predicate(self[i], $0) } ) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
    
    
}
