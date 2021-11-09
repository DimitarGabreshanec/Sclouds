//
//  EmergencyContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class EmergencyContactViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var userName = ""
    var profileButtonAction: (() -> Void)?
    var messageButtonAction: (() -> Void)?
    
    // Emergency contact
    @IBOutlet weak var emergencyContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bottomEmergencyViewConstraint: NSLayoutConstraint!

    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        // Current postion of emergency view
        bottomEmergencyViewConstraint.constant = -emergencyContainerView.frame.height
        // Render data
        userNameLabel.text = userName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.currentVC = self
        bottomEmergencyViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emergencyContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func hideEmergencyView(dismissCompletion: (() -> Void)?) {
        bottomEmergencyViewConstraint.constant = -emergencyContainerView.frame.height
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }, completion: { finish in
            self.dismiss(animated: false, completion: {
                dismissCompletion?()
            })
        })
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        print("CLOSE BUTTON PRESSED - EMERGENCYCONTACT_VC")
        hideEmergencyView(dismissCompletion: nil)
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        print("PROFILE BUTTON PRESSED - EMERGENCYCONTACT_VC")
        hideEmergencyView(dismissCompletion: {
            self.profileButtonAction?()
        })
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        print("MESSAGE BUTTON PRESSED - EMERGENCYCONTACT_VC")
        hideEmergencyView {
            self.messageButtonAction?()
        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        print("CALL BUTTON PRESSED - EMERGENCYCONTACT_VC")
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        print("EDIT BUTTON PRESSED - EMERGENCYCONTACT_VC")
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        print("MAIN VIEW TAPPED - EMERGENCYCONTACT_VC")
        hideEmergencyView(dismissCompletion: nil)
    }
    
    
    // MARK: - GESTURES / TOUCHES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: emergencyContainerView) {
            return false
        }
        return true
    }
    
    
    
}
