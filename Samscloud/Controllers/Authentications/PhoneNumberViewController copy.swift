//
//  PhoneNumberViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.

import UIKit

class PhoneNumberViewController: UIViewController ,UITextFieldDelegate{
    
    // MARK: - IBOutlets
    @IBOutlet weak var chooseCountryView: UIView!
    @IBOutlet weak var chooseCountryButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var areaCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var countryContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthCountryListConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCountryListConstraint: NSLayoutConstraint!
    
    // Confirm phone
    @IBOutlet var confirmPhoneContainerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var confirmPhoneNumberLabel: UILabel!
    
    // MARK: - Private let/var
    private var heightRow: CGFloat = 45
    private var widthCountryList: CGFloat = 0
    private var heightCountryList: CGFloat = 0
    private var alphaView: UIView!
    var userModel = User()
    let UserId : String = ""
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.delegate = self
        title = "Phone Number"
        //   let = nid = userModel.id
        updateUI()
        prepareNavigation()
        prepareTextField()
    }
    
    // MARK: - Private methods
    
    private func updateUI() {
        // Default frame
        widthCountryList = countryContainerView.frame.width
        heightCountryList = countryContainerView.frame.height
        widthCountryListConstraint.constant = (widthCountryList * 9.5) / 10
        heightCountryListConstraint.constant = (heightCountryList * 9.5) / 10
        
        // Set shadow
        countryContainerView.layer.applySketchShadow()
        
        // Round radius
        nextButton.roundRadius()
        confirmPhoneContainerView.layer.cornerRadius = 15
        chooseCountryView.layer.cornerRadius = 4
        tableView.layer.cornerRadius = 4
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        
        //        let pageControlImage = UIImageView()
        //        pageControlImage.image =  imageLiteral(resourceName: "slideNavigation-3")
        //        let rightBarButtonItem = UIBarButtonItem(customView: pageControlImage)
        //        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "B4B4B4")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        phoneNumberTextField.attributedPlaceholder = attributedString(placeHolder: "Phone number")
        phoneNumberTextField.textColor = UIColor.blackTextColor()
        phoneNumberTextField.font = UIFont.circularStdBook(size: 16)
    }
    
    fileprivate func animateIn() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(alphaView)
        confirmPhoneContainerView.center = self.alphaView.center
        
        alphaView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alphaView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.alphaView.alpha = 1
            self.alphaView.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alphaView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.alphaView.alpha = 0
            
        }) { (success: Bool) in
            self.alphaView.removeFromSuperview()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func chooseCountryButtonAction(_ button: UIButton) {
        let width = button.isSelected ? (widthCountryList * 9.5) / 10 : countryContainerView.frame.width
        let height = button.isSelected ? (heightCountryList * 9.5) / 10 : countryContainerView.frame.height
        countryContainerView.alpha = button.isSelected ? 0 : 1
        widthCountryListConstraint.constant = width
        heightCountryListConstraint.constant = height
        
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        button.isSelected = !button.isSelected
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        /*
         let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { alert in
         // Doing something
         })
         let closeAction = UIAlertAction(title: "Edit", style: .cancel, handler: nil)
         let message = "Is this your correct phone number?"
         self.showAlertWithActions("CONFIRM PHONE\n23423423423423",
         message: message,
         actions: [yesAction, closeAction])
         */
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        } else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        chooseCountryButton.isSelected = false
        countryContainerView.alpha = 0
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        animateOut()
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        animateOut()
        phoneNumberAPiCaling()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (self.phoneNumberTextField.text?.count)! < 11 {
            Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Please enter atleast 10 character")
        } else {
            confirmPhoneNumberLabel.text = "+1 " + phoneNumberTextField!.text!
            alphaView = UIView.init(frame: UIApplication.shared.keyWindow!.frame)
            alphaView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            alphaView.addSubview(confirmPhoneContainerView)
            view.endEditing(true)
            animateIn()
        }
    }
    
    // request the phone API
    func phoneNumberAPiCaling() {
        SwiftLoader.show(title:"Please Wait...", animated: false)
        
        let param = ["mobile_number": "1234567895"] as [String : Any]
        PSApi.apiRequestWithEndPoint(.phone, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            print(response)
            let statusCode = response.response?.statusCode
            if  statusCode == 200 {
                ("Success")
                
                let param = ["":""] as [String : Any]
                PSApi.apiRequestWithEndPoint(.phoneVerification(id: self.userModel.id), params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
                    print(response)
                    let statusCode = response.response?.statusCode
                    if  statusCode == 200 {
                        // self.performSegue(withIdentifier: "VerifiCodeVC", sender: self)
                        
                        // performSegue(withIdentifier: "VerifiCodeVC", sender: nil)
                        
                         let phonenoController = self.storyboard?.instantiateViewController(withIdentifier: "VerifiCodeVC") as! VerifiCodeViewController
                         phonenoController.userModel.id = self.userModel.id
                         self.present(phonenoController, animated: true, completion: nil)
                        
                        // self.performSegue(withIdentifier: "showVerifiCodeSegue", sender: nil)
                    } else {
                        Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                    }
                }
            } else {
                Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
            }
            
            
            //            PSApi.apiRequestWithEndPoint(.phoneVerification(id: userModel.id), params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: true) { (response) in
            //                print(response)
            //                 self.performSegue(withIdentifier: "showVerifiCodeSegue", sender: nil)
            //            }
            
        }
    }
}

// MARK: - UITableViewDataSource

extension PhoneNumberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as! CountryTableViewCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PhoneNumberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseCountryButton.isSelected = false
        countryContainerView.alpha = 0
    }
}
