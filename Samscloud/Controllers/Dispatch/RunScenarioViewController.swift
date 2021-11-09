//
//  RunScenarioViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class RunScenarioViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var activeShooterButton: UIButton!
    @IBOutlet weak var violenveButton: UIButton!
    @IBOutlet weak var medicalButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var bottomResponderViewConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Run Scenario"
        bottomResponderViewConstraint.constant = -containerView.frame.height
        prepareNavigationBar()
        shadowView()
        radiusView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomResponderViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    
    // MARK: - ACTIONS
    
    private func shadowView() {
        containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 2, blur: 30, spread: 0)
    }
    
    private func radiusView() {
        containerView.layer.cornerRadius = 30
        activeShooterButton.roundRadius()
        violenveButton.roundRadius()
        medicalButton.roundRadius()
        fireButton.roundRadius()
        otherButton.roundRadius()
    }
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        let rightButton = UIButton()
        rightButton.titleLabel?.font = UIFont.circularStdMedium(size: 14)
        rightButton.setTitle("  Touch ID", for: .normal)
        rightButton.setTitleColor(UIColor.mainColor(), for: .normal)
        rightButton.contentHorizontalAlignment = .right
        rightButton.setImage(UIImage(named: "Touch-ID"), for: .normal)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func violenceButtonAction(_ sender: UIButton) {
        let hideDevicePasscodeVC = StoryboardManager.menuStoryBoard().getController(identifier: "HideDevicePasscodeVC") as! HideDevicePasscodeViewController
        hideDevicePasscodeVC.isDispatchPassCode = true
        navigationController?.pushViewController(hideDevicePasscodeVC, animated: true)
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        bottomResponderViewConstraint.constant = -containerView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { (finished) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - GESTURES / TOUCHES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }  else {
            return true
        }
    }
    
    
}
