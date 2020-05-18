//
//  RoundedShadowView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        //self.layer.borderWidth = 0.25
        //self.layer.borderColor = UIColor(red: 0/225, green: 0/225, blue: 0/225, alpha: 1).cgColor
        self.layer.cornerRadius = 8.0
        self.layer.shadowOpacity = 0.75 // Shadow is 30 percent opaque.
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: -2, height: 2) // Offsets the shadow 5 points in the positive direction.
    }

}
