//
//  CustomTextField.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit


// MARK: - PROTOCOL

protocol MyTextFieldDelegate {
    
    func textFieldDidDelete()
    
}


// MARK: - CLASS

class CustomTextField: UITextField {
    
    var myDelegate: MyTextFieldDelegate?
    
    
    // MARK: - ACTIONS
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }
    
    
    
}
