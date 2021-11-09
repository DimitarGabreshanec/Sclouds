//
//  EscalateCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 8/2/18.
//  Copyright © 2018 Next Idea Tech. All rights reserved.
//

import UIKit

class EscalateCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EscalateCollectionViewCell"
    
    @IBOutlet weak var userNameImageView: UIImageView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var responderStatusLabel: UILabel!
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameImageView.bordered(withColor: UIColor.white, width: 1)
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.userNameImageView.layer.cornerRadius = self.userNameImageView.frame.size.width / 2;
            self.userNameImageView.clipsToBounds = true
            self.layoutIfNeeded()
        }
    }
    
    
}
