//
//  VerifiCodeViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import CoreLocation

class VerifiCodeViewController: UIViewController,PermissionViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var code1TextField: CustomTextField!
    @IBOutlet weak var code2TextField: CustomTextField!
    @IBOutlet weak var code3TextField: CustomTextField!
    @IBOutlet weak var code4TextField: CustomTextField!
    @IBOutlet weak var clearInvalidCodeButton: UIButton!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var invalidCodeLabel: UILabel!
    
    // MARK: - Variables
    var phoneNumber = ""
    private var codeString = ""
    private var invalidCode = 1234
    private var maxSecond = 59
    private var timer: Timer!
    
    // MARK: - View life cycle
    var userModel = User()

    var isForgotPassword = false
    var isChangePassword = false
    var senderVC:UIViewController?
    
    
    class func instanse()-> VerifiCodeViewController {
        let container  = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "VerifiCodeVC") as! VerifiCodeViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Verification"
        
        attributedResendText(second: maxSecond)
        prepareDefaultTextField()
        attributedText()
        translucentNavigationBar()
        prepareNavigation()
        textFieldDelegate()
        runTime()
    }
    
    func clearFields() {
        self.codeString = ""
        code1TextField.text = nil
        code2TextField.text = nil
        code3TextField.text = nil
        code4TextField.text = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Finish enter code
        if codeString.count == 4 {
           
            print("\(codeString.count)")
            ///// removable part
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let otpVC = storyBoard.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
            self.navigationController?.pushViewController(otpVC, animated: true)

            let addContactVC = StoryboardManager.mainStoryBoard().instantiateViewController(withIdentifier: "AddContactVC")
            self.navigationController?.pushViewController(addContactVC, animated: true)
            /////
            
            
            if isForgotPassword {
                verifyForgotOTP()
            }else{
               otpVerify()
            }
            
        }
        else if Int(codeString) != invalidCode, codeString.count == 4 {
            clearInvalidCodeButton.isHidden = false
            invalidCodeUI(isInvalid: true)
        }
        print("CodeString == \(codeString)")
    }
    
    // MARK: - Methods
    
    @objc func updateTime() {
        maxSecond -= 1
        if maxSecond == -1 {
            self.resendLabel.isHidden = true
            self.resendButton.isHidden = false
            timer.invalidate()
        } else {
            attributedResendText(second: maxSecond)
        }
    }
    
    // request the resend API
    func phoneNumberAPiCaling() {
        
        guard let email = DefaultManager().getEmail() else {return}
        
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
                    self.clearFields()
                    self.maxSecond = 59
                    self.runTime()
                    self.resendLabel.isHidden = false
                    self.resendButton.isHidden = true
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "OTP resend successfully")
                }else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                }
            }
        }
        
    }
        
        
        
        
        
    // MARK: - Private methods
    private func runTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
    }
    
    private func prepareDefaultTextField() {
        code1TextField.bordered(withColor: UIColor.greyTextColor(), width: 1, radius: 4)
        code2TextField.bordered(withColor: UIColor.greyTextColor(), width: 1, radius: 4)
        code3TextField.bordered(withColor: UIColor.greyTextColor(), width: 1, radius: 4)
        code4TextField.bordered(withColor: UIColor.greyTextColor(), width: 1, radius: 4)
    }
    
    private func textFieldDelegate() {
        code1TextField.myDelegate = self
        code2TextField.myDelegate = self
        code3TextField.myDelegate = self
        code4TextField.myDelegate = self
    }
    
    private func attributedText() {
        //Attribute `Resend` Button
        let attributed = NSAttributedString(string: "Resend",
                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: UIColor.mainColor()])
        resendButton.setAttributedTitle(attributed, for: .normal)
    }
    
    private func attributedResendText(second: Int) {
        // Attributed `Resend` label
        resendLabel.text = "Resend Code in 0:\(second)"
        let errorAttributedString = NSMutableAttributedString(string: resendLabel.text!)
        let errorAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        
        let resendRange = (resendLabel.text! as NSString).range(of: "0:\(second)")
        errorAttributedString.addAttributes(errorAttributes, range: resendRange)
        resendLabel.attributedText = errorAttributedString
    }
    
    private func invalidCodeUI(isInvalid: Bool) {
        let redColor = UIColor.redBorderColor().cgColor
        let mainColor = UIColor.mainColor().cgColor
        code1TextField.layer.borderColor = isInvalid ? redColor : mainColor
        code2TextField.layer.borderColor = isInvalid ? redColor : mainColor
        code3TextField.layer.borderColor = isInvalid ? redColor : mainColor
        code4TextField.layer.borderColor = isInvalid ? redColor : mainColor
        invalidCodeLabel.isHidden = !isInvalid
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let codeText = textField.text {
            let textCount = codeText.count
            
            switch textField {
            case code1TextField:
                // Updated UI of textField
                if textCount == 1 {
                    // Stop timer
                    timer.invalidate()
                    
                    textField.layer.borderColor = UIColor.mainColor().cgColor
                    code2TextField.isUserInteractionEnabled = true
                    code2TextField.becomeFirstResponder()
                }
                
                // Update code
                codeString.append(codeText)
            case code2TextField:
                // Updated UI of textField
                if textCount == 1 {
                    textField.layer.borderColor = UIColor.mainColor().cgColor
                    code3TextField.isUserInteractionEnabled = true
                    code3TextField.becomeFirstResponder()
                }
                
                // Update code
                codeString.append(codeText)
            case code3TextField:
                // Updated UI of textField
                if textCount == 1 {
                    textField.layer.borderColor = UIColor.mainColor().cgColor
                    code4TextField.isUserInteractionEnabled = true
                    code4TextField.becomeFirstResponder()
                }
                
                // Update code
                codeString.append(codeText)
            case code4TextField:
                // Updated UI of textField
                if textCount == 1 {
                    textField.layer.borderColor = UIColor.mainColor().cgColor
                    code4TextField.resignFirstResponder()
                }
                
                // Update code
                codeString.append(codeText)
            default:
                break
            }
        }
        
        resendLabel.isHidden = true
        // Show/die `Resend` button
        resendButton.isHidden = codeString.isEmpty
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        self.phoneNumberAPiCaling()
    }
    
    @IBAction func clearInvalidCodeButtonAction(_ sender: UIButton) {
        clearInvalidCodeButton.isHidden = true
        invalidCodeUI(isInvalid: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func otpVerify() {
        if codeString.count == 4 {
            guard Utility.isConnectedToNetwork() else {
                Utility.SubmitAlertView(viewController: self, title: "", message: "networkError")
                return
            }
            SwiftLoader.show(title:"Please Wait...", animated: false)
            let email = DefaultManager().getEmail() ?? ""
            let param = ["email":email,"otp":codeString]
            PSApi.apiRequestWithEndPointSome(.phoneVerification1, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
                SwiftLoader.hide()
               // let value1 = response.result
                let statusCode = response.response?.statusCode
                
                if  statusCode == 200 {
                    
                    let msg = response.value!["msg"]
                    let msgStr = msg.rawString()
                    if msgStr == "Invalid OTP" {
                        self.invalidCodeUI(isInvalid: true)
                        Utility.SubmitAlertView(viewController: self, title: "Alert!", message: msgStr!)
                    } else {
                        
                        let user_id = response.value?["user_id"].intValue
                        DefaultManager().setUserId(value: user_id)

                        let token = response.value?["access_token"].string
                        DefaultManager().setToken(value: token)

                        let refresh_token = response.value?["refresh_token"].string
                        DefaultManager().setRefreshToken(value: refresh_token)
                        
                        DefaultManager().setPhoneNumber(value: self.phoneNumber)
                        if self.isChangePassword == true {
                            showAlertWithConfirmation("Number update successfully", "Message", self) { (isConfirm) in
                                if let vc = self.senderVC {
                                    vc.navigationController?.popToViewController(vc, animated: true)
                                }
                            }
                            return
                        }
                        self.checkForLocation()
                    }
                } else if  statusCode == 400 {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "OTP doesn’t match.")
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                }
            }
        }
        
   }
    
    
    func checkForLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .restricted || status == .denied || status == .notDetermined{
            showLocationPermission()
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let otpVC = storyBoard.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
            otpVC.isFreshSignup = true
            otpVC.isNotShowPermissionPage = true
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    
    func showLocationPermission() {
        let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
        permissionVC.isLocation = true
        permissionVC.delegate = self
        permissionVC.modalPresentationStyle = .fullScreen
        present(permissionVC, animated: false, completion: nil)
    }

    func didFinish() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let otpVC = storyBoard.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
        otpVC.isFreshSignup = true
        otpVC.isNotShowPermissionPage = true
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    func verifyForgotOTP() {
        
        if codeString.count == 4 {
            guard Utility.isConnectedToNetwork() else {
                Utility.SubmitAlertView(viewController: self, title: "", message: "networkError")
                return
            }
            SwiftLoader.show(title:"Please Wait...", animated: false)
            
            let email = DefaultManager().getEmail() ?? ""
            let param = ["email":email,"otp":codeString]
            
            let url = BASE_URL + Users.FORGOT_PASS_VERIFY_OTP
            
            APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statuCode) in
                SwiftLoader.hide()
                if let err = error {
                    print(err.localizedDescription)
                }else if let json = response, let code =  statuCode{
                    print(json)
                    if code == 200 || code == 201{
                        let vc = ChangePwdViewController.instanse()
                        vc.isForgotPass = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                        showAlert(msg: msg, title: "Error", sender: self)
                    }
                    
                }
            }
            
            
           /* PSApi.apiRequestWithEndPointSome(.phoneVerification1, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
                SwiftLoader.hide()
                // let value1 = response.result
                let statusCode = response.response?.statusCode
                
                if  statusCode == 200 {
                    
                    let msg = response.value!["msg"]
                    let msgStr = msg.rawString()
                    if msgStr == "Invalid OTP" {
                        self.invalidCodeUI(isInvalid: true)
                        Utility.SubmitAlertView(viewController: self, title: "Alert!", message: msgStr!)
                    } else {
                        
                        let user_id = response.value?["user_id"].intValue
                        DefaultManager().setUserId(value: user_id)
                        
                        let token = response.value?["access_token"].string
                        DefaultManager().setToken(value: token)
                        
                        let refresh_token = response.value?["refresh_token"].string
                        DefaultManager().setRefreshToken(value: refresh_token)
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let otpVC = storyBoard.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
                        self.navigationController?.pushViewController(otpVC, animated: true)
                    }
                } else if  statusCode == 400 {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "OTP doesn’t match.")
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                }
            }*/
        }
    }
    
    
}

