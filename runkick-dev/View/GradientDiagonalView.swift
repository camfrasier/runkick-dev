//
//  GradientDiagonalView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/24/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import UIKit

class GradientDiagonalView: UIView {

    var gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupGradientView(){
        
        gradient.frame = bounds
        //gradient.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        //gradient.colors = [UIColor.rgb(red: 255, green: 110, blue: 126).cgColor, UIColor.airBnBRed().cgColor]
        gradient.colors = [UIColor.rgb(red: 255, green: 120, blue: 136).cgColor, UIColor.rgb(red: 236, green: 84, blue: 95).cgColor]
        //gradient.colors = [UIColor.rgb(red: 243, green: 78, blue: 92).cgColor, UIColor.rgb(red: 255, green: 99, blue: 117).cgColor]
        //UIColor.rgb(red: 252, green: 112, blue: 167)
        
        gradient.locations = [0.0, 0.65]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        //gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.addSublayer(gradient)
        self.clipsToBounds = true
    }
}
