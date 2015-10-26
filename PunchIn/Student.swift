//
//  Student.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/21/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

class Student: PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Student"
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
    
    // MARK: Properties saved to Parse
    @NSManaged private(set) var studentName: String!
    @NSManaged private(set) var studentId: String!
    @NSManaged private(set) var studentEmail: String!
    @NSManaged private(set) var studentImageFile:PFFile?

    // MARK: Properties not saved
    private(set) var studentImage:UIImage?
    
    override init() {
        super.init()
    }

    init(studentName:String,studentImage:UIImage,id:String, email: String){
        super.init()
        
        self.studentName = studentName
        self.studentImage = studentImage
        self.studentId = id
        self.studentEmail = email
        
        let imageData = UIImagePNGRepresentation(studentImage)
        self.studentImageFile = PFFile(name:studentName+".png", data:imageData!)
    }
    
    func getStudentImage(completion: ((image:UIImage?, error:NSError?)-> Void)) {
        guard !(studentImageFile?.isDataAvailable)! || studentImage == nil else {
            return completion(image:studentImage, error:nil)
        }
        
        if let imageFile = studentImageFile {
            imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.studentImage = UIImage(data:imageData)
                        completion(image:self.studentImage, error:nil)
                    }
                }else{
                    completion(image:nil, error:error)
                }
            }
        }
    }
    
    class func student(forEmail: String, completion: ((student:Student?, error:NSError?)->Void)) {
        if let query = Student.query() {
            query.whereKey("studentEmail", equalTo: forEmail)
            query.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    completion(student:object as? Student, error:nil)
                }else{
                    completion(student:nil, error:error)
                }
            }
        }
    }
    
    
    class func createStudent(name: String, id:String, email:String, image:UIImage?) -> Student {
        let student = Student()
        student.studentName = name
        student.studentEmail = email
        student.studentId = id
        student.studentImage = image
        
        let imageData = UIImagePNGRepresentation(image!)
        student.studentImageFile = PFFile(name:name+".png", data:imageData!)

        return student
    }

}
