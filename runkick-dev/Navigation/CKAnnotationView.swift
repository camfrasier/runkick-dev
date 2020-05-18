//
//  CKAnnotationView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 1/6/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class CKAnnotationView: MKAnnotationView {

    var label: UILabel?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
