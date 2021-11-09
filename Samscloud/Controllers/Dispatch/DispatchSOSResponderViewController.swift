//
//  DispatchSOSResponderViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchSOSResponderViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var idButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var hideLabel: UILabel!
    
    // IBOutlet when finish video
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var activeInvidentLabel: UILabel!
    @IBOutlet weak var standByContainerView: UIView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var standByButton: UIButton!
    @IBOutlet weak var standByLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var smallViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bigViewWidthConstraint: NSLayoutConstraint!
    
    // IBOutlet when click standBy button
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var noAudioButton: UIButton!
    
    // MARK: - Variables
    var videoImageName = ""
    let mapImage = "video-map"
    let videoImage = "report-photo"
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        prepareNavigation()
        prepareUI()
        addTapGeture()
    }
    
    // MARK: - Methods
    
    @objc func notificationButtonAction() {
    }
    
    @objc func emergencyNumberButtonAction() {
    }
    
    @objc func videoImageViewTapped() {
        if videoImageName == mapImage {
            videoImageName = videoImage
            backgroundImageView.image = UIImage(named: "dispatchSOSMap")
            locationButton.isHidden = false
            collectionView.isHidden = true
        }
        else if videoImageName == videoImage {
            videoImageName = mapImage
            locationButton.isHidden = true
            collectionView.isHidden = false
            backgroundImageView.image = UIImage(named: "videoPreview")
        }
        videoImageView.image = UIImage(named: videoImageName)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigation() {
        navigationItem.hidesBackButton = true
        
        let logo = UIImageView(frame: CGRect(x: 3, y: 0, width: 160, height: 36))
        logo.clipsToBounds = false
        logo.image = UIImage(named: "home-logo")
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 41))
        view.clipsToBounds = false
        view.addSubview(logo)
        
        // Set left navigationItem
        let logoBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItems = [logoBarButtonItem]
        
        // Set right navigationItem
        let notificationBarButtonItem = UIBarButtonItem(image: UIImage(named: "homeNotification"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(notificationButtonAction))
        notificationBarButtonItem.imageInsets.top = -5
        
        let emergencyBarButtonItem = UIBarButtonItem(image: UIImage(named: "911-icon")?.withRenderingMode(.alwaysOriginal),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(emergencyNumberButtonAction))
        emergencyBarButtonItem.imageInsets.top = -5
        navigationItem.rightBarButtonItems = [emergencyBarButtonItem, notificationBarButtonItem]
    }
    
    private func prepareUI() {
        bigViewWidthConstraint.constant = UIScreen.main.bounds.size.height == 667.0 ? 180 : 230
        smallViewWidthConstraint.constant = UIScreen.main.bounds.size.height == 667.0 ? 130 : 144
        bigView.layer.cornerRadius = bigViewWidthConstraint.constant / 2
        smallView.layer.cornerRadius = smallViewWidthConstraint.constant / 2
        smallView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        videoImageView.layer.cornerRadius = 10
    }
    
    private func addTapGeture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(videoImageViewTapped))
        videoImageView.addGestureRecognizer(tap)
    }
    
    private func showPassCodePage() {
        let passCodeVC = StoryboardManager.homeStoryBoard().getController(identifier: "PassCodeVC") as! PassCodeViewController
        passCodeVC.modalTransitionStyle = .crossDissolve
        
        present(passCodeVC, animated: true, completion: nil)
    }
    
    private func clickStandBy(isStandBy: Bool) {
        mapImageView.isHidden = isStandBy
        standByLabel.isHidden = isStandBy
        contentLabel.isHidden = isStandBy
        standByContainerView.isHidden = isStandBy
        locationButton.isHidden = isStandBy
        checkInButton.isHidden = isStandBy
        callButton.isHidden = isStandBy
        liveButton.isHidden = isStandBy
        messageStackView.isHidden = !isStandBy
        backgroundImageView.isHidden = !isStandBy
        collectionView.isHidden = !isStandBy
        idButton.isHidden = !isStandBy
        videoImageName = isStandBy ? mapImage : videoImage
        videoImageView.image = UIImage(named: videoImageName)
        callLabel.text = isStandBy ? "ID" : "911"
        messageButton.setImage(UIImage(named: "message-dispatch"), for: .normal)
        videoImageView.isUserInteractionEnabled = isStandBy
    }
    
    // MARK: - IBAction
  
    @IBAction func callButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func idButtonAction(_ sender: UIButton) {
        let facialRecognitionVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "FacialRecognitionVC") as! FacialRecognitionViewController
        facialRecognitionVC.isDispatchSOSFacil = true
        
        navigationController?.pushViewController(facialRecognitionVC, animated: true)
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func checkInButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        let activeIncidentVC = StoryboardManager.homeStoryBoard().getController(identifier: "ActiveIncidentVC") as! ActiveIncidentViewController
        activeIncidentVC.modalPresentationStyle = .overCurrentContext
        
        // Handle `continue` button
        activeIncidentVC.continueButtonAction = {
//            let mainTabBarVC = StoryBoardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
//            mainTabBarVC.defaultIndex = 2
//
//            self.navigationController?.pushViewController(mainTabBarVC, animated: true)
            AppState.setHomeVCFromContinueIncident()
        }
        
        // Handle `end` button
        activeIncidentVC.endButtonAction = {
            AppState.setHomeVC()
        }
        
        self.present(activeIncidentVC, animated: false, completion: nil)
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        showPassCodePage()
    }
    
    // IBAction when finish video
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func standByButtonAction(_ sender: UIButton) {
        //handleStandByButton(isStandBy: true)
        clickStandBy(isStandBy: true)
    }
    
    // IBAction when click standBy button
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        let chatNC = StoryboardManager.homeStoryBoard().getController(identifier: "ChatNC") as! UINavigationController
        chatNC.modalPresentationStyle = .overCurrentContext
        
        let chatVC = chatNC.topViewController as! ChatViewController
        chatVC.isIncidentDetail = true
        // Handle `end` button
        chatVC.endButtonAction = {
            let activeIncidentVC = StoryboardManager.homeStoryBoard().getController(identifier: "ActiveIncidentVC") as! ActiveIncidentViewController
            activeIncidentVC.modalPresentationStyle = .overCurrentContext
            
            // Handle `continue` button
            activeIncidentVC.continueButtonAction = {
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 2
                
                self.navigationController?.pushViewController(mainTabBarVC, animated: true)
            }
            
            self.present(activeIncidentVC, animated: false, completion: nil)
        }
        
        self.present(chatNC, animated: false, completion: nil)
    }
    
    @IBAction func audioButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func liveButtonAction(_ sender: UIButton) {
    }
}

// MARK: - UICollectionViewDelegate

extension DispatchSOSResponderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EscalateCollectionViewCell.identifier, for: indexPath) as! EscalateCollectionViewCell
        if indexPath.row == 3 {
            cell.userNameImageView.isHidden = true
            cell.responderStatusLabel.isHidden = true
            cell.liveButton.isHidden = false
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DispatchSOSResponderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.row == 3 ? 60 : 37, height: collectionView.frame.height)
    }
}
