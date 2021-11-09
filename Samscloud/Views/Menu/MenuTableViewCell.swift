//
//  MenuTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/28/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    static let identifier = "MenuTableViewCell"
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!
    
    
    // MARK: - ACTIONS
    func renderData(image: String, title: String, indexPath: IndexPath) {
        menuImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        menuImageView.tintColor = UIColor.mainColor()
        menuNameLabel.text = title
        // Update UI
        menuNameLabel.textColor = indexPath.section == 0 && indexPath.row == 1 || indexPath.section == 0 && indexPath.row == 3 ? UIColor.mainColor() : UIColor.blackTextColor()
        numberLabel.textColor = indexPath.section == 1 && indexPath.row == 2 ? UIColor(hexString: "5a5a5a") : UIColor(hexString: "B4B4B4")
        numberLabel.isHidden = indexPath.section == 3
        if indexPath.section == 0 {
            arrowImageView.isHidden = indexPath.row != 0
            numberLabel.isHidden = indexPath.row != 0
            menuImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            numberLabel.text = "6"
        } else if indexPath.section == 1 {
            numberLabel.isHidden = indexPath.row == 1
//            numberLabel.text = indexPath.row == 0 ? "17" : "0"
        } else if indexPath.section == 2 {
            arrowImageView.isHidden = false
            numberLabel.isHidden = true
            createLabel.isHidden = true
        }
    }
    
    func updateUI(sectionItemCount: Int, itemInSection: Int, indexPath: IndexPath) {
        bottomView.isHidden = sectionItemCount == 1 || indexPath.row == sectionItemCount - 1
        if indexPath.section == itemInSection - 1 && indexPath.row == sectionItemCount - 1 {
            bottomViewLeadingConstraint.constant = 0
            bottomView.isHidden = false
        } else {
            bottomViewLeadingConstraint.constant = 50
        }
    }
    
}
