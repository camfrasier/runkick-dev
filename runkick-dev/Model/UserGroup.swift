//
//  UserGroup.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/20/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Firebase

class UserGroup {
    
    // attributes
    var groupId: String!
    var groupName: String!
    var profileImageURL: String!
    var memberId: String!
    var groupOwnerId: String!
    var groupPrivate = false

    
    // When we create our user it will ask us for a value
    init(groupId: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.groupId = groupId
        
        if let groupName = dictionary["groupName"] as? String {
            self.groupName = groupName
        }

        
        if let groupId = dictionary["groupId"] as? String {
            self.groupId  = groupId
        }
        
        if let memberId = dictionary["memberId"] as? String {
            self.memberId = memberId
        }
        
        if let profileImageURL = dictionary["profileImageURL"] as? String {
            self.profileImageURL = profileImageURL
        }
        
        if let groupPrivate = dictionary["groupPrivate"] as? Bool {
            
            if groupPrivate == true {
                self.groupPrivate = true
            } else {
                self.groupPrivate = false
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
        
       //DataService.instance.REF_NOTIFICATIONS.child(self.uid).childByAutoId().updateChildValues(values)
    }

}
