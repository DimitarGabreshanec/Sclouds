//
//  SelectItemTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class SelectItemTableViewCell: UITableViewCell {
    
    static let identifier = "SelectItemTableViewCell"
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.roundRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
