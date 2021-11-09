//
//  ResponderPinView.swift
//  Samscloud
//
//  Created by Suraj on 10/3/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit




class ReporterPinView: UIView {
    
    
    @IBOutlet weak var numberLablel: UILabel?
    @IBOutlet weak var minuteLablel: UILabel?
    @IBOutlet weak var cityLablel: UILabel?
    @IBOutlet weak var detailsView: UIView?
    @IBOutlet weak var iconImage: UIImageView?
    
    class func view() -> ReporterPinView {
        let view =  UINib(nibName: "ReporterPinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReporterPinView
        return view
    }
}
