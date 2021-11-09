//
//  IncidentDetailModel.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 11/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.



import UIKit
import GoogleMaps
import WebRTC
import Starscream
import SwiftyJSON

/**
 @Auther : Irshad Ahmad
 @Class Description : Ongoing Incident Details Class
 */
class OngoingIncidentViewController: UIViewController {
    
    /**
     @Auther : Irshad Ahmad
     @Description : Main IBOutlets
     */
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var incidentImageView: UIImageView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var talkButton: UIButton!
    @IBOutlet weak var talkLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var navigateLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userNameImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var incidentIDLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    /**
     @Auther : Irshad Ahmad
     @Description : From dispatch home IBoutlets
     */
    @IBOutlet weak var actionDispatchStackView: UIStackView!
    @IBOutlet weak var messageDispatchButton: UIButton!
    @IBOutlet weak var muteDispatchButton: UIButton!
    @IBOutlet weak var numberRespondersLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var streamView:UIView!
    @IBOutlet weak var myStreamView:MyStreamView!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : Google MapView
     */
    @IBOutlet weak var mapView: GMSMapView!{
        didSet{
            if mapView != nil {
                mapView.isMyLocationEnabled = false
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
    
    /**
     @Auther : Irshad Ahmad
     @Description : variables
     */
    var isDispatchHome = false
    var incidentDetail:IncidentDetailModel?
    var myLocation:CLLocation?
    let client: AntMediaClient? = AntMediaClient.init()
    var incident:OngoingIncidentModel?
    var webSocket:WebSocket?
    
    var reporterPin:GMSMarker?
    var reporter_ETA_Marker:GMSMarker?
    var polyline:GMSPolyline?
    var reporterLoc:CLLocation?
    
    let pinView = ReporterPinView.view()
    var incident_time:Int16 = 0
    var incident_timer:Timer!
    var locationUpdateTimer:Timer?
    var socketTimer:Timer?
    var isDataSendedInSocket = false
    
    deinit {
        print("⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎ deniniting OngoingIncidentViewController ⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎")
    }
}





/**
 @Auther : Irshad Ahmad
 @Description : View Life Cycle
 */
extension OngoingIncidentViewController {
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        addPanGesture()
        
        if CLLocationManager.locationServicesEnabled() {
            mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        }
        
        initSocket()
        self.myStreamView.ongoingIncidentVC = self
        myStreamView.layer.cornerRadius = 5.0
        myStreamView.clipsToBounds = true
        pinView.iconImage?.image = UIImage(named:"pin_blue")
        getIncidentDetail()
        
        self.myLocation = appDelegate.currentLocation
        perform(#selector(animateZoomLevel(zoom:)), with: 14, afterDelay: 0.5)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isDispatchHome {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        streamView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        userNameImageView.roundRadius()
    }
    
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : PRIVATE ACTIONS
     */
    private func prepareUI() {
        // Set radius for view
        inProgressButton.roundRadius()
        userNameImageView.roundRadius()
        liveButton.roundRadius()
        containerView.layer.cornerRadius = 15
        incidentImageView.layer.cornerRadius = 21
        
        // Set shadow
        liveButton.titleLabel?.layer.applySketchShadow(color: UIColor.white.withAlphaComponent(0.5), alpha: 1, x: 0, y: 1, blur: 0, spread: 0)
        
        shareButton.isHidden = isDispatchHome
        numberRespondersLabel.isHidden = !isDispatchHome
        collectionView.isHidden = !isDispatchHome
        actionDispatchStackView.isHidden = !isDispatchHome
        talkButton.setImage(UIImage(named: isDispatchHome ? "ARView" : "mic"), for: .normal)
        messageButton.setImage(UIImage(named: isDispatchHome ? "liveFeed" : "message-incident"), for: .normal)
        navigateButton.setImage(UIImage(named: isDispatchHome ? "faceId-dispatch" : "navigation"), for: .normal)
        phoneNumberButton.setImage(UIImage(named: isDispatchHome ? "more-dispatch" : "call"), for: .normal)
        talkLabel.text = isDispatchHome ? "AR View" : "Talk"
        messageLabel.text = isDispatchHome ? "Live Feed" : "Message"
        navigateLabel.text = isDispatchHome ? "Face ID" : "Navigate"
        phoneNumberLabel.text = isDispatchHome ? "More" : "911"
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
    
    private func addPanGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeDown.direction = .down
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = .up
        containerView.addGestureRecognizer(swipeDown)
        containerView.addGestureRecognizer(swipeUp)
    }
}







/**
 @Auther : Irshad Ahmad
 @Description : UISwipeGestureRecognizer Action
 */
extension OngoingIncidentViewController {
    
    // MARK: - ACTIONS
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            containerViewBottomConstraint.constant = -(containerView.frame.height - incidentImageView.frame.origin.y - bottomContainerView.frame.height)
            incidentImageView.layer.cornerRadius = 30
            if isDispatchHome {
                messageDispatchButton.alpha = 0
                muteDispatchButton.alpha = 0
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }
        } else if gesture.direction == .up {
            containerViewBottomConstraint.constant = 0
            incidentImageView.layer.cornerRadius = 21
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }) { (finished) in
                if self.isDispatchHome {
                    self.messageDispatchButton.alpha = 1
                    self.muteDispatchButton.alpha = 1
                }
            }
        }
    }
}








