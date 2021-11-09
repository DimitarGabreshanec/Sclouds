//
//  AddFamilyViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyJSON

protocol AddFamilyViewControllerDelegate{
    func didFinishAdding()
}

class AddFamilyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StateTableViewCellDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
    
    private var heightRow: CGFloat = 45
    private var widthRelationshipList: CGFloat = 0
    private var heightRelationshipList: CGFloat = 0
    var inviteButton: UIButton!
    var isAddFamilyOnContact = false
    var inviteBarButtonAction: ((String) -> Void)?
    var inviteBBtnAction: ((String) -> Void)?
    var arrContact = [] as NSMutableArray
    var flagCheck = false
    var delegate:AddFamilyViewControllerDelegate?
    
    var isFromEmergency = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var relationshipButton: UIButton!
    @IBOutlet weak var relationshipListContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var userAvatarButton: UIButton!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var lastNameContainer: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberContainerView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var relationshipContainerView: UIView!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var heightContentViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightRelationshipViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthRelationshipViewConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        title = isAddFamilyOnContact ? "Add Family" : "Add Contact"
        
        if isFromEmergency{
            title = "Add Emergency Contact"
        }
        
        bottomLabel.isHidden = isAddFamilyOnContact
        prepareTextField()
        roundRadiuView()
        addTapContentView()
        defaultFrame()
        prepareNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         // Set height contentView
         scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
         height: bottomLabel.frame.maxY)
         heightContentViewConstraint.constant = bottomLabel.frame.maxY
         */
        // Set size default of state list
        heightRelationshipViewConstraint.constant = (heightRelationshipList * 9.5) / 10
        widthRelationshipViewConstraint.constant = (widthRelationshipList * 9.5) / 10
    }
    
    
    // MARK: - ACTIONS
    
    @objc func tapContentView() {
        contentView.endEditing(true)
        relationshipButton.isSelected = false
        relationshipListContainerView.alpha = 0
    }
    
    @objc func cancelButtonAction() {
        if navigationController?.popViewController(animated: true) == nil {
           dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func inviteButtonAction() {
        if !isAddFamilyOnContact {
            invitedFrds()
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func invitedFrds() {
        if nameTextField.text?.count == 0 {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter First Name")
        } else if txtLastName.text?.count == 0 {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Last Name")
        }else if phoneNumberTextField.text?.count == 0 && emailTextField.text?.count == 0{
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Phone Number or email")
        }else if (emailTextField.text?.count ?? 0) > 0 && !Utility.validateEmail(candidate: emailTextField.text ?? "") {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter valid Email Id")
        } /*else if !Utility.validateEmail(candidate: emailTextField.text ?? "") {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter valid Email Id")
        }*/ else if relationshipLabel.text?.count == 0 {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Relation")
        } else {
            self.arrContact.removeAllObjects()
            self.createContactArray()
        }
    }
    
    // request the Add Contant API
    func contactAdd() {

        SwiftLoader.show(title:"Please Wait...", animated: false)
        let addContactUrl = BASE_URL + Constants.ADD_EMG_CONTACTS

        print(JSON.init(self.arrContact))
        
        ConnectionManager().POSTApi(params: self.arrContact, addContactUrl) { (response, error, statusCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code =  statusCode{
                print(json)
                if code == 200 || code == 201 {
                    self.navigateBack()
                }else{
                    let msg = json.array?.first?["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
            }
        }
    }
    
    
    func messageComposer() {
        let phoneNumber = "tel-" + "\(phoneNumberTextField.text ?? "")"
        let messageVC = MFMessageComposeViewController()
        let urlToShare = "http://www.appzoy.com"
        messageVC.body = "Enter a message \(urlToShare)"
        messageVC.recipients = [phoneNumber]
        messageVC.messageComposeDelegate = self;
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
        self.inviteBarButtonAction?(self.nameTextField.text ?? "")
        self.inviteBBtnAction?(self.relationshipLabel.text ?? "")
        self.delegate?.didFinishAdding()
    }
    
    func createContactArray() {
        var dictionary =  [String:String]()
        let firstname = nameTextField.text ?? ""
        let lastname =  txtLastName.text ?? ""
        let name = firstname + " " + lastname
        dictionary["name"]   = name
        dictionary["phone_number"] = phoneNumberTextField.text ?? ""
        dictionary["email"]        = emailTextField.text ?? ""
        dictionary["relationship"] = relationshipLabel.text ?? ""
        
        if isFromEmergency {
            dictionary["contact_type"] = "Emergency"
        }else{
           dictionary["contact_type"] =  "Family"
        }
        print(dictionary)
        self.arrContact.add(dictionary)
        self.contactAdd()
    }
    
    func onInvited() {
        inviteButton = creatCustomBarButton(title: "Invite")
        inviteButton.addTarget(self, action: #selector(inviteButtonAction), for: .touchUpInside)
        inviteButton.activatedOfNavigationBar(false)
        let inviteBarButtonItem = UIBarButtonItem(customView: inviteButton)
        navigationItem.rightBarButtonItem = inviteBarButtonItem
    }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "$1-$2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: range)
        }
        return number
    }
    
    //Deleagete
    func didClick(indexValue: Int) {
        flagCheck = true
        self.tableView.isHidden = true
        //self.tableView.isHidden = true
        if indexValue == 0 {
            relationshipLabel?.text = "Father"
        } else if indexValue == 1 {
            relationshipLabel?.text = "Mother"
        } else if indexValue == 2 {
            relationshipLabel?.text = "Brother"
        } else if indexValue == 3 {
            relationshipLabel?.text = "Sister"
        }else if indexValue == 4 {
            relationshipLabel?.text = "Colleague"
        }else if indexValue == 5 {
            relationshipLabel?.text = "Friend"
        } else {
            relationshipLabel?.text = "Other"
        }
    }
    
    // MARK: - TOUCHES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        relationshipButton.isSelected = false
        relationshipListContainerView.alpha = 0
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //       // if phoneNumberTextField.text ==
    //        var fullString = textField.text ?? ""
    //        fullString.append(string)
    //        if range.length == 1 {
    //            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
    //        } else {
    //            textField.text = format(phoneNumber: fullString)
    //        }
    //        return false
    //    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNavigationBar() {
        // Add barButtonItem for leftBarButtonItem
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let cancelButton = creatCustomBarButton(title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        // Add barButtonItem for rightBarButtonItem
        inviteButton = creatCustomBarButton(title: "Invite")
        inviteButton.addTarget(self, action: #selector(inviteButtonAction), for: .touchUpInside)
        inviteButton.activatedOfNavigationBar(false)
        let inviteBarButtonItem = UIBarButtonItem(customView: inviteButton)
        navigationItem.rightBarButtonItem = inviteBarButtonItem
    }
    
    private func defaultFrame() {
        // frame relationship list
        widthRelationshipList = relationshipListContainerView.frame.width
        heightRelationshipList = heightRow * 4
    }
    
    private func roundRadiuView() {
        lastNameContainer.roundRadius()
        nameContainerView.roundRadius()
        emailContainerView.roundRadius()
        phoneNumberContainerView.roundRadius()
        relationshipContainerView.roundRadius()
        tableView.layer.cornerRadius = 4
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        txtLastName.attributedPlaceholder = attributedString(placeHolder: "Last name")
        nameTextField.attributedPlaceholder = attributedString(placeHolder: "First name")
        emailTextField.attributedPlaceholder = attributedString(placeHolder: "someone@mail.com")
        phoneNumberTextField.attributedPlaceholder = attributedString(placeHolder: "Phone")
    }
    
    private func addTapContentView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        tap.cancelsTouchesInView = true
        contentView.addGestureRecognizer(tap)
    }
    

    // MARK: - IBACTIONS
    
    @IBAction func relationshipButtonAction(_ button: UIButton) {
        self.view.endEditing(true)
        self.tableView.isHidden = false
        if flagCheck == false {
            flagCheck = true
            button.isSelected = true
        } else {
            flagCheck = true
            button.isSelected = false
        }
        let width = button.isSelected ? (widthRelationshipList * 9.5) / 10 : widthRelationshipList
        let height = button.isSelected ? (heightRelationshipList * 9.5) / 10 : heightRelationshipList
        //relationshipListContainerView.alpha = button.isSelected ? 0 : 1
        relationshipListContainerView.alpha = button.isSelected ? 0 : 1
        widthRelationshipViewConstraint.constant = width
        heightRelationshipViewConstraint.constant = height
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func userAvatarButtonAction(_ sender: UIButton) {
        print("USER AVATAR BUTTON ACTION")
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let userName = nameTextField.text {
            self.inviteButton.activatedOfNavigationBar(!userName.isEmpty)
        }
    }

    
    // MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StateTableViewCell.relationship, for: indexPath) as! StateTableViewCell
        cell.tag = indexPath.row
        cell.stateDelegate = self
        if indexPath.row == 0 {
            cell.stateLabel?.text = "Father"
        } else if indexPath.row == 1 {
            cell.stateLabel?.text = "Mother"
        } else if indexPath.row == 2 {
            cell.stateLabel?.text = "Brother"
        } else if indexPath.row == 3 {
            cell.stateLabel?.text = "Sister"
        }else if indexPath.row == 4 {
            relationshipLabel?.text = "Colleague"
        } else if indexPath.row == 5 {
            cell.stateLabel?.text = "Friend"
        } else {
            cell.stateLabel?.text = "Other"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        relationshipButton.isSelected = false
        relationshipListContainerView.alpha = 0
    }
    
    
    
}
