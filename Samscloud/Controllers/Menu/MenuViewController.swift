//
//  MenuViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/28/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var sharingLocationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = [[String]]()
    var menuImages = [[String]]()
    var profileDetail:ProfileDetailModel?
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems = fetchMenuItems()
        menuImages = fetchMenuImages()
        userImageView.roundRadius()
        userImageView.bordered(withColor: UIColor.white, width: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.cameraStop = false
        //        if DefaultManager().getShareLocationStatus() ?? false {
        addressButton.isHidden = false
        sharingLocationButton.isHidden = false
        addressButton.setTitle(kAppDelegate.currentAddressForShare != nil ? kAppDelegate.currentAddressForShare : appDelegate.addressStr, for: .normal)
        //        }else{
        //            addressButton.isHidden = true
        //            sharingLocationButton.isHidden = true
        //            kAppDelegate.locationManager.stopUpdatingLocation()
        //        }
        //        addressButton.isHidden = DefaultManager().getShareLocationStatus() ?? false
        
        
        navigationController?.isNavigationBarHidden = true
        let place_image = UIImage.init(named: "userAvatar")
        if let image = UserDefaults().imageForKey(key: "profile_logo_url") {
            userImageView?.image = image
        }
            
            //        if let image = DefaultManager().getImage() {
            //
            //            loadImage(image, userImageView!, activity: nil, defaultImage: place_image)
            //        }
        else{
            userImageView.image = place_image
        }
        if let name = DefaultManager().getName() {
            userNameLabel.text = name
        }
        //        sharingLocationButton.isHidden = !(DefaultManager().getShareLocationStatus() ?? true)

        getUserDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - ACTIONS
    
    private func fetchMenuItems() -> [[String]] {
        return [["Contacts", "Add Emergency Contacts","Organizations", "Add Organization"],
                //                ["Messages",
            ["Incidents", "Reports"],
            //                ["GeoFence"],
            ["Notification Settings", "Settings"]]
    }
    
    private func fetchMenuImages() -> [[String]] {
        return [["emergContact", "add", "emergContact","add"],
                //                ["message-menu",
            ["firstAid", "report"],
            //                ["location-big"],
            ["homeNotification", "settings"]]
    }
    
    private func showTabBar(defaultIndex: Int) {
        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = defaultIndex
        navigationController?.pushViewController(mainTabBarVC, animated: true)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        let editProfileNC = StoryboardManager.menuStoryBoard().getController(identifier: "EditProfileNC") as! UINavigationController
        if let editProfileVC = editProfileNC.topViewController as? EditProfileViewController {
            editProfileVC.modalPresentationStyle = .fullScreen
            editProfileNC.modalPresentationStyle = .fullScreen
            self.present(editProfileNC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        let image = menuImages[indexPath.section][indexPath.row]
        let title = menuItems[indexPath.section][indexPath.row]
        cell.renderData(image: image, title: title, indexPath: indexPath)
        let sectionItemCount = menuImages[indexPath.section].count
        let itemInSection = menuItems.count
        cell.updateUI(sectionItemCount: sectionItemCount, itemInSection: itemInSection, indexPath: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let faimlyConatct = Int(profileDetail?.family_contact_count ?? "0") ?? 0
            let emergencyConatct = Int(profileDetail?.emergency_contact_count ?? "0") ?? 0
            let total = faimlyConatct + emergencyConatct
            cell.numberLabel.text = "\(total)"
        }
        
        //        if indexPath.section == 1 && indexPath.row == 0 {
        //            cell.numberLabel.text = "0"
        //        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let ongoing = Int(profileDetail?.ongoing_incident_count ?? "0") ?? 0
            let history = Int(profileDetail?.history_incident_count ?? "0") ?? 0
            let total = ongoing + history
            cell.numberLabel.text = "\(total)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Open contacts page
                let addFamilyOnContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyOnContactVC")
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(addFamilyOnContactVC, animated: true)
                }
//                navigationController?.pushViewController(addFamilyOnContactVC, animated: true)
            } else if indexPath.row == 1 {
                showMenuAddContact()
            } else if indexPath.row == 2 {
                
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 1
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(mainTabBarVC, animated: true)
               }
            }else {
                showAddOrganizationPage()
            }
        } else if indexPath.section == 1 {
            // Open the report page
            if indexPath.row == 1 {
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 3
                mainTabBarVC.isReport = true
                navigationController?.pushViewController(mainTabBarVC, animated: true)
            } else if indexPath.row == 0{
                // Open the messages page with index = 0 and the incidents page with index = 1
                //                showTabBar(defaultIndex: 2)
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 2
                navigationController?.pushViewController(mainTabBarVC, animated: true)
            }
        }
            //        else if indexPath.section == 2 {
            //            // Open the create geofence page
            //            let createGeoFenceVC = StoryboardManager.contactStoryBoard().getController(identifier: "CreateGeoFenceVC") as! CreateGeoFenceViewController
            //            createGeoFenceVC.isFromMenu = true
            //            createGeoFenceVC.titleString = "Create GeoFence"
            //            // Handle `submit` button
            //            createGeoFenceVC.submitButtonAction = {
            //                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
            //                mainTabBarVC.defaultIndex = 3
            //                self.navigationController?.pushViewController(mainTabBarVC, animated: false)
            //            }
            //            navigationController?.pushViewController(createGeoFenceVC, animated: true)
            //        }
        else if indexPath.section == 2 {
            // Open the notification settings page
            let notificationSettingsVC = StoryboardManager.menuStoryBoard().getController(identifier: "NotificationSettingsVC") as! NotificationSettingsViewController
            notificationSettingsVC.isSettings = indexPath.row == 1
            navigationController?.pushViewController(notificationSettingsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 29
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: HeaderNotificationView = HeaderNotificationView.fromNib()
        headerView.headerLabel.text = ""
        headerView.topView.isHidden = section == 0
        return headerView
    }
    
    
}








