//
//  FacialRecognitionViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/23/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class FacialRecognitionViewController: UIViewController {
     
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var backgrounImageView: UIImageView!
    
    var isEngageStart = false
    var isFromHome = false
    var isDispatchSOSFacil = false
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facial Recognition"
        createBackBarButtonItem()
        changeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    
    // MARK: - ACTIONS
    
    private func changeUI() {
        resumeButton.setImage(UIImage(named: isFromHome ? "stop-dispatch" : "resume-dispatch"), for: .normal)
        stopButton.setImage(UIImage(named: isFromHome ? "police-dispatch" : "stop-dispatch"), for: .normal)
        resumeLabel.text = isFromHome ? "Stop" : "Resume"
        stopLabel.text = isFromHome ? "Escalate" : "Stop"
        backgrounImageView.image = UIImage(named: isFromHome ? "facial-home" : "face-background")
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func resumeButtonAction(_ sender: UIButton) {
        if isFromHome {
            backDispatchHomePage()
        } else {
            if isEngageStart || isDispatchSOSFacil {
                let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentVC") as! OngoingIncidentViewController
                ongoingIncidentVC.isDispatchHome = true
                self.navigationController?.pushViewController(ongoingIncidentVC, animated: false)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func runButtonAction(_ sender: UIButton) {
        let scanResultsVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "ScanResultsVC") as! ScanResultsViewController
        scanResultsVC.isFromHome = isFromHome
        scanResultsVC.isDispatchSOSFacil = isDispatchSOSFacil
        navigationController?.pushViewController(scanResultsVC, animated: true)
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        if isFromHome {
            // Handle `escalate` button
            let dispatchSOSResponderVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchSOSResponderVC") as! DispatchSOSResponderViewController
            navigationController?.pushViewController(dispatchSOSResponderVC, animated: true)
        } else {
            // Handle `stop` button
        }
    }
    
    
    
}
