//
//  GeoFencesTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class GeoFencesTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    static let identifier = "GeoFencesTableViewCell"
    var deleteButtonAction: (() -> Void)?
    
    @IBOutlet weak var geoFencesNameLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var assgingedMemberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
    }
 
    
    // MARK: - IBACTIONS
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonAction?()
    }

    
    // MARK: - TABLE VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResponderCollectionViewCell.geoIdentifier, for: indexPath) as! ResponderCollectionViewCell
        return cell
    }
}
