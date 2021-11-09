//
//  RoutesViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var zoneStackView: UIStackView!
    @IBOutlet weak var zoneCameraButton: UIButton!
    @IBOutlet weak var reportButtonAction: UIButton!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var taskName = ""
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Route"
        taskNameLabel.text = taskName
        containerViewBottomConstraint.constant = -containerView.frame.height
        containerView.layer.cornerRadius = 30
        timeButton.roundRadius()

        prepareNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportMessageSegue" {
            let vc = segue.destination as! DispatchMessageViewController
            vc.isReportMessage = true
        }
    }
    
    // MARK: - Methods
    
    @objc func doneButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        let doneButton = creatCustomBarButton(title: "Done")
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        //doneButton.activatedOfNavigationBar(false)
        
        let doneBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        mapImageView.image = UIImage(named: "route_background")
        zoneStackView.isHidden = true
        reportButtonAction.isUserInteractionEnabled = true
    }
    
    @IBAction func reportButtonActions(_ sender: UIButton) {
    }
}
