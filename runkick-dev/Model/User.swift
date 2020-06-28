//
//  User.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/29/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Firebase

class User {
    
    // attributes
    var username: String!
    var firstname: String!
    var lastname: String!
    var profileImageURL: String!
    var email: String!
    var isStoreadmin: Bool!
    var profileCompleted: Bool!
    var uid: String!
    var stripeId: String!
    var isFollowed = false
    var isAdmin = false
    var isProfileCompleted = false

    
    // When we create our user it will ask us for a value
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let stripeId = dictionary["stripeId"] as? String {
            self.stripeId = stripeId
        }
        
        if let firstname = dictionary["firstname"] as? String {
            self.firstname  = firstname
        }
        
        if let lastname = dictionary["lastname"] as? String {
            self.lastname = lastname
        }
        
        if let profileImageURL = dictionary["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        if let isStoreadmin = dictionary["isStoreadmin"] as? Bool {
            
            if isStoreadmin == true {
                self.isAdmin = true
            } else {
                self.isAdmin = false
            }
        }
        
        if let profileCompleted = dictionary["profileCompleted"] as? Bool {
            
            if profileCompleted == true {
                self.isProfileCompleted = true
            } else {
                self.isProfileCompleted = false
            }
        }
        
    }
    
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // update: = Get uid like this to work with update. This uid is the user that is getting followed.
        guard let uid = uid else { return }
        
        // set is followed to true
        self.isFollowed = true
        
        // add followed user to current user-following structure
        DataService.instance.REF_FOLLOWING.child(currentUid).updateChildValues([uid: 1])
        
        // add current user to followed user-follower structure
        DataService.instance.REF_FOLLOWER.child(self.uid).updateChildValues([currentUid: 1])
        
        // upload follow notification to server
        uploadFollowNotificationToServer()
        
        // add followed users post to current user-feed

        // also use this when we check in
        DataService.instance.REF_USER_POSTS.child(self.uid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
        }
    }
    
    func unfollow() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // set is followed to false
        self.isFollowed = false
        
        // Remove followed user to current user-following structure
        DataService.instance.REF_FOLLOWING.child(currentUid).child(self.uid).removeValue()
        
        // Remove current user to followed user-follower structure
        DataService.instance.REF_FOLLOWER.child(self.uid).child(currentUid).removeValue()
  
        // Remove followed users post to current user-feed
        DataService.instance.REF_USER_POSTS.child(self.uid).observe(.childAdded) { (snapshot) in
            
            let postId = snapshot.key
            DataService.instance.REF_FEED.child(currentUid).child(postId).removeValue()
        }
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) ->()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_FOLLOWING.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(self.uid) {
                
                self.isFollowed = true
                completion(true)
                print("User is followed")
            } else {
                
                self.isFollowed = false
                completion(false)
                print("User is not followed")
            }
        }
    }
    
    func uploadFollowNotificationToServer() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // notification values
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "uid": currentUid,
                      "type": FOLLOW_INT_VALUE] as [String : Any]
        
        DataService.instance.REF_NOTIFICATIONS.child(self.uid).childByAutoId().updateChildValues(values)
    }

}