/**
 @Auther : Irshad Ahmad
 @Description : IBActions
 */
extension OngoingIncidentViewController {
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        print("CLOSE BUTTON  PRESSED - ONGOINGINCIDENT_VC")
        if isDispatchHome {
            navigationController?.popViewController(animated: false)
        } else {
            if let _ = incident_timer {
                incident_timer.invalidate()
                incident_timer = nil
            }
            if let _ = locationUpdateTimer {
                locationUpdateTimer?.invalidate()
                locationUpdateTimer = nil
            }
            if let _ = socketTimer {
                socketTimer?.invalidate()
                socketTimer = nil
            }
            self.myStreamView.session.stopLive()
            self.myStreamView.removeFromSuperview()
//            if self.client?.webSocket.isConnected == true {
            if self.client?.isConnected() == true {
                self.client?.stop()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        // Handle contact button
        let contactsAction = UIAlertAction(title: "Contacts", style: .default, handler: { alert in
            self.navigationController?.isNavigationBarHidden = false
            // show share page
            let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
            newMessageVC.isShare = true
            newMessageVC.incident = self.incident
            self.navigationController?.pushViewController(newMessageVC, animated: true)
        })
        // Handle organization button
        let organizationAction = UIAlertAction(title: "Organization", style: .default, handler: { alert in
            self.navigationController?.isNavigationBarHidden = false
            // show search organization
            let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
            allContactVC.isFromIncident = true
            allContactVC.incident = self.incident
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
    
    @IBAction func inProgressButtonAction(_ sender: UIButton) {
        print("IN PROGRESS BUTTON PRESSED - ONGOINGINCIDENT_VC")
    }
    
    @IBAction func liveButtonAction(_ sender: UIButton) {
        print("LIVE BUTTON  PRESSED - ONGOINGINCIDENT_VC")
    }
    
    @IBAction func talkButtonAction(_ sender: UIButton) {
        print("TALK BUTTON  PRESSED - ONGOINGINCIDENT_VC")
        if isDispatchHome {
            let arViewVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "ARViewVC") as! ARViewViewController
            navigationController?.pushViewController(arViewVC, animated: true)
        }else{
            sender.isSelected = !sender.isSelected
            self.myStreamView.session.muted = sender.isSelected
        }
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        print("MESSAGE BUTTON  PRESSED - ONGOINGINCIDENT_VC")
        if isDispatchHome {
            let liveFeedsVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "LiveFeedsVC") as! LiveFeedsViewController
            navigationController?.pushViewController(liveFeedsVC, animated: true)
        } else {
            let chatNC = StoryboardManager.homeStoryBoard().getController(identifier: "ChatNC-ID") as! UINavigationController
            chatNC.modalPresentationStyle = .overCurrentContext
            let chatVC = chatNC.topViewController as! ChatViewController
            // Handle `end` button
            chatVC.endButtonAction = {
                // Show active incident page
                /*let activeIncidentVC = StoryboardManager.homeStoryBoard().getController(identifier: "ActiveIncidentVC") as! ActiveIncidentViewController
                activeIncidentVC.modalPresentationStyle = .overCurrentContext
                // Handle `continue` button
                activeIncidentVC.continueButtonAction = {
                    let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                    mainTabBarVC.defaultIndex = 2
                    self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                }
                self.present(activeIncidentVC, animated: false, completion: nil)*/
            }
            present(chatNC, animated: false, completion: nil)
        }
    }
    
    @IBAction func navigateButtonAction(_ sender: UIButton) {
        print("NAVIGATE BUTTON ACTION PRESSED - ONGOINGINCIDENT_VC")
        if isDispatchHome {
            let facialRecognitionVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "FacialRecognitionVC") as! FacialRecognitionViewController
            navigationController?.pushViewController(facialRecognitionVC, animated: true)
        }else{
            if let loc1 = myLocation, let loc2 = reporterLoc {
                fetchRoute(from: loc1.coordinate, to: loc2.coordinate)
            }
        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        if let url = URL(string: "tel://911") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func messageDispatchButtonAction(_ sender: UIButton) {
        print("MESSAGE DISPATCH BUTTON ACTION PRESSED - ONGOINGINCIDENT_VC")
    }
    
    @IBAction func muteDispatchButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.myStreamView.session.muted = sender.isSelected
    }
}








/**
 @Auther : Irshad Ahmad
 @Description : UITableViewDataSource
 */
extension OngoingIncidentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlyImageCollectionViewCell.dispatchIncidentAccept, for: indexPath) as! OnlyImageCollectionViewCell
        return cell
    }
}








