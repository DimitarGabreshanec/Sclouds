//
//  DispatchIncidentLocationViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchIncidentLocationViewController: UIViewController {
 
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Incident Location"
        createBackBarButtonItem()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    
    // MARK: - IBACTIONS

    @IBAction func declineButtonAction(_ sender: UIButton) {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    navigationController?.popToViewController(vc as! DispatchHomeViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        // Handle `accept` button
        let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentVC") as! OngoingIncidentViewController
        ongoingIncidentVC.isDispatchHome = true
        self.navigationController?.pushViewController(ongoingIncidentVC, animated: false)
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        print("LOCATION BUTTON ACTION PRESSED")
    }
    
    
    
    
    
}
