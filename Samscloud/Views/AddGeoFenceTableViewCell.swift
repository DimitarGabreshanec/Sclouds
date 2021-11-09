//
//  AddGeoFenceTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AddGeoFenceTableViewCell: UITableViewCell {
    
    static let identifier = "AddGeoFenceTableViewCell"
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var geofenceImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var requestLabel: UILabel!
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        geofenceImageView.roundRadius()
        rangeButton.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let checkImage = selected ? "checked" : "check"
        checkImageView.image = UIImage(named: checkImage)
    }
    
    
    // MARK: - ACTIONS
    
    func noAddress(isNoAddress: Bool) {
        timeLabel.isHidden = isNoAddress
        requestLabel.isHidden = !isNoAddress
        rangeButton.isHidden = isNoAddress
        addressLabel.text = isNoAddress ? "Location not available" : "632 Stark Terrace Suite 028"
        addressLabel.textColor = isNoAddress ? UIColor(named: "b4b4b4") : UIColor(named: "5a5a5a")
    }
    
    
    
}
