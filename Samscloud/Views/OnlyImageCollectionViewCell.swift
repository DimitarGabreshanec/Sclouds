//
//  OnlyImageCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class OnlyImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnlyImageCollectionViewCell"
    static let dispatchIdentifier = "DispatchCollectionViewCell"
    static let dispatchIncidentAccept = "DispatchIncidentAcceptCollectionViewCell"
    
    @IBOutlet weak var wrappedOnlyImageView: UIView!
    @IBOutlet weak var onlyImageView: UIImageView!
    @IBOutlet weak var dispatchHomeImageView: UIImageView!
    @IBOutlet weak var dispatchIncidentAcceptImageView: UIImageView!
    

    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        onlyImageView?.layer.cornerRadius = 10
        dispatchHomeImageView?.roundRadius()
        dispatchHomeImageView?.bordered(withColor: UIColor(hexString: "7ed321"), width: 2)
        onlyImageView?.bordered(withColor: UIColor(hexString: "ffffff"), width: 2)
        wrappedOnlyImageView?.roundRadius()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //dispatchIncidentAcceptImageView?.roundRadius()
    }
    
}
