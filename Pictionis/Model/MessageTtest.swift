//
//  Message.swift
//  Pictionis
//
//  Created by David LIN on 04/09/2018.
//  Copyright © 2018 David LIN. All rights reserved.
//

import Foundation

class MessageTest {
    
    private var _userId = "";
    private var _text = "";
    
    init(userId: String, text: String) {
        _userId = userId
        _text = text
    }
    
    var userId: String {
        return _userId
    }
    
    var text: String {
        return _text;
    }
}
