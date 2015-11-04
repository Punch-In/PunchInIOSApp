//
//  Class.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Class : PFObject, PFSubclassing, LocationProviderGeofenceDelegate {
    
    static let textForClassFinished = "Class has ended!"
    static let textForInstructorClassStarted = "You've started the class.\nTap again to finish"
    static let textForInstructorClassNotStarted = "Start the class"
    static let textForStudentClassNotStarted = "Class hasn't started yet"
    static let textForStudentClassStarted = "Class has started.\nTap to check in -->"
    static let textForStudentClassCheckedIn = "You've checked in for the class!"
    static let textForStudentOutsideGeofence = "You can't check in because you're not at the class location"
    
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
    @NSManaged private(set) var attendance: [Student]!
    @NSManaged private(set) var date: NSDate!
    @NSManaged private(set) var questions: [Question]!
    @NSManaged private(set) var startTime: NSDate!
    @NSManaged private(set) var finishTime: NSDate!
    @NSManaged private var classDuration: String? // grr.. to allow optionals
    @NSManaged var location: Location?
    
    var geofenceRegion: CLCircularRegion? {
        get {
            if let location = self.location {
                return LocationProvider.createGeofenceRegion(location, id: self.name)
            }else {
                return LocationProvider.createGeofenceRegion(self.parentCourse.courseLocation, id: self.name)
            }
        }
    }
    
    var isUsingCourseLocation: Bool {
        return location == parentCourse.courseLocation
    }
    
    /// grr... because NSManaged doesn't allow optionals on Ints, use this approach to 
    //      dynamically source the duration of the class
    var duration:Int {
        if let cd = classDuration {
            return Int(cd)!
        }else{
            return parentCourse.courseDurationMin
        }
    }
    
    private static let timeFormatter : NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEEEE, MMM dd, y @ h:mma"
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter
    }()
    
    private static let shortTimeFormatter : NSDateFormatter = {
       var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = NSTimeZone.localTimeZone()
        return formatter
    }()
    
    var dateString: String {
        get {
            return Class.timeFormatter.stringFromDate(self.date)
        }
    }
    
    var shortDateString: String {
        get {
            return Class.shortTimeFormatter.stringFromDate(self.date)
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
    
    private func copyFrom(otherClass:Class?){
        if let other = otherClass {
            self.parentCourse = other.parentCourse
            self.name = other.name
            self.courseIndex = other.courseIndex
            self.classDescription = other.classDescription
            self.isStarted = other.isStarted
            self.isFinished = other.isFinished
            self.attendance = other.attendance
            self.date = other.date
            self.questions = other.questions
            self.startTime = other.startTime
            self.finishTime = other.finishTime
            self.classDuration = other.classDuration
            self.location = other.location
        }
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
        // query?.includeKey("attendance.student")
        // query?.includeKey("attendance.location")
        // query?.includeKey("attendance.forClass")
        query?.includeKey("location")
        query?.includeKey("questions")
        
        if self.areAllFieldsAvailable() {
            // only refresh if the object has been updated
            query?.whereKey("updatedAt", greaterThan: self.updatedAt!)
        }
        
        query?.getFirstObjectInBackgroundWithBlock({ (obj: PFObject?, error: NSError?) -> Void in
            if error==nil, let theClass = obj as? Class {
                // copy the contents to self
                self.copyFrom(theClass)
                completion(myClass:self, error:nil)
            }else if error!.code == 101 {
                // object not found means the class wasn't updated, so just pass the original object back
                completion(myClass:self, error:nil)
            }else{
                // some other error
                completion(myClass:nil, error:error)
            }
        })
    }
    
    func refreshDetails(completion:((error:NSError?)->Void)) {
        self.fetchAllFields(true) { (myClass, error) -> Void in
            if error == nil {
                completion(error: nil)
            }else{
                completion(error: error)
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
    
    func absentStudents() -> [Student] {
        if let registered = parentCourse.registeredStudents {
            return registered.filter{ !self.attendance!.contains($0) }
        }else{
            print("registered students for course \(self.parentCourse.courseName) is nil")
            return []
        }
    }
    
    
    // MARK: class workflow
    func start(useCourseLocation isCourseLocation:Bool, completion: ((error:NSError?)->Void)) {
        
        if isCourseLocation {
            // just use the configured location of the course
            self.startMe(self.parentCourse.courseLocation)
            completion(error:nil)
        }else{
            // start class using current location or stored location
            LocationProvider.location{ (location, error) -> Void in
                if error == nil {
                    self.startMe(location)
                    completion(error:nil)
                }else{
                    print("error getting current location for starting class \(error); using course location instead")
                    self.startMe(self.parentCourse.courseLocation)
                    completion(error:nil)
                }
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

    private var classEndTimer: NSTimer?
    private(set) var isWaitingToAttend = false
    
    func canCheckIn() -> Bool {
        if self.isFinished {
            return false
        }
        
        if !self.isStarted {
            return false
        }
        
        // class has started, and is not finished
        return true
    }
    
    func notifyWhenStudentCanAttendClass() {
        guard !self.isFinished else {
            return
        }
        
        guard self.isStarted else {
            return
        }
        
        if let region = self.geofenceRegion {
            isWaitingToAttend = true
            LocationProvider.notifyWhenInsideGeofence(region, delegate: self)
        }
    }
    
    // MARK: LocationProviderGeofenceDelegate
    func isInsideGeofence() {
        print("inside geofence...")
        isWaitingToAttend = false
        LocationProvider.removeNotifyForRegion(self.geofenceRegion!)
        NSNotificationCenter.defaultCenter().postNotificationName(Class.insideClassGeofenceNotification, object: nil)
    }
    
    func isOutsideGeofence() {
        print("outside geofence...")
        NSNotificationCenter.defaultCenter().postNotificationName(Class.outsideClassGeofenceNotification, object: nil)

        // disable location tracking after estimated class end
        /*
        let estimatedClassEnd = self.startTime.dateByAddingTimeInterval(Double(self.duration*60))
        let now = NSDate().dateByAddingTimeInterval(Double(NSTimeZone.localTimeZone().secondsFromGMT))
        switch now.compare(estimatedClassEnd) {
        case .OrderedSame:
            // class has likely ended -- stop tracking
            stopCheckingForGeofence()
        case .OrderedDescending:
            // now is later than class end -- stop track
            stopCheckingForGeofence()
        case .OrderedAscending:
            // now is earlier than class end -- set timer for difference
            let ti = estimatedClassEnd.timeIntervalSinceDate(now)
            self.classEndTimer = NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: "stopCheckingForGeofence", userInfo: nil, repeats: false)
        }
        */
    }
    
    func isUnknown() {
        print("still outside geofence...")
    }
    
    func errorGettingLocation(error: NSError) {
        print("error getting location! \(error)")
    }
    
    func disableNotifyWhenStudentCanAttendClass() {
        stopCheckingForGeofence()
    }
    
    func stopCheckingForGeofence() {
        // triggered by NSTimer
        isWaitingToAttend = false
        print("stopping check for geofence")
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
