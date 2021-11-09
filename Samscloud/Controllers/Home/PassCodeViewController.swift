//
//  PassCodeViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/19/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class PassCodeViewController: UIViewController {
    
    var code = ""
    var finishAction: (() -> Void)?
    
    @IBOutlet weak var circle1View: UIView!
    @IBOutlet weak var circle2View: UIView!
    @IBOutlet weak var circle3View: UIView!
    @IBOutlet weak var circle4View: UIView!
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var hideTextField: UITextField!
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        code = DefaultManager().getPasscode() ?? ""
        
        let font = UIFont.circularStdBook(size: 16)
        enterCodeTextField.attributedPlaceholder = NSAttributedString(string: "Enter Passcode", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.mainColor()])
        enterCodeTextField.font = font
        enterCodeTextField.textColor = UIColor.mainColor()
        enterCodeTextField.isEnabled = false
        hideTextField.becomeFirstResponder()
        prepareNormalView()
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNormalView() {
        circle1View.roundRadius()
        circle2View.roundRadius()
        circle3View.roundRadius()
        circle4View.roundRadius()
        circle1View.backgroundColor = .white
        circle2View.backgroundColor = .white
        circle3View.backgroundColor = .white
        circle4View.backgroundColor = .white
        circle1View.bordered(withColor: UIColor.mainColor(), width: 1)
        circle2View.bordered(withColor: UIColor.mainColor(), width: 1)
        circle3View.bordered(withColor: UIColor.mainColor(), width: 1)
        circle4View.bordered(withColor: UIColor.mainColor(), width: 1)
    }
    
    private func changeUIwhenEnterCode(view: UIView, isChanged: Bool) {
        view.backgroundColor = isChanged ? UIColor.mainColor() : .white
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let codeText = textField.text {
            let countText = codeText.count
            if codeText.isEmpty {
                prepareNormalView()
            } else if countText == 1 {
                changeUIwhenEnterCode(view: circle1View, isChanged: true)
                changeUIwhenEnterCode(view: circle2View, isChanged: false)
                changeUIwhenEnterCode(view: circle3View, isChanged: false)
                changeUIwhenEnterCode(view: circle4View, isChanged: false)
            } else if countText == 2 {
                changeUIwhenEnterCode(view: circle1View, isChanged: true)
                changeUIwhenEnterCode(view: circle2View, isChanged: true)
                changeUIwhenEnterCode(view: circle3View, isChanged: false)
                changeUIwhenEnterCode(view: circle4View, isChanged: false)
            } else if countText == 3 {
                changeUIwhenEnterCode(view: circle1View, isChanged: true)
                changeUIwhenEnterCode(view: circle2View, isChanged: true)
                changeUIwhenEnterCode(view: circle3View, isChanged: true)
                changeUIwhenEnterCode(view: circle4View, isChanged: false)
            } else if countText == 4 {
                changeUIwhenEnterCode(view: circle1View, isChanged: true)
                changeUIwhenEnterCode(view: circle2View, isChanged: true)
                changeUIwhenEnterCode(view: circle3View, isChanged: true)
                changeUIwhenEnterCode(view: circle4View, isChanged: true)
            }
            if codeText.count == 4 {
                if code == "" {
                    DefaultManager().setPasscode(value: codeText)
                    dismiss(animated: false, completion: nil)
                }else if codeText == code {
                    enterCodeTextField.text = "Enter Passcode"
                    enterCodeTextField.textColor = UIColor.mainColor()
                    dismiss(animated: true) {
//                        if appDelegate.homeVC?.viewMain.frame != appDelegate.homeVC?.fullFrame {
//                           //appDelegate.homeVC?.reShowSmallCameraView()
//                        }
                    }
                } else {
                    hideTextField.text = ""
                    prepareNormalView()
                    enterCodeTextField.textColor = UIColor.redMainColor()
                    enterCodeTextField.text = "Invalid Code"
                }
            }
        }
    }
    
    
    
}
