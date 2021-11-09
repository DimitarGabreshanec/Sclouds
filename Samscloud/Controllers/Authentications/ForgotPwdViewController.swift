//
//  ForgotPwdViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightContainerViewConstraint: NSLayoutConstraint!
    
    // MARK: - Private let/var
    private var yCurrent: CGFloat = 66
    private var heightContainerView: CGFloat = 0
    var flagBack: Bool = true

    // MARK: - Variables
    var restoreButtonAction: (() -> Void)?

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable `restore` button
        self.view.alpha = 0
        restoreButton.activated(false)
        
        setHeightContainerView()
        roundRadiusView()
        prepareTextField()
        addPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomContainerViewConstraint.constant = 0
        
        UIView.animate(withDuration: 0.66, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.view.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    // MARK: - Methods
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        bottomContainerViewConstraint.constant = -heightContainerView
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func setHeightContainerView() {
        // set yDefault of containerView
        let heightView = view.frame.height
        let heightStatusBar = UIApplication.shared.statusBarFrame.height
        heightContainerView = heightView - heightStatusBar - yCurrent
        heightContainerViewConstraint.constant = heightContainerView
        bottomContainerViewConstraint.constant = -heightContainerView
    }
    
    private func addPanGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .down
        containerView.addGestureRecognizer(swipeRight)
    }
    
    private func roundRadiusView() {
        topView.roundRadius()
        emailContainerView.roundRadius()
        restoreButton.roundRadius()
        containerView.layer.cornerRadius = 20
    }
    
    private func prepareTextField() {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        emailTextField.attributedPlaceholder = NSAttributedString(string: "someone@mail.com", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        emailTextField.font = font
        emailTextField.textColor = UIColor.blackTextColor()
    }
    
    //MARk: Custom Function Calling
    func forgotApiCalling() {
        
        guard let email = emailTextField.text else {return}
        SwiftLoader.show(title:"Please Wait...", animated: false)
        
        let param:[String:Any] = ["email":email,"otp":""]
        let url = BASE_URL + Users.FORGOT_PASS
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 200 || code == 201 {
                    DefaultManager().setEmail(value: email)
                    self.dismiss(animated: true, completion: {
                        self.restoreButtonAction?()
                    })
                }else {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
            }
        }
        
        /*PSApi.apiRequestWithEndPointSome(.forgot, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            
            print("forgotApiCalling response -> \(response)")
            let statusCode = response.response?.statusCode
            if  statusCode == 200 {
                let msg = response.value!["msg"]
                let msgStr = msg.rawString()
                
                if msgStr == msgForgot {
                     Utility.SubmitAlertView(viewController: self, title: "Alert!", message: msgStr!)
                } else {
                    self.dismiss(animated: false) {
                        self.flagBack = false
                        self.restoreButtonAction?()
                    }
                }
                
            } else {
                
            }
        }*/
    }
    
    // MARK: - Validation
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let email = textField.text {
            restoreButton.activated(!email.isEmpty)
        }
    }
    
    @IBAction func restoreButtonAction(_ sender: UIButton) {
        if emailTextField.text?.count == 0 {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Email Id")
        } else if !Utility.validateEmail(candidate: emailTextField.text ?? "") {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter valid Email Id")
        } else {
            self.forgotApiCalling()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: false) {
            //self.flagBack = true
            //self.restoreButtonAction?()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
