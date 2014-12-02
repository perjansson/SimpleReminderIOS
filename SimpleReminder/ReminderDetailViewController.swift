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
    
    @IBOutlet weak var notificationTextView: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dateFormatter = NSDateFormatter()
    var DatePickerView  : UIDatePicker = UIDatePicker()
    
    var listViewController = ReminderListViewController()
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        textView.contentInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
        
        textView.delegate = self
        textView.text = note?.text
        saveButton.enabled = false
        
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        DatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        DatePickerView.addTarget(self, action: Selector("dateTimePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        notificationTextView.inputView = DatePickerView
        if note?.date != nil {
            notificationTextView.text = dateFormatter.stringFromDate(note!.date!)
        }
    }
    
    func dateTimePickerDidChange() {
        notificationTextView.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(DatePickerView.date), attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        toggleSaveButton()
    }
    
    func textViewDidChange(textView: UITextView) {
        toggleSaveButton()
    }
    
    func toggleSaveButton() {
        saveButton.enabled = textView.text != note?.text || DatePickerView.date != note?.date
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if note == nil {
            self.listViewController.notes.append(Note(text: textView.text, date: DatePickerView.date))
        } else {
            note?.text = textView.text
            note?.date = DatePickerView.date
        }
        self.listViewController.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
