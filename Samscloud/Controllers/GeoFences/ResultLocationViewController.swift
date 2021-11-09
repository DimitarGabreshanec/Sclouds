//
//  ResultLocationViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ResultLocationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var locationButton: UIButton!
    
    // MARK: - Variables
    var isDispatchRadius = false
    var isDispatchLocation = false
    var titleText = ""
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isDispatchRadius ? "Message Radius" : titleText
        mapImageView.image = UIImage(named: isDispatchRadius || isDispatchLocation ? "MessageRadius" : "big-map")
        locationButton.isHidden = !isDispatchRadius
        
        prepareNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    @objc func doneButtonAction() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is CreateGeoFenceViewController {
                    navigationController?.popToViewController(vc as! CreateGeoFenceViewController, animated: true)
                }
                
                if vc is DispatchCreateMessageViewController {
                    navigationController?.popToViewController(vc as! DispatchCreateMessageViewController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Private method
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let doneButton = creatCustomBarButton(title: "Done")
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        let doneBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func radiusSliderValueChanged(_ sender: UISlider) {
    }
}
