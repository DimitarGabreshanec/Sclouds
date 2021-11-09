//
//  AppDelegate+Socket.swift
//  Samscloud
//
//  Created by SubcoDevs  on 10/15/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
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


extension AppDelegate:WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocket) {
        
    }
   
    
    func websocketHttpUpgrade(socket: WebSocket, request: String) {
        
    }
    
    func websocketHttpUpgrade(socket: WebSocket, response: String) {
        
    }
    
    

    func websocketDidConnect(socket: WebSocketClient) {
        print("webSocketDidOpen")
        if webSocket.self == notificationSocket.self {
            sendNotification()
            return
        }
        pingIntoSocket()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: Error?){
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {

    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {

        guard let dict = convertToDictionary(text: text) else {return}
        guard let action = dict["action"] as? String else {return}
        
        if action == "reporter_location_update" {
            //print("****** reporter_location_update ******")
        }else if action == "conference_room"{
            //print("****** conference_room ******")
            
            let model = RespondersConferenceRoom.init(dict: dict)

            print("Name ----->>>> ",model.responder_name ?? "Name is null")
            print("UUID ----->>>> ",model.uuid ?? "UUID is null")
            print("Type ----->>>> ",model.type ?? "Type id null")
            print("StreamID ----->>>> ",model.stream_id ?? "Stream id null")
            
            if model.type != "left" {
                self.homeVC?.conferrenceRoomData.append(model)
                self.homeVC?.responderStreamCollection.reloadData()
            }
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData",data)
    }
    
    
    func initSocket() {
        print("incidentId:- \(appDelegate.homeVC?.createIncidentModel?.id)")
        guard let id = appDelegate.homeVC?.createIncidentModel?.id, id != "" else {
            return
        }
        let str = "wss://api.samscloud.io/wss/\(id)/incident/"
        guard let url = URL.init(string: str) else {return}
        let request = URLRequest.init(url: url)
        webSocket = WebSocket.init(request: request)
        webSocket?.delegate = self
        webSocket?.connect()
    }
    
    
    func pingIntoSocket() {
        _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            if let data = try? JSON.init(["ping":"pong"]).rawData() {
                //if self.webSocket?.isConnected == true {
                    self.webSocket?.write(ping: data)
                //}
            }
        }
    }
    
    
    func updateReporteLocatoin() {
        
        socketTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self](timer) in
            //if self?.webSocket?.isConnected == true {
                self?.sendDataInSocket()
            //}
        })
        
    }
    
    func sendDataInSocket() {
        
        guard let id = appDelegate.homeVC?.createIncidentModel?.id else { return }
        
        let id1 = DefaultManager().getUserId() ?? 0
        
        var params:[String:String] = [
            "latitude":"\(appDelegate.currentLocation.coordinate.latitude)",
            "longitude":"\(appDelegate.currentLocation.coordinate.longitude)",
            "altitude":"\(appDelegate.currentLocation.altitude)",
            "incident_id": id,
            "user_id":"\(id1)",
            "address":appDelegate.addressStr ?? "",
            "speed":"\(appDelegate.currentLocation.speed)",
            "action":"reporter_location_update"
        ]
        
        if appDelegate.homeVC?.session.running == true {
            params["status"] = "InProgress"
        }else{
            params["status"] = "Ended"
        }
        
        let data = stringify(json: params)
        //print("******** Sending Data in Socket ********")
        
        webSocket?.write(string: data, completion: {
            
        })
        
    }
    
   
    
    func initNotificationSocket() {
        
        if notificationSocket?.isConnected == true{
            notificationSocket?.disconnect()
            notificationSocket = nil
        }
        guard let id = appDelegate.homeVC?.incidentModel?.organization?.owner_id,id != "" else {
            return
        }
        let str = "wss://api.samscloud.io/wss/\(id)/organization-owner/"
        guard let url = URL.init(string: str) else {return}
        let request = URLRequest.init(url: url)
        notificationSocket = WebSocket.init(request: request)
        notificationSocket?.delegate = self
        notificationSocket?.connect()
    }
    
    
    func sendNotification() {
        guard let id = appDelegate.homeVC?.createIncidentModel?.id else { return }
        let params:[String:String] = [
            "incident_id":"\(id)",
            "action":"organization_owner"
        ]
        let data = stringify(json: params)
        print(data)
        if self.webSocket?.isConnected == true {
            notificationSocket?.write(string: data)
        }
    }
    
}


 func stringify(json: Any, prettyPrinted: Bool = true) -> String {
    var options: JSONSerialization.WritingOptions = []
    if prettyPrinted {
      options = JSONSerialization.WritingOptions.prettyPrinted
    }

    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: options)
      if let string = String(data: data, encoding: String.Encoding.utf8) {
        return string
      }
    } catch {
      print(error)
    }

    return ""
}




func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
