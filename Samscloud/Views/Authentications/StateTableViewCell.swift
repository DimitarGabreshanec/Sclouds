//
//  StateTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

// MARK: - PROTOCOL

protocol StateTableViewCellDelegate {
    func didClick(indexValue: Int)
}


// MARK: - CLASS

class StateTableViewCell: UITableViewCell {
    
    var stateDelegate:StateTableViewCellDelegate! = nil
    static let identifier = "StateTableViewCell"
    static let relationship = "RelationShipTableViewCell"
    
    @IBOutlet weak var stateLabel: UILabel!

    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func actionDidClick(_ sender: Any) {
        let str1 : Int = self.tag
        stateDelegate?.didClick(indexValue: str1)
    }
     
    
}
