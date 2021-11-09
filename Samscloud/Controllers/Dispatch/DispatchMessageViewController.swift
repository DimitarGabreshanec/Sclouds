//
//  DispatchMessageViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchMessageViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterMessageView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var topEndIncidentViewConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var isLiveMessage = false
    var isReportMessage = false
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        topEndIncidentViewConstraint.constant = -containerView.frame.height
        prepareContainerView()
        renderUIWithLiveMessage()
        renderUIWithReport()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        topEndIncidentViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    // MARK: - Private methods
    
    private func hideContainerView() {
        topEndIncidentViewConstraint.constant = -containerView.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
        
        messageTextField.resignFirstResponder()
    }
    
    private func prepareContainerView() {
        enterMessageView.roundRadius()
        bottomView.roundRadius()
        containerView.layer.cornerRadius = 20
        
        // attribute message text
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor.greyTextColor()
        let attributed = NSAttributedString(string: "Enter message here",
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: placeholderColor])
        messageTextField.attributedPlaceholder = attributed
        messageTextField.font = font
        messageTextField.textColor = UIColor.blackTextColor()
    }
    
    private func renderUIWithLiveMessage() {
        if isLiveMessage {
            titleLabel.text = "Live Message"
            saveButton.setTitle("Send", for: .normal)
        }
    }
    
    private func renderUIWithReport() {
        if isReportMessage {
            titleLabel.text = "Report"
            saveButton.setTitle("Submit", for: .normal)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        hideContainerView()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        hideContainerView()
        if isLiveMessage {
            // Handle `send` button
        }
        else {
            // Handle `save` button
        }
    }
    
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
        hideContainerView()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DispatchMessageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        
        return true
    }
}
