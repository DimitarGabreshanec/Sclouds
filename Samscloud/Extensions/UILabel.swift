//
//  UILabel.swift
//  Samscloud
//
//  Created by Javid Poornasir on 7/1/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit


extension UILabel {
    
    func animateToFont(_ font: UIFont, withDuration duration: TimeInterval) {
        let oldFont = self.font
        self.font = font
        // let oldOrigin = frame.origin
        let labelScale = oldFont!.pointSize / font.pointSize
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        // let newOrigin = frame.origin
        // frame.origin = oldOrigin
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            //    self.frame.origin = newOrigin
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }
    
    func lineSpacingInLabel(Space space:CGFloat, StringText text:String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        let attributeText:NSAttributedString =  NSAttributedString(string: text, attributes:attributes)
        // attributedText =
        return attributeText
    }
    
}
