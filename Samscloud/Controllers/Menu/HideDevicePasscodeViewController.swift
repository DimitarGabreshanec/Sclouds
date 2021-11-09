//
//  HideDevicePasscodeViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class HideDevicePasscodeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var code1TextField: CustomTextField!
    @IBOutlet weak var code2TextField: CustomTextField!
    @IBOutlet weak var code3TextField: CustomTextField!
    @IBOutlet weak var code4TextField: CustomTextField!
    @IBOutlet weak var confirmedButton: UIButton!
    
    // MARK: - Variables
    var isDispatchPassCode = false
    private var codeString = ""
    private var code:String?
    
    var isForConfirmPassword = false
    var confirmPasswordCode:String?
    var sender:UIViewController?
    var isFromHome:Bool = false
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = isDispatchPassCode ? "Message Passcode" : "Hide Device Passcode"
        
        if isDispatchPassCode {
            titleLabel.text = "Enter Passcode"
        }
        
        if let passcode = DefaultManager().getPasscode() {
            code = passcode
            titleLabel.text = "Confirm your passcode."
        }
        
        if isForConfirmPassword {
           titleLabel.text = "Confirm your passcode."
        }
        
        createBackBarButtonItem()
        prepareDefaultTextField()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        code1TextField.becomeFirstResponder()
    }
    
    // MARK: - Private methods
    private func prepareDefaultTextField() {
        code1TextField.layer.cornerRadius = 4
        code2TextField.layer.cornerRadius = 4
        code3TextField.layer.cornerRadius = 4
        code4TextField.layer.cornerRadius = 4
        textFieldDefault(textField: code1TextField)
        textFieldDefault(textField: code2TextField)
        textFieldDefault(textField: code3TextField)
        textFieldDefault(textField: code4TextField)
        code1TextField.text = ""
        code2TextField.text = ""
        code3TextField.text = ""
        code4TextField.text = ""
        code1TextField.myDelegate = self
        code2TextField.myDelegate = self
        code3TextField.myDelegate = self
        code4TextField.myDelegate = self
    }
    
    private func prepareTextFieldConfirm() {
        textFieldConfirm(textField: code1TextField)
        textFieldConfirm(textField: code2TextField)
        textFieldConfirm(textField: code3TextField)
        textFieldConfirm(textField: code4TextField)
    }
    
    private func prepareTextFieldError() {
        textFieldError(textField: code1TextField)
        textFieldError(textField: code2TextField)
        textFieldError(textField: code3TextField)
        textFieldError(textField: code4TextField)
    }
    
    private func textFieldDefault(textField: UITextField) {
        textField.bordered(withColor: UIColor.greyTextColor(), width: 1)
        textField.backgroundColor = UIColor(hexString: "fafafa")
    }
    
    private func changeUITextField(textField: UITextField) {
        textField.bordered(withColor: UIColor.mainColor(), width: 1)
        textField.backgroundColor = .white
    }
    
    private func textFieldConfirm(textField: UITextField) {
        textField.bordered(withColor: UIColor(hexString: "02c862"), width: 1)
        textField.backgroundColor = .white
    }
    
    private func textFieldError(textField: UITextField) {
        textField.bordered(withColor: UIColor(hexString: "f53c3c"), width: 1)
        textField.backgroundColor = .white
    }
    
    private func disableTextField() {
        code1TextField.isUserInteractionEnabled = false
        code2TextField.isUserInteractionEnabled = false
        code3TextField.isUserInteractionEnabled = false
        code4TextField.isUserInteractionEnabled = false
    }
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let codeText = textField.text {
            let textCount = codeText.count
            
            switch textField {
            case code1TextField:
                // Updated UI of textField
                if textCount == 1 {
                    changeUITextField(textField: textField)
                    code2TextField.isUserInteractionEnabled = true
                    code2TextField.becomeFirstResponder()
                }
                
                // Update code
                if codeString.count == 0 {
                    codeString.append(codeText)
                }
            case code2TextField:
                // Updated UI of textField
                if textCount == 1 {
                    changeUITextField(textField: textField)
                    code3TextField.isUserInteractionEnabled = true
                    code3TextField.becomeFirstResponder()
                }
                
                // Update code
                if codeString.count == 1 {
                    codeString.append(codeText)
                }
            case code3TextField:
                // Updated UI of textField
                if textCount == 1 {
                    changeUITextField(textField: textField)
                    code4TextField.isUserInteractionEnabled = true
                    code4TextField.becomeFirstResponder()
                }
                
                // Update code
                if codeString.count == 2 {
                    codeString.append(codeText)
                }
            case code4TextField:
                // Updated UI of textField
                if textCount == 1 {
                    changeUITextField(textField: textField)
                    code4TextField.resignFirstResponder()
                }
                
                // Update code
                codeString.append(codeText)
            default:
                break
            }
        }
        
        if codeString.count == 4 {
            if isForConfirmPassword {
                if codeString == confirmPasswordCode {
                    print("************")
                    confirmedButton.isHidden = false
                    DefaultManager().setPasscode(value: codeString)
                    self.navigationController?.popViewController(animated: false)
                    self.sender?.navigationController?.popViewController(animated: false)
                    if isFromHome {
                       appDelegate.homeVC?.showPassCodePage()
                    }
                }else{
                   let tryAgain = UIAlertAction(title: "Try Again", style: .default) { (alertAction) in
                        self.code2TextField.isUserInteractionEnabled = false
                        self.code3TextField.isUserInteractionEnabled = false
                        self.code4TextField.isUserInteractionEnabled = false
                        self.prepareDefaultTextField()
                        self.codeString.removeAll()
                        self.code1TextField.becomeFirstResponder()
                    }
                    prepareTextFieldError()
                    showAlertWithActions("Incorrect Match",
                                         message: "The passcode doesn’t match.\nPlease go back and try again", actions: [tryAgain])
                }
                return
            }
            if code == nil || code == "" {
                // first time coming...
                print("first time coming...")
                let vc = StoryboardManager.menuStoryBoard().getController(identifier: "HideDevicePasscodeVC1") as! HideDevicePasscodeViewController
                
                vc.isForConfirmPassword = true
                vc.confirmPasswordCode = codeString
                vc.sender = self
                vc.isFromHome = isFromHome
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                if codeString == code {
                    if isDispatchPassCode {
                        let dispatchSOSResponderVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchSOSResponderVC") as! DispatchSOSResponderViewController
                        DefaultManager().setPasscode(value: codeString)
                        navigationController?.pushViewController(dispatchSOSResponderVC, animated: true)
                    }
                    else {
                        titleLabel.text = "Confirm your passcode."
                        confirmedButton.isHidden = false
                        prepareTextFieldConfirm()
                        disableTextField()
                    }
                }
                else {
                    let tryAgain = UIAlertAction(title: "Try Again", style: .default) { (alertAction) in
                        self.code2TextField.isUserInteractionEnabled = false
                        self.code3TextField.isUserInteractionEnabled = false
                        self.code4TextField.isUserInteractionEnabled = false
                        self.prepareDefaultTextField()
                        self.codeString.removeAll()
                        self.code1TextField.becomeFirstResponder()
                    }
                    prepareTextFieldError()
                    showAlertWithActions("Incorrect Match",
                                         message: "The passcode doesn’t match.\nPlease go back and try again", actions: [tryAgain])
                }
            }
        }
    }
    
    @IBAction func confirmedButtonAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MyTextFieldDelegate

extension HideDevicePasscodeViewController: MyTextFieldDelegate {
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
               textFieldDefault(textField: code1TextField)
            }
            else if number2Text.isEmpty {
                // Update code
                if codeString.count == 2 {
                    let index = codeString.index(codeString.endIndex, offsetBy: -1)
                    codeString.remove(at: index)
                }
                
                // Updated UI for number2TextField
                textFieldDefault(textField: code2TextField)
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
                textFieldDefault(textField: code3TextField)
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
                textFieldDefault(textField: code4TextField)
                code4TextField.isUserInteractionEnabled = false
                code3TextField.becomeFirstResponder()
            }
        
            print("CodeString == \(codeString)")
        }
    }
}

