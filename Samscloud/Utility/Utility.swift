//
//  Utility.swift
//  Samscloud
//
//  Created by Chetu Mac on 16/04/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SDWebImage



class Utility: NSObject {
    
    /**
     This is class method which is display the alert message.
     - Parameters:
     - strTitle: Title of alert message
     - strBody: body of alert message
     - delegate: calling controller object
     - returns: N/A
     */
    
    class func alertContoller(stayle: UIAlertController.Style,
                              title: String,
                              message: String,
                              actionTitle1: String,
                              actionTitle2: String,
                              firstAction: Selector?,
                              secondAction: Selector?, controller: UIViewController) {
        var alert = UIAlertController()
        if stayle == .actionSheet{
            alert = UIAlertController(title: nil, message: nil, preferredStyle: stayle)
        } else {
            alert = UIAlertController(title: title, message: message, preferredStyle: stayle)
        }
        // let alert = UIAlertController(title: title, message: message, preferredStyle: stayle) // 1
        let firstActionHandler = UIAlertAction(title: actionTitle1, style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
            if (firstAction != nil){
                controller.perform(firstAction)
            }
        }
        alert.addAction(firstActionHandler)
        if (!actionTitle2.isEmpty) {
            let secondActionHandler = UIAlertAction(title: actionTitle2, style: .default) { (alert: UIAlertAction!) -> Void in
                NSLog("You pressed button two")
                if (secondAction != nil){
                    controller.perform(secondAction)
                }
            }
            alert.addAction(secondActionHandler)
        }
        alert.popoverPresentationController?.sourceView = UIView()
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: UIView().frame.size.height / 2,
                                                                 width: UIView().frame.size.width, height: UIView().frame.size.height / 2)
        controller.present(alert, animated: true, completion:nil)
    }
    
    static func logoutAction(controller:UIViewController)  {
        //                controller.appDelegate.items = nil
        //                controller.navigationController?.tabBarController?.increaseBadge(indexOfTab: 2, num:nil)
        //                controller.tabBarController?.selectedIndex = 0
        //                DBManager.sharedInstance.deleteObjectsFromTax()
        //                let  taxRateVM = TaxRateViewModel()
        //                UserDefaults.standard.setTaxRate(taxRateVM.calculateTotalTax())
        //                controller.appDelegate.logout()
    }
    
    
    /**
     This is class method which is display the alert message.
     - Parameters:
     - strTitle: Title of alert message
     - strBody: body of alert message
     - delegate: calling controller object
     - returns: N/A
     */
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        DispatchQueue.main.async { () -> Void in
            let alert: UIAlertView = UIAlertView()
            alert.message = strBody as String
            alert.title = strTitle as String
            alert.delegate = delegate
            alert.addButton(withTitle: NSLocalizedString("kOk", comment: ""))
            alert.show()
        }
    }
    
    class  func SubmitAlertView(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Cancel button
        let cancel = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Get length of string
    class func getLength(string: String) -> Int {
        let stringLenght = string as NSString
        return stringLenght.length
    }
    
    // check network is available or not
    // return true/false
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let networkStatus = (isReachable && !needsConnection)
        return networkStatus
        
    }
    
    // get application theme color
    class func getThemeColor() -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor.init(displayP3Red: 66/255, green: 59/255, blue: 78/255, alpha: 1)
        } else {
            // Fallback on earlier versions
            return UIColor.init(red: 66/255, green: 59/255, blue: 78/255, alpha: 1)
        }
    }
    
    class func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
     class func isValidPassword(passStr: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&()_+~])[A-Za-z\\d$@$!%*?&()_+~]{6,}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: passStr)
        if(isMatched  == true) {
            // Do your stuff ..
            return true
        } else {
            // Show Error Message.
            return false
        }
    }
    
    
    
    
    
}




func loadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?){
    
    let imageUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    activity?.startAnimating()
    
    let urlStr = URL.init(string: imageUrl)
  
    imageView.sd_setImage(with: urlStr, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil) {  (image, error, imageCacheType, imageUrl) in
        activity?.stopAnimating()
        if image != nil{
            imageView.image = image
        }
    }
}






func loadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?, _ completion:@escaping()->Void){
    
    let imageUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    activity?.startAnimating()
    
    let urlStr = URL.init(string: imageUrl)
  
    imageView.sd_setImage(with: urlStr, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil) {  (image, error, imageCacheType, imageUrl) in
        activity?.stopAnimating()
        if image != nil{
            imageView.image = image
        }
        completion()
    }
}
