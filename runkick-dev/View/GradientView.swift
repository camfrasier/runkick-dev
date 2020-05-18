//
//  GradientView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/5/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class GradientView: UIView {

// Creating a CA Gradient layer.
    
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView() {
        // Below we are telling the gradient where it should live and how it should be framed.
        // Setting frame to the bounds of our view.
        
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1) // The '1' value here will be understood as 100 percent.
        gradient.locations = [0.8,1.0] // Saying the white should go 80 percent and the clear 100 percent.
        
        // Make the gradient view a sublayer.
        self.layer.addSublayer(gradient)
    }

}
