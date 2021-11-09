//
//  HomeViewController+Incident.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 04/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import SwiftyJSON



extension HomeViewController:ContactListViewControllerDelegate {
    
    
    @objc func createIncident(message:String) {

        if appDelegate == nil || appDelegate.currentLocation == nil {
            perform(#selector(createIncident(message:)), with: message, afterDelay: 0.5)
            return
        }
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let long = appDelegate.currentLocation.coordinate.longitude
        let altitude = appDelegate.currentLocation.altitude
        let url = BASE_URL + Constants.INCIDENT_CREATE
        
        let param:[String:Any] = [
            "latitude": "\(lat)",
            "longitude": "\(long)",
            "altitude": "\(altitude)",
            "emergency_message": message,
            "address": self.lblAddress.text ?? "",
            "ending_message": "",
            "is_ended": false,
            "organization": self.incidentModel?.organization?.id ?? "",
            "streaming_id":streamId ?? "",
            "vod_name":streamId ?? ""
        ]
        
        print(JSON.init(param))
        
        //SwiftLoader.show(title: "Creating Incident...", animated: true)
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                if statusCode == 401 {
                    showAlertWithConfirmation("Session expired, please login again", "Message", self) { (code) in
                        
                    }
                    return
                }
                print(json,code)
                self.createIncidentModel = IncidentModel.init(json: json)
                appDelegate.initSocket()
                //self.handleClickCenterButton(isStartButton: true)
                //self.broadCastStart1()
                
                //self.perform(#selector(self.sendIncidentAlrtNotification), with: nil, afterDelay: 0.1)
                //self.getResponderList()
            }
        }
    }
    
    
    
    @objc func createIncidentFromStartButton(message:String) {

        if appDelegate == nil || appDelegate.currentLocation == nil {
            perform(#selector(createIncident(message:)), with: message, afterDelay: 0.5)
            return
        }
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let long = appDelegate.currentLocation.coordinate.longitude
        let altitude = appDelegate.currentLocation.altitude
        let url = BASE_URL + Constants.INCIDENT_CREATE
        
        let param:[String:Any] = [
            "latitude": "\(lat)",
            "longitude": "\(long)",
            "altitude": "\(altitude)",
            "emergency_message": message,
            "address": self.lblAddress.text ?? "",
            "ending_message": "",
            "is_ended": false,
            "organization": self.incidentModel?.organization?.id ?? "",
            "streaming_id":streamId ?? "",
            "vod_name":streamId ?? "",
            "is_started":true
        ]
        
        print(JSON.init(param))
        
        SwiftLoader.show(title: "Creating Incident...", animated: true)
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                if statusCode == 401 {
                    showAlertWithConfirmation("Session expired, please login again", "Message", self) { (code) in
                        
                    }
                    return
                }
                print(json,code)
                self.createIncidentModel = IncidentModel.init(json: json)
                appDelegate.initSocket()
                self.broadCastStart1()
                
                let auto_organization = DefaultManager().getAutoRouteOrganization() ?? false
                let auto_contacts = DefaultManager().getAutoRouteContact() ?? false
                
                if auto_contacts == true && auto_organization == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.responderButtonAction(UIButton())
                    }
                }else if auto_organization {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.getGeofenceArea()
                    }
                }else if auto_contacts {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.responderButtonAction(UIButton())
                    }
                }
            }
        }
    }
    
    func createIncidentWithCallBack(message:String, _ callback:@escaping ()->Void) {
        
        if appDelegate.currentLocation == nil {return}
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let long = appDelegate.currentLocation.coordinate.longitude
        let altitude = appDelegate.currentLocation.altitude
        let url = BASE_URL + Constants.INCIDENT_CREATE
        
        let param:[String:Any] = [
            "latitude": "\(lat)",
            "longitude": "\(long)",
            "altitude": "\(altitude)",
            "emergency_message": message,
            "address": self.lblAddress.text ?? "",
            "ending_message": "",
            "is_ended": false,
            "organization": self.incidentModel?.organization?.id ?? "",
            "streaming_id":streamId ?? "",
            "vod_name":streamId ?? ""
        ]
        
        print(JSON.init(param))
        
        //SwiftLoader.show(title: "Creating Incident...", animated: true)
        
        APIsHandler.POSTApi(url, param: param, header: header()) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.createIncidentModel = IncidentModel.init(json: json)
                appDelegate.initSocket()
                callback()
                //self.handleClickCenterButton(isStartButton: true)
                //self.broadCastStart1()
                
                //self.perform(#selector(self.sendIncidentAlrtNotification), with: nil, afterDelay: 0.1)
                //self.getResponderList()
            }
        }
    }
    
    
    func endIncident(msg:String) {
        
        guard let id = self.createIncidentModel?.id else {return}
        self.stopStreamAPI()
        
        let url = BASE_URL + Incident.END
        
        SwiftLoader.show(title: "Ending...", animated: true)
        
        let dict:[String:Any] = [
          "incident_id": id,
          "incident_ending_message": msg,
          "incident_status": true
        ]
        
        print(JSON.init(dict))
        
        APIsHandler.POSTApi(url, param: dict, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                //self.goCoder?.cameraPreview?.stop()
                //self.goCoder?.endStreaming(self)
                //self.goCoder?.cameraView = nil
                //self.goCoder = nil
                self.flushAllStreas()
                self.restartUIFromScratch()
                //AppState.setHomeVC()
            }
        }
    }
    
    

    
    func stopIncident() {
        
        guard let id = self.createIncidentModel?.id else {return}
        
        self.stopStreamAPI()
        let url = updateIncidentUrl(id: id)
        
        SwiftLoader.show(title: "Stopping...", animated: true)
        
        APIsHandler.PUTApi(url, param: ["is_stopped": true], header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.responderLabel.text = "End"
                self.flushAllStreas()
                self.restartUIFromScratch()
            }
        }
    }
    
    
    @objc func getResponderList() {
        
        guard let id = self.createIncidentModel?.id else {return}
        let url = BASE_URL + Incident.JOINED_RESPONDER_LIST + "?IncidentId=\(id)"
        
        SwiftLoader.show(title: "Getting Responder...", animated: true)
        
        APIsHandler.GETApi(url, param: nil, header: header()) { (response, error, statusCode) in
           
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 200 {
                    
                    self.responderMarkers.forEach({
                        $0.map = nil
                    })
                    
                    self.responderMarkers.removeAll()
                    
                    self.responderPinViews.forEach({
                        $0.removeFromSuperview()
                    })
                    
                    self.responderPinViews.removeAll()
                    self.responders = Responders.init(json: json)
        
                    /*
                    let first = self.responders?.emergency_contacts?.first
                    first?.latitude = 28.6005236
                    first?.longitude = 77.3119806
                    */
        
                    self.standByLabel.isHidden = true
                    self.contentLabel.isHidden = true
                    self.collectionView.isHidden = false
                    let count = self.responders?.emergency_contacts?.count ?? 0
                    
                    if count > 0 {
                        self.responderCountLabel.isHidden = false
                        self.responderCountLabel.text = "\(count) Responders Located"
                        self.locationMarker.map = nil
                        self.layer.removeFromSuperlayer()
                    }
    
                    self.collectionView.reloadData()
                    self.plotRepondersOnMap()
                    
                }
            }
        }
    }
    
    
    @objc func getEmergencyContactList() {
        
        let url = BASE_URL + Users.RESPONDER_LIST
        
        //SwiftLoader.show(title: "Getting Responder...", animated: true)
        
        APIsHandler.GETApi(url, param: nil, header: header()) { (response, error, statusCode) in
            
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 200 {
                    self.emergencyContacts = Responders.init(json: json)
                    if self.emergencyContacts?.emergency_contacts?.count == 0 {
                        //self.showEmptyContactAlrt()
                    }
                }
            }
        }
    }
    
    func addEmergencyQuickContact() {
        
        let url = BASE_URL + Users.EMERGENCY_QUICK_CONTACT
        
        let params:[String:Any] = [
            "name": "string",
            "email": "string",
            "phone_number": "string"
        ]
        
        print(JSON.init(params))
        
        SwiftLoader.show(title: "Finding Responder...", animated: true)
        
        APIsHandler.POSTApi(url, param: params, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
            }
        }
    }
    
    
    
    @objc func sendIncidentAlrtNotification() {
        
        if appDelegate.currentLocation == nil {return}
        guard let id = self.createIncidentModel?.id  else {return}
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let long = appDelegate.currentLocation.coordinate.longitude
        
        let url = BASE_URL + Users.SEND_INCIDENT_ALERT_NOTIFICATION
        //SwiftLoader.show(title: "Sending Notification...", animated: true)
        
        let params:[String:Any] = [
            "latitude": "\(lat)",
            "longitude": "\(long)",
            "incident_id": id
        ]
        
        print(JSON.init(params))
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        APIsHandler.POSTApi(url, param: params, header: header()) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.startButton.isHidden = true
                self.startLabel.isHidden = true
                self.responderLabel.text = "End"
                self.hideButton.isHidden = false
                self.hideLabel.isHidden = false
                self.showBigMapView()
                self.startResponderButton.isHidden = true
                
                if appDelegate.notificationSocket != nil && appDelegate.notificationSocket?.isConnected == true {
                    appDelegate.sendNotification()
                }else{
                    appDelegate.initNotificationSocket()
                }
                
            }
        }
    }
    
    
    
    
    @objc func sendIncidentAlrtNotification1(_ completion:(()->Void)?) {
        
        if appDelegate.currentLocation == nil {return}
        guard let id = self.createIncidentModel?.id  else {return}
        
        let lat = appDelegate.currentLocation.coordinate.latitude
        let long = appDelegate.currentLocation.coordinate.longitude
        
        let url = BASE_URL + Users.SEND_INCIDENT_ALERT_NOTIFICATION
        SwiftLoader.show(title: "Sending Notification...", animated: true)
        
        let params:[String:Any] = [
            "latitude": "\(lat)",
            "longitude": "\(long)",
            "incident_id": id
        ]
        
        print(JSON.init(params))
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        APIsHandler.POSTApi(url, param: params, header: header()) { (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                self.startButton.isHidden = true
                self.startLabel.isHidden = true
                self.responderLabel.text = "End"
                self.hideButton.isHidden = false
                self.hideLabel.isHidden = false
                self.showBigMapView()
                self.startResponderButton.isHidden = true
                
                if appDelegate.notificationSocket != nil && appDelegate.notificationSocket?.isConnected == true {
                    appDelegate.sendNotification()
                }else{
                    appDelegate.initNotificationSocket()
                }
                completion?()
            }
        }
    }
    
    
    
    @objc func patchIncidentApi(msg:String) {
        
        guard let id = self.createIncidentModel?.id else {return}
        let url = updateIncidentUrl(id: id)
        
        //SwiftLoader.show(title: "Updating...", animated: true)
        UIApplication.shared.isIdleTimerDisabled = true
        APIsHandler.PUTApi(url, param: ["emergency_message": msg], header: header()) { (response, error, statusCode) in
           // SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
            }
        }
    }
    
    
    
    @objc func patchStartIncidentInfo() {
        
        guard let id = self.createIncidentModel?.id else {return}
        let url = updateIncidentUrl(id: id)
        
        //SwiftLoader.show(title: "Updating...", animated: true)
        UIApplication.shared.isIdleTimerDisabled = true
        APIsHandler.PUTApi(url, param: ["is_started": true], header: header()) { (response, error, statusCode) in
           // SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
            }
        }
    }
    
    @objc func patchIncidentStreamId(id:String) {
    
        guard let id1 = createIncidentModel?.id else {return}
        
        let url = updateIncidentUrl(id: id1)
        
        //SwiftLoader.show(title: "Updating...", animated: true)
 
        APIsHandler.PUTApi(url, param: ["streaming_id":id], header: header()) { (response, error, statusCode) in
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
            }
        }
    }
    
    
    func showEmptyContactAlrt() {
        
        let title = "Your Contact List is Empty"
        let msg = "You can share this incident with\none of your phone contacts."
        
        showAlertConfirmation(msg, title, self) { (isAllowed) in
            if isAllowed {
                let allContactVC = StoryboardManager.contactStoryBoard().getController(identifier: "AllContactVC") as! ContactListViewController
                allContactVC.isAddContact = true
                allContactVC.isAddQuickShare = true
                allContactVC.delegate = self
                // Add Contact
                self.navigationController?.pushViewController(allContactVC, animated: true)
            }else{
                self.performSegue(withIdentifier: "showResponderSegue", sender: nil)
            }
        }
    }
    
    
    func didFinishAddingContacts() {
        print("didFinishAddingContacts")
        self.configureWowza()
        handleClickCenterButton(isStartButton: true)
        //broadCastStart1()
        //self.sendIncidentAlrtNotification()
        performSegue(withIdentifier: "showResponderSegue", sender: nil)
        //self.perform(#selector(sendIncidentAlrtNotification), with: nil, afterDelay: 0.1)
    }
    
}











extension HomeViewController {
    
    func getUserContacts(){
        
        let url = BASE_URL + Constants.GET_USER_CONTACTS
        
        //SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
            //SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
               
                let contacts:[ContactModel] = json.array?.decode() ?? []
                self.parseContacts(list: contacts)
            }
        }
        
    }
    
    
    
    func parseContacts(list:[ContactModel]) {
        
        if emergencyContacts == nil {
            emergencyContacts = Responders()
        }
        
        let array = Dictionary.init(grouping: list, by: {$0.contact_type!})
    
        var list = array.filter({$0.key == "Emergency"}).first?.value ?? []
        list = list.filter({$0.status?.lowercased() == "accepted"})
        emergencyContacts?.emergency_contacts = list
    }
}
