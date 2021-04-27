//
//  Notification.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/18/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation

class Notification {
    
    enum NotificationType: Int, Printable {
        
        case Like
        case Comment
        case Follow
        case CommentMention
        case PostMention
        case Message
        
        // created a protocol Printable so we are conforming here
        var description: String {
            switch self {
            case .Like: return " liked your post"
            case .Comment: return " commented on your post"
            case .Follow: return " started following you"
            case .CommentMention: return " mentioned you in a comment"
            case .PostMention: return " mentioned you in a post"
            case .Message: return " messaged you!"
            }
        }
        
        init(index: Int) {
            switch index { // because we cannot use every case for all integers we need to use a default to exhause our case
            case 0: self = .Like
            case 1: self = .Comment
            case 2: self = .Follow
            case 3: self = .CommentMention
            case 4: self = .PostMention
            case 5: self = .Message
            default: self = .Message
            }
        }
    }
    
    var creationDate: Date!
    var uid: String!
    var postId: String?
    var post: Post?
    var user: User!
    var type: Int?
    var notificationType: NotificationType!
    var didCheck = false
    
    // the post value below creates an optional value
    init(user: User, post: Post? = nil, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let post = post {
            self.post = post
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        // getting the integer value from our database, then we are initializing our enum with that integer value that we grabbed
        if let type = dictionary["type"] as? Int {
            self.notificationType = NotificationType(index: type)
        }
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
        
        if let postId = dictionary["postId"] as? String {
            self.postId = postId
        }
        
        if let checked = dictionary["checked"] as? Int {
            
            if checked == 0 {
                self.didCheck = false
            } else {
                self.didCheck = true
            }
        }
    }
}
