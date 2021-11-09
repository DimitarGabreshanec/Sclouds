//
//  IncidentHistoryTableViewCell.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class IncidentHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "IncidentHistoryTableViewCell"
    static let listIdentifier = "IncidentHistoryListTableViewCell"
    var deleteButtonAction: (() -> Void)?
    var recordedButtonAction: (() -> Void)?
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoTumbnail: UIImageView?
    
    @IBOutlet weak var showTimeButton: UIButton!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recordedButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
 
    var incident:OngoingIncidentModel? {
        didSet{
            setData()
        }
    }
    // MARK: - INIT

    override func awakeFromNib() {
        super.awakeFromNib()
        videoContainerView?.layer.cornerRadius = 4
        showTimeButton?.layer.cornerRadius = 2
        recordedButton?.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - IBACTIONS

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonAction?()
    }
    
    @IBAction func recordedButtonAction(_ sender: UIButton) {
        recordedButtonAction?()
    }
    
    
    private func setData() {
    
        let report = incident?.emergency_message ?? ""
        videoNameLabel.text = "Report- \(report)"
        contentLabel.text = incident?.current_location
        dateLabel.text = incident?.broadcast_start_time?.toIncidentDate()?.toIncidentHistorStr()
        
        let duration = incident?.stream_duration ?? 0
        
        if let url = incident?.preview_thumbnail, let imgView = videoTumbnail {
            loadImage(url, imgView, activity: nil, defaultImage: nil)
        }
        
        
        let secondsString = String(format: "%02d", Int(duration.truncatingRemainder(dividingBy: 60)))
        let minutes = duration/60
        let minutesString = String(format: "%02d", Int(minutes.truncatingRemainder(dividingBy: 60)))
        
        showTimeButton?.setTitle("\(minutesString):\(secondsString)", for: .normal)
        
        recordedButton.isHidden = !(incident?.is_stopped == true)
    }
}
