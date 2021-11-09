//
//  CountdownViewController.swift
//  Samscloud
//
//  Created by An Phan on 3/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var userNameImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var incidentIDLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var skipTimerButton: UIButton!
    
    // MARK: - Variables
    private var maxSecond = 5
    private var timer: Timer!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countdown"
        countdownLabel.text = "\(maxSecond)"

        createBackBarButtonItem()
        prepareUI()
        runTime()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - Methods
    
    @objc func updateTime() {
        maxSecond -= 1
        
        if maxSecond == 0 {
            performSegue(withIdentifier: "showDispatchMessageSegue", sender: nil)
            timer.invalidate()
        }
        countdownLabel.text = "\(maxSecond)"
    }
    
    // MARK: - Private method
    
    private func runTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func prepareUI() {
        userNameImageView.roundRadius()

        // AttributeText
        reportLabel.attributedText      = attributeTetx(label: reportLabel,
                                                        text: "Report: Earthquake",
                                                        rangeText: "Earthquake")
        incidentIDLabel.attributedText  = attributeTetx(label: incidentIDLabel,
                                                        text: "Incident ID: 000129",
                                                        rangeText: "000129")
        startTimeLabel.attributedText   = attributeTetx(label: startTimeLabel,
                                                        text: "Started: 9:04:07 PM",
                                                        rangeText: "9:04:07 PM")
        levelLabel.attributedText       = attributeTetx(label: levelLabel,
                                                        text: "Level: High",
                                                        rangeText: "High",
                                                        color: UIColor(hexString: "FF4646"))
        groupSizeLabel.attributedText   = attributeTetx(label: groupSizeLabel,
                                                        text: "Group Size: 2340",
                                                        rangeText: "2340")
        audienceLabel.attributedText    = attributeTetx(label: audienceLabel,
                                                        text: "Audience Size: 372",
                                                        rangeText: "372")
    }
    
    private func attributeTetx(label: UILabel,
                               text: String,
                               rangeText: String,
                               color: UIColor = UIColor(hexString: "5A5A5A")) -> NSMutableAttributedString {
        //Attribute String
        label.text = text
        let attributedString = NSMutableAttributedString(string: label.text!)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: color]
        
        let range = (label.text! as NSString).range(of: rangeText)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
    
    // MARK: - IBAction
    
    @IBAction func skipTimerButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "showDispatchMessageSegue", sender: nil)
        timer.invalidate()
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
