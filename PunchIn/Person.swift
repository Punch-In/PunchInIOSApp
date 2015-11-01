//
//  Person.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/30/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

enum PersonType : String {
    case Student = "Student"
    case Instructor = "Instructor"
}

protocol Person {
    func getImage(completion: ((image:UIImage?, error:NSError?)-> Void))
    func getType() -> PersonType
}