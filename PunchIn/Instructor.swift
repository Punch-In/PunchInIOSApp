//
//  Instructor.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Instructor: PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Instructor"
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
    
    // MARK: Properties saved to parse
    @NSManaged private(set) var instructorName: String!
    @NSManaged private(set) var instructorEmail: String!
    @NSManaged private(set) var instructorId: String!
    
    override init() {
        super.init()
    }
    
    init(name: String, email: String, id: String) {
        super.init()

        instructorName = name
        instructorEmail = email
        instructorId = id
    }
    
    // get instructor from email address
    class func instructor(forEmail: String, completion: ((instructor:Instructor?, error:NSError?)->Void)) {
        if let query = Instructor.query() {
            query.whereKey("instructorEmail", equalTo: forEmail)
            query.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    completion(instructor:object as? Instructor, error:nil)
                }else{
                    completion(instructor:nil, error:error)
                }
            }
        }
    }
    
    // MARK: Data Injection functions
    
    class func createInstructor(name:String, email:String, id:String) -> Instructor {
        let instructor = Instructor()
        instructor.instructorName = name
        instructor.instructorEmail = email
        instructor.instructorId = id
        
        return instructor
    }

}