//
//  GeoFencesViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class GeoFencesViewController: UIViewController {
    
    // MARK: - IBOutlets
    // Geo-Fence
    @IBOutlet weak var segmentedContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var geoFenceTableView: UITableView!
    
    // Report
    @IBOutlet weak var reportContainerView: UIView!
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listButtonAction: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    
    // MARK: - Variables
    var isDispatchHomeChirp = false
    var isReport = false
    var geoFences = [String]()
    var filterGeoFences = [String]() {
        didSet {
            geoFenceTableView.reloadData()
        }
    }
    
    var reports = [String]() {
        didSet {
            geoFenceTableView.reloadData()
        }
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoFenceTableView.keyboardDismissMode = .onDrag
        listTitleButton.setImage(UIImage(named: "listIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        listTitleButton.tintColor = UIColor.mainColor()
        if isDispatchHomeChirp {
            title = "CHirP Groups"
            
            createBackBarButtonItem()
            prepareNavigation()
        }
        geoFences       = fetchGeoFences()
        filterGeoFences = fetchGeoFences()
        reports         = fetchReports()
        
        prepareSegmentedControl()
        attributeText()
        showReportContainerView()
    }
    
    // MARK: - Methods
    
    @objc func newButtonAction() {
        if isDispatchHomeChirp {
            let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
            newMessageVC.isChirpGroup = true
            
            self.navigationController?.pushViewController(newMessageVC, animated: true)
        }
        else {
            displayCreateFencePage(title: "Create GeoFence")
        }
        
        //performSegue(withIdentifier: "showMyOrganizationsSegue", sender: nil)
    }
    
    @objc func newReportButtonAction() {
        let reportDetailVC = StoryboardManager.reportsStoryBoard().getController(identifier: "ReportDetailVC")
        self.navigationController?.pushViewController(reportDetailVC, animated: true)
    }
    
    func showReportContainerView() {
        if isReport {
            reportContainerView.isHidden = false
            prepareNavigationWithReport()
        }
        else {
            reportContainerView.isHidden = true
            prepareNavigation()
        }
    }
    
    // MARK: - Private method
    
    private func displayCreateFencePage(title: String) {
        let createGeoFenceVC = StoryboardManager.contactStoryBoard().getController(identifier: "CreateGeoFenceVC") as! CreateGeoFenceViewController
        createGeoFenceVC.titleString = title
        
        navigationController?.pushViewController(createGeoFenceVC, animated: true)
    }
    
    private func fetchGeoFences() -> [String] {
        return ["GEO-FENCE 1", "GEO-FENCE 2", "GEO-FENCE 3"]
    }
    
    private func fetchReports() -> [String] {
        return ["Report - Active Shooter 1",
                "Report - Active Shooter 2",
                "Report - Active Shooter 3",
                "Report - Active Shooter 4",
                "Report - Active Shooter 5",
                "Report - Active Shooter 6"]
    }
    
    private func prepareNavigation() {
        // Add barButtonItem for rightBarButton
        let newButton = creatCustomBarButton(title: "New")
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        let newBarButtonItem = UIBarButtonItem(customView: newButton)
        
        if isDispatchHomeChirp {
            navigationItem.rightBarButtonItem = newBarButtonItem
        }
        else {
            self.tabBarController?.navigationItem.rightBarButtonItem = newBarButtonItem
        }
    }
    
    private func prepareNavigationWithReport() {
        // Add barButtonItem for rightBarButton
        let newButton = creatCustomBarButton(title: "New")
        newButton.addTarget(self, action: #selector(newReportButtonAction), for: .touchUpInside)
        let newBarButtonItem = UIBarButtonItem(customView: newButton)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = newBarButtonItem
    }
    
    private func prepareSegmentedControl() {
        // SegmentControl for title
        let fontAttributeNormal = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        let fontAttributeSelected  = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.removeBorder()
        segmentedControl.tintColor = UIColor.mainColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(fontAttributeNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(fontAttributeSelected, for: .selected)
        segmentedContainerView.bordered(withColor: UIColor.mainColor(), width: 1, radius: 20)
        segmentedControl.selectedSegmentIndex = 1
    }
    
    private func attributeText() {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "939393")
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Geo-Fences", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        searchTextField.font = font
        searchTextField.textColor = UIColor.blackTextColor()
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let searchText = sender.text {
            filterGeoFences = searchText.isEmpty ? geoFences : geoFences.filter({ $0.lowercased().contains(searchText.lowercased()) })
        }
    }
}

// MARK: - UITableViewDataSource

extension GeoFencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == geoFenceTableView ? filterGeoFences.count : reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == geoFenceTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: GeoFencesTableViewCell.identifier, for: indexPath) as! GeoFencesTableViewCell
            let geoFence = filterGeoFences[indexPath.row]
            cell.geoFencesNameLabel.text = geoFence
            
            // Handle `delete` button
            cell.deleteButtonAction = {
                let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { alert in
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.geoFenceTableView.reloadData()
                    })
                    
                    tableView.beginUpdates()
                    if self.filterGeoFences.count > 0 {
                        self.filterGeoFences.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .top)
                    }
                    tableView.endUpdates()
                    CATransaction.commit()
                })
                deleteAction.setValue(UIColor(hexString: "ff3b30"), forKey: "titleTextColor")
                
                // Handle `View` button
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { alert in
                    if self.isDispatchHomeChirp {
                        // Handle action when page was show from on the home chirp
                    }
                    else {
                        self.displayCreateFencePage(title: "View")
                    }
                })
                
                // Handle `Edit` button
                let editAction = UIAlertAction(title: "Edit", style: .default, handler: { alert in
                    if self.isDispatchHomeChirp {
                        // Handle action when page was show from on the home chirp
                    }
                    else {
                        self.displayCreateFencePage(title: "Edit")
                    }
                })
                
                // Handle `addContact` button
                let addContactAction = UIAlertAction(title: "Add Contacts", style: .default, handler: { alert in
                    if self.isDispatchHomeChirp {
                        // Handle action when page was show from on the home chirp
                    }
                    else {
                        let addGeoFenceVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddGeoFenceVC") as! AddGeoFenceViewController
                        
                        // Handle `add geofence` button
                        addGeoFenceVC.assignButtonAction = { chooseUsers in
                            chooseUsers.forEach({ (user) in
                                let isExistUser = self.filterGeoFences.contains(where: { $0 == user })
                                if !isExistUser {
                                    self.filterGeoFences.append(user)
                                }
                            })
                        }
                        
                        self.navigationController?.pushViewController(addGeoFenceVC, animated: true)
                    }
                })
                
                // Handle `cancel` button
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                
                self.showActionSheet(geoFence,
                                     message: nil,
                                     actions: [cancelAction, viewAction, editAction, addContactAction, deleteAction])
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            let report = reports[indexPath.row]
            cell.reportNameLabel.text = report
            
            // Handle `more` button
            cell.moreButtonAction = {
                let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { alert in
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.reportTableView.reloadData()
                    })
                    
                    tableView.beginUpdates()
                    if self.reports.count > 0 {
                        self.reports.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .top)
                    }
                    tableView.endUpdates()
                    CATransaction.commit()
                })
                deleteAction.setValue(UIColor(hexString: "ff3b30"), forKey: "titleTextColor")
                
                // Handle `cancel` button
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                self.showActionSheet(nil,
                                     message: nil,
                                     actions: [cancelAction, deleteAction])
            }
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension GeoFencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == reportTableView {
            let reportDetailVC = StoryboardManager.reportsStoryBoard().getController(identifier: "ReportDetailVC")
            navigationController?.pushViewController(reportDetailVC, animated: true)
        }
    }
}
