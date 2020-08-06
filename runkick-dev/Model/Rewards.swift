//
//  Rewards.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/3/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class Rewards {
    
    // attributes
    var lat: Double?
    var long: Double?
    var location: String!
    var title: String!
    var imageUrl: String!
    var points: Int!
    var storeId: String!
    var averagePace: String!
    var pace: String!
    var distance: Double!
    var duration: String!
    var stepCount: Int!
    var creationDate: Date!
    
    
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
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let averagePace = dictionary["averagePace"] as? String {
            self.averagePace = averagePace
        }
        
        if let pace = dictionary["pace"] as? String {
            self.pace = pace
        }
        
        if let distance = dictionary["distance"] as? Double {
            self.distance = distance
        }
        
        if let duration = dictionary["duration"] as? String {
            self.duration = duration
        }
        
        if let stepCount = dictionary["stepCount"] as? Int {
            self.stepCount = stepCount
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
    }
}
