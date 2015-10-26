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
    
    class func initialize() {
        // Initialize Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId(appId, clientKey: clientKey)
        
        // hack to initialize Parse models....
        Course.initialize()
        Student.initialize()
        Instructor.initialize()
        Class.initialize()
        Location.initialize()
        Question.initialize()
    }
    
    func test() {
        var testObj = PFObject(className: "TestObject")
        testObj["foo"] = "bar"
        testObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("saved object")
            }else{
                print("error: \(error)")
            }
        }
    }
    
    class func logout() {
        if let user = PFUser.currentUser() {
            user.removeObjectForKey("type")
        }
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue()){
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.UserLoggedOut, object: nil)
        }
    }
    
    class func login(name: String, password: String, type: String) {
        PFUser.logInWithUsernameInBackground(name, password:password) {
            (newUser: PFUser?, error: NSError?) -> Void in
            if let newUser = newUser {
                print("good user!")
                newUser["type"] =  type
                // Do stuff after successful login.
                dispatch_async(dispatch_get_main_queue()){
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.UserLoggedIn, object: nil)
                }
            } else {
                // The login failed. Check error to see why.
                print("bad user!")
            }
        }
        
    }
}
