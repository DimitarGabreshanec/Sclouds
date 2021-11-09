//
//  PermissionViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//
import MapKit
import UIKit
protocol PermissionViewControllerDelegate {
    func didFinish()
}
class PermissionViewController: UIViewController ,CLLocationManagerDelegate{
    
    var isLocation = false
    var isflagNav = false
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var delegate:PermissionViewControllerDelegate?
    
    @IBOutlet weak var pushLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblEnable: UILabel!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isflagNav == true {
            dismiss(animated: false, completion: nil)
        }
        enableButton.roundRadius()
        checkPermission()
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnOk.tag = 1
        appDelegate.currentVC = self
    }
    
    
    // MARK: - ACTIONS
    private func checkPermission() {
        if isLocation {
            pushLabel.text = "Share"
            notificationLabel.text = "Location"
            imageView.image = UIImage(named: "location")
            descriptionLabel.text = "Samscloud needs your location to share with responders when you have an emergency or need assistance."
            enableButton.setTitle("Enable Location", for: .normal)
        //    cancelButton.isHidden = true
        } else {
            pushLabel.text = "Push"
            notificationLabel.text = "Notifications"
            imageView.image = UIImage(named: "notification")
            descriptionLabel.text = "Get notified when your family, friends or colleagues need assistance."
            enableButton.setTitle("Enable Notifications", for: .normal)
        }
    }
    
    
    //    // MARK: - IBACTIONS
    
    @IBAction func actionOk(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            btnOk.tag = 2
        } else {
            isflagNav = true
            dismiss(animated: false, completion: nil)
        }
    }
    


    // MARK:- NOTIFICATIONS
    
    func notificationEnable() {
     
    }
    
    
    //MARK: - LOCATIONS
    func locationFind() {
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.first!
        appDelegate.currentLocation = userLocation
        
        manager.stopUpdatingLocation()
        
        if isLocation {
            isLocation = false
            checkPermission()
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("EROR WITH NOTIFICATION: \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization status:",status.rawValue)
    }
    
    // MARK: - IBACTIONS
    @IBAction func enableButtonAction(_ sender: UIButton) {
        if isLocation {
            appDelegate.requestForLocation()
            isLocation = false
            checkPermission()
        } else {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().delegate = appDelegate
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (status, error) in
                        DispatchQueue.main.async {
                            self.delegate?.didFinish()
                            appDelegate.addFcmToken()
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.delegate?.didFinish()
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if isLocation {
            isLocation = false
            checkPermission()
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    
}

