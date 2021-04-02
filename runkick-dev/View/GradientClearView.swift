//
//  GradientClearView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import UIKit

class GradientClearView: UIView {

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
        //gradient.colors = [UIColor.black.withAlphaComponent(0.25).cgColor,
        //gradient.colors = [UIColor.rgb(red: 235, green: 235, blue: 235).withAlphaComponent(1).cgColor,
        //UIColor.rgb(red: 235, green: 235, blue: 235).withAlphaComponent(0.0).cgColor]
        gradient.colors = [UIColor.rgb(red: 180, green: 180, blue: 180).withAlphaComponent(0.25).cgColor,
                           UIColor.rgb(red: 255, green: 255, blue: 255).withAlphaComponent(0.25).cgColor]
        gradient.locations = [0.0, 0.85]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.addSublayer(gradient)
        self.clipsToBounds = true
    }
}






