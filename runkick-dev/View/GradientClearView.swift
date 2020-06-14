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
        gradient.colors = [UIColor.black.withAlphaComponent(0.75).cgColor,
        UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.locations = [0.0, 0.65]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.layer.addSublayer(gradient)
        self.clipsToBounds = true
    }
}






