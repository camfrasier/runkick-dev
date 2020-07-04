//
//  UserService.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/2/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

let UserService = _UserService()

final class _UserService {
    // Variables
    
    var user = [User]()
    
    var isGuest : Bool {
        guard let authUser = Auth.auth().currentUser else {
            return true
        }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = Auth.auth().currentUser else { return }
        
        let userRef = DataService.instance.REF_USERS.child(authUser.uid)
        
        userRef.observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            //self.user = User.init(uid: authUser.uid, dictionary: dictionary)
            
        }
    }
    
}
