//
//  GroupConversationViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class GroupConversationViewController: UIViewController, UICollectionViewDataSource {
    
    var users = [String]()
    var createBarButton: UIBarButtonItem!
    var createButton: UIButton!
    var messageBarButton: UIBarButtonItem!
    var menuBarButton: UIBarButtonItem!
    var isChirpGroup = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var countMemberLabel: UILabel!
    @IBOutlet weak var createGroupCompleteView: UIView!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isChirpGroup ? "Name Group" : "Group Conversation"
        prepareNavigationBar()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func createButtonAction() {
        if isChirpGroup {
            if let controllers = navigationController?.viewControllers {
                controllers.forEach { (vc) in
                    if vc is GeoFencesViewController {
                        navigationController?.popToViewController(vc as! GeoFencesViewController, animated: true)
                    }
                }
            }
        } else {
            navigationItem.leftBarButtonItem = messageBarButton
            navigationItem.rightBarButtonItem = menuBarButton
            noteLabel.text = "Jeffery created a group “\(groupNameTextField.text!)”"
            createGroupCompleteView.isHidden = false
            countMemberLabel.text = "\(users.count) members"
            countMemberLabel.isHidden = false
            title = "Top Buddies"
            view.endEditing(true)
        }
    }
    
    @objc func messageButtonAction() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is TabBarViewController {
                    let tabBarVC = vc as! TabBarViewController
                    tabBarVC.defaultIndex = 1
                    navigationController?.popToViewController(vc as! TabBarViewController, animated: true)
                }
            }
        }
    }
    
    @objc func menuButtonAction() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                let isMenuExist = controllers.contains(where: { $0 is MenuViewController })
                if isMenuExist {
                    if vc is MenuViewController {
                        navigationController?.popToViewController(vc as! MenuViewController, animated: true)
                    }
                }
                else {
                    if vc is HomeViewController {
                        let homeVC = vc as! HomeViewController
                        homeVC.isShowMenuPage = true
                        navigationController?.popToViewController(vc as! HomeViewController, animated: false)
                    }
                }
            }
        }
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        // Add barButtonItem for rightBarButtonItem
        // Create `create` button
        createButton = creatCustomBarButton(title: "Create")
        createButton.activatedOfNavigationBar(false)
        createButton.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        createBarButton = UIBarButtonItem(customView: createButton)
        self.navigationItem.rightBarButtonItem = createBarButton
        // Create `message` button
        let messageButton = creatCustomBarButton(title: "Messages")
        messageButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        messageBarButton = UIBarButtonItem(customView: messageButton)
        // Create `menu` button
        let menuButton = creatCustomBarButton(title: "Menu")
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        menuBarButton = UIBarButtonItem(customView: menuButton)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let text = groupNameTextField.text {
            createButton.activatedOfNavigationBar(!text.isEmpty)
        }
    }
    
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserResponderCollectionViewCell.groupIdentifier, for: indexPath) as! UserResponderCollectionViewCell
        cell.titleLabel.text = users[indexPath.row]
        return cell
    }
    
    
}
