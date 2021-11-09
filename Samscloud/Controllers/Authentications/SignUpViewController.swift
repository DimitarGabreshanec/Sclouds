//
//  SignUpViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON


class SignUpViewController: UIViewController ,UITextFieldDelegate,UIGestureRecognizerDelegate{
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateListContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstNameContainerView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    //Added by Chetu
    @IBOutlet weak var lastNameContainerView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdContainerView: UIView!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmPwdContainerView: UIView!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateContainerView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var chooseStateButton: UIButton!
    @IBOutlet weak var cityContainerView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipContainerView: UIView!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var agreeTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var heightContentViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightStateListConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthStateListConstraint: NSLayoutConstraint!
    
    // MARK: - Private methods
    private var heightRow: CGFloat = 45
    private var widthStateList: CGFloat = 0
    private var heightStateList: CGFloat = 0
    
    // MARK: - View life cycle
    
    @IBAction func moveForgotPassword(_ sender: Any) {
        let objVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdVC")
        self.present(objVc!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        emailTextField.text = "akhilesh@subcodevs.com"
        firstNameTextField.text = "Akhilesh"
        lastNameTextField.text = "Singh"
        pwdTextField.text = "Qwerty@123"
        confirmPwdTextField.text = "Qwerty@123"
         */
        title = "Introduce Yourself"
        nextButton.activated(false)
        updateUI()
        prepareNavigation()
        setFont()
        prepareTextField()
        attributedText()
        roundRadiuView()
        self.confirmPwdTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set height contentView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: loginStackView.frame.maxY + 5)
        heightContentViewConstraint.constant = loginStackView.frame.maxY + 5
        
        // Set height state list
        heightStateList = heightRow * 4
        
        // Set size default of state list
        heightStateListConstraint.constant = (heightStateList * 9.5) / 10
        widthStateListConstraint.constant = (widthStateList * 9.5) / 10
    }
    
    // MARK: - Private methods
    
    private func updateUI() {
        errorImageView.tintColor = UIColor.redMainColor()
        errorLabel.textColor = UIColor.redMainColor()
        
        // width state list
        widthStateList = stateListContainerView.frame.width
        stateListContainerView.layer.applySketchShadow()
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        
        let pageControlImage = UIImageView()
        pageControlImage.image =  #imageLiteral(resourceName: "slideNavigation") //imageLiteral(resourceName: "slideNavigation")
        let rightBarButtonItem = UIBarButtonItem(customView: pageControlImage)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func roundRadiuView() {
        firstNameContainerView.roundRadius()
        lastNameContainerView.roundRadius()
        emailContainerView.roundRadius()
        pwdContainerView.roundRadius()
        confirmPwdContainerView.roundRadius()
        addressContainerView.roundRadius()
        stateContainerView.roundRadius()
        cityContainerView.roundRadius()
        zipContainerView.roundRadius()
        nextButton.roundRadius()
        tableView.layer.cornerRadius = 4
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        firstNameTextField.attributedPlaceholder = attributedString(placeHolder: "First name")
        lastNameTextField.attributedPlaceholder = attributedString(placeHolder: "Last name")
        emailTextField.attributedPlaceholder = attributedString(placeHolder: "someone@mail.com")
        pwdTextField.attributedPlaceholder = attributedString(placeHolder: "*** *** ****")
        confirmPwdTextField.attributedPlaceholder = attributedString(placeHolder: "*** *** ****")
        addressTextField.attributedPlaceholder = attributedString(placeHolder: "Home address")
        cityTextField.attributedPlaceholder = attributedString(placeHolder: "City")
        zipTextField.attributedPlaceholder = attributedString(placeHolder: "Zip code")
    }
    
    @IBAction func actForgot(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let otpVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPwdVC") as! ForgotPwdViewController
        self.navigationController?.pushViewController(otpVC, animated: true)
    }
    
    private func attributedText() {
        //Attribute `agree` label
        
        let agreeText = "I have read and agreed to the <a href = 'https://www.google.com'>Terms of Service</a> and <a href = 'https://www.google.com/'>Privacy Policy </a>"

        let attr = NSMutableAttributedString(attributedString: agreeText.convertHtml() ?? NSAttributedString(string: agreeText))
        attr.addAttribute(.foregroundColor, value: UIColor.greyTextColor(), range: NSRange(location: 0, length: attr.string.count))
        agreeTextView.linkTextAttributes = [.foregroundColor: UIColor.greyTextColor()]
        agreeTextView.attributedText = attr

        
        agreeLabel.text = "I have read and agreed to the Terms of Service and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: agreeLabel.text!)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                          NSAttributedString.Key.underlineColor: UIColor.greyTextColor()]
        
        let termsOfService = (agreeLabel.text! as NSString).range(of: "Terms of Service")
        let privacyPolicy = (agreeLabel.text! as NSString).range(of: "Privacy Policy")
        attributedString.addAttributes(attributes, range: termsOfService)
        attributedString.addAttributes(attributes, range: privacyPolicy)
        agreeLabel.attributedText = attributedString
        
        //Attribute `Login` button
        let attributed = NSAttributedString(string: "Login",
                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: UIColor.mainColor()])
        loginButton.setAttributedTitle(attributed, for: .normal)
        
        // Attributed `Error` label
        errorLabel.text = "This email is already registered. Recover your password."
        let errorAttributedString = NSMutableAttributedString(string: errorLabel.text!)
        let errorAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        
        let recoverRange = (errorLabel.text! as NSString).range(of: "Recover your password.")
        errorAttributedString.addAttributes(errorAttributes, range: recoverRange)
        errorLabel.attributedText = errorAttributedString
    }
    
