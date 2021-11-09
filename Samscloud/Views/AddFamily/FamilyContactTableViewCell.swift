//
//  FamilyContactTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class FamilyContactTableViewCell: UITableViewCell {
    
    var messageButtonAction: (() -> Void)?
    var rangerButtonAction: (() -> Void)?
    var checkinButtonAction: (() -> Void)?
    
    static let identifier = "FamilyContactTableViewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangerButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var topMessageButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRangerButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var requestCheckinButton: UIButton?
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.roundRadius()
        rangerButton.layer.cornerRadius = 2
        timeAgoLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - ACTIONS
    
    func handlePendingContact(indexPath: IndexPath) {
        pendingLabel.isHidden = indexPath.row == 0
        //rangerButton.isHidden = indexPath.row != 0
        timeAgoLabel.text = indexPath.row != 0 ? "" : "3 min ago"
        topRangerButtonConstraint.constant = indexPath.row != 0 ? -10 : 5
        messageButton.isHidden = indexPath.row != 0
        userImageView.image = indexPath.row == 0 ? UIImage(named: "path") : UIImage(named: "pendingAvatar")
        userImageView.layer.cornerRadius = indexPath.row == 0 ? userImageView.frame.height / 2 : 0
        let addressText = "Sent Fri, Jul 3"
        addressLabel.text =  indexPath.row != 0 ? addressText : "632 Stark Terrace Suite 028"
    }
    
    func handleCellForEmergencyTab(indexPath: IndexPath) {
        //rangerButton.isHidden = true
        timeAgoLabel.text = ""
        topRangerButtonConstraint.constant = -10
        addressLabel.text = "Friend"
        pendingLabel.isHidden = true
        messageButton.isHidden = false
        userImageView.image = UIImage(named: "path")
    }
    
    // MARK: - IBACTIONS

    @IBAction func messageButtonAction(_ sender: UIButton) {
        messageButtonAction?()
    }
    
    @IBAction func rangerButtonAction(_ sender: UIButton) {
        print("RANGER BUTTON ACTION PRESSED")
        if sender.titleLabel?.text == "Request Check in" {
            rangerButtonAction?()
        }
    }
    
    func setPendingView() {
        userImageView.image = UIImage(named: "pendingAvatar")
        timeAgoLabel.isHidden = true
        rangerButton.isHidden = true
    }
    
    func setCheckinView() {
        timeAgoLabel.isHidden = true
        rangerButton.isHidden = false
        rangerButton.backgroundColor = .white
        rangerButton.setTitle("Request Check in", for: .normal)
        rangerButton.setTitleColor(#colorLiteral(red: 0.144264847, green: 0.3467099667, blue: 0.9637486339, alpha: 1), for: .normal)
    }
    
    func setForDistance() {
        rangerButton.isHidden = false
        rangerButton.backgroundColor = #colorLiteral(red: 0.3528889418, green: 0.7687920332, blue: 0.4267972112, alpha: 1)
        rangerButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
}
