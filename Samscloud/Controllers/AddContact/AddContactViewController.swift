//
//  AddContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddContactViewController: UIViewController, UICollectionViewDelegateFlowLayout ,SearchOrganizationDelegate,ContactListViewControllerDelegate,AddFamilyViewControllerDelegate{
    
    @IBOutlet weak var addContactContainerView: UIView!
    @IBOutlet weak var contactContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var addContactStyleLabel: UILabel!
    @IBOutlet weak var contactListContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goHomeButton: UIButton!
    @IBOutlet weak var addLaterButton: UIButton!
    
    let spacingLeftRight: CGFloat = 49
  
    
    var isNotShowPermissionPage = false
    var isAddEmergencyContacts = false
    var isAddProCode = false
    var isAddOrganization = false
    var isNotAddProCode = false
    var defaultSegmentedIndex = 0
    var isFreshSignup = false
    
    var showAddPopup = true
    var contacts = [ContactModel]()
    var organizations = [OrganizationModel]()

    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add"
        // roundView
        addContactContainerView.roundRadius()
        goHomeButton.roundRadius()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: spacingLeftRight, bottom: 0, right: spacingLeftRight)
       
        //contactListContainerView.isHidden = organizationArray.count == 0
        showPermissionPage()
        prepareSegmentedControl()
        
        changeUI(selectedSegmentIndex: defaultSegmentedIndex)
        
