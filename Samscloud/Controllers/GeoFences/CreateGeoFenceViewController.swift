//
//  CreateGeoFenceViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class CreateGeoFenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var submitButton: UIButton!
    var contacts = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var managers = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var titles = ["GROUP", "ORGANIZER"]
    var titleString = ""
    var isFromMenu = false
    var submitButtonAction: (() -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchLocationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addMoreLocation: UIButton!
    @IBOutlet weak var bigAddMoreLocationView: UIView!
    @IBOutlet weak var smalAddMoreLineView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var bigTimeView: UIView!
    @IBOutlet weak var timeLineView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var addMoreLocationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var autoCheckInHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromViewTrailingConstraint: NSLayoutConstraint!
    
 
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleString
        prepareTableView()
        prepareNavigation()
        attributeText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set dynamic headerTableView height
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var tmpFrame = headerView.frame
            // Comparison necessary to avoid infinite loop
            if height != tmpFrame.size.height {
                tmpFrame.size.height = height
                headerView.frame = tmpFrame
                tableView.tableHeaderView = headerView
            }
        }
    }

    
    // MARK: - ACTIONS
    
    @objc func submitBarButtonAction() {
        if isFromMenu {
            navigationController?.popViewController(animated: false, completion: {
                self.submitButtonAction?()
            })
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - ACTIONS
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        // Add barButtonItem for rightBarButton
        submitButton = creatCustomBarButton(title: "Submit")
        submitButton.addTarget(self, action: #selector(submitBarButtonAction), for: .touchUpInside)
        submitButton.activatedOfNavigationBar(false)
        let submitBarButtonItem = UIBarButtonItem(customView: submitButton)
        self.navigationItem.rightBarButtonItem = submitBarButtonItem
    }
    
    private func attributeString(string: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor(hexString: "d3d3d3")
        let attributeString = NSAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font,
                                                              NSAttributedString.Key.foregroundColor: placeholderColor
                                                              ])
        return attributeString
    }
    
    private func attributeText() {
        let font = UIFont.circularStdBook(size: 16)
        nameTextField.attributedPlaceholder = attributeString(string: "Title")
        searchLocationTextField.attributedPlaceholder = attributeString(string: "Search college or mall")
        fromTextField.attributedPlaceholder = attributeString(string: "Add time")
        toTextField.attributedPlaceholder = attributeString(string: "Add time")
        nameTextField.font = font
        nameTextField.textColor = UIColor.blackTextColor()
        searchLocationTextField.font = font
        searchLocationTextField.textColor = UIColor.blackTextColor()
        fromTextField.font = font
        fromTextField.textColor = UIColor.blackTextColor()
        toTextField.font = font
        toTextField.textColor = UIColor.blackTextColor()
    }
    
    private func showHideAddMoreLocation(isShow: Bool) {
        bigAddMoreLocationView.isHidden = !isShow
        addMoreLocation.isHidden = !isShow
        addMoreLocationHeightConstraint.constant = isShow ? 56 : 50
        autoCheckInHeightConstraint.constant = isShow ? 56 : 50
    }
    
    private func showHideTime(isShow: Bool) {
        bigTimeView.isHidden = isShow
        fromViewHeightConstraint.constant = isShow ? 34 : 56
        toViewHeightConstraint.constant = isShow ? 34 : 56
        rightArrowImageView.isHidden = !isShow
        fromViewTrailingConstraint.constant = isShow ? 49 : 19
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let nameText = nameTextField.text,
            let fromText = fromTextField.text,
            let toText = toTextField.text {
            showHideAddMoreLocation(isShow: !nameText.isEmpty)
            showHideTime(isShow: !fromText.isEmpty && !toText.isEmpty)
            
            if !nameText.isEmpty {
                submitButton.activatedOfNavigationBar(true)
            }
        }
    }
    
    @IBAction func addMoreLocationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func searchLocationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func radiusButtonAction(_ sender: UIButton) {
        let resultLocationVC = StoryboardManager.contactStoryBoard().getController(identifier: "ResultLocationVC") as! ResultLocationViewController
        resultLocationVC.titleText = "Name Default"
        
        navigationController?.pushViewController(resultLocationVC, animated: true)
    }
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contacts.count == 0 ? 1 : contacts.count + 1
        } else {
            return managers.count == 0 ? 1 : managers.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if contacts.count == 0 || indexPath.row == contacts.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateGeoFenceTableViewCell.assignIdentifier, for: indexPath) as! CreateGeoFenceTableViewCell
                cell.swipeGesture.isEnabled = false
                cell.assignContactButton.setTitle("Assign to contact", for: .normal)
                // Handle `assign` button
                cell.assignContactButtonAction = {
                    let addGeoFenceVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddGeoFenceVC") as! AddGeoFenceViewController
                    // Handle `add geofence` button
                    addGeoFenceVC.assignButtonAction = { chooseContacts in
                        chooseContacts.forEach({ (contact) in
                            let isExistUser = self.contacts.contains(where: { $0 == contact })
                            if !isExistUser {
                                self.contacts.append(contact)
                            }
                        })
                    }
                    self.navigationController?.pushViewController(addGeoFenceVC, animated: true)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateGeoFenceTableViewCell.identifier, for: indexPath) as! CreateGeoFenceTableViewCell
                let contact = contacts[indexPath.row]
                cell.swipeGesture.isEnabled = true
                cell.userNameLabel.text = contact
                // Handle `swipe` right
                cell.handleSwipeAction = {
                    cell.trailingDeleteButtonConstraint.constant = 0
                    cell.leadingUserImageConstraint.constant = -cell.deleteButton.frame.width
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.view.layoutIfNeeded()
                                    self.view.setNeedsLayout()
                    })
                }
                // Handle `delete` button
                cell.deleteButtonAction = {
                    cell.trailingDeleteButtonConstraint.constant = -cell.deleteButton.frame.width
                    cell.leadingUserImageConstraint.constant = 13
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.view.layoutIfNeeded()
                                    self.view.setNeedsLayout()
                    }, completion: { (finished) in
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({ [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.tableView.reloadData()
                        })
                        self.tableView.beginUpdates()
                        if self.contacts.count > 0 {
                            self.contacts.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .none)
                        }
                        self.tableView.endUpdates()
                        CATransaction.commit()
                    })
                }
                // Handle `hideDelete` button
                cell.hideDeleteButtonAction = {
                    cell.trailingDeleteButtonConstraint.constant = -cell.deleteButton.frame.width
                    cell.leadingUserImageConstraint.constant = 13
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        self.view.setNeedsLayout()
                    })
                }
                return cell
            }
        } else {
            if managers.count == 0 || indexPath.row == managers.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateGeoFenceTableViewCell.assignIdentifier, for: indexPath) as! CreateGeoFenceTableViewCell
                cell.swipeGesture.isEnabled = false
                cell.assignContactButton.setTitle("Add a manager", for: .normal)
                // Handle `assign` button
                cell.assignContactButtonAction = {
                    let addGeoFenceVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddGeoFenceVC") as! AddGeoFenceViewController
                    // Handle `add geofence` button
                    addGeoFenceVC.assignButtonAction = { chooseManagers in
                        chooseManagers.forEach({ (contact) in
                            let isExistUser = self.managers.contains(where: { $0 == contact })
                            if !isExistUser {
                                self.managers.append(contact)
                            }
                        })
                    }
                    self.navigationController?.pushViewController(addGeoFenceVC, animated: true)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CreateGeoFenceTableViewCell.identifier, for: indexPath) as! CreateGeoFenceTableViewCell
                let manager = managers[indexPath.row]
                cell.swipeGesture.isEnabled = true
                cell.userNameLabel.text = manager
                // Handle `swipe` right
                cell.handleSwipeAction = {
                    cell.trailingDeleteButtonConstraint.constant = 0
                    cell.leadingUserImageConstraint.constant = -cell.deleteButton.frame.width
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.view.layoutIfNeeded()
                                    self.view.setNeedsLayout()
                    })
                }
                // Handle `delete` button
                cell.deleteButtonAction = {
                    cell.trailingDeleteButtonConstraint.constant = -cell.deleteButton.frame.width
                    cell.leadingUserImageConstraint.constant = 13
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.view.layoutIfNeeded()
                                    self.view.setNeedsLayout()
                    }, completion: { (finished) in
                        CATransaction.begin()
                        CATransaction.setCompletionBlock({ [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.tableView.reloadData()
                        })
                        self.tableView.beginUpdates()
                        if self.managers.count > 0 {
                            self.managers.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .none)
                        }
                        self.tableView.endUpdates()
                        CATransaction.commit()
                    })
                }
                // Handle `hideDelete` button
                cell.hideDeleteButtonAction = {
                    cell.trailingDeleteButtonConstraint.constant = -cell.deleteButton.frame.width
                    cell.leadingUserImageConstraint.constant = 13
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                        self.view.setNeedsLayout()
                    })
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = UIColor(hexString: "F4F4F4")
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 27, width: view.frame.width - 40, height: 16))
        titleLabel.text = titles[section]
        titleLabel.textColor = UIColor(hexString: "939393")
        titleLabel.font = UIFont.circularStdBook(size: 13)
        view.addSubview(titleLabel)
        return view
    }
    
    
    
}

