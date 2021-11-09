//
//  DispatchHomeTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchHomeTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    // Notification
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var liveButton: UIButton!
    
    static let notificationIdentifier = "NotificationTableViewCell"
    
    // Team
    @IBOutlet weak var teamContainerView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    static let teamIdentifier = "TeamTableViewCell"
    
    var liveButtonAction: (() -> Void)?
    var locationButtonAction: (() -> Void)?
    
    
    // MARK: - INIT
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCollectionView()
    }
    
    
    // MARK: - ACTIONS
    
    private func prepareShadow(view: UIView) {
        // Shadow and Radius
        let color = UIColor.black
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.25
        view.layer.shadowPath = nil
        view.layer.masksToBounds = false
    }
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: OnlyImageCollectionViewCell.identifier, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: OnlyImageCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func prepareNotificationCell() {
        liveButton.roundRadius()
        prepareShadow(view: containerView)
        containerView.layer.cornerRadius = 8
    }
    
    func prepareTeamCell() {
        locationImageView?.image = UIImage(named: "location-big")?.withRenderingMode(.alwaysTemplate)
        locationImageView?.tintColor = UIColor.mainColor()
        if let teamContainerView = teamContainerView {
            prepareShadow(view: teamContainerView)
        }
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func liveButtonAction(_ sender: UIButton) {
        liveButtonAction?()
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        locationButtonAction?()
    }
    
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlyImageCollectionViewCell.identifier, for: indexPath) as! OnlyImageCollectionViewCell
        if indexPath.row < 3 {
            cell.onlyImageView.bordered(withColor: UIColor(hexString: "ffffff"), width: 0.5)
        } else {
            cell.onlyImageView.bordered(withColor: UIColor(hexString: "ffffff"), width: 0)
            cell.wrappedOnlyImageView.backgroundColor = UIColor(hexString: "f8e71c")
        }
        cell.onlyImageView.layer.cornerRadius = 17
        return cell
    }
    
    
    
}