//        getUserContacts()
        getOrganizationList()
        
        if showAddPopup {
            showAddContactPage()
            showAddOrganization()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        navigationController?.isNavigationBarHidden = false
        prepareNavigation()
         getUserContacts()
    }
    

    private func prepareNavigation() {
        if isFreshSignup {
            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.leftBarButtonItems = []
        }else{
            addLaterButton.isHidden = true
            createBackBarButtonItem()
        }
    }
    
    private func prepareSegmentedControl() {
        // SegmentControl for title
        let fontAttributeNormal = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        let fontAttributeSelected  = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.removeBorder()
        segmentedControl.tintColor = UIColor.mainColor()
        segmentedControl.selectedSegmentIndex = defaultSegmentedIndex
        segmentedControl.setTitleTextAttributes(fontAttributeNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(fontAttributeSelected, for: .selected)
        contactContainerView.bordered(withColor: UIColor.mainColor(), width: 1, radius: 20)
    }
    
    private func showAddContactPage() {
        if isAddEmergencyContacts {
            isAddEmergencyContacts = false
            showMenuAddContact()
        }
    }
    
    private func showAddOrganization() {
        if isAddOrganization {
            isAddEmergencyContacts = false
            changeUIWithOrganization()
            showAddOrganizationPage()
        }
    }
    
    private func showPermissionPage() {
        // Show permission page
        if !isNotShowPermissionPage {
            if kAppDelegate.verifyFlag == true {
                kAppDelegate.verifyFlag = false
                let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
                permissionVC.isLocation = true
                permissionVC.modalTransitionStyle = .crossDissolve
                present(permissionVC, animated: false, completion: nil)
            }
        }
        if isAddProCode { // Show the contact list page
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = false
            allContactVC.delegate = self
            allContactVC.backButtonAction = {
                self.isAddProCode = false
                self.navigationController?.popViewController(animated: false)
            }
            //Add Organization
            allContactVC.addOrganizationAction = { [unowned self] organizationList in
                self.isAddProCode = false
                organizationList.forEach({ (organization) in
                    
                })
                //self.displayList = self.organizationArray
                self.collectionView.reloadData()
                self.contactListContainerView.isHidden = organizationList.count == 0
            }
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
    }
    
    
    private func showMenuAddContact() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = false
        menuAddContactVC.isAddProCode = segmentedControl.selectedSegmentIndex == 1
        // Handle action of the add contact tab
        // Handle `addContact` button of the add contact tab
        menuAddContactVC.addContactButtonAction = {
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = true
            allContactVC.isFromEmergency = true
            // Add Contact
            allContactVC.delegate = self
            allContactVC.addContactAction = { contactList in
                self.contactListContainerView.isHidden = contactList.count == 0
            }
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
        // Handle `manually` button
        menuAddContactVC.manuallyAddButtonAction = {
            // Handle action when is showed from the add contact page
            let addFamilyNC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyNC") as! UINavigationController
            let addFamilyVC = addFamilyNC.topViewController as! AddFamilyViewController
            addFamilyNC.modalTransitionStyle = .crossDissolve
            addFamilyVC.delegate = self
            addFamilyVC.isFromEmergency = true
        
            addFamilyVC.inviteBarButtonAction = { userName in
    
            }
            self.present(addFamilyNC, animated: false, completion: nil)
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
        // Handle `search` button on the add organization page
        menuAddContactVC.addContactButtonAction = {
            self.showSearchMyOrganization()
        }
        // Handle `search` button on the search pro code page
        menuAddContactVC.searchProCodeButtonAction = {
            self.showSearchMyOrganization()
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
    
    private func showSearchMyOrganization() {
        let searchMyOrganizationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
        searchMyOrganizationVC.isAddOrganization = true
        searchMyOrganizationVC.delegate = self
        self.navigationController?.pushViewController(searchMyOrganizationVC, animated: true)
    }
    
    
    func didfinish() {
        if isFreshSignup {
            AppState.setHomeVC()
            return
        }
        self.getOrganizationList()
    }
    
    private func changeUIWithOrganization() {
        segmentedControl.setTitle("Organization", forSegmentAt: 1)
        addContactStyleLabel.text = "Add Organization"
    }
    
    private func changeUI(selectedSegmentIndex: Int) {
        if selectedSegmentIndex == 0 {
            descriptionLabel.text = """
            We recommend adding at least one person
            from your family, friends or trusted colleagues
            so they can be notified whenever you are
            in need of assistance.
            """
            addContactStyleLabel.text = "Add Contacts"
            contactListContainerView.isHidden = contacts.count == 0
            isAddOrganization = false
            collectionView.reloadData()
        } else {
            descriptionLabel.text = """
            Subcribe to trusted organizations
            and recieve Emergency Notifications
            when there are possible threats to
            your safety.
            """
            // Change status add organization
            isAddOrganization = true
            if isAddOrganization && isNotAddProCode {
                isAddOrganization = false
                addContactStyleLabel.text = "Add Pro Code"
            } else {
                changeUIWithOrganization()
            }
            contactListContainerView.isHidden = organizations.count == 0
            collectionView.reloadData()
        }
        
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func addContactButtonAction(_ sender: Any) {
        if isAddOrganization {
            showAddOrganizationPage()
        } else {
            showMenuAddContact()
        }
    }
    
    @IBAction func cancelAddButtonAction(_ sender: Any) {
        if isFreshSignup {
          AppState.setHomeVC()
        }else{
          navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func goHomeButtonAction(_ sender: UIButton) {
        if isFreshSignup {
           AppState.setHomeVC()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        changeUI(selectedSegmentIndex: sender.selectedSegmentIndex)
    } 
    
    
    func didFinishAddingContacts() {
        if isFreshSignup {
           AppState.setHomeVC()
        }else{
            getUserContacts()
        }
    }
 
}







// MARK: - UICollectionViewDataSource
extension AddContactViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return contacts.count + 1
        }
        return organizations.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if contacts.count == indexPath.item {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.addMoreIdentifier,
                                                              for: indexPath) as! ContactCollectionViewCell
                cell.userImageView?.roundRadius()
                return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier,
                                                              for: indexPath) as! ContactCollectionViewCell
                cell.userImageView?.roundRadius()
                cell.userNameLabel.text = contacts[indexPath.row].name
                cell.relationshipLabel.text = contacts[indexPath.row].status
                return cell
            }
            
        }else{
            if organizations.count == indexPath.item {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.addMoreIdentifier,
                                                              for: indexPath) as! ContactCollectionViewCell
                cell.userImageView?.roundRadius()
                return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.organizationCell,
                                                              for: indexPath) as! ContactCollectionViewCell
                cell.userImageView?.roundRadius()
                cell.lblName.text = organizations[indexPath.row].organization_name
                let url = URL(string:organizations[indexPath.row].logo ?? "")
                cell.userImageView.sd_setImage(with: url, placeholderImage:  UIImage(named: "userAvatar"), options: .progressiveLoad, context: nil)
                return cell
            }
        }
        
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize: CGFloat = 76
        return CGSize(width: imageSize + 16, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == contacts.count {showMenuAddContact();return}
            let vc = ContactProfileViewController.instanse()
            vc.contact = contacts[indexPath.item]
            vc.removeContactAction = {
                self.removeContact(indexPath: indexPath)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if segmentedControl.selectedSegmentIndex == 1 {
            if indexPath.row == organizations.count {showAddOrganization();return}
            let vc = OrganizationDetailViewController.instanse()
            //vc.contact = contacts[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    func removeContact(indexPath:IndexPath) {
        guard let id = contacts[indexPath.row].id else {return}
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
                        self.collectionView.reloadData()
                         self.getUserContacts()
                               })
                    self.showAlertWithActions(msg, message: "", actions: [okAction])
                    return
                }
            }
        }
    }
    
    
}












extension AddContactViewController {
    
    
    func getUserContacts(){
        
        let url = BASE_URL + Constants.GET_USER_CONTACTS
        
        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                if code != 200{
//                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
//                    showAlert(msg: msg, title: "Error", sender: self)
                    self.collectionView.reloadData()
                    return
                }
                self.contacts = json.array?.decode() ?? []
                self.changeUI(selectedSegmentIndex: self.segmentedControl.selectedSegmentIndex)
                self.collectionView.reloadData()
            }
        }

    }
    
    
    func getOrganizationList() {
    
        let url = BASE_URL + Constants.ORGANIZATION_LIST
        
        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{

                print(json)
                
                if code != 200{
//                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
//                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                self.organizations = json.array?.decode() ?? []
                self.changeUI(selectedSegmentIndex: self.segmentedControl.selectedSegmentIndex)
                self.collectionView.reloadData()
            }
        }
    }
    
}








extension AddContactViewController:MenuAddContactDelegate {
    
    func didclickMenu(arrOrgan: Organization) {
        
    }
    
    
    func didFinishAdding() {
        if isFreshSignup {
            AppState.setHomeVC()
            return
        }
        getOrganizationList()
    }
    
}
