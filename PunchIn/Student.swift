//
//  Student.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/21/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class Student: NSObject {
    
    var studentName:String?
    var studentImage:UIImage?
    var attendanceOfStudent:String?
    var attendances:[Attendance]?
    
    init(studentName:String,studentImage:UIImage,attendanceOfStudent:String?,attendance:[Attendance]){
        self.studentName = studentName
        self.studentImage = studentImage
        self.attendanceOfStudent = attendanceOfStudent
        self.attendances = attendance
    }
    
    /*iOS Class*/
    class func getStudentsForiOSClass()->[Student]{
        let student1 = Student.init(studentName: "Neha Agrawal", studentImage: UIImage(named: "student1")!, attendanceOfStudent: "80",attendance: Attendance.getAllAttedance())
        let student2 = Student.init(studentName: "Ketty Perry", studentImage: UIImage(named: "student2")!, attendanceOfStudent: "80",attendance:Attendance.getAllAttedance())
        let student3 = Student.init(studentName: "Vaidehi Murarka", studentImage: UIImage(named: "student3")!, attendanceOfStudent: "80",attendance:Attendance.getAllAttedance())
        let student4 = Student.init(studentName: "Shalini Khare", studentImage: UIImage(named: "student4")!, attendanceOfStudent: "80",attendance:Attendance.getAllAttedance())
        let student5 = Student.init(studentName: "Saurabh Gupta", studentImage: UIImage(named: "student5")!, attendanceOfStudent: "80",attendance:Attendance.getAllAttedance())
        let student6 = Student.init(studentName: "Sumit Samant", studentImage: UIImage(named: "student6")!, attendanceOfStudent: "80",attendance:Attendance.getAllAttedance())
        let students:[Student] = [student1,student2,student3,student4,student5,student6]
        return students
    }
}
