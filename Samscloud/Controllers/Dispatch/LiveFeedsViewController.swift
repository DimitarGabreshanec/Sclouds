//
//  LiveFeedsViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/21/19.
//  Copyright © 2019 done Idea Tech. All rights reserved.
//

import UIKit

class LiveFeedsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var segmentedBorderView: UIView!
    @IBOutlet weak var segmentedContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    
    private var collectionViewLayout: LGHorizontalLeftFlowLayout!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Live Feeds"
        
        prepareNavigationBar()
        prepareSegmentedControl()
        prepareCollectionView()
        translucentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        collectionView.isHidden = true
    }
    
    // MARK: - Methods
    
    @objc func doneButtonAction() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is OngoingIncidentViewController {
                    navigationController?.popToViewController(vc as! OngoingIncidentViewController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func prepareNavigationBar() {
        createBackBarButtonItem()
        
        let doneButton = creatCustomBarButton(title: "Done")
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneButton.activatedOfNavigationBar(false)
        
        let doneBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    private func prepareSegmentedControl() {
        // SegmentControl for title
        let fontAttributeNormal = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        let fontAttributeSelected  = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.removeBorder()
        segmentedControl.tintColor = UIColor.mainColor()
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.setTitleTextAttributes(fontAttributeNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(fontAttributeSelected, for: .selected)
        segmentedBorderView.bordered(withColor: UIColor.mainColor(), width: 1, radius: 20)
        segmentedControl.roundRadius()
    }
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: LiveFeedCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: LiveFeedCollectionViewCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let height = collectionView.frame.height
        let witdh = (height * 9.7) / 10
        self.collectionViewLayout = LGHorizontalLeftFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: witdh, height: height), minimumLineSpacing: 10)
        collectionViewLeadingConstraint.constant = -((view.frame.width / 2) - 32)
    }
}

// MARK: - UICollectionViewDataSource

extension LiveFeedsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveFeedCollectionViewCell.identifier, for: indexPath) as! LiveFeedCollectionViewCell
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LiveFeedsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is OngoingIncidentViewController {
                    navigationController?.popToViewController(vc as! OngoingIncidentViewController, animated: true)
                }
            }
        }
    }
}
