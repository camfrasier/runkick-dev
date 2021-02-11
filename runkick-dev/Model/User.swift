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
    var stepCount: Int!
    var distance: Double!
    var isFollowed = false
    var isAdmin = false
    var isProfileCompleted = false
    var activityDate: String!
    var lo1: String!

    
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
        
        if let activityDate = dictionary["dailyActivityDate"] as? String {
            self.activityDate = activityDate
        }
        
        if let stepCount = dictionary["dailyStepCount"] as? Int {
            self.stepCount = stepCount
        }
        
        if let distance = dictionary["dailyDistance"] as? Double {
            self.distance = distance
        }
        
        if let lo1 = dictionary["lo1"] as? String {
            self.lo1 = lo1
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
    
    func inviteUserToGroup(_ groupId: String) {
        // access database etc. and send notification
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = uid else { return }
        
        print("Here is the current user id \(currentUid)")
        print("Here is the user id \(uid)")
        print("Here is the user group Id \(groupId)")
       
        // adding user to group
        //DataService.instance.REF_USER_GROUPS.child(groupId).child("members").childByAutoId().updateChildValues(["uid": uid])
        DataService.instance.REF_USER_GROUPS.child("\(groupId)/members").childByAutoId().setValue(uid)
        
        
        // adding the user group to user profile
        let creationDate = Int(NSDate().timeIntervalSince1970)
        DataService.instance.REF_USERS.child(uid).child("groups").child(groupId).updateChildValues(["inviteDate": creationDate, "inviteAccepted": false, "isAdmin": false])
        
    }
    
    func uninviteUserToGroup(_ groupId: String) {
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = uid else { return }

        // remove specific user to group
        DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
            for snap in snapshots {
                    
                let snapshotKey = snap.key
                    
                    print("This should be the key \(snapshotKey)")
                DataService.instance.REF_USER_GROUPS.child(groupId).child("members").child(snapshotKey).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let keyValue = snapshot.value as? String
                    
                   print("This should be the value for key \(keyValue)")
                    
                    if uid == keyValue {
                        print("here we should remove the key value in question")
                        DataService.instance.REF_USER_GROUPS.child(groupId).child("members").child(snapshotKey).removeValue()
                    }
                }
                    
                }
            }
        })
    
        
        // adding the user group to user profile
        DataService.instance.REF_USERS.child(uid).child("groups").child(groupId).removeValue()
        
        /*
            DataService.instance.REF_USERS.child(currentUid).child("groups").queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
                
                // preserving groupId
                let groupId = snapshot.key
                
                print("The USER GROUP ID IS>>> \(groupId)")
                
                // remove specific user to group
                DataService.instance.REF_USER_GROUPS.child(groupId).child("members").child(uid).removeValue()
                
                // adding the user group to user profile
                DataService.instance.REF_USERS.child("groups").child(groupId).removeValue()
            }
         */
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
