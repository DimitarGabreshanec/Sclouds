//
//  NotificationSettingsViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationSettingsViewController: UIViewController,NotificationCellDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private let/var
    private var notificationTitles = [[String]]()
    private var sectionTitles = [String]()
    private var settingsTitles = [[String]]()
    
    // MARK: - Variables
    var isSettings = false
    
    // MARK: - View life cycle
    
    var notificationPrefrenes:NotificationPrefrenceModel?
    var settingsPrefrenes:SettingPrefrenceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isSettings ? "Settings" : "Notification Settings"
        
        notificationTitles = fetchNotificationTitles()
        sectionTitles      = fetchSectionTitles()
        settingsTitles     = fetchSettingsTitles()
        
        prepareNavigationBar()
        if isSettings {
            loadCache()
            getSettingsPrefrences()
        }else{
            getNotificationPrefrences()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = isSettings ? "Settings" : "Notification Settings"
        
        notificationTitles = fetchNotificationTitles()
        sectionTitles      = fetchSectionTitles()
        settingsTitles     = fetchSettingsTitles()
        
        prepareNavigationBar()
        if isSettings {
            loadCache()
            getSettingsPrefrences()
        }else{
            getNotificationPrefrences()
        }
        
        tableView.reloadData()
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Methods
    
    @objc func doneButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        let doneButton = creatCustomBarButton(title: "Done")
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        let doneBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.rightBarButtonItems = isSettings ? [] : [doneBarButtonItem]
    }
    
    private func fetchNotificationTitles() -> [[String]] {
        return [["New Messages", "Contact Request", "Contact Disables Location"],
                ["Crisis and Emergency Alerts", "Contact Has an Incident", "Send Incident Text", "Send Incident Email"],
                ["Get notified for new updates", "App tips"]]
    }
    
    private func fetchSectionTitles() -> [String] {
        return ["MESSAGE NOTIFICATIONS", "EMERGENCY NOTIFICATIONS", "NEW FEATURES AND UPDATES"]
    }
    
    private func fetchSettingsTitles() -> [[String]] {
        return [["Share my location"],
                ["Change Password", "Phone Number", "Hide Device Passcode"],
//                ["BlueTooth","NFC"],
//                ["Siri Incident Start", "Auto Route to Organization", "Auto Route to Contacts"],
                ["Shake to Activate Incident"],
//                 "Manage Shake Sensitivity"],
                ["Share Samscloud App"],
                ["Privacy Policy", "Terms of Use"],
                ["Log Out"]]
    }
    //MarkS -> Delegate
    func didclickMenu(idIndex: Int) {
        
    }
    
    
}

// MARK: - UITableViewDataSource

