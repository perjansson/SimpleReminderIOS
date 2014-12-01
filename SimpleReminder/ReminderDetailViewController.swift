//
//  ReminderDetailViewController.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-11-30.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import UIKit

class ReminderDetailViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var listViewController = ReminderListViewController()
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        textView.text = note?.text
    }
    
    @IBAction func onSave(sender: AnyObject) {
        self.listViewController.notes.append(Note(text: textView.text))
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
