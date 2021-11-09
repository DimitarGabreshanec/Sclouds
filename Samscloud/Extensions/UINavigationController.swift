//
//  UINavigationController.swift
//  Samscloud
//
//  Created by An Phan on 1/18/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func popViewController(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    
    
}
