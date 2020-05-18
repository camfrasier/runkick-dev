//
//  RunnerAnnotation.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/2/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import MapKit

class RunnerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
    self.coordinate = coordinate
    self.key = key
    super.init()
    }
}
