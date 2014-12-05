//
//  ReminderListViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit
import CoreData

class ReminderListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notificationManager = NotificationManager()
    var notes: [Note] = []
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        initView()        
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let firstTimeLoggingIn: Bool? = userDefaults.objectForKey("firstTimeLogin") as? Bool
        if (firstTimeLoggingIn == nil) {
            userDefaults.setBool(true, forKey: "firstTimeLogin")
            actionSheetForFirstLogin()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationBecameActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func applicationBecameActive(notification: NSNotification) {
        findAllNotes()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        findAllNotes()
        self.tableView.reloadData()
    }
    
    func actionSheetForFirstLogin() {
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        var newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context!) as Note
        newNote.key = NSUUID().UUIDString
        newNote.text = "First note with instructions\n\nHi, and thanks for getting this super simple app to save notes. Create as many notes as you like, add an optional time to be notified and just hit save.\n\nIf you want to delete a note just swipe it in the list and hit delete. Hope you enjoy the app! :)"
        newNote.createddate = NSDate()
        newNote.lastupdateddate = NSDate()
        context!.save(nil)
    }
    
    class func showNotes() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewControllerWithIdentifier("NavigationController") as UINavigationController
        UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
        
        let reminderListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ReminderListViewController") as ReminderListViewController
        
        navigationController.pushViewController(reminderListViewController, animated: true)
    }
    
    func initView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func findAllNotes() {
        self.notes = []
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        var request = NSFetchRequest(entityName: "Note")
        var allNotes = context?.executeFetchRequest(request, error: nil)! as [Note]
        for note:Note in allNotes {
            if !note.isdeleted {
                self.notes.append(note)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var note = self.notes[indexPath.row]
        var cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel!.text = note.text
        cell.textLabel!.font = UIFont(name: "AvenirNext-Regular", size: 17)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.note = self.notes[indexPath.row]
        self.performSegueWithIdentifier("showDetailSegue", sender: self)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
            var note = self.notes[indexPath.row]
            note.isdeleted = true
            self.notificationManager.cancelAnyExistingNotification(note)
            context!.save(nil)
            findAllNotes()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    @IBAction func onNew(sender: AnyObject) {
        self.note = nil
        self.performSegueWithIdentifier("showDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController = segue.destinationViewController as ReminderDetailViewController
        detailViewController.delegate = self
        detailViewController.note = self.note
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
    
    func onSave(note: Note) {
        self.notificationManager.handleNotification(note)
        //findAllNotes()
        //self.tableView.reloadData()
    }

}

