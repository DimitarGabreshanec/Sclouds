//
//  RemoveContactViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class RemoveContactViewController: UIViewController {
    
    var removeContactAction:(() -> Void)?
    var name = ""
    
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        nameLabel.text = name
        pendingButton.roundRadius()
        prepareNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
    }
    
    
    // MARK: - ACTIONS
    
    @objc func removeBarButtonAction() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert in
            self.navigationController?.popViewController(animated: true, completion: {
                self.removeContactAction?()
            })
        })
        let message = "This action will delete thie contact\nfrom your emergency list."
        self.showAlertWithActions("CONFIRM REMOVAL",
                                  message: message,
                                  actions: [cancelAction, okAction])
    }
    
    
    // MARK: - PRIVATE METHODS
  
    private func prepareNavigation() {
       createBackBarButtonItem()
        // Set right navigationItem
        let addBarButtonItem = UIBarButtonItem(title: "Remove",
                                               style: .plain,
                                               target: self,
                                               action: #selector(removeBarButtonAction))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pendingButtonAction(_ sender: UIButton) {
        print("PRESSED REMOVE CONTACT ACTION")
    }
    
}
