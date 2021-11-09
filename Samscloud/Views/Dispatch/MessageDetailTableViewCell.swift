//
//  MessageDetailTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 7/3/18.
//  Copyright © 2018 Next Idea Tech. All rights reserved.
//

import UIKit

class MessageDetailTableViewCell: UITableViewCell {
    
    static let identifier = "MessageDetailTableViewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sendingToLabel: UILabel!
    @IBOutlet weak var addOrRemoveImageView: UIImageView!
    @IBOutlet weak var addOrRemoveLabel: UILabel!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - ACTIONS
    
    func renderUI(indexPath: IndexPath) {
        sendingToLabel.isHidden = indexPath.row != 0
        userImageView.isHidden = indexPath.row == 0
        userNameLabel.isHidden = indexPath.row == 0
        distanceLabel.isHidden = indexPath.row == 0
        addOrRemoveLabel.text = indexPath.row == 0 ? "Add Group" : "Remove"
        addOrRemoveImageView.image = UIImage(named: indexPath.row == 0 ? "add-small" : "remove")
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func addOrRemoveButtonAction(_ sender: UIButton) {
        print("ADD OR REMOVE BUTTON ACTION PRESSED")
    }
    
    
    
}
