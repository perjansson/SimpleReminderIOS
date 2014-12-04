//
//  Note.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-12-01.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import UIKit

class Note {
    
    var key: String?
    var text: String?
    var date: NSDate?
    var notification: UILocalNotification?
    
    // Audit stuff
    var createdDate: NSDate?
    var lastUpdatedDate: NSDate?
    var deleted: Bool = false
    
    init(text: String) {
        self.text = text
    }
    
    init(text: String, key: String) {
        self.text = text
        self.key = key
    }
    
    var description: String {
        return "Text: \(text) Date: \(date) CreatedDate: \(createdDate) LastUpdatedDate: \(lastUpdatedDate) Deleted: \(deleted)"
    }
    
}