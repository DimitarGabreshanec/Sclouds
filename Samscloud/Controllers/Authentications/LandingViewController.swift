//
//  LandingViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import MobileCoreServices


class LandingViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var movieTitle = "Movie"
    var movieType = "m4v"
    var loop = false
    var movieURL: URL? {
        get {
            var url:URL?
            if let moviePath = Bundle.main.path(forResource: movieTitle, ofType: movieType) {
                url = URL(fileURLWithPath: moviePath)
            }
            return url
        }
    }

    //Mark: - Open camera for demo
    var imagePicker = UIImagePickerController()
    
    //Cerma open
    func videoLibrary(){
        /*if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.camera;
            imag.cameraDevice = UIImagePickerController.CameraDevice.rear //or Front
            imag.mediaTypes = [kUTTypeMovie] as [String];
            self.present(imag, animated: true, completion: nil)
        }*/
    }
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var settingsButton:UIButton!
    @IBOutlet var broadcastButton:UIButton!
    @IBOutlet weak var startedButton: UIButton!
    @IBOutlet weak var btnDemo: UIButton!
    
    
    // MARK: - INIT
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let refreshToken =  DefaultManager().getRefreshToken()  ?? ""
        
        if(!refreshToken.isEmpty){
            
            let param = ["refresh":refreshToken]
            
            PSApi.apiRequestWithEndPointSome(.refreshToken, params: param as [String : AnyObject], isShowAlert: true, controller: self, isNeedToken: false) { (response) in
                
                let statusCode = response.response?.statusCode
                if  statusCode == 200 {
                    _ = Refresh.init(dictUserData: response.value?.dictionary ?? [:])
                } else {
                    Utility.SubmitAlertView(viewController: self, title: "Alert!", message: "Opp! Something event wrong")
                }
            }
        }
        
        startedButton.roundRadius()
        // Reload any saved data
        imagePicker.delegate = self
        videoLibrary()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: - ACTIONS
    
    func setupAssetReader() -> Bool {
        // create an AVAsset for reading
       /* guard let assetURL = self.movieURL else {
            return false
        }
        videoAsset = AVAsset(url: assetURL)
        let videoTracks = videoAsset!.tracks(withMediaType: AVMediaType.video)
        guard let track = videoTracks.first else {
            return false
        }
        videoTrack = track
        guard let reader = try? AVAssetReader(asset: self.videoAsset!) else {
            return false
        }
        assetReader = reader
        let options: [String : AnyObject] = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)]
        readerOutput = AVAssetReaderTrackOutput(track: track, outputSettings: options)
        reader.add(readerOutput)*/
        return true
    }
    
  
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.title = "Choose Video"
    }
    
  
    
    
    //MARK: - IBACTIONS
    
    @IBAction func actionGetStart(_ sender: Any) {
        print("ACTION GET START BUTTON PRESSED")
        
    }
    
    @IBAction func didTapSettings(_ sender:AnyObject?) {
        print("DID TAP SETTINGS ACTION PRESSED")
       
    }
    
    @IBAction func didTapBroadcast(_ sender:AnyObject?) {
        print("DID TAP BROADCAST ACTION PRESSED")
        
    }
    
    @IBAction func didTapLoopButton(_ sender:AnyObject?) {
        
    }
    
}






extension LandingViewController {
    
    
    class func makeRoot() {
        let container = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = container.instantiateViewController(withIdentifier: "LandingVC") as! LandingViewController
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
