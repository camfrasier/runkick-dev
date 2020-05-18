//
//  CircleView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class CircleView: UIView {

// IBInspectable variable will allow you to modify the border color independent of the image.
    @IBInspectable var borderColor: UIColor? {
        didSet {
        // setupView
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor // Using Interface Builder variable to set borderColor.
    }
}
