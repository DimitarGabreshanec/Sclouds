//
//  MenuAddContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit


// MARK: - PROTOCOL

protocol MenuAddContactDelegate {
    func didclickMenu(arrOrgan: Organization)
    func didFinishAdding()
}


// MARK: - CLASS

class MenuAddContactViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var organizations = [Organization]()
    var addContactButtonAction: (() -> Void)?
    var manuallyAddButtonAction: (() -> Void)?
    var searchProCodeButtonAction: (() -> Void)?
    var errorProCodeButtonAction: (() -> Void)?
    var isAddProCode = false
    var isAddOrganization = false
    var proCode = "1234"
    var isInvalidCode = false
    var isSearchButtonHidden = false
    var arrorganList = [Organization]()
    var addOrganizationButtonAction: (([Organization]) -> Void)?
    var isFromEmergency = false
    var isFromReport = false
    
    // `Add Contact`
    var menuDel: MenuAddContactDelegate! = nil
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addContactContainerView: UIView!
    @IBOutlet weak var manuallyAddContainerView: UIView!
    @IBOutlet weak var addContactLabel: UILabel!
    @IBOutlet weak var addContactTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var manuallyAddLabel: UILabel!
    @IBOutlet weak var manuallyAddImageView: UIImageView!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var manuallyAddButton: UIButton!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    // `Add Pro Code`
    @IBOutlet weak var addProCodeContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var enterProCodeContainerView: UIView!
    @IBOutlet weak var enterProCodeTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterCodeImageView: UIImageView!
    @IBOutlet weak var topContainerViewConstraint: NSLayoutConstraint!
    
    var delegate:MenuAddContactDelegate?
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        // Update UI to animation when show from the add contact page or the pro code page
        bottomContainerViewConstraint.constant = -containerView.frame.height
        topContainerViewConstraint.constant = -addProCodeContainerView.frame.height
        prepareView()
        addPanGesture()
        prepareTextField()
        addOrganizationUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isAddProCode {
            topContainerViewConstraint.constant = 0
        } else {
            bottomContainerViewConstraint.constant = 0
        }
        addProCodeContainerView.transform = CGAffineTransform(scaleX: 0.75, y: 1.0)
        containerView.transform = CGAffineTransform(scaleX: 0.75, y: 1)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.60, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.view.alpha = 1
            self.containerView.transform = .identity
            self.addProCodeContainerView.transform = .identity
        }, completion: { (finished) in
            if self.isAddProCode {
                self.enterProCodeTextField.becomeFirstResponder()
            }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        addProCodeContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    
    // MARK: - ACTIONS
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        dismissPage()
    }
    
  
    
    // MARK: - PRIVATE ACTIONS
    private func dismissPage(completion: (() -> Void)? = nil) {
        
        if topContainerViewConstraint.constant == 0 {
            topContainerViewConstraint.constant = -addProCodeContainerView.frame.height
        }
        if bottomContainerViewConstraint.constant == 0 {
            bottomContainerViewConstraint.constant = -containerView.frame.height
        }
        
        UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.view.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.75, y: 1)
            self.addProCodeContainerView.transform = CGAffineTransform(scaleX: 0.75, y: 1)
        }, completion: { (finished) in
            self.dismiss(animated: false, completion: {
                completion?()
            })
        })
        
    }
    
    private func addPanGesture() {
        // Add swipe down for containerView of the add contact page
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        containerView.addGestureRecognizer(swipeDown)
        // Add swipe up for containerView of the pro code page
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        addProCodeContainerView.addGestureRecognizer(swipeUp)
    }
    
    private func addOrganizationUI() {
        if isAddOrganization {
            addContactLabel.text = "Search"
            contactImageView.image = UIImage(named: "search-icon")?.withRenderingMode(.alwaysTemplate)
            contactImageView.tintColor = .white
            manuallyAddLabel.text = "Add Pro-Code"
            addContactTitleLabel.text = "Add Organization"
            descriptionLabel.text = "Subscribe and connect by searching for\nyour organization or by using their pro-code."
        } else if isFromReport {
            addContactLabel.text = "Add Photo"
            contactImageView.image = UIImage(named: "camera-report")?.withRenderingMode(.alwaysTemplate)
            contactImageView.tintColor = .white
            manuallyAddLabel.text = "Add Video"
            manuallyAddImageView.image = UIImage(named: "CapturePhoto")
            addContactTitleLabel.text = "Add Media"
            descriptionLabel.text = "Choose the media type to add to your report."
        } else {
            addContactLabel.text = "Add Contacts"
            contactImageView.image = UIImage(named: "contacts")
            contactImageView.tintColor = .white
            manuallyAddLabel.text = "Manually Add"
            addContactTitleLabel.text = "Add Contacts"
            descriptionLabel.text = "Choose to get contact information\nfrom your phone contact list or manually add."
        }
    }
    
    private func prepareView() {
        addContactContainerView.roundRadius()
        manuallyAddContainerView.roundRadius()
        topView.roundRadius()
        enterProCodeContainerView.roundRadius()
        bottomView.roundRadius()
        searchButton.isHidden = isSearchButtonHidden
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        enterProCodeTextField.attributedPlaceholder = attributedString(placeHolder: "Enter pro code")
        enterProCodeTextField.font = UIFont.circularStdBook(size: 16)
        enterProCodeTextField.textColor = UIColor.blackTextColor()
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func addContactButtonAction(_ sender: UIButton) {
        dismiss(animated: false) {
            self.addContactButtonAction?()
        }
    }
    
    @IBAction func manuallyAddButtonAction(_ sender: UIButton) {
        if isAddOrganization {
            containerView.isHidden = true
            bottomContainerViewConstraint.constant = -containerView.frame.height
            topContainerViewConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            dismiss(animated: false) {
                self.manuallyAddButtonAction?()
            }
        }
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        dismissPage()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismissPage()
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        dismissPage {
            self.searchProCodeButtonAction?()
        }
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let searchText = textField.text {
            isInvalidCode = searchText == proCode
            enterCodeImageView.isHidden = !searchText.isEmpty
            submitButton.setTitleColor(searchText.isEmpty ? UIColor.greyTextColor() : UIColor.mainColor(), for: .normal)
            submitButton.isUserInteractionEnabled = !searchText.isEmpty
        }
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if self.isInvalidCode {
            dismissPage()
        } else {
            self.searchPromoCode()
        }
    }
    
    
    // MARK: - GESTURES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        if let view = touch.view, view.isDescendant(of: addProCodeContainerView) {
            return false
        }
        return true
    }
    
}















extension MenuAddContactViewController {
    
    
    
    func searchPromoCode() {
        
        guard let code = self.enterProCodeTextField.text else {return}
        
        let url = BASE_URL + Constants.SEARCH_ORG_BY_PROMO
        
        SwiftLoader.show(title:"Adding...", animated: false)
        
        let param:[String:Any] = ["pro_code":code]
        
        ApiManager.shared.POSTApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                
                print(json)
                
                if code == 200 || code == 201{
                    self.addOrganization(id: json["organization_id"].stringValue)
                    return
                }
                let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                showAlert(msg: msg, title: "Error", sender: self)
            }
        }
        
    }
    
    
    func addOrganization(id:String) {
        
   
        let url = BASE_URL + Constants.ADD_ORG
        
        SwiftLoader.show(title:"Adding...", animated: false)
        
        let param:[String:Any] = ["organization":id]
        
        ApiManager.shared.POSTApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                
                print(json)
                
                if code == 200 || code == 201{
                    self.delegate?.didFinishAdding()
                    self.dismissPage()
                    return
                }
                let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                showAlert(msg: msg, title: "Error", sender: self)
            }
        }
    }
    
}
