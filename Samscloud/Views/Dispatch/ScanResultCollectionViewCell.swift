//
//  ScanResultCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/23/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ScanResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ScanResultCollectionViewCell"
    
    @IBOutlet weak var scanResultImageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var accuracyLbel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        bottomContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
//    }
    
    
    
}
