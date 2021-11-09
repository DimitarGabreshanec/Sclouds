//
//  ChatInputView.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ChatInputView: UIView {
    
    var addFileButtonAction: (() -> Void)?
    var sendButtonAction: (() -> Void)?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addFileButton: UIButton!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    

    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        sendButton.activated(false)
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
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let messageText = textField.text {
            sendButton.activated(!messageText.isEmpty)
        }
    }
    
    @IBAction func addFileButtonAction(_ sender: UIButton) {
        addFileButtonAction?()
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        sendButtonAction?()
        chatTextField.resignFirstResponder()
    }
    
    
    
}
