//
//  MessageViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentSwipeIndexPath: IndexPath!
    var userMessages = ["Leon", "Grace", "Henrietta", "Jennie", "Christopher", "Logan", "Logan", "Logan"]
    var filterMessages = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var showSearchButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var leadingSearchViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSearchViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXSearchViewConstraint: NSLayoutConstraint!
    

    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchContainerView.layer.cornerRadius = 8
        groupButton.adjustsImageWhenHighlighted = false
        // Current data
        filterMessages = userMessages
        prepareTableView()
        prepareTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        prepareNavigationBar()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func newMessageAction() {
        let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    private func prepareNavigationBar() { // Add barButtonItem for rightBarButton
        let newBarButtonItem = UIBarButtonItem(image: UIImage(named: "newMessage"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(newMessageAction))
        self.tabBarController?.navigationItem.rightBarButtonItem = newBarButtonItem
    }
    
    private func prepareTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 13)
        let placeholderColor = UIColor(hexString: "939393")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        let placeHolder = "Search for messages or contacts"
        searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
        searchTextField.textColor = UIColor.blackTextColor()
        searchTextField.font = UIFont.circularStdBook(size: 13)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func showSearchViewButtonAction(_ sender: UIButton) {
        centerXSearchViewConstraint.isActive = false
        leadingSearchViewConstraint.isActive = true
        trailingSearchViewConstraint.isActive = true
        showSearchButton.isHidden = true
        searchTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let searchText = textField.text {
            filterMessages = searchText.isEmpty ? userMessages : userMessages.filter({ $0.lowercased().contains(searchText.lowercased()) })
        }
    }
    
    @IBAction func groupConversationButtonAction(_ sender: UIButton) {
        let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
        newMessageVC.isGroup = true
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    
    // MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        // Render Data
        cell.userNameLabel.text = filterMessages[indexPath.row]
        let countMessage = indexPath.row == 0 || indexPath.row == 1 ? 2 : 0
        cell.countNewMessageButton.isHidden = countMessage == 0
        cell.countMessageTrailingConstraint.constant = countMessage == 0 ? 0 : 19
        cell.countNewMessageButton.setTitle("\(countMessage)", for: .normal)
        // Fixed reusable when swipe cell
        if currentSwipeIndexPath != nil {
            cell.deleteButtonTrailingConstraint.constant = currentSwipeIndexPath.row == indexPath.row ? 0 : -cell.deleteButton.frame.width
            cell.userImageLeadingConstraint.constant = currentSwipeIndexPath.row == indexPath.row ? -cell.deleteButton.frame.width : 20
        }
        // Handle `swipe` right
        cell.handleSwipeAction = {
            print("IndexPath == \(indexPath.row)")
            self.currentSwipeIndexPath = indexPath
            cell.deleteButtonTrailingConstraint.constant = 0
            cell.userImageLeadingConstraint.constant = -cell.deleteButton.frame.width
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
                            self.view.setNeedsLayout()
            })
        }
        // Handle `delete` button
        cell.deleteButtonAction = {
            self.currentSwipeIndexPath = nil
            cell.deleteButtonTrailingConstraint.constant = -cell.deleteButton.frame.width
            cell.userImageLeadingConstraint.constant = 20
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
                tableView.beginUpdates()
                if self.filterMessages.count > 0 {
                    self.filterMessages.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .top)
                }
                tableView.endUpdates()
                CATransaction.commit()
            })
        }
        // Handle `hideDelete` button
        cell.hideDeleteButtonAction = {
            self.currentSwipeIndexPath = nil
            cell.deleteButtonTrailingConstraint.constant = -cell.deleteButton.frame.width
            cell.userImageLeadingConstraint.constant = 20
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageChatVC = StoryboardManager.contactStoryBoard().getController(identifier: "MessageChatVC") as! MessageChatViewController
        messageChatVC.titleText = filterMessages[indexPath.row]
        navigationController?.pushViewController(messageChatVC, animated: true)
    }
    
    
    
    
}
