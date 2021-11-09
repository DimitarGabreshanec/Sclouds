//
//  LiveFeedCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class LiveFeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LiveFeedCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var liveFeedImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
            self.userImageView.clipsToBounds = true
            self.layoutIfNeeded()
        }
    }
    
    
    
}
