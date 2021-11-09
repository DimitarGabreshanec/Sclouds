//
//  HomeViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import AVFoundation
import WowzaGoCoderSDK


class HomeViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate , WOWZStatusCallback, WOWZVideoSink, WOWZAudioSink {
    
    //MARK: - Class Member Variables
    
    let SDKSampleSavedConfigKey = "SDKSampleSavedConfigKey"
    let SDKSampleAppLicenseKey = "GOSK-6E46-010C-CEE5-D126-4A2A"
    let BlackAndWhiteEffectKey = "BlackAndWhiteKey"
    let BitmapOverlayEffectKey = "BitmapOverlayKey"
    
    @IBOutlet weak var broadcastButton:UIButton!
    @IBOutlet weak var settingsButton:UIButton!
    @IBOutlet weak var switchCameraButton:UIButton!
    @IBOutlet weak var torchButton:UIButton!
    @IBOutlet weak var micButton:UIButton!
    @IBOutlet weak var bitmapOverlayImgView:UIImageView!
    
    var goCoder:WowzaGoCoder?
    var goCoderConfig:WowzaConfig!
    
    var receivedGoCoderEventCodes = Array<WOWZEvent>()
    
    var blackAndWhiteVideoEffect = false
    var bitmapOverlayVideoEffect = false /// Not supported in swift version
    var goCoderRegistrationChecked = false
    
    
    
    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    var usingFrontCamera = false
    
    var captureDevice: AVCaptureDevice!
    
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var viewMain: UIView!
    var takePhoto = false
    // MARK: - IBOutlets
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
    
    // MARK: - Private method
    private var heightResponderView: CGFloat = 0
    private var gesture = UIPanGestureRecognizer()
    private var minX: CGFloat = 3.5
    private var maxX: CGFloat = 0
    private var activeShooterImageY: CGFloat = 0
    private var isLargeVideo = false
    
    // MARK: - Methods
    var isFromDispatchSOSResponder = false
    var isShowMenuPage = false
    var ischeck = false

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                // Reload any saved data
                blackAndWhiteVideoEffect = UserDefaults.standard.bool(forKey: BlackAndWhiteEffectKey)
                bitmapOverlayVideoEffect = UserDefaults.standard.bool(forKey: BitmapOverlayEffectKey)
                WowzaGoCoder.setLogLevel(.default)
                
                if let savedConfig:Data = UserDefaults.standard.object(forKey: SDKSampleSavedConfigKey) as? Data {
                    if let wowzaConfig = NSKeyedUnarchiver.unarchiveObject(with: savedConfig) as? WowzaConfig {
                        goCoderConfig = wowzaConfig
                    }
                    else {
                        goCoderConfig = WowzaConfig()
                    }
                }
                else {
                    goCoderConfig = WowzaConfig()
                }
                
                // Log version and platform info
                print("WowzaGoCoderSDK version =\n major: \(WOWZVersionInfo.majorVersion())\n minor: \(WOWZVersionInfo.minorVersion())\n revision: \(WOWZVersionInfo.revision())\n build: \(WOWZVersionInfo.buildNumber())\n string: \(WOWZVersionInfo.string())\n verbose string: \(WOWZVersionInfo.verboseString())")
                
                print("Platform Info:\n\(WOWZPlatformInfo.string())")
                
                if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(SDKSampleAppLicenseKey) {
                    //self.showAlert("GoCoder SDK Licensing Error", error: goCoderLicensingError as NSError)
                }
        
        bigViewWidthConstraint.constant = UIScreen.main.bounds.size.height == 667.0 ? 180 : 230
        smallViewWidthConstraint.constant = UIScreen.main.bounds.size.height == 667.0 ? 130 : 144

