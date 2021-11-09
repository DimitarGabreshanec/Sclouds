//
//  InvalidOTP.swift
//  PizzaExpress
//
//  Created by Irshad Ahmed on 19/07/18.
//  Copyright © 2018 Irshad Ahmed. All rights reserved.
//

import UIKit

class MessageView: BasePopUpView {
    
    @IBOutlet weak var descLabel:UILabel!
    
    @IBAction func clickOnTryAgain(_ sender:UIButton) {
        self.hidePopup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func view() -> MessageView {
        let view =  UINib(nibName: "MessageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MessageView
        let height:CGFloat = 170
        view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 100, height: height)
        return view
    }
    
    
    @IBAction func clickOnCross(_ sender:UIButton) {
        self.hidePopup()
    }
    
    func set(text:String,vc:UIViewController)->MessageView{
        descLabel.text = text
        self.parentVC = vc
        return self
    }
    
}


