//
//  RoundedShadowButton.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

// Creating animation variable for spinner.
    var originalSize: CGRect?
    
    func setupView() {
        originalSize = self.frame // Capturing the original size before we animate it down.
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero // We don't want it to move. We want it to stay in the center of everything.
    }
    
    override func awakeFromNib() {
        setupView()   // This tells the app to display the button.
    }
    
    func animateButton(shouldLoad: Bool, withMessage message: String?) {
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = UIColor.darkGray
        spinner.alpha = 0.0
        spinner.hidesWhenStopped = true // Automatically hides spinner when stopped.
        spinner.tag = 21 // Giving the spinner a unique identifier to specify which subview to remove specifically.
        
        if shouldLoad {
            self.addSubview(spinner)
            
            self.setTitle("", for: .normal) // Remember self refers to a UIbutton. Display a title of nothing.
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = self.frame.height / 2
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
            }, completion: { (finished) in
                if finished == true {
                    spinner.startAnimating()
                    spinner.center = CGPoint(x: self.frame.width / 2 + 1, y: self.frame.width / 2 + 1)
                    spinner.fadeTo(alphaValue: 1.0, withDuration: 0.2)
                }
            })
            // Once the animation has completed, we want to block out user interaction.
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
            
            for subview in self.subviews {
                if subview.tag == 21 {
                subview.removeFromSuperview()
                }
                
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = 5.0
                self.frame = self.originalSize! // We need to force unwrap it.
                self.setTitle(message, for: .normal) // Our control state is set to normal.
            })
        }
    }
}
