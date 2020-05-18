//
//  Alertable.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/12/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    
    func showAlert(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil) // Handler is set to nil because we don't need to do anything after we dismiss the error.
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
