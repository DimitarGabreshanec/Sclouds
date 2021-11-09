//
//  UserResponderCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class UserResponderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserResponderCollectionViewCell"
    static let groupIdentifier = "GroupCollectionViewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.roundRadius()
        userImageView.bordered(withColor: UIColor.white, width: 1)
    }
    
    
    
}
