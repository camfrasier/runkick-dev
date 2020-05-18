//
//  Post.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/7/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation  // for the date functionality we need the swift foundation
import Firebase

class Post {
    
    var caption: String!
    var likes: Int!
    var imageUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var storeId: String!
    var user: User?
    var didLike = false
    
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        self.user = user
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
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
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func adjustLikes(addLike: Bool, completion: @escaping(Int) -> ()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            if addLike {
                
                // must cast as a string in order for completion block to function properly in the below instance
                let post = postId as String
                
                // updates user like structure
                DataService.instance.REF_USER_LIKES.child(currentUid).updateChildValues([post: 1], withCompletionBlock: { (err, ref) in
                    
               // send notification to server
                self.sendLikeNotificationToServer()
                    
                // updates post like structure, which comes in handy when determining who liked a particular post
                DataService.instance.REF_POST_LIKES.child(self.postId).updateChildValues([currentUid: 1], withCompletionBlock: { (err, ref) in
                
                    // these values won't be set until both of the above values have been completed
                    self.likes = self.likes + 1
                    self.didLike = true
                    completion(self.likes)
                    
                    // go into the database and set the like value based on the function for adjustLikes
                    DataService.instance.REF_POSTS.child(self.postId).child("likes").setValue(self.likes)
                    
                })
            })
                
        } else {
                
                // we make sure that everything is handled within the completion block to ensure that we observer the notification snapshot value first
                DataService.instance.REF_USER_LIKES.child(currentUid).child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // notification id ot remove from server
                    guard let notificationId = snapshot.value as? String else { return }
                    
                    // remove notification from server
                    DataService.instance.REF_NOTIFICATIONS.child(self.ownerUid).child(notificationId).removeValue(completionBlock: { (err, ref) in
                        
                        DataService.instance.REF_USER_LIKES.child(currentUid).child(self.postId).removeValue(completionBlock: { (err, ref) in
                            
                            // remove post like structure
                            DataService.instance.REF_POST_LIKES.child(self.postId).child(currentUid).removeValue(completionBlock: { (err, ref) in
                                
                                guard self.likes > 0 else { return }  // make sure likes are greater than 0
                                self.likes = self.likes - 1
                                self.didLike = false
                                completion(self.likes)
                                
                                // go into the database and set the like value based on the function for adjustLikes
                                DataService.instance.REF_POSTS.child(self.postId).child("likes").setValue(self.likes)
                            })
                        })
                    })
                })
            }
        }
    
    // will need to create a function similar to this to delete user post
    func deletePost(_ sender: String?) {
        
        guard let ownderUid = sender else { return }
        print("DEBUG: This is the user post ID\(ownderUid)")
            
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Storage.storage().reference(forURL: self.imageUrl).delete(completion: nil)
        
        DataService.instance.REF_FOLLOWER.child(ownderUid).observe(.childAdded) { (snapshot) in
            let followerUid = snapshot.key
            DataService.instance.REF_FEED.child(followerUid).child(self.postId).removeValue()
        }
        
        DataService.instance.REF_FEED.child(ownderUid).child(postId).removeValue()
        
        DataService.instance.REF_USER_POSTS.child(ownderUid).child(postId).removeValue()
        
        // get all of the posts that users liked first
        DataService.instance.REF_POST_LIKES.child(postId).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            // now we find all of the post id that is being deleted from each user that has liked a post
            DataService.instance.REF_USER_LIKES.child(uid).child(self.postId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let notificationId = snapshot.value as? String else { return }
                
                // after we have observed the post likes, we need to identify the notification under the post owner and delete
                DataService.instance.REF_NOTIFICATIONS.child(self.ownerUid).child(notificationId).removeValue(completionBlock: { (err, ref) in
                    
                    // now remove post id from the post likes ref and then lastly the user likes ref - this must be done last!
                    DataService.instance.REF_POST_LIKES.child(self.postId).removeValue()
                    DataService.instance.REF_USER_LIKES.child(uid).child(self.postId).removeValue()
                })
            })
        }
        
        // now we need to remove all hashtags related to the post
        
        // creates an array out of the caption to allow us to loop through that array for the hashtag
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                DataService.instance.REF_HASHTAG_POST.child(word).child(postId).removeValue()
            }
        }
        
        DataService.instance.REF_USER_POST_COMMENT.child(postId).removeValue()
        DataService.instance.REF_POSTS.child(postId).removeValue()
    }
    
    func sendLikeNotificationToServer() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let postId = postId else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // only send notification if like is for post that is not current users
        if currentUid != self.ownerUid {
            
            // notification values
            let values = ["checked": 0,
                          "creationDate": creationDate,
                          "uid": currentUid,
                          "type": LIKE_INT_VALUE,
                          "postId": postId] as [String : Any]
            
            // upload notification values to server
            let notificationRef = DataService.instance.REF_NOTIFICATIONS.child(self.ownerUid).childByAutoId()
            
            // upload our notification values to database
            notificationRef.updateChildValues(values, withCompletionBlock:  { (err, ref) in
                DataService.instance.REF_USER_LIKES.child(currentUid).child(self.postId).setValue(notificationRef.key)
            })
        }
    }
}
