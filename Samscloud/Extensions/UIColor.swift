//
//  UIColor.swift
//  Samscloud
//
//  Created by An Phan on 1/16/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// useful macros
    class func rgbColor(red r: Float, green g: Float, blue b: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0)
    }
    
    class func rgbaColor(red r: Float, green g: Float, blue b: Float, alpha a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: a)
    }
    
    /**
     * Separate line view, placeholder text color of the application
     * @return UIColor color to use
     */
    
    class func mainColor() -> UIColor {
        return UIColor(hexString: "0156FF")
    }
    
    class func blackTextColor() -> UIColor {
        return UIColor(hexString: "242424")
    }
    
    class func greyTextColor() -> UIColor {
        return UIColor(hexString: "B4B4B4")
    }
    
    class func redMainColor() -> UIColor {
        return UIColor(hexString: "FF3400")
    }
    
    class func redBorderColor() -> UIColor {
        return UIColor(hexString: "FF010A")
    }
    
    class func appThemeOrangeColor() -> UIColor {
        return UIColor.init(red: 249/255.0, green: 100/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    class func appButtonLighGrayColor() -> UIColor {
        return UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
    }
    
    class func appDarkGrayTitleColor() -> UIColor {
        return UIColor.init(red: 45/255.0, green: 46/255.0, blue: 47/255.0, alpha: 1.0)
    }
    
    class func appGrayTitleColor() -> UIColor {
        return UIColor.init(red: 96/255.0, green: 97/255.0, blue: 98/255.0, alpha: 1.0)
    }
    
    class func appLighGrayDescriptionColor() -> UIColor {
        return UIColor.init(red: 183/255.0, green: 184/255.0, blue: 185/255.0, alpha: 1.0)
    }
    
    class func appLightGraySperatorColor() -> UIColor {
        return UIColor.init(red: 245/255.0, green: 246/255.0, blue: 247/255.0, alpha: 1.0)
    }
    
    class func appRedColor() -> UIColor {
        return UIColor.init(red: 226/255.0, green: 71/255.0, blue: 76/255.0, alpha: 1.0)
    }
    
    class func appThemeBlueColor() -> UIColor {
        return UIColor.init(red:  51/255.0, green: 204/255.0, blue: 219/255.0, alpha: 1.0)
    }
    
    class func appThemeLightBlueColor() -> UIColor {
        return UIColor.init(red:  220/255.0, green: 240/255.0, blue: 244/255.0, alpha: 1.0)
    }
    
    class func appGrayColor() -> UIColor {
        return UIColor.init(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1.0)
    }
    
    class func appLightGrayColor() -> UIColor {
        return UIColor.init(red: 179/255.0, green: 179/255.0, blue: 199/255.0, alpha: 1.0)
    }
    
    class func appLightColor() -> UIColor {
        return UIColor.init(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
    }
    
    class func appDarkGrayColor() -> UIColor {
        return UIColor.init(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
    }
    
    class func appBorderGrayColor() -> UIColor {
        //return UIColor.init(red: 190/255.0, green: 194/255.0, blue: 205/255.0, alpha: 1.0)
        return UIColor.init(red: 218/255.0, green: 220/255.0, blue: 226/255.0, alpha: 1.0)
    }
    
    class func appLightBlueColor() -> UIColor {
        return UIColor.init(red: 238/255.0, green: 240/255.0, blue: 248/255.0, alpha: 1.0)
    }
    
    class func appNotificationSuccess() -> UIColor {
        return UIColor.init(red: 204/255.0, green: 250/255.0, blue: 228/255.0, alpha: 1.0)
    }
    
    class func appNotificationFail() -> UIColor {
        return UIColor.init(red: 225/255.0, green: 216/255.0, blue: 241/255.0, alpha: 1.0)
    }
    
    class func appPurpleColor() -> UIColor {
        return UIColor.init(red: 103/255.0, green: 57/255.0, blue: 183/255.0, alpha: 1.0)
    }
    
    class func appGoldenColor() -> UIColor {
        return UIColor.init(red: 247/255.0, green: 188/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    class func appPerrotColor() -> UIColor {
        return UIColor.init(red: 0/255.0, green: 148/255.0, blue: 134/255.0, alpha: 1.0)
    }
    
    class func appGreenColor() -> UIColor {
        return UIColor.init(red: 141/255.0, green: 197/255.0, blue: 62/255.0, alpha: 1.0)
    }
    
    class func appBlackColor() -> UIColor {
        return UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
    }
    //    class func randomColor() -> UIColor {
    //
    //        let hue = CGFloat(arc4random() % 100) / 100
    //        let saturation = CGFloat(arc4random() % 100) / 100
    //        let brightness = CGFloat(arc4random() % 100) / 100
    //
    //        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    //    }
    
}
