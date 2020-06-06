//
//  GradientView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/5/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import UIKit



class GradientView: UIView {

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
        gradient.colors = [UIColor.yellow.cgColor, UIColor.actionRed().cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.addSublayer(gradient)
        self.clipsToBounds = true
    }
}

