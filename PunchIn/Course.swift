//
//  Courses.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class Course: PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Course"
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
    @NSManaged private(set) var courseName: String!
    @NSManaged private(set) var courseId: String!
    @NSManaged private(set) var courseTime: String! // TODO: fix me; should be a date? duration?
    @NSManaged private(set) var courseDay: String! // TODO: fix me; should be a date?
    @NSManaged private(set) var courseDurationMin: Int // in minutes
    @NSManaged private(set) var courseDescription: String!
    @NSManaged private(set) var courseInstructors: [Instructor]?
    @NSManaged private(set) var courseTAs: [Instructor]?
    @NSManaged private(set) var registeredStudents: [Student]?
    @NSManaged private(set) var classes: [Class]?
    @NSManaged private(set) var courseLocation: Location!
    @NSManaged private(set) var courseImageFile: PFFile?
    
    // MARK: Properties not saved
    private(set) var courseImage:UIImage?
    
    override init() {
        super.init()
    }
        
    class func allCourses(completion: ((courses: [Course]?, error:NSError?)->Void)){
        if let query = Course.query() {
//            query.includeKey("registeredStudents")
//            query.includeKey("courseTAs")
//            query.includeKey("courseInstructors")
            query.findObjectsInBackgroundWithBlock {
                (courses: [PFObject]?, error: NSError?) -> Void in
                completion(courses: courses as? [Course], error: error)
            }
        }
    }
    
    class func courses(handler: ((courses: [Course]?, error:NSError?)->Void)){
        ParseDB.initializeCurrentPerson({ (error) -> Void in
            if error == nil {
                if ParseDB.isStudent {
                    Course.courses(ParseDB.currentPerson as! Student, completion: handler)
                }else {
                    Course.courses(ParseDB.currentPerson as! Instructor, completion: handler)
                }
            }else{
                /// TODO...
                print("error initializing ParseDB.person \(error)")
                handler(courses:nil, error:error)
            }
        })
    }
    
    @objc(getCoursesForInstructor:instructor:)
    class func courses(forInstructor: Instructor, completion: ((courses: [Course]?, error:NSError?)->Void)) {
        if let query = Course.query() {
            query.whereKey("courseInstructors", equalTo: forInstructor)
            query.includeKey("courseLocation")
            query.includeKey("classes")
            query.includeKey("registeredStudents")
            query.includeKey("courseInstructors")
            query.findObjectsInBackgroundWithBlock {
                (courses: [PFObject]?, error: NSError?) -> Void in
                completion(courses: courses as? [Course], error: error)
            }
        }
    }
    
    @objc(getCoursesForStudent:student:)
    class func courses(forStudent: Student, completion: ((courses: [Course]?, error:NSError?)->Void)) {
        if let query = Course.query() {
            query.whereKey("registeredStudents", equalTo: forStudent)
            query.includeKey("courseLocation")
            query.includeKey("classes")
            query.includeKey("registeredStudents")
            query.includeKey("courseInstructors")
            query.findObjectsInBackgroundWithBlock {
                (courses: [PFObject]?, error: NSError?) -> Void in
                completion(courses: courses as? [Course], error: error)
            }
        }
    }

    // get classes for a course (needed?)
    func classes(completion: ((classes:[Class]?, error:NSError?)->Void)) {
        // TODO: fix me
        for c in self.classes! {
            if !c.isDataAvailable() {
                c.fetchInBackgroundWithBlock({ (obj: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print("error fetching classes for course \(self.courseName): \(error)")
                    }
                })
            }
        }
    }
    
    func instructors(completion: ((instructors:[Instructor]?, error:NSError?)->Void)) {
        var available:Bool = true
        courseInstructors?.forEach{ available = available && $0.isDataAvailable()  }
        
        if available {
            // all data is available.
            completion(instructors: self.courseInstructors, error: nil)
            return
        }
        

        // ugly solution to refresh the instructors array of data
        var counter = 0
        for instructor in self.courseInstructors! {
            instructor.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                counter++
                if counter == self.courseInstructors!.count {
                    completion(instructors: self.courseInstructors, error: nil)
                }
            })
        }
        
    }
    
    // TODO: support refresh data
    func attendanceForCourse(student: Student, completion: ((classes:[Class]?, isRegistered: Bool)->Void)) {
        // check if student is actually registered
        if let students = self.objectForKey("registeredStudents") as? [Student] {
            if !students.contains(student) {
                // student not registered for class
                completion(classes: nil, isRegistered:false)
            }
        }
        
        // get the classes for this course
        var attendedClasses : [Class] = []
        if let classes = self.objectForKey("classes") as? [Class] {
            attendedClasses = classes.filter{ $0.didStudentAttend(student) }
        }
        completion(classes: attendedClasses, isRegistered:true)
    }
    
    func refreshAttendanceForCourse(student: Student, completion: ((classes:[Class]?, error: NSError?)->Void)) {
        if let query = Class.query() {
            query.includeKey("attendance")
            query.whereKey("parentCourse", equalTo: self)
            query.findObjectsInBackgroundWithBlock({ (objs: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let classes = objs as? [Class] {
                        completion(classes: classes, error:nil)
                    }
                }else {
                    print("error refreshing attendance! \(error)")
                    completion(classes:nil, error:error)
                }
            })
        }
    }
    
    func getImage(completion: ((image:UIImage?, error:NSError?)-> Void)) {
        // check to see if image already exists
        guard courseImage == nil else {
            return completion(image:courseImage, error:nil)
        }
        
        if let imageFile = courseImageFile {
            imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.courseImage = UIImage(data:imageData)
                        completion(image:self.courseImage, error:nil)
                    }
                }else{
                    completion(image:nil, error:error)
                }
            }
        }
    }
    
    
    // MARK: for data loading purposes
    
    class func createCourse(name:String, id:String, time:String, day:String, desc:String, location: Location, instructors: [Instructor], image:UIImage) -> Course {
        let course = Course()
        course.courseName = name
        course.courseId = id
        course.courseTime = time
        course.courseDay = day
        course.courseDescription = desc
        course.courseInstructors = instructors
        course.registeredStudents = []
        course.classes = []
        course.courseLocation = location

        course.courseImage = image
        
        let imageData = UIImagePNGRepresentation(image)
        course.courseImageFile = PFFile(name:name+".png", data:imageData!)

        return course
    }
    
    func addClass(newClass:Class) {
        classes?.append(newClass)
    }
    
    func addClasses(newClasses:[Class]){
        classes?.appendContentsOf(newClasses)
    }
    
    func addStudent(student:Student) {
        registeredStudents?.append(student)
    }
    
    func addStudents(students:[Student]){
        registeredStudents?.appendContentsOf(students)
    }
}
