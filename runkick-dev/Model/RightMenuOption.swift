//
//  RightMenuOption.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/18/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

enum RightMenuOption: Int, CustomStringConvertible {
    
    case Analytics
    case Search
    case Message
    case Notifications
    case Groups
    case Posts
    case Followers
    case Following
    

    var description: String {
        switch self {
        case .Analytics: return "Analytics"
        case .Search: return "Search"
        case .Message: return "Messages"
        case .Notifications: return "Notifications"
        case .Groups: return "Groups"
        case .Posts: return "Posts"
        case .Followers: return "Followers"
        case .Following: return "Following"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Analytics: return UIImage(named: "iconAnalytics") ?? UIImage()
        case .Search: return UIImage(named: "iconSearchFriends") ?? UIImage()
        case .Message: return UIImage(named: "iconMessages") ?? UIImage()
        case .Notifications: return UIImage(named: "iconNotifications") ?? UIImage()
        case .Groups: return UIImage(named: "iconGroups") ?? UIImage()
        case .Posts: return UIImage(named: "spaceDot") ?? UIImage()
        case .Followers: return UIImage(named: "spaceDot") ?? UIImage()
        case .Following: return UIImage(named: "spaceDot") ?? UIImage()
        }
        
    }
    
    var image2: UIImage {
        switch self {
        case .Analytics: return UIImage(named: "simpleMenuArrowUp") ?? UIImage()
        case .Search: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Message: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Notifications: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Groups: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Posts: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Followers: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        case .Following: return UIImage(named: "simpleMenuArrowRight") ?? UIImage()
        }
    }
}

