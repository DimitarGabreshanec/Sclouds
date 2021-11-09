//
//  UIViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func translucentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func resetNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularStdBold(size: 18),
                                                                   NSAttributedString.Key.foregroundColor: UIColor.blackTextColor()]
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func prepareNavigationWithWhiteTitle() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularStdBold(size: 18),
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.mainColor()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func prepareNavigationWithBlackTitle() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.circularStdBold(size: 18),
                                                            NSAttributedString.Key.foregroundColor: UIColor.blackTextColor()]
        UINavigationBar.appearance().tintColor = UIColor.mainColor()
        UINavigationBar.appearance().barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func showAlertWithActions(_ title: String?, message: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let uActios = actions {
            for action in uActios {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(_ title: String?, message: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if let uActios = actions {
            for action in uActios {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) -> Void in }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func creatCustomBarButton(title: String) -> UIButton {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.titleLabel?.font = UIFont.circularStdMedium(size: 18)
        return button
    }
    
    // Add barButtonItem for leftBarButton
    func createBackBarButtonItem() {
        navigationItem.leftItemsSupplementBackButton = false
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.tintColor = UIColor.mainColor()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [backBarButtonItem]
        
    }
    
    @objc func backButtonAction() {
        /*if self.presentingViewController != nil {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            
        }*/
        navigationController?.popViewController(animated: true)
    }
    
    func backDispatchHomePage() {
        if let controllers = navigationController?.viewControllers {
            controllers.forEach { (vc) in
                if vc is DispatchHomeViewController {
                    let homeVC = vc as! DispatchHomeViewController
                    navigationController?.popToViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    
}


extension UIViewController {
    
    class func loadController() -> Self {
        return instantiateViewControllerFromMainStoryBoard()
    }
    
    fileprivate class func instantiateViewControllerFromMainStoryBoard<T>() -> T {
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
}


extension UIViewController {
    
    class func loadUserController() -> Self {
        return instantiateViewControllerFromUserStoryBoard()
    }
    
    fileprivate class func instantiateViewControllerFromUserStoryBoard<T>() -> T {
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
}


extension UIViewController {
    class func loadCookController() -> Self {
        return instantiateViewControllerFromCookStoryBoard()
    }
    
    fileprivate class func instantiateViewControllerFromCookStoryBoard<T>() -> T {
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
    
    func showMessage(_ text:String?) {
        if let str = text {
            let image = UIImage.init(named: "sams_logo")
            let announcment = Announcement.init(title: str, subtitle: "", image: image, urlImage: nil, duration: 2.0, interactionType: .none, userInfo: nil, action: nil)
            InAppNotify.Show(announcment, to: self)
        }
    }
}
