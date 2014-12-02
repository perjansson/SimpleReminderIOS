//
//  ReminderDetailViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import UIKit

class ReminderDetailViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var listViewController = ReminderListViewController()
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        textView.contentInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
        
        textView.delegate = self
        textView.text = note?.text
        saveButton.enabled = false
    }
    
    func textViewDidChange(textView: UITextView) {
        saveButton.enabled = textView.text != note?.text
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if note == nil {
            self.listViewController.notes.append(Note(text: textView.text))
        } else {
            note?.text = textView.text
        }
        self.listViewController.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