extension NotificationSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSettings ? settingsTitles.count : sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSettings ? settingsTitles[section].count : notificationTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSettings {
//            if indexPath.section == 2 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsTableViewCell.identifier, for: indexPath) as! NotificationSettingsTableViewCell
//
//                cell.settingPrefrence = settingsPrefrenes
//                cell.notificationNameLabel.text = settingsTitles[indexPath.section][indexPath.row]
//                let titleCount = settingsTitles[indexPath.section].count
//
//                cell.delegate = self
//                cell.tag = indexPath.section
//                cell.bottomView.isHidden = true
//                cell.bigBottomView.isHidden = titleCount == 1 || indexPath.row == titleCount - 1
//                cell.notificationSwitch.isOn = true
//
//                if indexPath.row == 0 {
//                    cell.notificationSwitch.isOn = settingsPrefrenes?.bluetooth ?? false
//                }else if indexPath.row == 1 {
//                    cell.notificationSwitch.isOn = settingsPrefrenes?.nfc ?? false
//                }
//
//                cell.switchValueChanged = { (tableCell, value) in
//                    if let indexpath = tableView.indexPath(for: tableCell) {
//                        self.handleSettingSwitchChange(indexPath: indexpath, value: value)
//                    }
//                }
//
//                return cell
//            }
//            if indexPath.section == 3 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsTableViewCell.identifier, for: indexPath) as! NotificationSettingsTableViewCell
//                cell.notificationNameLabel.text = settingsTitles[indexPath.section][indexPath.row]
//                let titleCount = settingsTitles[indexPath.section].count
//                cell.settingPrefrence = settingsPrefrenes
//                cell.delegate = self
//                cell.tag = indexPath.section
//                cell.bottomView.isHidden = true
//                cell.bigBottomView.isHidden = titleCount == 1 || indexPath.row == titleCount - 1
//
//                if indexPath.row == 0 {
//                    cell.notificationSwitch.isOn = settingsPrefrenes?.siri_incident_start ?? false
//                }else if indexPath.row == 1 {
//                    cell.notificationSwitch.isOn = settingsPrefrenes?.auto_route_incident_organization ?? false
//                }else if indexPath.row == 2 {
//                    cell.notificationSwitch.isOn = settingsPrefrenes?.auto_route_contacts ?? false
//                }
//
//                cell.switchValueChanged = { (tableCell, value) in
//                    if let indexpath = tableView.indexPath(for: tableCell) {
//                        self.handleSettingSwitchChange(indexPath: indexpath, value: value)
//                    }
//                }
//                return cell
//            }
            if indexPath.section == 0 || indexPath.section == 2 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsTableViewCell.identifier, for: indexPath) as! NotificationSettingsTableViewCell
                cell.notificationNameLabel.text = settingsTitles[indexPath.section][indexPath.row]
                let titleCount = settingsTitles[indexPath.section].count
                cell.settingPrefrence = settingsPrefrenes
                cell.delegate = self
                cell.tag = indexPath.section
                cell.bottomView.isHidden = true
                cell.bigBottomView.isHidden = titleCount == 1 || indexPath.row == titleCount - 1
                
                print(settingsTitles[indexPath.section][indexPath.row])
                print(indexPath.section,indexPath.row)
                
                if indexPath.row == 0 && indexPath.section == 0 {
                    cell.settingPrefrence = nil
                    cell.notificationSwitch.isOn = DefaultManager().getShareLocationStatus() ?? false
                    cell.switchValueChanged1 = { (sender) in
                        self.handleShareMyLocation(sender.isOn)
                    }
                }else{
                    
                }
                
                if indexPath.section == 2 && indexPath.row == 0 {
                    cell.notificationSwitch.isOn = DefaultManager().getShake() ?? false
//                   cell.notificationSwitch.isOn = settingsPrefrenes?.shake_activate_incident ?? false
                    cell.switchValueChanged = { (tableCell, value) in
                        if let indexpath = tableView.indexPath(for: tableCell) {
                            self.handleSettingSwitchChange(indexPath: indexpath, value: value)
                        }
                    }
                }else{
                    
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
                cell.settingsNameLabel.text = settingsTitles[indexPath.section][indexPath.row]
                let titleCount = settingsTitles[indexPath.section].count
                let sectionCount = settingsTitles.count
                cell.bigBottomView.isHidden = titleCount == 1 || indexPath.row == titleCount - 1
                if indexPath.section == sectionCount - 1 && indexPath.row == titleCount - 1 {
                    cell.bigBottomView.isHidden = false
                }
                cell.renderUI(indexPath: indexPath)
                cell.checkedImageView.isHidden = true
                if indexPath.section == 1 && indexPath.row == 2 {
                    let passcode = DefaultManager().getPasscode()
                    cell.checkedImageView.isHidden = (passcode == nil || passcode == "")
                    cell.settingsTextField.isHidden = !(passcode == nil || passcode == "")
                }else{
                    cell.checkedImageView.isHidden = true
                }
                if indexPath.section == 1 {
                    if indexPath.row == 0 {
                        cell.settingsTextField.isHidden = true
                    }
                    if indexPath.row == 1 {
                        cell.settingsTextField.text = DefaultManager().getPhoneNumber() ?? ""
                    }
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsTableViewCell.identifier, for: indexPath) as! NotificationSettingsTableViewCell
            let title = notificationTitles[indexPath.section][indexPath.row]
            let titleCount = notificationTitles[indexPath.section].count
            let sectionCount = notificationTitles.count
            cell.notificationNameLabel.text = title
            cell.bottomView.isHidden = titleCount == 1 || indexPath.row == titleCount - 1
            if indexPath.section == sectionCount - 1 && indexPath.row == titleCount - 1 {
                cell.bigBottomView.isHidden = false
            }
            cell.prefrence = notificationPrefrenes
            cell.renderUI(indexPath: indexPath)
            cell.switchValueChanged = { (cell, value) in
                if let indexpath = tableView.indexPath(for: cell) {
                    self.handleSwitchChange(indexPath: indexpath, value: value)
                }
            }
            return cell
        }
    }
    
    
    func handleSwitchChange(indexPath:IndexPath, value:Bool) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                notificationPrefrenes?.new_message = value
            }
            if indexPath.row == 1 {
                notificationPrefrenes?.contact_request = value
            }
            if indexPath.row == 2 {
                notificationPrefrenes?.contact_disable_location = value
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                notificationPrefrenes?.crisis_emergency_alert = value
            }
            if indexPath.row == 1 {
                notificationPrefrenes?.contact_has_incident = value
            }
            if indexPath.row == 2 {
                notificationPrefrenes?.send_incident_text = value
            }
            if indexPath.row == 3 {
                notificationPrefrenes?.send_incident_email = value
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                notificationPrefrenes?.new_updates = value
            }
            if indexPath.row == 1 {
                notificationPrefrenes?.app_tips = value
            }
        }
        
        updateNotificationPrefrences()
    }
    
    
    func handleSettingSwitchChange(indexPath:IndexPath, value:Bool) {
//        if indexPath.section == 2 {
//            if indexPath.row == 0 {
//                settingsPrefrenes?.bluetooth = value
//            }
//            if indexPath.row == 1 {
//                settingsPrefrenes?.nfc = value
//            }
//        }
//        else if indexPath.section == 3 {
//            if indexPath.row == 0 {
//                settingsPrefrenes?.siri_incident_start = value
//            }
//            if indexPath.row == 1 {
//                settingsPrefrenes?.auto_route_incident_organization = value
//            }
//            if indexPath.row == 2 {
//                settingsPrefrenes?.auto_route_contacts = value
//            }
//        }
            if indexPath.section == 2 {
            if indexPath.row == 0 {
                settingsPrefrenes?.shake_activate_incident = value
                 DefaultManager().setShake(value: value)
            }
        }
        
        updateSettingPrefrences()
    }
}

