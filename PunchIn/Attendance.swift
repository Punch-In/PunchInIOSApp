//
//  Attendance.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class Attendance: NSObject {

    var className:String?
    var classDate:String?
    var classPresentOrAbsent:String?
    
    init(class_name:String,class_date:String,classPresentORAbsent:String){
        className = class_name
        classDate = class_date
        classPresentOrAbsent = classPresentORAbsent
    }
    
    class func getAllAttedance()->[Attendance]{
        let attendance1 = Attendance.init(class_name: "Class 1", class_date: "8/8/2015", classPresentORAbsent: "Present");
        let attendance2 = Attendance.init(class_name: "Class 2", class_date: "8/16/2015", classPresentORAbsent: "Present");
        let attendance3 = Attendance.init(class_name: "Class 3", class_date: "8/24/2015", classPresentORAbsent: "Present");
        let attendance4 = Attendance.init(class_name: "Class 4", class_date: "9/2/2015", classPresentORAbsent: "Present");
        let attendance5 = Attendance.init(class_name: "Class 5", class_date: "9/10/2015", classPresentORAbsent: "Present");
        let attendance6 = Attendance.init(class_name: "Class 6", class_date: "9/18/2015", classPresentORAbsent: "Present");
        let attendance7 = Attendance.init(class_name: "Class 7", class_date: "9/24/2015", classPresentORAbsent: "Present");
        let attendance8 = Attendance.init(class_name: "Class 8", class_date: "9/30/2015", classPresentORAbsent: "Present");
        let attendance9 = Attendance.init(class_name: "Class 9", class_date: "10/2/2015", classPresentORAbsent: "Present");
        let attendance10 = Attendance.init(class_name: "Class 10", class_date: "10/10/2015", classPresentORAbsent: "Present");
        let attedances:[Attendance] = [attendance1,attendance2,attendance3,attendance4,attendance5,attendance6,attendance7,attendance8,attendance9,attendance10];
        return attedances
    }
    
    
}
