//
//  MenuOption.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/5/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    //case Profile
    case Home
    case Payment
    case Trips
    case Favorites
    case Rewards
    case Cart
    case Settings
    case Help
    
    var description: String {
        switch self {
        case .Home: return "Home"
        case .Payment: return "Payment"
        case .Trips: return "Trip History"
        case .Favorites: return "Favorites"
        case .Rewards: return "Rewards"
        case .Cart: return "Your Cart" // Cam remove cart probably - replace it with something else
        case .Settings: return "Settings"
        case .Help: return "Help"
            
        }
    }
    
    var image: UIImage {
        switch self {
        //case .Profile: return UIImage(named: "simpleProfileCircleIcon") ?? UIImage()
        case .Home: return UIImage(named: "simplePaymentCard") ?? UIImage()
        case .Payment: return UIImage(named: "simplePaymentCard") ?? UIImage()
        case .Trips: return UIImage(named: "simpleHistoryClock") ?? UIImage()
        case .Favorites: return UIImage(named: "simpleAnalyticsLimer") ?? UIImage()
        case .Rewards: return UIImage(named: "simpleRewardsCardPink") ?? UIImage()
        case .Cart: return UIImage(named: "trueBlueCircleCart") ?? UIImage()
        case .Settings: return UIImage(named: "simpleYellowCircleWhiteGear") ?? UIImage()
        case .Help: return UIImage(named: "simpleHelp") ?? UIImage()
        }  
    }
    
    var image2: UIImage {
        switch self {
            case .Home: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Payment: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Trips: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Favorites: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Rewards: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Cart: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Settings: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
            case .Help: return UIImage(named: "simpleMenuArrowBlueRight") ?? UIImage()
        }
    }
}
