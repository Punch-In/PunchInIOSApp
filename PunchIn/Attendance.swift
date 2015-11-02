//
//  Attendance.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class Attendance: PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Attendance"
    private static var initialized = false
    
    override class func initialize() {
        if !initialized {
            print("registered \(className) with parse!")
            registerSubclass()
            initialized=true
        }
    }
    
    class func parseClassName() -> String {
        return className
    }

    // MARK: Properties stored to Parse
    @NSManaged private(set) var student: Student!
    @NSManaged private(set) var checkInTime: NSDate!
    @NSManaged private(set) var location: Location
    @NSManaged private(set) weak var forClass: Class!

    override init() {
        super.init()
    }
}
