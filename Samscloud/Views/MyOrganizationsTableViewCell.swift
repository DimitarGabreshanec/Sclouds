//
//  MyOrganizationsTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/15/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import CoreLocation

class MyOrganizationsTableViewCell: UITableViewCell {
    
    var presenter: SearchOrgnizationPresenter? = nil
    var moreButtonAction: (() -> Void)?
    var isSearchOrganization = false
    static let identifier = "MyOrganizationsTableViewCell"
    
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var policeButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    
    // MARK: - INIT
    
    
    var organization:OrganizationModel?{
        didSet{
            fill()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        organizationImageView.roundRadius()
        rangeButton.layer.cornerRadius = 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //let checkImage = selected ? "checked" : "check"
        //checkImageView.image = UIImage(named: checkImage)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        moreButtonAction?()
    }
    
    
    // MARK: - ACTIONS
    
    func renderUI(organizations: [Organization], indexPath: IndexPath) {
        renderUI(at: indexPath)
    }
    
    func renderUI(at indexPath: IndexPath) {
        // statusLabel.text = indexPath.section == 0 && indexPath.row == 0 ? "Private" : "Public"
        policeButton.isHidden = indexPath.row == 2
        notificationButton.isHidden = indexPath.row == 1
    }
    
    func searchOrganizationUI() {
        moreButton.isHidden = isSearchOrganization
        if presenter == .reports {
            // Do nothing
        } else if isSearchOrganization {
            checkImageView.isHidden = statusLabel.text == "Private"
        } else {
            checkImageView.isHidden = true
        }
    }
    
    func showHideBottomView(indexPath: IndexPath, organizations: [Organization]) {
        let organizationCount = organizations.count
        bottomView.isHidden = organizationCount == 1 || indexPath.row == organizationCount - 1
    }
    
    
    
    private func fill() {
        nameLabel.text = (presenter == .reports ? organization?.organization_name : organization?.contact_name)
        statusLabel.text = organization?.who_can_join
        addressLabel.text = organization?.address
        let checkImage = "checked"  //"checked" : "check"
        checkImageView.image = UIImage(named: checkImage)
        
        
        if let lat = organization?.latitude, let long = organization?.longitude {
            let location = CLLocation.init(latitude: lat, longitude: long)
            let distance = (appDelegate.currentLocation?.distance(from: location) ?? 0)/1609.34
            let str = String.init(format: "%.2f miles", Float(distance))
            rangeButton.setTitle(str, for: .normal)
        }
        checkImageView.isHidden =  false//organization?.who_can_join == "Private"
    
        print("Logo ------->>>>>",organization?.logo ?? "org logo is nil")
        
        if let logo = organization?.logo, logo != "" {
            loadImage(logo, organizationImageView, activity: nil, defaultImage: nil)
        }else{
            organizationImageView.image = UIImage.init(named: "sams_logo")
        }
    }
    
    
    
}


