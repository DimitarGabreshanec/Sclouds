//
//  ReportTypesViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/20/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class ReportTypesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var reportTypes: [ReportType] = []
    var selectedReportType: ReportType?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareNavigation()
        self.getReportTypes()
    }
    
    func getReportTypes() {
        SwiftLoader.show(animated: true)
        GetReportTypesService().getReportTypes(success: { (reportTypes) in
            SwiftLoader.hide()
            self.reportTypes = reportTypes
            self.tableView.reloadData()
        }, failure: { error in
            SwiftLoader.hide()
            self.showAlertWithActions("Error", message: "Oops! Something went wrong.", actions: nil)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportType = self.reportTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTypeCell", for: indexPath) as! ReportTypeCell
        cell.reportTypeLabel.text = reportType.name
        if self.selectedReportType?.id == reportType.id {
            cell.checkImageView.image = UIImage(named: "checked")
        } else {
            cell.checkImageView.image = UIImage(named: "check")
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportType = self.reportTypes[indexPath.row]
        self.selectedReportType = reportType
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func saveButtonAction() {
        self.performSegue(withIdentifier: "unwindToReportDetailsTable", sender: nil)
    }
    
    // MARK: - Private
    
    private func prepareNavigation() {
        self.title = "Report Types"
        self.createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let saveButton = creatCustomBarButton(title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }

}