/**
 @Auther : Irshad Ahmad
 @Description : UICollectionViewDelegateFlowLayout
 */
extension OngoingIncidentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        return CGSize(width: size, height: size)
    }
}







/**
 @Auther : Irshad Ahmad
 @Description : APIs Call
 */
extension OngoingIncidentViewController {
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : get incident details from server
     */
    func getIncidentDetail() {
        
        guard let id = incident?.id else {return}
        let url = incidentDetailUrl(id: id)
        SwiftLoader.show(title: "Fetching...", animated: true)
        APIsHandler.GETApi(url, param: nil, header: header()) { [unowned self] (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Message", sender: self)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.incidentDetail = IncidentDetailModel(json: json)
                self.updateUIWithData()
            }
        }
    }
    
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : show info in UI
     */
    func updateUIWithData() {
        userNameLabel.text = incidentDetail?.user?.first_name
        if let profile = incidentDetail?.user?.profile_logo {
            let defaultImg = UIImage.init(named: "userAvatar")
            loadImage(profile, userNameImageView, activity: nil, defaultImage: defaultImg)
        }
        
        // Set Attributed Texts in Labels
        let emergency_message = incidentDetail?.emergency_message ?? ""
        reportLabel.attributedText      = attributeTetx(label: reportLabel,
                                                        text: "Report: \(emergency_message)",
            rangeText: "\(emergency_message)")
        
        let id = incidentDetail?.id ?? ""
        incidentIDLabel.attributedText  = attributeTetx(label: incidentIDLabel,
                                                        text: "Incident ID: \(id)",
            rangeText: "\(id)")
        
        let start_time = incidentDetail?.broadcast_start_time?.toIncidentDate()?.toIncidentTimeStr() ?? ""
        startTimeLabel.attributedText   = attributeTetx(label: startTimeLabel,
                                                        text: "Started: \(start_time)",
            rangeText: "\(start_time)")
        
        
        let level = "High"
        levelLabel.attributedText       = attributeTetx(label: levelLabel,
                                                        text: "Level: \(level)",
            rangeText: "\(level)",
            color: UIColor(hexString: "FF4646"))
        
        self.loadLiveStream()
//        self.myStreamView.enable2WayCommunication()
        incident_time = incidentDetail?.broadcast_start_time?.toIncidentDate()?.getElapsedIntervalTimeOnly1() ?? 0
        
        if incident?.is_ended == true || incident?.is_stopped == true {
            inProgressButton.setTitle("Closed", for: .normal)
        }else{
            startIncidentTimer()
            startUpdatingMyLocationToDB()
        }
    }
    
    
    func startIncidentTimer() {
        incident_timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.incident_time += 1
            let seconds = Float64(self.incident_time)
            let minutes = Float64(self.incident_time)/60
    
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%02d", Int(minutes.truncatingRemainder(dividingBy: 60)))
            
            self.timeLabel.text = "\(minutesString):\(secondsString)"
        })
    }
    
    @objc func startUpdatingMyLocationToDB() {
        self.updateMyLocationToReporter()
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [weak self](timer) in
            self?.updateMyLocationToReporter()
        })
    }
}







/**
 @Auther : Irshad Ahmad
 @Description : GMSMapViewDelegate & Map related Works
 */
