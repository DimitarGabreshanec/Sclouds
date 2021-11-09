//
//  AddFamilyOnContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON


class AddFamilyOnContactViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contactContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: GMSMapView!{
        didSet{
            if mapView != nil {
                mapView.isMyLocationEnabled = true
                mapView.settings.myLocationButton = true
                
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"){
                    mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
                }
    
            }
        }
    }
    
    var isShowMessagePage = false
    var emergenry = [ContactModel]()
    var contacts = [[ContactModel]]()
    var location:CLLocation?
    let titles = ["PARENTS", "RELATIVES", "FRIENDS"]
    

    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        // Set contacts data
        //contacts = fetchAllContact()
        self.location = appDelegate.currentLocation
        
        prepareSegmentedControl()
        prepareTableView()
        prepareNavigation()
        loadCache()
        getUserContacts()
        animateZoomLevel(zoom: 14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate.currentVC = self
        headerView.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        //translucentNavigationBar()
        //prepareNavigationWithBlackTitle()
        
        // Show message page when click message from new message page
        if isShowMessagePage {
            isShowMessagePage = false
            let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
            mainTabBarVC.defaultIndex = 1
            navigationController?.pushViewController(mainTabBarVC, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headerView.isHidden = true
    }
    
    
    // MARK: - ACTIONS
    
    @objc func addButtonAction() {
        /*let addFamilyNC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyNC") as! UINavigationController
        let addFamilyVC = addFamilyNC.topViewController as! AddFamilyViewController
        addFamilyVC.isAddFamilyOnContact = true
        addFamilyNC.modalTransitionStyle = .crossDissolve
        present(addFamilyNC, animated: false, completion: nil)*/
        
        self.showMenuAddContact()
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        // Add barButtonItem for rightBarButton
        let addButton = creatCustomBarButton(title: "Add")
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func fetchAllContact() -> [String] {
        return ["Gordon Pittman", "Alma Elliot", "Blanche Day", "Ethan Reyes", "Susan Weaver", "Della Richards", "Rosalie Boone", "Nora Holt", "Frances Sparks", "Leo Cortez", "A", "B" ]
    }
    
    private func prepareSegmentedControl() {
        // SegmentControl for title
        let fontAttributeNormal = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        let fontAttributeSelected  = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.removeBorder()
        segmentedControl.tintColor = UIColor.mainColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(fontAttributeNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(fontAttributeSelected, for: .selected)
        contactContainerView.bordered(withColor: UIColor.mainColor(), width: 1, radius: 20)
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableViewTopConstraint.constant = 6
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("SEGMENTED CONTROLLER VALUE CHANGED - ADDFAMILYONCONTACT_VC")
        tableViewTopConstraint.constant = sender.selectedSegmentIndex == 0 ? 6 : 15
        tableView.reloadData()
    }
    
    
    // MARK: - ADD_TAB_BAR_DELEGATE
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            AppState.setHomeVC()
        }
    }
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return contacts.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return emergenry.count
        }else{
            return contacts[section].count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: FamilyContactTableViewCell.identifier, for: indexPath) as! FamilyContactTableViewCell
        cell.addressLabel.numberOfLines = 1
        cell.timeAgoLabel?.isHidden = false
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let count = contacts[indexPath.section].count
            let list = contacts[indexPath.section]
            cell.bottomLineView.isHidden = count == 1 || indexPath.row == count - 1
            cell.userNameLabel.text = list[indexPath.row].name
            
            if let address = list[indexPath.row].location_status?.location_address , address != "" {
                cell.addressLabel.text = address
                
                let lat = list[indexPath.row].location_status?.location_latitude
                let long = list[indexPath.row].location_status?.location_longitude
                
                if lat != nil && long != nil && appDelegate.currentLocation != nil{
                    cell.setForDistance()
                    let location = CLLocation.init(latitude: lat!, longitude: long!)
                    let distance = appDelegate.currentLocation.distance(from: location)/1609.34
                    let distanceStr = String.init(format: "%.1f miles", Float(distance))
                    cell.rangerButton.setTitle(distanceStr, for: .normal)
                }
            
                if let dateStr = list[indexPath.row].location_status?.location_last_updated {
                    let agoTime = dateStr.syncDate()?.getElapsedInterval()
                    cell.timeAgoLabel.text = agoTime
                }
                
            }else{
                cell.addressLabel.text = "Location not available"
                cell.setCheckinView()
            }
            
            let profile_image = list[indexPath.row].profile_image ?? ""
            if profile_image != "" {
                loadImage(profile_image, cell.userImageView, activity: nil, defaultImage: nil)
            }else{
                cell.userImageView.image = UIImage.init(named: "userAvatar")
            }
            let date = list[indexPath.row].created_at ?? ""
            let requestedDate = date.toIncidentDate()?.toRequestContactStr() ?? ""
            
            if list[indexPath.row].status == "Pending" {
                cell.pendingLabel.isHidden = false
                cell.messageButton.isHidden = true
                cell.setPendingView()
                cell.addressLabel.text = "Sent \(requestedDate)"
            }else{
                cell.pendingLabel.isHidden = true
                cell.messageButton.isHidden = false
            }
            
            cell.rangerButtonAction = { () in
                let contactList = self.contacts[indexPath.section]
                let contact = contactList[indexPath.row]
                self.requestCheckInFor(contact: contact)
            }
            
        }else{
            cell.bottomLineView.isHidden = emergenry.count == 1 || indexPath.row == emergenry.count - 1
            cell.userNameLabel.text = emergenry[indexPath.row].name
           
            let contact = emergenry[indexPath.row]
            let location_status = contact.location_status
            let request_checkin_data = contact.request_checkin_data
            
            let requet_checkin_status = request_checkin_data?.request_checkin_last_updated?.syncDate()?.getElapsedIntervalTimeOnly()
            
            let location_update_status = location_status?.location_last_updated?.syncDate()?.getElapsedIntervalTimeOnly() ?? 1000
    
            if requet_checkin_status == nil {
                cell.addressLabel.text = "Location not available"
                cell.setCheckinView()
            }else if location_status?.location_share_location == false {
                
                if location_update_status  <= 20 {
                    showLocation(cell: cell, location: location_status)
                }else if requet_checkin_status! <= 20 {
                    showCheckinLocation(cell: cell, location: request_checkin_data)
                }else{
                    cell.addressLabel.text = "Location not available"
                    cell.setCheckinView()
                }
            }else if location_status?.location_share_location == true {
                showLocation(cell: cell, location: location_status)
            }else{
                cell.addressLabel.text = "Location not available"
                cell.setCheckinView()
            }
            
            /*if let address = emergenry[indexPath.row].location_status?.location_address , address != "" {
                
                cell.addressLabel.text = address
                
                let lat = emergenry[indexPath.row].location_status?.location_latitude
                let long = emergenry[indexPath.row].location_status?.location_longitude
                
                if lat != nil && long != nil && appDelegate.currentLocation != nil{
                    cell.setForDistance()
                    let location = CLLocation.init(latitude: lat!, longitude: long!)
                    let distance = appDelegate.currentLocation.distance(from: location)/1609.34
                    let distanceStr = String.init(format: "%.1f miles", Float(distance))
                    cell.rangerButton.setTitle(distanceStr, for: .normal)
                }
                
                if let dateStr = emergenry[indexPath.row].location_status?.location_last_updated {
                    let agoTime = dateStr.syncDate()?.getElapsedInterval()
                    cell.timeAgoLabel.text = agoTime
                }
                
            }else{
                cell.addressLabel.text = "Location not available"
                cell.setCheckinView()
            }*/
            
            let profile_image = emergenry[indexPath.row].profile_image ?? ""
            if profile_image != "" {
                loadImage(profile_image, cell.userImageView, activity: nil, defaultImage: nil)
            }else{
                cell.userImageView.image = UIImage.init(named: "userAvatar")
            }
            let date = emergenry[indexPath.row].created_at ?? ""
            let requestedDate = date.toIncidentDate()?.toRequestContactStr() ?? ""
            
            if emergenry[indexPath.row].status == "Pending" {
                cell.pendingLabel.isHidden = false
                cell.messageButton.isHidden = true
                cell.setPendingView()
                cell.addressLabel.text = "Sent \(requestedDate)"
            }else{
                cell.pendingLabel.isHidden = true
                cell.messageButton.isHidden = false
            }
            
            cell.rangerButtonAction = { () in
                //let contactList = self.contacts[indexPath.section]
                let contact = self.emergenry[indexPath.row]
                self.requestCheckInFor(contact: contact)
            }
            
        }
        
        return cell
    }
    
    
    func showLocation(cell:FamilyContactTableViewCell, location:LocationStatus?) {
        if let address = location?.location_address , address != "" {
            cell.addressLabel.text = address
            
            let lat = location?.location_latitude
            let long = location?.location_longitude
            
            if lat != nil && long != nil && appDelegate.currentLocation != nil{
                cell.setForDistance()
                let location = CLLocation.init(latitude: lat!, longitude: long!)
                let distance = appDelegate.currentLocation.distance(from: location)/1609.34
                let distanceStr = String.init(format: "%.1f miles", Float(distance))
                cell.rangerButton.setTitle(distanceStr, for: .normal)
            }
            
            if let dateStr = location?.location_last_updated {
                let agoTime = dateStr.syncDate()?.getElapsedInterval()
                cell.timeAgoLabel.text = agoTime
            }
        }
    }
    
    
    func showCheckinLocation(cell:FamilyContactTableViewCell, location:RequestCheckinData?) {
        if let address = location?.request_checkin_address , address != "" {
            cell.addressLabel.text = address
            
            let lat = location?.request_checkin_latitude
            let long = location?.request_checkin_longitude
            
            if lat != nil && long != nil && appDelegate.currentLocation != nil{
                cell.setForDistance()
                let location = CLLocation.init(latitude: lat!, longitude: long!)
                let distance = appDelegate.currentLocation.distance(from: location)/1609.34
                let distanceStr = String.init(format: "%.1f miles", Float(distance))
                cell.rangerButton.setTitle(distanceStr, for: .normal)
            }
            
            if let dateStr = location?.request_checkin_last_updated {
                let agoTime = dateStr.syncDate()?.getElapsedInterval()
                cell.timeAgoLabel.text = agoTime
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            let count = contacts[section].count
            if count == 0 {return 0}
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView: HeaderAddFamilyView = HeaderAddFamilyView.fromNib()
        headerSectionView.topView.isHidden = section == 0
        if section != 3 {
           headerSectionView.relationshipLabel.text = self.titles[section]
        }else {
            headerSectionView.relationshipLabel.text = "PENDING"
        }
        return headerSectionView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let vc = ContactProfileViewController.instanse()
            vc.contact = contacts[indexPath.section][indexPath.row]
            vc.removeContactAction = {
                self.removeContact(contact: vc.contact)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ContactProfileViewController.instanse()
            vc.contact = emergenry[indexPath.row]
            vc.removeContactAction = {
                self.removeContact(contact: vc.contact)
            }
            //requestCheckInFor(contact: emergenry[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func removeContact(contact:ContactModel?) {
        
        guard let id = contact?.id else {return}
        SwiftLoader.show(title:"Removing...", animated: false)
        
        let url = BASE_URL + Constants.DELETE_CONTACT + "\(id)/"
        
        APIsHandler.DELETEApi(url, param: nil, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code != 204{
                    let msg = json["message"].stringValue
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
                                           self.tableView.reloadData()
                                            self.getUserContacts()
                                                  })
                                       self.showAlertWithActions(msg, message: "", actions: [okAction])
                                       return
                }
//                self.getUserContacts()
            }
        }
    }
}









