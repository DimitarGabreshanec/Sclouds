//
//  ContactProfileViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ContactProfileViewController: UIViewController {
    
    var userName = ""
    var removeContactAction: (() -> Void)?
    var isShowMessagePage = false
    var isFromTeamContact = false
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var emergContactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    
    var contact:ContactModel?
    
    
    // MARK: - INIT

    static func instanse() ->ContactProfileViewController{
        let container = UIStoryboard.init(name: "Contact", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "ContactProfileVC") as! ContactProfileViewController
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigation()
        userNameLabel.text = userName
        mapImageView.isHidden = !isFromTeamContact
        
        fill()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        if isShowMessagePage {
            isShowMessagePage = false
            let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
            mainTabBarVC.defaultIndex = 1
            navigationController?.pushViewController(mainTabBarVC, animated: true)
        }
        translucentNavigationBar()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func removeButtonAction() {
        navigationController?.popViewController(animated: true, completion: {
            self.removeContactAction?()
        })
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        let addButton = creatCustomBarButton(title: "Remove")
        addButton.addTarget(self, action: #selector(removeButtonAction), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - IBACTIONS
    @IBAction func messageButtonAction(_ sender: UIButton) {
        print("MESSAGE BUTTON ACTION BUTTON PRESSED - CONTACTPROFILE_VC")
        let messageChatVC = StoryboardManager.contactStoryBoard().getController(identifier: "MessageChatVC") as! MessageChatViewController
        messageChatVC.titleText = userName
        messageChatVC.isFromGeofence = true
        navigationController?.pushViewController(messageChatVC, animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        print("CALL BUTTON ACTION BUTTON PRESSED - CONTACTPROFILE_VC")
    }
    

    func fill() {
        userNameLabel.text = contact?.name
        phoneNumberLabel.text = contact?.phone_number
        relationshipLabel.text = contact?.relationship
        emailLabel.text = contact?.email
        userImageView.image = UIImage.init(named: "userAvatar")
    }
    
}