// MARK: - UITextFieldDelegate

extension VerifiCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= 1 {
            return true
        }
        
        if newString.length > 1 {
            switch textField {
            case code1TextField:
                code2TextField.isUserInteractionEnabled = true
                code2TextField.becomeFirstResponder()
            case code2TextField:
                code3TextField.isUserInteractionEnabled = true
                code3TextField.becomeFirstResponder()
            case code3TextField:
                code4TextField.isUserInteractionEnabled = true
                code4TextField.becomeFirstResponder()
            default:
                break
            }
            
            return false
        }
        
        return true
    }
}

// MARK: - MyTextFieldDelegate

extension VerifiCodeViewController: MyTextFieldDelegate {
    func textFieldDidDelete() {
        if let number1Text = code1TextField.text,
            let number2Text = code2TextField.text,
            let number3Text = code3TextField.text,
            let number4Text = code4TextField.text {
            if number1Text.isEmpty {
                // Update code
                if codeString.count == 1 {
                    codeString.remove(at: codeString.startIndex)
                }
                
                // Updated UI for number1TextField
                code1TextField.layer.borderColor = UIColor.greyTextColor().cgColor
            }
            else if number2Text.isEmpty {
                // Update code
                if codeString.count == 2 {
                    let index = codeString.index(codeString.endIndex, offsetBy: -1)
                    codeString.remove(at: index)
                }
                
                // Updated UI for number2TextField
                code2TextField.layer.borderColor = UIColor.greyTextColor().cgColor
                code2TextField.isUserInteractionEnabled = false
                code1TextField.becomeFirstResponder()
            }
            else if number3Text.isEmpty {
                // Update code
                if codeString.count == 3 {
                    let index = codeString.index(codeString.endIndex, offsetBy: -1)
                    codeString.remove(at: index)
                }
                
                // Updated UI for number3TextField
                code3TextField.layer.borderColor = UIColor.greyTextColor().cgColor
                code3TextField.isUserInteractionEnabled = false
                code2TextField.becomeFirstResponder()
            }
            else if number4Text.isEmpty {
                // Update code
                if codeString.count == 4 {
                    let index = codeString.index(before: codeString.endIndex)
                    codeString.remove(at: index)
                }
                
                // Updated UI for number5TextField
                code4TextField.layer.borderColor = UIColor.greyTextColor().cgColor
                code4TextField.isUserInteractionEnabled = false
                code3TextField.becomeFirstResponder()
            }
            
            // Show/die `Resend` button
            resendButton.isHidden = codeString.isEmpty
            
            print("CodeString == \(codeString)")
        }
    }

}
