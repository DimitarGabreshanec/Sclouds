//
//  BorderedTextView.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/21/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit

class BorderedTextView: UITextView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 8
    }
}