extension AddFamilyOnContactViewController {
    
    func getUserContacts(){
        
        let url = BASE_URL + Constants.GET_USER_CONTACTS
        
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
                let contacts:[ContactModel] = json.array?.decode() ?? []
                self.parseContacts(list: contacts)
                UserDefaults.standard.setContactsCache(json)
            }
        }
        
    }
    
    func loadCache() {
        if let json = UserDefaults.standard.getContactsCache() {
            let contacts:[ContactModel] = json.array?.decode() ?? []
            self.parseContacts(list: contacts)
        }
    }
    
    func parseContacts(list:[ContactModel]) {
        
        let array = Dictionary.init(grouping: list, by: {$0.contact_type!})
        let faimlyList = array.filter({$0.key == "Family"}).first?.value ?? []
        
        let acceptedfaimlyList = faimlyList.filter({$0.status == "Accepted"})
        let pendingfaimlyList = faimlyList.filter({$0.status == "Pending"})
        
        
        let wholeEmergencyContacts = array.filter({$0.key == "Emergency"}).first?.value ?? []
        
        let acceptedEmergency = wholeEmergencyContacts.filter({$0.status == "Accepted"})
        let pendingEmergency = wholeEmergencyContacts.filter({$0.status == "Pending"})
        
        self.emergenry = acceptedEmergency + pendingEmergency
        
        let array1 = Dictionary.init(grouping: acceptedfaimlyList, by: {$0.relationship!})
        
        self.contacts.removeAll()
     
        list.forEach({
            
            if let lat = $0.location_status?.location_latitude , let long = $0.location_status?.location_longitude {
                let marker = GMSMarker.init()
                marker.title = $0.name
                marker.snippet = $0.relationship
                marker.isTappable = true
                marker.icon = UIImage.init(named: "map_icon")
                marker.position = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                marker.map = self.mapView
            }
            
        })
        
        
        let parentList = array1.filter({$0.key.lowercased() == "mother" || $0.key.lowercased() == "father" })
        let friendlist = array1.filter({$0.key.lowercased() == "friend"})
        let relativelist = array1.filter({$0.key.lowercased() == "brother" || $0.key.lowercased() == "sister"})
        
        contacts.append(parentList.first?.value ?? [])
        contacts.append(friendlist.first?.value ?? [])
        contacts.append(relativelist.first?.value ?? [])
        contacts.append(pendingfaimlyList)
        
        self.tableView.reloadData()
    }
}







