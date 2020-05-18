//
//  Message.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/26/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    // the benefit to creating a custom object is time and less effort
    var messageText: String!
    var fromId: String!
    var toId: String!
    var creationDate: Date!
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        if let messageText = dictionary["messageText"] as? String {
            self.messageText = messageText
        }
        
        if let fromId = dictionary["fromId"] as? String {
            self.fromId = fromId        }
        
        if let toId = dictionary["toId"] as? String {
            self.toId = toId
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
    }
    
    func getChatPartnerId() -> String {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return ""}
        
        // determining who are chat partner is in this function
        if fromId == currentUid {
            return toId
        } else {
            return fromId
        }
        
    }
}
