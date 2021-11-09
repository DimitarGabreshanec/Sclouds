//
//  UIStoryBoard.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func getController<T: UIViewController>(identifier: String = String(describing: T.self)) -> T {
        let controller = instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
    
    
}
