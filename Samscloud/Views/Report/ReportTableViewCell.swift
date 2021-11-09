//
//  ReportTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    static let identifier = "ReportTableViewCell" 
    var moreButtonAction: (() -> Void)?
    
    @IBOutlet weak var reportNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    // MARK: - IBACTIONS
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        moreButtonAction?()
    }
    
    
}
