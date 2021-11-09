//
//  EngageStartViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class EngageStartViewController: UIViewController {
     
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var idButton: UIButton!
    @IBOutlet weak var dispatchButton: UIButton!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var dispatchLabel: UILabel!
    @IBOutlet weak var escalateLabel: UILabel!
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.roundRadius()
        prepareNavigation()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func notificationButtonAction() {
        print("NOTIFICATION BUTTON ACTION PRESSED")
    }
    
    @objc func emergencyNumberButtonAction() {
        print("EMERGENCY NUMBER BUTTON ACTION PRESSED")
    }
    
    private func prepareNavigation() {
        navigationItem.hidesBackButton = true
        let logo = UIImageView(frame: CGRect(x: 3, y: 0, width: 160, height: 36))
        logo.clipsToBounds = false
        logo.image = UIImage(named: "home-logo")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 41))
        view.clipsToBounds = false
        view.addSubview(logo)
        // Set left navigationItem
        let logoBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItems = [logoBarButtonItem]
        // Set right navigationItem
        let notificationBarButtonItem = UIBarButtonItem(image: UIImage(named: "homeNotification"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(notificationButtonAction))
        notificationBarButtonItem.imageInsets.top = -5
        let emergencyBarButtonItem = UIBarButtonItem(image: UIImage(named: "911-icon")?.withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: self,
                                                action: #selector(emergencyNumberButtonAction))
        emergencyBarButtonItem.imageInsets.top = -5
        navigationItem.rightBarButtonItems = [emergencyBarButtonItem, notificationBarButtonItem]
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        backDispatchHomePage()
    }
    
    @IBAction func idButtonAction(_ sender: Any) {
        let facialRecognitionVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "FacialRecognitionVC") as! FacialRecognitionViewController
        facialRecognitionVC.isEngageStart = true
        facialRecognitionVC.isDispatchSOSFacil = true
        navigationController?.pushViewController(facialRecognitionVC, animated: true)
    }
    
    @IBAction func dispatchButtonAction(_ sender: Any) {
        let dispatchSOSResponderVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchSOSResponderVC") as! DispatchSOSResponderViewController
        navigationController?.pushViewController(dispatchSOSResponderVC, animated: true)
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        print("MESSAGE BUTTON ACTION PRESSED")
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        print("CAMERA BUTTON ACTION PRESSED")
    }
    
    @IBAction func micButtonAction(_ sender: Any) {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    let homeVC = vc as! DispatchHomeViewController
                    homeVC.isPopToArView = true
                    navigationController?.popToViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    
    
}
