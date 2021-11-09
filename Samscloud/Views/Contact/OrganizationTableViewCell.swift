//
//  OrganizationTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/18/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import CoreLocation

class OrganizationTableViewCell: UITableViewCell {
    
    static let identifier = "OrganizationTableViewCell"
    
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        rangeButton.layer.cornerRadius = 2
        organizationImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var organization:OrganizationModel? {
        didSet{
            if let image = organization?.logo, image != "" {
                let placeholder = UIImage.init(named: "sams_logo")
                loadImage(image, organizationImageView, activity: nil, defaultImage: placeholder)
            }
            nameLabel.text = organization?.organization_name
            statusLabel.text = ""
            addressLabel.text = organization?.address
            
            if let loc1 = appDelegate.currentLocation ,  let lat = organization?.latitude, let lon = organization?.longitude {
                let loc2 = CLLocation.init(latitude: lat, longitude: lon)
                let distance = Float(loc1.distance(from: loc2)/1609.34)
                
                let str = String.init(format: "%.2f miles", distance)
                rangeButton.setTitle(str, for: .normal)
                rangeButton.isHidden = false
            }else{
                rangeButton.isHidden = true
            }
            
        }
    }
    
    
}
