//
//  ContactCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/18/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
       @IBOutlet weak var lblName: UILabel!
    static let identifier = "ContactCollectionViewCell"
    
    // AddMore Cell
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!

    static let addMoreIdentifier = "AddMoreCollectionViewCell"
    
    // OrganizationCell
    @IBOutlet weak var organizationStatusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    static let organizationCell = "OrganizatioCollectionViewCell"
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView?.roundRadius()
        subView?.roundRadius()
        userImageView?.roundRadius()
        organizationStatusView?.roundRadius()
        statusImageView?.roundRadius()
    }
}