// MARK: - UITableViewDelegate

extension NotificationSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSettings ? 50 : 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSettings ? 29 : 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: HeaderNotificationView = HeaderNotificationView.fromNib()
        headerView.headerLabel.text = isSettings ? "" : sectionTitles[section]
        headerView.topView.isHidden = section == 0 
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSettings {
            if indexPath.section == 10 {
                if indexPath.row == 0 {
                    let addContactVC = StoryboardManager.mainStoryBoard().getController(identifier: "AddContactVC") as! AddContactViewController
                    addContactVC.defaultSegmentedIndex = 1
                    addContactVC.isNotShowPermissionPage = true
                    
                    navigationController?.pushViewController(addContactVC, animated: true)
                } else {
                    let searchMyOrganizationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
                    searchMyOrganizationVC.isAddOrganization = true
                    
                    // Handle `add` organization
                    /*searchMyOrganizationVC.addOrganizationButtonAction = { organizations in
                     let addContactVC = StoryboardManager.mainStoryBoard().getController(identifier: "AddContactVC") as! AddContactViewController
                     addContactVC.defaultSegmentedIndex = 1
                     addContactVC.isNotShowPermissionPage = true
                     
                     // Reload organization list
                     organizations.forEach({ (organization) in
                     let isExistOrganization = addContactVC.organizationArray.contains(where: { $0 == organization })
                     if !isExistOrganization {
                     addContactVC.organizationArray.append(organization)
                     }
                     })
                     self.navigationController?.pushViewController(addContactVC, animated: true)
                     }*/
                    self.navigationController?.pushViewController(searchMyOrganizationVC, animated: true)
                }
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    self.performSegue(withIdentifier: "showChangePwdSegue", sender: nil)
                }else if indexPath.row == 1 {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
                    otpVC.isFromChangeNumber = true
                    otpVC.senderVC = self
                    self.navigationController?.pushViewController(otpVC, animated: true)
                }else if indexPath.row == 2 {
                    self.performSegue(withIdentifier: "showHidePassCodeSegue", sender: nil)
                }
            }
//            else if indexPath.section == 4 {
//                if indexPath.row == 1 {
//                    performSegue(withIdentifier: "showShakeSegue", sender: nil)
//                }
//            }
            else if indexPath.section == 3 {
                let text = "This is the text...."
                let sharingObjects = [text]
                let activity = UIActivityViewController(activityItems: sharingObjects,
                                                        applicationActivities: nil)
                activity.excludedActivityTypes = [.airDrop, .addToReadingList, .postToFlickr, .copyToPasteboard, .saveToCameraRoll,
                                                  .assignToContact, .openInIBooks, .postToWeibo, .postToTencentWeibo]
                self.present(activity, animated: true, completion: nil)
            }
            else if indexPath.section == 4{
                indexPath.row == 0 ?
                self.performSegue(withIdentifier: "toPrivacyPolicyVC", sender: nil)
                :
                self.performSegue(withIdentifier: "toTermsAndConditionsVC", sender: nil)
                
            }
            else if indexPath.section == 5 {
                
                KeychainManager.clear()
                //LandingViewController.makeRoot()
                appDelegate.requestForLocation()
                UserDefaults().removeObject(forKey: "profile_logo_url")
                UserDefaults.standard.clearCaches()
                LoginViewController.makeRoot()
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHidePassCodeSegue" {
            let vc = segue.destination as? HideDevicePasscodeViewController
            let passcode = DefaultManager().getPasscode()
            //vc?.isDispatchPassCode = (passcode != nil && passcode != "")
        }
    }
}









