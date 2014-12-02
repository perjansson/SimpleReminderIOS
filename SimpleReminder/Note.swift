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
    var date: NSDate?
    
    init(text: String) {
        self.key = NSUUID().UUIDString
        self.text = text
    }
    
    init(text: String, date: NSDate) {
        self.key = NSUUID().UUIDString
        self.text = text
        self.date = date
    }
    
    func isNew() -> Bool {
        return key == nil
    }
    
}