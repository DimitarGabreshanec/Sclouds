//
//  AddGeoFenceViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AddGeoFenceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var geofenceNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchImageViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Private var/let
    private let titles = ["PARENTS", "RELATIVES", "FRIENDS"]
    private let names = [["Jorge", "Adeline"], ["Grace", "Leon", "Henrietta"], ["Derrick"]]
    private var assignButton: UIButton!
    private var chooseUsers = [String]()
    
    // MARK: - Variables
    var assignButtonAction: (([String]) -> Void)?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Geo-Fence"
        
        prepareNavigationBar()
        prepareTableView()
        attributeText()
    }
    
    // MARK: - Methods
    
    @objc func assignBarButtonAction() {
        navigationController?.popViewController(animated: true, completion: {
            self.assignButtonAction?(self.chooseUsers)
        })
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        // Add rightBarButtonItem
        assignButton = creatCustomBarButton(title: "Assign")
        assignButton.addTarget(self, action: #selector(assignBarButtonAction), for: .touchUpInside)
        assignButton.activatedOfNavigationBar(false)
        
        let assignBarButtonItem = UIBarButtonItem(customView: assignButton)
        
        navigationItem.rightBarButtonItem = assignBarButtonItem
    }
    
    private func prepareTableView() {
        let nib = UINib(nibName: AddGeoFenceTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AddGeoFenceTableViewCell.identifier)
    }
    
    private func attributeText() {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "939393")
        geofenceNameTextField.attributedPlaceholder = NSAttributedString(string: "Who would you like to assign to?", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        geofenceNameTextField.font = font
        geofenceNameTextField.textColor = placeholderColor
    }
    
    private func updateUITextField() {
        geofenceNameTextField.text = chooseUsers.map({ $0 }).joined(separator: ", ")
        searchImageView.isHidden = chooseUsers.count != 0
        searchImageViewLeadingConstraint.constant = chooseUsers.count == 0 ? 20 : 5
        assignButton.activatedOfNavigationBar(chooseUsers.count > 0)
    }
}

// MARK: - UITableViewDataSource

extension AddGeoFenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddGeoFenceTableViewCell.identifier, for: indexPath) as! AddGeoFenceTableViewCell
        let name = names[indexPath.section][indexPath.row]
        let itemsInSection = names[indexPath.section].count
        cell.nameLabel.text = name
        cell.noAddress(isNoAddress: indexPath.section == 1 && indexPath.row == 2)
        cell.bottomView.isHidden = itemsInSection == 1 || indexPath.row == itemsInSection - 1
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddGeoFenceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = names[indexPath.section][indexPath.row]
        chooseUsers.append(name)
        updateUITextField()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let name = names[indexPath.section][indexPath.row]
        if let index = chooseUsers.firstIndex(where: { $0 == name }) {
            chooseUsers.remove(at: index)
        }
        updateUITextField()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView: HeaderAddFamilyView = HeaderAddFamilyView.fromNib()
        headerSectionView.topView.isHidden = section == 0
        headerSectionView.relationshipLabel.text = titles[section]
        headerSectionView.relationshipLabel.font = UIFont.circularStdMedium(size: 13)
        return headerSectionView
    }
}
