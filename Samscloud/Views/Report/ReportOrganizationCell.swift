//
//  ReportOrganizationCell.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/10/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class ReportOrganizationCell: UITableViewCell {
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var orgImageView: UIImageView!
    @IBOutlet var orgNameLabel: UILabel!
    @IBOutlet var orgAddressLabel: UILabel!
    var removeAction: () -> () = {}
    
    @IBAction func removeTapped() {
        self.removeAction()
    }
}
