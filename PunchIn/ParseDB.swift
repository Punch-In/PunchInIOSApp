//
//  ParseDB.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class ParseDB {
    private static let appId = "gaczrw01jIML4LYeOVRYVAbqo7t9hDrcszLMYf8l"
    private static let clientKey = "jo8XmhAefUTy1KmisFveehNCbuJS0MSHQTXPg76Y"
    
    static let BadLoginNotificationName = "BadLoginNotification"
    static let UserLoggedInNotificatioName = "UserLoggedInNotification"
    static let UserLoggedOutNotificationName = "UserLoggedOutNotification"
    static let BadTypeNotificationName = "BadTypeNotification"

    
    static let errorDomain = "ParseDB"
    static let errorCodeBadType = 1234
    
    class func initialize() {
        // Initialize Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId(appId, clientKey: clientKey)
        
        // hack to initialize Parse models....
        Location.initialize()
        Question.initialize()
        Student.initialize()
        Instructor.initialize()
        Class.initialize()
        Course.initialize()
    }
    
    class func logout() {
        currentPerson = nil
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue()){
            NSNotificationCenter.defaultCenter().postNotificationName(ParseDB.UserLoggedOutNotificationName, object: nil)
        }
    }
    
    class func login(name: String, password: String, type: String) {
        PFUser.logInWithUsernameInBackground(name, password:password) {
            (newUser: PFUser?, error: NSError?) -> Void in
            // error during login
            if error != nil {
                // The login failed. Check error to see why.
                print("bad user! \(error)")
                dispatch_async(dispatch_get_main_queue()){
                    NSNotificationCenter.defaultCenter().postNotificationName(ParseDB.BadLoginNotificationName, object:nil)
                }
                return
            }
            
            // verify the user
            if let newUser = newUser {
                if let userType = newUser.objectForKey("type") as? String {
                    if userType == type {
                        // registered type matches login type
                        postLogin()
                    }else{
                        // registered type does not match login type for user
                        print("registered type \(userType) for user does not match login type \(type)")
                        PFUser.logOut()
                        dispatch_async(dispatch_get_main_queue()) {
                            NSNotificationCenter.defaultCenter().postNotificationName(ParseDB.BadTypeNotificationName, object: nil)
                        }
                    }
                }else{
                    // type information not found... so just add it based on the login type
                    print("user \(name) did not have a registered type. Adding type as \(type)")
                    newUser["type"] =  type
                    newUser.saveEventually()
                    postLogin()
                }
            }
        }
    }
    
    private class func postLogin(){
        ParseDB.person { (person, error) -> Void in
            if error != nil {
                print("ParseDB error getting person! \(error)")
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName(ParseDB.UserLoggedInNotificatioName, object: nil)
                }
            }
        }
    }
    
    static var isStudent:Bool  {
        get{
            return PFUser.currentUser()?.objectForKey("type") as? String == LoginViewController.userTypes[0]
        }
    }
    
    static private(set) var currentPerson: Person?
    
    class func initializeCurrentPerson(handler: ((error:NSError?)->Void)) {
        guard currentPerson == nil else {
            return handler(error:nil)
        }
        
        ParseDB.person { (person, error) -> Void in
            if error != nil {
                print("ParseDB error getting person! \(error)")
                handler(error:error)
            }else{
                handler(error:nil)
            }
        }
    }
    
    private class func person(completion:((person:Person?,error:NSError?)->Void)) {
        guard currentPerson == nil else {
            return completion(person:currentPerson, error:nil)
        }
        
        if isStudent {
            student({ (student, error) -> Void in
                currentPerson = student
                completion(person:currentPerson, error:error)
            })
        }else{
            instructor({ (instructor, error) -> Void in
                currentPerson = instructor
                completion(person:currentPerson, error:error)
            })
        }
    }
    
    class func instructor(completion:((instructor:Instructor?,error:NSError?)->Void)) {
        guard !isStudent else {
            print("not an instructor")
            return completion(instructor:nil, error:NSError(domain: ParseDB.errorDomain, code: ParseDB.errorCodeBadType, userInfo:nil))
        }

        Instructor.instructor((PFUser.currentUser()?.email!)!, completion: { (instructor, error) -> Void in
            if error == nil {
                completion(instructor:instructor, error:nil)
            }else{
                completion(instructor:nil, error:error)
            }
        })
    }
    
    class func student(completion:((student:Student?,error:NSError?)->Void)) {
        guard isStudent else {
            print("not a student")
            return completion(student:nil, error:NSError(domain: ParseDB.errorDomain, code: ParseDB.errorCodeBadType, userInfo:nil))
        }
        
        Student.student((PFUser.currentUser()?.email!)!, completion: { (student, error) -> Void in
            if error == nil {
                completion(student: student, error: nil)
            }else{
                completion(student: nil, error:error)
            }
        })
    }
    
    // MARK: test
    func test() {
        let testObj = PFObject(className: "TestObject")
        testObj["foo"] = "bar"
        testObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("saved object")
            }else{
                print("error: \(error)")
            }
        }
    }

}
