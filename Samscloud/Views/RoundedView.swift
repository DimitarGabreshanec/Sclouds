//
//  RoundedView.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor        }
    }
    
}









class ResponderView: UIView {
    
    
    @IBOutlet weak var imgView: UIImageView?
    
    class func view() -> ResponderView {
        let view =  UINib(nibName: "ResponderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ResponderView
        view.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        return view
    }
    
}
