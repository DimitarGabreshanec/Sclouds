//
//  IncidentHistoryViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMaps
import Photos

class IncidentHistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleVideoLabel: UILabel!
    @IBOutlet weak var reportedTimeLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emergencyContactsCountLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView?
    
    /**
     @Auther : Irshad Ahmad
     @Description : Google MapView
     */
    @IBOutlet weak var mapView: GMSMapView!{
        didSet{
            if mapView != nil {
                mapView.isMyLocationEnabled = true
                // mapView.settings.myLocationButton =
                mapView.delegate = self
                do {
                    // Set the map style by passing the URL of the local file.
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            }
        }
    }
    
    
    
    // MARK: - Variables
    var moreButtonAction: (() -> Void)?
    var incidentModel:OngoingIncidentModel?
    
    static var player:AVPlayer?
    static var previewLayer:AVPlayerLayer?
    
    var responders:Responders?
    var myLocation:CLLocation?
    var responderList = [ContactModel]()
    var incident_id:String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎ deniniting IncidentHistoryViewController ⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎")
    }
    
}








// MARK:- View Controller Life Cycle
/**
 @Auther : Irshad Ahmad
 @Description : life cycle methods
 */
extension IncidentHistoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.size.height
        contentViewTopConstraint.constant = screenHeight >= 812 ? -44 : -20
        
        self.perform(#selector(loadData), with: nil, afterDelay: 0.5)
        
        let incident = incidentModel?.emergency_message ?? ""
        titleVideoLabel.text = "Report : \(incident)"
        
        let time = incidentModel?.broadcast_start_time?.toIncidentDate()?.toIncidentHistorStr() ?? ""
        reportedTimeLabel.text = "Reported on \(time)"
        
        let address = incidentModel?.current_location
        addressButton.setTitle(address, for: .normal)
        //pauseButton.isHidden = true
        //getIncidentDetail()
        getResponderList()
        
        /*if CLLocationManager.locationServicesEnabled() {
            mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        }*/
        
        if let image = incidentModel?.preview_thumbnail {
            loadImage(image, videoImageView, activity: nil, defaultImage: nil)
        }
    
        if let lat = incidentModel?.start_location?.latitude, let lon = incidentModel?.start_location?.longitude {
            let location = CLLocation.init(latitude: lat, longitude: lon)
            self.myLocation = location
            self.animateZoomLevel(zoom: 14)
            let marker = GMSMarker.init()
            marker.icon = UIImage.init(named: "pin_blue")
            
            marker.position = location.coordinate

            marker.map = self.mapView
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: mapImageView.frame.maxY)
        contentViewHeightConstraint.constant = mapImageView.frame.maxY
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    @objc func loadData() {
        if let videoUrl = incidentModel?.stream_url{
            if let url = URL.init(string: videoUrl) {
                if IncidentHistoryViewController.player != nil {
                    removePlayer()
                }else{
                    playVideo(url: url)
                }
            }
        }
    }
}









// MARK:- @IBActions
/**
 @Auther : Irshad Ahmad
 @Description : button actions
 */
extension IncidentHistoryViewController {
    