    private func setFont() {
        let font = UIFont.circularStdBook(size: 16)
        emailTextField.font = font
        emailTextField.textColor = UIColor.blackTextColor()
        pwdTextField.font = font
        pwdTextField.textColor = UIColor.blackTextColor()
        firstNameTextField.font = font
        lastNameTextField.textColor = UIColor.blackTextColor()
        lastNameTextField.font = font
        firstNameTextField.textColor = UIColor.blackTextColor()
        confirmPwdTextField.font = font
        confirmPwdTextField.textColor = UIColor.blackTextColor()
        addressTextField.font = font
        addressTextField.textColor = UIColor.blackTextColor()
        cityTextField.font = font
        cityTextField.textColor = UIColor.blackTextColor()
        zipTextField.font = font
        zipTextField.textColor = UIColor.blackTextColor()
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        //        if let email = emailTextField.text {
        //            errorContainerView.isHidden = !email.isEmpty
        //            emailContainerView.bordered(withColor: UIColor.redMainColor(), width: email.isEmpty ? 1 : 0)
        //        }
    }
    
    @IBAction func chooseStateButtonAction(_ button: UIButton) {
        let width = button.isSelected ? (widthStateList * 9.5) / 10 : stateListContainerView.frame.width
        let height = button.isSelected ? (heightStateList * 9.5) / 10 : stateListContainerView.frame.height
        stateListContainerView.alpha = button.isSelected ? 0 : 1
        widthStateListConstraint.constant = width
        heightStateListConstraint.constant = height
        
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        button.isSelected = !button.isSelected
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let image = sender.isSelected ? UIImage(named: "checked-icon") : UIImage(named: "check-icon")
        let flag = sender.isSelected ? true : false
        nextButton.activated(flag)
        checkButton.setImage(image, for: .normal)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
    func SignUP(){
        let randomIntFrom0To10 = generateRandomDigits(10)
        SwiftLoader.show(title:"Please Wait...", animated: false)
        let email = emailTextField.text?.lowercased() ?? ""
        let param :[String:Any] = ["email": email,
                                   "first_name":firstNameTextField.text ?? "",
                                   "last_name":lastNameTextField.text ?? "",
                                   "password":pwdTextField.text ?? "",
                                   "confirm_password":confirmPwdTextField.text ?? "",
                                   "address":addressTextField.text ?? "",
                                   "city": cityTextField.text ?? "",
                                   "state": stateLabel.text ?? "",
                                   "zip":zipTextField.text ?? "",
                                   // "phone_number":"\(randomIntFrom0To10)",
            //"phone_number":"",
            "country": "US",
            "user_type":userType,
            "fcm_token":DefaultManager().getFcmToken() ?? ""
        ]
        
        print(JSON.init(param))
        
        PSApi.apiRequestWithEndPointRegister(.createUser, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            let statusCode = response.response?.statusCode
            let dictUserData : [String:JSON] = (response.value?.dictionary)!
            //let status = dictUserData["status"]?.stringValue ?? ""
            
        
            switch statusCode {
            
             case 201:
                
                 print(" Case 201")
                self.errorImageView.isHidden = true
                DefaultManager().setEmail(value: self.emailTextField.text!.lowercased())
                
                let userData = User.init(dictUserData: response.value?.dictionary ?? [:])
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let addphoto = storyBoard.instantiateViewController(withIdentifier: "AddPhotoVC") as! AddPhotoViewController
                addphoto.userModel = userData
                 DefaultManager().setName(value: userData.firstVame + " " + userData.lastName)
            
                self.navigationController?.pushViewController(addphoto, animated: true)
                
                break
             case 202:
            
                 self.errorContainerView.isHidden = true
                  print(" Case 202")
                break
             case 412:
                self.emailReadyValues()
                let msg = dictUserData["msg"]?.stringValue ?? ""
                // self.errorLabel.text = "This email is already registered. Recover your password."
                // Utility.SubmitAlertView(viewController: self, title: "Alert!", message:msg)
                break
            default:
                  print("Default Case")
                break
              
            }
            
                    
        }
    }

    func alreadyEmaiRegisted(strEmail:String) {
        SwiftLoader.show(title:"Please Wait...", animated: false)
        let param = ["email":strEmail]
       
         PSApi.apiRequestWithEndPointSign(.isEmailExist, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
           // let statusCode = response.response?.statusCode
            let dictUserData : [String:JSON] = (response.value?.dictionary)!
            
             let statusCode = response.response?.statusCode
         //   let status = dictUserData["status"]?.stringValue ?? ""
            if statusCode == 400 {
                self.emailReadyValues()
            } else {
                
            }
        }
    }
    func emailReadyValues() {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red:1.00, green:0.20, blue:0.00, alpha:1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.00, green:0.34, blue:1.00, alpha:1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let partOne = NSMutableAttributedString(string: "This email is already registered.", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: " Recover your password.", attributes: yourOtherAttributes)
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        self.errorLabel.attributedText = combination
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textTapped(recognizer:)))
        tap.delegate = self
        self.errorLabel.addGestureRecognizer(tap)
        
