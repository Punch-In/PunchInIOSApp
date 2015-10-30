//
//  Class.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Class : PFObject, PFSubclassing, LocationProviderGeofenceDelegate {
    
    static let classFinishedText = "Class has ended!"
    static let classStartedText = "Class has started"
    static let classNotStartedText = "Start Class"
    
    static let insideClassGeofenceNotification = "InsideClassGeofenceNotification"
    static let outsideClassGeofenceNotification = "OutsideClassGeofenceNotification"

    
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
    @NSManaged private(set) var startTime: NSDate!
    @NSManaged private(set) var finishTime: NSDate!
    @NSManaged var location: Location?
    
    var geofenceRegion: CLCircularRegion? {
        get {
            if let location = self.location {
                return LocationProvider.createGeofenceRegion(location, id: self.name)
            }else {
                return nil
            }
        }
    }
    
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
    
    // MARK: Refresh data
    
    private func fetchAllFields(forceFetch: Bool=false, completion:((myClass:Class?, error:NSError?)->Void)) {
        // perform query ONLY if forceFetch is true OR fields aren't already available
        guard forceFetch || !self.areAllFieldsAvailable() else {
            return completion(myClass:self, error:nil)
        }
                
        let query = Class.query()
        query?.whereKey("objectId", equalTo: self.objectId!)
        query?.includeKey("attendance")
        query?.includeKey("location")
        query?.includeKey("questions")
        query?.getFirstObjectInBackgroundWithBlock({ (obj: PFObject?, error: NSError?) -> Void in
            if error==nil, let theClass = obj as? Class {
                // do nothing...
                completion(myClass:theClass, error:nil)
            }else{
                completion(myClass:nil, error:error)
            }
        })
    }
    
    func refreshDetails(completion:((theClass:Class?, error:NSError?)->Void)) {
        self.fetchAllFields(true) { (myClass, error) -> Void in
            if error == nil {
                completion(theClass: myClass, error: nil)
            }else{
                completion(theClass: nil, error: error)
            }
        }
    }

    
    func refreshQuestions(completion:((questions:[Question]?, error:NSError?)->Void)) {
        self.fetchAllFields(true) { (myClass, error) -> Void in
            if error == nil {
                completion(questions: myClass!.questions, error: nil)
            }else{
                completion(questions: nil, error: error)
            }
        }
    }
    
    func refreshAttendance(completion:((attendance:[Student]?, error:NSError?)->Void)) {
        self.fetchAllFields(true) { (myClass, error) -> Void in
            if error == nil {
                completion(attendance: myClass!.attendance, error: nil)
            }else{
                completion(attendance: nil, error: error)
            }
        }
    }
    
    
    // MARK: class workflow
    func start(completion: ((error:NSError?)->Void)) {
        LocationProvider.location{ (location, error) -> Void in
            if error == nil {
                self.startMe(location)
                completion(error:nil)
            }else{
                print("error getting location for starting class \(error)")
                completion(error:error)
            }
        }
    }
    
    private func startMe(location: Location?) {
        self.isStarted = true
        self.location = location
        self.startTime = NSDate()
        self.saveEventually()
    }
    
    // TODO: add completion handler to finish when parsedb is updated
    func finish() {
        self.isFinished = true
        self.finishTime = NSDate()
        self.saveEventually()
    }
    
    func update() {
        self.saveEventually()
    }
    
    // MARK: attendance workflow
    func attendClass(student:Student, completion:((confirmed:Bool)->Void)) {
        // TODO: can we assume this can only be called if the geofence is satisfied?
        self.addStudentToAttendance(student)
        completion(confirmed:true)
    }

    func notifyWhenStudentCanAttendClass() {
        guard !self.isFinished else {
            return
        }
        
        guard self.isStarted else {
            return
        }
        
        if let region = self.geofenceRegion {
            LocationProvider.notifyWhenInsideGeofence(region, delegate: self)
        }
    }
    
    // MARK: LocationProviderGeofenceDelegate
    func isInsideGeofence() {
        print("inside geofence...")
        LocationProvider.removeNotifyForRegion(self.geofenceRegion!)
        NSNotificationCenter.defaultCenter().postNotificationName(Class.insideClassGeofenceNotification, object: nil)
    }
    
    func isOutsideGeofence() {
        print("outside geofence...")
        NSNotificationCenter.defaultCenter().postNotificationName(Class.outsideClassGeofenceNotification, object: nil)
    }
    
    func isUnknown() {
        print("still outside geofence...")
    }
    
    func errorGettingLocation(error: NSError) {
        print("error getting location! \(error)")
    }
    
    private func stopCheckingForGeofence() {
        // triggered by NSTimer
        LocationProvider.removeNotifyForRegion(self.geofenceRegion!)
    }

    
    // MARK: additional function
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
    
    private func addStudentToAttendance(student:Student) {
        if let attendance = self.attendance {
            if !attendance.contains(student) {
                self.attendance!.append(student)
                self.saveEventually()
            }
        }
    }

    
    // MARK: utility functions
    
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
