//
//  Store.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/1/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class Store {
    
    // attributes
    var lat: Double?
    var long: Double?
    var location: String!
    var title: String!
    var points: Int!
    var storeId: String!
    var category: String?
    var caption: String!
    var imageUrl: String!
    var storeLogoUrl: String!
    //var favoritesUrl: String!
    var uid: String!
    
    
    init(storeId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.storeId = storeId
        
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
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        //if let favoritesUrl = dictionary["imageUrl"] as? String {
          //  self.favoritesUrl = favoritesUrl
       // }
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        
    }
}
