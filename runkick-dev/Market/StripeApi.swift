//
//  StripeApi.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/1/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions
import Firebase

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {

    var user: User?
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        // create data object and pass it in the call below
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_USERS.child(currentUid).child("stripeId").observe(.value) { (snapshot) in
                let stripeId = snapshot.value as! String
                
                print("DEBUG: The user STRIPE ID is \(snapshot.value as! String)")
        
        
        let data = [
            "stripe_version": apiVersion,
            "customer_id": stripeId
        ]
        
        // the below invokes the cloud function
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            // if there are no errors then extract the key
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
        }
    }
    }
    
}
