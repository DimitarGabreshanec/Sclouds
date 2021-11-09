//
//  ChatViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var isIncidentDetail = false
    var chatInputView: ChatInputView = ChatInputView.fromNib()
    var endButtonAction: (() -> Void)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chatContentView: UIView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var addLabel: UILabel!
    // Bottom View
    @IBOutlet weak var addFileButton: UIButton!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var bottomChatContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatContentHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prepare collectionView
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if isIncidentDetail {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            view.semanticContentAttribute = .forceRightToLeft
            actionStackView.semanticContentAttribute = .forceRightToLeft
            addButton.isHidden = true
            addLabel.isHidden = true
        }
        chatImageView.contentMode = UIScreen.main.bounds.height > 375 ? .scaleAspectFit : .scaleAspectFill
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularStdBold(size: 18),
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.mainColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: chatImageView.frame.maxY + 20)
        chatContentHeightConstraint.constant = chatImageView.frame.maxY + 20
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return chatInputView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareUI() {
        audioButton.roundRadius()
        audioButton.tintColor = .white
        cameraButton.roundRadius()
        topView.roundRadius()
        addButton.roundRadius()
        addButton.bordered(withColor: UIColor(hexString: "5A5A5A"), width: 1)
        addButton.setTitleColor(UIColor(hexString: "5A5A5A"), for: .normal)
        addButton.setTitleColor(UIColor(hexString: "5A5A5A"), for: .selected)
        chatContainerView.roundRadius()
        chatContainerView.bordered(withColor: UIColor(hexString: "DADADA"), width: 1) 
        // attribute message text
        let font = UIFont.circularStdBook(size: 16)
        let placeholderColor = UIColor.greyTextColor()
        let attributed = NSAttributedString(string: "Message",
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: placeholderColor])
        chatTextField.attributedPlaceholder = attributed
        chatTextField.font = font
        chatTextField.textColor = UIColor.blackTextColor()
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func endBarButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: {
            self.endButtonAction?()
        })
    }
    
    @IBAction func arrowDownBarButtonAction(_ sender: UIBarButtonItem) {
        print("ARROW DOWN BAR BUTON BUTTON ACTION PRESSED - CHAT_VC")
    }
    
    @IBAction func addButtonAction(_ button: UIButton) {
        print("ADD BUTTON ACTION PRESSED - CHAT_VC")
        button.isSelected = !button.isSelected
        addLabel.text = button.isSelected ? "Ungroup" : "Add"
    }
    
    @IBAction func audioButtonAction(_ sender: UIButton) {
        print("AUDIO BUTTON ACTION PRESSED - CHAT_VC")
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        print("CAMERA BUTTON ACTION PRESSED - CHAT_VC")
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        print("MAIN VIEW TAPPED - CHAT_VC")
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addFileButtonAction(_ sender: UIButton) {
        print("ADD FILE BUTTON ACTION PRESSED - CHAT_VC")
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        print("SEND BUTTON ACTION PRESSED - CHAT_VC")
    }
    
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserResponderCollectionViewCell.identifier, for: indexPath) as! UserResponderCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: collectionView.frame.height)
    }
    
    
    // MARK: - GESTURES / TOUCHES
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        return true
    }
    
    
    
}
