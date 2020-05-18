//
//  StoreAnnotation.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/25/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import MapKit

struct StoreAnnotation {
    var latitude :Double
    var longitude :Double
    var title :String?
    var location :String?
    var points :Int?
    
    func toDictionary() -> [String:Any] {
        return ["lat":self.latitude,"long":self.longitude]
    }
}

extension StoreAnnotation {
    
    init?(dictionary :[String:Any]) {
        guard let latitude = dictionary["lat"] as? Double, let longitude = dictionary["long"] as? Double, let title = dictionary["title"] as? String, let points = dictionary["points"] as? Int, let location = dictionary["location"] as? String else {
            return nil // If it fails we will just return nil.
        }
        
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.points = points
        self.location = location
    }
}