extension AddFamilyOnContactViewController:AddFamilyViewControllerDelegate,ContactListViewControllerDelegate {
    
    private func showMenuAddContact() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = false
        menuAddContactVC.isAddProCode = false
        if segmentedControl.selectedSegmentIndex == 1 {
            menuAddContactVC.isFromEmergency = true
        }
        // Handle action of the add contact tab
        // Handle `addContact` button of the add contact tab
        menuAddContactVC.addContactButtonAction = {
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.delegate = self
            allContactVC.isAddContact = true
            if self.segmentedControl.selectedSegmentIndex == 1 {
                allContactVC.isFromEmergency = true
            }
            // Add Contact
            allContactVC.addContactAction = { contactList in
                //self.contactListContainerView.isHidden = contactList.count == 0
            }
            if self.segmentedControl.selectedSegmentIndex == 1 {
                allContactVC.isFromEmergency = true
            }
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
        // Handle `manually` button
        menuAddContactVC.manuallyAddButtonAction = {
            // Handle action when is showed from the add contact page
            let addFamilyNC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyNC") as! UINavigationController
            let addFamilyVC = addFamilyNC.topViewController as! AddFamilyViewController
            addFamilyVC.delegate = self
            addFamilyNC.modalTransitionStyle = .crossDissolve
            if self.segmentedControl.selectedSegmentIndex == 1 {
                addFamilyVC.isFromEmergency = true
            }
            
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
    
    
    func didFinishAdding() {
        self.getUserContacts()
    }
    
    func didFinishAddingContacts() {
        self.getUserContacts()
    }
    
}







// MARK:- MKMapViewDelegate...
extension AddFamilyOnContactViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            self.location = location
            mapView?.removeObserver(self, forKeyPath: "myLocation")
            self.animateZoomLevel(zoom: 14)
        }
    }
    
    
    func animateZoomLevel(zoom:CGFloat) {
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = zoom
        zoomAnimation.duration = CFTimeInterval(2.5)
        
        mapView?.layer.add(zoomAnimation, forKey: nil)
        perform(#selector(updateCamera), with: nil, afterDelay: 2.3)
    }
    
    @objc func  updateCamera() {
        
        if let loc = self.location {
            let camera = GMSCameraPosition.camera(withLatitude: appDelegate.currentLocation.coordinate.latitude, longitude: appDelegate.currentLocation.coordinate.longitude, zoom: 17.0)
            mapView.camera = camera
        }
    }

    
}









// MARK:- APIs...
extension AddFamilyOnContactViewController {

    func requestCheckInFor(contact:ContactModel) {
        
        guard let id = contact.id else {return}
        
        let url = BASE_URL + "users/contact-request-check-in/"
        SwiftLoader.show(title: "Requesting help ...", animated: true)
        
        print(JSON.init(["contact_id":id]))
        
        ApiManager.shared.POSTApi(url, param: ["contact_id":id], header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }else if code == 200 {
                    showAlert(msg: "Request sent successfully", title: "Message", sender: self)
                }
                
            }
        }
        
    }
    
}





extension String {
    func dateFromUTCString()->Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let convertedDate = formatter.date(from: self)
        return convertedDate
    }
    
    func syncDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        return date
    }
    
}




