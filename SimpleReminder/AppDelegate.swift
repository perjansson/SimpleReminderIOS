//
//  AppDelegate.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit
import CoreData
import XCGLogger

let log = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Registering for sending user various kinds of notifications
        var notificationActionOpen :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionOpen.identifier = "OPEN_IDENTIFIER"
        notificationActionOpen.title = "Open"
        notificationActionOpen.destructive = false
        notificationActionOpen.authenticationRequired = true
        notificationActionOpen.activationMode = UIUserNotificationActivationMode.Foreground
        
        var notificationActionOK :UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationActionOK.identifier = "OK_IDENTIFIER"
        notificationActionOK.title = "OK"
        notificationActionOK.destructive = false
        notificationActionOK.authenticationRequired = true
        notificationActionOK.activationMode = UIUserNotificationActivationMode.Background
        
        var notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "NOTE_CATEGORY"
        notificationCategory.setActions([notificationActionOpen, notificationActionOK], forContext: UIUserNotificationActionContext.Default)
        notificationCategory.setActions([notificationActionOpen, notificationActionOK], forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: NSSet(array:[notificationCategory])))
                
        // Logging
        log.setup(logLevel: .Info, showLogLevel: true, showFileNames: true, showLineNumbers: true)
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if notification.category == "NOTE_CATEGORY" {
            let noteKey = notification.userInfo!["key"] as? NSString
            
            var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            var request = NSFetchRequest(entityName: "Note")
            var notes = context?.executeFetchRequest(request, error: nil)! as [Note]
            for note:Note in notes {
                if note.key == noteKey! {
                    note.date = nil
                    if identifier == "OPEN_IDENTIFIER" {
                        ReminderDetailViewController.showNote(note)
                    }
                }
            }
            
            //ReminderListViewController()
            
        }
        completionHandler()
    }
    
    func application(application: UIApplication!, didReceiveLocalNotification notification: UILocalNotification!) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.perjansson.SimpleReminder" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SimpleReminder", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SimpleReminder.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

