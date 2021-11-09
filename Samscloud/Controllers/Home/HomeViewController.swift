//
//  HomeViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import AVFoundation
//import WowzaGoCoderSDK
import CoreLocation
import GoogleMaps
import SwiftyJSON
import SnapKit
import LFLiveKit

class HomeViewController: UIViewController {
    
    
    // MARK:- ANT MEDIA
    var streamUrl: String!
    var streamName: String!
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.medium3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.adaptiveBitrate = true
        return session!
    }()
    
    
    var blackAndWhiteVideoEffect = false
    var bitmapOverlayVideoEffect = false
    var goCoderRegistrationChecked = false
    var usingFrontCamera = false
    var isLargeVideo = false
    
    var takePhoto = false
    var isFromDispatchSOSResponder = false
    var isShowMenuPage = false
    var ischeck = false
    
    let SDKSampleSavedConfigKey = "SDKSampleSavedConfigKey"
    let SDKSampleAppLicenseKey = "GOSK-0747-010C-2C0F-FBB1-0C00"
    
    //"GOSK-0347-010C-1895-C258-CFF4"
    //"GOSK-C246-010C-E608-83D9-7AEF"
    //"PLAY2-3fyuz-x6xGG-vG6Bt-QrJcW-Gc4nj"
    //"PLAY2-9nUk8-EaujY-Vv96C-cyye9-JRKrj"
    //"GOSK-C246-010C-E608-83D9-7AEF"
    //"PLAY2-9nUk8-EaujY-Vv96C-cyye9-JRKrj"
    
    let BlackAndWhiteEffectKey = "BlackAndWhiteEffectKey"
    let BitmapOverlayEffectKey = "BitmapOverlayEffectKey"
    let BitmapOverlayKey = "BitmapOverlayKey";
    let BlackAndWhiteKey =  "BlackAndWhiteKey";
    
    var captureSession:AVCaptureSession? = AVCaptureSession()
    var previewLayer: CALayer?
    var captureDevice: AVCaptureDevice?
    var gesture = UIPanGestureRecognizer()
    
    
    var minX: CGFloat = 3.5
    var maxX: CGFloat = 0
    var activeShooterImageY: CGFloat = 0.0
    
    var wowzaStreamModel:WowzaStreamModel?
    var incidentModel:HomeIncidentModel?
    var locationMarker = GMSMarker.init()
    
    var innerlocationMarker = GMSMarker.init()
    var responders:Responders?
    var actionType = ""
    
    var emergencyContacts:Responders?
    
    var address:String?
    var responderMarkers = [GMSMarker]()
    var polyline:GMSPolyline?
    
    var fullFrame:CGRect!
    var smallFrame:CGRect!
    var finalActiveShooterFrame:CGRect?
    
    var responderPinViews = [ResponderPinView]()
    
    var selectedPinIndex:Int = -1
    var layer = PulsingHaloLayer()
    var organizationList = [OrganizationModel]()
    
    var googleOrgImgUrl:String?
    var samsOrgImgUrl:String?
    
    var streamId:String? = "\(Date().ticks)"
    
    var conferrenceRoomData = [RespondersConferenceRoom]()
    var locationUpdateTimer:Timer?
    
    
    @IBOutlet weak var responderStreamCollection: UICollectionView!
    
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var bitmapOverlayImgView: UIImageView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var responderButton: UIButton!
    @IBOutlet weak var responderLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var shakeContainerView: UIView!
    @IBOutlet weak var shakeSwitch: UISwitch!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var startResponderButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var hideLabel: UILabel!
    @IBOutlet weak var activeShooterView: UIView!
    @IBOutlet weak var activeShooterImageView: UIImageView!
    @IBOutlet weak var activeShooterLabel: UILabel!
    
    
    @IBOutlet weak var switchView: UIView!
    
    
    @IBOutlet weak var slideToActivateLabel: UILabel!
    @IBOutlet weak var backgroundActiveShooterView: UIView!
    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
    
    // IBOutlet when finish video
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var activeInvidentLabel: UILabel!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var standByButton: UIButton!
    @IBOutlet weak var standByLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var smallViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bigViewWidthConstraint: NSLayoutConstraint!
    
    // IBOutlet when click standBy button
    @IBOutlet weak var responderCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var noAudioButton: UIButton!
    
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var pulseImgView: UIImageView!
    @IBOutlet weak var pinImgView: UIImageView!
    
    @IBOutlet var bigCameraViewConstraints: [NSLayoutConstraint]!
    @IBOutlet var smallCameraViewConstraints: [NSLayoutConstraint]!
    
    
    @IBOutlet var bigMapViewConstraints: [NSLayoutConstraint]!
    var smallMapViewConstraints: [NSLayoutConstraint]! = []
    
    
    
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
    
    
    // MARKS:- Address Field
    @IBOutlet weak var lblAddressName: UILabel!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    var createIncidentModel:IncidentModel?
    
    var isPropertySet = false
    
    var resppnderCell:ResponderStreamCell?
    
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        responderStreamCollection.register(ResponderStreamCell.nib(), forCellWithReuseIdentifier: "ResponderStreamCell")
        
        appDelegate.requestForLocation()
        shakeSwitch.isOn = DefaultManager().getShake() ?? false
        
        
        //self.viewMain.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        
        switchView.backgroundColor = .white
        
        //createStreamAPI()
        getUserContacts()
        
        initAntMediaClient()
        
        //createIncident(message: "")
        
        checkInButton.isSelected = false
        checkInButton.backgroundColor = !checkInButton.isSelected ? UIColor(hexString: "0088ff") : UIColor.white
        
        collectionView.isHidden = true
        
        if appDelegate.currentLocation != nil {
            self.animateZoomLevel(zoom: 14)
        }
        
        self.setup1()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleInnerTap))
        innerView.addGestureRecognizer(tap)
        
        //startPlusing()
        hideButton.isHidden = true
        hideLabel.isHidden = true
        kAppDelegate.shakeFlag = DefaultManager().getShake() ?? false
        perform(#selector(getOrganizationList), with: nil, afterDelay: 0.5)
        perform(#selector(setupAntMedia), with: nil, afterDelay: 0.5)
        //perform(#selector(createIncident(message:)), with: " ", afterDelay: 0.5)
        perform(#selector(handleFrame), with: nil, afterDelay: 1.0)
        
//        if let addressOrg = appDelegate.addressNameStr {
//            lblAddressName.text = addressOrg
//        }
//        if let address = appDelegate.addressStr {
//            lblAddress.text = address
//        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            appDelegate.requestForLocation()
        }
    }
    
    func startPlusing() {
        layer.haloLayerNumber = 5
        layer.radius = 200
        layer.animationDuration = 10
        layer.backgroundColor = UIColor.lightGray.cgColor
        self.pulseImgView.layer.insertSublayer(layer, below: pulseImgView.layer)
        layer.start()
    }
    
    @objc func handleFrame() {
        fullFrame = viewMain.frame
        smallFrame = innerView.frame
    }
    
    @objc func handleInnerTap() {
        if switchView.frame == fullFrame {
            print("viewMain full")
            handleInnerMapTap()
        }else{
            print("mapView full")
            fullCameraView()
        }
        stopButton.isHidden = false
    }
    
    
    func fullCameraView() {
        
        //UIView.animate(withDuration: 0.33) {
        self.switchView.frame = self.fullFrame
        self.mapView.frame = self.smallFrame
        //}
        
        pinView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        self.innerView.isHidden = false
        self.standByLabel.isHidden = true
        self.contentLabel.isHidden =  true
        
        self.mapView.layer.cornerRadius = 4.0
        self.mapView.clipsToBounds = true
        switchView.layer.cornerRadius = 0
        
        
        if conferrenceRoomData.count > 0 {
            
        }
        
        responderStreamCollection.isHidden = false
        
        switchView.clipsToBounds = true
        liveImageView.isHidden = true
        activeInvidentLabel.isHidden = true
        
        mapView.isHidden = false
        mapView.center = innerView.center
        activeInvidentLabel.isHidden = false
        
        mapView.alpha = 1
        updateMapFrame()
        
        let count =  responders?.emergency_contacts?.count ?? 0
        
        if count > 0 {
            responderCountLabel.isHidden = true
            collectionView.isHidden = true
        }else{
            responderCountLabel.isHidden = true
        }
        
        //self.perform(#selector(updateMapFrame), with: nil, afterDelay: 0.10)
    }
    
    
    
    @objc func handleInnerMapTap() {
        
        if mapView.isHidden == true {return}
        
        self.pinView.transform = .identity
        
        let count =  responders?.emergency_contacts?.count ?? 0
        if count > 0 {
            responderCountLabel.isHidden = false
        }
        
        self.standByLabel.isHidden = (count > 0)
        self.contentLabel.isHidden =  (count > 0)
        self.showBigMapView()
        
        self.liveImageView.isHidden = false
        pinView.transform = .identity
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        if let img = DefaultManager().getImage(), img != "" {
            loadImage(img, pinImgView, activity: nil, defaultImage: nil)
            pinImgView.roundRadius()
            pinImgView.clipsToBounds = true
        }
        
        appDelegate.currentVC = self
        appDelegate.homeVC = self
        //prepareNavigation()
        
        if !isPropertySet {
            //self.setup2()
        }
        if CLLocationManager.locationServicesEnabled() {
            mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        }
        shakeSwitch.isOn = DefaultManager().getShake() ?? false
        //startPlusing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.goCoder?.cameraPreview?.stop()
        //self.layer._resume()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.lblAddressName.text = appDelegate.addressNameStr
                   self.lblAddress.text = appDelegate.addressStr
                   //        locationAPI()
                   locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true, block: { (timer) in
                       self.updateCamera()
                        appDelegate.startLocationUpdate()
                       //                   self.getCurrentAddress()
                       self.lblAddressName.text = appDelegate.addressNameStr
                       self.lblAddress.text = appDelegate.addressStr

                   })
        //setupAntMedia()
    }
    
    
    func showBigMapView() {
        
        //self.viewMain.isHidden = false
        self.mapView.isHidden = false
        self.standByLabel.isHidden = false
        
        self.contentLabel.isHidden = false
        self.innerView.isHidden = false
        
        startButton.isHidden = true
        responderButton.isHidden = true
        stopButton.isHidden = false
        
        shakeContainerView.isHidden = true
        
        switchView.layer.cornerRadius = 5.0
        switchView.clipsToBounds = true
        
        
        responderStreamCollection.isHidden = true
        
        //UIView.animate(withDuration: 0.33) {
        self.switchView.frame = self.smallFrame
        self.mapView.frame = self.fullFrame
        //self.goCoder?.cameraPreview?.previewLayer?.frame = self.switchView.bounds
        //}
        
        /*
         viewMain.snp.removeConstraints()
         mapView.snp.removeConstraints()
         mapView.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(self.view).offset(fullFrame.origin.y)
         make.left.equalTo(self.view).offset(0)
         make.size.equalTo(CGSize(width: fullFrame.size.width, height: fullFrame.size.height))
         }
         
         bigCameraViewConstraints.forEach({$0.isActive = false})
         viewMain.translatesAutoresizingMaskIntoConstraints = false
         
         viewMain.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(self.view).offset(innerView.frame.origin.y)
         make.width.equalTo(innerView.frame.width)
         make.height.equalTo(innerView.frame.height)
         make.centerWithinMargins.equalTo(innerView)
         }*/
        
        
        activeInvidentLabel.isHidden = false
        //viewMain.center = innerView.center
        
        let count =  responders?.emergency_contacts?.count ?? 0
        
        if count > 0 {
            responderCountLabel.isHidden = false
        }else{
            responderCountLabel.isHidden = true
        }
        
        self.standByLabel.isHidden = (count > 0)
        self.contentLabel.isHidden =  (count > 0)
        startButton.isHidden = true
        self.startResponderButton.isHidden = true
        
        //reShowSmallCameraView()
        //self.viewMain.setNeedsDisplay()
    }
    
    
    func reShowSmallCameraView() {
        
        /*viewMain.center = innerView.center
         viewMain.alpha = 0
         activeInvidentLabel.isHidden = false
         self.perform(#selector(updateFrame), with: nil, afterDelay: 0.10)
         self.viewMain.setNeedsDisplay()*/
    }
    
    
    func showSmallCameraView() {
        //viewMain.center = innerView.center
    }
    
    @objc func updateFrame() {
        /*
         viewMain.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(self.view).offset(innerView.frame.origin.y)
         make.width.equalTo(innerView.frame.width)
         make.height.equalTo(innerView.frame.height)
         make.centerWithinMargins.equalTo(innerView)
         }*/
        
        /*self.viewMain.center = self.innerView.center
         UIView.animate(withDuration: 0.10) {
         self.viewMain.alpha = 1
         }
         self.viewMain.setNeedsDisplay()*/
    }
    
    
    @objc func updateMapFrame() {
        self.mapView.center = self.innerView.center
        self.perform(#selector(updateMapAlpha), with: nil, afterDelay: 0.1)
    }
    
    
    @objc func updateMapAlpha() {
        //UIView.animate(withDuration: 0.22) {
        self.mapView.alpha = 1
        //}
    }
    
    func showBigCameraView() {
        //self.viewMain.isHidden = true
        self.standByLabel.isHidden = false
        self.contentLabel.isHidden = false
        activeInvidentLabel.isHidden = true
        
        if conferrenceRoomData.count > 0 {
            
        }
        responderStreamCollection.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        imgAddress.layer.cornerRadius = imgAddress.frame.width/2
        
        if !isPropertySet {
            fullFrame = viewMain.frame
            addSwitchView()
            isPropertySet = true
            //setPropertyAndCameraPreview()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //goCoder?.cameraPreview?.previewLayer?.frame = view.bounds
    }
    
    
    func addSwitchView() {
        
        switchView.frame = fullFrame
        mapView.frame = fullFrame
        self.view.addSubview(mapView)
        self.view.addSubview(switchView)
        self.view.bringSubviewToFront(activeShooterView)
        self.view.bringSubviewToFront(innerView)
        
        self.view.bringSubviewToFront(collectionView)
        self.view.bringSubviewToFront(contentLabel)
        self.view.bringSubviewToFront(standByLabel)
        self.view.bringSubviewToFront(responderCountLabel)
        self.view.bringSubviewToFront(responderStreamCollection)
        
        //goCoder?.cameraView = switchView
        //goCoder?.cameraPreview?.start()
    }
    
    
    
    @objc func handleTappp() {
        
        if switchView.frame == fullFrame {
            //UIView.animate(withDuration: 0.33) {
            self.switchView.frame = self.smallFrame
            //}
        }else{
            //UIView.animate(withDuration: 0.33) {
            self.switchView.frame = self.fullFrame
            //}
        }
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    
    func updateAddressLabel(str:String?) {
        self.address = str
        //lblAddressName.text = ""
        lblAddress.text = str
        //createIncident(message: "")
    }
    
    
    
    // MARK: - ACTIONS (API CALLING)
    func locationAPI() {
        
        //        kAppDelegate.startLocationUpdate()
        //        SwiftLoader.show(title:"Please Wait...", animated: false)
        //        let param = ["altitude":"\(kAppDelegate.curaltitude)",
        //            "longitude":"\(kAppDelegate.curLongitude)"]
        //        PSApi.apiRequestWithEndPoint(.localApi, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
        //            SwiftLoader.hide()
        //        }
    }
    
    
    // MARK: - ACTIONS
    @objc func notificationButtonAction() {
        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = 4
        mainTabBarVC.isNotification = true
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mainTabBarVC, animated: true)
        }
    }
    
    @objc func menuButtonAction() {
        let menuVC = StoryboardManager.menuStoryBoard().getController(identifier: "MenuViewController")
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func getFrontCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
    }
    
    
    
    func handleViolenceButton(isStandBy: Bool) { // Calling fristssss
        //mapImageView.isHidden = !isStandBy
        self.showBigMapView()
        locationButton.isHidden = !isStandBy
        videoImageView.isHidden = !isStandBy
        //innerView.isHidden = !isStandBy
        activeInvidentLabel.isHidden = !isStandBy
        responderLabel.text = isStandBy ? "End" : "Responder"
        startResponderButton.isHidden = true
        startLabel.isHidden = isStandBy
        handleStandByButton(isStandBy: !isStandBy)
    }
    
    func handleStandByButton(isStandBy: Bool) { // Sec
        bigView.isHidden = isStandBy
        standByLabel.isHidden = isStandBy
        contentLabel.isHidden = isStandBy
        responderCountLabel.isHidden = !isStandBy
        collectionView.isHidden = !isStandBy
        messageStackView.isHidden = !isStandBy
        // innerView.isUserInteractionEnabled = isStandBy
        videoImageView.isUserInteractionEnabled = isStandBy
        if isStandBy == false {
            self.stopSession()
            self.captureSession?.stopRunning()
            setupCamera(flag: isStandBy)
        } else {
            self.stopSession()
            self.captureSession?.stopRunning()
            setupCamera(flag: isStandBy)
            //video()
        }
        cameraPreview()
    }
    
    func prepareUIWithStopVideo() {
        bigView.layer.cornerRadius = bigViewWidthConstraint.constant / 2
        bigView.bordered(withColor: UIColor.white.withAlphaComponent(0.15), width: 1)
        bigView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        smallView.layer.cornerRadius = smallViewWidthConstraint.constant / 2
        smallView.bordered(withColor: UIColor.white.withAlphaComponent(0.25), width: 1)
        smallView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        avatarImageView.roundRadius()
        videoImageView.layer.cornerRadius = 10
        innerView.layer.cornerRadius = 10
    }
    
    func prepareUIWithStandBy() {
        noAudioButton.roundRadius()
        noAudioButton.tintColor = .white
        audioImageView.tintColor = UIColor.white.withAlphaComponent(0.75)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func prepareUI() {
        shakeContainerView.layer.cornerRadius = 15
        activeShooterView.roundRadius()
        activeShooterImageView.roundRadius()
        backgroundActiveShooterView.roundRadius()
        // Set max X
        maxX = activeShooterView.frame.width - activeShooterImageView.frame.width - minX
        // Add geture for activeShooter button
        gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        gesture.delegate = self
        activeShooterImageView.isUserInteractionEnabled = true
        activeShooterImageView.addGestureRecognizer(gesture)
    }
    
    func addActionForView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapVideoImage))
        videoImageView.addGestureRecognizer(tap)
    }
    
    func prepareNavigation() {
        
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
        let menuBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(menuButtonAction))
        menuBarButtonItem.imageInsets.top = -5
        navigationItem.rightBarButtonItems = [menuBarButtonItem, notificationBarButtonItem]
    }
    
    @objc func handleClickCenterButton(isStartButton: Bool) {
        // Center button.
        //self.createIncident(message: "")
        self.startLiveStream(isStartButton: true)
    }
    
    
    func startLiveStream(isStartButton:Bool) {
        
        startResponderButton.isHidden = !isStartButton
        startLabel.text               = isStartButton ? "Responder" : "Start"
        startButton.isHidden          = isStartButton
        
        // Left button
        stopButton.isHidden      = !isStartButton
        responderLabel.text      = isStartButton ? "Stop" : "Responder"
        responderButton.isHidden = isStartButton
        
        // Show/hide shake view
        shakeContainerView.isHidden = isStartButton
        hideButton.isHidden         = !isStartButton
        hideLabel.isHidden          = !isStartButton
        activeShooterView.isHidden = isStartButton
        currentActiveShooterFrame()
    }
    
    
    func showHomePage() {
        /*//handleClickCenterButton(isStartButton: false)
         //handleViolenceButton(isStandBy: false)
         collectionView.isHidden = true
         responderCountLabel.isHidden = true
         messageStackView.isHidden = true
         //handleClickCenterButton(isStartButton: false)
         backgroundImageView.isHidden = false*/
        
        //self.setup1()
        //self.setup2()
        AppState.setHomeVC()
    }
    
    func currentActiveShooterFrame() {
        activeShooterLabel.alpha = 1
        slideToActivateLabel.alpha = 1
        activeShooterImageView.frame = CGRect(x: minX,
                                              y: 3.5,
                                              width: activeShooterImageView.frame.width,
                                              height: activeShooterImageView.frame.height)
        backgroundActiveShooterView.frame = CGRect(x: -minX,
                                                   y: 0,
                                                   width: activeShooterView.frame.width,
                                                   height: activeShooterView.frame.height)
    }
    
    func showPassCodePage() {
        let passCodeVC = StoryboardManager.homeStoryBoard().getController(identifier: "PassCodeVC") as! PassCodeViewController
        present(passCodeVC, animated: true) {
            
        }
    }
    
    
    // MARK : - SHAKING FUNCTIONALITY
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let shake = DefaultManager().getShake() ?? false
            if shake == true {
                print("shake on")
                if startLabel.text == "Start" {
                    startButtonAction(UIButton())
                }else if startLabel.text == "Responder" && startLabel.isHidden == false{
                    responderButtonAction(UIButton())
                }
            }else{
                print("shake off")
                showMessage("Shake is off, please turn on to use this feature")
                /*showConfirmationAlert("", "Message", self) { (isAllowed) in
                 DefaultManager().setShake(value: isAllowed)
                 self.shakeSwitch.isOn = isAllowed
                 kAppDelegate.shakeFlag = isAllowed
                 }*/
            }
        }
    }
    
    @objc func broadCastStart1() {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://antmedia.samscloud.io/WebRTCAppEE/\(streamId!)"
        session.startLive(stream)
        resppnderCell?.perform(#selector(resppnderCell?.loadStream), with: nil, afterDelay: 10.0)
        patchStreamThumb()
    }
    
    
    func patchStreamThumb() {
        if self.session.running, let image = self.session.currentImage {
            guard let id = self.createIncidentModel?.id else {return}
            guard let data = image.streamThumb().jpegData(compressionQuality: 0.6) else {return}
            let name = self.streamId ?? ""
            let url = incidentDetailUrl(id: id)
            APIsHandler.PATCHStreamThumb(url, data, "\(name).jpg", header: header()) { (error, response, statusCode) in
                print(error?.localizedDescription ?? "")
                print(response ?? "")
            }
        }
    }
    
    func broadCastStart() {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://antmedia.samscloud.io/WebRTCAppEE/\(streamId!)"
        session.startLive(stream)
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func responderButtonAction(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        print("RESPONDER BUTTON ACTION PRESSED - HOME_VC")
        //resppnderCell?.loadStream()
        actionType = "responder"
//        DispatchQueue.main.async {
        UIApplication.shared.isIdleTimerDisabled = true
            if self.createIncidentModel == nil {
            self.createIncidentWithCallBack(message: "") {
                if self.incidentModel == nil {
                    self.getGeofenceArea {
                        sender.isUserInteractionEnabled = true
                        appDelegate.updateReporteLocatoin()
                        self.startResponderButtonAction(sender)
                    }
                }else{
                     sender.isUserInteractionEnabled = true
                    appDelegate.updateReporteLocatoin()
                    self.startResponderButtonAction(sender)
                }
                
            }
        }else{
            if self.incidentModel == nil {
                self.getGeofenceArea {
                     sender.isUserInteractionEnabled = true
                    appDelegate.updateReporteLocatoin()
                    self.startResponderButtonAction(sender)
                }
            }else{
                 sender.isUserInteractionEnabled = true
                appDelegate.updateReporteLocatoin()
                self.startResponderButtonAction(sender)
            }
        }
//        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        print("CALL BUTTON ACTION PRESSED - HOME_VC")
        if let url = URL(string: "tel://911") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        print("START BUTTON ACTION PRESSED - HOME_VC")
        actionType = "start"
        handleClickCenterButton(isStartButton: true)
        UIApplication.shared.isIdleTimerDisabled = true
        self.createIncidentFromStartButton(message: "")
        appDelegate.updateReporteLocatoin()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        DefaultManager().setShake(value: sender.isOn)
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        print("CAMERA BUTTON ACTION PRESSED - HOME_VC")
        
        /*if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
         if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
         goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
         goCoder?.config = goCoderConfig
         }
         }
         
         goCoder?.cameraPreview?.switchCamera()
         self.updateUIControls()*/
        
        let devicePositon = session.captureDevicePosition;
        self.session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
    }
    
    @IBAction func checkInButtonAction(_ sender: UIButton) {
        if checkInButton.isSelected == true {
            return
        }
        getGeofenceArea()
    }
    
    @IBAction func startResponderButtonAction(_ sender: UIButton) {     // Shows Responder_VC
        print("START RESPONDER BUTTON ACTION PRESSED - HOME_VC")
        UIApplication.shared.isIdleTimerDisabled = true
        
        let contacts = emergencyContacts?.emergency_contacts ?? []
        if contacts.count == 0 {
            self.showEmptyContactAlrt()
            if actionType != "start" {
                self.broadCastStart1()
            }
        }else{
            if actionType != "start" {
                self.broadCastStart1()
            }
            if self.incidentModel == nil {
                //SwiftLoader.show(title: "Checking in...", animated: true)
                self.getGeofenceArea {
                    //SwiftLoader.hide()
                    appDelegate.updateReporteLocatoin()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.performSegue(withIdentifier: "showResponderSegue", sender: nil)
                    }
                }
            }else{
                performSegue(withIdentifier: "showResponderSegue", sender: nil)
            }
            
        }
        self.collectionView.isHidden = false
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        if responderLabel.text == "Stop" {
            //handleClickCenterButton(isStartButton: false)
            //goCoder?.endStreaming(self)
            //stopIncident()
            handleStopStream()
        } else if responderLabel.text == "End" {
            self.performSegue(withIdentifier: "showActiveIncidentSegue", sender: nil)
            //goCoder?.endStreaming(self)
        }
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        let passcode = DefaultManager().getPasscode()
        if passcode == nil || passcode == "" {
            showConfirmationAlert("hide password is not set, would you like to set it","Message", self) { (isAllowed) in
                if isAllowed {
                    let vc = StoryboardManager.menuStoryBoard().getController(identifier: "HideDevicePasscodeVC1") as! HideDevicePasscodeViewController
                    vc.isFromHome = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            showPassCodePage()
        }
    }
    
    
    // IBACTIONS (FINISHING VIDEOS)
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
        print("LOCATION BUTTON ACTION PRESSED - HOME_VC")
    }
    
    @IBAction func standByButtonAction(_ sender: UIButton) {
        print("STANDBY BUTTON ACTION PRESSED - HOME_VC")
        handleStandByButton(isStandBy: true)
    }
    
    // IBACTIONS (CLICK STANDBY BUTTON)
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        //        responderCountLabel.isHidden = true
        //        collectionView.isHidden = true
        tapLargeVideo(isLargeVideo: true)
        print("MESSAGE BUTTON ACTION PRESSED - HOME_VC")
        let chatNC = StoryboardManager.homeStoryBoard().getController(identifier: "ChatNC") as! UINavigationController
        chatNC.modalPresentationStyle = .overCurrentContext
        let chatVC = chatNC.topViewController as! ChatViewController
        chatVC.endButtonAction = {
            self.performSegue(withIdentifier: "showActiveIncidentSegue", sender: nil)
        }
        present(chatNC, animated: false, completion: nil)
    }
    
    @IBAction func audioButtonAction(_ sender: UIButton) {
        print("AUDIO BUTTON ACTION PRESSED - HOME_VC")
        sender.isSelected = !sender.isSelected
        let image = sender.isSelected ? UIImage(named: "audio") : UIImage(named: "no-audio")
        noAudioButton.setImage(image, for: .normal)
    }
    
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        print("TAKE PHOTO BUTTON  PRESSED - HOME_VC")
        takePhoto = true
    }
    
    @IBAction func didTapBroadcastButton(_ sender:AnyObject?) {
        print("DID TAP BROADCAST PHOTO BUTTON  PRESSED - HOME_VC")
        // Ensure the minimum set of configuration settings have been specified necessary to
        // initiate a broadcast streaming session
        
    }
    
    @IBAction func didTapSwitchCameraButton(_ sender:AnyObject?) {
        print("DID TAP SWITCH CAMERA BUTTON  PRESSED - HOME_VC")
        
    }
    
    @IBAction func didTapTorchButton(_ sender:AnyObject?) {
        print("DID TAP TORCH BUTTON  PRESSED - HOME_VC")
        
    }
    
    @IBAction func didTapMicButton(_ sender:AnyObject?) {
        print("DID TAP MIC BUTTON  PRESSED - HOME_VC")
    }
    
    @IBAction func didTapSettingsButton(_ sender:AnyObject?) {
        print("DID TAP SETTINGS BUTTON  PRESSED - HOME_VC")
    }
    
    func showAlert(_ title: String, error: NSError) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}












