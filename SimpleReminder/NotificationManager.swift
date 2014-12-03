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
        if note.notification != nil {
            cancelNotification(note)
        }
        
        if note.date != nil {
            scheduleNotification(note)
        }
    }
    
    func cancelNotification(note: Note) {
        log.debug("Cancelling notification " + note.notification!.description)
        UIApplication.sharedApplication().cancelLocalNotification(note.notification!)
        note.notification = nil
    }
    
    func scheduleNotification(note: Note) {
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = note.text
        localNotification.fireDate = note.date
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        note.notification = localNotification
        log.debug("Scheduling notification " + note.notification!.description)
    }
    
}