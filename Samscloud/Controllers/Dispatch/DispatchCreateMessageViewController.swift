//
//  DispatchCreateMessageViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchCreateMessageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var selectGroupContainerView: UIView!
    @IBOutlet weak var geofenceContainerView: UIView!
    @IBOutlet weak var radiusContainerView: UIView!
    @IBOutlet weak var addMessageContainerView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var verifyContainerView: UIView!
    @IBOutlet weak var conferenceContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectGroupTextField: UITextField!
    @IBOutlet weak var goLiveButton: UIButton!
    @IBOutlet weak var verifySwitch: UISwitch!
    @IBOutlet weak var conferenceSwitch: UISwitch!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var nextButton: UIButton!
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        goLiveButton.roundRadius()
        prepareNavigationBar()
        attributeText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: bottomStackView.frame.maxY + 10)
        contentViewHeightConstraint.constant = bottomStackView.frame.maxY + 10
    }
    
    
    // MARK: - ACTIONS
    
    @objc func nextButtonAction() {
        let dispatchIncidentDetailVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchIncidentDetailVC") as! DispatchIncidentDetailViewController
        dispatchIncidentDetailVC.isMessageDetail = true
        navigationController?.pushViewController(dispatchIncidentDetailVC, animated: true)
    }
    
    private func attributeString(string: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "d3d3d3")
        let attributeString = NSAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font,
                                                              NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributeString
    }
    
    private func attributeText() {
        let font = UIFont.circularStdBook(size: 16)
        nameTextField.attributedPlaceholder = attributeString(string: "Title")
        selectGroupTextField.attributedPlaceholder = attributeString(string: "Search college or mall")
        nameTextField.font = font
        nameTextField.textColor = UIColor.blackTextColor()
        selectGroupTextField.font = font
        selectGroupTextField.textColor = UIColor.blackTextColor()
    }
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        nextButton = creatCustomBarButton(title: "Next")
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        nextButton.activatedOfNavigationBar(false)
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)
        navigationItem.rightBarButtonItem = nextBarButtonItem
    }

    
    // MARK: - IBACTIONS
    
    @IBAction func showSelectGroupButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showSelectGroupSegue", sender: nil)
    }
    
    @IBAction func geofenceButtonActions(_ sender: UIButton) {
        let searchLocationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchLocationVC") as! SearchLocationViewController
        searchLocationVC.isDispatchLocation = true
        navigationController?.pushViewController(searchLocationVC, animated: true)
    }
    
    @IBAction func radiusButtonAction(_ sender: UIButton) {
        let resultLocationVC = StoryboardManager.contactStoryBoard().getController(identifier:  "ResultLocationVC") as! ResultLocationViewController
        resultLocationVC.isDispatchRadius = true
        navigationController?.pushViewController(resultLocationVC, animated: true)
    }
    
    @IBAction func selectGroupButtonAction(_ sender: UIButton) {
        selectGroupTextField.becomeFirstResponder()
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let name = textField.text {
            nextButton.activatedOfNavigationBar(!name.isEmpty)
        }
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        print("SWITCH VALUE CHANGED")
    }
    
    
    // MARK: - TOUCHES / GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
