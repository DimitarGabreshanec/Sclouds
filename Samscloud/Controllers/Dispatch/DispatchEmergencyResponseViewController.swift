//
//  DispatchEmergencyResponseViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchEmergencyResponseViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: - Variables
    var hideContainerView: CGFloat = 0
    var viewButtonAction: (() -> Void)?
    var declineButtonAction: (() -> Void)?
    var acceptButtonAction: (() -> Void)?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        hideContainerView = view.frame.height / 2 + containerView.frame.height / 2
        containerViewCenterYConstraint.constant = -hideContainerView
        containerView.layer.cornerRadius = 12
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerViewCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Private methods
    
    private func dismissPage(completion: (() -> Void)?) {
        containerViewCenterYConstraint.constant = hideContainerView
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func mainViewTapped(_ sender: Any) {
        dismissPage(completion: nil)
    }
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        dismissPage {
            self.declineButtonAction?()
        }
    }
    
    @IBAction func viewButtonAction(_ sender: UIButton) {
        dismissPage {
            self.viewButtonAction?()
        }
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        dismissPage {
            self.acceptButtonAction?()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DispatchEmergencyResponseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        
        return true
    }
}
