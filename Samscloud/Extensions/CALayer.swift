//
//  CALayer.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import  UIKit

extension CALayer {
    
    func applySketchShadow(color: UIColor = UIColor.black, alpha: Float = 0.16,
                           x: CGFloat = 0, y: CGFloat = 3,
                           blur: CGFloat = 6, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        masksToBounds = false
    }
    
    func addGradientBackground(WithColors color:[UIColor]) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.colors = color.map({$0.cgColor})
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        self.addSublayer(gradientLayer)
    }
    
    func addRoundGradientBackground(WithColors color:[UIColor]) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = self.bounds.size.width/2
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.colors = color.map({$0.cgColor})
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        let roundRect = CALayer()
        roundRect.frame = self.bounds
        roundRect.cornerRadius = self.bounds.size.height/2.0
        roundRect.masksToBounds = true
        roundRect.addSublayer(gradientLayer)
        gradientLayer.mask = roundRect
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.size.height).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.cornerRadius = self.bounds.size.width/2.0
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        self.addSublayer(shapeLayer)
    }
    
    func addGradientBorder(WithColors color:[UIColor],Width width:CGFloat = 1) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        gradientLayer.colors = color.map({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.addSublayer(gradientLayer)
    }
    
    //
    //    func addShadow(Color color:UIColor, View view:UIView) -> Void {
    //        //  let shapeLayer = CAShapeLayer()
    //        view.layer.shadowColor = color.cgColor
    //         view.layer.shadowOpacity = 0.3
    //
    //        //self.addSublayer(shapeLayer)
    //    }
    //
    
    func addBorderShadow(Height height:CGFloat, Width width:CGFloat) -> Void {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect:CGRect (x: 0, y: 0, width: width, height: height), cornerRadius: height/2).cgPath
        shapeLayer.fillColor = UIColor.appThemeBlueColor().cgColor
        shapeLayer.shadowColor = UIColor .appThemeBlueColor().cgColor
        shapeLayer.shadowPath = shapeLayer.path
        shapeLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shapeLayer.shadowOpacity = 0.5
        shapeLayer.shadowRadius = 2
        // layer.insertSublayer(shadowLayer, at: 0)
        self.addSublayer(shapeLayer)
    }
    
    
    
}
