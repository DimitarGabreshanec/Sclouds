//
//  HomeViewController+Wowza.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 05/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import AVFoundation
//import WowzaGoCoderSDK
import CoreLocation
import SwiftyJSON



extension HomeViewController:AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setupCamera(flag: Bool) {
        /*self.captureSession?.stopRunning()
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        if let availabeDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices as? [AVCaptureDevice] {
            captureDevice = availabeDevices.first
            beginSession(flag: flag)
        }*/
    }
    
    func beginSession(flag: Bool) {
        
        /*if Platform.isSimulator {return}
        guard let device = captureDevice else {return}
        guard let session = captureSession else {return}
        //guard let layer = previewLayer else {return}
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: device) else {return}
        
        let inputs = session.inputs as? [AVCaptureDeviceInput]
        inputs?.forEach({
            session.removeInput($0)
        })

        session.addInput(captureDeviceInput)
        //begin layer setup use session to display camera input through layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer = previewLayer
        previewLayer.videoGravity = .resizeAspectFill
        
        if flag {
             //self.goCoder?.cameraPreview?.previewLayer
            //self.viewMain.frame = view.bounds
            self.previewLayer?.frame = self.switchView.bounds
            self.switchView.layer.addSublayer(layer)
            receivedGoCoderEventCodes.removeAll()
            //viewMain.frame = CGRect(x: 0, y: 0, width: 1024, height: 500)
            self.goCoder?.cameraView = self.switchView
            //captureSession.startRunning()
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if session.canAddOutput(dataOutput) {
                session.addOutput(dataOutput)
            }
            session.commitConfiguration()
            let queue = DispatchQueue(label: "com.mikaelTeklehaimanot.captureSessionQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
                if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                    goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                    goCoder?.config = goCoderConfig
                }
                goCoder?.cameraPreview?.switchCamera()
                self.updateUIControls()
            }
            goCoder?.cameraPreview?.switchCamera()
            //torchButton.setImage(UIImage(named: "torch_on_button"), for: UIControl.State())
            self.updateUIControls()
        } else {
            self.innerView.frame = view.bounds
            //layer.frame = self.innerView.layer.frame
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            innerView.layer.masksToBounds = true
            self.innerView.layer.addSublayer(layer)
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if session.canAddOutput(dataOutput) {
                session.addOutput(dataOutput)
            }
            session.commitConfiguration()
            let queue = DispatchQueue(label: "com.mikaelTeklehaimanot.captureSessionQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            if let otherCamera = goCoder?.cameraPreview?.otherCamera() {
                if !otherCamera.supportsWidth(goCoderConfig.videoWidth) {
                    goCoderConfig.load(otherCamera.supportedPresetConfigs.last!.toPreset())
                    goCoder?.config = goCoderConfig
                }
                goCoder?.cameraPreview?.switchCamera()
                self.updateUIControls()
            }
            self.updateUIControls()
        }*/
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
        
        guard let session = captureSession else {return}
        if let inputs = session.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                session.removeInput(input)
            }
        }
    }
    
    func setPropertyAndCameraPreview() {
        
       /* if !goCoderRegistrationChecked {
            if let licensingError = WowzaGoCoder.registerLicenseKey(SDKSampleAppLicenseKey) {
                self.showAlert("GoCoder SDK Licensing Error", error: licensingError as NSError)
            } else { // No Wowza licensing error
                //goCoderRegistrationChecked = true
                // Initialize the GoCoder SDK
                if let shared = WowzaGoCoder.sharedInstance() { // This is nil if licensing failed
                                // idle
                    self.goCoder = shared
                   
                    WowzaGoCoder.requestPermission(for: .camera, response: { (permission) in
                        
                    })
                    
                    WowzaGoCoder.requestPermission(for: .microphone, response: { (permission) in
                       
                    })
                    
                    self.goCoder?.register(self as WOWZAudioSink)
                    self.goCoder?.register(self as WOWZVideoSink)
                    self.cameraPreview()
                    //1935//8088
                    self.configureWowza()
                    goCoderConfig.audioEnabled = true
                    goCoderConfig.videoEnabled = true
                    
                    goCoderConfig.audioSampleRate = 22100
                    // Set the frame rate to 15 fps
                    goCoderConfig.videoFrameRate = 15;
                    // Set the keyframe interval to 10 frames
                    goCoderConfig.videoKeyFrameInterval = 10;
                    // Set the bitrate to 2.5 kbps
                    goCoderConfig.videoBitrate = 2500;
                    
                    self.goCoder?.config = self.goCoderConfig       // Audio / video / stream
                    // Specify the view in which to display the camera preview
                    //viewMain.frame = CGRect(x: -300, y: 0, width: 1024, height: 800)
                    print(fullFrame)
                    switchView.frame = fullFrame
                    self.goCoder?.cameraView = self.switchView // Setting cameraView auto. sets  cameraPreview
                    // Start the camera preview
                    self.goCoder?.cameraPreview?.previewLayer?.frame = switchView.bounds
                    self.goCoder?.cameraPreview?.previewGravity = .resizeAspectFill
                    self.goCoder?.cameraPreview?.start() // Did setup; start cameraPreview
                }
                self.updateUIControls()
            }
        } else {
            self.goCoder?.cameraPreview?.previewGravity = .resizeAspectFill
            self.goCoder?.cameraPreview?.start()
        }*/
    
    }
    
    
    func configureWowza() {
      
    }
    
    // MARK: - ACTIONS
    func updateUIControls() {
        /*print("PRINTING SELF.GOCODER.STATUS.STATE: \(String(describing: self.goCoder?.status.state.rawValue))") // idle = 0, starting = 1, running = 2, stopping = 3
        if self.goCoder?.status.state != .idle && self.goCoder?.status.state != .running { // Not idle nor running          // buffering = 4, ready = 5
            // If a streaming broadcast session is in the process of starting up or shutting down,
            // disable the UI controls
            //self.broadcastButton.isEnabled    = false
            // self.torchButton.isEnabled        = false
            //self.switchCameraButton.isEnabled = false
            //self.settingsButton.isEnabled     = false
            // self.micButton.isHidden           = true
            //self.micButton.isEnabled          = false
        } else { // Is idle or running
            // Set the UI control state based on the streaming broadcast status, configuration,
            // and device capability
            //self.broadcastButton.isEnabled    = true
            // self.switchCameraButton.isEnabled = ((self.goCoder?.cameraPreview?.cameras?.count) ?? 0) > 1
            //self.torchButton.isEnabled        = self.goCoder?.cameraPreview?.camera?.hasTorch ?? false
            let isStreaming                 = self.goCoder?.isStreaming ?? false; print(isStreaming)
            //self.settingsButton.isEnabled     = !isStreaming
            // The mic icon should only be displayed while streaming and audio streaming has been enabled
            // in the GoCoder SDK configuration setiings
            // self.micButton.isEnabled          = isStreaming && self.goCoderConfig.audioEnabled
            //self.micButton.isHidden           = !self.micButton.isEnabled
            print("BITMAP_OVERLAY_VIDEO_EFFECT: \(!self.bitmapOverlayVideoEffect)")
            //print("======\(!(self.bitmapOverlayImgView != nil))")
            self.bitmapOverlayImgView.isHidden = !self.bitmapOverlayVideoEffect
            if (bitmapOverlayVideoEffect) {
                let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBitmapDragged))
                bitmapOverlayImgView.addGestureRecognizer(panRecognizer)
                let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleBitmapOverlayPinch))
                self.view.addGestureRecognizer(pinchRecognizer);
            }
        }*/
    }
    
    @objc func handleBitmapOverlayPinch(_ sender:UIPinchGestureRecognizer){
        let recognizer = sender.view;
        let state = sender.state;
        let recognizerView:UIImageView = bitmapOverlayImgView;
        if (state == UIGestureRecognizer.State.began || state == UIGestureRecognizer.State.changed) {
            let scale  = sender.scale;
            recognizerView.transform = view.transform.scaledBy(x: scale, y: scale);
            recognizer?.contentScaleFactor = 1.0;
        }
        if (state == UIGestureRecognizer.State.ended) {
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
    
    func cameraPreview() {
        
    }
    
    
    // MARK: -  ACTIONS
    func tapLargeVideo(isLargeVideo: Bool) {
        responderCountLabel.isHidden = isLargeVideo
        collectionView.isHidden = isLargeVideo
        locationButton.isHidden = isLargeVideo
        mapImageView.isHidden = isLargeVideo
        backgroundImageView.isHidden = !isLargeVideo
        videoImageView.image = isLargeVideo ? UIImage(named: "video-map") : UIImage(named: "home-small")
    }
    
}

































extension HomeViewController {
    
    
    
    func setupWowza() {
        
        
    }
    
    
    
    func configureWowzaSDK() {
        
        
        
    }
    
    
}





//MARK:- WOWZA APIs
extension HomeViewController {
    
    
    @objc func createTranscoder() {
        
        /*let url = "https://cloud.wowza.com/api/v1.3/transcoders"
        
        let dict:[String:Any] = [
            "billing_mode": "pay_as_you_go",
            "broadcast_location": "asia_pacific_india",
            "delivery_method": "push",
            "name": " MyQuickStartTranscoder",
            "protocol": "rtsp",
            "transcoder_type": "transcoded"
        ]
        
        let finalDict:[String:Any] = [
            "transcoder":dict
        ]
        
        print(JSON.init(finalDict))
        
        
        let header:[String:String] = [
            "wsc-api-key":wsc_api_key,
            "wsc-access-key":wsc_access_key
        ]
        
        //SwiftLoader.show(title: "Starting....", animated: true)
        
        APIsHandler.POSTApi(url, param: finalDict, header: header) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.createStreamAPI()
                //self.perform(#selector(self.createStreamAPI), with: nil, afterDelay: 0.0)
            }
        }*/
        
    }
    
    
    @objc func createStreamAPI() {
        
        /*let url = "https://api.cloud.wowza.com/api/v1.3/live_streams"
        
        let dict:[String:Any] = [
            "aspect_ratio_height": 1080,
            "aspect_ratio_width": 1920,
            "billing_mode": "pay_as_you_go",
            "broadcast_location": "asia_pacific_india",
            "encoder": "wowza_gocoder",
            "name": "Incident",
            "transcoder_type": "transcoded",
            "closed_caption_type": "none",
            "delivery_method": "push",
            "delivery_protocols": "rtsp",
            "delivery_type": "single-bitrate",
            "disable_authentication": false,
            "hosted_page": true,
            "hosted_page_description": "My Hosted Page Description",
            "low_latency": true,
            //"player_countdown": true,
            //"player_countdown_at": "2019-01-30 17:00:00 UTC",
            //"player_logo_image": "[Base64-encoded string representation of GIF, JPEG, or PNG file]",
            //"player_logo_position": "top-right",
            "player_responsive": true,
            "player_type": "wowza_player",
            //"player_video_poster_image": "[Base64-encoded string representation of GIF, JPEG, or PNG file]",
            "player_width": 0,
            "recording": true,
            "remove_hosted_page_logo_image": true,
            "remove_player_logo_image": true,
            "remove_player_video_poster_image": true,
            //"source_url": "xyz.streamlock.net/vod/mp4:Movie.mov",
            "target_delivery_protocol": "hls-https",
            "use_stream_source": false,
            "username":"wowza",
            "password":"wowza"
        ]
        
        let finalDict:[String:Any] = [
            "live_stream":dict
        ]
        
        print(JSON.init(finalDict))
        //SwiftLoader.show(title: "Creating Stream", animated: true)
        let header:[String:String] = [
            "wsc-api-key":wsc_api_key,
            "wsc-access-key":wsc_access_key
        ]
        
        //SwiftLoader.show(title: "Creating Stream....", animated: true)
        
        APIsHandler.POSTApi(url, param: finalDict, header: header) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.wowzaStreamModel = WowzaStreamModel(json: json["live_stream"])
                self.configureWowza()
                self.startStreamAPI()
                //self.perform(#selector(self.startStreamAPI), with: nil, afterDelay: 0.5)
            }
        }*/
    }
    
    @objc func startStreamAPI() {
        
        /*guard let id = wowzaStreamModel?.id else {return}
        
        let header:[String:String] = [
            "wsc-api-key":wsc_api_key,
            "wsc-access-key":wsc_access_key
        ]
        
        let url = "https://api.cloud.wowza.com/api/v1.3/live_streams/\(id)/start"
        //SwiftLoader.show(title: "Starting...", animated: true)
        
        APIsHandler.PUTApi(url, param: nil, header: header) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                //self.perform(#selector(self.broadCastStart1), with: nil, afterDelay: 5)
                //self.handleClickCenterButton(isStartButton: true)
                //self.broadCastStart1()
                self.createIncident(message: "")
                //self.perform(#selector(self.createIncident(message:)), with: "", afterDelay: 0.0)
                let id =  self.wowzaStreamModel?.id ?? ""
                self.patchIncidentStreamId(id: id)
            }
        }*/
            
    }
    
    @objc func stopStreamAPI() {
        
        /*guard let id = wowzaStreamModel?.id else {return}
        
        let header:[String:String] = [
            "wsc-api-key":wsc_api_key,
            "wsc-access-key":wsc_access_key
        ]
        
        let url = "https://api.cloud.wowza.com/api/v1.3/live_streams/\(id)/stop"
        //SwiftLoader.show(title: "Starting...", animated: true)
        
        APIsHandler.PUTApi(url, param: nil, header: header) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                //self.perform(#selector(self.broadCastStart1), with: nil, afterDelay: 5)
                //self.handleClickCenterButton(isStartButton: true)
                //self.broadCastStart1()
                //self.createIncident(message: "")
                //self.perform(#selector(self.createIncident(message:)), with: "", afterDelay: 0.0)
                let id =  self.wowzaStreamModel?.id ?? ""
                self.patchIncidentStreamId(id: id)
            }
        }*/
            
    }
    
    func handleStopStream() {
        self.session.stopLive()
        //flushAllStreas()
        stopIncident()
    }
    
    func handleEndStream() {
        self.session.stopLive()
        //flushAllStreas()
        endIncident(msg: "Please Call Me")
    }
    
    
    func flushAllStreas() {
        
        for (index,obj) in conferrenceRoomData.enumerated() {

            let indexPath = IndexPath.init(item: index, section: 0)
            let cell = responderStreamCollection.cellForItem(at: indexPath) as? ResponderStreamCell
            
            if cell?.client != nil {
               cell?.client?.stop()
            }
            cell?.removeFromSuperview()
            cell?.isLoaded = false
        
        }
        conferrenceRoomData.removeAll()
        responderStreamCollection.reloadData()
    }
    
}
