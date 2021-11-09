//
//  DispatchIncidentDetailViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchIncidentDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var declineBigView: UIView!
    @IBOutlet weak var declineSmallView: UIView!
    @IBOutlet weak var declineLabel: UILabel!
    @IBOutlet weak var acceptBigView: UIView!
    @IBOutlet weak var acceptSmallView: UIView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var availableResponderLabel: UILabel!
    @IBOutlet weak var showNumberStudentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var linkedIncidentsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var bottomTableHeaderView: UIView!
    @IBOutlet weak var descriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    var isMessageDetail = false
    var userNames = ["Grace Jones", "Leon Little", "Eleanor Roseveltt"]
    
    // MARK: - Private var/let
    private let spacingCollectionView: CGFloat = 0
    private var collectionViewLayout: LGHorizontalLeftFlowLayout!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = isMessageDetail ? "Message Details" : "Incident Details"
        
        // Prepare collectionView
        let height = collectionView.frame.height
        let witdh = (height * 9.7) / 10
        self.collectionViewLayout = LGHorizontalLeftFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: witdh, height: height), minimumLineSpacing: 8)
        collectionViewLeadingConstraint.constant = -((view.frame.width / 2) + ( UIScreen.main.bounds.width > 375 ? 40 : 26))
        
        createBackBarButtonItem()
        prepareUI()
        renderUIWithMessage()
        prepareTableView()
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
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - Private methods
    
    private func prepareUI() {
        locationButton.roundRadius()
        locationButton.bordered(withColor: UIColor.mainColor(), width: 1)
        declineBigView.roundRadius()
        declineBigView.bordered(withColor: UIColor(hexString: "e7e7e7").withAlphaComponent(0.4), width: 1)
        declineSmallView.roundRadius()
        acceptBigView.roundRadius()
        acceptBigView.bordered(withColor: UIColor(hexString: "e7e7e7").withAlphaComponent(0.4), width: 1)
        acceptSmallView.roundRadius()
    }
    
    private func renderUIWithMessage() {
        linkedIncidentsLabel.text = isMessageDetail ? "Message:" : "Linked Incidents"
        descriptionLabel.text = isMessageDetail ? "The center of the roof is leaking on the 3rd floor. The entire floor is soaked." : "Showing 3 students in your proximity"
        bottomTableHeaderView.isHidden = !isMessageDetail
        descriptionBottomConstraint.constant = isMessageDetail ? 20 : 0
        videoLabel.text = isMessageDetail ? "Video | Photos" : "Video Feeds"
        declineLabel.text = isMessageDetail ? "Cancel" : "Decline"
        acceptLabel.text = isMessageDetail ? "Send" : "Accept"
        if isMessageDetail {
            tableView.tableFooterView = UIView()
        }
    }
    
    private func prepareTableView() {
        // Prepare tableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let nib = UINib(nibName: MessageDetailTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MessageDetailTableViewCell.identifier)
    }
    
    // MARK: - IBAction
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    navigationController?.popToViewController(vc as! DispatchHomeViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        if isMessageDetail {
            // Handle `send` button
            if let controllers = navigationController?.viewControllers {
                controllers.forEach { (vc) in
                    if vc is DispatchHomeViewController {
                        navigationController?.popToViewController(vc as! DispatchHomeViewController, animated: true)
                    }
                }
            }
        }
        else {
            // Handle `accept` button
            let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentVC") as! OngoingIncidentViewController
            ongoingIncidentVC.isDispatchHome = true
            
            self.navigationController?.pushViewController(ongoingIncidentVC, animated: false)
        }
    }
}

// MARK: - comment

extension DispatchIncidentDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isMessageDetail {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageDetailTableViewCell.identifier, for: indexPath) as! MessageDetailTableViewCell
            cell.renderUI(indexPath: indexPath)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DispatchIncidentDetailTableViewCell.identifier, for: indexPath) as! DispatchIncidentDetailTableViewCell
            cell.userNameLabel.text = userNames[indexPath.row]
            cell.bottomView.isHidden = userNames.count == 1 || indexPath.row == userNames.count - 1
            
            // Handle `message` button
            cell.messageButtonAction = {
                let chatNC = StoryboardManager.homeStoryBoard().getController(identifier: "ChatNC") as! UINavigationController
                chatNC.modalPresentationStyle = .overCurrentContext
                
                let chatVC = chatNC.topViewController as! ChatViewController
                chatVC.isIncidentDetail = true
                // Handle `end` button
                chatVC.endButtonAction = {
                    let activeIncidentVC = StoryboardManager.homeStoryBoard().getController(identifier: "ActiveIncidentVC") as! ActiveIncidentViewController
                    activeIncidentVC.modalPresentationStyle = .overCurrentContext
                    
                    // Handle `continue` button
                    activeIncidentVC.continueButtonAction = {
                        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                        mainTabBarVC.defaultIndex = 2
                        
                        self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                    }
                    
                    self.present(activeIncidentVC, animated: false, completion: nil)
                }
                
                self.present(chatNC, animated: false, completion: nil)
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DispatchIncidentDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DispatchIncidentDetailCollectionViewCell.identifier, for: indexPath) as! DispatchIncidentDetailCollectionViewCell
        
        return cell
    }
}

