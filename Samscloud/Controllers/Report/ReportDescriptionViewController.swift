//
//  ReportDescriptionViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/21/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class ReportDescriptionViewController: UIViewController {
    var descriptionText: String?
    @IBOutlet var textView: BorderedTextView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    func setupView() {
        self.prepareNavigation()
        self.textView.text = self.descriptionText
    }
    
    // MARK: - Actions
    
    @objc func saveButtonAction() {
        self.descriptionText = self.textView.text
        self.performSegue(withIdentifier: "unwindToReportDetailsTable", sender: nil)
    }
    
    // MARK: - Private
    
    private func prepareNavigation() {
        self.title = "Details"
        self.createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let saveButton = creatCustomBarButton(title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }

}
