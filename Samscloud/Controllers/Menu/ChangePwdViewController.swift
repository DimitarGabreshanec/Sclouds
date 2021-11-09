//
//  ChangePwdViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ChangePwdViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentPwdTextField: UITextField?
    @IBOutlet weak var currentCheckedImageView: UIImageView?
    @IBOutlet weak var newPwdTextField: UITextField!
    @IBOutlet weak var newCheckedImageView: UIImageView!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var confirmCheckedImageView: UIImageView!
    @IBOutlet weak var pwdWrongLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPasswordLine: UIView?
    
    @IBOutlet weak var passwordViewHeight: NSLayoutConstraint!
    
    // MARK: - View life cycle

    var isForgotPass = false
    
    class func instanse()-> ChangePwdViewController {
        let container  = UIStoryboard.init(name: "Menu", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "ChangePwdVC") as! ChangePwdViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Change Password"
        
        if isForgotPass {
            currentPasswordLine?.removeFromSuperview()
            currentCheckedImageView?.removeFromSuperview()
            currentPwdTextField?.removeFromSuperview()
            title = "Set Password"
            titleLabel.text = "Set Password"
            passwordViewHeight.constant = 0
        }
        
        prepareImageView()
        prepareNavigationBar()
        attributeText(text: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*// Set height contentView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: noteLabel.frame.maxY + 20)
        contentViewHeightConstraint.constant = noteLabel.frame.maxY + 20*/
    }
    
    // MARK: - Methods
    //else if self.validate(password: pwdTextField.text!) == false {
//    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Password should be of minimum 6 characters where it must contain at least 1 uppercase letter, 1 lowercase letter, 1 digit and 1 special character.")
//}
    @objc func updatedButtonAction() {
        
        if isForgotPass {
            if newPwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter new password")
            } else if self.validate(password: newPwdTextField.text!) == false {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Password should be of minimum 6 characters where it must contain at least 1 uppercase letter, 1 lowercase letter, 1 digit and 1 special character(~!@#$%^&*()_+).")
            } else if confirmPwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter confirm password")
            } else if newPwdTextField.text != confirmPwdTextField.text{
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Your new password and confirm password does not match")
            } else {
                self.setPassword()
            }
        }else{
            if currentPwdTextField?.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter old password")
            } else if newPwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter new password")
            } else if self.validate(password: newPwdTextField.text!) == false {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Password should be of minimum 6 characters where it must contain at least 1 uppercase letter, 1 lowercase letter, 1 digit and 1 special character(~!@#$%^&*()_+).")
            } else if confirmPwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter confirm password")
            } else if newPwdTextField.text != confirmPwdTextField.text{
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Your new password and confirm password does not match")
            } else {
                self.changePasswords()
            }
        }
    }
    /*let dic = response.value!["status"]
     let status = dic["rawNumber"]
     if  status == 200 {
     let msgStatus = dic["msg"]*/
    // MARKS:- Password change Api Calling
    func changePasswords(){
        
        SwiftLoader.show(title:"Please Wait...", animated: false)
        
        let param:[String:Any] = [
            "new_password":newPwdTextField.text ?? "",
            "confirm_password":confirmPwdTextField.text ?? "",
            "current_password":currentPwdTextField?.text ?? ""
        ]
        
        let url = BASE_URL + Users.CHANGE_PASSWORD
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, stausCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code =  stausCode{
                print(json)
                if code == 200 || code == 201{
                    showAlertWithConfirmation("Password has been changed successfully!", "Message", self, completion: { (isTapped) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }else{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
                
            }
        }
    }
    
    
    
    func setPassword(){
        
        SwiftLoader.show(title:"Please Wait...", animated: false)
        
        let param:[String:Any] = [
            "new_password":newPwdTextField.text ?? "",
            "confirm_password":confirmPwdTextField.text ?? "",
            "email":DefaultManager().getEmail() ?? ""
        ]
        
        let url = BASE_URL + Users.FORGOT_PASS_UPDATE
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, stausCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code =  stausCode{
                print(json)
                if code == 200 || code == 201{
                    showAlertWithConfirmation("Password has been updated successfully\nPlease login now", "Message", self, completion: { (isTapped) in
                        self.popToLogin()
                    })
                    
                }else{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                }
                
            }
        }
        
    }
    
    
    func popToLogin() {
        let vcs = self.navigationController?.viewControllers ?? []
        
        for vc in vcs {
            if let obj = vc as? LoginViewController {
                self.navigationController?.popToViewController(obj, animated: true)
                break
            }
        }
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let updatedButton = creatCustomBarButton(title: "Update")
        updatedButton.addTarget(self, action: #selector(updatedButtonAction), for: .touchUpInside)
        let updatedBarButtonItem = UIBarButtonItem(customView: updatedButton)
        
        navigationItem.rightBarButtonItem = updatedBarButtonItem
    }
    
    private func prepareImageView() {
        currentCheckedImageView?.image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
        newCheckedImageView.image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
        confirmCheckedImageView.image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
        currentCheckedImageView?.tintColor = UIColor(hexString: "02c862")
        newCheckedImageView.tintColor = UIColor(hexString: "02c862")
        confirmCheckedImageView.tintColor = UIColor(hexString: "02c862")
    }
    
    private func attributeText(text:String) {
        //Attribute String
        let line1 = "       •    Your password has to be at least 6 characters long.\n"
        let line2 = "       •    Must contain at least one lower case letter,\n"
        let line3 = "       •    one upper case letter,\n"
        let line4 = "       •    one digit.\n"
        let line5 = "       •    at least one special character ~!@#$%^&*()_+"
        
        let lines = [line1,line2,line3,line4,line5]
        
        // Attribute key
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "02C862")]
        let attributes1 = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
        let finalStr = NSMutableAttributedString.init()
        
        lines.forEach({
            // Attribute the first dot of line 1
            
            let lineString = NSMutableAttributedString(string: $0)
            let dotRange = (line1 as NSString).range(of: "•")
            if $0 == line1 {
                if text.count >= 6 {
                    lineString.addAttributes(attributes, range: dotRange)
                }else{
                    lineString.addAttributes(attributes1, range: dotRange)
                }
            }else if $0 == line2 {
                if validateAtLeastOneLowerCase(str: text) {
                    lineString.addAttributes(attributes, range: dotRange)
                }else{
                    lineString.addAttributes(attributes1, range: dotRange)
                }
            }else if $0 == line3 {
                if validateAtLeastOneUpperCase(str: text) {
                    lineString.addAttributes(attributes, range: dotRange)
                }else{
                    lineString.addAttributes(attributes1, range: dotRange)
                }
            }else if $0 == line4 {
                if validateAtLeastOneLowerCase(str: text) {
                    lineString.addAttributes(attributes, range: dotRange)
                }else{
                    lineString.addAttributes(attributes1, range: dotRange)
                }
            }else if $0 == line5 {
                if validateAtLeastOneSpecialChar(str: text) {
                    lineString.addAttributes(attributes, range: dotRange)
                }else{
                    lineString.addAttributes(attributes1, range: dotRange)
                }
            }
            finalStr.append(lineString)
        })
        // Added for note label
        noteLabel.attributedText = finalStr
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        
        if isForgotPass {
            if let newPwd = newPwdTextField.text,
                let confirmPwd = confirmPwdTextField.text {
                
                newCheckedImageView.isHidden = !validate(password: newPwd)
                confirmCheckedImageView.isHidden = !validate(password: confirmPwd)
                
                if textField == newPwdTextField || textField == confirmPwdTextField {
                    pwdWrongLabel.isHidden = newPwd == confirmPwd
                }
                
                confirmCheckedImageView.tintColor = newPwd == confirmPwd ? UIColor(hexString: "02c862") : UIColor(hexString: "f53c3c")
                attributeText(text: textField.text ?? "")
            }
        }else if let currentPwd = currentPwdTextField?.text,
            let newPwd = newPwdTextField.text,
            let confirmPwd = confirmPwdTextField.text {
            
            currentCheckedImageView?.isHidden = !validate(password: currentPwd)
            newCheckedImageView.isHidden = !validate(password: newPwd)
            confirmCheckedImageView.isHidden = !validate(password: confirmPwd)
        
            if textField == newPwdTextField || textField == confirmPwdTextField {
               pwdWrongLabel.isHidden = newPwd == confirmPwd
            }
        
            confirmCheckedImageView.tintColor = newPwd == confirmPwd ? UIColor(hexString: "02c862") : UIColor(hexString: "f53c3c")
            attributeText(text: textField.text ?? "")
        }
        
    }
    
    
