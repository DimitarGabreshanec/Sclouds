//
//  ScanResultsViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/23/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class ScanResultsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infomationContainerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lenghtButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var wantedButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var addProfileContainerView: UIView!
    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    
    // MARK: - Variables
    var isFromHome = false
    var isDispatchSOSFacil = false
    private var collectionViewLayout: LGHorizontalLinearFlowLayout!
    private var animationsCount = 0
    private var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Scan Results"

        prepareNavigationBar()
        prepareCollectionView()
        renderUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: addProfileContainerView.frame.maxY + 10)
        contentViewHeightConstraint.constant = addProfileContainerView.frame.maxY + 10
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        infomationContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    // MARK: - Methods
    
    @objc func doneButtonAction() {
        if isFromHome {
            navigationController?.popViewController(animated: true)
        }
        else {
            if let controllers = navigationController?.viewControllers {
                controllers.forEach { (vc) in
                    if vc is OngoingIncidentViewController {
                        navigationController?.popToViewController(vc as! OngoingIncidentViewController, animated: true)
                    }
                }
            }
        }
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
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: ScanResultCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ScanResultCollectionViewCell.identifier)
        let size = collectionView.frame.height - 5
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView:
            self.collectionView, itemSize: CGSize(width: (size * 8) / 10, height: size), minimumLineSpacing: 10)
    }
    
    private func renderUI() {
        if isFromHome {
            resumeButton.setImage(UIImage(named: "report-dispatch-big"), for: .normal)
            resumeLabel.text = "Report"
            stopButton.setImage(UIImage(named: "responder"), for: .normal)
            stopLabel.text = "Escalate"
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func runButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resumeButtonAction(_ sender: Any) {
        if isFromHome {
            // Handle report button
        }
        else {
            // Handle resume button
            if isDispatchSOSFacil {
                let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentVC") as! OngoingIncidentViewController
                ongoingIncidentVC.isDispatchHome = true
                
                self.navigationController?.pushViewController(ongoingIncidentVC, animated: false)
            }
            else {
                if let controllers = navigationController?.viewControllers {
                    controllers.forEach { (vc) in
                        if vc is OngoingIncidentViewController {
                            navigationController?.popToViewController(vc as! OngoingIncidentViewController, animated: true)
                        }
                    }
                }
            } 
        }
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        if isFromHome {
            // Handle `escalate` button
            let dispatchSOSResponderVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchSOSResponderVC") as! DispatchSOSResponderViewController
            
            navigationController?.pushViewController(dispatchSOSResponderVC, animated: true)
        }
        else {
            // Handle `live feeds` button
            let liveFeedsVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "LiveFeedsVC") as! LiveFeedsViewController
            
            navigationController?.pushViewController(liveFeedsVC, animated: true)
        }
    }
    
    @IBAction func addProfileButtonAction(_ sender: UIButton) {
    }
}

// MARK: - UICollectionViewDataSource

extension ScanResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScanResultCollectionViewCell.identifier, for: indexPath) as! ScanResultCollectionViewCell
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScanResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height - 5
        return CGSize(width: (size * 8) / 10, height: size)
    }
}
