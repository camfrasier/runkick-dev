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
    
    var logo1: String!
    var logo2: String!
    var logo3: String!
    var logo4: String!
    var logo5: String!
    var logo6: String!
    var logo7: String!
    var logo8: String!
    var logo9: String!
    var logo10: String!
    var logo11: String!
    var logo12: String!
    
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
        
        if let logo1 = dictionary["logo1"] as? String {
            self.logo1 = logo1
        }
        if let logo2 = dictionary["logo2"] as? String {
              self.logo2 = logo2
          }
        if let logo3 = dictionary["logo3"] as? String {
              self.logo3 = logo3
          }
        if let logo4 = dictionary["logo4"] as? String {
              self.logo4 = logo4
          }
        if let logo5 = dictionary["logo5"] as? String {
            self.logo5 = logo5
        }
        if let logo6 = dictionary["logo6"] as? String {
              self.logo6 = logo6
          }
        if let logo7 = dictionary["logo7"] as? String {
              self.logo7 = logo7
          }
        if let logo8 = dictionary["logo8"] as? String {
              self.logo8 = logo8
          }
        if let logo9 = dictionary["logo9"] as? String {
            self.logo9 = logo9
        }
        if let logo10 = dictionary["logo10"] as? String {
              self.logo10 = logo10
          }
        if let logo11 = dictionary["logo11"] as? String {
              self.logo11 = logo11
          }
        if let logo12 = dictionary["logo12"] as? String {
              self.logo12 = logo12
          }


    }
    
}