extension OngoingIncidentViewController:GMSMapViewDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            self.myLocation = location
            mapView?.removeObserver(self, forKeyPath: "myLocation")
            perform(#selector(animateZoomLevel(zoom:)), with: 14, afterDelay: 0.2)
        }
    }
    
    @objc func animateZoomLevel(zoom:CGFloat) {
    
        let marker = GMSMarker.init()
        marker.icon = UIImage.init(named: "pin")
        if let location = self.myLocation {
            marker.position = location.coordinate
        }
        marker.map = self.mapView
    
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = zoom
        zoomAnimation.duration = CFTimeInterval(2.5)
        
        mapView?.layer.add(zoomAnimation, forKey: nil)
        perform(#selector(updateCamera), with: nil, afterDelay: 2.0)
    }
    
    @objc func  updateCamera() {
        guard let loc = self.myLocation else {return}
        let camera = GMSCameraPosition.camera(withLatitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, zoom: 17.0)
        mapView.camera = camera
        
    }
    
}







/**
 @Auther : Irshad Ahmad
 @Description : Stream related Work
 */
extension OngoingIncidentViewController:AntMediaClientDelegate {
    
    //637116550315704320
    
    func loadLiveStream() {
        
        let id = incident?.streaming_id ?? ""
        let clientURL = "wss://antmedia.samscloud.io:5443/WebRTCAppEE/websocket"

        self.client?.delegate = self
        self.client?.setDebug(true)
        self.client?.setVideoEnable(enable: true)
        self.client?.setOptions(url: clientURL, streamId: id, token: "", mode: .play, enableDataChannel: true)
        self.client?.setRemoteView(remoteContainer: streamView, mode: .scaleAspectFill)
        self.client?.initPeerConnection()
        self.client?.start()
        
    /*
        let id = incident?.streaming_id ?? ""
        self.client?.delegate = self
        self.client?.setVideoEnable(enable: true)
        self.client?.setDebug(true)
        let url = "wss://antmedia.samscloud.io:5443/WebRTCAppEE/websocket"
        self.client?.setOptions(url: url, streamId: id, token: "", mode: .play)
        self.client?.setRemoteView(remoteContainer: streamView, mode: .scaleAspectFill)
//        self.client?.setScaleMode(mode: .scaleAspectFill)
        self.client?.connectWebSocket()
    */
    }
    
    func clientDidConnect(_ client: AntMediaClient) {
        print("OngoingIncidentViewController: Client Connected")
//        self.client?.start()
    }
    
    func clientDidDisconnect(_ message: String) {
        print("OngoingIncidentViewController: Disconnected: \(message)")
    }
    
    func clientHasError(_ message: String) {
        print("*** OngoingIncidentViewController: ERROR ***")
        print(message)
    }
    
    
    func disconnected() {
        print("OngoingIncidentViewController: disconnected")

    }
    
    func remoteStreamStarted() {
        print("OngoingIncidentViewController: Remote stream started")
    }
    
    func remoteStreamRemoved() {
        print("*** ERROR ***")
        print("OngoingIncidentViewController: Remote stream is no longer available")
    }
    
    func localStreamStarted() {
        print("OngoingIncidentViewController: Local stream added")
    }
    
    
    func playStarted(){
        print("OngoingIncidentViewController: play started")
    }
    
    func playFinished() {
        print("OngoingIncidentViewController: *** playFinished ***")
    }
    
    func publishStarted() {
        print("OngoingIncidentViewController: publish Started")
    }
    
    func publishFinished() {
        print("OngoingIncidentViewController: publish Finished")
    }
    
    func audioSessionDidStartPlayOrRecord() {
        print("OngoingIncidentViewController:  audioSessionDidStartPlayOrRecord")
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        print("OngoingIncidentViewController:   dataReceivedFromDataChannel")
    }
}














extension OngoingIncidentViewController:WebSocketDelegate,WebSocketAdvancedDelegate {
    
