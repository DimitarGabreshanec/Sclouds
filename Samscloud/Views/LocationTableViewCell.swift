//
//  LocationTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        rangeButton.layer.cornerRadius = 2
    }
 

}
