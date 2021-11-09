//
//  AcceptUserNotificationTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AcceptUserNotificationTableViewCell: UITableViewCell {

    static let identifier = "AcceptUserNotificationTableViewCell"
    var acceptButtonAction: (() -> Void)?
    var declineButtonAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
 
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 10
        acceptButton.layer.cornerRadius = 4
        declineButton.layer.cornerRadius = 4
    }
 
    
    // MARK: - IBACTIONS

    @IBAction func acceptButtonAction(_ sender: UIButton) {
        acceptButtonAction?()
    }
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        declineButtonAction?()
    }
    
    
    
}
