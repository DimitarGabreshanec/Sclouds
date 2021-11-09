//
//  ARViewViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/23/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ARViewViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userNameImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "AR View"
        userNameImageView.roundRadius()
        userNameImageView.bordered(withColor: UIColor.white, width: 2)
        
        createBackBarButtonItem()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - IBAction
    
    @IBAction func searchMicButtonAction(_ sender: UIButton) {
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
