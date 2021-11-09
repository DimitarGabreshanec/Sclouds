//
//  DispatchGoingLiveViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchGoingLiveViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var liveButton: UIButton!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Live"
        
        
        liveButton.roundRadius()
        prepareNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLiveMessageSegue" {
            let vc = segue.destination as! DispatchMessageViewController
            vc.isLiveMessage = true
        }
    }
    
    // MARK: - Methods
    
    @objc func backbarButtonAction() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    let homeVC = vc as! DispatchHomeViewController
                    
                    navigationController?.popToViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func prepareNavigationBar() {
        createBackBarButton()
        
        let rightButton = UIButton()
        rightButton.titleLabel?.font = UIFont.circularStdMedium(size: 14)
        rightButton.setTitle(" 372/2084", for: .normal)
        rightButton.setTitleColor(UIColor.blackTextColor(), for: .normal)
        rightButton.contentHorizontalAlignment = .right
        rightButton.setImage(UIImage(named: "Profile"), for: .normal)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    fileprivate func createBackBarButton() {
        navigationItem.leftItemsSupplementBackButton = false
        
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.tintColor = UIColor.mainColor()
        backButton.addTarget(self, action: #selector(backbarButtonAction), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
    // MARK: - IBAction

    @IBAction func endButtonAction(_ sender: UIButton) {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    navigationController?.popToViewController(vc as! DispatchHomeViewController, animated: false)
                }
            }
        }
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func liveButtonActions(_ sender: UIButton) {
    }
    
    @IBAction func muteButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
    }
}
