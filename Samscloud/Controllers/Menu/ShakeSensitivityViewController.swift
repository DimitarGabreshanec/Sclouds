//
//  ShakeSensitivityViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ShakeSensitivityViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var shakeSlider: UISlider!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shake Sensitivity"
        
        createBackBarButtonItem()
    }
    
    @IBAction func shakeSliderValueChanged(_ sender: UISlider) {
    }
    
}
