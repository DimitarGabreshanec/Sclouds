//
//  HomeViewController+Actions.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 05/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import AVFoundation
//import WowzaGoCoderSDK
import CoreLocation






extension HomeViewController {
    
    // MARK: - SETUP
    func setup1() {
        
        shakeSwitch.isEnabled = true
        innerView.isHidden = true
        
        prepareNavigation()
        prepareUI()
       
        prepareUIWithStandBy()
        addActionForView()
        if isFromDispatchSOSResponder {
            handleClickCenterButton(isStartButton: true)
            handleViolenceButton(isStandBy: true)
            handleStandByButton(isStandBy: true)
            isLargeVideo = true
            tapLargeVideo(isLargeVideo: isLargeVideo)
        }
    }
    
    func setup2() {
        
        if kAppDelegate.cameraStop  {
            setupCamera(flag: false)
        }
        
        navigationController?.isNavigationBarHidden = false
        if isShowMenuPage {
            isShowMenuPage = false
            // Show Menu page
            let menuVC = StoryboardManager.menuStoryBoard().getController(identifier: "MenuViewController")
            navigationController?.pushViewController(menuVC, animated: true)
        }
    }
    
}








// MARK:- handler's of actions
extension HomeViewController {
    
    
    
}









// MARK:- objc handler
extension HomeViewController:UIGestureRecognizerDelegate {
    