        prepareNavigation()
        prepareUI()
        prepareUIWithStopVideo()
        prepareUIWithStandBy()
        addActionForView()
        if isFromDispatchSOSResponder {
            handleClickCenterButton(isStartButton: true)
            handleViolenceButton(isStandBy: true)
            handleStandByButton(isStandBy: true)
            isLargeVideo = true
            tapLargeVideo(isLargeVideo: isLargeVideo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera(flag: true)

       /// Live Streaming
        let savedConfigData = NSKeyedArchiver.archivedData(withRootObject: goCoderConfig)
        UserDefaults.standard.set(savedConfigData, forKey: SDKSampleSavedConfigKey)
        UserDefaults.standard.synchronize()
        
        // Update the configuration settings in the GoCoder SDK
        if (goCoder != nil) {
            goCoder?.config = goCoderConfig
            blackAndWhiteVideoEffect = UserDefaults.standard.bool(forKey: BlackAndWhiteEffectKey)
            bitmapOverlayVideoEffect = UserDefaults.standard.bool(forKey: BitmapOverlayEffectKey)
        }
        ///
        navigationController?.isNavigationBarHidden = false
        
        if isShowMenuPage {
            isShowMenuPage = false
            
            // Show Menu page
            let menuVC = StoryBoardManager.menuStoryBoard().getController(identifier: "MenuViewController")
            
            navigationController?.pushViewController(menuVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResponderSegue" {
            // Hide active shooter
            activeShooterView.isHidden = true
            
            // Show responder page
            let responderVC = segue.destination as! ResponderViewController
            
            // Handle `stop` button
            responderVC.stopButtonAction = {
                self.handleClickCenterButton(isStartButton: false)
            }
            
            // Handle `hide` button
            responderVC.hideButtonAction = {
                self.showPassCodePage()
            }
            
            // Handle `violence` button
            responderVC.violenceButtonAction = {
                self.handleViolenceButton(isStandBy: true)
            }
            
            // Handle `skip` button
            responderVC.skipButtonAction = {
                self.handleClickCenterButton(isStartButton: true)
                self.handleViolenceButton(isStandBy: true)
            }
        }
        else if segue.identifier == "showResponderFromLeftItemSegue" {
            // Hide active shooter
            activeShooterView.isHidden = true
            
            // Show responder page
            let responderVC = segue.destination as! ResponderViewController
            
            // Handle `stop` button
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
        }
        else if segue.identifier == "showActiveIncidentSegue" {
            
            // Show active incident page
            let activeIncidentVC = segue.destination as! ActiveIncidentViewController
            
            // Handle `end` button
            activeIncidentVC.endButtonAction = {
                self.showHomePage()
            }
            
            // Handle `continue` button
            activeIncidentVC.continueButtonAction = {
                let mainTabBarVC = StoryBoardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                mainTabBarVC.defaultIndex = 2
                mainTabBarVC.isIncidentHistory = true
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(mainTabBarVC, animated: true)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func notificationButtonAction() {
        let mainTabBarVC = StoryBoardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = 4
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mainTabBarVC, animated: true)
        }
    }
    
    @objc func menuButtonAction() {
        let menuVC = StoryBoardManager.menuStoryBoard().getController(identifier: "MenuViewController")
        
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    @objc func tapVideoImage() {
        isLargeVideo = !isLargeVideo
        
        tapLargeVideo(isLargeVideo: isLargeVideo)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.activeShooterImageView)
        let velocity = recognizer.velocity(in: self.activeShooterImageView)
        
        activeShooterImageY = (activeShooterView.frame.height - activeShooterImageView.frame.height) / 2
        let x = self.activeShooterImageView.frame.minX
        if x + translation.x >= minX && x + translation.x <= maxX {
            self.activeShooterImageView.frame = CGRect(x: x + translation.x,
                                                       y: activeShooterImageY,
                                                       width: activeShooterImageView.frame.width,
                                                       height: activeShooterImageView.frame.height)
            self.backgroundActiveShooterView.frame = CGRect(x: x + translation.x - minX,
                                                            y: 0,
                                                            width: self.activeShooterView.frame.width,
                                                            height: self.activeShooterView.frame.height)
            self.activeShooterLabel.alpha = 0
            self.slideToActivateLabel.alpha = 0
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.x < 0 ? Double((x - minX) / -velocity.x) : Double((maxX - x) / velocity.x)
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: [.allowUserInteraction],
                           animations: {
                if self.activeShooterImageView.frame.origin.x >= (self.maxX - self.minX) / 2 {
                    self.activeShooterLabel.alpha = 0
                    self.slideToActivateLabel.alpha = 0
                    self.activeShooterImageView.frame = CGRect(x: self.maxX,
                                                               y: self.activeShooterImageY,
                                                               width: self.activeShooterImageView.frame.width,
                                                               height: self.activeShooterImageView.frame.height)
                    
                    self.backgroundActiveShooterView.frame = CGRect(x: self.maxX - self.minX,
                                                                    y: 0,
                                                                    width: self.activeShooterView.frame.width - self.maxX + self.minX,
                                                                    height: self.activeShooterView.frame.height)
                } else {
                    self.activeShooterLabel.alpha = 1
                    self.slideToActivateLabel.alpha = 1
                    self.activeShooterImageView.frame = CGRect(x: self.minX,
                                                               y: self.activeShooterImageY,
                                                               width: self.activeShooterImageView.frame.width,
                                                               height: self.activeShooterImageView.frame.height)
                    
                    self.backgroundActiveShooterView.frame = CGRect(x: -self.minX,
                                                                    y: 0,
                                                                    width: self.activeShooterView.frame.width,
                                                                    height: self.activeShooterView.frame.height)
                }
            }, completion: { [weak self] _ in
                guard let strongSelf = self else { return }
                if strongSelf.activeShooterImageView.frame.origin.x == strongSelf.maxX {
                    strongSelf.activeShooterView.isHidden = true
                    let responderVC = StoryBoardManager.homeStoryBoard().getController(identifier: "ResponderViewController") as! ResponderViewController
                    responderVC.modalPresentationStyle = .overCurrentContext
                    responderVC.isActiveShooter = true
                    
                    strongSelf.handleClickCenterButton(isStartButton: true)
                    self?.ischeck = true

                    // Handle `stop` button
                    responderVC.stopActiveButtonAction = {
                        strongSelf.showHomePage()
                    }
                    
                    // Handle `stop` button
                    responderVC.stopButtonAction = {
                        self?.ischeck = false
                        strongSelf.handleClickCenterButton(isStartButton: false)
                    }
                    
                    // Handle `hide` button
                    responderVC.hideButtonAction = {
                        strongSelf.showPassCodePage()
                    }
                    
                    // Handle `violence` button
                    responderVC.violenceButtonAction = {
                        strongSelf.handleViolenceButton(isStandBy: true) // firstCall
                    }
                    
                    // Handle `skip` actinve shooter button
                    responderVC.skipActiveButtonAction = {
                        strongSelf.handleViolenceButton(isStandBy: true) //firstCall
                    }
                    
                    strongSelf.present(responderVC, animated: false, completion: nil)
                }
            })
        }
    }
    
    // MARK: - Private methods
    
    private func tapLargeVideo(isLargeVideo: Bool) {
        responderCountLabel.isHidden = isLargeVideo
        collectionView.isHidden = isLargeVideo
        locationButton.isHidden = isLargeVideo
        mapImageView.isHidden = isLargeVideo
        backgroundImageView.isHidden = !isLargeVideo
        videoImageView.image = isLargeVideo ? UIImage(named: "video-map") : UIImage(named: "home-small")
    }
    
    private func handleViolenceButton(isStandBy: Bool) { // Calling fristssss
        mapImageView.isHidden = !isStandBy
        locationButton.isHidden = !isStandBy
        videoImageView.isHidden = !isStandBy
        activeInvidentLabel.isHidden = !isStandBy
        responderLabel.text = isStandBy ? "End" : "Responder"
        startResponderButton.isHidden = true
        startLabel.isHidden = isStandBy
        handleStandByButton(isStandBy: !isStandBy)
    }
    
    private func handleStandByButton(isStandBy: Bool) { // Sec
        bigView.isHidden = isStandBy
        standByLabel.isHidden = isStandBy
        contentLabel.isHidden = isStandBy
        responderCountLabel.isHidden = !isStandBy
        collectionView.isHidden = !isStandBy
        messageStackView.isHidden = !isStandBy
        videoImageView.isUserInteractionEnabled = isStandBy
        if isStandBy == false {
            self.stopSession()
            self.captureSession.stopRunning()
            setupCamera(flag: isStandBy)
        } else {
            self.stopSession()
            self.captureSession.stopRunning()
            setupCamera(flag: isStandBy)
           //video()
        }
        if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
            if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                goCoder?.config = goCoderConfig
            }
            
            goCoder?.cameraPreview?.switchCamera()
            //torchButton.setImage(UIImage(named: "torch_on_button"), for: UIControl.State())
            self.updateUIControls()
        }
    }
//    func video(){
//    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//    let myPickerController = UIImagePickerController()
//    myPickerController.delegate = self
//    myPickerController.sourceType = .photoLibrary
//    myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
//    currentVC?.present(myPickerController, animated: true, completion: nil)
//    }
//    }
    private func prepareUIWithStopVideo() {
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
    
    private func prepareUIWithStandBy() {
        noAudioButton.roundRadius()
        noAudioButton.tintColor = .white
        audioImageView.tintColor = UIColor.white.withAlphaComponent(0.75)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func prepareUI() {
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
    
    private func addActionForView() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(tapVideoImage))
        videoImageView.addGestureRecognizer(tap)
    }
    
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
        
        let menuBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(menuButtonAction))
        menuBarButtonItem.imageInsets.top = -5
        navigationItem.rightBarButtonItems = [menuBarButtonItem, notificationBarButtonItem]
    }
    
    private func handleClickCenterButton(isStartButton: Bool) {
        // Center button
        startResponderButton.isHidden = !isStartButton
        startLabel.text = isStartButton ? "Responder" : "Start"
        startButton.isHidden = isStartButton
        
        // Left button
        stopButton.isHidden = !isStartButton
        responderLabel.text = isStartButton ? "Stop" : "Responder"
        responderButton.isHidden = isStartButton
        
        // Show/hide shake view
        shakeContainerView.isHidden = isStartButton
        hideButton.isHidden = !isStartButton
        hideLabel.isHidden = !isStartButton
        
        /*
        // Check in button
        checkInButton.backgroundColor = isStartButton ? .white : UIColor(hexString: "0088FF")
        checkInButton.setTitleColor(isStartButton ? UIColor(hexString: "0088FF") : UIColor.white, for: .normal)
        checkInButton.setImage(UIImage(named: isStartButton ? "home-checked" : "home-check"), for: .normal)
        */
        
        // Hide active shooter button
        activeShooterView.isHidden = isStartButton
        
        //videoImageView.image = UIImage(named: "home-small")
        
        currentActiveShooterFrame()
    }
    
    private func showHomePage() {
        handleClickCenterButton(isStartButton: false)
        handleViolenceButton(isStandBy: false)
        collectionView.isHidden = true
        responderCountLabel.isHidden = true
        messageStackView.isHidden = true
        handleClickCenterButton(isStartButton: false)
        backgroundImageView.isHidden = false
    }
    
    private func currentActiveShooterFrame() {
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
    
    private func showPassCodePage() {
        let passCodeVC = StoryBoardManager.homeStoryBoard().getController(identifier: "PassCodeVC") as! PassCodeViewController
        passCodeVC.modalTransitionStyle = .crossDissolve
        
        present(passCodeVC, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func responderButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        handleClickCenterButton(isStartButton: true)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        usingFrontCamera = !usingFrontCamera
        do{
            captureSession.removeInput(captureSession.inputs.first!)
            
            if(usingFrontCamera){
                captureDevice = getFrontCamera()
            }else{
                captureDevice = getBackCamera()
            }
            let captureDeviceInput1 = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput1)
        }catch{
            print(error.localizedDescription)
        }
    }
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
        return nil
    }
    @IBAction func checkInButtonAction(_ sender: UIButton) {
        checkInButton.isSelected = !checkInButton.isSelected
        checkInButton.backgroundColor = !checkInButton.isSelected ? UIColor(hexString: "0088ff") : UIColor.white
    }
    
    // Action show when click start button
    
    @IBAction func startResponderButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        if responderLabel.text == "Stop" {
            handleClickCenterButton(isStartButton: false)
        }
        else if responderLabel.text == "End" {
            self.performSegue(withIdentifier: "showActiveIncidentSegue", sender: nil)
        }
    }
    
    @IBAction func hideButtonAction(_ sender: UIButton) {
        showPassCodePage()
    }
    
    // IBAction when finish video
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func standByButtonAction(_ sender: UIButton) {
        handleStandByButton(isStandBy: true)
    }
    
    // IBAction when click standBy button
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
//        responderCountLabel.isHidden = true
//        collectionView.isHidden = true
        tapLargeVideo(isLargeVideo: true)
        
        let chatNC = StoryBoardManager.homeStoryBoard().getController(identifier: "ChatNC") as! UINavigationController
        chatNC.modalPresentationStyle = .overCurrentContext
        
        let chatVC = chatNC.topViewController as! ChatViewController
        chatVC.endButtonAction = {
            self.performSegue(withIdentifier: "showActiveIncidentSegue", sender: nil)
        }
        
        present(chatNC, animated: false, completion: nil)
    }
    
    @IBAction func audioButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let image = sender.isSelected ? UIImage(named: "audio") : UIImage(named: "no-audio")
        noAudioButton.setImage(image, for: .normal)
    }
