//
//  Question.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Question : PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Question"
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
    @NSManaged private(set) var askedBy: String!
    @NSManaged private(set) var questionText: String!
    @NSManaged private(set) var isAnswered: Bool
    @NSManaged private(set) var date: NSDate!
    @NSManaged private(set) weak var forClass: Class!
    
    override init() {
        super.init()
    }
    
    func markQuestionAnswered() {
        isAnswered = true
        self.saveEventually()
    }
    
    class func createQuestion(email:String, text:String, date: NSDate, inClass: Class) -> Question {
        let question = Question()
        question.askedBy = email
        question.questionText = text
        question.isAnswered = false
        question.date = date
        question.forClass = inClass
        question.saveEventually()
        
        return question
    }
}