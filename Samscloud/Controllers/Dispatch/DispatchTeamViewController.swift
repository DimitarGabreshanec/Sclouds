//
//  DispatchTeamViewController.swift
//  Samscloud
//
//  Created by An Phan on 3/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchTeamViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let titles = ["ADMINISTRATORS ", "SECURTIY TEAM", "TEACHERS"]
    let names = [["Jorge", "Adeline"], ["Grace", "Leon", "Henrietta"], ["Derrick", "Johnson", "Bettie"]]
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"

        prepareTableView()
        prepareNavigationBar()
    }
    
    // MARK: - Methods
    
    @objc func addButtonAction() {
        let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
        newMessageVC.isAddMember = true
        
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareTableView() {
        let nib = UINib(nibName: GroupTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: GroupTableViewCell.identifier)
    }
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        let addButton = creatCustomBarButton(title: "Add")
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func searchGroupButtonAction(_ sender: UIButton) {
    }
}

// MARK: - UITableViewDataSource

extension DispatchTeamViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
        let name = names[indexPath.section][indexPath.row]
        let itemsInSection = names[indexPath.section].count
        cell.userNameLabel.text = name
        
        cell.renderUI(isRequest: indexPath.section == 1 && indexPath.row == 2)
        cell.bottomView.isHidden = itemsInSection == 1 || indexPath.row == itemsInSection - 1
        if indexPath.section == 2 && indexPath.row != 0 {
            cell.renderPendingUI()
        }
        
        // Handle `message` button
        cell.messageButtonAction = {
            let messageChatVC = StoryboardManager.contactStoryBoard().getController(identifier: "MessageChatVC") as! MessageChatViewController
            messageChatVC.titleText = name
            messageChatVC.isNewMessage = true
            
            messageChatVC.newMessageButtonAction = {
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 1
                
                self.navigationController?.pushViewController(mainTabBarVC, animated: true)
            }
            
            self.navigationController?.pushViewController(messageChatVC, animated: true)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DispatchTeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = names[indexPath.section][indexPath.row]
        let contactProfileVC = StoryboardManager.contactStoryBoard().getController(identifier: "ContactProfileVC") as! ContactProfileViewController
        contactProfileVC.userName = name
        contactProfileVC.isFromTeamContact = true
        
        navigationController?.pushViewController(contactProfileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white
        
        // Create top line view
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        topView.backgroundColor = UIColor(hexString: "d3d3d3")
        topView.isHidden = section == 0
        
        // Create label
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 16, width: tableView.frame.width - 40, height: 16))
        headerLabel.textColor = UIColor(hexString: "939393")
        headerLabel.font = UIFont.circularStdMedium(size: 13)
        headerLabel.text = titles[section]
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(topView)
        
        return headerView
    }
}
