//
//  CreateGeoFenceTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class CreateGeoFenceTableViewCell: UITableViewCell {
    
    // Contact
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var hideDeleteButton: UIButton!
    @IBOutlet weak var leadingUserImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingDeleteButtonConstraint: NSLayoutConstraint!
    
    static let identifier = "CreateGeoFenceTableViewCell"
    
    // Assign Contact
    @IBOutlet weak var assignContactButton: UIButton!
    @IBOutlet weak var countPersonLabel: UILabel!
    
    static let assignIdentifier = "AssignGeoFenceTableViewCell"
    
    var swipeGesture: UISwipeGestureRecognizer!
    var deleteButtonAction: (() -> Void)?
    var handleSwipeAction: (() -> Void)?
    var hideDeleteButtonAction: (() -> Void)?
    var assignContactButtonAction: (() -> Void)?
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView?.roundRadius()
        rangeButton?.layer.cornerRadius = 2
        addSwipeGeture()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func handleSwipeCell() {
        hideDeleteButton.isHidden = false
        handleSwipeAction?()
    }
    
    private func addSwipeGeture() {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeCell))
        swipeGesture.direction = .left
        self.addGestureRecognizer(swipeGesture)
    }
    
    
    // MARK: - IBACTIONS

    @IBAction func assignContactButtonAction(_ sender: UIButton) {
        assignContactButtonAction?()
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        hideDeleteButton.isHidden = true
        deleteButtonAction?()
    }
    
    @IBAction func hideDeleteButtonAction(_ sender: UIButton) {
        hideDeleteButton.isHidden = true
        hideDeleteButtonAction?()
    }
    
    
}