extension HomeViewController:ResponderViewControllerDelegate,ActiveIncidentViewControllerDelegate {
    
    // MARK: - SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResponderSegue" {
            // Hide active shooter
            activeShooterView.isHidden = true
            responderButton.isHidden = true
            stopButton.isHidden = false
            //self.broadCastStart1()
            self.sendIncidentAlrtNotification()
            // Show responder page
            let responderVC = segue.destination as! ResponderViewController
            // Handle `stop` button
            responderVC.delegate = self
            
            responderVC.stopButtonAction = {
                self.handleStopStream()
            }
            
            // Handle `hide` button
            responderVC.hideButtonAction = {
                self.showPassCodePage()
            }
            
            // Handle `violence` button
            responderVC.violenceButtonAction = {
                //self.handleViolenceButton(isStandBy: false)
            }
            
            // Handle `skip` button
            responderVC.skipButtonAction = {
                //self.handleClickCenterButton(isStartButton: true)
                //self.handleViolenceButton(isStandBy: true)
            }
        } else if segue.identifier == "showResponderFromLeftItemSegue" {
            // Hide active shooter
            activeShooterView.isHidden = true
            // Show responder page
            let responderVC = segue.destination as! ResponderViewController
            // Handle `stop` button
            responderVC.delegate = self
            responderVC.stopButtonAction = {
                self.handleClickCenterButton(isStartButton: false)
            }
            // Handle `hide` button
            responderVC.hideButtonAction = {
                self.showPassCodePage()
            }
            // Handle `violence` button
            responderVC.violenceButtonAction = {
                self.handleClickCenterButton(isStartButton: true)
                self.handleViolenceButton(isStandBy: true)
            }
            // Handle `skip` button
            responderVC.skipButtonAction = {
                self.handleClickCenterButton(isStartButton: true)
                self.handleViolenceButton(isStandBy: true)
            }
        } else if segue.identifier == "showActiveIncidentSegue" {
            // Show active incident page
            let activeIncidentVC = segue.destination as! ActiveIncidentViewController
            // Handle `end` button
            
            activeIncidentVC.delegate = self
            
            activeIncidentVC.endButtonAction = {
                self.showHomePage()
            }
            
            // Handle `continue` button
            activeIncidentVC.continueButtonAction = {
                let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 2
                mainTabBarVC.isIncidentHistory = true
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                }
            }
        }
    }
    
    
    func didChooseOption(option: String) {
        patchIncidentApi(msg: option)
    }
    
    
    func didSelectEndOption(value: String) {
        //captureSession = nil
        //previewLayer = nil
        //captureDevice = nil
        self.endIncident(msg: value)
        //self.restartUIFromScratch()
    }
    
}









