//
//  RoundImageView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        // Modifying the corner radius with the below commands. The width of the square divided by 2.
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true // Cookie cuts the image and allow it to fit in the image view.
    }

}
