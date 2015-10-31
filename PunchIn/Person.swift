//
//  Person.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/30/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

protocol Person {
    func getImage(completion: ((image:UIImage?, error:NSError?)-> Void))
}