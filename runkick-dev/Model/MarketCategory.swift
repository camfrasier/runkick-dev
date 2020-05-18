//
//  MarketCategory.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/9/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation  // may not need this class, could possibly use Post for all feed posts
import Firebase

class MarketCategory {
    
    // attributes
    var points: Int!
    var categoryId: String!
    var storeId: String!
    var category: String?
    var caption: String?
    var imageUrl: String!
    
    init(categoryId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.categoryId = categoryId

        
        if let points = dictionary["points"] as? Int {
            self.points = points
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
    }
}