    @IBAction func closeButtonActions(_ sender: UIButton) {
        print("CLOSE BUTTON PRESSED - INCIDENTHISTORY_VC")
        self.removePlayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pauseButtonActions(_ sender: UIButton) {
        print("PAUSE BUTTON PRESSED - INCIDENTHISTORY_VC")
        if sender.isSelected {
            IncidentHistoryViewController.player?.play()
        }else{
            IncidentHistoryViewController.player?.pause()
        }
        sender.isSelected = !sender.isSelected
        sender.tintColor = UIColor.white
    }
    
    @IBAction func shareButtonActions(_ sender: UIButton) {
        print("SHARE BUTTON PRESSED - INCIDENTHISTORY_VC")
        // Handle contact button
        let contactsAction = UIAlertAction(title: "Contacts", style: .default, handler: { alert in
            self.navigationController?.isNavigationBarHidden = false
            // show share page
            let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
            newMessageVC.isShare = true
            newMessageVC.incident = self.incidentModel
            self.navigationController?.pushViewController(newMessageVC, animated: true)
        })
        // Handle organization button
        let organizationAction = UIAlertAction(title: "Organization", style: .default, handler: { alert in
            self.navigationController?.isNavigationBarHidden = false
            // show search organization
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isFromIncident = true
            allContactVC.incident = self.incidentModel
            self.navigationController?.pushViewController(allContactVC, animated: true)
        })
        // Handle other button
        let otherAction = UIAlertAction(title: "Other", style: .default, handler: { alert in
            let text = "This is the text...."
            let sharingObjects = [text]
            let activity = UIActivityViewController(activityItems: sharingObjects,
                                                    applicationActivities: nil)
            activity.excludedActivityTypes = [.airDrop, .addToReadingList, .postToFlickr, .copyToPasteboard, .saveToCameraRoll,
                                              .assignToContact, .openInIBooks, .postToWeibo, .postToTencentWeibo]
            self.present(activity, animated: true, completion: nil)
        })
        otherAction.setValue(UIColor(hexString: "a4aab3"), forKey: "titleTextColor")
        // Handle cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Show alert
        self.showActionSheet("Share", message: nil, actions: [cancelAction, contactsAction, organizationAction])
    }
    
    @IBAction func downloadButtonActions(_ sender: UIButton) {
        print("DOWNLOAD BUTTON PRESSED - INCIDENTHISTORY_VC")
        
        havePHPhotoLibraryAccess { [unowned self] (staus) in
            if staus == true {
                if let url = self.incidentModel?.stream_url {
                   saveVideoInGallery(awsUrl: url)
                }
                DispatchQueue.main.async {
                    self.showMessage("Downloading started...")
                }
            }else{
                DispatchQueue.main.async {
                    let msg = "We don't have access to use your Photo Library, kindly grant access in order to save incident video in your Photo Library."
                    showAlert(msg: msg, title: "Message", sender: self)
                }
            }
        }
        
    }
    
    @IBAction func moreButtonActions(_ sender: UIButton) {
        print("MORE BUTTON PRESSED - INCIDENTHISTORY_VC")
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] alert in
             self?.deleteIncident()
        })
        deleteAction.setValue(UIColor(hexString: "f53c3c"), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.showActionSheet(nil, message: nil, actions: [cancelAction, deleteAction])
    }
    
    
    func deleteIncident() {
        
        guard let id = incidentModel?.id else {return}
        let url = incidentDetailUrl(id: id)
        SwiftLoader.show(title: "Deleting...", animated: true)
        APIsHandler.DELETEApi(url, param: nil, header: header()) { [weak self] (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self?.removePlayer()
                self?.dismiss(animated: false) {
                    self?.moreButtonAction?()
                }
            }
        }
    }
    
    
}





// MARK:- COLLECTION VIEW
/**
 @Auther : Irshad Ahmad
 @Description : Video Player Work
 */
extension IncidentHistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResponderCollectionViewCell.incidentIdentifier, for: indexPath) as! ResponderCollectionViewCell
        
        if let img = responderList[indexPath.item].profile_image, img != "" {
            if img != "" {
                loadImage(img, cell.responderImageView, activity: nil, defaultImage: nil)
            }else{
                cell.responderImageView.image = UIImage.init(named: "userAvatar")
            }
        }else{
            cell.responderImageView.image = UIImage.init(named: "userAvatar")
        }
        return cell
    }
}




// MARK:- Play Audio/Video
/**
 @Auther : Irshad Ahmad
 @Description : Video Player Work
 */
extension IncidentHistoryViewController {
    
    /**
     @Auther : Irshad Ahmad
     @Description : play video from URL
     */
    func playVideo(url:URL) {
        IncidentHistoryViewController.player = AVPlayer.init(url: url)
        let interval = CMTime.init(value: 1, timescale: 2)
        
        IncidentHistoryViewController.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (time) in
            if IncidentHistoryViewController.player != nil {
                
                self?.activityIndicator?.stopAnimating()
                
                let seconds = CMTimeGetSeconds(time)
                let minutes = seconds/60
                
                var totalTimeSeconds = CMTimeGetSeconds(IncidentHistoryViewController.player!.currentItem!.duration)
                if totalTimeSeconds.isNaN {
                    totalTimeSeconds = CMTimeGetSeconds(IncidentHistoryViewController.player!.currentItem!.asset.duration)
                    if totalTimeSeconds.isNaN {
                        totalTimeSeconds = 0
                    }
                }
                
                let totalTimeMinutes = totalTimeSeconds/60
                
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(minutes.truncatingRemainder(dividingBy: 60)))
                
                let totalSecondsString = String(format: "%02d", Int(totalTimeSeconds.truncatingRemainder(dividingBy: 60)))
                let totalMinutesString = String(format: "%02d", Int(totalTimeMinutes.truncatingRemainder(dividingBy: 60)))
                
                self?.runTimeLabel.text = "\(minutesString):\(secondsString) / \(totalMinutesString):\(totalSecondsString)"
                
                //lets move the slider thumb
                
                self?.progressView.progress = Float(seconds / totalTimeSeconds)
                
                if seconds == totalTimeSeconds {
                    self?.removePlayer()
                }
            }
        }
        
        IncidentHistoryViewController.previewLayer = AVPlayerLayer.init(player: IncidentHistoryViewController.player!)
        IncidentHistoryViewController.previewLayer?.frame = videoImageView.bounds
        IncidentHistoryViewController.previewLayer?.videoGravity = .resizeAspectFill
        self.videoImageView.layer.addSublayer(IncidentHistoryViewController.previewLayer!)
        IncidentHistoryViewController.player?.play()
    }
    
    /**
     @Auther : Irshad Ahmad
     @Description : remove Player Item
     */
    func removePlayer() {
        IncidentHistoryViewController.previewLayer?.removeFromSuperlayer()
        IncidentHistoryViewController.player?.pause()
        IncidentHistoryViewController.player?.replaceCurrentItem(with: nil)
        IncidentHistoryViewController.player = nil
    }

}









