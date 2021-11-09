//
//  DispatchIncidentDetailTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchIncidentDetailTableViewCell: UITableViewCell {
    
    static let identifier = "DispatchIncidentDetailTableViewCell"
    var messageButtonAction: (() -> Void)?
    var microButtonAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var microButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    // MARK: - IBACTIONS
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        messageButtonAction?()
    }
    
    @IBAction func microButtonAction(_ sender: UIButton) {
        microButtonAction?()
    }
    
    
    
}
