//
//  UIButton.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

extension UIButton {
    
    func activated(_ activated: Bool) {
        isEnabled = activated
        alpha = activated ? 1.0 : 0.5
    }
    
    func activatedOfNavigationBar(_ activated: Bool) {
        isUserInteractionEnabled = activated
        setTitleColor(activated ? UIColor.mainColor() : UIColor(hexString: "d3d3d3"), for: .normal)
    }
    
    
}
