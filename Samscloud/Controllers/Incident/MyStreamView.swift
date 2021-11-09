//
//  MyStreamView.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 17/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import WebRTC
import LFLiveKit

class MyStreamView:UIView {
    
    var myStreamID:String?
    weak var ongoingIncidentVC:OngoingIncidentViewController?
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.medium1)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.adaptiveBitrate = true
        return session!
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}




/**
@Auther : Irshad Ahmad
@Description : Stream related Work
*/
extension MyStreamView:LFLiveSessionDelegate {
    
    
     func enable2WayCommunication() {
        myStreamID = "\(Date().ticks)"
        self.session.delegate = self
        self.session.preView = self
        self.session.running = true
        self.session.captureDevicePosition = AVCaptureDevice.Position.front
        session.prepareForInterfaceBuilder()
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://antmedia.samscloud.io/WebRTCAppEE/\(myStreamID!)"
        session.startLive(stream)
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
       }
       
       func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
           print("Debug info: \(debugInfo.debugDescription)")
       }
    
}
 
