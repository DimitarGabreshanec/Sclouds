//
//  ReportDetailTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 3/15/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ReportDetailTableViewCell: UITableViewCell {
    
    static let identifier = "ReportDetailTableViewCell"
    var removeButtonAction: (() -> Void)?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - IBACTIONS

    @IBAction func removeButtonAction(_ sender: UIButton) {
        removeButtonAction?()
    }
    
    
    
}
