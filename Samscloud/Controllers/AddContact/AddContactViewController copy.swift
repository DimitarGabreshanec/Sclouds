//
//  AddContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    // MARK: - IBOutlet
    // `Add Contact` tab
    @IBOutlet weak var addContactContainerView: UIView!
    @IBOutlet weak var contactContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var addContactStyleLabel: UILabel!
    
    // Contact list
    @IBOutlet weak var contactListContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goHomeButton: UIButton!
    
    // MARK: - Private let/var
    private var userNameList = [ContactEntry]()
    private let spacingLeftRight: CGFloat = 49
    
    // MARK: - Variables
    var organizationArray = [Organization]()
    // Display the all contact list or organizationList of the add pro code
    var displayList = [ContactEntry]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var isNotShowPermissionPage = false
    var isAddEmergencyContacts = false
    var isAddProCode = false
    var isAddOrganization = false
    var isNotAddProCode = false
    var defaultSegmentedIndex = 0
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add"
        
        // roundView
        addContactContainerView.roundRadius()
        goHomeButton.roundRadius()
        
        // contentInset
        collectionView.contentInset = UIEdgeInsets(top: 0, left: spacingLeftRight, bottom: 0, right: spacingLeftRight)
        
        // set current list
        //displayList = defaultSegmentedIndex == 0 ? userNameList : organizationArray
        defaultSegmentedIndex == 0 ? displayList = userNameList : collectionView.reloadData()
        contactListContainerView.isHidden = organizationArray.count == 0
        
        showPermissionPage()
        prepareSegmentedControl()
        changeUI(selectedSegmentIndex: defaultSegmentedIndex)
        showAddContactPage()
        showAddOrganization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        prepareNavigation()
        let notification = Notification.Name("OrganizationEable")
        NotificationCenter.default.addObserver(self, selector: #selector(OrganizationEable(not:)), name: notification, object: nil)
    }
    @objc func OrganizationEable(not: Notification) {
        organizationArray.removeAll()
        organizationArray = kAppDelegate.organizationArray
        self.collectionView.reloadData()
    }
    // MARK: - Private methods
    
    private func prepareNavigation() {
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItems = []
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
            let permissionVC = StoryBoardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
            permissionVC.isLocation = true
            permissionVC.modalTransitionStyle = .crossDissolve
            
            present(permissionVC, animated: false, completion: nil)
        }
        
        if isAddProCode {
            // Show the contact list page
            let allContactVC = StoryBoardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = false
            
            allContactVC.backButtonAction = {
                self.isAddProCode = false
                self.navigationController?.popViewController(animated: false)
            }
            
            //Add Organization
            allContactVC.addOrganizationAction = { [unowned self] organizationList in
                self.isAddProCode = false
                organizationList.forEach({ (organization) in
                    let isExistOrganization = self.organizationArray.contains(where: { $0.orgtId == organization.orgtId })
                    if !isExistOrganization {
                        self.organizationArray.append(organization)
                    }
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
            let allContactVC = StoryBoardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = true
            
            // Add Contact
            allContactVC.addContactAction = { contactList in
                contactList.forEach({ (contact) in
                    let isExistContact = self.userNameList.contains(where: { $0.name  == contact.name })
                    if !isExistContact {
                        self.userNameList.append(contact)
                    }
                })
                self.displayList = self.userNameList
                self.contactListContainerView.isHidden = contactList.count == 0
            }
            
            self.navigationController?.pushViewController(allContactVC, animated: true)
        }
        
        // Handle `manually` button
        menuAddContactVC.manuallyAddButtonAction = {
            // Handle action when is showed from the add contact page
            let addFamilyNC = StoryBoardManager.contactStoryBoard().getController(identifier: "AddFamilyNC") as! UINavigationController
            let addFamilyVC = addFamilyNC.topViewController as! AddFamilyViewController
            addFamilyNC.modalTransitionStyle = .crossDissolve
            
            // Handle `invite` action.
            addFamilyVC.inviteBarButtonAction = { userName in
                let isExistContact = self.userNameList.contains(where: { $0.name == userName })
                if !isExistContact {
                    //self.userNameList.append(userName)
                }
                self.displayList = self.userNameList
                self.contactListContainerView.isHidden = self.userNameList.count == 0
            }
            
            self.present(addFamilyNC, animated: false, completion: nil)
        }
        
        // Handle action of the add pro code tab
        // Handle `search pro code` button
        menuAddContactVC.searchProCodeButtonAction = {
            let allContactVC = StoryBoardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isAddContact = false
            
            // Add Organization
            allContactVC.addOrganizationAction = { [unowned self] organizationList in
                organizationList.forEach({ (organization) in
                    let isExistOrganization = self.organizationArray.contains(where: { $0.orgtId == organization.orgtId })
                    if !isExistOrganization {
                        self.organizationArray.append(organization)
                    }
                })
                //self.displayList = self.organizationArray
                self.collectionView.reloadData()
                self.contactListContainerView.isHidden = organizationList.count == 0
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
        // Show the search my organization page
        let searchMyOrganizationVC = StoryBoardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
        searchMyOrganizationVC.isAddOrganization = true
        
        // Handle `add` organization
        searchMyOrganizationVC.addOrganizationButtonAction = { [unowned self] organizations in
            // Reload organization list
            organizations.forEach({ (organization) in
                let isExistOrganization = self.organizationArray.contains(where: { $0.orgtId == organization.orgtId })
                if !isExistOrganization {
                    self.organizationArray.append(organization)
                }
            })
            //self.displayList = self.organizationArray
            self.collectionView.reloadData()
            self.contactListContainerView.isHidden = organizations.count == 0
        }
        
        self.navigationController?.pushViewController(searchMyOrganizationVC, animated: true)
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
            // Show/hide contact list
            contactListContainerView.isHidden = userNameList.count == 0
            displayList = userNameList
            
            // Change status add organization
            isAddOrganization = false
        }
        else {
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
            }
            else {
                changeUIWithOrganization()

            }
            // Show/hide contact list
            contactListContainerView.isHidden = organizationArray.count == 0
            //displayList = organizationArray
            collectionView.reloadData()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func addContactButtonAction(_ sender: Any) {
        if isAddOrganization {
            showAddOrganizationPage()
        }
        else {
            showMenuAddContact()
        }
    }
    
    @IBAction func cancelAddButtonAction(_ sender: Any) {
        AppState.setHomeVC()
    }
    
    @IBAction func goHomeButtonAction(_ sender: UIButton) {
        AppState.setHomeVC()
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        changeUI(selectedSegmentIndex: sender.selectedSegmentIndex)
    }
}

// MARK: - UICollectionViewDataSource

extension AddContactViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
                return displayList.count + 1
        }
        return organizationArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = segmentedControl.selectedSegmentIndex == 0 ? ContactCollectionViewCell.organizationCell : ContactCollectionViewCell.organizationCell
        let cellID = indexPath.item == displayList.count ? ContactCollectionViewCell.addMoreIdentifier : mainCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                      for: indexPath) as! ContactCollectionViewCell
       
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.userImageView?.roundRadius()
            if indexPath.item != displayList.count {
                cell.userNameLabel.text = displayList[indexPath.row].name
            }
        } else {
            if indexPath.item != organizationArray.count {
                if indexPath.row == 0 {
                    let value = organizationArray[indexPath.row]
                  //   cell.userNameLabel.text = value.orgName
                } else {
                
                    
                }
            }
            cell.userImageView?.layer.cornerRadius = 8
        }
        
        return cell
    }
    // request the Organisation API
    func organizationListAPiCaling() {
        SwiftLoader.show(title:"Please Wait...", animated: false)
        //https://e740439e-0c75-443a-ad4c-43500d92e975.mock.pstmn.io/organizationList
        let param = ["base_entity": 0,
                     "organizationId":"","userId":""] as [String : Any]
        PSApi.apiRequestWithEndPoint(.phone, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            print(response)
            let statusCode = response.response?.statusCode
            if  statusCode == 201 {
            } else {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AddContactViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize: CGFloat = 76
        return CGSize(width: imageSize + 16, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == displayList.count {
            if isAddOrganization {
                showAddOrganizationPage()
            }
            else {
                showMenuAddContact()
            }
        }
        else {
            if segmentedControl.selectedSegmentIndex == 0 {
                let removeContactVC = StoryBoardManager.contactStoryBoard().getController(identifier: "RemoveContactVC") as! RemoveContactViewController
                let contact = displayList[indexPath.row]
                removeContactVC.name = contact.name
                
                // Handle `remove` button
                removeContactVC.removeContactAction = {
                    self.userNameList.remove(at: indexPath.row)
                    self.contactListContainerView.isHidden = self.userNameList.count == 0
                    self.displayList = self.userNameList
                }
                navigationController?.pushViewController(removeContactVC, animated: true)
            }
        }
    }
}