// MARK:- MKMapViewDelegate...
extension HomeViewController  :GMSMapViewDelegate{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            print("\(appDelegate.currentLocation)")
            appDelegate.currentLocation = location
            mapView?.removeObserver(self, forKeyPath: "myLocation")
            self.animateZoomLevel(zoom: 14)
        }
    }
    
    
    func addMarkers() {
        self.mapView.clear()
    }
    
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return true
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    
    /// show user's location on map...
    func showUserLocationOnMap() {
        let location = appDelegate.currentLocation
        if location == nil {return}
        
        //pinView.clipsToBounds = false
        locationMarker.position = appDelegate.currentLocation.coordinate
        locationMarker.iconView = pinView
        locationMarker.map = self.mapView
        mapView.isMyLocationEnabled = false
        //pinView.startPulse(with: .lightGray, animation: .radarPulsing)
        pulseImgView.startPulse(with: .lightGray, animation: .radarPulsing)
        /*if let path =  Bundle.main.url(forResource: "document", withExtension: "json") {
         if let jsonData = try? Data.init(contentsOf: path), let json = try? JSON.init(data: jsonData){
         self.responders = Responders.init(json: json)
         self.standByLabel.isHidden = true
         self.contentLabel.isHidden = true
         self.collectionView.isHidden = false
         self.collectionView.reloadData()
         self.plotRepondersOnMap()
         }
         }*/
    }
    
    
    
    func animateZoomLevel(zoom:CGFloat) {
        
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = zoom
        zoomAnimation.duration = CFTimeInterval(2.5)
        
        mapView?.layer.add(zoomAnimation, forKey: nil)
        perform(#selector(updateCamera), with: nil, afterDelay: 2.3)
    }
    
    @objc func  updateCamera() {
        let loc = appDelegate.currentLocation
        if loc == nil {return}
        let camera = GMSCameraPosition.camera(withLatitude: appDelegate.currentLocation.coordinate.latitude, longitude: appDelegate.currentLocation.coordinate.longitude, zoom: 17.0)
        mapView.camera = camera
        self.showUserLocationOnMap()
    }
    
    
    
    
    func plotRepondersOnMap() {
        
        mapView.isMyLocationEnabled = true
        let array = self.responders?.emergency_contacts ?? []
        
        if array.count > 0 {self.mapView.clear()}
        
        for (_, obj) in array.enumerated() {
            
            let marker = GMSMarker.init()
            
            let responderPinView = ResponderPinView.view()
            responderPinView.detailsView?.isHidden = true
            self.responderPinViews.append(responderPinView)
            
            marker.iconView = responderPinView
            
            if let lat = obj.latitude, let long = obj.longitude {
                let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                marker.position = location
            }
            marker.map = self.mapView
            self.responderMarkers.append(marker)
        }
        
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = 12.0
        zoomAnimation.duration = CFTimeInterval(2.5)
        mapView?.layer.add(zoomAnimation, forKey: nil)
    }
    
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(GoogleApiKey)")!
        
        SwiftLoader.show(title: "Finding Path...", animated: true)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
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
            
            guard let route = routes[0] as? [String: Any] else {
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
                self.standByLabel.isHidden = true
                self.contentLabel.isHidden = true
                self.collectionView.isHidden = false
                self.responderCountLabel.isHidden = false
                
                let loc1 = CLLocation.init(latitude: source.latitude, longitude: source.longitude)
                let loc2 = CLLocation.init(latitude: destination.latitude, longitude: destination.longitude)
                let distanceBetween:Float = Float(loc1.distance(from: loc2)/1609.34)
                
                var zooom:Float = 12
                
                if distanceBetween > 5 {
                    zooom += (distanceBetween)/10
                }else{
                    zooom = 11.5 + (5 - distanceBetween)/2
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
                self.responderPinViews[self.selectedPinIndex].detailsView?.isHidden = false
                if value >= 1 {
                    self.responderPinViews[self.selectedPinIndex].minuteLablel?.text = "hours"
                    self.responderPinViews[self.selectedPinIndex].numberLablel?.text = valueStr
                }else{
                    let value = (durationStr/60)
                    let valueStr = String.init(format: "%.2f", value)
                    self.responderPinViews[self.selectedPinIndex].minuteLablel?.text = "minutes"
                    self.responderPinViews[self.selectedPinIndex].numberLablel?.text = valueStr
                }
                
                self.reShowSmallCameraView()
            }
            
            guard let end_address = leg["end_address"]  as? String else {
                return
            }
            let list = end_address.components(separatedBy: ", ")
            
            DispatchQueue.main.async {
                self.responderPinViews[self.selectedPinIndex].cityLablel?.text = list.first
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
    
    
    func restartUIFromScratch() {
        
        self.session.stopLive()
        appDelegate.socketTimer?.invalidate()
        appDelegate.socketTimer = nil
        appDelegate.webSocket?.disconnect()
        appDelegate.webSocket = nil
        
        createIncidentModel = nil
        wowzaStreamModel = nil
        incidentModel = nil
        
        //goCoder?.endStreaming(self)
        //goCoder?.cameraPreview?.stop()
        
        innerView.isHidden = true
        startButton.isHidden = false
        mapView.isHidden = true
        //viewMain.frame = fullFrame
        
        switchView.frame = fullFrame
        //goCoder?.cameraPreview?.previewLayer?.frame = switchView.bounds
        
        //goCoder?.cameraPreview?.start()
        
        collectionView.isHidden = true
        activeShooterView.isHidden = false
        activeInvidentLabel.isHidden = true
        startLabel.isHidden = false
        standByLabel.isHidden = true
        contentLabel.isHidden = true
        responderLabel.isHidden = false
        checkInButton.isSelected = false
        stopButton.isHidden = true
        startLabel.text = "Start"
        currentActiveShooterFrame()
        shakeContainerView.isHidden = false
        responderButton.isHidden = false
        hideButton.isHidden = true
        hideLabel.isHidden = true
        
        responderLabel.text = "Responder"
        responderStreamCollection.isHidden = true
        
        self.activeShooterLabel.alpha = 1
        self.slideToActivateLabel.alpha = 1
        
        checkInButton.isSelected = false
        checkInButton.isUserInteractionEnabled = true
        /*
         viewMain.snp.removeConstraints()
         
         viewMain.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(self.view).offset(fullFrame.origin.y)
         make.left.equalTo(self.view).offset(0)
         make.right.equalTo(self.view).offset(0)
         make.size.equalTo(CGSize(width: fullFrame.size.width, height: fullFrame.size.height))
         }
         
         mapView.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(self.view).offset(fullFrame.origin.y)
         make.left.equalTo(self.view).offset(0)
         make.size.equalTo(CGSize(width: fullFrame.size.width, height: fullFrame.size.height))
         }
         */
        mapView.isHidden = true
        viewDidLoad()
        self.setup2()
        UIApplication.shared.isIdleTimerDisabled = false
        responderCountLabel.isHidden = true
        startResponderButton.isHidden = true
        startButton.isHidden = false
        streamId = "\(Date().ticks)"
    }
    
}








extension HomeViewController {
    
    
    func addBigCameraConstaints() {
        
    }
    
    func addSmallCameraConstaints() {
        
    }
    
}
