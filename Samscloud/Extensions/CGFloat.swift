//
//  CGFloat+Extension.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//
 
import UIKit

extension CGFloat {
    
    func proportionalFontSize() -> CGFloat {
        let sizeToCheckAgainst = self
        let screenHeight = UIScreen.main.bounds.size.height
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if screenHeight == 480 {
                return (sizeToCheckAgainst - 2.5)
            } else if screenHeight == 568 {
                return (sizeToCheckAgainst -  1.5)
            } else if screenHeight == 667 {
                return (sizeToCheckAgainst +  0)
            } else if screenHeight == 736 {
                return (sizeToCheckAgainst + 1)
            }
            break
        case .pad:
            return (sizeToCheckAgainst + 12)
        default:
            return self
        }
        return self
    }
    
}