        //self.updateUI()
        self.emailContainerView.bordered(withColor:UIColor(red:1.00, green:0.20, blue:0.00, alpha:1.0), width: 0.5)
        self.errorContainerView.isHidden = false
        self.errorImageView.isHidden = false
    }
    @objc func textTapped(recognizer:UITapGestureRecognizer) {
//        let objVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdVC")
//        self.present(objVc!, animated: true, completion: nil)
    }
    @IBAction func nextButtonAction(_ sender: Any) {

            if firstNameTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter First Name")
            } else if lastNameTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Last Name")
            } else if emailTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Email ID")
            } else if !Utility.validateEmail(candidate: emailTextField.text ?? "") {
                      Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter valid Email ID")
            } else if pwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Password")
            } else if self.validate(password: pwdTextField.text!) == false {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Password should be of minimum 6 characters where it must contain at least 1 uppercase letter, 1 lowercase letter, 1 digit and 1 special character.")
            } else if confirmPwdTextField.text?.count == 0 {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter Confirm Password")
            } else if pwdTextField.text != confirmPwdTextField.text{
//                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Your Password and Confirm Password does not match")
            } else {
                self.SignUP()
            }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        chooseStateButton.isSelected = false
        stateListContainerView.alpha = 0
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        let string = textField.text?.lowercased() ?? ""
        
        if textField === self.emailTextField {
            self.emailContainerView.bordered(withColor:UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
                , width: 1)
            if string != "" {
                let emailType = validateEmail(enteredEmail: string)
                if emailType == true {
                    print("Email ID")
                    alreadyEmaiRegisted(strEmail: string)
                }else {
                    self.emailContainerView.bordered(withColor:UIColor(red:1.00, green:0.20, blue:0.00, alpha:1.0)
                        , width: 1)
                    self.errorLabel.text = "Invalid email format."
                    self.errorContainerView.isHidden = false
                }
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    //MARKS:- Validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == zipTextField {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == firstNameTextField || textField == lastNameTextField {
            let notAllowedSet = CharacterSet.init(charactersIn: "0123456789")
            return string.rangeOfCharacter(from: notAllowedSet) == nil
        }
        
        if textField === self.confirmPwdTextField {
           // self.confirmPwdTextField.text = self.confirmPwdTextField.text! + string
            let str = pwdTextField.text
            let str1 = self.confirmPwdTextField.text ?? ""
            if "\(str1)" == "\(str?.dropLast() ?? "")" {
            self.errorContainerView.isHidden = true
            self.confirmPwdContainerView.bordered(withColor:UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
                    , width: 1)
            return true
        } else {
                self.confirmPwdContainerView.bordered(withColor:UIColor(red:1.00, green:0.20, blue:0.00, alpha:1.0)
                    , width: 1)
                self.errorLabel.text = "Confirm password did not match with password"
            self.errorContainerView.isHidden = false
            return true
        }
        }
        
        if textField === self.emailTextField {
            self.emailContainerView.bordered(withColor:UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
                , width: 1)
            if string != "" {
                let emailValue = self.emailTextField.text
                let emailType = validateEmail(enteredEmail: emailValue! + string)
                if emailType == true {
                    print("Email ID")
                    alreadyEmaiRegisted(strEmail: emailValue! + string)
                }else {
                    self.emailContainerView.bordered(withColor:UIColor(red:1.00, green:0.20, blue:0.00, alpha:1.0)
                        , width: 1)
                    self.errorLabel.text = "Invalid email format."
                    self.errorContainerView.isHidden = false
                    return true
                }
            }
        }
        self.errorContainerView.isHidden = true
        return true
        //Return false if you don't want the textfield to be updated
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if updatedString == confirmPwdTextField.text {
            return false

        }
        // do whatever you need with this updated string (your code)
        
        
        // always return true so that changes propagate
        return true
    }
    //Password Validation
    func validate(password: String) -> Bool {
        let regex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: pwdTextField.text)
        if(isMatched  == true) {
            // Do your stuff ..
            return true
        } else {
            // Show Error Message.
            return false
        }
    }
    //Email Validation
    func validateEmail(enteredEmail:String) -> Bool {
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}

// MARK: - UITableViewDataSource

extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StateTableViewCell.identifier, for: indexPath) as! StateTableViewCell
        cell.stateLabel.text = stateList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SignUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stateLabel.text = stateList[indexPath.row]
        chooseStateButton.isSelected = false
        stateListContainerView.alpha = 0
    }
}

