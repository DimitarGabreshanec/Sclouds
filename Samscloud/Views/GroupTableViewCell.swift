//
//  GroupTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 3/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    static let identifier = "GroupTableViewCell"
    var messageButtonAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var rangeButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestLabelTopConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - ACTIONS
    
    func renderUI(isRequest: Bool) {
        addressLabel.text = isRequest ? "Location not available" : "632 Stark Terrace Suite 028"
        requestLabel.isHidden = !isRequest
        rangeButton.isHidden = isRequest
        timeLabel.isHidden = isRequest
        //addressLabel.textColor = isRequest ? UIColor(named: "b4b4b4") : UIColor(named: "5a5a5a")
        rangeButtonTopConstraint.constant = 5
        requestLabelTopConstraint.constant = 2
        userImageView.image = UIImage(named: "oval")
    }
    
    func renderPendingUI() {
        rangeButton.isHidden = true
        timeLabel.isHidden = true
        requestLabel.isHidden = true
        pendingLabel.isHidden = false
        messageButton.isHidden = true
        rangeButtonTopConstraint.constant = -rangeButton.frame.height
        requestLabelTopConstraint.constant = -requestLabel.frame.height
        addressLabel.text = "Sent Fri, Jun 28"
        userImageView.image = UIImage(named: "pendingAvatar")
        //addressLabel.textColor = UIColor(named: "5a5a5a")
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func messageButtonAction(_ sender: Any) {
        messageButtonAction?()
    }
    
    
}