//    func setupCamera(flag:Bool) {
//
//        //capture session begins at photo screen (not video record)
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//            if let availabeDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices as? [AVCaptureDevice] {
//
//           captureDevice = availabeDevices.first
//                beginSession(flag: flag)
//        }
//    }
    
    func setupCamera(flag:Bool) {
        
        //capture session begins at photo screen (not video record)
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        //grab devices and assign to capture device variable
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices as? [AVCaptureDevice] {
            captureDevice = availableDevices.first
            beginSession()
        }
        
    }
    func beginSession(flag:Bool) {
        
        //get input from device and add to session
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("MIKE: there was an error adding device input to session: \(error.localizedDescription)")
        }
        
        //begin layer setup use session to display camera input through layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer = previewLayer

         if flag == true {
            self.viewMain.frame = view.bounds
            self.previewLayer.frame = self.viewMain.layer.frame
            self.viewMain.layer.addSublayer(self.previewLayer)
        } else {
            self.videoImageView.frame = videoImageView.bounds
            self.previewLayer.frame = self.videoImageView.layer.frame
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoImageView.layer.masksToBounds = true
            self.videoImageView.layer.addSublayer(self.previewLayer)
        }
        captureSession.startRunning()
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        let queue = DispatchQueue(label: "com.mikaelTeklehaimanot.captureSessionQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)

    }
    func beginSession() {
        
        //get input from device and add to session
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("MIKE: there was an error adding device input to session: \(error.localizedDescription)")
        }
        
        //begin layer setup use session to display camera input through layer
        // if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.mikaelTeklehaimanot.captureSessionQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
       // }
        
    }
    
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        takePhoto = true
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if takePhoto {
            takePhoto = false
            if let image = self.getPhotoFromSampleBuffer(sampleBuffer) {
                DispatchQueue.main.async {
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
                    photoVC.photo = image
                    
                    self.present(photoVC, animated: true, completion: {
                        self.stopSession()
                    })
                }
            }
            
        }
    }
    
    func getPhotoFromSampleBuffer(_ buffer: CMSampleBuffer) -> UIImage? {
        
        if let imageBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvImageBuffer: imageBuffer)
            let ciContext = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
            if let image = ciContext.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image)
            }
        }
        
        return nil
    }
    
    func stopSession() {
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
    }
