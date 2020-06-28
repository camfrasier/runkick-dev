//
//  ShoppingCart.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/25/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class ShoppingCart {
    
    var caption: String!
    var imageUrl: String!
    var ownerUid: String!
    var cartId: String!
    var creationDate: Date!
    var postId: String!
    var category: String!
    var price: Double!
    var poppPrice: Double!
    //var price: Float!
    //var poppPrice: Float!
    var address: String!
    var storeId: String!
    var user: User?
    
    init(ownerUid: String!, dictionary: Dictionary<String, AnyObject>) {
        
        self.ownerUid = ownerUid
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let cartId = dictionary["cartId"] as? String {
            self.cartId = cartId
        }
        
        if let address = dictionary["address"] as? String {
            self.address = address
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        /*
        if let price = dictionary["price"] as? Float {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Float {
            self.poppPrice = poppPrice
        }
        */
        
        if let price = dictionary["price"] as? Double {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Double {
            self.poppPrice = poppPrice
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    
    
    // download shopping cart from firebase
    func downloadCartFromFirebase(_ ownerUid: String, completion: @escaping(_ shoppingCart: ShoppingCart) -> ()) {
        
        
        
        DataService.instance.REF_SHOPPING_CART.child(ownerUid).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
   
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            if !dictionary.isEmpty && dictionary.count > 0 {
                
                let shoppingCart = ShoppingCart(ownerUid: ownerUid, dictionary: dictionary)
                
                completion(shoppingCart)
            }
            
        }

    }
    
    
}


