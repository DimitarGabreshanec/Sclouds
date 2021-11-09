//
//  NotificationSettingsTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit


// MARK: - PROTOCOL

protocol NotificationCellDelegate {
    func didclickMenu(idIndex: Int)
}


// MARK: - CLASS

class NotificationSettingsTableViewCell: UITableViewCell {
    
    var delegate: NotificationCellDelegate! = nil
    static let identifier = "NotificationSettingsTableViewCell"
    var switchValueChanged: ((NotificationSettingsTableViewCell, _ value:Bool) -> Void)?
    
    var switchValueChanged1: ((UISwitch) -> Void)?
    
    @IBOutlet weak var notificationNameLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bigBottomView: UIView!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!
    

    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        notificationSwitch.onTintColor = UIColor.mainColor()
        notificationSwitch.tintColor = UIColor(hexString: "e5e5ea")
    }
 
    var prefrence:NotificationPrefrenceModel?
    var settingPrefrence:SettingPrefrenceModel?
    
    // MARK: - ACTIONS
    
    func renderUI(indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                notificationSwitch.isOn = prefrence?.new_message ?? false
            }
            if indexPath.row == 1 {
                notificationSwitch.isOn = prefrence?.contact_request ?? false
            }
            if indexPath.row == 2 {
                notificationSwitch.isOn = prefrence?.contact_disable_location ?? false
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                notificationSwitch.isOn = prefrence?.crisis_emergency_alert ?? false
            }
            if indexPath.row == 1 {
                notificationSwitch.isOn = prefrence?.contact_has_incident ?? false
            }
            if indexPath.row == 2 {
                notificationSwitch.isOn = prefrence?.send_incident_text ?? false
            }
            if indexPath.row == 3 {
                notificationSwitch.isOn = prefrence?.send_incident_email ?? false
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                notificationSwitch.isOn = prefrence?.new_updates ?? false
            }
            if indexPath.row == 1 {
                notificationSwitch.isOn = prefrence?.app_tips ?? false
            }
            
        }
    }
    
    // MARK: - IBACTIONS

    @IBAction func switchValueChanged(_ sender: UISwitch)  {
        if settingPrefrence != nil {
            switchValueChanged?(self, sender.isOn)
            return
        }
        if prefrence == nil {
            switchValueChanged1?(sender)
        }else{
            switchValueChanged?(self, sender.isOn)
        }
    }
    
    
    
}
