//
//  EditProfileViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateListContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var chooseUserImageButton: UIButton!
    @IBOutlet weak var facialButton: UIButton!
    @IBOutlet weak var facialLabel: UILabel!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var lastNameContainerView: UIView?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var secondNameField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateContainerView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var chooseStateButton: UIButton!
    @IBOutlet weak var cityContainerView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipContainerView: UIView!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var heightContentViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightStateListConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthStateListConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView?
    
    let stateList = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY"]
    
    // MARK: - Private let/var
    private var heightRow: CGFloat = 45
    private var widthStateList: CGFloat = 0
    private var heightStateList: CGFloat = 0
    
    var imagePicker: UIImagePickerController!
    
//    var picker = UIImagePickerController();
    var menu = MenuViewController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        title = "Edit Profile"
        
        // set shadow
        stateListContainerView.layer.applySketchShadow()
        
        prepareNavigationBar()
        roundRadiuView()
        prepareTextField()
        attributedText()
        //addTapGeture()
        emailTextField.isUserInteractionEnabled = false
        
        nameTextField.delegate = self
        secondNameField.delegate = self
        
        if let image = UserDefaults().imageForKey(key: "profile_logo_url") {
            profileImageView?.image = image
            self.chooseUserImageButton.setImage(UIImage(named: "camera"), for: .normal)
            self.profileImageView?.clipsToBounds = true
        }else{
            self.chooseUserImageButton.setImage(nil, for: .normal)
            self.profileImageView?.clipsToBounds = false
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        translucentNavigationBar()
        
//        if let image = DefaultManager().getImage() {
//            loadImage(image, profileImageView!, activity: nil, defaultImage: nil)
//        }
//        else{
//            profileImageView?.image = UIImage.init(named: "userAvatarCamera")
//        }
        
        let name1 = DefaultManager().getName()?.components(separatedBy: " ").first
        let name2 = DefaultManager().getName()?.components(separatedBy: " ").last
        
        nameTextField.text = name1
        secondNameField.text = name2
        
        if let name = DefaultManager().getName() {
            
        }
        
        if let email = DefaultManager().getEmail() {
            emailTextField.text = email
        }
        
        if let address = DefaultManager().getAddress() {
            addressTextField.text = address
        }
        
        if let name = DefaultManager().getState() {
            stateLabel.text = name
        }
        
        if let name = DefaultManager().getCity() {
            cityTextField.text = name
        }
        
        if let name = DefaultManager().getZipCode() {
            zipTextField.text = name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set height contentView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: informationStackView.frame.maxY + 20)
        heightContentViewConstraint.constant = informationStackView.frame.maxY + 20
        
        // Set height state list
        heightStateList = heightRow * 3
        
        // width state list
        widthStateList = stateListContainerView.frame.width
        
        // Set size default of state list
        heightStateListConstraint.constant = (heightStateList * 9.5) / 10
        widthStateListConstraint.constant = (widthStateList * 9.5) / 10
    }
    
    // MARK: - Methods
    
    @objc func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func medicallButtonAction() {
        performSegue(withIdentifier: "showMedicalIDSegue", sender: nil)
    }
    
    @objc func tapContentViewAction() {
        contentView.endEditing(true)
        chooseStateButton.isSelected = false
        stateListContainerView.alpha = 0
    }
    
    // MARK: - Private methods
    
    private func addTapGeture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapContentViewAction))
        tap.cancelsTouchesInView = true
        contentView.addGestureRecognizer(tap)
    }
    
    func saveImageInUserDefault(img:UIImage, key:String) {
          UserDefaults.standard.set(img.pngData(), forKey: key)
      }
    
    private func roundRadiuView() {
        nameContainerView.roundRadius()
        lastNameContainerView?.roundRadius()
        emailContainerView.roundRadius()
        addressContainerView.roundRadius()
        stateContainerView.roundRadius()
        cityContainerView.roundRadius()
        zipContainerView.roundRadius()
        doneButton.roundRadius()
        stateListContainerView.layer.cornerRadius = 4
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        nameTextField.attributedPlaceholder = attributedString(placeHolder: "Full name")
        emailTextField.attributedPlaceholder = attributedString(placeHolder: "someone@mail.com")
        addressTextField.attributedPlaceholder = attributedString(placeHolder: "Home address")
        cityTextField.attributedPlaceholder = attributedString(placeHolder: "City")
        zipTextField.attributedPlaceholder = attributedString(placeHolder: "Zip code")
    }
    
    private func attributedText() {
        //Attribute `agree` label
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                          NSAttributedString.Key.underlineColor: UIColor.greyTextColor()]
        facialLabel.attributedText = NSAttributedString(string: "Facial Recognition",
                                                        attributes: attributes)
    }
    
    private func prepareNavigationBar() {
        navigationItem.hidesBackButton = true
        
        // Add barButtonItem for rightBarButton
        let medicalButton = creatCustomBarButton(title: "Medical ID")
        medicalButton.addTarget(self, action: #selector(medicallButtonAction), for: .touchUpInside)
        medicalButton.isHidden = true
        let medicalBarButtonItem = UIBarButtonItem(customView: medicalButton)
        
        navigationItem.rightBarButtonItems = [medicalBarButtonItem]
        
        // Add barButtonItem for leftBarButton
        let cancelButton = creatCustomBarButton(title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func chooseUserImageButtonAction(_ sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectImageFrom(.camera)
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectImageFrom(.photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
//        picker.delegate = self as (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
//        selectImageFrom(.photoLibrary)
    }
    
    @IBAction func facialButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func chooseStateButtonAction(_ button: UIButton) {
        let width = button.isSelected ? (widthStateList * 9.5) / 10 : widthStateList
        let height = button.isSelected ? (heightStateList * 9.5) / 10 : heightStateList
        stateListContainerView.alpha = button.isSelected ? 0 : 1
        widthStateListConstraint.constant = width
        heightStateListConstraint.constant = height
        
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
        button.isSelected = !button.isSelected
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        hitUpdateProfileApi()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
        chooseStateButton.isSelected = false
        stateListContainerView.alpha = 0
    }*/
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StateTableViewCell.identifier, for: indexPath) as! StateTableViewCell
        cell.stateLabel.text = stateList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         chooseStateButton.isSelected = false
         stateListContainerView.alpha = 0
         UIView.animate(withDuration: 0.3) {
             self.view.setNeedsLayout()
             self.view.layoutIfNeeded()
         }
         stateLabel.text = stateList[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

// MARK: - UITableViewDelegate

//extension EditProfileViewController {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return heightRow
//    }
//
//
//    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chooseStateButton.isSelected = false
//        stateListContainerView.alpha = 0
//        UIView.animate(withDuration: 0.3) {
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//        }
//        stateLabel.text = stateList[indexPath.row]
//    }*/
//
//}




extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
//    func openCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func openPhotoLibrary() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
//                   let imagePicker = UIImagePickerController()
//                   imagePicker.delegate = self
//                   imagePicker.allowsEditing = true
//                   imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//                   self.present(imagePicker, animated: true, completion: nil)
//               }
//
//    }
    
    func selectImageFrom(_ source: ImageSource) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
         self.profileImageView?.clipsToBounds = true
         self.chooseUserImageButton.setImage(UIImage(named: "camera"), for: .normal)
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        profileImageView?.image = selectedImage
        uploadImage()
    }
    
}




extension EditProfileViewController {
    
    
    func uploadImage() {

        let url = BASE_URL + Users.UPLOAD_PHOTO
        guard let image = profileImageView?.image else {return}
        guard let data = image.jpegData(compressionQuality: 0.3) else {return}
        SwiftLoader.show(title:"Uploading...", animated: false)
        
        let userEmail = DefaultManager().getEmail()  ?? ""
        ApiManager.shared.UploadPhoto(url, data, "profile.png", ["email":userEmail], header: nil) { (error, reponse, statuCode) in
            
            
            if let err = error {
                SwiftLoader.hide()
                print(err.localizedDescription)
            }else if let json = reponse, let code = statuCode {
                print(json)
                if code == 200 {
                    SwiftLoader.hide()
//                    DefaultManager().setImage(value: json["profile_logo_url"].stringValue)
                     UserDefaults().setImage(image: self.profileImageView?.image, forKey: "profile_logo_url")
                    showAlert(msg: "Image updated successfully", title: "Message", sender: self)
                }else{
                    SwiftLoader.hide()
                    showAlert(msg: "Something went worng, please try again", title: "Error", sender: self)
                }
            }
        }
        
    }
    
    
    func hitUpdateProfileApi() {

        let url = BASE_URL + Constants.UPDATE_PROFILE
        SwiftLoader.show(title:"Updating...", animated: false)
        
        let firstName = nameTextField.text ?? ""
        let lastName = secondNameField.text ?? ""
        
        let param:[String:Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "state": stateLabel.text ?? "",
            "city": cityTextField.text ?? "",
            "zip": zipTextField.text ?? "",
            "address": addressTextField.text ?? ""
        ]
        
        print(JSON.init(param))
        
        ApiManager.shared.PATCHApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response {
                print(json)
                if statusCode == 200 {
                    
                    let name = json["first_name"].stringValue + " " + json["last_name"].stringValue
                    
                    DefaultManager().setName(value: name)
                    DefaultManager().setAddress(value: json["address"].string)
                    DefaultManager().setCity(value: json["city"].string)
                    DefaultManager().setState(value: json["state"].string)
                    DefaultManager().setZipCode(value: json["zip"].string)
                    DefaultManager().setCity(value: json["city"].string)
                    
                    showAlertWithConfirmation("Profile updated successfully", "Message", self) { (isAllowed) in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
}











extension EditProfileViewController :UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField || textField == secondNameField {
            let aSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
}
