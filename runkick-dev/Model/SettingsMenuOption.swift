//
//  SettingsMenuOption.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/22/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

enum SettingsMenuOption: Int, CustomStringConvertible {
    
    case Profile
    case Payment
    case Trips
    case Help
    case Logout
    
    var description: String {
        switch self {
        case .Profile: return "NOTIFICATIONS"
        case .Payment: return "LOCATION SETTINGS"
        case .Trips: return "TERMS"
        case .Help: return "PRIVICY"
        case .Logout: return "LOGOUT"
            
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "simpleMenuRightArrow") ?? UIImage()
        case .Payment: return UIImage(named: "simpleMenuRightArrow") ?? UIImage()
        case .Trips: return UIImage(named: "simpleMenuRightArrow") ?? UIImage()
        case .Help: return UIImage(named: "simpleMenuRightArrow") ?? UIImage()
        case .Logout: return UIImage(named: "simpleMenuRightArrow") ?? UIImage()
        }
    }
}