//Password validation ~!@#$%^&*()_+
    
func validate(password: String) -> Bool {
    let regex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
    let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: newPwdTextField.text)
    if(isMatched  == true) {
        // Do your stuff ..
        return true
    } else {
        // Show Error Message.
        return false
    }
}
}



func validateAtLeastOneUpperCase(str:String) -> Bool {
    let regex = ".*[A-Z]+.*"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: str)
}

func validateAtLeastOneNumber(str:String) -> Bool {
    let regex = "*[0-9]*"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: str)
}

func validateAtLeastOneLowerCase(str:String) -> Bool {
    let regex = ".*[a-z]+.*"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: str)
}

func validateAtLeastOneSpecialChar(str:String) -> Bool {
    let regex = ".*[!&^%$#@()/_*+-]+.*"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: str)
}


func showAlertWithConfirmation(_ message: String, _ title: String, _ controller: UIViewController, completion completionBlock: @escaping (_ success: Bool) -> Void) {
    let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(true)
    })
    alrt.addAction(ok)
    controller.present(alrt, animated: true, completion: nil)
}




func showAlertConfirmation(_ message: String, _ title: String, _ controller: UIViewController, completion completionBlock: @escaping (_ success: Bool) -> Void) {
    let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Quick Share", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(true)
    })
    let notNow = UIAlertAction(title: "Not Now", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(false)
    })
    alrt.addAction(ok)
    alrt.addAction(notNow)
    controller.present(alrt, animated: true, completion: nil)
}

func showContactAlert(_ message: String, _ title: String, _ controller: UIViewController, completion completionBlock: @escaping (_ success: Bool) -> Void) {
    let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let accept = UIAlertAction(title: "Accept", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(true)
    })
    let reject = UIAlertAction(title: "Reject", style: .destructive, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(false)
    })
    alrt.addAction(accept)
    alrt.addAction(reject)
    controller.present(alrt, animated: true, completion: nil)
}




func showConfirmationAlert(_ message: String, _ title: String, _ controller: UIViewController, completion completionBlock: @escaping (_ success: Bool) -> Void) {
    let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let accept = UIAlertAction(title: "YES", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(true)
    })
    let reject = UIAlertAction(title: "NO", style: .destructive, handler: {(_ alert: UIAlertAction) -> Void in
        completionBlock(false)
    })
    alrt.addAction(accept)
    alrt.addAction(reject)
    controller.present(alrt, animated: true, completion: nil)
}
