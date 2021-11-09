//
//  MessageTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/29/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static let identifier = "MessageTableViewCell"
    var hideDeleteButtonAction: (() -> Void)?
    var deleteButtonAction: (() -> Void)?
    var handleSwipeAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countNewMessageButton: UIButton!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hideDeleteButton: UIButton!
    @IBOutlet weak var deleteButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var countMessageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageLeadingConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        countNewMessageButton.roundRadius()
        userImageView.roundRadius()
        addSwipeGeture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - ACTIONS
    
    @objc func handleSwipeCell() {
        hideDeleteButton.isHidden = false
        handleSwipeAction?()
    }
    
    private func addSwipeGeture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeCell))
        swipe.direction = .left
        self.addGestureRecognizer(swipe)
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
