//
//  NewMessageTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/30/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    
    static let identifier = "NewMessageTableViewCell"
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        checkButton.setImage(UIImage(named: "checked"), for: .selected)
        checkButton.setImage(UIImage(named: "check"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //checkButton.setImage(selected ? UIImage(named: "checked") : UIImage(named: "check"), for: .normal)
    }
    
    
    // MARK: - ACTIONS
    
    func noAddress(isNoAddress: Bool) {
        requestLabel.isHidden = !isNoAddress
        rangeButton.isHidden = isNoAddress
        timeAgoLabel.isHidden = isNoAddress
        addressLabel.text = isNoAddress ? "Location not available" : "632 Stark Terrace Suite 028"
        addressLabel.textColor = isNoAddress ? UIColor(named: "b4b4b4") : UIColor(named: "5a5a5a")
    }
    
    var contact:ContactModel? {
        didSet{
            userNameLabel.text = contact?.name
            
            let address = contact?.organization ?? ""
            addressLabel.text = address.isEmpty ? "Location not available" : address
            addressLabel.textColor = address.isEmpty ? UIColor(named: "b4b4b4") : UIColor(named: "5a5a5a")
            if address == "" {
                noAddress(isNoAddress: true)
            }
            rangeButton.isHidden = true
            timeAgoLabel.text = ""
            if let image = contact?.profile_image, image != "" {
                let defaultImg = UIImage.init(named: "userAvatar")
                loadImage(image, userImageView, activity: nil, defaultImage: defaultImg)
            }else{
                userImageView.image = UIImage.init(named: "userAvatar")
            }
            requestLabel.isHidden = true
        }
    }
    
}
