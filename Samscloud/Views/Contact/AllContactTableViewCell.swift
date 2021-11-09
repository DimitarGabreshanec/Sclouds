//
//  AllContactTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class AllContactTableViewCell: UITableViewCell {
    
    static let identifier = "AllContactTableViewCell"
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if kAppDelegate.checkValue <= 300 {
            if  let image = checkImageView.image {
                if image == UIImage(named: "checked") {
                    kAppDelegate.checkValue = kAppDelegate.checkValue - 1
                    checkImageView.image = UIImage(named: "check")
                } else {
                    kAppDelegate.checkValue = kAppDelegate.checkValue + 1
                    checkImageView.image = UIImage(named: "checked")
                }
            } else {
                if kAppDelegate.checkValue <= 3 {
                checkImageView.image =  UIImage(named: "check")
                }
            }
        } else {
            print("CHECK VALUE > 3")
        }
//       if kAppDelegate.checkValue <= 3 {
//            kAppDelegate.checkValue = kAppDelegate.checkValue + 1
//            checkImageView.image = selected ? UIImage(named: "checked") : UIImage(named: "check")
//        } else {
//                checkImageView.image = UIImage(named: "checked")
//                kAppDelegate.checkValue = kAppDelegate.checkValue - 1
//        }
    }
    
    
    
}
