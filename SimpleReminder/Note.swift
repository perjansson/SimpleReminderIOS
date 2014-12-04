//
//  Note.swift
//  SimpleReminder
//
//  Created by Per Jansson on 2014-12-04.
//  Copyright (c) 2014 Per Jansson. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {

    @NSManaged var key: String
    @NSManaged var text: String
    @NSManaged var date: NSDate?
    @NSManaged var createddate: NSDate
    @NSManaged var lastupdateddate: NSDate
    @NSManaged var isdeleted: Bool

}
