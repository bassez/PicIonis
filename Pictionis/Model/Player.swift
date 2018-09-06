//
//  Player.swift
//  Pictionis
//
//  Created by David LIN on 06/09/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Player {
    let email:String!
    let online:Bool!
    let state:String!
    
    // initialise les informations de cette structure
    init(email:String, online:Bool, state:String) {
        self.email = email
        self.online = online
        self.state = state
    }
    
    var dictionary:[String:Any] {
        return [
            "email" : email,
            "online" : online,
            "state" : state
        ]
    }
}

extension Player : DocumentSerializable {
    init?(dictionary:[String:Any]) {
        guard let email = dictionary["email"] as? String,
            let online = dictionary["online"] as? Bool,
            let state = dictionary["state"] as? String else {return nil}
        
        self.init(email: email, online: online, state: state)
    }
}