extension MenuViewController {
    
    
    
    private func showMenuAddContact() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.isFromEmergency = true
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = false
        menuAddContactVC.isAddProCode = false
        // Handle action of the add contact tab
        // Handle `addContact` button of the add contact tab
        menuAddContactVC.addContactButtonAction = {
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.delegate = self
            allContactVC.isFromEmergency = true
            allContactVC.isAddContact = true
            // Add Contact
            allContactVC.addContactAction = { contactList in
                //self.contactListContainerView.isHidden = contactList.count == 0
            }
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
        // Handle `manually` button
        menuAddContactVC.manuallyAddButtonAction = {
            // Handle action when is showed from the add contact page
            let addFamilyNC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyNC") as! UINavigationController
            let addFamilyVC = addFamilyNC.topViewController as! AddFamilyViewController
            addFamilyVC.delegate = self
            
            addFamilyVC.isFromEmergency = true
            
            addFamilyNC.modalTransitionStyle = .crossDissolve
            let image: UIImage = #imageLiteral(resourceName: "search-icon")//UIImage(named: "afternoon")!
            // bgImage = UIImageView(image: image)
            // Handle `invite` action.
            addFamilyVC.inviteBarButtonAction = { userName in
                
            }
            self.navigationController?.pushViewController(addFamilyVC, animated: true)
        }
        // Handle action of the add pro code tab
        // Handle `search pro code` button
        menuAddContactVC.searchProCodeButtonAction = {
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = false
            // Add Organization
            allContactVC.addOrganizationAction = { [unowned self] organizationList in
                
            }
            
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
        // Handle `error Pro code` button
        menuAddContactVC.errorProCodeButtonAction = {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let message = "Enter a valid ProCode."
            self.showAlertWithActions("Error",
                                      message: message,
                                      actions: [okAction])
        }
        present(menuAddContactVC, animated: false, completion: nil)
    }
    
    
    
    
    private func showAddOrganizationPage() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = true
        menuAddContactVC.delegate = self
        
        menuAddContactVC.addContactButtonAction = {
            print("addContactButtonAction")
            let searchMyOrganizationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
            searchMyOrganizationVC.isAddOrganization = true
            searchMyOrganizationVC.delegate = self
            self.navigationController?.pushViewController(searchMyOrganizationVC, animated: true)
        }
        
        menuAddContactVC.searchProCodeButtonAction = {
            print("searchProCodeButtonAction")
        }
        
        menuAddContactVC.errorProCodeButtonAction = {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let message = "Enter a valid ProCode."
            self.showAlertWithActions("Error",
                                      message: message,
                                      actions: [okAction])
        }
        present(menuAddContactVC, animated: false, completion: nil)
    }
    
}









extension MenuViewController:AddFamilyViewControllerDelegate,ContactListViewControllerDelegate,MenuAddContactDelegate {
    
    func didclickMenu(arrOrgan: Organization) {
        
    }
    
    
    func didFinishAdding() {
        let vc = StoryboardManager.mainStoryBoard().getController(identifier: "AddContactVC") as! AddContactViewController
        vc.isNotShowPermissionPage = true
        vc.isAddEmergencyContacts = true
        vc.showAddPopup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didFinishAddingContacts() {
        let vc = StoryboardManager.mainStoryBoard().getController(identifier: "AddContactVC") as! AddContactViewController
        vc.isNotShowPermissionPage = true
        vc.isAddEmergencyContacts = true
        vc.showAddPopup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}







extension MenuViewController:SearchOrganizationDelegate {
    func didfinish() {
        let vc = StoryboardManager.mainStoryBoard().getController(identifier: "AddContactVC") as! AddContactViewController
        vc.isNotShowPermissionPage = true
        vc.isAddEmergencyContacts = false
        vc.defaultSegmentedIndex = 1
        vc.showAddPopup = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getUserDetails() {
        
        let url = BASE_URL + Constants.USER_DETAILS
        
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
                
                if let info = json.array?.first {
                    self.profileDetail = ProfileDetailModel.init(json: info)
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
}
