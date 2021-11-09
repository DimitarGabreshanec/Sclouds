//
//  MessageChatViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MessageChatViewController: UIViewController {
    
    var titleText = ""
    var chatInputView: ChatInputView = ChatInputView.fromNib()
    var isNewMessage = false
    var isFromGeofence = false
    var newMessageButtonAction: (() -> Void)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        prepareNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: chatImageView.frame.maxY + 10)
        contentViewHeightConstraint.constant = chatImageView.frame.maxY + 10
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return chatInputView
    }
    
    
    // MARK: - ACTIONS
    
    @objc func messageButtonAction() {
        if isNewMessage {
            navigationController?.popViewController(animated: false, completion: {
                self.newMessageButtonAction?()
            })
        }
        if isFromGeofence {
            if let controllers = navigationController?.viewControllers {
                controllers.forEach { (vc) in
                    if vc is TabBarViewController {
                        let tabBarVC = vc as! TabBarViewController
                        tabBarVC.isPopToVC = true
                        tabBarVC.defaultIndex = 1
                        navigationController?.popToViewController(tabBarVC, animated: false)
                    }
                    if vc is ContactProfileViewController {
                        let contactProfileVC = vc as! ContactProfileViewController
                        contactProfileVC.isShowMessagePage = true
                        navigationController?.popToViewController(contactProfileVC, animated: false)
                    }
                    if vc is AddFamilyOnContactViewController {
                        let addFamilyOnContactVC = vc as! AddFamilyOnContactViewController
                        addFamilyOnContactVC.isShowMessagePage = true
                        navigationController?.popToViewController(addFamilyOnContactVC, animated: false)
                    }
                }
            }
        }
        if !isNewMessage && !isFromGeofence {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func plusButtonAction() {
        let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
        newMessageVC.isGroup = true
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNavigationBar() {
        // Add barButtonItem for leftBarButtonItem
        // Create `plus` barbutton
        let plusBarButton = UIBarButtonItem(image: UIImage(named: "addDetail"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(plusButtonAction))
        
        // Create user image
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let userImageView = UIImageView()
        userImageView.frame = view.bounds
        userImageView.roundRadius()
        userImageView.image = UIImage(named: "oval")
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        view.addSubview(userImageView)
        let userImageBarButton = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItems = [userImageBarButton, plusBarButton]
        // Add barButtonItem for leftBarButtonItem
        let messagesButton = creatCustomBarButton(title: "Messages")
        messagesButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        let messageBarButtonItem = UIBarButtonItem(customView: messagesButton)
        self.navigationItem.leftBarButtonItem = messageBarButtonItem
    }
    
    
    // MARK: - TOUCHES / GESTURES
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatInputView.chatTextField.resignFirstResponder()
    }
    
    
    
}
