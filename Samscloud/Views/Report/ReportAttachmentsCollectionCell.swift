//
//  ReportAttachmentsCollectionCell.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 12/1/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class ReportAttachmentsCollectionCell: UICollectionViewCell {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var removeButton: UIButton!
    var removeAction: () -> () = {}
    
    @IBAction func removeTapped() {
        self.removeAction()
    }
    
    func showSpinner() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideSpinner() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
