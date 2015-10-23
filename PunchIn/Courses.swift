//
//  Courses.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/20/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class Courses: NSObject {

    var courseName:String?
    var classNumber:String?
    var classTimeAndDate:String?
    var courseAddress:String?
    var classStatus:Bool?
    var overAllAttendanceCount:String?
    var totalClassCount:String?
    var unansweredQuestionsCount:String?
    var studentArray:[Student]?

    init(courseName:String,className:String,classTimeAndDate:String,courseAddress:String,classStatus:Bool, overAllAttendance:String,totalClassCount:String,unansweredQuestionsCount:String,studentArray:[Student]){
        self.courseName = courseName
        self.classNumber =  className
        self.classTimeAndDate = classTimeAndDate
        self.courseAddress = courseAddress
        self.classStatus = classStatus
        self.overAllAttendanceCount = overAllAttendance
        self.totalClassCount = totalClassCount
        self.studentArray = studentArray
    }
    
   class func getAllCourses() ->[Courses] {
    
        let course1 = Courses.init(courseName: "iOS", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray: Student.getStudentsForiOSClass())
    
        let course2 = Courses.init(courseName: "Android", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray:Student.getStudentsForiOSClass())
    
        let course3 = Courses.init(courseName: "Node.js", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray:Student.getStudentsForiOSClass())
    
        let course4 = Courses.init(courseName: "iOS SDK Engineering", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray:Student.getStudentsForiOSClass())
    
        let course5 = Courses.init(courseName: "Natural Language Processing", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray:Student.getStudentsForiOSClass())
    
        let course8 = Courses.init(courseName: "Android Gradle", className: "Class 101 #1", classTimeAndDate:"Sept 22nd, 2015. 8 am - 10 am" , courseAddress: "800 Townstead, San Fransisco. Room #122", classStatus: true, overAllAttendance: "34", totalClassCount: "40", unansweredQuestionsCount: "20",studentArray:Student.getStudentsForiOSClass())
    
    let courses:[Courses] = [course1, course2,course3,course4,course5,course8]
    return courses;
    }
    
    
}
