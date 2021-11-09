//
//  ResponderViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

protocol ResponderViewControllerDelegate {
    func didChooseOption(option:String)
}

class ResponderViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var heightResponderView: CGFloat = 0
    private var maxSecond = 5
    var initialProgress:Double = 0.0
    private var timer: Timer!
    var isActiveShooter = false
    var stopButtonAction: (() -> Void)?
    var hideButtonAction: (() -> Void)?
    var violenceButtonAction: (() -> Void)?
    var stopActiveButtonAction: (() -> Void)?
    var skipActiveButtonAction: (() -> Void)?
    var skipButtonAction: (() -> Void)?
    
    var delegate:ResponderViewControllerDelegate?
    
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var stopImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var responderContainerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var activeShooterButton: UIButton!
    @IBOutlet weak var violenveButton: UIButton!
    @IBOutlet weak var medicalButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var bottomResponderViewConstraint: NSLayoutConstraint!
    
    // IBOutlet when show from active shooter button
    @IBOutlet weak var activieShooterContainerView: UIView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var policeButton: UIButton!
    @IBOutlet weak var fireDeptButton: UIButton!
    @IBOutlet weak var ambulanceButton: UIButton!
    @IBOutlet weak var activeStopButton: UIButton!
    @IBOutlet weak var activeSkipButton: UIButton!
    @IBOutlet weak var bottomActiveShooterConstraint: NSLayoutConstraint!
    @IBOutlet weak var bigView: CircleProgressView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "\(maxSecond)"
        prepareResponderContainerView()
        prepareActiveContainerView()
        if isActiveShooter {
            runTime()
        }
        
        if let address = appDelegate.addressOnly {
            locationButton.setTitle(address, for: .normal)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.currentVC = self
        if isActiveShooter {
            bottomActiveShooterConstraint.constant = 0
        } else {
            bottomResponderViewConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        responderContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        activieShooterContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func updateTime() {
        maxSecond -= 1
        initialProgress += 0.2
        bigView.setProgress(initialProgress, animated: true)
        if maxSecond == 0 {
            skipTimer()
        }
        timeLabel.text = "\(maxSecond)"
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func runTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func prepareResponderContainerView() {
        heightResponderView = responderContainerView.frame.height
        bottomResponderViewConstraint.constant = -heightResponderView
        activeShooterButton.roundRadius()
        violenveButton.roundRadius()
        medicalButton.roundRadius()
        fireButton.roundRadius()
        otherButton.roundRadius()
        skipButton.roundRadius()
    }
    
    private func prepareActiveContainerView() {
        heightResponderView = activieShooterContainerView.frame.height
        bottomResponderViewConstraint.constant = -heightResponderView
        activeStopButton.roundRadius()
        skipButton.roundRadius()
        bigView.roundRadius()
        smallView.roundRadius()
        activeSkipButton.roundRadius()
    }
    
    private func hideResponderPage(compeletion: (() -> Void)?) {
        bottomResponderViewConstraint.constant = -heightResponderView
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { (finished) in
            self.dismiss(animated: false, completion: {
                compeletion?()
            })
        }
    }
    
    private func hideActiveShooterPage(compeletion: (() -> Void)?) {
        bottomActiveShooterConstraint.constant = -heightResponderView
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { (finished) in
            self.dismiss(animated: false, completion: {
                compeletion?()
            })
        }
    }
    
    private func skipTimer() {
        hideActiveShooterPage {
            self.skipActiveButtonAction?()
        }
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        hideResponderPage(compeletion: {
            self.skipButtonAction?()
        })
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        print("STOP BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.stopButtonAction?()
        }
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        print("HIDE BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.hideButtonAction?()
        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        print("CALL BUTTON ACTION PRESSED - RESPONDER_VC")
        if let url = URL(string: "tel://911") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func activeShooterButtonAction(_ sender: UIButton) {
        print("ACTIVE SHOOTER BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.delegate?.didChooseOption(option: "ACTIVE_SHOOTER")
        }
    }
    
    @IBAction func violenceButtonAction(_ sender: UIButton) {
        print("VIOLENCE BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.delegate?.didChooseOption(option: "VIOLENCE OR THREAT")
        }
    }
    
    @IBAction func medicalButtonAction(_ sender: UIButton) {
        print("MEDICAL BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.delegate?.didChooseOption(option: "MEDICAL")
        }
    }
    
    @IBAction func fireButtonAction(_ sender: UIButton) {
        print("FIRE BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.delegate?.didChooseOption(option: "FIRE")
        }
    }
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
        print("OTHER BUTTON ACTION PRESSED - RESPONDER_VC")
        hideResponderPage {
            self.delegate?.didChooseOption(option: "OTHER")
        }
    }
    
    @IBAction func mainViewTapped(_ sender: UIButton) {
        bottomResponderViewConstraint.constant = -heightResponderView
        bottomActiveShooterConstraint.constant = -heightResponderView
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - IBOutlet when show from active shooter button
    
    @IBAction func skipActiveButtonAction(_ sender: UIButton) {
        print("SKIP BUTTON ACTION PRESSED - RESPONDER_VC")
        skipTimer()
    }
    
    @IBAction func contactButtonAction(_ sender: UIButton) {
        print("CONTACT BUTTON ACTION PRESSED - RESPONDER_VC")
        let shareAction = UIAlertAction(title: "Quick Share", style: .default, handler: { alert in
            // Doing something
        })
        let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        let message = "You can share this incident with\none of your phone contacts."
        self.showAlertWithActions("Your Contact List is Empty",
                                  message: message,
                                  actions: [notNowAction, shareAction])
    }
    
    @IBAction func policeButtonAction(_ sender: UIButton) {
        print("POLICE BUTTON ACTION PRESSED - RESPONDER_VC")
    }
    
    @IBAction func fireDeptButtonAction(_ sender: UIButton) {
        print("FIRE DEPT. BUTTON ACTION PRESSED - RESPONDER_VC")
    }
    
    @IBAction func ambulanceButtonAction(_ sender: UIButton) {
        print("AMBULENCE BUTTON ACTION PRESSED - RESPONDER_VC")
    }
    
    @IBAction func stopActiveButtonAction(_ sender: UIButton) {
        print("STOP_ACTIVE BUTTON ACTION PRESSED - RESPONDER_VC")
        hideActiveShooterPage {
            self.stopActiveButtonAction?()
        }
    }

    
    // MARK: - GESTURES / TOUCHES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: responderContainerView) {
            return false
        }
        if let view = touch.view, view.isDescendant(of: activieShooterContainerView) {
            return false
        }
        return true
    }
    
    
}
