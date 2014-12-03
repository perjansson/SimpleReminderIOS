//
//  ReminderDetailViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

class ReminderDetailViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var notificationTextView: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dateFormatter = NSDateFormatter()
    var DatePickerView: UIDatePicker = UIDatePicker()
    
    var delegate: ReminderListViewController?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        automaticallyAdjustsScrollViewInsets = false
        
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        DatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        DatePickerView.addTarget(self, action: Selector("dateTimePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        notificationTextView.inputView = DatePickerView
        if note?.date != nil {
            notificationTextView.text = dateFormatter.stringFromDate(note!.date!)
        }
        notificationTextView.delegate = self
        
        textView.contentInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
        textView.delegate = self
        textView.text = note?.text
        
        saveButton.enabled = false
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if note == nil {
            var newNote = Note(text: textView.text)
            newNote.date = getSelectedDate()
            self.delegate!.onSave(newNote);
        } else {
            note!.text = textView.text
            note!.date = getSelectedDate()
            self.delegate!.onSave(note!);
        }
                
        log.debug("Saving note '" + note!.description)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getSelectedDate() -> NSDate? {
        if notificationTextView.text != "" {
            let date = dateFormatter.dateFromString(notificationTextView.text)
            let calendar = NSCalendar( calendarIdentifier:NSGregorianCalendar )
            let components = calendar?.components( NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: date! )
            let dateStrippedOfTimeComponent : NSDate? = calendar?.dateFromComponents(components!)
            return dateStrippedOfTimeComponent!
        } else {
            return nil
        }
    }
    
    func dateTimePickerDidChange() {
        notificationTextView.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(DatePickerView.date), attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        toggleSaveButton()
    }
    
    func textViewDidChange(textView: UITextView) {
        toggleSaveButton()
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        toggleSaveButton()
        return true
    }
    
    func toggleSaveButton() {
        saveButton.enabled = textView.text != note?.text || DatePickerView.date != note?.date
    }
    
}
