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
    
    var dateFormatter = NSDateFormatter()
    
    func handleNotification(note: Note) {
        cancelAnyExistingNotification(note)
        if note.date != nil {
            scheduleNotification(note)
        }
    }
    
    func notificationForNoteExist(note: Note) {
        
    }
    
    func cancelAnyExistingNotification(note: Note) {
        for n:AnyObject in UIApplication.sharedApplication().scheduledLocalNotifications {
            var notification = n as UILocalNotification
            let noteKey = notification.userInfo!["key"] as? NSString
            if note.key == noteKey! {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                log.debug("Cancelling notification for note " + note.text)
            }
        }
    }
    
    func scheduleNotification(note: Note) {       
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.category = "NOTE_CATEGORY";
        localNotification.alertBody = note.text
        localNotification.fireDate = note.date
        localNotification.userInfo = ["key":note.key]
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1;
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        log.debug("Scheduling notification for note " + note.text + " at " + dateFormatter.stringFromDate(note.date!))
    }
    
}