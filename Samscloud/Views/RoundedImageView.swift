//
//  RoundedImageView.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 12/1/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
