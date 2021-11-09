//
//  ActiveIncidentViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

@objc protocol ActiveIncidentViewControllerDelegate {
    @objc optional func didSelectEndOption(value:String)
}


class ActiveIncidentViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var heightContainerView: CGFloat = 0
    var heightEndIncidentView: CGFloat = 0
    var endButtonAction: (() -> Void)?
    var continueButtonAction: (() -> Void)?
    var delegate:ActiveIncidentViewControllerDelegate?
    var reasonStr:String? = ""
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendHelpButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var callMeButton: UIButton!
    @IBOutlet weak var accidentButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    // End active incident custom
    @IBOutlet weak var blurEndIncidentView: UIView!
    @IBOutlet weak var endIncidentContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterMessageView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topEndIncidentViewConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        heightContainerView = containerView.frame.height
        heightEndIncidentView = endIncidentContainerView.frame.height
        bottomContainerViewConstraint.constant = -heightContainerView
        topEndIncidentViewConstraint.constant = -heightEndIncidentView
        roundRadiusView()
        prepareEndIncidentView()
        
        buttons.forEach({
            $0.setTitleColor(.black, for: .normal)
        })
        callMeButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 1, alpha: 1), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomContainerViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        endIncidentContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func roundRadiusView() {
        continueButton.roundRadius()
        endButton.roundRadius()
    }
    
    private func prepareEndIncidentView() {
        enterMessageView.roundRadius()
        bottomView.roundRadius()
        // attribute message text
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor.greyTextColor()
        let attributed = NSAttributedString(string: "Enter message here",
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: placeholderColor])
        messageTextField.attributedPlaceholder = attributed
    }
    
    private func hideEndIncidentView() {
        topEndIncidentViewConstraint.constant = -heightEndIncidentView
        blurEndIncidentView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
        messageTextField.resignFirstResponder()
    }
    
    private func hideActiveIncidentView(dismissCompeletion: (() -> Void)?) {
        bottomContainerViewConstraint.constant = -heightContainerView
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.view.setNeedsLayout()
        }) { (finished) in
            self.dismiss(animated: false, completion: {
                dismissCompeletion?()
            })
        }
        messageTextField.resignFirstResponder()
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func continueButtonAction(_ sender: Any) {
        hideActiveIncidentView(dismissCompeletion: nil)
        /*
        hideActiveIncidentView(dismissCompeletion: {
            self.continueButtonAction?()
        })
         */
    }
    
    @IBAction func endButtonAction(_ sender: Any) {
        print("END BUTTON PRESSED - ACTIVEINCIDENT_VC")
        hideActiveIncidentView(dismissCompeletion: {
            //self.endButtonAction?()
            self.delegate?.didSelectEndOption?(value: self.reasonStr != "" ? self.reasonStr ?? "Please Call Me" : "Please Call Me")
        })
    }
    
    @IBAction func customBottonAction(_ sender: UIButton) {
        print("CUSTOM BUTTON PRESSED - ACTIVEINCIDENT_VC")
        topEndIncidentViewConstraint.constant = 0
        blurEndIncidentView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    
    
    @IBAction func accidentBottonAction(_ sender: UIButton) {
        print("ACCIDENT BUTTON PRESSED - ACTIVEINCIDENT_VC")
        buttons.forEach({
            $0.setTitleColor(.black, for: .normal)
        })
        let color = #colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 1, alpha: 1)
        reasonStr = sender.titleLabel?.text
        buttons[sender.tag].setTitleColor(color, for: .normal)
    }
    
    
    
    @IBAction func callMeBottonAction(_ sender: UIButton) {
        print("CALL ME BUTTON PRESSED - ACTIVEINCIDENT_VC")
        buttons.forEach({
            $0.setTitleColor(.black, for: .normal)
        })
        let color = #colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 1, alpha: 1)
        reasonStr = sender.titleLabel?.text
        buttons[sender.tag].setTitleColor(color, for: .normal)
    }
    
    
    
    @IBAction func okBottonAction(_ sender: UIButton) {
        print("OK BUTTON PRESSED - ACTIVEINCIDENT_VC")
        buttons.forEach({
            $0.setTitleColor(.black, for: .normal)
        })
        let color = #colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 1, alpha: 1)
        reasonStr = sender.titleLabel?.text
        buttons[sender.tag].setTitleColor(color, for: .normal)
    }
    
    
    
    @IBAction func sendHelpBottonAction(_ sender: UIButton) {
        print("SEND HELP BUTTON PRESSED - ACTIVEINCIDENT_VC")
        buttons.forEach({
            $0.setTitleColor(.black, for: .normal)
        })
        let color = #colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 1, alpha: 1)
        reasonStr = sender.titleLabel?.text
        buttons[sender.tag].setTitleColor(color, for: .normal)
    }
    
    
    
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
        print("MAIN VIEW TAPPED - ACTIVEINCIDENT_VC")
        if topEndIncidentViewConstraint.constant == -heightEndIncidentView {
            hideActiveIncidentView(dismissCompeletion: nil)
        } else {
            hideEndIncidentView()
        }
    }
    
    // End active incident custom
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("CANCEL BUTTON PRESSED - ACTIVEINCIDENT_VC")
        hideEndIncidentView()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        print("TEXT FIELD EDITING CHANGED")
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        print("SUBMIT BUTTON PRESSED - ACTIVEINCIDENT_VC")
        //AppState.setHomeVC()
        messageTextField.resignFirstResponder()
        hideActiveIncidentView(dismissCompeletion: {
            //self.endButtonAction?()
            self.delegate?.didSelectEndOption?(value: self.messageTextField.text ?? "")
        })
        
    }
    
    
    // MARK: - GESTURES / TOUCHES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        if let view = touch.view, view.isDescendant(of: endIncidentContainerView) {
            return false
        }
        return true
    }
    
    
}
