//
//  StorePost.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/2/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation  // for the date functionality we need the swift foundation
import Firebase

class StorePost {
    
    var caption: String!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var category: String!
    var storeId: String!
    //var price: Int!    // may need to change this value to an integer
    //var poppPrice: Int!
    var price: Float!    // may need to change this value to an integer
    var poppPrice: Float!
    
    var user: User?
    
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        self.user = user
        
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
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let price = dictionary["price"] as? Float {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Float {
            self.poppPrice = poppPrice
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    
    // will need to create a function similar to this to delete user post
    func deletePost() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // removing photo from general admin posts
        DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).removeValue()
        
        // removing photo from admin user posts
        DataService.instance.REF_ADMIN_USER_POSTS.child(currentUid).child(postId).removeValue()
        
        // removing photo from storage databease
        Storage.storage().reference(forURL: self.imageUrl).delete(completion: nil)

        //DataService.instance.REF_FEED.child(currentUid).child(postId).removeValue()
        
        //DataService.instance.REF_POSTS.child(postId).removeValue()
    }
}

