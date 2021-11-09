//
//  IncidentOngoingTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class IncidentOngoingTableViewCell: UITableViewCell {
    
    static let identifier = "IncidentOngoingTableViewCell"
    var liveButtonAction: (() -> Void)?
    
    @IBOutlet weak var ongoingImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reportNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT

    var incident:OngoingIncidentModel?  {
        didSet{
            setData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationImageView.image = UIImage(named: "location-small")?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor(hexString: "939393")
        liveButton.roundRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func liveButtonAction(_ sender: UIButton) {
        liveButtonAction?()
    }
    
    
    private func setData() {
        userNameLabel.text = incident?.user?.first_name
        let report = incident?.emergency_message ?? ""
        reportNameLabel.text = "Report: \(report)"
        addressLabel.text = incident?.current_location
        timeAgoLabel.text = incident?.broadcast_start_time?.toIncidentDate()?.getElapsedInterval()
        
        if let profile = incident?.user?.profile_logo {
            let defaultImg = UIImage.init(named: "userAvatar")
            loadImage(profile, userImageView, activity: nil, defaultImage: defaultImg)
        }
        
        if let profile = incident?.preview_thumbnail {
            loadImage(profile, ongoingImageView, activity: nil, defaultImage: nil)
        }
    }
    
    
}
