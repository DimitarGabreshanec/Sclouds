//
//  ResponderStreamCell.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 19/11/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
//import AntMediaSDK
import WebRTC


class ResponderStreamCell: UICollectionViewCell {

    @IBOutlet weak var streamView:UIView!
    @IBOutlet weak var nameLabel:UILabel!
    
    let client: AntMediaClient? = AntMediaClient.init()
    var isLoaded = false
    var stream:RespondersConferenceRoom?
    
    class func nib() -> UINib {
        return UINib.init(nibName: "ResponderStreamCell", bundle: nil)
    }
    
    override func awakeFromNib() {
         super.awakeFromNib()
         //self.bordered(withColor: .white, width: 1.0)
         //self.perform(#selector(loadStream), with: nil, afterDelay: 1.0)
    }
    
    
    @objc func loadStream(id:String) {
         if isLoaded == true {return}
         isLoaded = true
         streamView.bordered(withColor: .white, width: 1.0)
        
        let clientURL = "wss://antmedia.samscloud.io:5443/WebRTCAppEE/websocket"

        self.client?.delegate = self
        self.client?.setDebug(true)
        self.client?.setVideoEnable(enable: true)
        self.client?.setOptions(url: clientURL, streamId: id, token: "", mode: .play, enableDataChannel: true)
        self.client?.setRemoteView(remoteContainer: streamView, mode: .scaleAspectFill)
        self.client?.initPeerConnection()
        self.client?.start()
        
/*         self.client?.delegate = self
         self.client?.setVideoEnable(enable: false)
         self.client?.setDebug(true)
         let url = "wss://antmedia.samscloud.io"
         self.client?.setOptions(url: url, streamId: id, token: "", mode: .play)
         self.client?.setRemoteView(remoteContainer: streamView, mode: .scaleAspectFill)
//         self.client?.setScaleMode(mode: .scaleAspectFill)
         self.client?.connectWebSocket()
 */
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("didMoveToWindow")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("didMoveToWindow")
    }

}







extension ResponderStreamCell: AntMediaClientDelegate {
    
    func clientDidConnect(_ client: AntMediaClient) {
        print("ResponderStreamCell: Connected")
//         self.client?.start()
    }
    
    func clientDidDisconnect(_ message: String) {
        print("ResponderStreamCell: Disconnected: \(message)")
    }
    
    func clientHasError(_ message: String) {
        print("*** ERROR ***")
        print(message)
    }
    
    
    func disconnected() {
        
    }
    
    func remoteStreamStarted() {
        print("ResponderStreamCell: Remote stream started")
    }
    
    func remoteStreamRemoved() {
        print("*** ERROR ***")
        print("ResponderStreamCell: Remote stream is no longer available")
    }
    
    func localStreamStarted() {
        print("ResponderStreamCell: Local stream added")
    }
    
    
    func playStarted(){
        print("ResponderStreamCell: play started")
    }
    
    func playFinished() {
        print("*** ResponderStreamCell: playFinished ***")
        
        guard let vc = appDelegate.homeVC else {return}
        guard let indexPath = vc.responderStreamCollection.indexPath(for: self) else {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            vc.conferrenceRoomData.remove(at: indexPath.item)
            
            if self.client?.isConnected() == true {
//            if self.client?.webSocket.isConnected == true {
                self.client?.stop()
            }
            self.removeFromSuperview()
            self.isLoaded = false
            vc.responderStreamCollection.reloadData()
        }
        
    }

    func publishStarted() {
        
    }
    
    func publishFinished() {
        
    }
    func audioSessionDidStartPlayOrRecord() {
        print("ResponderStreamCell: audioSessionDidStartPlayOrRecord")
    }
    
    func dataReceivedFromDataChannel(streamId: String, data: Data, binary: Bool) {
        print("ResponderStreamCell: dataReceivedFromDataChannel")
    }
}

