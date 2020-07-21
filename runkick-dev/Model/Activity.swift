//
//  Activity.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/17/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class Activity {
    
    // attributes
    var lat: Double?
    var long: Double?
    var location: String!
    var title: String!
    var points: Int!
    var tripId: String!
    var averagePace: Double!
    var pace: Double!
    var distance: Double!
    var duration: Double!
    var stepCount: Int!
    var creationDate: Date!
    
    
    init(tripId: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.tripId = tripId
        
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
        
        if let tripId = dictionary["tripId"] as? String {
            self.tripId = tripId
        }
        
        if let averagePace = dictionary["averagePace"] as? Double {
            self.averagePace = averagePace
        }
        
        if let pace = dictionary["pace"] as? Double {
            self.pace = pace
        }
        
        if let distance = dictionary["distance"] as? Double {
            self.distance = distance
        }
        
        if let duration = dictionary["duration"] as? Double {
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
