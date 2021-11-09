//
//  DispatchSelectGroupViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchSelectGroupViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lastRefreshLabel: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private var/let
    var nextButton: UIButton!
    
    // MARK: - Variables
    let titles = ["ADMINISTRATOR", "PARENTS", "STUDENTS"]
    let names = [["Administrator Local", "District Clerk"], ["PTA", "Watch Groups", "All"], ["Patrol"]]
    var chooseUsers = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Group"
        
        prepareNavigationBar()
        prepareTableView()
        translucentNavigationBar()
    }
    
    // MARK: - Methods
    
    @objc func nextButtonAction() {
        let searchLocationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchLocationVC") as! SearchLocationViewController
        searchLocationVC.isDispatchLocation = true
        
        navigationController?.pushViewController(searchLocationVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        nextButton = creatCustomBarButton(title: "Next")
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        nextButton.activatedOfNavigationBar(false)
        
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)
        navigationItem.rightBarButtonItem = nextBarButtonItem
    }
    
    private func prepareTableView() {
        let nib = UINib(nibName: SelectItemTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SelectItemTableViewCell.identifier)
    }
    
    private func selectGroup(indexPath: IndexPath) {
        let name = names[indexPath.section][indexPath.row]
        let isExistName = chooseUsers.contains(where: { $0 == name })
        if isExistName {
            if let index = chooseUsers.firstIndex(where: { $0 == name }) {
                chooseUsers.remove(at: index)
            }
        }
        else {
            chooseUsers.append(name)
        }
        
        groupTextField.text = chooseUsers.map({ $0 }).joined(separator: ", ")
        nextButton.activatedOfNavigationBar(chooseUsers.count > 0)
    }
    
    // MARK: - IBActions
    
    @IBAction func groupButtonAction(_ sender: UIButton) {
        groupTextField.becomeFirstResponder()
    }
    
    @IBAction func selectAllGroupView(_ sender: UIButton) {
        chooseUsers = names.flatMap({ $0 })
        groupTextField.text = chooseUsers.map({ $0 }).joined(separator: ", ")
        nextButton.activatedOfNavigationBar(chooseUsers.count > 0)
    }
}

// MARK: - UITableViewDataSource

extension DispatchSelectGroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectItemTableViewCell.identifier, for: indexPath) as! SelectItemTableViewCell
        let name = names[indexPath.section][indexPath.row]
        let itemsInSection = names[indexPath.section].count
        
        // Render data
        cell.userNameLabel.text = name
        cell.bottomView.isHidden = itemsInSection == 1 || indexPath.row == itemsInSection - 1
        
        // Check group
        let isExistName = chooseUsers.contains(where: { $0 == name })
        let checkImage = isExistName ? "checked" : "check"
        cell.checkButton.setImage(UIImage(named: checkImage), for: .normal)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DispatchSelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectGroup(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectGroup(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = .white
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        topView.backgroundColor = UIColor(hexString: "d3d3d3")
        topView.isHidden = section == 0
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 27, width: view.frame.width - 40, height: 16))
        titleLabel.text = titles[section]
        titleLabel.textColor = UIColor(hexString: "939393")
        titleLabel.font = UIFont.circularStdBook(size: 13)
        view.addSubview(titleLabel)
        view.addSubview(topView)
        
        return view
    }
}
