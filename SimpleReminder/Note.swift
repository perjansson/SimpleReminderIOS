//
//  Note.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-12-01.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation

class Note {
    
    var key:String?
    var text:String?
    
    init(text: String) {
        self.key = NSUUID().UUIDString
        self.text = text
    }
    
    func isNew() -> Bool {
        return key == nil
    }
    
}