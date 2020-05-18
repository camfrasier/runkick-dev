//
//  AlertService.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/13/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class AlertService {
    
    private init () {}
    
    static func actionSheet(in vc: UIViewController, title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
}
