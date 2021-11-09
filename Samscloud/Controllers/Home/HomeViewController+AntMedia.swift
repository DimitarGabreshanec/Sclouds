//
//  HomeViewController+AntMedia.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 13/11/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation
import GoogleMaps
import SwiftyJSON
import LFLiveKit




extension HomeViewController:LFLiveSessionDelegate {
    
    
    @objc func setupAntMedia() {
        self.session.delegate = self
        self.session.preView = self.switchView
        self.session.running = true
        self.session.captureDevicePosition = AVCaptureDevice.Position.back
        session.prepareForInterfaceBuilder()
    }
    
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
           print("State: \(state.hashValue)")
           switch state {
               case LFLiveState.ready:
                   print("Status: Not connected")
                   break
               case LFLiveState.pending:
                   print("Status: Connecting")
                   break
               case LFLiveState.start:
                   print("Status: Live")
                   break
               case LFLiveState.error:
                print(session?.streamInfo?.url)
                   print("Status: Error")
                   break
               case LFLiveState.stop:
                   print("Status: Stop")
                   break
               default:
                   break
            
            
           }
       }
       
       func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
           let message: String = Messages.getLocalizedError(with: errorCode)
           print("Error: \(errorCode.rawValue) -> \(message)")
           Samscloud.showAlert(msg: message, title: "Error", sender: self)
       }
       
       func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
           print("Debug info: \(debugInfo.debugDescription)")
       }
    
}







class Messages {
    
    static func getLocalizedError(with code: LFLiveSocketErrorCode) -> String {
        switch code.rawValue {
            case 201:
                return "Preview failed."
            case 202:
                return "Failed to get streaming information. Please check availability of Ant Media Server."
            case 203:
                return "Failed to connect to the socket. Please check your network."
            case 204:
                return "Verify server failed. Please check server url."
            case 205:
                return "Server timeout. Please check network availability and server variables."
            default:
                return ""
        }
    }
    
}
