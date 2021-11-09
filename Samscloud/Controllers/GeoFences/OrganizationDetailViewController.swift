//
//  OrganizationDetailViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/15/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import CoreLocation


class OrganizationDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var policeImageView: UIImageView!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incidentSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var checkInSwitch: UISwitch!
    @IBOutlet weak var alertsSwitch: UISwitch!
    @IBOutlet weak var radiusButton: UIButton!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var pencilImageView: UIImageView!
    @IBOutlet weak var setRadiusContainerView: UIView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusContainerView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var name = ""
    var organization:OrganizationModel?
    
    // MARK: - View life cycle

    
    static func instanse() ->OrganizationDetailViewController{
        let container = UIStoryboard.init(name: "Contact", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "OrganizationDetailVC") as! OrganizationDetailViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = name
        
        prepareNavigation()
        prepareUI()
        prepareTextField()
        
        addressLabel.text = organization?.address
        
        if let lat = organization?.latitude , let long = organization?.longitude {
            if appDelegate.currentLocation != nil{
                let loc1 = CLLocation.init(latitude: lat, longitude: long)
                let distance = loc1.distance(from: appDelegate.currentLocation)/1609.34
                let str = String.init(format: "%.2f miles", Float(distance))
                rangeButton.setTitle(str, for: .normal)
            }
        }
        if let dispatch = organization?.dispatch {
            policeImageView.isHidden = !dispatch
        }
         
        if let alert = organization?.alert {
            notificationImageView.isHidden = !alert
        }
        
        if let img = organization?.logo, img != ""{
            loadImage(img, userImageView, activity: nil, defaultImage: nil)
        }else{
            userImageView.image = UIImage.init(named: "logo-landing")
        }
        
        userImageView.roundRadius()
        phoneTextField.text = organization?.phone_number
        emailTextField.text = organization?.email
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: setRadiusContainerView.frame.maxY + 15)
        contentViewHeightConstraint.constant = setRadiusContainerView.frame.maxY + 15
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        radiusContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - Methods
    
    @objc func saveButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareUI() {
        rangeButton.layer.cornerRadius = 2
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let saveButton = creatCustomBarButton(title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    private func attributedString(string: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let mainColor = UIColor.mainColor()
        let attributed = NSAttributedString(string: string,
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: mainColor,
                                                         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: mainColor])
        return attributed
    }
    
    private func prepareTextField() {
        phoneTextField.attributedText = attributedString(string: "+1 323 765 3885")
        emailTextField.attributedText = attributedString(string: "Sams@Baylor.com")
    }
    
    // MARK: - IBActions

    @IBAction func phoneNumberButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        let messageChatVC = StoryboardManager.contactStoryBoard().getController(identifier: "MessageChatVC") as! MessageChatViewController
        messageChatVC.titleText = name
        messageChatVC.isFromGeofence = true
        
        navigationController?.pushViewController(messageChatVC, animated: true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func radiusButtonAction(_ sender: UIButton) {
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }
}
