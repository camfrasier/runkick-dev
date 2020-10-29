//
//  MainSwitch.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 2/29/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

// i don't think this toggle is neccessary. may get rid of it soon

import UIKit
import Firebase



class MainSwitch: UISwitch {

var createGroupVC: CreateGroupVC?
var delegate: PrivacyStatusControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.onTintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        self.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleSwitch() {
        if self.isOn {
            print("Group set to private")
            delegate?.handlePrivacySetting(privacyToggled: true)
            
        } else {
            print("Group set to public")
            delegate?.handlePrivacySetting(privacyToggled: false)
        }
        
        
    }
}
