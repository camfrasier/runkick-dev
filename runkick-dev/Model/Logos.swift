//
//  Logos.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/16/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation  // for the date functionality we need the swift foundation
import Firebase

class Logos {
    
    var caption: String!
    var logoUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var title: String!
    var postId: String!
    var tripId: String!
    var points: Int!
    var category: String!
    var storeId: String!
    var description: String!
    var calories: Int!
    //var price: Int!    // may need to change this value to an integer
    //var poppPrice: Int!
    var price: Double!    // may need to change this value to an integer
    var poppPrice: Double!
    
    var user: User?
    
    init(postId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let logoUrl = dictionary["logoUrl"] as? String {
            self.logoUrl = logoUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let price = dictionary["price"] as? Double {
            self.price = price
        }
        
        if let calories = dictionary["calories"] as? Int {
            self.calories = calories
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Double {
            self.poppPrice = poppPrice
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        
        if let points = dictionary["points"] as? Int {
                  self.points = points
              }
    }
    
}
