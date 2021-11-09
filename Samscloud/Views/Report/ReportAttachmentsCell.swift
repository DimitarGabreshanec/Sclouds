//
//  ReportAttachmentsCell.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/10/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class ReportAttachmentsCell: UITableViewCell {
    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    private var collectionViewLayout: LGHorizontalLeftFlowLayout!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, for row: Int) {
        
        self.collectionView.delegate = dataSourceDelegate
        self.collectionView.dataSource = dataSourceDelegate
        self.collectionView.tag = row
        self.collectionView.reloadData()
        
        /*
        // Setup flow layout
        let height = collectionView.frame.height
        let width = (height * 9.7) / 10
        self.collectionViewLayout = LGHorizontalLeftFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: width, height: height), minimumLineSpacing: 8)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        */
    }
    
    func hideCollectionView() {
        self.collectionView.isHidden = true
        self.collectionViewHeightConstraint.constant = 0
        self.collectionViewTopConstraint.constant = 4
    }
    
    func showCollectionView() {
        self.collectionView.isHidden = false
        self.collectionViewHeightConstraint.constant = 126
        self.collectionViewTopConstraint.constant = 8
    }
}