/// Live Straeming
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goCoder?.cameraPreview?.previewLayer?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !goCoderRegistrationChecked {
            if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(SDKSampleAppLicenseKey) {
                self.showAlert("GoCoder SDK Licensing Error", error: goCoderLicensingError as NSError)
            }
            else {
                goCoderRegistrationChecked = true
                
                // Initialize the GoCoder SDK
                if let goCoder = WowzaGoCoder.sharedInstance() {
                    self.goCoder = goCoder
                    
                    // Request camera and microphone permissions
                    WowzaGoCoder.requestPermission(for: .camera, response: { (permission) in
                        print("Camera permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    
                    WowzaGoCoder.requestPermission(for: .microphone, response: { (permission) in
                        print("Microphone permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    
                    self.goCoder?.register(self as WOWZAudioSink)
                    self.goCoder?.register(self as WOWZVideoSink)
                    self.goCoder?.config = self.goCoderConfig
                    
                    // Specify the view in which to display the camera preview
                    self.goCoder?.cameraView = self.view
                    
                    // Start the camera preview
                    self.goCoder?.cameraPreview?.start()
                }
                
                self.updateUIControls()
            }
        }
        else{
            // Start the camera preview
            self.goCoder?.cameraPreview?.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // self.goCoder?.cameraPreview?.stop()
    }
    
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    
    
    //MARK - UI Action Methods
    
    @IBAction func didTapBroadcastButton(_ sender:AnyObject?) {
        // Ensure the minimum set of configuration settings have been specified necessary to
        // initiate a broadcast streaming session
        if let configError = goCoder?.config.validateForBroadcast() {
            self.showAlert("Incomplete Streaming Settings", error: configError as NSError)
        }
        else {
            // Disable the U/I controls
            broadcastButton.isEnabled    = false
            //torchButton.isEnabled        = false
           // switchCameraButton.isEnabled = false
            //settingsButton.isEnabled     = false
            
            if goCoder?.status.state == .running {
                goCoder?.endStreaming(self)
            }
            else {
                receivedGoCoderEventCodes.removeAll()
                goCoder?.startStreaming(self)
                let audioMuted = goCoder?.isAudioMuted ?? false
                micButton.setImage(UIImage(named: audioMuted ? "mic_off_button" : "mic_on_button"), for: UIControl.State())
            }
        }
    }
    
    @IBAction func didTapSwitchCameraButton(_ sender:AnyObject?) {
        if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
            if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                goCoder?.config = goCoderConfig
            }
            
            goCoder?.cameraPreview?.switchCamera()
            //torchButton.setImage(UIImage(named: "torch_on_button"), for: UIControl.State())
            self.updateUIControls()
        }
    }
    
    @IBAction func didTapTorchButton(_ sender:AnyObject?) {
        var newTorchState = goCoder?.cameraPreview?.camera?.isTorchOn ?? true
        newTorchState = !newTorchState
        goCoder?.cameraPreview?.camera?.isTorchOn = newTorchState
        //torchButton.setImage(UIImage(named: newTorchState ? "torch_off_button" : "torch_on_button"), for: UIControl.State())
    }
    
    @IBAction func didTapMicButton(_ sender:AnyObject?) {
        var newMutedState = self.goCoder?.isAudioMuted ?? true
        newMutedState = !newMutedState
        goCoder?.isAudioMuted = newMutedState
        micButton.setImage(UIImage(named: newMutedState ? "mic_off_button" : "mic_on_button"), for: UIControl.State())
    }
    
    @IBAction func didTapSettingsButton(_ sender:AnyObject?) {
//        if let settingsNavigationController = UIStoryboard(name: "AppSettings", bundle: nil).instantiateViewController(withIdentifier: "settingsNavigationController") as? UINavigationController {
//
//            if let settingsViewController = settingsNavigationController.topViewController as? SettingsViewController {
//                settingsViewController.addAllSections()
//                settingsViewController.removeDisplay(.recordVideoLocally)
//                settingsViewController.removeDisplay(.backgroundMode)
//                let viewModel = SettingsViewModel(sessionConfig: goCoderConfig)
//                viewModel?.supportedPresetConfigs = goCoder?.cameraPreview?.camera?.supportedPresetConfigs
//                settingsViewController.viewModel = viewModel!
//            }
//
//            self.present(settingsNavigationController, animated: true, completion: nil)
//        }
    }
    
    func updateUIControls() {
        if self.goCoder?.status.state != .idle && self.goCoder?.status.state != .running {
            // If a streaming broadcast session is in the process of starting up or shutting down,
            // disable the UI controls
            //self.broadcastButton.isEnabled    = false
           // self.torchButton.isEnabled        = false
            //self.switchCameraButton.isEnabled = false
            //self.settingsButton.isEnabled     = false
           // self.micButton.isHidden           = true
            //self.micButton.isEnabled          = false
        }
        else {
            // Set the UI control state based on the streaming broadcast status, configuration,
            // and device capability
            //self.broadcastButton.isEnabled    = true
           // self.switchCameraButton.isEnabled = ((self.goCoder?.cameraPreview?.cameras?.count) ?? 0) > 1
            //self.torchButton.isEnabled        = self.goCoder?.cameraPreview?.camera?.hasTorch ?? false
            let isStreaming                 = self.goCoder?.isStreaming ?? false
            //self.settingsButton.isEnabled     = !isStreaming
            // The mic icon should only be displayed while streaming and audio streaming has been enabled
            // in the GoCoder SDK configuration setiings
           // self.micButton.isEnabled          = isStreaming && self.goCoderConfig.audioEnabled
            //self.micButton.isHidden           = !self.micButton.isEnabled
            
            //self.bitmapOverlayImgView.isHidden = !self.bitmapOverlayVideoEffect;
            if(bitmapOverlayVideoEffect){
                let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBitmapDragged));
                bitmapOverlayImgView.addGestureRecognizer(panRecognizer);
                
                let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleBitmapOverlayPinch));
                self.view.addGestureRecognizer(pinchRecognizer);
            }
        }
    }
    
    @objc func handleBitmapOverlayPinch(_ sender:UIPinchGestureRecognizer){
        let recognizer = sender.view;
        let state = sender.state;
        let recognizerView:UIImageView = bitmapOverlayImgView;
        if (state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.changed)
        {
            let scale  = sender.scale;
            recognizerView.transform = view.transform.scaledBy(x: scale, y: scale);
            recognizer?.contentScaleFactor = 1.0;
        }
        if(state == UIGestureRecognizer.State.ended){
            bitmapOverlayImgView.frame = CGRect(x: recognizerView.frame.origin.x, y: recognizerView.frame.origin.y, width: recognizerView.frame.size.width, height: recognizerView.frame.size.height);
        }
    }
    
    @objc func handleBitmapDragged(_ sender:UIPanGestureRecognizer){
        let recognizer:UIImageView = bitmapOverlayImgView;
        self.view.bringSubviewToFront(recognizer)
        let translation = sender.translation(in: recognizer)
        recognizer.center = CGPoint(x: recognizer.center.x + translation.x, y: recognizer.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: recognizer)
        
        bitmapOverlayImgView.frame = CGRect(x: recognizer.frame.origin.x, y: recognizer.frame.origin.y, width: recognizer.frame.size.width, height: recognizer.frame.size.height);
    }
    
    //MARK: - WOWZStatusCallback Protocol Instance Methods
    
    func onWOWZStatus(_ status: WOWZStatus!) {
        switch (status.state) {
        case .idle:
            DispatchQueue.main.async { () -> Void in
                //self.broadcastButton.setImage(UIImage(named: "start_button"), for: UIControl.State())
                self.updateUIControls()
            }
            
        case .running:
            DispatchQueue.main.async { () -> Void in
               // self.broadcastButton.setImage(UIImage(named: "stop_button"), for: UIControl.State())
                self.updateUIControls()
            }
        case .stopping, .starting:
            DispatchQueue.main.async { () -> Void in
                self.updateUIControls()
            }
            
        case .buffering: break
        default: break
        }
    }
    
    func onWOWZEvent(_ status: WOWZStatus!) {
        // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
        // but only if we haven't already shown an alert for this event
        
        DispatchQueue.main.async { () -> Void in
            if !self.receivedGoCoderEventCodes.contains(status.event) {
                self.receivedGoCoderEventCodes.append(status.event)
                self.showAlert("Live Streaming Event", status: status)
            }
            
            self.updateUIControls()
        }
    }
    
    func onWOWZError(_ status: WOWZStatus!) {
        // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
        DispatchQueue.main.async { () -> Void in
            self.showAlert("Live Streaming Error", status: status)
            self.updateUIControls()
        }
    }
    
    
    //MARK: - WOWZZVideoSink Protocol Methods
    
    func videoFrameWasCaptured(_ imageBuffer: CVImageBuffer, framePresentationTime: CMTime, frameDuration: CMTime) {
        if goCoder != nil && goCoder!.isStreaming && blackAndWhiteVideoEffect {
            // convert frame to b/w using CoreImage tonal filter
            var frameImage = CIImage(cvImageBuffer: imageBuffer)
            if let grayFilter = CIFilter(name: "CIPhotoEffectTonal") {
                grayFilter.setValue(frameImage, forKeyPath: "inputImage")
                if let outImage = grayFilter.outputImage {
                    frameImage = outImage
                    
                    let context = CIContext(options: nil)
                    context.render(frameImage, to: imageBuffer)
                }
            }
        }
        
        if goCoder != nil && goCoder!.isStreaming && bitmapOverlayVideoEffect {
            let wowzOverlayImg = bitmapOverlayImgView.image?.ciImage;
            CVPixelBufferLockBaseAddress(imageBuffer, []);
            let context = CGContext(data: CVPixelBufferGetBaseAddress(imageBuffer),
                                    width: CVPixelBufferGetWidth(imageBuffer),
                                    height: CVPixelBufferGetHeight(imageBuffer),
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(imageBuffer),
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue );
            
            let rect:CGRect = bitmapOverlayImgView.frame;
            let height = goCoderConfig.videoHeight+100; /// accommodating for header / footer areas
            let y = CGFloat(height) - rect.origin.y;
            let newFrame:CGRect = CGRect(x: rect.origin.x, y: y, width: bitmapOverlayImgView.frame.size.width, height: bitmapOverlayImgView.frame.size.height);
            
            let cgImage: CGImage? = bitmapOverlayImgView.image?.cgImage;
            context?.draw(cgImage!, in: newFrame);
            CVPixelBufferUnlockBaseAddress(imageBuffer, []);
            
            if wowzOverlayImg != nil
            {
                let contextOverlay = CIContext(options: nil)
                contextOverlay.render(wowzOverlayImg!, to: imageBuffer)
            }
        }
    }
    
    func videoCaptureInterruptionStarted() {
        goCoder?.endStreaming(self)
    }
    
    
    //MARK: - WOWZAudioSink Protocol Methods
    
    func audioLevelDidChange(_ level: Float) {
        //        print("Audio level did change: \(level)");
    }
    
    
    //MARK: - Alerts
    
    func showAlert(_ title:String, status:WOWZStatus) {
        let alertController = UIAlertController(title: title, message: status.description, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(_ title:String, error:NSError) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
    
// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResponderCollectionViewCell.identifier, for: indexPath)
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate

extension HomeViewController: UIGestureRecognizerDelegate {
    // Solution
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
//
//        let y = view.frame.minY
//        if y == minY && tableView.contentOffset.y == 0 && direction > 0 || y == thumbnailHeight {
//            tableView.isScrollEnabled = false
//        }
//        else {
//            tableView.isScrollEnabled = true
//        }
//
//        return false
//    }
    
}
