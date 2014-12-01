//
//  ReminderListViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import UIKit

class ReminderListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notes: [Note] = []
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.notes.append(Note(text: "Buy milk"))
        self.notes.append(Note(text: "Call Mike"))
        self.notes.append(Note(text: "Walk the dog"))
        self.notes.append(Note(text: "Push the code"))
        self.notes.append(Note(text: "Make coffee"))
        self.notes.append(Note(text: "Cut the lawn"))
        self.notes.append(Note(text: "Paint the bedroom"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel!.text = self.notes[indexPath.row].text
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.note = self.notes[indexPath.row]
        self.performSegueWithIdentifier("showDetailSegue", sender: self)
    }
    
    @IBAction func onNew(sender: AnyObject) {
        self.note = nil
        self.performSegueWithIdentifier("showDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController = segue.destinationViewController as ReminderDetailViewController
        detailViewController.listViewController = self
        detailViewController.note = self.note
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }

}

