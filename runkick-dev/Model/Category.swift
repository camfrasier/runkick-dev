//
//  Category.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/13/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//


import Foundation  // for the date functionality we need the swift foundation
import Firebase

class Category {
    
    var caption: String!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var category: String!
    var description: String!
    var price: Double!
    var poppPrice: Double!
    //var price: Float!
    //var poppPrice: Float!
    var address: String!
    var storeId: String!
    var user: User?
    var points: Int!
    
    init(postId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let address = dictionary["address"] as? String {
            self.address = address
        }
        
        if let points = dictionary["points"] as? Int {
            self.points = points
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        /*
        if let price = dictionary["price"] as? Float {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Float {
            self.poppPrice = poppPrice
        }
        */
        
        if let price = dictionary["price"] as? Double {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Double {
            self.poppPrice = poppPrice
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
}

// may need to add items to this equitable extension below
extension Category: Equatable {}

func ==(lhs: Category, rhs: Category) -> Bool {
    let areEqual = lhs.postId == rhs.postId &&
        lhs.price == rhs.price

    return areEqual
}
