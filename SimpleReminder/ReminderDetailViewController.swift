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
import CoreData

class ReminderDetailViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var notificationTextView: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dateFormatter = NSDateFormatter()
    var datePickerView: UIDatePicker = UIDatePicker()
    
    var delegate: ReminderListViewController?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    class func showNote(note: Note) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewControllerWithIdentifier("NavigationController") as UINavigationController
        UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
        
        let reminderListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ReminderListViewController") as ReminderListViewController
        let reminderDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ReminderDetailViewController") as ReminderDetailViewController
        reminderDetailViewController.delegate = reminderListViewController
        reminderDetailViewController.note = note
        
        navigationController.pushViewController(reminderDetailViewController, animated: true)
    }
    
    func initView() {
        automaticallyAdjustsScrollViewInsets = false
        
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        datePickerView.addTarget(self, action: Selector("dateTimePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        notificationTextView.inputView = datePickerView
        if note?.date != nil {
            notificationTextView.text = dateFormatter.stringFromDate(note!.date!)
            datePickerView.date = note!.date!
        }
        notificationTextView.delegate = self
        
        textView.contentInset = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
        textView.delegate = self
        textView.text = note?.text
        
        saveButton.enabled = false
    }
    
    @IBAction func onSave(sender: AnyObject) {
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        if note == nil {
            var newNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context!) as Note
            newNote.key = NSUUID().UUIDString
            newNote.text = textView.text
            newNote.createddate = NSDate()
            newNote.lastupdateddate = NSDate()
            var selectedDate : NSDate? = getSelectedDate()
            if selectedDate != nil {
                newNote.date = selectedDate!
            }
            note = newNote
        } else {
            note!.text = textView.text
            var selectedDate : NSDate? = getSelectedDate()
            if selectedDate != nil {
                note!.date = selectedDate!
            }
            note!.lastupdateddate = NSDate()
        }
        
        context!.save(nil)
        self.delegate!.onSave(note!);
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
        notificationTextView.attributedText = NSAttributedString(string: dateFormatter.stringFromDate(datePickerView.date), attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        toggleSaveButton()
    }
    
    func textFieldDidBeginEditing(textView: UITextView) -> Bool {
        datePickerView.minimumDate = defaultMinimumDate()
        return true
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        return false;
    }
    
    func textViewDidChange(textView: UITextView) {
        toggleSaveButton()
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        datePickerView.date = defaultMinimumDate()
        toggleSaveButton()
        return true
    }
    
    func defaultMinimumDate() -> NSDate {
        return NSDate().dateByAddingTimeInterval(60)
    }
    
    func toggleSaveButton() {
        saveButton.enabled = hasText() && dateOrTextHasChanges() && dateIsAfterNow()
    }
    
    func hasText() -> Bool {
        return !textView.text.isEmpty
    }
    
    func dateOrTextHasChanges() -> Bool {
        return textView.text != note?.text || datePickerView.date != note?.date
    }
    
    func dateIsAfterNow() -> Bool {
        return notificationTextView.text.isEmpty || (datePickerView.date.laterDate(NSDate()) == datePickerView.date)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, -5.0, keyboardSize.height, 0.0)
        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
    }
    
}
