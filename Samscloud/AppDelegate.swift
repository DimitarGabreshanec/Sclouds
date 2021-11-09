//
//  AppDelegate.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
//import WowzaGoCoderSDK
import Firebase
import FirebaseMessaging
import GoogleMaps
import Starscream
import SwiftyJSON


let userDefault = UserDefaults.standard
let kAppDelegate = (UIApplication.shared.delegate as? AppDelegate)!



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var navController: UINavigationController!
    var locManager = CLLocationManager.init()
    
    var locationManager = CLLocationManager.init()
    
    var currentLocation: CLLocation!
    var curLongitude: Double = 0.0
    var curaltitude: Double = 0.0
    var curSpeed: Double = 0.0
    var curAltitude: Double = 0.0
    var checkValue: Int = 0
    var shakeFlag: Bool?
    var shakeFlagOn: Bool = true
    var shakeFlagOnSet: Bool = true
    
    var cameraStop: Bool = true
    var verifyFlag: Bool = false
    
    var tokenAuth: String = ""
    var refreshTokenAuth: String = ""
    var organizationArray = [Organization]()
    var curTime: String = ""
    var notiFlag: Bool = true
    var currentVC:UIViewController?
    var addressStr:String?
    var addressNameStr:String?
    
    var homeVC:HomeViewController?
    var webSocket:WebSocket?
    var notificationSocket:WebSocket?
    
    var isFirstTimeLocationUpdateDone = false
    var locationTimer:Timer?
    var nearbyPlaces = [PlaceResult]()
    
    var startLongitude: Double = 0.0
    var startLaltitude: Double = 0.0
    var area:String?
    var socketTimer:Timer?
    var addressOnly:String?
    
    var currentLocationForShare:CLLocation?
    var currentAddressForShare:String?
    var locationUpdateTimer:Timer?
    
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    
    class func shared() -> AppDelegate! {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.registerForPushNotifications(application)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KeychainManager.clearOnFirstLaunch()
        BASE_URL = Constants.STAGING_URL
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        kAppDelegate.organizationArray.removeAll()
        //requestForLocation()
        
        GMSServices.provideAPIKey(GoogleApiKey)
        
        let userUpdateNotification = Notification.Name("userUpdate")
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(not:)), name: userUpdateNotification, object: nil)
        configAppearance()
        
        let auth = DefaultManager().getToken() ?? ""
        print("auth token -> \(auth)")
        if(!auth.isEmpty){
            addFcmToken()
            AppState.setHomeVC()
        }
        
        shakeFlag = DefaultManager().getShake() ?? false
        
        if let share_location = DefaultManager().getShareLocationStatus(), share_location == true {
            self.startLocationUpdate()
        }
        
        
        
        return true
    }
    
    func requestForLocation() {
        DefaultManager().setShareLocationStatus(value: true)
        //SwiftLoader.show(title: "Fetching Location...", animated: true)
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
//        bgTask = application.beginBackgroundTask(withName:"MyBackgroundTask", expirationHandler: {() -> Void in
//            // Do something to stop our background task or the app will be killed
//            application.endBackgroundTask(self.bgTask)
//            self.bgTask = UIBackgroundTaskIdentifier.invalid
//        })
//
//        DispatchQueue.global(qos: .background).async {
//            appDelegate.homeVC?.endIncident(msg: "App Killed")
//            //make your API call here
//        }
        appDelegate.homeVC?.endIncident(msg: "Please call me")
        sleep(5)
        print("Application terminated")
    }
    
    
    // MARK: - ACTIONS
    
    func testToken() { // set Token for testing
        let token =  "54M5CL0UD-T0K3N"
        UserDefaults.standard.setAuthenticationToken(token)
    }
    
    fileprivate func configAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularStdBold(size: 18),NSAttributedString.Key.foregroundColor: UIColor.blackTextColor()]
        UINavigationBar.appearance().tintColor = UIColor.mainColor()
        UINavigationBar.appearance().barTintColor = UIColor.white
    }
    
    
    //MARK: - LOCATION
    
    @objc func updateUser(not: Notification) { // location for
        NotificationCenter.default.post(name: NSNotification.Name("userUpdate11"), object: self, userInfo: ["1": "1"])
    }
    
    
    // MARK: - PUSH NOTIFICATIONS
    @objc func notificationEable(not: Notification) {
        notiFlag = false
        kAppDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            application.registerForRemoteNotifications()
        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        
        let json = JSON.init(info)
        print(json)
        
        let action = info["action"] as? String
        let noti_type = info["type"] as? String
        
        if action == "incident_share" {
            //self.processIncidentShare(json)
            completionHandler([.alert, .badge, .sound])
            return
        }else if action == "responder_alert" {
            completionHandler([.alert, .badge, .sound])
            //self.processIncidentShare(json)
            return
        }else if action == "incident_ended" {
            self.processEndIncident()
            completionHandler([.alert, .badge, .sound])
            return
        } else if action == "emergency_contact_response" {
            self.processEmergencyContact(json)
            completionHandler([.alert, .badge, .sound])
            return
        }
        
        if noti_type == "request-check-in" {
            completionHandler([.alert, .badge, .sound])
        }else if noti_type == "contact-location-update" {
            completionHandler([.alert, .badge, .sound])
        }else if noti_type == "share_location" {
            completionHandler([.alert, .badge, .sound])
        }
        
        guard let type = info["type"] as? String else {return}
        let state = UIApplication.shared.applicationState
        
        if type == "responder_joined" {
            if state == .active {
                self.processResponder(info)
            }else{
                self.perform(#selector(processResponder(_:)), with: info, afterDelay: 2.5)
            }
            //self.homeVC?.showMessage("")
            return
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    // @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let info = response.notification.request.content.userInfo
        let json = JSON.init(info)
        let state = UIApplication.shared.applicationState
        
        print(json)
        
        let action = info["action"] as? String
        let noti_type = info["type"] as? String
        
        if action == "incident_share" {
            if state == .active {
                self.processIncidentShare(json)
            }else{
                self.perform(#selector(processIncidentShare(_:)), with: json, afterDelay: 1.5)
            }
            return
        }else if action == "responder_alert" {
            if state == .active {
                self.processIncidentShare(json)
            }else{
                self.perform(#selector(processIncidentShare(_:)), with: json, afterDelay: 1.5)
            }
            return
        } else if action == "emergency_contact_response" {
            if state == .active {
                self.processEmergencyContact(json)
            }else{
                self.perform(#selector(processEmergencyContact(_:)), with: json, afterDelay: 1.5)
            }
            return
        }
        
        if noti_type == "request-check-in" {
            if state == .active {
                self.processRequestCheckin(info)
            }else{
                self.perform(#selector(processRequestCheckin(_:)), with: info, afterDelay: 2.5)
            }
            completionHandler()
        }else if noti_type == "contact-location-update" {
            if state == .active {
                self.processRequestCheckinUpdate(info)
            }else{
                self.perform(#selector(processRequestCheckinUpdate(_:)), with: info, afterDelay: 2.5)
            }
            completionHandler()
        }else if noti_type == "share_location" {
            if state == .active {
                self.processLocationShare(info)
            }else{
                self.perform(#selector(processLocationShare), with: info, afterDelay: 2.5)
            }
            completionHandler()
        }
        
        guard let type = info["type"] as? String else {return}
        
        
        if type == "accept_contact" {
            if state == .active {
                self.processContact(info)
            }else{
                self.perform(#selector(processContact(_:)), with: info, afterDelay: 2.5)
            }
        }
        /*else if type == "responder_joined" {
         if state == .active {
         self.processResponder(info)
         }else{
         self.perform(#selector(processResponder(_:)), with: info, afterDelay: 2.5)
         }
         }*/
        completionHandler()
    }
    
    // @available(iOS 10.0, *)
    private func processNotification(_ notif: UNNotification) {
        print("PROCESSING NOTIFICATION - APP DELEGATE")
    }
    
    

    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
    }
    
    func sendNot (_ title: String, _ body: String) {
        let notificationCenter = UNMutableNotificationContent()
        notificationCenter.title = title  //dict123s.string("title")//"\(dict123s["title"] as! String)"
        notificationCenter.body = body    //dict123s.string("body")//"\(dict123s["body"] as! String)"
    }
    
    // MARK: -  OPEN URL
    
    @available(iOS 9.0, *)
    private func application(_ app: UIApplication,
                             open url: URL,
                             options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        print("URL.SCHEME = \(url.scheme!)")
        print("URL.DESCRIPTION: ",url.description)
        if(url.scheme!.isEqual("Samscloud")) {
            //  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            // let otpVC = AppSharedData.sharedData.getViewController(controllerIdentifier: "PersonalInfoViewController")
            //  UIApplication.shared.delegate?.window
            //            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            //            let ResetViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ResetViewController") as! ResetViewController
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.window?.rootViewController = ResetViewController
        } else {
            print("NOT THE SCHEME WE'RE EXPECTING")
        }
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token is \(token)")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        
        
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication,
                     handleOpen url: URL) -> Bool {
        //AppSharedData.sharedData.showMessageView(title: "Error", withMessage: "Data" )
        // Do something with the url here
        //        if (url.scheme == INSTAGRAM_SCHEME) {
        //            return instagram.handleOpen(url)
        //        }
        //        if (url.scheme == FACEBOOK_SCHEME) {
        //            return PFFacebookUtils.handleOpen(url)
        //        }
        return true
    }
    
    
    
    
    func startUpdatingEverySecond() {
        locationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
            self.update()
        })
    }
    
    
    @objc func update() {
        
        let now_location = CLLocation.init(latitude: curaltitude, longitude: curLongitude)
        let start_location = CLLocation.init(latitude: startLaltitude, longitude: startLongitude)
        
        let distanse = now_location.distance(from: start_location)
        
        //print("Distnace -------->>>>>",distanse)
        
        if distanse < 2000 {
            getAddressFromLocation(loc: now_location) { (addressStr) in
                self.homeVC?.lblAddress.text = addressStr
            }
            appDelegate.homeVC?.checkNearByOrganization()
        }else{
            isFirstTimeLocationUpdateDone = false
            locationTimer?.invalidate()
        }
        //updateReporteLocatoin()
    }
    
}












extension AppDelegate :MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM TOKEN ------",fcmToken)
        DefaultManager().setFcmToken(value: fcmToken)
        addFcmToken()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
    

    
    
    
    func addFcmToken() {
        guard let name = DefaultManager().getName() else {return}
        
        let param:[String:Any] = [
            "name":name,
            "active":true,
            "device_id":UIDevice.current.identifierForVendor?.uuidString ?? "",
            "registration_id":DefaultManager().getFcmToken() ?? ""
        ]
        
        let url = BASE_URL + Users.ADD_FCM_TOKEN
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, stausCode) in
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response {
                print(json)
            }
        }
    }
    
    
    @objc func processContact(_ userInfo:[AnyHashable : Any]) {
        
        guard let aps = userInfo["aps"] as? [AnyHashable : Any] else {return}
        guard let alert = aps["alert"] as? [AnyHashable : Any] else {return}
        guard let title = alert["title"] as? String else {return}
        guard let message = alert["body"] as? String else {return}
        
        guard let vc = self.currentVC else {return}
        
        showContactAlert(message, title, vc) { (isAccepted) in
            if isAccepted {
                self.acceptRejectContact("Accepted", info: userInfo)
            }else{
                self.acceptRejectContact("Rejected", info: userInfo)
            }
        }
    }
    
    
    @objc func processResponder(_ userInfo:[AnyHashable : Any]) {
        /*guard let aps = userInfo["aps"] as? [AnyHashable : Any] else {return}
         guard let alert = aps["alert"] as? [AnyHashable : Any] else {return}
         guard let title = alert["title"] as? String else {return}
         guard let message = alert["body"] as? String else {return}*/
        appDelegate.homeVC?.getResponderList()
    }
    
    
    @objc func processRequestCheckin(_ userInfo:[AnyHashable : Any]) {
        
        guard let aps = userInfo["aps"] as? [AnyHashable : Any] else {return}
        guard let alert = aps["alert"] as? [AnyHashable : Any] else {return}
        guard let title = alert["title"] as? String else {return}
        guard let message = alert["body"] as? String else {return}
        
        guard let vc = self.currentVC else {return}
        
        showContactAlert(message, title, vc) { (isAccepted) in
            if isAccepted {
                self.acceptRejectRequestCheckin("Accepted", info: userInfo)
            }else{
                self.acceptRejectContact("Rejected", info: userInfo)
            }
        }
    }
    
    
    @objc func processRequestCheckinUpdate(_ userInfo:[AnyHashable : Any]) {
        let addFamilyOnContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyOnContactVC")
        self.homeVC?.navigationController?.pushViewController(addFamilyOnContactVC, animated: true)
    }
    
    
    @objc func processLocationShare(_ userInfo:[AnyHashable : Any]) {
        let addFamilyOnContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AddFamilyOnContactVC")
        let vc = UIApplication.topViewController()?.navigationController
        vc?.pushViewController(addFamilyOnContactVC, animated: true)
    }
    
    @objc func processEmergencyContact(_ userInfo: Any) {
        if let controller = UIApplication.topViewController() as? AddFamilyOnContactViewController {
            controller.getUserContacts()
        }
    }
    
    @objc func processIncidentShare(_ userInfo:Any) {
        guard let json = userInfo as? JSON else {return}
        
        print(json)
        
        let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentNC") as! UINavigationController
        ongoingIncidentVC.modalPresentationStyle = .fullScreen
        let vc = ongoingIncidentVC.viewControllers.first as? OngoingIncidentViewController
        let incident = OngoingIncidentModel.init(json: json)
        if json["user"].string != nil {
            let user = JSON.init(json["user"].stringValue)
            incident.user = IncidentUserModel.init(json: user)
        }
        vc?.incident = incident
        
        
        let incidentHistoryNC = StoryboardManager.contactStoryBoard().getController(identifier: "IncidentHistoryNC") as! UINavigationController
        incidentHistoryNC.modalPresentationStyle = .fullScreen
        
        let incidentHistoryVC = incidentHistoryNC.topViewController as! IncidentHistoryViewController
        incidentHistoryVC.incidentModel = incident
        
        
        DispatchQueue.main.async {
            
            if incident.is_ended == true || incident.is_stopped == true{
                if let _ = UIApplication.topViewController() as? IncidentHistoryViewController {
                    UIApplication.topViewController()?.present(incidentHistoryNC, animated: true, completion: nil)
                }else{
                    let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                    mainTabBarVC.defaultIndex = 2
                    let navigation = UIApplication.topViewController()?.navigationController
                    navigation?.pushViewController(mainTabBarVC, animated: true)
                    
                    if let vc = mainTabBarVC.viewControllers?[2] as? IncidentViewController {
                        vc.selectedIndex = 1
                    }
                    
                    UIApplication.topViewController()?.present(incidentHistoryNC, animated: true, completion: nil)
                }
            }else{
                if let _ = UIApplication.topViewController() as? IncidentViewController {
                    UIApplication.topViewController()?.present(ongoingIncidentVC, animated: true, completion: nil)
                }else{
                    let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
                    mainTabBarVC.defaultIndex = 2
                    let navigation = UIApplication.topViewController()?.navigationController
                    navigation?.pushViewController(mainTabBarVC, animated: true)
                    
                    UIApplication.topViewController()?.present(ongoingIncidentVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func processEndIncident() {
        if let vc = UIApplication.topViewController() as? OngoingIncidentViewController {
            vc.closeButtonAction(UIButton())
        }
    }
}






