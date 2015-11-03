//
//  Instructor.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Instructor: PFObject, PFSubclassing, Person {
    
    // MARK: Parse subclassing
    private static let className = "Instructor"
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
    
    // MARK: Properties saved to parse
    @NSManaged private(set) var instructorName: String!
    @NSManaged private(set) var instructorEmail: String!
    @NSManaged private(set) var instructorId: String!
    @NSManaged private(set) var instructorImageFile:PFFile?

    // MARK: Properties not saved
    private(set) var instructorImage:UIImage?
    
    override init() {
        super.init()
    }
    
    init(name: String, email: String, id: String, image:UIImage) {
        super.init()

        instructorName = name
        instructorEmail = email
        instructorId = id
        
        let imageData = UIImagePNGRepresentation(image)
        self.instructorImageFile = PFFile(name:instructorName+".png", data:imageData!)
    }
    
    // MARK: Person protocol
    func getImage(completion: ((image:UIImage?, error:NSError?)-> Void)) {
        guard instructorImage == nil else {
            return completion(image:instructorImage, error:nil)
        }
        
        if let imageFile = instructorImageFile {
            imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.instructorImage = UIImage(data:imageData)
                        completion(image:self.instructorImage, error:nil)
                    }
                }else{
                    completion(image:nil, error:error)
                }
            }
        }
    }

    func getType() -> PersonType {
        return PersonType.Instructor
    }
    
    func getName() -> String {
        return self.instructorName
    }

    
    // get instructor from email address
    class func instructor(forEmail: String, completion: ((instructor:Instructor?, error:NSError?)->Void)) {
        if let query = Instructor.query() {
            query.whereKey("instructorEmail", equalTo: forEmail)
            query.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    completion(instructor:object as? Instructor, error:nil)
                }else{
                    completion(instructor:nil, error:error)
                }
            }
        }
    }
    
    // MARK: Data Injection functions
    
    class func create(name:String, email:String, id:String, image:UIImage?) -> Instructor {
        let instructor = Instructor()
        instructor.instructorName = name
        instructor.instructorEmail = email
        instructor.instructorId = id
        
        instructor.instructorImage = image
        
        let imageData = UIImagePNGRepresentation(image!)
        instructor.instructorImageFile = PFFile(name:name+".png", data:imageData!)

        
        return instructor
    }

}