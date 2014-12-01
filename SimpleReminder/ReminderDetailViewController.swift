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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        //textView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0)
    }
    
}
