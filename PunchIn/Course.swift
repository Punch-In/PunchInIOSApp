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
    @NSManaged private(set) var courseTime: String! // TODO: fix me
    @NSManaged private(set) var courseDay: String! // TODO: fix me
    @NSManaged private(set) var courseDurationMin: Int // in minutes
    @NSManaged private(set) var courseDescription: String!
    @NSManaged private(set) var courseInstructors: [Instructor]?
    @NSManaged private(set) var courseTAs: [Instructor]?
    @NSManaged private(set) var registeredStudents: [Student]?
    @NSManaged private(set) var classes: [Class]?
    @NSManaged private(set) var courseLocation: Location! // TODO: fix me
    
    override init() {
        super.init()
    }
        
    class func allCourses(completion: ((courses: [Course]?, error:NSError?)->Void)){
        if let query = Course.query() {
            query.findObjectsInBackgroundWithBlock {
                (courses: [PFObject]?, error: NSError?) -> Void in
                completion(courses: courses as? [Course], error: error)
            }
        }
    }
    
    class func courses(handler: ((courses: [Course]?, error:NSError?)->Void)){
        if ParseDB.isStudent {
            Student.student((PFUser.currentUser()?.email!)!, completion: { (student, error) -> Void in
                if error == nil {
                    Course.courses(student!, completion: handler)
                }else{
                    handler(courses: nil, error: error)
                }
            })
        }else {
            Instructor.instructor((PFUser.currentUser()?.email!)!, completion: { (instructor, error) -> Void in
                if error == nil {
                    Course.courses(instructor!, completion: handler)
                }else{
                    handler(courses: nil, error: error)
                }
            })
        }
    }
    
    @objc(getCoursesForInstructor:instructor:)
    class func courses(forInstructor: Instructor, completion: ((courses: [Course]?, error:NSError?)->Void)) {
        if let query = Course.query() {
            query.whereKey("courseInstructors", equalTo: forInstructor)
            query.includeKey("courseLocation")
            query.includeKey("classes")
            query.includeKey("registeredStudents")
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
    
    
    // MARK: for data loading purposes
    
    class func createCourse(name:String, id:String, time:String, day:String, desc:String, location: Location, instructors: [Instructor]) -> Course {
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
