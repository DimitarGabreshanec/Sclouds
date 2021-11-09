//
//  ResponderCollectionViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ResponderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResponderCollectionViewCell"
    static let incidentIdentifier = "IncidentHistoryResponderCollectionViewCell"
    static let geoIdentifier = "GeoFencesResponderCollectionViewCell"
    
    @IBOutlet weak var responderImageView: UIImageView!
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        responderImageView.roundRadius()
        
        responderImageView.layer.borderWidth = 0
        responderImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    
}