extension NotificationSettingsViewController {
    
    func getNotificationPrefrences() {
        
        let url = BASE_URL + Constants.USER_NOTIFICATION_SETTINGS
        
        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                self.notificationPrefrenes = NotificationPrefrenceModel.init(json: json)
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    
    func updateNotificationPrefrences() {
        
        let url = BASE_URL + Constants.UPDATE_USER_NOTIFICATION_SETTINGS
        
        let param:[String:Any] = [
            "new_message": notificationPrefrenes?.new_message ?? false,
            "contact_request": notificationPrefrenes?.contact_request ?? false,
            "contact_disable_location": notificationPrefrenes?.contact_disable_location ?? false,
            "crisis_emergency_alert": notificationPrefrenes?.crisis_emergency_alert ?? false,
            "contact_has_incident": notificationPrefrenes?.contact_has_incident ?? false,
            "send_incident_text": notificationPrefrenes?.send_incident_text ?? false,
            "send_incident_email": notificationPrefrenes?.send_incident_email ?? false,
            "app_tips": notificationPrefrenes?.app_tips ?? false,
            "new_updates": notificationPrefrenes?.new_updates ?? false
        ]
        
        print(JSON.init(param))
        
        SwiftLoader.show(title:"Updating...", animated: false)
        
        ApiManager.shared.PUTApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
            }
        }
    }
    
    
    func handleShareMyLocation(_ value:Bool) {
        if appDelegate.checkLocationPermission() {
            hitUpdateLocationPrefrenceApi(value: value)
            DefaultManager().setShareLocationStatus(value: value)
//            appDelegate.startLocationUpdate()
        }else{
            tableView.reloadData()
        }
        
    }
    
    
    func hitUpdateLocationPrefrenceApi(value:Bool) {
        
        let url = BASE_URL + Constants.SHARE_MY_LOCATION
        
        SwiftLoader.show(title: "Updating ...", animated: true)
        let param:[String:Any] = [
            "share_location": value,
        ]
        
        print(JSON.init(param))
        
        ApiManager.shared.PATCHApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response {
                print(json)
                if statusCode == 200 {
                    DefaultManager().setShareLocationStatus(value: value)
                    if value == false {
//                        appDelegate.stopSharingLocationUpdate()
//                        appDelegate.stopLocationUpdateTimer()
                    }else{
                        appDelegate.startLocationUpdate()
                    }
                }
            }
        }
    }
    
}






extension NotificationSettingsViewController {
    
    func getSettingsPrefrences() {
        
        let url = BASE_URL + Constants.USER_SETTINGS
        
//        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
//            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                self.settingsPrefrenes = SettingPrefrenceModel.init(json: json)
                UserDefaults.standard.setSettingsCache(json)
                self.tableView.reloadData()
                DefaultManager().setAutoRouteContact(value: self.settingsPrefrenes?.auto_route_contacts)
                DefaultManager().setAutoRouteOrganization(value: self.settingsPrefrenes?.auto_route_incident_organization)
            }
        }
    }
    
    func loadCache() {
        if let json = UserDefaults.standard.getSettingsCache() {
            self.settingsPrefrenes = SettingPrefrenceModel.init(json: json)
            self.tableView.reloadData()
            DefaultManager().setAutoRouteContact(value: self.settingsPrefrenes?.auto_route_contacts)
            DefaultManager().setAutoRouteOrganization(value: self.settingsPrefrenes?.auto_route_incident_organization)
        }
    }
    
    
    
    func updateSettingPrefrences() {
        
        let url = BASE_URL + Constants.UPDATE_USER_SETTINGS
        
        let contact = settingsPrefrenes?.auto_route_contacts ?? false
        let org = settingsPrefrenes?.auto_route_incident_organization ?? false
        
        let param:[String:Any] = [
            "bluetooth": settingsPrefrenes?.bluetooth ?? false,
            "nfc": settingsPrefrenes?.nfc ?? false,
            "siri_incident_start": settingsPrefrenes?.siri_incident_start ?? false,
            "auto_route_incident_organization": settingsPrefrenes?.auto_route_incident_organization ?? false,
            "auto_route_contacts": settingsPrefrenes?.auto_route_contacts ?? false,
            "shake_activate_incident": settingsPrefrenes?.shake_activate_incident ?? false
        ]
        
        print(JSON.init(param))
        
        SwiftLoader.show(title:"Updating...", animated: false)
        
        ApiManager.shared.PUTApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                DefaultManager().setAutoRouteContact(value: contact)
                DefaultManager().setAutoRouteOrganization(value: org)
            }
        }
    }
    
}
