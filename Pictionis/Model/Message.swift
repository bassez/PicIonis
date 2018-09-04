//
//  Message.swift
//  Pictionis
//
//  Created by David LIN on 30/08/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Message {
    let username:String!
    let text:String!
    let timeStamp:Date
    
    // initialise les informations de cette structure
    init(username:String, text:String, timeStamp:Date) {
        self.username = username
        self.text = text
        self.timeStamp = timeStamp
    }
    
    var dictionary:[String:Any] {
        return [
            "username" : username,
            "text" : text,
            "timeStamp" : timeStamp
        ]
    }
}

extension Message : DocumentSerializable {
    init?(dictionary:[String:Any]) {
        guard let username = dictionary["username"] as? String,
            let text = dictionary["text"] as? String,
            let timeStamp = dictionary["timeStamp"] as? Date else {return nil}
        
        self.init(username: username, text: text, timeStamp: timeStamp)
    }
}
