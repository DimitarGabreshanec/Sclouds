//
//  AppState.swift
//  Samscloud
//
//  Created by An Phan on 1/21/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

struct AppState {
    
    static func setHomeVC() {
        let tabBarVC = StoryboardManager.homeStoryBoard().instantiateViewController(withIdentifier: "HomeNC")
        guard let snapshot = AppDelegate.shared().window?.snapshotView(afterScreenUpdates: true) else {
            return
        }
        tabBarVC.view.addSubview(snapshot)
        AppDelegate.shared().window?.rootViewController = tabBarVC
        UIView.transition(with: snapshot, duration: 0.4, options: .transitionCrossDissolve, animations: {
            snapshot.layer.opacity = 0.0
        }) { (finished) in
            snapshot.removeFromSuperview()
        }
    }
    
    static func setHomeVCFromContinueIncident() {
        let tabBarVC = StoryboardManager.homeStoryBoard().instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
        guard let snapshot = AppDelegate.shared().window?.snapshotView(afterScreenUpdates: true) else {
            return
        }
        let homeVC = tabBarVC.topViewController as! HomeViewController
        homeVC.isFromDispatchSOSResponder = true
        tabBarVC.view.addSubview(snapshot)
        AppDelegate.shared().window?.rootViewController = tabBarVC
        UIView.transition(with: snapshot, duration: 0.4, options: .transitionCrossDissolve, animations: {
            snapshot.layer.opacity = 0.0
        }) { (finished) in
            snapshot.removeFromSuperview()
        }
    }
    
    static func setHomeResponderVC() {
        let tabBarVC = StoryboardManager.dispatchStoryBoard().instantiateViewController(withIdentifier: "DispatchHomeVC")
        guard let snapshot = AppDelegate.shared().window?.snapshotView(afterScreenUpdates: true) else {
            return
        }
        tabBarVC.view.addSubview(snapshot)
        AppDelegate.shared().window?.rootViewController = tabBarVC
        UIView.transition(with: snapshot, duration: 0.4, options: .transitionCrossDissolve, animations: {
            snapshot.layer.opacity = 0.0
        }) { (finished) in
            snapshot.removeFromSuperview()
        }
    }
    
    static func setLoginVC() {
        DispatchQueue.main.async {
            print("SET LOGIN VC METHOD CALLED")
        }
    }
    
    
}