    func websocketDidConnect(socket: WebSocket) {
        print("webSocketDidConnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String, response: WebSocket.WSResponse) {
        print("websocketDidReceiveMessage")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data, response: WebSocket.WSResponse) {
        print("websocketDidReceiveData")
    }
    
    func websocketHttpUpgrade(socket: WebSocket, request: String) {
        
    }
    
    func websocketHttpUpgrade(socket: WebSocket, response: String) {
        
    }
    
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("webSocketDidOpen")
        pingIntoSocket()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: Error?){
        
        print("websocketDidDisconnect ------  webSocket")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
        print("websocketDidDisconnect ------  webSocket")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        guard let dict = convertToDictionary(text: text) else {return}
        guard let action = dict["action"] as? String else {return}
        if action == "reporter_location_update" {
            let latitudeStr = dict["latitude"] as? String ?? ""
            let latitude = Double(latitudeStr) ?? 0
            
            let longtitudeStr = dict["longitude"] as? String ?? ""
            let longitude = Double(longtitudeStr) ?? 0
            
            let speedStr =  dict["speed"] as? String ?? ""
            var speed = (Float(speedStr) ?? 0)*2.23694 // Miles per hour
            if speed < 0 {speed = 0}
            
            print("Latitude ----- >>>",latitude)
            print("Longtitude ----- >>>",longitude)
            print("Speed ----- >>>",speed)
            
            speedLabel.text = String(format: "SPEED: %.2fmph", speed)
            
            self.reporterLoc = CLLocation.init(latitude: latitude, longitude: longitude)
            if let location1 = self.myLocation {
                let distance = location1.distance(from: reporterLoc!)/1609.34 // in miles
                distanceLabel.text = String(format: "DIST: %.2fmi", distance)
            }
            
            if reporter_ETA_Marker == nil {
                addMarkerToMap()
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData",data)
    }
    
    
    func initSocket() {
        guard let id = self.incident?.id else {
            return
        }
        let str = "wss://api.samscloud.io/wss/\(id)/incident/"
        guard let url = URL.init(string: str) else {return}
        webSocket = WebSocket.init(url: url)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
    
    func pingIntoSocket() {
        socketTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [unowned self] (timer) in
            if let data = try? JSON.init(["ping":"pong"]).rawData() {
                if self.webSocket?.isConnected == true {
                    self.webSocket?.write(ping: data)
                }
            }
        }
    }
    
}














/**
 @Auther : Irshad Ahmad
 @Description : GMSMapViewDelegate & Map related Works
 */
extension OngoingIncidentViewController {
    
    
    func addMarkerToMap() {
        
        if reporter_ETA_Marker == nil {
            self.reporter_ETA_Marker = GMSMarker.init()
        }
        
        pinView.detailsView?.isHidden = true
        reporter_ETA_Marker?.iconView = pinView
        
        if let lat = reporterLoc?.coordinate.latitude, let long = reporterLoc?.coordinate.longitude {
            let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
            reporter_ETA_Marker?.position = location
            let position = GMSCameraPosition.init(target: location, zoom: 15)
            UIView.animate(withDuration: 0.33) {
                self.mapView.animate(to: position)
            }
        }
        
        reporter_ETA_Marker?.map = self.mapView
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(GoogleApiKey)")!
        
        SwiftLoader.show(title: "Finding Path...", animated: true)
        
        let task = session.dataTask(with: url, completionHandler: {
            [unowned self] (data, response, error) in
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
            }
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            
            guard let route = routes.first as? [String: Any] else {
                return
            }
            
            print(JSON.init(route))
            
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            DispatchQueue.main.async {
                
                let loc1 = CLLocation.init(latitude: source.latitude, longitude: source.longitude)
                let loc2 = CLLocation.init(latitude: destination.latitude, longitude: destination.longitude)
                let distanceBetween:Float = Float(loc1.distance(from: loc2)/1609.34)
                
                var zooom:Float = 14
                
                if distanceBetween > 5 {
                    zooom += (distanceBetween)/10
                }else{
                    zooom = 13 + (5 - distanceBetween)/2
                }
                if zooom > 16 {zooom = 16}
                
                let position = GMSCameraPosition.init(target: destination, zoom: zooom)
                UIView.animate(withDuration: 0.33) {
                    self.mapView.animate(to: position)
                }
                self.drawPath(from: polyLineString)
            }
            
            guard let legs = route["legs"] as? [Any] else {
                return
            }
            
            guard let leg = legs[0] as? [String: Any] else {
                return
            }
            
            guard let duration = leg["duration"]  as? [String: Any] else {
                return
            }
            
            let durationStr = duration["value"] as? Float ?? 0
            let value = (durationStr/3600)
            let valueStr = String.init(format: "%.2f", value)
            
            //Call this method to draw path on map
            DispatchQueue.main.async {
                if value >= 1 {
                    self.pinView.minuteLablel?.text = "hours"
                    self.pinView.numberLablel?.text = valueStr
                    self.etaLabel.text = "ETA: \(valueStr) hours"
                }else{
                    let value = (durationStr/60)
                    let valueStr = String.init(format: "%.2f", value)
                    self.pinView.minuteLablel?.text = "minutes"
                    self.etaLabel.text = "ETA: \(valueStr) minutes"
                    self.pinView.numberLablel?.text = valueStr
                }
            }
            guard let end_address = leg["end_address"]  as? String else {
                return
            }
            let list = end_address.components(separatedBy: ", ")
            DispatchQueue.main.async {
                self.pinView.cityLablel?.text = list.first
                self.pinView.detailsView?.isHidden = false
            }
            
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        polyline = GMSPolyline(path: path)
        polyline?.strokeWidth = 2.0
        polyline?.strokeColor = .white
        polyline?.map = mapView
    }
    
    
    private func set(polyline: GMSPolyline, on mapView: GMSMapView) {
        guard let path = polyline.path else {
            return
        }
        //mapView.clear()
        let intervalDistanceIncrement: CGFloat = 10
        let circleRadiusScale = 1 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        var previousCircle: GMSCircle?
        for coordinateIndex in 0 ..< path.count() - 1 {
            let startCoordinate = path.coordinate(at: coordinateIndex)
            let endCoordinate = path.coordinate(at: coordinateIndex + 1)
            let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
            let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
            let pathDistance = endLocation.distance(from: startLocation)
            let intervalLatIncrement = (endLocation.coordinate.latitude - startLocation.coordinate.latitude) / pathDistance
            let intervalLngIncrement = (endLocation.coordinate.longitude - startLocation.coordinate.longitude) / pathDistance
            for intervalDistance in 0 ..< Int(pathDistance) {
                let intervalLat = startLocation.coordinate.latitude + (intervalLatIncrement * Double(intervalDistance))
                let intervalLng = startLocation.coordinate.longitude + (intervalLngIncrement * Double(intervalDistance))
                let circleCoordinate = CLLocationCoordinate2D(latitude: intervalLat, longitude: intervalLng)
                if let previousCircle = previousCircle {
                    let circleLocation = CLLocation(latitude: circleCoordinate.latitude,
                                                    longitude: circleCoordinate.longitude)
                    let previousCircleLocation = CLLocation(latitude: previousCircle.position.latitude,
                                                            longitude: previousCircle.position.longitude)
                    if mapView.projection.points(forMeters: circleLocation.distance(from: previousCircleLocation),
                                                 at: mapView.camera.target) < intervalDistanceIncrement {
                        continue
                    }
                }
                let circleRadius = 3 * CLLocationDistance(circleRadiusScale)
                let circle = GMSCircle(position: circleCoordinate, radius: circleRadius)
                circle.map = mapView
                //circle.strokeWidth = 1.5
                //circle.strokeColor = .white
                previousCircle = circle
            }
        }
    }
    
}











extension OngoingIncidentViewController {
    
    @objc func updateMyLocationToReporter() {
        
        
        guard let id = incident?.id else {return}
        guard let latitude = mapView.myLocation?.coordinate.latitude else {return}
        guard let longitude = mapView.myLocation?.coordinate.longitude else {return}
        guard let altitude = mapView.myLocation?.altitude else {return}
    
        let url = BASE_URL + Incident.RESPONDER_LOCATION_UPDATE
        
        let param:[String:Any] = [
            "incident_id": "\(id)",
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "altitude": "\(altitude)",
            "uuid": incident?.contact_uuid ?? ""
        ]
        
        APIsHandler.POSTApi(url, param: param, header: header()) { [unowned self] (response, error, statusCode) in
            if let err = error {
                showAlert(msg: err.localizedDescription, title: "Error", sender: self)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 200 {
                    if self.isDataSendedInSocket == false{
                        self.isDataSendedInSocket = true
                        self.perform(#selector(self.sendDataInSocket), with: nil, afterDelay: 2.0)
                    }
                }
            }
        }
    }
    
    
    @objc func sendDataInSocket() {
        
        guard let id = self.incident?.id else { return }
        let name = DefaultManager().getName() ?? ""
        
        let params:[String:String] = [
            "uuid":incident?.contact_uuid ?? "",
            "incident_id": id,
            "action":"conference_room",
            "stream_id":self.myStreamView?.myStreamID ?? "",
            "type":"joined",
            "responder_name":name
        ]
        
        let data = stringify(json: params)
        
        print(data)
        
        if webSocket?.isConnected == true {
            webSocket?.write(string: data)
        }else{
            self.perform(#selector(sendDataInSocket), with: nil, afterDelay: 0.5)
        }
        
    }
    
}
