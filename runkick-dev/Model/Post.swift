//
//  Post.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/7/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation  // for the date functionality we need the swift foundation
import Firebase

/*
enum PostType: String {
    case checkIn
    case userPost
}
*/

class Post {
    
    var caption: String!
    var likes: Int!
    var imageUrl: String!
    var videoUrl: String!
    var ownerUid: String!
    var creationDate: Date!
    var postId: String!
    var tripId: String!
    var logoId: String!
    var category: String!
    var description: String!
    var price: Double!
    var poppPrice: Double!
    var storeId: String!
    var type: String!
    var photoStyle: String!
    var mediaType: String!
    var points: Int!
    var averagePace: String!
    var distance: Double!
    var duration: String!
    var stepCount: Int!
    
    var user: User?
    var didLike = false
    var isFollowed = false
    
    
    var logo1: String!
    var logo2: String!
    var logo3: String!
    var logo4: String!
    var logo5: String!
    var logo6: String!
    var logo7: String!
    var logo8: String!
    var logo9: String!
    var logo10: String!
    var logo11: String!
    var logo12: String!

    
    init(postId: String!, user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.postId = postId
        
        self.user = user
        
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        }
        
        if let type = dictionary["type"] as? String {
            self.type = type
        }
        
        if let photoStyle = dictionary["photoStyle"] as? String {
            self.photoStyle = photoStyle
        }
        
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let price = dictionary["price"] as? Double {
            self.price = price
        }
        
        if let poppPrice = dictionary["poppPrice"] as? Double {
            self.poppPrice = poppPrice
        }
        
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let videoUrl = dictionary["videoUrl"] as? String {
            self.videoUrl = videoUrl
        }
        
        if let ownerUid = dictionary["ownerUid"] as? String {
            self.ownerUid = ownerUid
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let points = dictionary["points"] as? Int {
            self.points = points
        }
        
        if let tripId = dictionary["tripId"] as? String {
            self.tripId = tripId
        }
        
        if let logoId = dictionary["logoId"] as? String {
            self.logoId = logoId
        }
        
        if let averagePace = dictionary["averagePace"] as? String {
            self.averagePace = averagePace
        }
        
        if let duration = dictionary["duration"] as? String {
            self.duration = duration
        }
        
        if let stepCount = dictionary["stepCount"] as? Int {
            self.stepCount = stepCount
        }
        
        if let storeId = dictionary["storeId"] as? String {
            self.storeId = storeId
        }
        
        if let mediaType = dictionary["mediaType"] as? String {
            self.mediaType = mediaType
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let logo1 = dictionary["logo1"] as? String {
            self.logo1 = logo1
        }
        if let logo2 = dictionary["logo2"] as? String {
              self.logo2 = logo2
          }
        if let logo3 = dictionary["logo3"] as? String {
              self.logo3 = logo3
          }
        if let logo4 = dictionary["logo4"] as? String {
              self.logo4 = logo4
          }
        if let logo5 = dictionary["logo5"] as? String {
            self.logo5 = logo5
        }
        if let logo6 = dictionary["logo6"] as? String {
              self.logo6 = logo6
          }
        if let logo7 = dictionary["logo7"] as? String {
              self.logo7 = logo7
          }
        if let logo8 = dictionary["logo8"] as? String {
              self.logo8 = logo8
          }
        if let logo9 = dictionary["logo9"] as? String {
            self.logo9 = logo9
        }
        if let logo10 = dictionary["logo10"] as? String {
              self.logo10 = logo10
          }
        if let logo11 = dictionary["logo11"] as? String {
              self.logo11 = logo11
          }
        if let logo12 = dictionary["logo12"] as? String {
              self.logo12 = logo12
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
                
                DataService.instance.REF_USER_LIKES.child(currentUid).child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let notificationId = snapshot.value as? String {
                        DataService.instance.REF_NOTIFICATIONS.child(self.ownerUid).child(notificationId).removeValue(completionBlock: { (err, ref) in
                            
                            self.removeLike(withCompletion: { (likes) in
                                completion(likes)
                            })
                        })
                    } else {
                        self.removeLike(withCompletion: { (likes) in
                            completion(likes)
                        })
                    }
                })
                /*
                // we make sure that everything is handled within the completion block to ensure that we observer the notification snapshot value first
                
                DataService.instance.REF_USER_LIKES.child(currentUid).child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print("WE GET HERE DO WE ADD OR TAKE AWAY like \(snapshot.value)")
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
                 */
        }
    }
        
    func removeLike(withCompletion completion: @escaping (Int) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USER_LIKES.child(currentUid).child(self.postId).removeValue(completionBlock: { (err, ref) in
            
            DataService.instance.REF_POST_LIKES.child(self.postId).child(currentUid).removeValue(completionBlock: { (err, ref) in
                guard self.likes > 0 else { return }
                self.likes = self.likes - 1
                self.didLike = false
                DataService.instance.REF_POSTS.child(self.postId).child("likes").setValue(self.likes)
                completion(self.likes)
            })
        })
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
    
    
    // will need to create a function similar to this to delete user post
    func deleteCheckInPost(_ sender: String?) {
        
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
        
        // now we need to remove all hashtags related to the post we don't have this value
        
        /*
        // creates an array out of the caption to allow us to loop through that array for the hashtag
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                DataService.instance.REF_HASHTAG_POST.child(word).child(postId).removeValue()
            }
        }
        */
        
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
    
    func follow() {
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
           
           // update: = Get uid like this to work with update. This uid is the user that is getting followed.
           guard let uid = ownerUid else { return }
           
           // set is followed to true
           self.isFollowed = true
           
           // add followed user to current user-following structure
           DataService.instance.REF_FOLLOWING.child(currentUid).updateChildValues([uid: 1])
           
           // add current user to followed user-follower structure
           DataService.instance.REF_FOLLOWER.child(uid).updateChildValues([currentUid: 1])
           
           // upload follow notification to server
           uploadFollowNotificationToServer()
           
           // add followed users post to current user-feed

           // also use this when we check in
           DataService.instance.REF_USER_POSTS.child(uid).observe(.childAdded) { (snapshot) in
               
               let postId = snapshot.key
               DataService.instance.REF_FEED.child(currentUid).updateChildValues([postId: 1])
           }
       }
       
       func unfollow() {
           
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
           guard let uid = ownerUid else { return }
        
           // set is followed to false
           self.isFollowed = false
           
           // Remove followed user to current user-following structure
           DataService.instance.REF_FOLLOWING.child(currentUid).child(uid).removeValue()
           
           // Remove current user to followed user-follower structure
           DataService.instance.REF_FOLLOWER.child(uid).child(currentUid).removeValue()
     
           // Remove followed users post to current user-feed
           DataService.instance.REF_USER_POSTS.child(uid).observe(.childAdded) { (snapshot) in
               
               let postId = snapshot.key
               DataService.instance.REF_FEED.child(currentUid).child(postId).removeValue()
           }
       }
       
       func checkIfUserIsFollowed(completion: @escaping(Bool) ->()) {
           
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
           guard let uid = ownerUid else { return }
        
           DataService.instance.REF_FOLLOWING.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
               
               if snapshot.hasChild(uid) {
                   
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
        guard let uid = ownerUid else { return }
           
           // notification values
           let values = ["checked": 0,
                         "creationDate": creationDate,
                         "uid": currentUid,
                         "type": FOLLOW_INT_VALUE] as [String : Any]
           
           DataService.instance.REF_NOTIFICATIONS.child(uid).childByAutoId().updateChildValues(values)
       }
}
