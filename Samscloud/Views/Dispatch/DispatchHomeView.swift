//
//  DispatchHomeView.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchHomeView: UIView {
    
    var moreButtonAction: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    
    // MARK: - IBACTIONS

    @IBAction func moreButtonAction(_ sender: UIButton) {
        moreButtonAction?()
    }
    
    
    
}
