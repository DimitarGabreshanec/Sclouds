//
//  ResponderPinView.swift
//  Samscloud
//
//  Created by Suraj on 10/3/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit




class ResponderPinView: UIView {
    
    
    @IBOutlet weak var numberLablel: UILabel?
    @IBOutlet weak var minuteLablel: UILabel?
    @IBOutlet weak var cityLablel: UILabel?
    @IBOutlet weak var detailsView: UIView?
    
    class func view() -> ResponderPinView {
        let view =  UINib(nibName: "ResponderPinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ResponderPinView
        return view
    }
    
    
}