// MARK:- APIs
/**
 @Auther : Irshad Ahmad
 @Description : APIs Call
 */
extension IncidentHistoryViewController {
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : get incident details from server
     */
    func getIncidentDetail() {
        
        guard let id = incident_id else {return}
        let url = incidentDetailUrl(id: id)
        
        SwiftLoader.show(title: "Loading...", animated: true)
        APIsHandler.GETApi(url, param: nil, header: header()) { [unowned self] (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Message", sender: self)
            }else if let json = response, let code = statusCode {
                print(json,code)
                //self.incidentDetail = IncidentDetailModel(json: json)
                
            }
        }
    }
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : get joined responder list  from server
     */
    func getResponderList() {
        
        guard let id = self.incidentModel?.id else {return}
        
        let url = BASE_URL + Incident.JOINED_RESPONDER_LIST + "?IncidentId=\(id)"
        
        //SwiftLoader.show(title: "Loading...", animated: true)
        
        APIsHandler.GETApi(url, param: nil, header: header()) { [unowned self] (response, error, statusCode) in
            
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 200 {
                    self.responders = Responders.init(json: json)
                    self.responderList.append(contentsOf: self.responders?.emergency_contacts ?? [])
                    self.responderList.append(contentsOf: self.responders?.organization_contacts ?? [])
                    self.collectionView.reloadData()
                    let count = self.responders?.emergency_contacts?.count ?? 0
                    self.emergencyContactsCountLabel.text = "\(count) Emerg. Contacts"
                    self.plotRepondersOnMap()
                }
            }
        }
    }

    
}








/**
 @Auther : Irshad Ahmad
 @Description : GMSMapViewDelegate & Map related Works
 */
extension IncidentHistoryViewController:GMSMapViewDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            self.myLocation = location
            mapView?.removeObserver(self, forKeyPath: "myLocation")
            self.animateZoomLevel(zoom: 14)
        }
    }
    
    @objc func animateZoomLevel(zoom:CGFloat) {
        
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = zoom
        zoomAnimation.duration = CFTimeInterval(2.5)
        
        mapView?.layer.add(zoomAnimation, forKey: nil)
        perform(#selector(updateCamera), with: nil, afterDelay: 2.3)
    }
    
    @objc func  updateCamera() {
        guard let loc = self.myLocation else {return}
        let camera = GMSCameraPosition.camera(withLatitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, zoom: 17.0)
        mapView.camera = camera
    }
    
    
    func plotRepondersOnMap() {
        
        let emergency_conacts = responders?.emergency_contacts ?? []
        let organization_contacts = responders?.organization_contacts ?? []
        
        for (_, obj) in emergency_conacts.enumerated() {

            let marker = GMSMarker.init()
            marker.icon = UIImage.init(named: "pin")
            marker.title = obj.name
            marker.snippet = obj.organization
            marker.isTappable = true
            
            if let location =  obj.end_location?.location?.coordinate{
                //let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                marker.position = location
            }
            
            marker.map = self.mapView
        }
    
        for (_, obj) in organization_contacts.enumerated() {

            let marker = GMSMarker.init()
            marker.icon = UIImage.init(named: "pin")
            marker.title = obj.name
            marker.snippet = obj.organization
            marker.isTappable = true
            
            if let lat = obj.latitude, let long = obj.longitude  {
                let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                marker.position = location
            }
            marker.map = self.mapView
        }
        
        
        let obj =  organization_contacts.first
        
        if let location = emergency_conacts.first?.end_location?.location?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 14.0)
            mapView.camera = camera
        }else if let lat = obj?.latitude, let long = obj?.longitude  {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
    }
}







func havePHPhotoLibraryAccess(_ completion:@escaping(_ status:Bool)->Void) {
    let status = PHPhotoLibrary.authorizationStatus()
    if status == .notDetermined {
        PHPhotoLibrary.requestAuthorization { (newStatus) in
            if newStatus == .authorized {
                completion(true)
            }else if newStatus == .restricted || newStatus == .denied{
                completion(false)
            }
        }
    }else if status == .authorized {
        completion(true)
    }else if status == .restricted || status == .denied{
        completion(false)
    }
}
