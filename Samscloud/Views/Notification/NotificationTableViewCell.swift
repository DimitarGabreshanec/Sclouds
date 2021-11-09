//
//  NotificationTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationTableViewCell"
    var deleteButtonAction: (() -> Void)?
    var handleSwipeAction: (() -> Void)?
    var hideDeleteButtonAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hideDeleteButton: UIButton!
    @IBOutlet weak var leadingUserImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingDeleteButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var typeLabel: UILabel!
 
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var viewButton: UIButton?
    @IBOutlet weak var liveImageView: UIImageView?
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.roundRadius()
        //addSwipeGeture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - ACTIONS
    
    @objc func handleSwipeCell() {
        //hideDeleteButton?.isHidden = false
        //handleSwipeAction?()
    }
    
    private func addSwipeGeture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeCell))
        swipe.direction = .left
        self.addGestureRecognizer(swipe)
    }
    
    func handleSelectLink(text: String, linkURL: String, textToFind: String) {
        textView.text = text
        let attributedString = NSMutableAttributedString(string: textView.text, attributes: nil)
        attributedString.setAsLink(textToFind: textToFind, linkURL: linkURL)
        textView.attributedText = attributedString
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.mainColor(),
                                       NSAttributedString.Key.font: UIFont.circularStdMedium(size: 13)]
        textView.font = UIFont.circularStdBook(size: 16)
        textView.textColor = UIColor.blackTextColor()
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        hideDeleteButton.isHidden = true
        deleteButtonAction?()
    }
    
    @IBAction func hideDeleteButtonAction(_ sender: UIButton) {
        hideDeleteButton.isHidden = true
        hideDeleteButtonAction?()
    }
    
    
    
    
}
