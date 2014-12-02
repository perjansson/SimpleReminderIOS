//
//  NoteNotifyManager.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-12-02.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import UIKit

class NotificationManager {
    
    func handleNotification(note: Note) {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "OK"
        localNotification.alertBody = note.text
        localNotification.fireDate = note.date
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}