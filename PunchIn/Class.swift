//
//  Class.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Class : PFObject, PFSubclassing {
    
    static let classFinishedText = "Class has ended!"
    static let classStartedText = "Class has started"
    static let classNotStartedText = "Start Class"
        
    // MARK: Parse subclassing
    private static let className = "Class"
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
    @NSManaged private(set) weak var parentCourse: Course!
    @NSManaged private(set) var name: String!
    @NSManaged private(set) var courseIndex: Int
    @NSManaged private(set) var classDescription: String!
    @NSManaged private(set) var isStarted: Bool
    @NSManaged private(set) var isFinished: Bool
    @NSManaged private(set) var attendance: [Student]?
    @NSManaged private(set) var date: NSDate!
    @NSManaged private(set) var questions: [Question]?
    @NSManaged var location: Location?
    
    override init(){
        super.init()
    }

    private func areAllFieldsAvailable() -> Bool {
        var allDataAvailable = true
        allDataAvailable = allDataAvailable && self.location!.isDataAvailable()
        self.attendance!.forEach{ allDataAvailable = allDataAvailable && $0.isDataAvailable() }
        self.questions!.forEach{ allDataAvailable = allDataAvailable && $0.isDataAvailable() }
        
        return allDataAvailable
    }
    
    func fetchAllFields(forceFetch: Bool=false, completion:((theClass:Class?, error:NSError?)->Void)) {
        // perform query ONLY if forceFetch is true OR fields aren't already available
        guard forceFetch || !self.areAllFieldsAvailable() else {
            return completion(theClass:self, error:nil)
        }
                
        let query = Class.query()
        query?.whereKey("objectId", equalTo: self.objectId!)
        query?.includeKey("attendance")
        query?.includeKey("location")
        query?.includeKey("questions")
        query?.getFirstObjectInBackgroundWithBlock({ (obj: PFObject?, error: NSError?) -> Void in
            if error==nil, let theClass = obj as? Class {
                // do nothing...
                completion(theClass:theClass, error:nil)
            }else{
                completion(theClass:nil, error:error)
            }
        })
    }
    
    func didStudentAttend(student: Student) -> Bool {
        if let attendance = self.objectForKey("attendance") as? [Student] {
            return attendance.contains(student)
        }
        
        return false
    }
    
    func addQuestion(question:Question) {
        self.addObject(question, forKey:"questions")
        self.saveEventually()
    }
    
    func refreshQuestions(completion:((questions:[Question]?, error:NSError?)->Void)) {
        self.fetchAllFields(true) { (theClass, error) -> Void in
            if error == nil {
                completion(questions: theClass!.questions, error: nil)
            }else{
                completion(questions: nil, error: error)
            }
        }
    }
    
    func start(location: Location?) {
        self.isStarted = true
        self.location = location
        self.saveEventually()
    }
    
    func finish() {
        self.isFinished = true
        self.saveEventually()
    }
    
    func update() {
        self.saveEventually()
    }
    
    // utility functions
    
    class func createClass(name:String, index:Int, desc:String, date:NSDate, location:Location) -> Class {
        let theClass = Class()
        theClass.name = name
        theClass.courseIndex = index
        theClass.classDescription = desc
        theClass.date = date
        theClass.location = location
        theClass.isStarted = false
        theClass.isFinished = false
        theClass.questions = []
        theClass.attendance = []
        
        return theClass
    }
    
    func addParentCourse(course:Course) {
        parentCourse = course
    }
    
}
