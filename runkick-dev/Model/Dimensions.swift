//
//  Dimensions.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 2/5/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import Foundation  // for the date functionality we need the swift foundation
import Firebase

class Dimensions {
    
    var postId: String!
    var tripId: String!
    var logoId: String!
    var imageUrl: String!
    var description: String!
    var storeId: String!
    var type: String!
    var user: User?

    
    init(postId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        if let type = dictionary["type"] as? String {
            self.type = type
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }

        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let tripId = dictionary["tripId"] as? String {
            self.tripId = tripId
        }
        
        if let logoId = dictionary["logoId"] as? String {
            self.logoId = logoId
        }

        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }

    }
}
