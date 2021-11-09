//
//  ContactListViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//
import UIKit
import SwiftyJSON
import AddressBook
import Contacts

// MARK: - ACTIONS

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


// MARK: - CLASS


protocol ContactListViewControllerDelegate {
   func didFinishAddingContacts()
}

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var allContacts = [ContactEntry]()
    private var filterContactsDict = [String: [ContactEntry]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var allContactsDict = [String: [ContactEntry]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    var isAddContact = false
    // add or search procode of setting page
    var isAddOrSearchProcode = false
    var isFromIncident = false
    var isAddOrganization = false // from report detail page
    var addOrganizationAction: (([Organization]) -> Void)?
    var addContactAction: (([ContactEntry]) -> Void)?
    var backButtonAction: (() -> Void)?
    var contacts = [ContactEntry]()
    var arrcont = [ContactEntry]()
    var arrOrgan = [Organization]()
    var arrContact = [] as NSMutableArray
    var arrpic = NSMutableArray()
    var arrfname = String()
    var arrlname = String()
    var arrnumber = String()
    var isSearhing = false
    var fliteredContacts = [ContactEntry]()
    var isAddQuickShare = false
    var delegate:ContactListViewControllerDelegate?
    var isFromEmergency = false
    var organizations = [OrganizationModel]()
    var filteredOrganizations = [OrganizationModel]()
    var selectedOrganizationID:String?
    
    var selectedOrganizationIDs = [String]()
    
    var addBarButtonItem:UIBarButtonItem!
    var incident:OngoingIncidentModel?
    var allSamsContacts = [ContactModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showSearchButton: UIButton!
    @IBOutlet weak var searchViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXSearchViewConstraint: NSLayoutConstraint!
    

    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAddOrganization {
            title = "Search Organization"
        } else {
            title = isAddContact ? "All Contacts" : "Search Organization"
        }
        
        searchContainerView.roundRadius()
        tableView.keyboardDismissMode = .onDrag
        
        if !isAddContact {
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableView.automaticDimension
        }
        
        prepareNavigation()
        prepareTextField()
        translucentNavigationBar()
        
        fetchContacts { (contacts) in
            
            for abPerson in contacts {
                if let contact = ContactEntry.init(cnContact: abPerson) {
                   self.allContacts.append(contact)
                }
            }
            
            DispatchQueue.main.async {
                self.getContactListWithKey()
                self.tableView.reloadData()
            }
            self.getRegisteredUsers()
        }
        
        if isAddContact == false {
            addBarButtonItem.isEnabled = false
            getOrganizationList()
        }else{
            //getUserContacts()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        kAppDelegate.checkValue = 0
        getContactListWithKey()
        retrieveAddressBookContacts { (success, contacts) in
            self.tableView.isHidden = !success
            if success && contacts?.count > 0 {
                DispatchQueue.main.async {
                    self.contacts = contacts!
                    self.tableView.reloadData()
                }
                
            }else {
                print("NO CONTACTS TO RETRIEVE / OR NOT RETRIEVED")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    // MARK: - ACTIONS
    
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactEmailAddressesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            request.sortOrder = .givenName
            
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant {
                    do {
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print("ERROR FETCHING CONTACTS: \(error.localizedDescription)")
                    }
                    completion(results)
                } else {
                    print("ACCESS NOT GRANTED: Error \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
    // AddressBook methods
    func retrieveAddressBookContacts(_ completion: @escaping (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        let abAuthStatus = ABAddressBookGetAuthorizationStatus()
        if abAuthStatus == .denied || abAuthStatus == .restricted {
            completion(false, nil)
            return
        }
        let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError?) in
            DispatchQueue.main.async {
                if !granted {
                    print("NOT GRANTED")
                    // self.showAlertMessage("Sorry, you have no permission for accessing the address book contacts.")
                } else {
                    var contacts = [ContactEntry]()
                    let abPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
                    for abPerson in abPeople {
                        if let contact = ContactEntry(addressBookEntry: abPerson) {
                            contacts.append(contact)
                            self.arrcont.append(contact)
                            print("PRINTING SELF.ARRCONT1: \(self.arrcont)")
                            self.allContacts.append(contact)
                        }
                    }
                    //self.fetchAllContact()
                    self.getContactListWithKey()
                    // self.allContacts = self.fetchAllContact().sorted(by: { $0 < $1 })
                    //self.tableView.reloadData()
                    completion(true, contacts)
                }
            }
        }
    }
    
    func organizationList() {
        SwiftLoader.show(title:"Please Wait...", animated: false)
        let param = ["userId":"\(User.sharedUser.id)"]
        PSApi.apiRequestWithEndPointMockUp(.organizationListUrl, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            let statusCode = response.response?.statusCode
            if  statusCode == 200 {
                let dict = response.value!["organziation"]
                let arrList:Array<[String:AnyObject]> = dict.rawValue as! Array
                for item in arrList {
                    var org = Organization.init(dictUserData: response.value?.dictionary ?? [:])
                    org = org.setOrganization(dictUserData: item)
                    self.arrOrgan.append(org)
                }
            } else {
                print("STATUS CODE !200")
            }
        }
    }
    
    private func fetchAllContact() -> [ContactEntry] {
        print("PRINTING SELF.ARRCONT2: \(self.arrcont)")
        print(self.arrcont)
        return self.arrcont
    }
    
    @objc func addBarButtonAction() {
        if isFromIncident {
            shareIncidentWithOrganization()
        } else {
            if isAddContact {
                contactEmergencyAdd()
            } else {
                
            }
        }
    }
    
    func contactEmergencyAdd() {
        _ = [ContactEntry]()
        self.arrContact.removeAllObjects()
        if let indexPaths = self.tableView.indexPathsForSelectedRows {
            indexPaths.forEach { (indexPath) in
                let contact = isSearhing == true ? fliteredContacts[indexPath.row] : allContacts[indexPath.row]
                
                var dictionary =  [String:String]()
                
                dictionary["name"]   = contact.name
                dictionary["phone_number"] = contact.phone
                dictionary["email"]        = contact.email
                
                let relationships:[String] = ["Father","Mother","Brother","Sister","Colleague","Friend"]
                
                if relationships.contains(contact.familyRelation ?? "") {
                    dictionary["relationship"] = contact.familyRelation ?? "Friend"
                }else{
                    dictionary["relationship"] = "Friend"
                }
                
                if isFromEmergency {
                    dictionary["contact_type"] = "Emergency"
                }else{
                   dictionary["contact_type"] =  "Family"
                }
                self.arrContact.add(dictionary)
            }
        }
        // Marks :- Api calling in add contact
        if isAddQuickShare{
           self.addContactQuickShare()
        }else{
          self.contactNumberAdd()
        }
        
    }
    
    // request the Add Contant API
    func contactNumberAdd() {
        
        SwiftLoader.show(title:"Please Wait...", animated: false)
        let addContactUrl: String = "\(BASE_URL)\(Constants.ADD_EMG_CONTACTS)"
    
        ConnectionManager().POSTApi(params: self.arrContact, addContactUrl) { (response, error, statusCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code == 200 || code == 201 {
                    self.navigationForAddContact()
                }else{
                    let msg = json.array?.first?["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
            }
        }
    
    }
    
    
    
    
    // request the Add Contant API
    func addContactQuickShare() {
        
        SwiftLoader.show(title:"Adding...", animated: false)
        
        let addContactUrl: String = "\(BASE_URL)\(Users.EMERGENCY_QUICK_CONTACT)"
        
        guard let object = arrContact.firstObject  as? [String:String] else {return}
        
        
        let dict:[String:Any] = [
            "name": object["name"] ?? "",
            "email": object["email"]  ?? "",
            "phone_number": object["phone_number"] ?? ""
            
        ]
    
        print(JSON.init(dict))
        
        ConnectionManager().POSTApi(params: [dict], addContactUrl) { (response, error, statusCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code == 200 || code == 201 {
                    self.navigationForAddContact()
                }else{
                    let msg = json.array?.first?["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
            }
        }
       
        /*
        APIsHandler.POSTApi(addContactUrl, param: dict, header: header()) { (response, error, statusCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code == 200 || code == 201 {
                    self.navigationForAddContact()
                }else{
                    var msg = json.array?.first?["email"].array?.first?.string
                    if msg == nil {
                       msg = json.array?.first?["phone_number"].array?.first?.string
                    }
                    showAlert(msg: msg ?? "", title: "Error", sender: self)
                }
            }
        }*/
        
    }
    
    
    func navigationForAddContact(){
        self.arrContact.removeAllObjects()
        navigationController?.popViewController(animated: !isAddOrSearchProcode, completion: {
            let contactList = [ContactEntry]()
            if let indexPaths = self.tableView.indexPathsForSelectedRows {
                indexPaths.forEach { (indexPath) in
                    /*let sortedkeys = Array(self.filterContactsDict.keys).sorted() { $0 < $1 }
                    let keyBySection = sortedkeys[indexPath.section]
                    if let contacts1 = self.filterContactsDict[keyBySection] {
                        let contact = contacts1[indexPath.row]
                        contactList.append(contact)
                        var dictionary =  [String:String]()
                        dictionary["name"]   = contact.name
                        //dictionary["last_name"]    = ""
                        dictionary["phone_number"] = contact.phone
                        dictionary["email"]        = contact.email
                        dictionary["relationship"] = ""
                        self.arrContact.add(dictionary)
                    }*/
                }
            }
            // Marks :- Api calling in add contact
            self.contactNumberAdd()
            self.addContactAction?(contactList)
            self.delegate?.didFinishAddingContacts()
        })
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func getContactListWithKey() {
        var groupedContactData = allContacts.chunk {
            $0.name.first.map { String($0) } ?? "" == $1.name.first.map { String($0) } ?? ""
        }
        // Group contacts do not follow Alphabetical
        var differentTexts: ArraySlice<ContactEntry> = []
        allContacts.forEach { (contact) in
            if !contact.name.isAlphabetical {
                differentTexts.append(contact)
            }
        }
        // Add contacts do not follow Alphabetical
        if differentTexts.count != 0 {
            groupedContactData.append(differentTexts)
        }
        // Get contact
        groupedContactData.forEach { (contact) in
            // Get first word of title.
            var key = ""
            let firstContact = contact[contact.startIndex]
            if let firstKey = firstContact.name.first, String(firstKey).isAlphabetical {
                key = "\(firstKey)"
            }
            if let firstKey = firstContact.name.first, !String(firstKey).isAlphabetical {
                key = "#"
            }
            // Get contact by keyword
            let contactWithKey = contact.map{$0}
            allContactsDict.updateValue(contactWithKey, forKey: key)
        }
        filterContactsDict = allContactsDict
    }
    
    
    private func prepareNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        createBackBarButtonItem()
        var title = ""
        if isAddOrganization {
            title = "Add"
        } else {
            title = isFromIncident ? "Send" : "Add"
        }
        // Set right navigationItem
        let addButton = creatCustomBarButton(title: title)
        addButton.addTarget(self, action: #selector(addBarButtonAction), for: .touchUpInside)
        
        self.addBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 13)
        let placeholderColor = UIColor(hexString: "939393")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        let placeHolder = isAddContact ? "Search for contacts" : "Search geofence community"
        searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
        searchTextField.textColor = UIColor.blackTextColor()
        searchTextField.font = UIFont.circularStdBook(size: 13)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func showSearchViewButtonAction(_ sender: UIButton) {
        centerXSearchViewConstraint.isActive = false
        searchViewLeadingConstraint.isActive = true
        searchViewTrailingConstraint.isActive = true
        showSearchButton.isHidden = true
        searchTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let searchText = textField.text {
            if isAddContact == false {// for organization
                if searchText.isEmpty {
                    isSearhing = false
                } else {
                    isSearhing = true
                    filteredOrganizations = organizations.filter({$0.organization_name!.localizedCaseInsensitiveContains(searchText)})
                }
            }else{
                if searchText.isEmpty {
                    isSearhing = false
                } else {
                    isSearhing = true
                    fliteredContacts = allContacts.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//filterContactsDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*let contactKeys = Array(filterContactsDict.keys).sorted() { $0 < $1 }
        let keyBySection = contactKeys[section]
        if let contacts = filterContactsDict[keyBySection] {
            return contacts.count
        }*/
        if isSearhing {return fliteredContacts.count}
        if isAddContact == false{
            if isSearhing {return filteredOrganizations.count}
            return organizations.count
        }
        return allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAddContact {
            let cell = tableView.dequeueReusableCell(withIdentifier: AllContactTableViewCell.identifier, for: indexPath) as! AllContactTableViewCell
            let contact = isSearhing == true ? fliteredContacts[indexPath.row] : allContacts[indexPath.row]
            cell.contactNameLabel.text = contact.name
            //let count = allSamsContacts.filter({$0.phone_number == contact.phone}).count
            cell.logoImageView.isHidden = !contact.isSamsUser
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.identifier, for: indexPath) as! OrganizationTableViewCell
            let organization = isSearhing == true ? filteredOrganizations[indexPath.row] : organizations[indexPath.row]
            cell.organization =  organization
           
            let id = organization.id ?? ""
            if selectedOrganizationIDs.contains(id) {
                cell.checkImageView.image = UIImage(named: "checked")
            }else{
                cell.checkImageView.image = UIImage(named: "check")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isAddContact == false {
           
            let organization = isSearhing == true ? filteredOrganizations[indexPath.row] : organizations[indexPath.row]
            let id = organization.id ?? ""
            if selectedOrganizationIDs.contains(id) {
                if let index = selectedOrganizationIDs.firstIndex(where: {$0 == id}) {
                    selectedOrganizationIDs.remove(at: index)
                }
            }else{
                selectedOrganizationIDs.append(id)
            }
            
            addBarButtonItem?.isEnabled = (selectedOrganizationIDs.count > 0)
            tableView.reloadData()
        }
    }
    
}










extension ContactListViewController {
    
    func getOrganizationList() {
    
        let url = BASE_URL + Constants.ORGANIZATION_LIST
        
        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = respnse, let _ =  statuCode{

                self.organizations = json.array?.decode() ?? []
                self.tableView.reloadData()
                
                
            }
        }
    }
    
    
    
    func shareIncidentWithOrganization() {

        guard let incident_id = self.incident?.id else {return}
        guard selectedOrganizationIDs.count > 0 else {return}
        
        let url = shareIncidentWithOrganizationURL()
        
        let param:[String:Any] = [
            "incident":incident_id,
            "organizations":selectedOrganizationIDs
        ]
        
        SwiftLoader.show(title: "Sharing...", animated: true)
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code == 200 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func getUserContacts(){
        
        let url = BASE_URL + Constants.GET_USER_CONTACTS
        
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
                self.allSamsContacts = json.array?.decode() ?? []
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func getRegisteredUsers(){
        
        let url = BASE_URL + Constants.SAMSCLOUD_USERS
        
        SwiftLoader.show(title:"Loading...", animated: false)
        
        var array = NSMutableArray.init()
        
        for contact in allContacts {
            if let phone = contact.phone {
                array.add(["phone_no":phone])
            }
        }
        
        print(JSON.init(array))
        
        ConnectionManager().POSTApi(params: array, url) { (respnse, error, statuCode) in
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
                json.array?.forEach({
                    let phone = $0["phone_number"].stringValue
                    if let filteredContact = self.allContacts.filter({$0.phone == phone}).first {
                        filteredContact.isSamsUser = true
                    }
                })

                self.tableView.reloadData()
            }
        }
        
        /*ApiManager.shared.POSTApi(url, param: params, header: header()) { (respnse, error, statuCode) in
            
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
                
                json.array?.forEach({
                    let phone = $0["phone_number"].stringValue
                    if let filteredContact = self.allContacts.filter({$0.phone == phone}).first {
                        filteredContact.isSamsUser = true
                    }
                })

                self.tableView.reloadData()
            }
        }*/
        
    }
}
