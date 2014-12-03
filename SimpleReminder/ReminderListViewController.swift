//
//  ReminderListViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit

class ReminderListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notificationManager = NotificationManager()
    var noteRepository = NoteRepository()
    var notes: [Note] = []
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        findAllNotes()
    }
    
    func initView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func findAllNotes() {
        self.notes = noteRepository.findAll()
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
        cell.textLabel.text = note.text!
        cell.textLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)
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
            noteRepository.delete(self.notes[indexPath.row])
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
        self.noteRepository.save(note)
        findAllNotes()
        self.tableView.reloadData()
    }

}

