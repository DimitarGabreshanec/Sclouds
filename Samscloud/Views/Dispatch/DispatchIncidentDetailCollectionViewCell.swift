//
//  DispatchIncidentDetailCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchIncidentDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DispatchIncidentDetailCollectionViewCell"
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        userImageView.roundRadius()
        prepareShadow()
    }
    
    
    // MARK: - ACTIONS
    
    private func prepareShadow() {
        // Shadow and Radius
        let color = UIColor.black
        shadowView.layer.shadowColor = color.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowRadius = 6
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowPath = nil
        shadowView.layer.masksToBounds = false
    }
    
    
    
}
