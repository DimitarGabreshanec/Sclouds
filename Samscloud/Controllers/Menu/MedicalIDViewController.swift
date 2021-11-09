//
//  MedicalIDViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MedicalIDViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var medicalContainerView: UIView!
    @IBOutlet weak var medicalTextField: UITextField!
    @IBOutlet weak var specialContainerView: UIView!
    @IBOutlet weak var specialTextField: UITextField!
    @IBOutlet weak var allergicContainerView: UIView!
    @IBOutlet weak var allergicTextField: UITextField!
    @IBOutlet weak var medicationsContainerView: UIView!
    @IBOutlet weak var medicationsTextField: UITextField!
    @IBOutlet weak var bloodTypeContainerView: UIView!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var heightContainerView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightContainerView: UIView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var physicianContainerView: UIView!
    @IBOutlet weak var physicianLabel: UILabel!
    @IBOutlet weak var emergencyContainerView: UIView!
    @IBOutlet weak var emergencyTextField: UITextField!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Medical ID"
        
        roundRadiuView()
        prepareTextField()
        prepareNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        translucentNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set height contentView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width,
                                        height: informationStackView.frame.maxY + 20)
        contentViewHeightConstraint.constant = informationStackView.frame.maxY + 20
    }
    
    // MARK: - Methods
    
    @objc func saveButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let saveButton = creatCustomBarButton(title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItems = [saveBarButtonItem]
    }
    
    private func roundRadiuView() {
        medicalContainerView.roundRadius()
        specialContainerView.roundRadius()
        allergicContainerView.roundRadius()
        medicationsContainerView.roundRadius()
        bloodTypeContainerView.roundRadius()
        heightContainerView.roundRadius()
        weightContainerView.roundRadius()
        physicianContainerView.roundRadius()
        emergencyContainerView.roundRadius()
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "D3D3D3")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        medicalTextField.attributedPlaceholder = attributedString(placeHolder: "None listed")
        specialTextField.attributedPlaceholder = attributedString(placeHolder: "None listed")
        allergicTextField.attributedPlaceholder = attributedString(placeHolder: "None listed")
        medicationsTextField.attributedPlaceholder = attributedString(placeHolder: "None listed")
        emergencyTextField.attributedPlaceholder = attributedString(placeHolder: "Add")
    }

    // MARK: - IBActions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    }
}
