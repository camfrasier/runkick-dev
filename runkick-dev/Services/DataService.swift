//
//  DataService.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/13/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

// Singleton

import Foundation
import Firebase

// Allows us to update the driver realtime

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()
let LIKE_INT_VALUE = 0
let COMMENT_INT_VALUE = 1
let FOLLOW_INT_VALUE = 2
let COMMENT_MENTION_INT_VALUE = 3
let POST_MENTION_INT_VALUE = 4

class DataService {
    
    // Created an instance of the class, meaning we can access anything inside of it.
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_STORAGE = STORAGE_BASE
    private var _REF_STORAGE_PROFILE_IMAGES = STORAGE_BASE.child("profile_images")
    private var _REF_STORAGE_SCREENSHOT_IMAGES = STORAGE_BASE.child("screenshot_images")
    private var _REF_STORAGE_GROUP_PROFILE_IMAGES = STORAGE_BASE.child("group_profile_images")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_STOREADMIN = DB_BASE.child("storeadmin")
    private var _REF_CATEGORIES = DB_BASE.child("categories")
    private var _REF_MARKETPLACE = DB_BASE.child("marketplace")
    private var _REF_TRIPS = DB_BASE.child("trips")
    private var _REF_ACTIVITY = DB_BASE.child("activity")
    private var _REF_STORES = DB_BASE.child("stores")
    private var _REF_USER_GROUPS = DB_BASE.child("user_groups")
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_ADMIN_STORE_POSTS = DB_BASE.child("admin-store-posts")
    private var _REF_ADMIN_USER_POSTS = DB_BASE.child("admin-user-posts")
    private var _REF_TEXT_FIRST_POSTS = DB_BASE.child("text-first-posts")
    private var _REF_USER_POSTS = DB_BASE.child("user-posts")
    private var _REF_USER_CHECKIN_POSTS = DB_BASE.child("user-checkin-posts")
    private var _REF_FOLLOWING = DB_BASE.child("user-following")
    private var _REF_FOLLOWERS = DB_BASE.child("user-followers")
    private var _REF_FEED = DB_BASE.child("user-feed")
    private var _REF_NOTIFICATIONS = DB_BASE.child("notifications")
    private var _REF_USER_LIKES = DB_BASE.child("user-likes")
    private var _REF_USER_REWARDS = DB_BASE.child("user-rewards")
    private var _REF_POST_LIKES = DB_BASE.child("post-likes")
    private var _REF_USER_POST_COMMENT = DB_BASE.child("user-comments")
    private var _REF_MESSAGES = DB_BASE.child("messages")
    private var _REF_USER_MESSAGES = DB_BASE.child("user-messages")
    private var _REF_HASHTAG_POST = DB_BASE.child("hashtag-post")
    private var _REF_SHOPPING_CART = DB_BASE.child("shopping-cart")
    
    // Prevents the above variables from being modified directly.
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
        
    }
    
    var REF_STORAGE_PROFILE_IMAGES: StorageReference {
        return _REF_STORAGE_PROFILE_IMAGES
        
    }
    
    var REF_STORAGE_GROUP_PROFILE_IMAGES: StorageReference {
        return _REF_STORAGE_GROUP_PROFILE_IMAGES
        
    }
    
    var REF_STORAGE_SCREENSHOT_IMAGES: StorageReference {
        return _REF_STORAGE_SCREENSHOT_IMAGES
        
    }
    
    var REF_USER_CHECKIN_POSTS: DatabaseReference {
        return _REF_USER_CHECKIN_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_GROUPS: DatabaseReference {
        return _REF_USER_GROUPS
    }
    
    var REF_MARKETPLACE: DatabaseReference {
        return _REF_MARKETPLACE
    }
    
    var REF_SHOPPING_CART: DatabaseReference {
        return _REF_SHOPPING_CART
    }
    
    var REF_CATEGORIES: DatabaseReference { // may not need category section because we have the feed
        return _REF_CATEGORIES
    }
    
    var REF_STOREADMIN: DatabaseReference {
        return _REF_STOREADMIN
    }
    
    var REF_TRIPS: DatabaseReference {
        return _REF_TRIPS
    }
    
    var REF_ACTIVITY: DatabaseReference {
        return _REF_ACTIVITY
    }
    
    var REF_STORES: DatabaseReference {
        return _REF_STORES
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_ADMIN_STORE_POSTS: DatabaseReference {
        return _REF_ADMIN_STORE_POSTS
    }
    
    var REF_TEXT_FIRST_POSTS: DatabaseReference {
        return _REF_TEXT_FIRST_POSTS
    }
    
    var REF_USER_POSTS: DatabaseReference {
        return _REF_USER_POSTS
    }
    
    var REF_USER_REWARDS: DatabaseReference {
        return _REF_USER_REWARDS
    }
    
    var REF_ADMIN_USER_POSTS: DatabaseReference {
        return _REF_ADMIN_USER_POSTS
    }
    
    var REF_FOLLOWING: DatabaseReference {
        return _REF_FOLLOWING
    }
    
    var REF_FOLLOWER: DatabaseReference {
        return _REF_FOLLOWERS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    var REF_NOTIFICATIONS: DatabaseReference {
        return _REF_NOTIFICATIONS
    }
    
    var REF_USER_LIKES: DatabaseReference {
        return _REF_USER_LIKES
    }
    
    var REF_POST_LIKES: DatabaseReference {
        return _REF_POST_LIKES
    }
    
    var REF_USER_POST_COMMENT: DatabaseReference {
        return _REF_USER_POST_COMMENT
    }
    
    var REF_MESSAGES: DatabaseReference {
        return _REF_MESSAGES
    }
    
    var REF_USER_MESSAGES: DatabaseReference {
        return _REF_USER_MESSAGES
    }
    
    var REF_HASHTAG_POST: DatabaseReference {
        return _REF_HASHTAG_POST
    }
    /*
    // Function that creates a firebase user.
    func createFirebaseDBUser(uid: String, userData: Dictionary< String, Any>, isStoreadmin: Bool) {
        if isStoreadmin {
            REF_STOREADMIN.child(uid).updateChildValues(userData)
        } else {
            REF_USERS.child(uid).updateChildValues(userData)
        }
    }
    */
    
    // Function that creates a firebase user.
    func createFirebaseDBUser(uid: String, userData: Dictionary< String, Any>, isStoreadmin: Bool) {
        if isStoreadmin == false {
            REF_USERS.child(uid).updateChildValues(userData)
        }
    }
    
    // Function that creates a firebase admin user.
    func verifyFirebaseAdmin(uid: String, userData: Dictionary< String, Any>) {
            REF_USERS.child(uid).updateChildValues(userData)
    }
}
