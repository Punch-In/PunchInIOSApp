//
//  DataInjector.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/25/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//


// sole purpose is to inject data into parse backend
import CoreLocation

class DataInjector {
    class func dateHelper(dateStr:String, format:String="yyyy-MM-d") -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
    
    class func doIt() {
        print("adding data to parse...")
        
        // students
        let homer = Student.createStudent("homer simpson", id: "homer12345", email: "homer@spru.edu", image: UIImage(named: "student1.png"))
        let marge = Student.createStudent("marge simpson", id: "marge12345", email: "marge@spru.edu", image: UIImage(named: "student2.png"))
        let bart = Student.createStudent("bart simpson", id: "bart12345", email: "bart@spru.edu", image: UIImage(named: "student3.png"))
        let lisa = Student.createStudent("lisa simpson", id: "lisa12345", email: "lisa@spru.edu", image: UIImage(named: "student4.png"))
        let maggie = Student.createStudent("maggie simpson", id: "maggie12345", email: "maggie@spru.edu", image: UIImage(named: "student5.png"))
        let milhouse = Student.createStudent("milhouse van houten", id: "milhouse12345", email: "milhouse@spru.edu", image: UIImage(named: "student6.png"))
        let ralph = Student.createStudent("ralph wiggum", id: "ralph12345", email: "ralph@spru.edu", image: UIImage(named: "student1.png"))
        let nelson = Student.createStudent("nelson muntz", id: "nelson12345", email: "nelson@spru.edu", image: UIImage(named: "student2.png"))

        // instructors
        let frink = Instructor.create("john frink", email: "frink@spru.edu", id: "frink12345", image: UIImage(named:"student1.png"))
        let apu = Instructor.create("apu nahasapeemapetilon", email: "apu@spru.edu", id: "apu12345", image:UIImage(named:"student2.png"))
        
        // classes
        let location1 = Location(address: "699 8th St, San Francisco, CA 94103", coordinates: CLLocation(latitude: 37.771073, longitude: -122.403945))
        let class1 = Class.createClass("class1", index: 0, desc: "this is class #1", date: dateHelper("2015-09-14"), location: location1)
        let class2 = Class.createClass("class2", index: 1, desc: "this is class #2", date: dateHelper("2015-09-16"), location: location1)
        let class3 = Class.createClass("class3", index: 2, desc: "this is class #3", date: dateHelper("2015-09-21"), location: location1)
        let class4 = Class.createClass("class4", index: 3, desc: "this is class #4", date: dateHelper("2015-09-23"), location: location1)
        let class5 = Class.createClass("class5", index: 4, desc: "this is class #5", date: dateHelper("2015-09-28"), location: location1)
        let class6 = Class.createClass("class6", index: 5, desc: "this is class #6", date: dateHelper("2015-09-30"), location: location1)
        let class7 = Class.createClass("class7", index: 6, desc: "this is class #7", date: dateHelper("2015-10-05"), location: location1)
        let class8 = Class.createClass("class8", index: 7, desc: "this is class #8", date: dateHelper("2015-10-07"), location: location1)
        let class9 = Class.createClass("class9", index: 8, desc: "this is class #9", date: dateHelper("2015-10-12"), location: location1)
        let class10 = Class.createClass("class10", index: 9, desc: "this is class #10", date: dateHelper("2015-10-14"), location: location1)
        let class11 = Class.createClass("class11", index: 10, desc: "this is class #11", date: dateHelper("2015-10-19"), location: location1)
        let class12 = Class.createClass("class12", index: 11, desc: "this is class #12", date: dateHelper("2015-10-21"), location: location1)
        
        // classes
        let location2 = Location(address: "Golden Gate Bridge", coordinates: CLLocation(latitude: 37.820183, longitude: -122.478223))
        var classes2: [Class] = []
        for i in 0..<10 {
            let newClass = Class.createClass("class\(i)", index:i, desc: "this is class #\(i)", date: dateHelper("2015-10-\(i+1)"), location: location2)
            classes2.append(newClass)
        }
        
        // course
        let course1 = Course.createCourse("iOS Bootcamp", id: "iOS1234", time: "7-9PM", day: "Monday,Wednesday", desc: "iOS Bootcamp for Senior Engineers", location: location1, instructors: [frink])
        let course2 = Course.createCourse("Golden Gate Bridge History", id: "gg1234", time: "1-3PM", day: "Monday,Tuesday,Wednesday,Thursday,Friday",
            desc: "History of the Golden Gate Bridge for Senior Engineers", location:location2, instructors: [apu])
        
        try! course1.save()
        try! course2.save()
        
        
        // setup relationships
        let classes1 = [class1,class2,class3,class4,class5,class6,class7,class8,class9,class10,class11,class12]
        for c in classes1 {
            c.addParentCourse(course1)
            try! c.save()
        }

        course1.addClasses(classes1)
        course1.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save course with classes \(course1.courseName)")
            }else{
                print("error! \(error)")
            }
        })
        
        for c in classes2 {
            c.addParentCourse(course2)
            try! c.save()
        }
        
        course2.addClasses(classes2)
        course2.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save course with classes \(course2.courseName)")
            }else{
                print("error! \(error)")
            }
        })

        
        let students1 = [homer,marge,bart,lisa,maggie]
        for s in students1 {
            try! s.save()
        }
        
        course1.addStudents(students1)
        course1.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save course with students \(course1.courseName)")
            }else{
                print("error! \(error)")
            }
        })

        let students2 = [bart, lisa, milhouse, ralph, nelson]
        for s in students2 {
            try! s.save()
        }
        
        course2.addStudents(students2)
        course2.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save course with students \(course2.courseName)")
            }else{
                print("error! \(error)")
            }
        })
        
        
        frink.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save instructor \(frink.instructorName)")
            }else{
                print("error! \(error)")
            }
        })
        apu.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if error == nil {
                print("save instructor \(apu.instructorName)")
            }else{
                print("error! \(error)")
            }
        })
        
        print("...done")
    }
}