//
//  NewMessageViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON


class NewMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let titles = ["PARENTS", "RELATIVES", "FRIENDS"]
    
    var chooseUsers = [String]()
    var nextButton: UIButton!
    var isGroup = false
    var isShare = false
    var isAddMember = false
    var isAddButtonHomeChirp = false
    var isChirpGroup = false
    
    var contacts = [ContactModel]()
    
    var contactList = [[ContactModel]]()
    
    var incident:OngoingIncidentModel?
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedContactID:String?
    var selectedContactIDs = [String]()
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTitleNavigation()
        prepareNavigationBar()
        prepareTextField()
        prepareTableView()
        getUserContacts()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func nextButtonAction() {
        if isShare || isAddMember || isAddButtonHomeChirp {
            if isShare { shareIncidentWithContact() }
        } else {
            if isGroup || isChirpGroup {
                let groupConversationVC = StoryboardManager.contactStoryBoard().getController(identifier: "GroupConversationVC") as! GroupConversationViewController
                groupConversationVC.users = chooseUsers
                groupConversationVC.isChirpGroup = isChirpGroup
                
                navigationController?.pushViewController(groupConversationVC, animated: true)
            } else {
                performSegue(withIdentifier: "showMessageChatSegue", sender: nil)
            }
        }
    }
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        // Add barButtonItem for rightBarButtonItem
        var rightBarButtonTitle = ""
        if isAddButtonHomeChirp {
            rightBarButtonTitle = "Add"
        } else {
            rightBarButtonTitle = isShare ? "Send" : "Next"
        }
        nextButton = creatCustomBarButton(title: rightBarButtonTitle)
        nextButton.activatedOfNavigationBar(false)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.rightBarButtonItem = nextBarButtonItem
    }
    
    private func prepareTextField() {
        let font = UIFont.circularStdBook(size: isShare ? 14 : 16)
        let placeholderColor = UIColor(hexString: "939393")
        var searchString = ""
        if isAddMember {
            searchString = "Who would you like to the group?"
        } else {
            if isAddButtonHomeChirp {
                searchString = "Who would you add to the group?"
            } else {
                searchString = isShare ? "Who would you like to send the incident to?" : "Who would you like to message?"
            }
        }
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchString,
                                                                   attributes: [NSAttributedString.Key.font: font,
                                                                                NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func displayTitleNavigation() {
        if isShare {
            title = "Share"
        } else {
            if isAddMember || isChirpGroup {
                title = "Add Members"
            } else {
                if isAddButtonHomeChirp {
                    title = "CHirP"
                } else {
                    title = isGroup ? "Group Conversation" : "New Message"
                }
            }
        }
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        print("SEARCH BUTTON PRESSED - NEWMESSAGE_VC")
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        print("TEXT FIELD EDITING CHANGED BUTTON PRESSED - NEWMESSAGE_VC")
    }
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMessageTableViewCell.identifier, for: indexPath) as! NewMessageTableViewCell
        let itemsInSection = contactList[indexPath.section].count
        cell.contact = contactList[indexPath.section][indexPath.row]
        cell.bottomView.isHidden = itemsInSection == 1 || indexPath.row == itemsInSection - 1
        let id = cell.contact?.id ?? ""
        cell.checkButton.isSelected = selectedContactIDs.contains(id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contactList[indexPath.section][indexPath.row]
        let id = contact.id ?? ""
        if selectedContactIDs.contains(id) {
            if let index = selectedContactIDs.firstIndex(where: {$0 == id}) {
                selectedContactIDs.remove(at: index)
            }
        }else{
            selectedContactIDs.append(id)
        }
        nextButton.activatedOfNavigationBar(selectedContactIDs.count != 0)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if contactList[section].count == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        // Create top line view
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        topView.backgroundColor = UIColor(hexString: "d3d3d3")
        topView.isHidden = section == 0
        // Create label
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 16, width: tableView.frame.width - 40, height: 16))
        headerLabel.textColor = UIColor(hexString: "939393")
        headerLabel.font = UIFont.circularStdMedium(size: 13)
        headerLabel.text = titles[section]
        headerView.addSubview(headerLabel)
        headerView.addSubview(topView)
        return headerView
    }
    
    
    // MARK: - SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageChatSegue" {
            let vc = segue.destination as! MessageChatViewController
            vc.isNewMessage = true
            // Handle `message` button
            vc.newMessageButtonAction = {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}









extension NewMessageViewController {
    
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
                let contacts:[ContactModel] = json.array?.decode() ?? []
                self.parseContacts(list: contacts)
            }
        }
        
    }
    
    
    
    func parseContacts(list:[ContactModel]) {
        
        let array = Dictionary.init(grouping: list, by: {$0.relationship!})
    
        let parentList = array.filter({$0.key.lowercased() == "mother" || $0.key.lowercased() == "father" })
    
        
        let friendlist = array.filter({$0.key.lowercased() == "friend"})
       
        let relativelist = array.filter({$0.key.lowercased() == "brother" || $0.key.lowercased() == "sister"})
        
        contactList.append(parentList.first?.value ?? [])
        contactList.append(friendlist.first?.value ?? [])
        contactList.append(relativelist.first?.value ?? [])
        
        tableView.reloadData()
    }
    
    
    func shareIncidentWithContact() {

        guard let id = incident?.id else {return}
        guard selectedContactIDs.count > 0 else {return}
        
        let url = shareIncidentWithContactsURL()
        
        let param:[String:Any] = [
            "incident":id,
            "contacts":selectedContactIDs
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
}
