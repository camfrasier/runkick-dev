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
    
    
    var points1: Int!
    var points2: Int!
    var points3: Int!
    var points4: Int!
    var points5: Int!
    var points6: Int!
    var points7: Int!
    var points8: Int!
    var points9: Int!
    var points10: Int!
    var points11: Int!
    var points12: Int!
    var points13: Int!
    var points14: Int!
    
    
    var storeImageUrl1: String!
    var storeImageUrl2: String!
    var storeImageUrl3: String!
    var storeImageUrl4: String!
    var storeImageUrl5: String!
    var storeImageUrl6: String!
    var storeImageUrl7: String!
    var storeImageUrl8: String!
    var storeImageUrl9: String!
    var storeImageUrl10: String!
    var storeImageUrl11: String!
    var storeImageUrl12: String!
    var storeImageUrl13: String!
    var storeImageUrl14: String!
    
    
    var title1: String!
    var title2: String!
    var title3: String!
    var title4: String!
    var title5: String!
    var title6: String!
    var title7: String!
    var title8: String!
    var title9: String!
    var title10: String!
    var title11: String!
    var title12: String!
    var title13: String!
    var title14: String!
    
    
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
        
        if let points1 = dictionary["points1"] as? Int {
                  self.points1 = points1
        }
        if let points2 = dictionary["points2"] as? Int {
                  self.points2 = points2
        }
        if let points3 = dictionary["points3"] as? Int {
                  self.points3 = points3
        }
        if let points4 = dictionary["points4"] as? Int {
                  self.points4 = points4
        }
        if let points5 = dictionary["points5"] as? Int {
                  self.points5 = points5
        }
        if let points6 = dictionary["points6"] as? Int {
                  self.points6 = points6
        }
        if let points7 = dictionary["points7"] as? Int {
                  self.points7 = points7
        }
        if let points8 = dictionary["points8"] as? Int {
                  self.points8 = points8
        }
        if let points9 = dictionary["points9"] as? Int {
                  self.points9 = points9
        }
        if let points10 = dictionary["points10"] as? Int {
                  self.points10 = points10
        }
        if let points11 = dictionary["points11"] as? Int {
                  self.points11 = points11
        }
        if let points12 = dictionary["points12"] as? Int {
                  self.points12 = points12
        }
        if let points13 = dictionary["points13"] as? Int {
                  self.points13 = points13
        }
        if let points14 = dictionary["points14"] as? Int {
                  self.points14 = points14
        }
        
        
        if let storeImageUrl1 = dictionary["storeImageUrl1"] as? String {
            self.storeImageUrl1 = storeImageUrl1
        }
        
        if let storeImageUrl2 = dictionary["storeImageUrl2"] as? String {
            self.storeImageUrl2 = storeImageUrl2
        }
        
        if let storeImageUrl3 = dictionary["storeImageUrl3"] as? String {
            self.storeImageUrl3 = storeImageUrl3
        }
        if let storeImageUrl4 = dictionary["storeImageUrl4"] as? String {
              self.storeImageUrl4 = storeImageUrl4
          }
        if let storeImageUrl5 = dictionary["storeImageUrl5"] as? String {
              self.storeImageUrl5 = storeImageUrl5
          }
        if let storeImageUrl6 = dictionary["storeImageUrl6"] as? String {
              self.storeImageUrl6 = storeImageUrl6
          }
        if let storeImageUrl7 = dictionary["storeImageUrl7"] as? String {
            self.storeImageUrl7 = storeImageUrl7
        }
        if let storeImageUrl8 = dictionary["storeImageUrl8"] as? String {
              self.storeImageUrl8 = storeImageUrl8
          }
        if let storeImageUrl9 = dictionary["storeImageUrl9"] as? String {
              self.storeImageUrl9 = storeImageUrl9
          }
        if let storeImageUrl10 = dictionary["storeImageUrl10"] as? String {
              self.storeImageUrl10 = storeImageUrl10
          }
        if let storeImageUrl11 = dictionary["storeImageUrl11"] as? String {
            self.storeImageUrl11 = storeImageUrl11
        }
        if let storeImageUrl12 = dictionary["storeImageUrl12"] as? String {
              self.storeImageUrl12 = storeImageUrl12
          }
        if let storeImageUrl13 = dictionary["storeImageUrl13"] as? String {
              self.storeImageUrl13 = storeImageUrl13
          }
        if let storeImageUrl14 = dictionary["storeImageUrl14"] as? String {
              self.storeImageUrl14 = storeImageUrl14
          }


        if let title1 = dictionary["title1"] as? String {
                  self.title1 = title1
        }
        if let title2 = dictionary["title2"] as? String {
                  self.title2 = title2
        }
        if let title3 = dictionary["title3"] as? String {
                  self.title3 = title3
        }
        if let title4 = dictionary["title4"] as? String {
                  self.title4 = title4
        }
        if let title5 = dictionary["title5"] as? String {
                  self.title5 = title5
        }
        if let title6 = dictionary["title6"] as? String {
                  self.title6 = title6
        }
        if let title7 = dictionary["title7"] as? String {
                  self.title7 = title7
        }
        if let title8 = dictionary["title8"] as? String {
                  self.title8 = title8
        }
        if let title9 = dictionary["title9"] as? String {
                  self.title9 = title9
        }
        if let title10 = dictionary["title10"] as? String {
                  self.title10 = title10
        }
        if let title11 = dictionary["title11"] as? String {
                  self.title11 = title11
        }
        if let title12 = dictionary["title12"] as? String {
                  self.title12 = title12
        }
        if let title13 = dictionary["title13"] as? String {
                  self.title13 = title13
        }
        if let title14 = dictionary["title14"] as? String {
                  self.title14 = title14
        }

    }
    
}
