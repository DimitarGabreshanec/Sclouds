//
//  SettingsTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    @IBOutlet weak var bigBottomView: UIView!
    @IBOutlet weak var settingsNameLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    @IBOutlet weak var settingsTextField: UITextField!
    
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkedImageView.image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
        checkedImageView.tintColor = UIColor(hexString: "02c862")
    }
    
    
    // MARK: - ACTIONS
    
    func renderUI(indexPath: IndexPath) {
        checkedImageView.isHidden = !(indexPath.section == 2 && indexPath.row == 2)
        if indexPath.section == 1 {
            settingsTextField.text = indexPath.row == 0 ? "3" : "Add"
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                settingsTextField.text = "+1 323 765 3885"
            } else if indexPath.row == 2 {
                settingsTextField.text = "Create"
            } else {
                settingsTextField.text = ""
            }
        } else {
            settingsTextField.text = ""
        }
        settingsNameLabel.textColor = indexPath.section == 5 || indexPath.section == 7 ? UIColor.mainColor() : UIColor.blackTextColor()
    }
    
    
    
    
}
