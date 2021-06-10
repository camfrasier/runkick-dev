//
//  Recent.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/8/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class Recent {
    
    // attributes
    var lat: Double?
    var long: Double?
    var location: String!
    var title: String!
    var points: Int!
    var uid: String!
    var category: String?
    var imageUrl: String!
    var storeLogoUrl: String!
    
    
    init(uid: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let lat = dictionary["lat"] as? Double {
            self.lat = lat
        }
        
        if let long = dictionary["long"] as? Double {
            self.long = long
        }
        
        if let location = dictionary["location"] as? String {
            self.location = location
        }
        
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        
        if let points = dictionary["points"] as? Int {
            self.points = points
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let storeLogoUrl = dictionary["storeLogoUrl"] as? String {
            self.storeLogoUrl = storeLogoUrl
        }

        
    }
}
