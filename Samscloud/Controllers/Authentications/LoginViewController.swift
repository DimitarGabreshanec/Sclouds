//
//  LoginViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation


class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var pwdContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var forgotPwdButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var isToShowBack = false
    // MARK: - INIT
    
    class func makeRoot() {
        let container = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "LoginViewControllerNV") as! UINavigationController
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    class func instanse()-> LoginViewController{
        let container = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Account"
        // Disable `login` button
        // loginButton.activated(false)
        
        prepareTextField()
        roundRadiuView()
        translucentNavigationBar()
        prepareNavigation()
        addTapContentView()
        attributedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestorePageSegue" {
            let restoreVC = segue.destination as! ForgotPwdViewController
            restoreVC.restoreButtonAction = {
                let vc = VerifiCodeViewController.instanse()
                vc.isForgotPassword = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func tapContentView() {
        contentView.endEditing(true)
    }
    
    // MARK: - Private method
    private func prepareNavigation() {
        if isToShowBack {
           createBackBarButtonItem()
        }
    }
    
    private func roundRadiuView() {
        emailContainerView.roundRadius()
        pwdContainerView.roundRadius()
        loginButton.roundRadius()
    }
    
    private func prepareTextField() {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        emailTextField.attributedPlaceholder = NSAttributedString(string: "someone@mail.com", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        
        pwdTextField.attributedPlaceholder = NSAttributedString(string: "*** *** ****", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        emailTextField.font = font
        pwdTextField.font = font
        emailTextField.textColor = UIColor.blackTextColor()
        pwdTextField.textColor = UIColor.blackTextColor()
    }
    
    private func attributedText() {
        //Attribute String
        let attributed = NSAttributedString(string: "Register",
                                            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: UIColor.mainColor()])
        registerButton.setAttributedTitle(attributed, for: .normal)
    }
    
    private func addTapContentView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
        tap.cancelsTouchesInView = true
        contentView.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let email = emailTextField.text,
            let password = pwdTextField.text {
            DispatchQueue.main.async {
                self.loginButton.activated(!email.isEmpty && !password.isEmpty)
            }
        }
    }
    
    @IBAction func forgotPwdButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
       
        /*
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                
            }else{
                
            }
        }
    */
        self.handleLogin()
        
    }
    
    
    func handleLogin() {
        
        if !Utility.validateEmail(candidate: emailTextField.text ?? "") {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please Enter valid Email Id")
        } else{
            //AppState.setHomeVC()
            
            if Utility.getLength(string: emailTextField.text!) > 0 {
                if Utility.getLength(string: pwdTextField.text!) > 0{
                    guard Utility.isConnectedToNetwork() else {
                        Utility.SubmitAlertView(viewController: self, title: "", message: "networkError")
                        return
                    }
                    SwiftLoader.show(title:"Logging In ...", animated: true)
                    let param = ["email":emailTextField.text!,
                                 "password":pwdTextField.text!,
                                 "fcm_token":DefaultManager().getFcmToken() ?? ""
                    ]
                    PSApi.apiRequestWithEndPointSign(.authLogin, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
                        
                        SwiftLoader.hide()
                        let statusCode = response.response?.statusCode
                        if  statusCode == 200 {
                            
                            guard let json = response.value else {return}
                            print(json)
                            
                            /*if !json["profile_logo"].isKeyPresent() {
                                print("****** profile_logo is null ******")
                                //let userData = User.init(dictUserData: response.value?.dictionary ?? [:])
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let addphoto = storyBoard.instantiateViewController(withIdentifier: "AddPhotoVC") as! AddPhotoViewController
                                    //addphoto.userModel = userData
                                     //DefaultManager().setName(value: userData.firstVame + " " + userData.lastName)
                                    self.navigationController?.pushViewController(addphoto, animated: true)
                                return
                            }else*/
                            let userData = User.init(dictUserData: response.value?.dictionary ?? [:])
                            DefaultManager().setShareLocationStatus(value: json["share_location"].bool)
                            DefaultManager().setPhoneNumber(value: json["phone_number"].string)
                            DefaultManager().setEmail(value: self.emailTextField.text)
                            DefaultManager().setImage(value: json["profile_logo"].string)
                            let string = json["profile_logo"].string
                            if let image = getImage(from: string ?? ""){
                                UserDefaults().setImage(image: image, forKey: "profile_logo_url")
//                                print("user image is \()")

                            }
                            DefaultManager().setName(value: userData.firstVame + " " + userData.lastName)
                            DefaultManager().setAddress(value: json["address"].string)
                            DefaultManager().setCity(value: json["city"].string)
                            DefaultManager().setState(value: json["state"].string)
                            DefaultManager().setZipCode(value: json["zip"].string)
                            DefaultManager().setCity(value: json["city"].string)
                            
                            
                            DefaultManager().setAutoRouteOrganization(value: json["auto_route_incident_organization"].bool)
                            DefaultManager().setAutoRouteContact(value: json["auto_route_contacts"].bool)
                            
                            DefaultManager().setShake(value: json["shake_activate_incident"].bool)
                            
                            DefaultManager().setShareLocationStatus(value: json["share_location"].bool)
                            
                            if json["verified_status"].boolValue == false {
                                print("****** verified_status is false ******")
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let otpVC = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberViewController
                                self.navigationController?.pushViewController(otpVC, animated: true)
                                return
                            }
                            
                            let defaults = UserDefaults.standard
                            defaults.set(self.emailTextField.text!, forKey: "email")
                            defaults.synchronize()
                            
                            print("login response \(response)")

                            
                            self.checkForPermission()
                            //AppState.setHomeVC()
                        } else {
                            if let data = response.data {
                                let json = try? JSON.init(data: data)
                                let msg = json?["non_field_errors"].array?.first?.stringValue ?? ""
                                showAlert(msg: msg, title: "Error", sender: self)
                            }else{
                               Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something went wrong")
                            }
                        }
                    }
                    
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please_enter_username_and_password")
                }
            } else {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "")
            }
        }

    }
    
    
    
    func checkForPermission() {
        
        let status = CLLocationManager.authorizationStatus()
        
        let locat_finalStatus:Bool = (status == .authorizedAlways || status == .authorizedWhenInUse)
        
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    if locat_finalStatus {
                        AppState.setHomeVC()
                    }else{
                        let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
                        permissionVC.isLocation = true
                        permissionVC.delegate = self
                        permissionVC.modalPresentationStyle = .fullScreen
                        self.present(permissionVC, animated: false, completion: nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
                    permissionVC.isLocation = !locat_finalStatus
                    permissionVC.delegate = self
                    permissionVC.modalPresentationStyle = .fullScreen
                    self.present(permissionVC, animated: false, completion: nil)
                }
            }
        }
        
    }
    
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        let vc = StoryboardManager.mainStoryBoard().getController(identifier: "SignUpVC") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showLocationPermission() {
        let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
        permissionVC.isLocation = true
        permissionVC.modalPresentationStyle = .fullScreen
        present(permissionVC, animated: false, completion: nil)
    }
    
    func showNotificationPermission() {
        let permissionVC = StoryboardManager.mainStoryBoard().getController(identifier: "PermissionVC") as! PermissionViewController
        permissionVC.isLocation = false
        permissionVC.modalTransitionStyle = .crossDissolve
        present(permissionVC, animated: false, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate,PermissionViewControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            pwdTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    func didFinish() {
        DispatchQueue.main.async {
            AppState.setHomeVC()
        }
    }
    
}

extension String {
func toImage() -> UIImage? {
    if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
        return UIImage(data: data)
    }
    return nil
}
}

func getImage(from string: String) -> UIImage? {
    //2. Get valid URL
    guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
    }

    var image: UIImage? = nil
    do {
        //3. Get valid data
        let data = try Data(contentsOf: url, options: [])

        //4. Make image
        image = UIImage(data: data)
    }
    catch {
        print(error.localizedDescription)
    }

    return image
}




