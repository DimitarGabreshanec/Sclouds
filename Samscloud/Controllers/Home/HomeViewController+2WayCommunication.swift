//
//  HomeViewController+2WayCommunication.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 18/11/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation
import GoogleMaps
import SwiftyJSON
//import AntMediaSDK
import WebRTC





extension HomeViewController :AntMediaClientDelegate{
    
    
    func initAntMediaClient() {
        
        let client = AntMediaClient.init()
        client.delegate = self
        client.setVideoEnable(enable: true)
    
        client.setOptions(url: "wss://antmedia.samscloud.io:5443/WebRTCAppEE/websocket", streamId: "room11111212121212", token: "tokenID454545445", mode: AntMediaClientMode.play)
        
        client.setRemoteView(remoteContainer: RTCEAGLVideoView())
        client.setLocalView(container: RTCEAGLVideoView())
        client.connectWebSocket()
    }
    
    func audioSessionDidStartPlayOrRecord() {
        print("HomeViewController+2WayCommunication.swift -----  audioSessionDidStartPlayOrRecord")
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        print("HomeViewController+2WayCommunication.swift -----  dataReceivedFromDataChannel streamId: \(streamId)")
    }
    
    func clientDidConnect(_ client: AntMediaClient) {
        print("HomeViewController+2WayCommunication.swift -----  clientDidConnect")
    }
    
    func clientDidDisconnect(_ message: String) {
        print("HomeViewController+2WayCommunication.swift -----  clientDidDisconnect",message)
    }
    
    func clientHasError(_ message: String) {
        print("HomeViewController+2WayCommunication.swift -----  clientHasError",message)
    }
    
    func remoteStreamStarted() {
        print("HomeViewController+2WayCommunication.swift -----  remoteStreamStarted")
    }
    
    func remoteStreamRemoved() {
        print("HomeViewController+2WayCommunication.swift -----  remoteStreamRemoved")
    }
    
    func localStreamStarted() {
        print("HomeViewController+2WayCommunication.swift -----  localStreamStarted")
    }
    
    func playStarted() {
        print("HomeViewController+2WayCommunication.swift -----  playStarted")
    }
    
    func playFinished() {
        print("HomeViewController+2WayCommunication.swift -----  playFinished")
    }
    
    func publishStarted() {
        print("HomeViewController+2WayCommunication.swift -----  publishStarted")
    }
    
    func publishFinished() {
        print("HomeViewController+2WayCommunication.swift -----  publishFinished")
    }
    
    func disconnected() {
        print("HomeViewController+2WayCommunication.swift -----  disconnected")
    }
    
}





