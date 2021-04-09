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
    
    
    var logoUrl1: String!
    
    var logoUrl2: String!
    
    var logoUrl3: String!
    var logoUrl4: String!
    var logoUrl5: String!
    var logoUrl6: String!
    var logoUrl7: String!
    var logoUrl8: String!
    var logoUrl9: String!
    var logoUrl10: String!
    var logoUrl11: String!
    var logoUrl12: String!
    var logoUrl13: String!
    var logoUrl14: String!
    
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
        
        if let logoUrl1 = dictionary["logoUrl1"] as? String {
            self.logoUrl1 = logoUrl1
        }
        
        if let logoUrl2 = dictionary["logoUrl2"] as? String {
            self.logoUrl2 = logoUrl2
        }
        
        if let logoUrl3 = dictionary["logoUrl3"] as? String {
            self.logoUrl3 = logoUrl3
        }
        if let logoUrl4 = dictionary["logoUrl4"] as? String {
              self.logoUrl4 = logoUrl4
          }
        if let logoUrl5 = dictionary["logoUrl5"] as? String {
              self.logoUrl5 = logoUrl5
          }
        if let logoUrl6 = dictionary["logoUrl6"] as? String {
              self.logoUrl6 = logoUrl6
          }
        if let logoUrl7 = dictionary["logoUrl7"] as? String {
            self.logoUrl7 = logoUrl7
        }
        if let logoUrl8 = dictionary["logoUrl8"] as? String {
              self.logoUrl8 = logoUrl8
          }
        if let logoUrl9 = dictionary["logoUrl9"] as? String {
              self.logoUrl9 = logoUrl9
          }
        if let logoUrl10 = dictionary["logoUrl10"] as? String {
              self.logoUrl10 = logoUrl10
          }
        if let logoUrl11 = dictionary["logoUrl11"] as? String {
            self.logoUrl11 = logoUrl11
        }
        if let logoUrl12 = dictionary["logoUrl12"] as? String {
              self.logoUrl12 = logoUrl12
          }
        if let logoUrl13 = dictionary["logoUrl13"] as? String {
              self.logoUrl13 = logoUrl13
          }
        if let logoUrl14 = dictionary["logoUrl14"] as? String {
              self.logoUrl14 = logoUrl14
          }


    }
    
}
