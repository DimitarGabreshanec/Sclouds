//
//  BaseViewController.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 09/08/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @objc func clickOnBack() {
        if navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func prepareNavigation() {
        //createBackBarButtonItem()
        navigationItem.leftItemsSupplementBackButton = false
        
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.tintColor = UIColor.mainColor()
        backButton.addTarget(self, action: #selector(clickOnBack), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
}