    // MARK: - TOUCHES / GESTURES
    @objc func tapVideoImage() {
        isLargeVideo = !isLargeVideo
        tapLargeVideo(isLargeVideo: isLargeVideo)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.activeShooterImageView)
        let velocity = recognizer.velocity(in: self.activeShooterImageView)
        activeShooterImageY = (activeShooterView.frame.height - activeShooterImageView.frame.height) / 2
        let x = self.activeShooterImageView.frame.minX
        if x + translation.x >= minX && x + translation.x <= maxX {
            
            let newX = x + translation.x
            let newX1 = x + translation.x - minX
            
            print("------",newX)
            print("------",newX1)
            
            self.activeShooterImageView.frame = CGRect(x: newX,
                                                       y: activeShooterImageY,
                                                       width: activeShooterImageView.frame.width,
                                                       height: activeShooterImageView.frame.height)
            self.backgroundActiveShooterView.frame = CGRect(x: newX1,
                                                            y: 0,
                                                            width: self.activeShooterView.frame.width,
                                                            height: self.activeShooterView.frame.height)
            self.activeShooterLabel.alpha = 0
            self.slideToActivateLabel.alpha = 0
            
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        if recognizer.state == .ended {
            var duration =  velocity.x < 0 ? Double((x - minX) / -velocity.x) : Double((maxX - x) / velocity.x)
            duration = duration > 1.3 ? 1 : duration
            UIView.animate(withDuration: duration,
                           delay: 0.0,
                           options: [.allowUserInteraction],
                           animations: {
                            
                            self.finalActiveShooterFrame = self.activeShooterImageView.frame
                            
                            if self.activeShooterImageView.frame.origin.x >= (self.maxX - 5*self.minX) {
                                self.activeShooterLabel.alpha = 0
                                self.slideToActivateLabel.alpha = 0
                                self.activeShooterImageView.frame = CGRect(x: self.maxX,
                                                                           y: self.activeShooterImageY,
                                                                           width: self.activeShooterImageView.frame.width,
                                                                           height: self.activeShooterImageView.frame.height)
                                self.backgroundActiveShooterView.frame = CGRect(x: self.maxX - self.minX,
                                                                                y: 0,
                                                                                width: self.activeShooterView.frame.width - self.maxX + self.minX,
                                                                                height: self.activeShooterView.frame.height)
                                self.activeShooterView.isHidden = true
                            } else {
                                self.activeShooterLabel.alpha = 1
                                self.slideToActivateLabel.alpha = 1
                                self.activeShooterImageView.frame = CGRect(x: self.minX,
                                                                           y: self.activeShooterImageY,
                                                                           width: self.activeShooterImageView.frame.width,
                                                                           height: self.activeShooterImageView.frame.height)
                                self.backgroundActiveShooterView.frame = CGRect(x: -self.minX,
                                                                                y: 0,
                                                                                width: self.activeShooterView.frame.width,
                                                                                height: self.activeShooterView.frame.height)
                            }
            }, completion: { [weak self] _ in
                guard let strongSelf = self else { return }
                        
                strongSelf.handleSlide()
                /*
                if strongSelf.finalActiveShooterFrame == nil {
                    strongSelf.finalActiveShooterFrame = strongSelf.activeShooterImageView.frame
                }
                
                if strongSelf.finalActiveShooterFrame!.origin.x >= (strongSelf.maxX - 5*strongSelf.minX) {
                    strongSelf.activeShooterView.isHidden = true
                   
                    let responderVC = StoryboardManager.homeStoryBoard().getController(identifier: "ResponderViewController") as! ResponderViewController
                    
                    responderVC.modalPresentationStyle = .overCurrentContext
                    responderVC.isActiveShooter = true
                  
                    self?.ischeck = true
                    // Handle `stop` button
                    responderVC.stopActiveButtonAction = {
                        strongSelf.showHomePage()
                    }
                    
                    // Handle `stop` button
                    responderVC.stopButtonAction = {
                        self?.ischeck = false
                        //strongSelf.handleClickCenterButton(isStartButton: false)
                    }
                    
                    // Handle `hide` button
                    responderVC.hideButtonAction = {
                        strongSelf.showPassCodePage()
                    }
                    
                    // Handle `violence` button
                    responderVC.violenceButtonAction = {
                        //strongSelf.handleViolenceButton(isStandBy: true) // firstCall
                    }
                    
                    // Handle `skip` actinve shooter button
                    responderVC.skipActiveButtonAction = {
                        strongSelf.configureWowza()
                        strongSelf.broadCastStart1()
                    }
                    
                    strongSelf.present(responderVC, animated: false, completion: nil)
                    
                    if strongSelf.incidentModel == nil {
                        strongSelf.createIncidentWithCallBack(message: "") {
                            strongSelf.checkInAndSendAlert()
                        }
                    }else{
                        strongSelf.sendIncidentAlrtNotification()
                    }
                    strongSelf.patchIncidentApi(msg: "Active Shooter")
                    strongSelf.finalActiveShooterFrame = nil
                    
                    appDelegate.updateReporteLocatoin()
                }*/
            })
        }
    }
    
    
    func handleSlide() {
        
        let strongSelf = self
        
        if self.finalActiveShooterFrame == nil {
            self.finalActiveShooterFrame = strongSelf.activeShooterImageView.frame
        }
        
        if self.finalActiveShooterFrame!.origin.x >= (self.maxX - 5*self.minX) {
            self.activeShooterView.isHidden = true
           
            let responderVC = StoryboardManager.homeStoryBoard().getController(identifier: "ResponderViewController") as! ResponderViewController
            
            responderVC.modalPresentationStyle = .overCurrentContext
            responderVC.isActiveShooter = true
          
            self.ischeck = true
            // Handle `stop` button
            responderVC.stopActiveButtonAction = {
                strongSelf.showHomePage()
            }
            
            // Handle `stop` button
            responderVC.stopButtonAction = {
                self.ischeck = false
                //strongSelf.handleClickCenterButton(isStartButton: false)
            }
            
            // Handle `hide` button
            responderVC.hideButtonAction = {
                strongSelf.showPassCodePage()
            }
            
            // Handle `violence` button
            responderVC.violenceButtonAction = {
                //strongSelf.handleViolenceButton(isStandBy: true) // firstCall
            }
            
            // Handle `skip` actinve shooter button
            responderVC.skipActiveButtonAction = {
                strongSelf.configureWowza()
                strongSelf.broadCastStart1()
            }
            
            strongSelf.present(responderVC, animated: false, completion: nil)
            
            if strongSelf.incidentModel == nil {
                strongSelf.createIncidentWithCallBack(message: "") {
                    strongSelf.checkInAndSendAlert()
                }
            }else{
                strongSelf.sendIncidentAlrtNotification()
            }
            strongSelf.patchIncidentApi(msg: "Active Shooter")
            strongSelf.finalActiveShooterFrame = nil
            
            appDelegate.updateReporteLocatoin()
        }
        
    }
    
    
    @objc func checkInAndSendAlert() {
        self.getGeofenceArea {
            self.perform(#selector(self.sendIncidentAlrtNotification), with: nil, afterDelay: 0.3)
        }
    }
}
