//
//  UIVIew+Extension.swift
//  PizzaExpress
//
//  Created by Irshad Ahmed on 19/07/18.
//  Copyright © 2018 Irshad Ahmed. All rights reserved.
//

import UIKit

class BasePopUpView: UIView {
    
    weak var parentVC:UIViewController!
    
    // popup background view....
    lazy var bgView:UIView = {
        let view = UIView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        return view
    }()
    
    /*lazy var bgView:UIVisualEffectView = {
        let view = UIVisualEffectView.init(frame: UIScreen.main.bounds)
        view.effect = UIBlurEffect.init(style: .dark)
        return view
    }()*/
    
    
    lazy var initialCentre:CGPoint = {
       let height = self.frame.height + 16
       let point = CGPoint.init(x: SCREEN_WIDTH/2, y: -height)
       return point
    }()
    
    lazy var finalCentre:CGPoint = {
        let height = self.frame.height + 16
        let point = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        return point
    }()
    
    lazy var bottomCentre:CGPoint = {
        let height = self.frame.height + 16
        let point = CGPoint.init(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT + height)
        return point
    }()
    
}



extension BasePopUpView {
    
    /// use to show select order type popup...
    @objc func showPopup() {
        
        //self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        bgView.addSubview(self)
        bgView.alpha = 0
        self.center = initialCentre
        
        parentVC?.view.addSubview(bgView)
        parentVC?.view.endEditing(true)
        self.center = self.finalCentre
        self.bgView.alpha = 1
        //self.transform = .identity
        
        UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            
        }) { (isCompleted) in
            //self.springView()
        }
    }
    
    /// use to hide select order type popup...
    @objc func hidePopup() {
        self.center = self.bottomCentre
        self.bgView.alpha = 0
        //self.transform = CGAffineTransform(scaleX: 0.33, y: 0.33)
        self.bgView.removeFromSuperview()
        self.removeFromSuperview()
        
        /*self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            
        }) { (isCompleted) in
            
        }*/
        
    }
    
    
    @objc func hidePopup(_ completion:(()->Void)?) {
        
        self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.animate(withDuration: 0.74, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.center = self.bottomCentre
            self.bgView.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.33, y: 0.33)
        }) { (isCompleted) in
            self.bgView.removeFromSuperview()
            self.removeFromSuperview()
            completion?()
        }
        
    }
    
    
    func springView() {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
}


class LaunchView:UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 5 , height: 5);
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
}




extension UIView {
    
    func dropLightShadow(radius:CGFloat , color:UIColor) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.69
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2.6
        self.layer.cornerRadius = radius
    }
    
    func dropBottomShadow(opacity:Float, color:UIColor) {
        self.layer.shadowOffset = CGSize(width: 1.4, height: 1.0)
        self.layer.shadowRadius = 1.5
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.clipsToBounds = false
    }
    
    func showGradientSkeleton() {
        
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.40, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
    func bigBounce() {
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 0.50, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.transform = .identity
        }, completion: nil)
    }
}
