//
//  ChatroomMessage.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/6/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class ChatroomMessage {
    
    // the benefit to creating a custom object is time and less effort
    var messageText: String!
    var fromId: String!
    var messageKey: String!
    var creationDate: Date!
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        if let messageText = dictionary["messageText"] as? String {
            self.messageText = messageText
        }
        
        if let fromId = dictionary["fromId"] as? String {
            self.fromId = fromId        }
        
        if let messageKey = dictionary["messageKey"] as? String {
            self.messageKey = messageKey
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    /*
    func getChatPartnerId() -> String {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return ""}
        
        // determining who are chat partner is in this function
        if fromId == currentUid {
            return toId
        } else {
            return fromId
        }
    }
    */
}
